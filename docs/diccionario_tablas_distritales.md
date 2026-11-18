# Diccionario de las tablas distritales por censo

Archivos (uno por censo, mismas columnas, una fila por distrito):

| Archivo | Distritos | Fuente |
|---------|-----------|--------|
| `outputs/tables/censo_2007_distrital.csv` / `.xlsx` | 1.833 | Base REDATAM completa 2007 |
| `outputs/tables/censo_2017_distrital.csv` / `.xlsx` | 1.874 | Base REDATAM completa 2017 |
| `outputs/tables/censo_2025_distrital.csv` / `.xlsx` | 1.893 | Tabulados distritales oficiales del INEI 2025 |

Se generan con `Rscript R/07_tabla_distrital.R`.

**Llave:** `ubigeo`, código de 6 dígitos guardado como texto (`010101`). Al abrir el CSV en
Excel se pierden los ceros iniciales; usa el `.xlsx`, o en R lee el CSV con
`colClasses = c(ubigeo = "character")`.

Los ubigeos corresponden a los límites de cada censo: los 1.874 de 2017 están en 2025; 2025
tiene 19 distritos nuevos; 2007 tiene 3 ubigeos que ya no existen en 2017 (120699, 160109,
160114) y le faltan 44 que se crearon después. Para comparar en el tiempo, los distritos
nuevos deben reagruparse en su distrito de origen.

## Columnas

Las columnas `pob_*`, `viv_*` y `hog_*` son conteos; las `pct_*` son porcentajes (0–100, dos
decimales) calculados como numerador / denominador × 100.

| Columna | Definición | Denominador del % |
|---------|------------|-------------------|
| `ubigeo` | Código de distrito | |
| `anio` | Año del censo | |
| `departamento`, `provincia`, `distrito` | Nombres oficiales de ese censo | |
| `pob_censada` | Población censada (sin omisión estimada) | |
| `pob_0_14`, `pob_15_64`, `pob_65_mas` | Población por grandes grupos de edad (años cumplidos) | `pob_censada` |
| `pob_rural` | Población en área rural | `pob_censada` |
| `pob_3_mas` | Población de 3 años y más | |
| `pob_lengua_indigena` | Población de 3+ cuya lengua materna es indígena u originaria | `pob_3_mas` |
| `pob_15_mas` | Población de 15 años y más | |
| `pob_15_mas_analfabeta` | Población de 15+ que no sabe leer ni escribir | `pob_15_mas` |
| `pob_25_mas` | Población de 25 años y más | |
| `pob_25_mas_superior` | Población de 25+ con educación superior (no universitaria o universitaria, completa o incompleta, o posgrado) | `pob_25_mas` |
| `pob_sis`, `pob_essalud` | Población afiliada al SIS / a EsSalud (una persona puede tener ambos) | `pob_censada` |
| `viv_particulares` | Viviendas particulares con ocupantes presentes | |
| `viv_sin_agua_red` | Viviendas sin agua por red pública (ni dentro ni fuera de la vivienda) | `viv_particulares` |
| `viv_sin_desague_red` | Viviendas sin desagüe por red pública | `viv_particulares` |
| `viv_sin_electricidad_red` | Viviendas sin electricidad por red pública | `viv_particulares` |
| `hogares` | Hogares en viviendas particulares con ocupantes presentes | |
| `hog_celular` | Hogares con teléfono celular | `hogares` |
| `hog_internet` | Hogares con conexión a internet (2025: internet fijo) | `hogares` |

## Diferencias entre censos que afectan la comparación

- **De hecho vs. de derecho:** 2007 y 2017 cuentan a las personas donde durmieron la noche
  anterior al censo; 2025, donde viven habitualmente. Afecta a todos los conteos, sobre todo en
  distritos con mucha población flotante.
- **Lengua materna 2025:** la pregunta admitía varias lenguas. `pob_lengua_indigena` de 2025 es la
  suma de quienes marcaron cada lengua indígena; cuenta dos veces a quien aprendió dos lenguas
  indígenas (caso poco frecuente). En 2007 y 2017 era una sola respuesta.
- **Internet 2025:** se usa solo internet fijo, lo más parecido a la "conexión a internet" de
  2007 y 2017. El internet móvil de 2025 no tiene equivalente.
- **Rural 2025:** el % rural nacional sube de 17,6 % (2017) a 19,4 % (2025). Puede deberse al
  cambio a censo de derecho o a la clasificación urbano/rural; falta confirmarlo con el INEI.
- **Seguro 2007:** la variable combina tipos de seguro; se reconstruyeron SIS y EsSalud a partir
  de sus combinaciones.

## Pendiente

- **Densidad poblacional:** requiere la superficie de cada distrito (INEI/IGN), que aún no se ha
  incorporado.

## Valores nacionales (suma de distritos)

| Indicador | 2007 | 2017 | 2025 |
|-----------|------|------|------|
| Población censada | 27.412.157 | 29.381.884 | 32.706.028 |
| % rural | 24,1 | 17,6 | 19,4 |
| % 65 años y más | 6,4 | 8,4 | 10,5 |
| % lengua materna indígena (3+) | 15,7 | 16,0 | 16,2 |
| % analfabetismo (15+) | 7,1 | 5,8 | 5,1 |
| % educación superior (25+) | 32,7 | 34,2 | 37,6 |
| % afiliados al SIS | 18,5 | 44,4 | 66,0 |
| % afiliados a EsSalud | 17,9 | 25,8 | 24,8 |
| % viviendas sin agua por red pública | 36,4 | 21,7 | 20,7 |
| % viviendas sin desagüe por red pública | 45,8 | 33,4 | 31,2 |
| % viviendas sin electricidad por red pública | 25,9 | 12,3 | 8,6 |
| % hogares con celular | 42,9 | 83,8 | 95,4 |
| % hogares con internet | 6,8 | 28,0 | 31,1 |
