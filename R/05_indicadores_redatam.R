# Indicadores por distrito de los censos 2007 y 2017, calculados desde las bases REDATAM.
#
# Devuelve conteos (numeradores y denominadores) por distrito con nombres de columna
# comunes a los tres censos. Los porcentajes se calculan en R/07_tabla_distrital.R.

source("R/utils_redatam.R")

# Variables y códigos de cada censo (ver docs/comparabilidad_variables.md)
definiciones <- list(
  "2007" = list(
    persona = "Poblacio", vivienda = "Vivienda", hogar = "Hogar",
    edad = "Poblacio.P03AANIO",
    rural = "Poblacio.PAREA = 2",
    lengua_indigena = "(Poblacio.P09IDIOMA >= 1) AND (Poblacio.P09IDIOMA <= 4)",
    analfabeta = "Poblacio.P10LEE = 2",
    superior = "(Poblacio.P11ANIVEL >= 5) AND (Poblacio.P11ANIVEL <= 8)",
    # P08AFILIA combina seguros: 1-4 incluyen SIS; 2, 3, 5 y 6 incluyen EsSalud
    sis = "(Poblacio.P08AFILIA >= 1) AND (Poblacio.P08AFILIA <= 4)",
    essalud = "(Poblacio.P08AFILIA = 2) OR (Poblacio.P08AFILIA = 3) OR (Poblacio.P08AFILIA = 5) OR (Poblacio.P08AFILIA = 6)",
    # Vivienda particular con ocupantes presentes
    viv_particular = "(Vivienda.V01TIPOVIV <= 8) AND (Vivienda.V02CONDIOC = 1)",
    agua_red = "(Vivienda.V04ABASAGU = 1) OR (Vivienda.V04ABASAGU = 2)",
    desague_red = "(Vivienda.V06SERVHIG = 1) OR (Vivienda.V06SERVHIG = 2)",
    electricidad_red = "Vivienda.V07ALUMBRA = 1",
    # H01BSERV combina servicios del hogar; estos códigos incluyen celular / internet
    celular = paste(sprintf("(Hogar.H01BSERV = %d)", c(3, 6, 9, 10, 12, 13, 15, 16)), collapse = " OR "),
    internet = paste(sprintf("(Hogar.H01BSERV = %d)", c(4, 7, 9, 11, 12, 14, 15, 16)), collapse = " OR ")
  ),
  "2017" = list(
    persona = "PERSONA", vivienda = "VIVIENDA", hogar = "HOGAR",
    edad = "PERSONA.C5P41",
    rural = "PERSONA.PAREA = 2",
    # 1-9 y 15-45: lenguas indígenas u originarias
    lengua_indigena = "((PERSONA.C5P11 >= 1) AND (PERSONA.C5P11 <= 9)) OR ((PERSONA.C5P11 >= 15) AND (PERSONA.C5P11 <= 45))",
    analfabeta = "PERSONA.C5P12 = 2",
    superior = "(PERSONA.C5P13NIV >= 6) AND (PERSONA.C5P13NIV <= 10)",
    sis = "PERSONA.C5P81 = 1",
    essalud = "PERSONA.C5P82 = 1",
    viv_particular = "(VIVIENDA.C2P1 <= 8) AND (VIVIENDA.C2P2 = 1)",
    agua_red = "(VIVIENDA.C2P6 = 1) OR (VIVIENDA.C2P6 = 2)",
    desague_red = "(VIVIENDA.C2P10 = 1) OR (VIVIENDA.C2P10 = 2)",
    electricidad_red = "VIVIENDA.C2P11 = 1",
    celular = "HOGAR.C3P210 = 1",
    internet = "HOGAR.C3P213 = 1"
  )
)

#' Arma el programa SPC que calcula todos los conteos por distrito.
programa_spc <- function(d) {
  p <- d$persona; v <- d$vivienda; h <- d$hogar; e <- d$edad
  indicadores <- list(
    # entidad, nombre, condición
    c(p, "pob_censada", "1 = 1"),
    c(p, "pob_0_14", sprintf("%s <= 14", e)),
    c(p, "pob_15_64", sprintf("(%s >= 15) AND (%s <= 64)", e, e)),
    c(p, "pob_65_mas", sprintf("%s >= 65", e)),
    c(p, "pob_rural", d$rural),
    c(p, "pob_3_mas", sprintf("%s >= 3", e)),
    c(p, "pob_lengua_indigena", sprintf("(%s >= 3) AND (%s)", e, d$lengua_indigena)),
    c(p, "pob_15_mas", sprintf("%s >= 15", e)),
    c(p, "pob_15_mas_analfabeta", sprintf("(%s >= 15) AND (%s)", e, d$analfabeta)),
    c(p, "pob_25_mas", sprintf("%s >= 25", e)),
    c(p, "pob_25_mas_superior", sprintf("(%s >= 25) AND (%s)", e, d$superior)),
    c(p, "pob_sis", d$sis),
    c(p, "pob_essalud", d$essalud),
    c(v, "viv_particulares", d$viv_particular),
    c(v, "viv_sin_agua_red", sprintf("(%s) AND NOT(%s)", d$viv_particular, d$agua_red)),
    c(v, "viv_sin_desague_red", sprintf("(%s) AND NOT(%s)", d$viv_particular, d$desague_red)),
    c(v, "viv_sin_electricidad_red", sprintf("(%s) AND NOT(%s)", d$viv_particular, d$electricidad_red)),
    # Los hogares se cuentan solo en viviendas particulares con ocupantes presentes
    c(h, "hogares", d$viv_particular),
    c(h, "hog_celular", sprintf("(%s) AND (%s)", d$viv_particular, d$celular)),
    c(h, "hog_internet", sprintf("(%s) AND (%s)", d$viv_particular, d$internet))
  )
  distrito <- if (p == "Poblacio") "Distrito" else "DISTRITO"
  lineas <- character()
  for (i in seq_along(indicadores)) {
    ent <- indicadores[[i]][1]; nom <- toupper(indicadores[[i]][2]); cond <- indicadores[[i]][3]
    lineas <- c(lineas,
      sprintf("DEFINE %s.I_%s AS %s TYPE INTEGER", ent, nom, cond),
      sprintf("DEFINE %s.N_%s AS SUM %s.I_%s TYPE INTEGER", distrito, nom, ent, nom))
  }
  columnas <- paste(sprintf("%s.N_%s", distrito, toupper(sapply(indicadores, `[`, 2))), collapse = ", ")
  c(lineas, sprintf("TABLE T1 AS AREALIST OF %s, %s", distrito, columnas))
}

#' Conteos por distrito para 2007 o 2017.
indicadores_redatam <- function(anio) {
  d <- definiciones[[as.character(anio)]]
  r <- consultar_censo(anio, paste(programa_spc(d), collapse = "\n"))
  names(r) <- sub("^n_(.*)_[0-9]+$", "\\1", names(r))
  names(r)[1] <- "ubigeo"
  r[-1] <- lapply(r[-1], as.numeric)
  r
}

#' Nombres de departamento, provincia y distrito (AREALIST de cada nivel).
nombres_redatam <- function(anio) {
  b <- bases_censo[[as.character(anio)]]
  if (anio == 2007) {
    niv <- c(departamento = "Departam", provincia = "Provinci", distrito = "Distrito")
    lab <- c(departamento = "NDPTO", provincia = "NPRO", distrito = "NDIS")
  } else {
    niv <- c(departamento = "DEPARTAM", provincia = "PROVINCI", distrito = "DISTRITO")
    lab <- c(departamento = "NCCDD", provincia = "NCCPP", distrito = "NCCDI")
  }
  t <- lapply(names(niv), function(n) {
    r <- consultar_censo(anio, sprintf("TABLE T1 AS AREALIST OF %s, %s.%s", niv[[n]], niv[[n]], lab[[n]]))
    # 2017: "Amazonas, Chachapoyas, distrito: Asunción"; 2007: "Dpto. Amazonas   Prov. ...   Dist. Asunción"
    nombre <- trimws(sub(".*(: |Dpto\\. |Prov\\. |Dist\\. )", "", r[[2]]))
    setNames(data.frame(r[[1]], nombre), c("codigo", n))
  })
  dist <- t[[3]]
  dist$departamento <- t[[1]]$departamento[match(substr(dist$codigo, 1, 2), t[[1]]$codigo)]
  dist$provincia <- t[[2]]$provincia[match(substr(dist$codigo, 1, 4), t[[2]]$codigo)]
  data.frame(ubigeo = dist$codigo, departamento = dist$departamento,
             provincia = dist$provincia, distrito = dist$distrito)
}
