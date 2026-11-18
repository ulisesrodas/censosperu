# Funciones para consultar las bases REDATAM de los censos 2007 y 2017 con redatamx.
#
# El motor de REDATAM en Linux busca los archivos de datos (.rbf, .ptr) con el
# nombre en minúsculas y relativo a la carpeta de trabajo. Por eso:
#   1. preparar_base() crea enlaces en minúsculas a cada archivo (una sola vez).
#   2. consultar_censo() cambia temporalmente a la carpeta de la base.

library(redatamx)

bases_censo <- list(
  "2007" = list(dir = "data/raw/2007/CP2007PER/BasePub", dic = "CPV2007PER_PUB.dicx",
                persona = "Poblacio", vivienda = "Vivienda", hogar = "Hogar",
                distrito = "Distrito"),
  "2017" = list(dir = "data/raw/2017/BaseD/BaseR", dic = "CPVPER2017D.dicX",
                persona = "PERSONA", vivienda = "VIVIENDA", hogar = "HOGAR",
                distrito = "DISTRITO")
)

#' Crea enlaces simbólicos en minúsculas para los archivos de una base REDATAM.
preparar_base <- function(dir) {
  archivos <- list.files(dir)
  for (f in archivos) {
    minus <- tolower(f)
    destino <- file.path(dir, minus)
    if (minus != f && !file.exists(destino)) file.symlink(f, destino)
  }
  invisible(dir)
}

#' Ejecuta una consulta SPC sobre la base de un censo ("2007" o "2017").
#' Devuelve un data.frame (o lista de data.frames) con el resultado.
consultar_censo <- function(anio, spc) {
  base <- bases_censo[[as.character(anio)]]
  stopifnot(!is.null(base))
  dir_base <- normalizePath(base$dir)
  preparar_base(dir_base)

  dir_original <- setwd(dir_base)
  on.exit(setwd(dir_original), add = TRUE)

  db <- redatam_open(base$dic)
  on.exit(redatam_close(db), add = TRUE, after = FALSE)
  redatam_query(db, spc)
}

#' Lista las variables de una entidad (p. ej. "persona", "vivienda", "hogar").
variables_censo <- function(anio, entidad = c("persona", "vivienda", "hogar")) {
  entidad <- match.arg(entidad)
  base <- bases_censo[[as.character(anio)]]
  dir_original <- setwd(normalizePath(base$dir))
  on.exit(setwd(dir_original), add = TRUE)
  db <- redatam_open(base$dic)
  on.exit(redatam_close(db), add = TRUE, after = FALSE)
  redatam_variables(db, base[[entidad]])
}
