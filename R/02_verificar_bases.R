# Verifica que las bases 2007 y 2017 se leen bien comparando la población censada
# total con las cifras oficiales del INEI.
# Ejecutar desde la raíz del proyecto: Rscript R/02_verificar_bases.R

source("R/utils_redatam.R")

oficial <- c("2007" = 27412157, "2017" = 29381884)
variable_sexo <- c("2007" = "Poblacio.P02SEXO", "2017" = "PERSONA.C5P2")

for (anio in names(oficial)) {
  r <- consultar_censo(anio, paste("freq", variable_sexo[[anio]]))
  total <- sum(r$value)
  cat(sprintf("Censo %s: %s personas (oficial INEI: %s) -> %s\n", anio,
              format(total, big.mark = ".", decimal.mark = ","), format(oficial[[anio]], big.mark = ".", decimal.mark = ","),
              if (total == oficial[[anio]]) "OK" else "NO COINCIDE"))
}
