# Indicadores por distrito del Censo 2025, leídos de los tabulados oficiales del INEI
# (data/raw/2025/tabulados, descargados con R/03_descargar_2025.R).
#
# Cada cuadro lista, por región: provincia > distrito > subfilas (grupos de edad, sexo,
# área, tipo de vivienda...). Para cada distrito se toman la fila del distrito y sus
# subfilas hasta la primera división por sexo o área, que corresponden al total del distrito.
# El ubigeo se asigna con data/reference/ubigeo_2025.csv (R/04_ubigeos_2025.R).

library(readxl)

dir_2025 <- file.path("data", "raw", "2025", "tabulados")

#' Lee un cuadro (n = número de CUADRO) y devuelve una lista de bloques, uno por distrito.
#' Cada bloque es un data.frame con la etiqueta (col 1) y los valores numéricos.
leer_bloques <- function(cod, archivo, n) {
  f <- file.path(dir_2025, cod, archivo)
  hoja <- excel_sheets(f)[n + 2]  # las dos primeras hojas son la nota y el anexo
  x <- suppressMessages(read_excel(f, sheet = hoja, col_names = FALSE, .name_repair = "minimal"))
  x <- as.data.frame(x)
  # Encabezados (filas 2 y 3 de la hoja) para ubicar columnas por nombre
  limpiar <- function(v) trimws(gsub("\\s+", " ", ifelse(is.na(v), "", as.character(v))))
  encabezado <- list(fila2 = limpiar(unlist(x[2, ])), fila3 = limpiar(unlist(x[3, ])))
  x <- x[!is.na(x[[1]]), ]
  etiqueta <- trimws(gsub("\\s+", " ", x[[1]]))
  valores <- suppressWarnings(sapply(x[-1], as.numeric))

  es_distrito <- grepl("^DISTRITO ", etiqueta)
  es_provincia <- grepl("^PROVINCIA ", etiqueta)
  inicio <- which(es_distrito)
  bloques <- vector("list", length(inicio))
  provincia_actual <- NA_character_
  for (k in seq_along(inicio)) {
    i <- inicio[k]
    previas <- which(es_provincia[seq_len(i)])
    provincia <- if (length(previas)) sub("^PROVINCIA ", "", etiqueta[max(previas)]) else NA
    fin <- if (k < length(inicio)) inicio[k + 1] - 1 else nrow(x)
    # cortar en la siguiente provincia, si la hay
    sig_prov <- which(es_provincia[i:fin])
    if (length(sig_prov)) fin <- i + sig_prov[1] - 2
    bloque <- data.frame(etiqueta = etiqueta[i:fin], valores[i:fin, , drop = FALSE])
    # quedarse con el total del distrito: hasta la primera división por sexo o área
    corte <- which(bloque$etiqueta %in% c("Hombre", "Mujer", "URBANA", "RURAL"))
    if (length(corte)) bloque <- bloque[seq_len(corte[1] - 1), ]
    bloques[[k]] <- list(provincia = provincia, distrito = sub("^DISTRITO ", "", etiqueta[i]),
                         datos = bloque, encabezado = encabezado)
  }
  bloques
}

# Edad inferior de una etiqueta de grupo ("De 15 a 19 años" -> 15; "Menores de 1 año" -> 0)
edad_inferior <- function(e) {
  ifelse(grepl("^Menores", e), 0, suppressWarnings(as.numeric(sub("^De ([0-9]+) .*", "\\1", e))))
}
es_grupo <- function(e) grepl("^(Menores de 1 año|De [0-9]+ (a [0-9]+|y más) años)$", e)

#' Columna cuyo encabezado (fila 3 de la hoja) coincide con el patrón. Error si no existe.
columna <- function(b, patron, fila = "fila3") {
  j <- grep(patron, b$encabezado[[fila]], ignore.case = TRUE)
  if (length(j) == 0) stop("No se encontró la columna '", patron, "' en el distrito ", b$distrito)
  j
}

#' Fila con etiqueta dada dentro del bloque (la primera)
fila <- function(b, etiqueta) b[which(b$etiqueta == etiqueta)[1], ]

#' Indicadores de una región
indicadores_region <- function(cod) {
  # Población censada, urbana/rural y grupos de edad (Indicadores demográficos, C2)
  edades <- leer_bloques(cod, "poblacion/Indicadores_demograficos.xlsx", 2)
  base <- do.call(rbind, lapply(edades, function(b) {
    d <- b$datos
    g <- d[es_grupo(d$etiqueta), ]
    ei <- edad_inferior(g$etiqueta)
    # El total rural está en la columna anterior a la etiqueta "Rural"; si no hay, es 0
    j_rural <- which(b$encabezado$fila2 == "Rural")
    rural <- if (length(j_rural)) d[1, j_rural - 1] else 0
    data.frame(provincia = b$provincia, distrito = b$distrito,
               pob_censada = d[1, 2], pob_rural = rural,
               pob_0_14 = sum(g[ei <= 14, 2]),
               pob_15_64 = sum(g[ei >= 15 & ei <= 64, 2]),
               pob_65_mas = sum(g[ei >= 65, 2]))
  }))

  # Lengua aprendida en la niñez, 3+ (Etnicidad, C11). Respuesta múltiple: se suman
  # las lenguas indígenas (puede sobrestimar a quienes aprendieron dos lenguas indígenas).
  indigenas <- c("Quechua", "Aimara", "Ashaninka", "Awajún / Aguaruna", "Shipibo - Konibo",
                 "Otros idiomas o lenguas indígenas u originarias 1/")
  lengua <- t(sapply(leer_bloques(cod, "poblacion/Etnicidad.xlsx", 11), function(b) {
    d <- b$datos
    c(pob_3_mas = d[1, 2], pob_lengua_indigena = sum(d[d$etiqueta %in% indigenas, 2]))
  }))

  # Alfabetismo, 15+ (Educación, C4): columnas total, sabe, no sabe
  alfa <- t(sapply(leer_bloques(cod, "poblacion/Educacion.xlsx", 4), function(b) {
    g <- b$datos[es_grupo(b$datos$etiqueta), ]
    m <- edad_inferior(g$etiqueta) >= 15
    c(pob_15_mas = sum(g[m, 2]), pob_15_mas_analfabeta = sum(g[m, columna(b, "^No sabe leer")]))
  }))

  # Nivel educativo, 25+ (Educación, C1): superior no universitaria, universitaria y posgrado
  educ <- t(sapply(leer_bloques(cod, "poblacion/Educacion.xlsx", 1), function(b) {
    g <- b$datos[es_grupo(b$datos$etiqueta), ]
    m <- edad_inferior(g$etiqueta) >= 25
    sup <- columna(b, "^(Sup\\.|Maestr)")
    stopifnot(length(sup) == 5)
    c(pob_25_mas = sum(g[m, 2]), pob_25_mas_superior = sum(as.matrix(g[m, sup])))
  }))

  # Seguro de salud (Estado civil, identidad y seguro de salud, C6): total, SIS, EsSalud
  seguro <- t(sapply(leer_bloques(cod, "poblacion/Estado_civil_identidad_y_seguro_de_salud.xlsx", 6),
                     function(b) c(pob_sis = b$datos[1, columna(b, "\\(SIS\\)")],
                                   pob_essalud = b$datos[1, columna(b, "^EsSalud$")])))

  # Servicios básicos (viviendas particulares con ocupantes presentes)
  viv <- function(n, patron, esperadas) {
    lapply(leer_bloques(cod, "vivienda/Servicios_basicos_de_la_vivienda.xlsx", n), function(b) {
      f <- fila(b$datos, "Viviendas particulares")
      cols <- columna(b, patron)
      stopifnot(length(cols) == esperadas)
      c(total = f[[2]], red = sum(unlist(f[cols])))
    })
  }
  agua <- viv(1, "^Red pública$", 1)
  desague <- viv(9, "^Red pública de desagüe", 2)  # dentro de la vivienda + dentro del lote
  luz <- viv(10, "^Red pública$", 1)
  vivienda <- data.frame(
    viv_particulares = sapply(agua, `[[`, "total"),
    viv_sin_agua_red = sapply(agua, function(v) v[["total"]] - v[["red"]]),
    viv_sin_desague_red = sapply(desague, function(v) v[["total"]] - v[["red"]]),
    viv_sin_electricidad_red = sapply(luz, function(v) v[["total"]] - v[["red"]])
  )

  # Hogares con celular e internet fijo (Equipamiento del hogar, C2)
  hogar <- t(sapply(leer_bloques(cod, "hogar/Equipamiento_del_hogar.xlsx", 2), function(b) {
    f <- fila(b$datos, "Hogares")
    c(hogares = f[[2]], hog_celular = f[[columna(b, "^Teléfono celular$")]],
      hog_internet = f[[columna(b, "^Conexión a internet fijo$")]])
  }))

  cbind(cod_region = cod, base, lengua, alfa, educ, seguro, vivienda, hogar)
}

# Normaliza nombres para comparar (sin tildes, mayúsculas, solo letras y números)
normalizar_nombre <- function(x) {
  x <- toupper(iconv(x, "UTF-8", "ASCII//TRANSLIT"))
  gsub("[^A-Z0-9]", "", x)
}

#' Indicadores 2025 de todos los distritos, con ubigeo.
indicadores_2025 <- function() {
  regiones <- read.csv(file.path(dir_2025, "regiones.csv"), colClasses = "character")
  ubigeos <- read.csv("data/reference/ubigeo_2025.csv", colClasses = "character", encoding = "UTF-8")
  datos <- do.call(rbind, lapply(regiones$codRegion, function(cod) {
    r <- indicadores_region(cod)
    u <- ubigeos[ubigeos$cod_region == cod, ]
    u <- u[order(as.integer(u$orden)), ]
    if (nrow(r) != nrow(u)) stop("Región ", cod, ": ", nrow(r), " distritos en Excel y ", nrow(u), " en la API")
    # Los distritos aparecen en el mismo orden en los Excel y en la API; se verifica por nombre
    dif <- normalizar_nombre(r$distrito) != normalizar_nombre(u$distrito)
    if (any(dif)) {
      warning("Región ", cod, ": nombres distintos en ", sum(dif), " distritos: ",
              paste(r$distrito[dif], "/", u$distrito[dif], collapse = "; "))
    }
    # Lima Metropolitana (27) y Región Lima (26) forman el departamento de Lima
    depto <- if (cod %in% c("26", "27")) "Lima" else u$region
    cbind(ubigeo = u$ubigeo, departamento = depto,
          provincia = u$provincia, distrito = u$distrito, r[setdiff(names(r), c("cod_region", "provincia", "distrito"))])
  }))
  datos[order(datos$ubigeo), ]
}
