# Descarga las bases REDATAM completas de los censos 2007 y 2017
# publicadas por CELADE/CEPAL (validadas por el INEI) y las descomprime.
# Ejecutar desde la raíz del proyecto: Rscript R/01_descargar_datos.R

options(timeout = 3600)

censos <- c("2007", "2017")
url_base <- "https://prod.redatam.org/cdr/descargas/censos/poblacion/CP%sPER.zip"

# Diccionario de cada base: si ya existe, la base está descargada
diccionarios <- c("2007" = "data/raw/2007/CP2007PER/BasePub/CPV2007PER_PUB.dicx",
                  "2017" = "data/raw/2017/BaseD/BaseR/CPVPER2017D.dicX")

for (anio in censos) {
  if (file.exists(diccionarios[[anio]])) {
    message("Censo ", anio, " ya descargado.")
    next
  }
  destino <- file.path("data", "raw", anio)
  zip <- file.path(destino, sprintf("CP%sPER.zip", anio))
  dir.create(destino, recursive = TRUE, showWarnings = FALSE)

  if (!file.exists(zip)) {
    message("Descargando censo ", anio, "...")
    download.file(sprintf(url_base, anio), zip, mode = "wb")
  }
  message("Descomprimiendo censo ", anio, "...")
  unzip(zip, exdir = destino)
  unlink(zip)  # el ZIP ya no hace falta
}

# El video promocional de 2007 no se necesita (~80 MB)
unlink(file.path("data", "raw", "2007", "CP2007PER", "Docs", "CPV2007.mpg"))

# Enlaces en minúsculas que necesita el motor REDATAM en Linux
source("R/utils_redatam.R")
for (b in bases_censo) preparar_base(b$dir)
