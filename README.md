# Censos de Perú: 2007, 2017 y 2025

Análisis comparativo de los censos nacionales de población y vivienda de Perú
realizados por el INEI:

| Censo | Nombre oficial | Fecha de empadronamiento |
|-------|----------------|--------------------------|
| 2007 | XI Censo de Población y VI de Vivienda | 21 de octubre de 2007 |
| 2017 | XII Censo de Población, VII de Vivienda y III de Comunidades Indígenas | 22 de octubre de 2017 |
| 2025 | XIII Censo de Población, VIII de Vivienda y IV de Comunidades Indígenas | 2025 (primeros resultados: 29 de mayo de 2026) |

## Estructura

```
R/                               Scripts de R (descarga, limpieza, funciones)
analisis/                        Documentos de análisis (Quarto / R Markdown)
data/
  raw/2007, raw/2017, raw/2025   Bases originales (no se suben a git)
  processed/                     Tablas limpias y armonizadas por distrito
  reference/                     Tablas de apoyo: ubigeos, equivalencias de distritos
docs/                            Documentación (comparabilidad de variables, etc.)
outputs/figures, outputs/tables  Gráficos y tablas finales
dashboard/                       Página web con los resultados
```

## Instalación

Requiere R 4.3 o superior.

```bash
Rscript R/00_paquetes.R          # instala los paquetes
Rscript R/01_descargar_datos.R   # descarga las bases 2007 y 2017 (~1,2 GB)
```

O abre `censosperu.Rproj` en RStudio y ejecuta los mismos scripts.

## Fuentes de datos

- **2007 y 2017:** bases completas (todo el universo censado) en formato REDATAM,
  distribuidas por CELADE/CEPAL en [redatam.org](https://redatam.org/en/microdatos)
  y validadas por el INEI. Se leen en R con el paquete `redatamx`.
- **2025:** resultados por departamento, provincia y distrito publicados por el INEI.
  Falta confirmar si ya hay microdatos disponibles.

Las bases pesadas están excluidas de git (ver `.gitignore`). Cada archivo se anota en
`data/raw/FUENTES.md` con su origen y fecha de descarga.

La comparabilidad de cada variable entre los tres censos está documentada en
[`docs/comparabilidad_variables.md`](docs/comparabilidad_variables.md).

## Puntos de cuidado al comparar censos

1. **Límites distritales:** se crearon distritos entre un censo y otro. Hay que
   usar una tabla de equivalencias de ubigeo (`data/reference/`) para comparar
   el mismo territorio.
2. **Preguntas distintas:** algunas variables solo existen en ciertos censos
   (p. ej. autoidentificación étnica desde 2017) o cambian de categorías.
3. **Población censada vs. total:** 2025 publica población censada y población
   total con omisión estimada. Hay que comparar siempre la misma medida.
