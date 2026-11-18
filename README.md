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
data/
  raw/2007, raw/2017, raw/2025   Archivos originales del INEI (no se suben a git)
  processed/                     Tablas limpias y armonizadas entre censos
  reference/                     Tablas de apoyo: ubigeos, equivalencias de distritos
notebooks/                       Exploración y análisis
src/censos_peru/                 Código reutilizable (carga, limpieza, armonización)
outputs/figures, outputs/tables  Gráficos y tablas finales
dashboard/                       Página web con los resultados
```

## Instalación

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Fuentes de datos

- **2007 y 2017:** microdatos y consultas REDATAM del INEI.
- **2025:** resultados por departamento, provincia y distrito publicados por el INEI.
  Falta confirmar si ya hay microdatos disponibles.

Coloca los archivos descargados en `data/raw/<año>/`. Los archivos de datos
pesados están excluidos de git (ver `.gitignore`); anota en
`data/raw/FUENTES.md` de dónde salió cada archivo y en qué fecha se descargó.

## Puntos de cuidado al comparar censos

1. **Límites distritales:** se crearon distritos entre un censo y otro. Hay que
   usar una tabla de equivalencias de ubigeo (`data/reference/`) para comparar
   el mismo territorio.
2. **Preguntas distintas:** algunas variables solo existen en ciertos censos
   (p. ej. autoidentificación étnica desde 2017) o cambian de categorías.
3. **Población censada vs. total:** 2025 publica población censada y población
   total con omisión estimada. Hay que comparar siempre la misma medida.
