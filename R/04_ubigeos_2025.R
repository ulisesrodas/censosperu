# Lista de distritos del Censo 2025 con su ubigeo, desde la API de geografía del sitio
# censos2025.inei.gob.pe. El campo idGeografia de un distrito es "9" + ubigeo (6 dígitos).
# Ejecutar desde la raíz del proyecto: Rscript R/04_ubigeos_2025.R

library(jsonlite)

api <- "https://censos2025.inei.gob.pe/api/v1/geografia"
obtener <- function(ruta) fromJSON(paste0(api, ruta))$data

regiones <- obtener("/departamentos")
filas <- list()
for (cod in regiones$codRegion) {
  provs <- obtener(paste0("/provincias?codRegion=", cod))
  for (j in seq_len(nrow(provs))) {
    dists <- obtener(sprintf("/distritos?codRegion=%s&ccpp=%s", cod, provs$ccpp[j]))
    filas[[length(filas) + 1]] <- data.frame(
      cod_region = cod,
      region = regiones$nombre[regiones$codRegion == cod],
      provincia = provs$nombre[j],
      distrito = dists$nombre,
      orden = dists$orden,
      ubigeo = substr(dists$idGeografia, 2, 7)
    )
  }
}
ubigeos <- do.call(rbind, filas)
dir.create("data/reference", showWarnings = FALSE)
write.csv(ubigeos, "data/reference/ubigeo_2025.csv", row.names = FALSE, fileEncoding = "UTF-8")
message(nrow(ubigeos), " distritos")
