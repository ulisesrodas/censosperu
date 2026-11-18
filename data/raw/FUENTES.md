# Registro de fuentes

Los archivos de datos no se suben a git. Para obtenerlos: `Rscript R/01_descargar_datos.R`.

| Archivo | Censo | Fuente (URL) | Fecha de descarga | Notas |
|---------|-------|--------------|-------------------|-------|
| CP2007PER.zip (568 MB) | 2007 | https://prod.redatam.org/cdr/descargas/censos/poblacion/CP2007PER.zip | 2026-11-18 | Base REDATAM completa (universo), CELADE/CEPAL. Niveles: departamento, provincia, distrito, vivienda, hogar, persona. Incluye cédula y fichas técnicas en `Docs/`. |
| CP2017PER.zip (679 MB) | 2017 | https://prod.redatam.org/cdr/descargas/censos/poblacion/CP2017PER.zip | 2026-11-18 | Base REDATAM completa (universo), versión distrital, CELADE/CEPAL. Niveles: departamento, provincia, distrito, vivienda, hogar, persona. |

Catálogo: https://redatam.org/en/microdatos

## Verificación

`Rscript R/02_verificar_bases.R` compara la población censada total con las cifras oficiales del INEI:

| Censo | Total en la base | Oficial INEI |
|-------|------------------|--------------|
| 2007 | 27.412.157 | 27.412.157 |
| 2017 | 29.381.884 | 29.381.884 |
