# Usar UTF-8 para que tildes y eñes se lean y escriban bien (Linux en la nube).
# En Windows (R >= 4.2) y macOS ya se usa UTF-8 por defecto.
if (.Platform$OS.type == "unix" && !grepl("UTF-8", Sys.getlocale("LC_CTYPE"), ignore.case = TRUE)) {
  invisible(Sys.setlocale("LC_ALL", "C.UTF-8"))
}
