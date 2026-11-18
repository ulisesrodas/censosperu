# Registro de fuentes

Los archivos de datos no se suben a git. Para obtenerlos: `Rscript R/01_descargar_datos.R`.

| Archivo | Censo | Fuente (URL) | Fecha de descarga | Notas |
|---------|-------|--------------|-------------------|-------|
| CP2007PER.zip (568 MB) | 2007 | https://prod.redatam.org/cdr/descargas/censos/poblacion/CP2007PER.zip | 2026-11-18 | Base REDATAM completa (universo), CELADE/CEPAL. Niveles: departamento, provincia, distrito, vivienda, hogar, persona. Incluye cédula y fichas técnicas en `Docs/`. |
| CP2017PER.zip (679 MB) | 2017 | https://prod.redatam.org/cdr/descargas/censos/poblacion/CP2017PER.zip | 2026-11-18 | Base REDATAM completa (universo), versión distrital, CELADE/CEPAL. Niveles: departamento, provincia, distrito, vivienda, hogar, persona. |
| `2025/tabulados/<región>/<tema>/*.xlsx` (286 archivos, 565 MB) | 2025 | https://censos2025.inei.gob.pe/descarga-de-datos | 2026-11-18 | Tabulados oficiales del INEI por departamento (26 regiones: Lima Metropolitana = 27, Región Lima = 26) y tema (7 de población, 2 de vivienda, 2 de hogar). Cuadros a nivel de provincia y distrito. No son microdatos. Se descargan con `R/03_descargar_2025.R`. |

Catálogo REDATAM 2007/2017: https://redatam.org/en/microdatos

## Verificación

`Rscript R/02_verificar_bases.R` compara la población censada total con las cifras oficiales del INEI:

| Censo | Total en la base | Oficial INEI |
|-------|------------------|--------------|
| 2007 | 27.412.157 | 27.412.157 |
| 2017 | 29.381.884 | 29.381.884 |
| 2025 (suma de regiones, censada) | 32.706.028 | 32.706.028 |
| 2025 (suma de regiones, total con omisión) | 34.157.732 | 34.157.732 |
