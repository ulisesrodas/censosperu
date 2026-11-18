# Censos de Perú 2007, 2017 y 2025: puntos clave

Comparación de los tres últimos censos nacionales de población y vivienda a nivel de **distrito**.

## Variables que sí se pueden comparar (13)

| Variable | Qué mide | A tener en cuenta |
|----------|----------|-------------------|
| Tamaño de la población | Población censada del distrito | Sin la omisión estimada de 2025 |
| Grupos de edad | 0–14, 15–64 y 65+ años | — |
| Población rural | % en área rural | En 2025 sube; falta confirmar si cambió la clasificación |
| Densidad poblacional | Habitantes por km² | Requiere la superficie del distrito (pendiente) |
| Lengua materna indígena | % de 3+ años con lengua indígena | En 2025 se podía marcar más de una lengua: dato aproximado |
| Analfabetismo | % de 15+ años que no sabe leer ni escribir | — |
| Educación superior | % de 25+ años con estudios superiores | — |
| Seguro de salud | % afiliado al SIS y % a EsSalud | Una persona puede tener ambos |
| Agua | % de viviendas sin agua por red pública | — |
| Desagüe | % de viviendas sin desagüe por red pública | — |
| Electricidad | % de viviendas sin electricidad por red pública | — |
| Teléfono celular | % de hogares con celular | — |
| Internet | % de hogares con internet | En 2025 solo internet fijo, para que sea comparable |

## Variables que no se pueden comparar en los tres censos (6)

| Variable | Por qué no | Qué sí se puede hacer |
|----------|-----------|-----------------------|
| Autoidentificación étnica | No se preguntó en 2007 | Comparar 2017 con 2025 |
| Religión | No se preguntó en 2025 | Comparar 2007 con 2017 |
| Migración | En 2025 no está publicada por distrito | Revisar la consulta REDATAM en línea del INEI |
| Trabajo en agricultura o actividades primarias | Sin datos de empleo 2025 | Comparar 2007 con 2017 |
| Independientes o familiares no remunerados | Sin datos de empleo 2025 | Comparar 2007 con 2017 |
| Trabajo en comercio y servicios | Sin datos de empleo 2025 | Comparar 2007 con 2017 |

## Advertencias

- **De hecho vs. de derecho:** 2007 y 2017 contaron a las personas donde durmieron la noche anterior al censo; 2025, donde viven habitualmente. Puede mover las cifras en distritos con mucha población de paso.
- **Distritos nuevos:** 2025 tiene 19 distritos que no existían en 2017, y 2017 tiene 44 códigos de distrito que no existían en 2007. Para comparar hay que juntarlos con su distrito de origen.
- **Fuentes distintas:** 2007 y 2017 salen de las bases completas del censo; 2025, de los cuadros por distrito del INEI, porque aún no hay base completa.

## Datos

- Tablas por año (una fila por distrito, llave `ubigeo`): [`outputs/tables/`](../outputs/tables/)
- Diccionario de columnas: [`diccionario_tablas_distritales.md`](diccionario_tablas_distritales.md)
- Detalle de preguntas por censo: [`comparabilidad_variables.md`](comparabilidad_variables.md)

## Fuentes

- **2007 y 2017:** bases REDATAM completas de CELADE/CEPAL ([redatam.org](https://redatam.org/en/microdatos)), validadas por el INEI.
- **2025:** cuadros por distrito del INEI ([censos2025.inei.gob.pe](https://censos2025.inei.gob.pe/descarga-de-datos)).
- Totales verificados con el INEI: 27.412.157 (2007), 29.381.884 (2017) y 32.706.028 (2025) personas censadas.
