"""Utilidades para códigos de ubigeo del INEI.

El ubigeo tiene 6 dígitos: DD (departamento) + PP (provincia) + DD (distrito).
"""

import pandas as pd


def normalizar(ubigeo) -> str:
    """Devuelve el ubigeo como texto de 6 dígitos con ceros a la izquierda."""
    return str(ubigeo).strip().split(".")[0].zfill(6)


def nivel(serie: pd.Series, nivel: str) -> pd.Series:
    """Recorta ubigeos a 'departamento' (2), 'provincia' (4) o 'distrito' (6)."""
    largo = {"departamento": 2, "provincia": 4, "distrito": 6}[nivel]
    return serie.map(normalizar).str[:largo]
