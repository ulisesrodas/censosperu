# Descarga los tabulados oficiales del Censo 2025 (INEI) a nivel distrital.
#
# Fuente: https://censos2025.inei.gob.pe/descarga-de-datos
# El sitio publica, por cada departamento, archivos Excel por tema (población,
# vivienda y hogar) con cuadros a nivel de provincia y distrito.
#
# Ejecutar desde la raíz del proyecto: Rscript R/03_descargar_2025.R

library(jsonlite)

options(timeout = 600)

api <- "https://censos2025.inei.gob.pe/api/v1"
archivos <- "https://proyectos.inei.gob.pe/dir-segmentacion-ci/postcensal/prod/adjuntos/censos-2025/descarga_datos/tabulados"
destino <- file.path("data", "raw", "2025", "tabulados")

# Catálogo de temas: id del tema en el sitio -> carpeta del archivo
temas <- c("948" = "poblacion", "949" = "vivienda", "950" = "hogar")

# Departamentos (Lima se divide en Lima Metropolitana = 27 y Región Lima = 26)
regiones <- fromJSON(paste0(api, "/geografia/departamentos"))$data
regiones <- regiones[, c("codRegion", "nombre")]

catalogo <- do.call(rbind, lapply(names(temas), function(id) {
  docs <- fromJSON(paste0(api, "/catalogo/datos-documentos/", id))$data
  data.frame(tipo = temas[[id]], ruta = docs$ruta, tema = docs$nombDato)
}))

dir.create(destino, recursive = TRUE, showWarnings = FALSE)
write.csv(regiones, file.path(destino, "regiones.csv"), row.names = FALSE)
write.csv(catalogo, file.path(destino, "catalogo.csv"), row.names = FALSE)

for (cod in regiones$codRegion) {
  for (i in seq_len(nrow(catalogo))) {
    tipo <- catalogo$tipo[i]
    ruta <- catalogo$ruta[i]
    archivo <- file.path(destino, cod, tipo, paste0(ruta, ".xlsx"))
    if (file.exists(archivo)) next
    dir.create(dirname(archivo), recursive = TRUE, showWarnings = FALSE)
    url <- sprintf("%s/%s/%s/%s.xlsx", archivos, cod, tipo, ruta)
    ok <- tryCatch({ download.file(url, archivo, mode = "wb", quiet = TRUE); TRUE },
                   error = function(e) { unlink(archivo); FALSE })
    message(sprintf("%s %s/%s %s", cod, tipo, ruta, if (ok) "OK" else "FALLÓ"))
  }
}
