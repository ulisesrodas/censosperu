# Genera un archivo por censo (2007, 2017, 2025) con los indicadores comparables por
# distrito. Llave: ubigeo (6 dígitos, texto). Mismas columnas en los tres archivos.
#
# Salida: outputs/tables/censo_<año>_distrital.csv y .xlsx
# Ejecutar desde la raíz del proyecto: Rscript R/07_tabla_distrital.R

source("R/05_indicadores_redatam.R")
source("R/06_indicadores_2025.R")
library(writexl)

pct <- function(num, den) ifelse(den > 0, round(100 * num / den, 2), NA_real_)

completar <- function(d, anio) {
  d$anio <- anio
  d$pct_0_14 <- pct(d$pob_0_14, d$pob_censada)
  d$pct_15_64 <- pct(d$pob_15_64, d$pob_censada)
  d$pct_65_mas <- pct(d$pob_65_mas, d$pob_censada)
  d$pct_rural <- pct(d$pob_rural, d$pob_censada)
  d$pct_lengua_indigena <- pct(d$pob_lengua_indigena, d$pob_3_mas)
  d$pct_analfabetismo <- pct(d$pob_15_mas_analfabeta, d$pob_15_mas)
  d$pct_superior <- pct(d$pob_25_mas_superior, d$pob_25_mas)
  d$pct_sis <- pct(d$pob_sis, d$pob_censada)
  d$pct_essalud <- pct(d$pob_essalud, d$pob_censada)
  d$pct_viv_sin_agua_red <- pct(d$viv_sin_agua_red, d$viv_particulares)
  d$pct_viv_sin_desague_red <- pct(d$viv_sin_desague_red, d$viv_particulares)
  d$pct_viv_sin_electricidad_red <- pct(d$viv_sin_electricidad_red, d$viv_particulares)
  d$pct_hog_celular <- pct(d$hog_celular, d$hogares)
  d$pct_hog_internet <- pct(d$hog_internet, d$hogares)

  columnas <- c(
    "ubigeo", "anio", "departamento", "provincia", "distrito",
    # Demografía
    "pob_censada", "pob_0_14", "pob_15_64", "pob_65_mas", "pct_0_14", "pct_15_64", "pct_65_mas",
    # Territorio
    "pob_rural", "pct_rural",
    # Lengua
    "pob_3_mas", "pob_lengua_indigena", "pct_lengua_indigena",
    # Educación
    "pob_15_mas", "pob_15_mas_analfabeta", "pct_analfabetismo",
    "pob_25_mas", "pob_25_mas_superior", "pct_superior",
    # Salud
    "pob_sis", "pob_essalud", "pct_sis", "pct_essalud",
    # Vivienda
    "viv_particulares", "viv_sin_agua_red", "viv_sin_desague_red", "viv_sin_electricidad_red",
    "pct_viv_sin_agua_red", "pct_viv_sin_desague_red", "pct_viv_sin_electricidad_red",
    # Hogar
    "hogares", "hog_celular", "hog_internet", "pct_hog_celular", "pct_hog_internet"
  )
  d <- d[order(d$ubigeo), columnas]
  rownames(d) <- NULL
  d
}

tablas <- list(
  "2007" = completar(merge(nombres_redatam(2007), indicadores_redatam(2007), by = "ubigeo"), 2007),
  "2017" = completar(merge(nombres_redatam(2017), indicadores_redatam(2017), by = "ubigeo"), 2017),
  "2025" = completar(indicadores_2025(), 2025)
)

dir.create(file.path("outputs", "tables"), recursive = TRUE, showWarnings = FALSE)
for (anio in names(tablas)) {
  base <- file.path("outputs", "tables", sprintf("censo_%s_distrital", anio))
  # CSV con BOM para que Excel en Windows lea bien las tildes
  con <- file(paste0(base, ".csv"), open = "wb")
  writeBin(as.raw(c(0xEF, 0xBB, 0xBF)), con)
  write.csv(tablas[[anio]], con, row.names = FALSE, fileEncoding = "UTF-8", na = "")
  close(con)
  write_xlsx(tablas[[anio]], paste0(base, ".xlsx"))
  message(sprintf("%s: %d distritos -> %s.csv / .xlsx", anio, nrow(tablas[[anio]]), base))
}
