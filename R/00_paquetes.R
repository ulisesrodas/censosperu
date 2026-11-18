# Instala los paquetes de R que usa el proyecto.
# Ejecutar una vez: Rscript R/00_paquetes.R

paquetes <- c(
  "dplyr", "tidyr", "readr", "readxl", "stringr", "purrr",  # manejo de datos
  "haven",      # leer SPSS / Stata
  "ggplot2",    # gráficos
  "sf",         # mapas
  "redatamx",   # leer bases REDATAM (CELADE/CEPAL)
  "jsonlite"    # leer la API del sitio del Censo 2025
)

faltantes <- setdiff(paquetes, rownames(installed.packages()))
if (length(faltantes) > 0) {
  install.packages(faltantes, repos = "https://cloud.r-project.org",
                   Ncpus = parallel::detectCores())
}
