# Comparabilidad de variables entre los censos 2007, 2017 y 2025

Revisión hecha sobre las cédulas censales oficiales del INEI (ver fuentes al final).
Nivel de análisis previsto: distrito.

Leyenda: ✅ comparable · ⚠️ comparable con ajustes · ❌ no comparable en los tres censos

## Advertencia general: censo de hecho vs. censo de derecho

| Censo | Tipo | A quién se registra en la vivienda |
|-------|------|------------------------------------|
| 2007 | De hecho | Personas que "durmieron aquí la noche anterior al día del censo" (incluye visitas) |
| 2017 | De hecho | Igual que 2007 |
| 2025 | De derecho | Personas que "viven permanentemente en este hogar", estén o no presentes |

Esto afecta a **todas** las variables a nivel distrital, sobre todo en distritos con mucha
población flotante (capitales, zonas mineras, turísticas o de frontera). 2007 y 2017
preguntan además "¿Vive permanentemente en este distrito?" (P5), lo que podría servir
para aproximar la población de derecho en esos dos censos si se trabaja con microdatos.

2025 publica también población total con omisión estimada (4,25 % a nivel nacional);
para comparar hay que usar la **población censada**.

## Resumen

| Tema | Variable | 2007 | 2017 | 2025 | Veredicto |
|------|----------|------|------|------|-----------|
| Demografía | Edad (grupos etarios) | P3 | P4 | P3 | ✅ |
| Demografía | Tamaño de población | ✔ | ✔ | ✔ | ⚠️ de hecho vs. de derecho |
| Demografía | Migración reciente (distrito hace 5 años) | P6 | P6 | P5 | ⚠️ periodo de referencia |
| Demografía | Migración de toda la vida (distrito de la madre al nacer) | P7 | P7 | P6 | ✅ |
| Territorio | % población rural | Ubicación censal | Ubicación censal | Ubicación censal | ⚠️ confirmar definición 2025 |
| Territorio | Densidad poblacional | — | — | — | ✅ se calcula con superficie externa |
| Etnolingüística | Lengua materna indígena | P9 | P11 | P16 | ⚠️ 2025 admite varias respuestas |
| Etnolingüística | Autoidentificación étnica | No existe | P25 | P10 | ❌ solo 2017–2025 |
| Educación | Analfabetismo | P10 | P12 | P14 | ✅ |
| Educación | Educación superior / años de estudio | P11 | P13 | P13 | ✅ |
| Empleo | PEA en agricultura / actividades primarias | P17 | P20 | P21 | ⚠️ |
| Empleo | Independientes y familiares no remunerados | P18 | P21 | P22 | ✅ |
| Empleo | PEA en comercio y servicios | P17 | P20 | P21 | ⚠️ |
| Vivienda | Sin agua por red pública | V-P4 | V-P6 | V-P5/5.1 | ✅ |
| Vivienda | Sin desagüe por red pública | V-P6 | V-P10 | V-P8 | ✅ |
| Vivienda | Sin electricidad por red pública | V-P7 | V-P11 | V-P9 | ✅ (solo "por red pública") |
| Hogar | Hogares con teléfono celular | H-P1B | H-P2 | H-P4 | ✅ |
| Hogar | Hogares con internet | H-P1B | H-P2 | H-P4 | ⚠️ 2025 separa fijo y móvil |
| Salud | SIS vs. EsSalud | P8 | P8 | P7 | ✅ |
| Religión | Religión | P20 | P26 | No existe | ❌ solo 2007–2017 |

(P = pregunta de la sección de población; V = sección de vivienda; H = sección de hogar.)

## Variables comparables en los tres censos, a nivel distrital

Solo se incluyen las variables pedidas que pueden compararse en 2007, 2017 y 2025 por distrito.
2007 y 2017 se calculan desde las bases REDATAM completas; 2025 desde los **tabulados oficiales
del INEI** por distrito (https://censos2025.inei.gob.pe/descarga-de-datos, descargados con
`R/03_descargar_2025.R`), ya que no hay microdatos.

| Variable | 2007 (REDATAM) | 2017 (REDATAM) | 2025 (tabulado) | Nota |
|----------|----------------|----------------|-----------------|------|
| Tamaño de población (censada) | `Poblacio` (conteo) | `PERSONA` (conteo) | Indicadores demográficos, C1 | Usar población censada; 2007/2017 de hecho, 2025 de derecho |
| Grupos etarios | `P03AANIO` | `C5P41` | Indicadores demográficos, C2 (edades simples) | |
| % población rural | `PAREA` | `PAREA` | Indicadores demográficos, C2 | Confirmar definición urbano/rural 2025 |
| Densidad poblacional | — | — | — | Población / superficie del distrito (INEI/IGN) |
| % lengua materna indígena | `P09IDIOMA` | `C5P11` | Etnicidad, C11 | 2025 admite varias lenguas |
| % analfabetismo (15+) | `P10LEE` | `C5P12` | Educación, C4 | |
| % educación superior (25+) | `P11ANIVEL` | `C5P13NIV` | Educación, C1 | |
| % SIS y % EsSalud | `P08AFILIA` | `C5P81`, `C5P82` | Estado civil, identidad y seguro de salud, C6 | |
| % viviendas sin agua por red pública | `V04ABASAGU` | `C2P6` | Servicios básicos de la vivienda, C1 | |
| % viviendas sin desagüe por red pública | `V06SERVHIG` | `C2P10` | Servicios básicos de la vivienda, C9 | |
| % viviendas sin electricidad por red pública | `V07ALUMBRA` | `C2P11` | Servicios básicos de la vivienda, C10 | |
| % hogares con celular | `H01BSERV` | `C3P210` | Equipamiento del hogar, C2 | |
| % hogares con internet | `H01BSERV` | `C3P213` | Equipamiento del hogar, C2 | En 2025 usar internet fijo |

Los nombres de distritos en los tabulados 2025 no traen ubigeo: hay que asignarlo por nombre de
departamento, provincia y distrito. El anexo de cada archivo lista leyes de demarcación de 2026
que cambiaron límites, por lo que algunos distritos no coincidirán con 2017.

## Detalle por variable

### Grupos etarios
Los tres censos registran la **edad en años cumplidos** (2017 y 2025 además la fecha de nacimiento).
Agrupaciones habituales:
- Quinquenales: 0–4, 5–9, …, 75–79, 80+ (para pirámides de edad).
- Grandes grupos: 0–14 (niñez), 15–64 (edad de trabajar), 65+ (adultos mayores).
- Indicadores derivados: índice de envejecimiento (65+ / 0–14 × 100), razón de dependencia
  ((0–14 + 65+) / 15–64 × 100), edad mediana.

### Migración
- **Reciente:** "Hace 5 años, ¿en qué distrito vivía?". Referencias: octubre 2002 (2007),
  octubre 2012 (2017), 2020 (2025, mes según la fecha de la entrevista). El periodo 2020–2025
  incluye la pandemia y la llegada de migración venezolana.
- **De toda la vida:** "Cuando nació, ¿en qué distrito vivía su madre?". Igual en los tres.
- Migrante = residía en otro distrito o país. 2025 agrega el año de llegada al Perú para nacidos fuera.

### Población rural
La cédula de los tres censos clasifica cada vivienda en área urbana o rural. Definición INEI
usada en 2007 y 2017: centro poblado urbano = 100 o más viviendas agrupadas contiguamente, o
capital de distrito. **Pendiente confirmar que 2025 mantiene la misma definición.**

### Densidad poblacional
No es una pregunta del censo: población / superficie del distrito (km²). La superficie viene de
INEI/IGN. Hay que usar los límites distritales correspondientes a cada año o armonizarlos.

### Lengua materna
- 2007: "¿El idioma o lengua con el que aprendió a hablar fue…?" — **una sola respuesta**.
- 2017: "¿Cuál es el idioma o lengua materna con el que aprendió a hablar en su niñez?" — **una sola respuesta**.
- 2025: "Los idiomas o lenguas con los que aprendió a hablar en su niñez fueron…" — **una o más respuestas**.
- Universo: 3 años y más en los tres.
- Consecuencia: en 2025, quien aprendió quechua y castellano a la vez marca ambas; en 2007/2017
  elegía una. El % con lengua indígena en 2025 tenderá a ser mayor por el cambio de pregunta.
  Para comparar, se puede reportar "alguna lengua indígena" (2025) frente a "lengua indígena"
  (2007/2017), señalando el cambio, o "solo lengua indígena" si los microdatos lo permiten.

### Autoidentificación étnica
- 2007: **no se preguntó**.
- 2017: "Por sus costumbres y sus antepasados, ¿usted se siente o considera…?" — 12 años y más.
- 2025: "Por sus antepasados, costumbres o tradiciones, se siente o considera…" — aparentemente para
  todas las personas (no tiene filtro de edad en la cédula); para comparar con 2017 hay que
  restringir a 12 años y más.
- Categorías 2025 añadidas: Nikkei, Tusan. "Nativo o indígena de la Amazonía" (2017) pasa a
  "De un pueblo indígena u originario de la Amazonía".

### Analfabetismo
"¿Sabe leer y escribir?" en los tres censos, preguntado a personas de 3 años y más.
Indicador estándar: % de población de **15 años y más** que no sabe leer ni escribir.

### Educación superior / años de estudio
"¿Cuál fue el último nivel y grado o año de estudios que aprobó?" en los tres.
- Niveles superiores: no universitaria incompleta/completa, universitaria incompleta/completa en
  los tres; 2017 agrega "Maestría/Doctorado" y 2025 los separa (incompleto/completo). Se agrupan
  sin problema.
- Indicador: % de población de 25 años y más con educación superior (completa o incompleta).
- Años promedio de estudio: calculable en los tres a partir de nivel + grado/año (para superior
  se asignan años por nivel).

### Empleo
- Rama de actividad: "¿A qué actividad se dedicó el negocio, organismo o empresa en la que trabajó?"
  (respuesta abierta, codificada por el INEI con la CIIU). Para agricultura/actividades primarias y
  comercio/servicios conviene usar grandes sectores, que son estables aunque cambie la versión de la CIIU.
- Universo: la pregunta de trabajo se aplica desde 6 años (2007) y 5 años (2017, 2025). Para
  comparar, usar el estándar de PEA de **14 años y más** en los tres.
- La forma de captar a los ocupados cambia algo (2025 añade trabajo artesanal y prácticas pagadas
  como trabajo), lo que puede mover ligeramente el tamaño de la PEA ocupada.

### Independientes y familiares no remunerados
Categoría de ocupación en los tres:
- Independiente / por cuenta propia: igual en los tres.
- Familiar no remunerado: "Trabajador familiar no remunerado" (2007), "Trabajador/a en negocio de
  un familiar" (2017), "Ayudante en el negocio o empresa de un familiar" (2025). Mismo concepto,
  redacción distinta.

### Agua, desagüe y electricidad
- **Agua:** red pública dentro de la vivienda / fuera pero dentro de la edificación o lote en los
  tres (2025 lo pregunta en dos pasos, P5 y P5.1). Pilón de uso público va aparte en los tres.
  Indicador: % de viviendas sin red pública (ni dentro ni fuera).
- **Desagüe:** red pública dentro / fuera en los tres. Indicador: % sin red pública de desagüe.
- **Electricidad:** 2007 y 2017 preguntan "¿Tiene alumbrado eléctrico por red pública? Sí/No".
  2025 pregunta la fuente (red pública, panel solar, generador, eólica, otro, no tiene).
  Indicador comparable: % de viviendas **sin electricidad por red pública**. El "% sin ningún
  tipo de electricidad" solo existe en 2025.

### Celular e internet
Pregunta a nivel de hogar en los tres ("¿Su hogar tiene…?").
- Teléfono celular: igual en los tres.
- Internet: 2007 y 2017 preguntan "Conexión a Internet"; 2025 separa "Internet fijo" e "Internet
  móvil". Para comparar, la opción más cercana es "Internet fijo" de 2025; "fijo o móvil" daría un
  salto artificial.
- 2025 pregunta además a cada persona si usó internet en los últimos 3 meses (P15), sin
  equivalente en censos anteriores.

### Seguro de salud
"¿Se encuentra afiliado al…?" con respuesta múltiple en los tres.
- 2007: SIS, EsSalud, otro seguro, ninguno.
- 2017 y 2025: SIS, EsSalud, FF.AA./policial, privado, otro, ninguno.
- SIS y EsSalud son directamente comparables. Para "otro", agrupar FF.AA. + privado + otro.

### Religión
- 2007: 12 años y más — Católica, Cristiana/Evangélica, Otra, Ninguna.
- 2017: 12 años y más — Católica, Evangélica, Otra, Ninguna.
- 2025: **la cédula no incluye pregunta de religión.**

## Fuentes

- Cédula censal 2007: https://www.inei.gob.pe/media/MenuRecursivo/cedulacensal_2007_1.pdf
- Cédula censal 2017: https://www.inei.gob.pe/media/MenuRecursivo/censos/cedulacensalcpv201706jun.pdf
- Cédula censal 2025 (versión de capacitación, julio 2025):
  https://www.gob.pe/institucion/inei/informes-publicaciones/6930565-cedula-censal-de-los-censos-nacionales-2025

La cédula 2025 revisada es la publicada para capacitación (lleva la marca de agua "CAPACITACIÓN").
Conviene contrastarla con el diccionario de variables cuando el INEI publique los microdatos.
