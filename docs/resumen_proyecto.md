# Resumen del proyecto: censos de Perú 2007, 2017 y 2025

Resumen de lo trabajado hasta ahora: objetivo, decisiones, datos obtenidos, resultados y
pendientes.

## 1. Objetivo

Comparar los tres últimos censos nacionales de población y vivienda de Perú **a nivel de
distrito**, con un proyecto accesible desde varios dispositivos.

## 2. Decisiones tomadas

| Tema | Decisión |
|------|----------|
| Acceso desde varios dispositivos | Repositorio en GitHub (público, porque los datos son públicos y no sensibles) |
| Lenguaje de análisis | **R**, frente a Python |
| Nivel geográfico | Distrito, con el **ubigeo** como llave |
| Censo reciente | El censo es de **2025**, no de 2026: el trabajo de campo fue en 2025 y los primeros resultados se publicaron el 29 de mayo de 2026 |
| Datos pesados | No se suben a GitHub; se descargan con scripts |

## 3. Qué se hizo

1. **Estructura del proyecto en R:** carpetas `R/`, `data/`, `docs/`, `outputs/`,
   `analisis/` y archivo `censosperu.Rproj`.
2. **Revisión de comparabilidad:** se leyeron las cédulas censales oficiales de 2007, 2017 y
   2025 y se comparó cada variable pedida (pregunta, categorías y edad a la que se aplica).
3. **Descarga de 2007 y 2017:** bases REDATAM completas (todo el universo censado) de
   CELADE/CEPAL, que se leen en R con el paquete `redatamx`.
4. **Descarga de 2025:** no hay microdatos. Se usaron los **tabulados oficiales por distrito**
   del sitio del INEI (censos2025.inei.gob.pe): 286 archivos Excel, 26 regiones × 11 temas.
   El ubigeo de cada distrito se obtuvo de la API de geografía del mismo sitio.
5. **Tablas finales:** un archivo por censo, una fila por distrito y las mismas columnas en
   los tres.
6. **Documentación:** diccionario de columnas, detalle de comparabilidad y un resumen en Word
   para compartir.

## 4. Verificación de los datos

Los totales calculados coinciden con las cifras oficiales del INEI:

| Censo | Población censada | Distritos |
|-------|-------------------|-----------|
| 2007 | 27.412.157 | 1.833 |
| 2017 | 29.381.884 | 1.874 |
| 2025 | 32.706.028 (34.157.732 con omisión estimada) | 1.893 |

## 5. Variables

**Comparables en los tres censos por distrito (13):** tamaño de población, grupos de edad,
% rural, densidad, % lengua materna indígena, % analfabetismo (15+), % educación superior
(25+), % SIS, % EsSalud, % viviendas sin agua, sin desagüe y sin electricidad por red pública,
% hogares con celular y con internet.

**No comparables en los tres:**

| Variable | Motivo |
|----------|--------|
| Autoidentificación étnica | No se preguntó en 2007 (sí en 2017 y 2025) |
| Religión | No se preguntó en 2025 (sí en 2007 y 2017) |
| Migración | En 2025 no está publicada por distrito |
| Empleo: agricultura, independientes/familiares no remunerados, comercio y servicios | El INEI aún no publica datos de empleo de 2025 |

## 6. Resultados nacionales

| Indicador | 2007 | 2017 | 2025 |
|-----------|------|------|------|
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

## 7. Advertencias metodológicas

- **De hecho vs. de derecho:** 2007 y 2017 registraron a las personas donde durmieron la noche
  anterior al censo; 2025, donde viven habitualmente. Afecta sobre todo a distritos con
  población de paso.
- **Distritos que cambian:** 2025 tiene 19 distritos nuevos respecto a 2017; 2017 tiene 44
  códigos que no existían en 2007, y 3 de 2007 ya no existen.
- **Lengua materna 2025:** se podía marcar más de una lengua; el dato es una aproximación.
- **Internet 2025:** se usa solo internet fijo para comparar con 2007 y 2017.
- **% rural 2025:** sube respecto a 2017; falta confirmar si cambió la clasificación
  urbano/rural.

## 8. Archivos principales

| Archivo | Contenido |
|---------|-----------|
| [`outputs/tables/`](../outputs/tables/) | Tablas distritales 2007, 2017 y 2025 (`.xlsx` y `.csv`) |
| [`diccionario_tablas_distritales.md`](diccionario_tablas_distritales.md) | Significado de cada columna |
| [`comparabilidad_variables.md`](comparabilidad_variables.md) | Preguntas y categorías de cada censo |
| [`variables_censos_peru.docx`](variables_censos_peru.docx) | Resumen en Word para compartir |
| [`../data/raw/FUENTES.md`](../data/raw/FUENTES.md) | Origen de cada archivo de datos |

## 9. Cómo reproducirlo

Desde la raíz del proyecto, en R o RStudio:

```r
source("R/00_paquetes.R")         # instala paquetes
source("R/01_descargar_datos.R")  # descarga 2007, 2017 y 2025
source("R/02_verificar_bases.R")  # compara totales con el INEI
source("R/07_tabla_distrital.R")  # genera las tablas por distrito
```

## 10. Pendientes

- **Densidad poblacional:** incorporar la superficie de cada distrito (INEI/IGN).
- **Tabla de equivalencias de distritos:** agrupar los distritos nuevos con su distrito de
  origen para comparar el mismo territorio en los tres censos.
- **REDATAM en línea 2025** (redatamcpv2025.inei.gob.pe): revisar si permite obtener empleo y
  migración por distrito.
- **Confirmar con el INEI** la definición urbano/rural de 2025.
- Bajar las bases a la computadora local con `R/01_descargar_datos.R`.
