# Utilidades para códigos de ubigeo del INEI.
# El ubigeo tiene 6 dígitos: DD (departamento) + PP (provincia) + DD (distrito).

#' Devuelve el ubigeo como texto de 6 dígitos con ceros a la izquierda.
normalizar_ubigeo <- function(x) {
  x <- sub("\\.0+$", "", trimws(as.character(x)))
  formatC(x, width = 6, flag = "0")
}

#' Recorta ubigeos a "departamento" (2), "provincia" (4) o "distrito" (6).
nivel_ubigeo <- function(x, nivel = c("distrito", "provincia", "departamento")) {
  nivel <- match.arg(nivel)
  largo <- c(departamento = 2, provincia = 4, distrito = 6)[[nivel]]
  substr(normalizar_ubigeo(x), 1, largo)
}
