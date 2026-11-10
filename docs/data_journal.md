# 📓 Data Journal - Proyecto CMF Risk

## [Fase 1: Preparación y Estructuración en Google Sheets]

### 1. Tratamiento de Inconsistencias, Encabezados y Simbología CMF
- **[P] Problema:** Las planillas originales de la CMF traían símbolos `'---'` para celdas vacías, comas de miles y encabezados combinados en 3 filas con acentos y caracteres especiales, lo que impedía la lectura automática de BigQuery.
- **[D] Decisión:** Diseñar una plantilla base (*molde*) en Google Sheets, aplanar encabezados a una sola fila en formato `snake_case` (sin acentos ni `ñ`), reemplazar nulos y agregar la columna `fecha`.
- **[A] Acción:** Reemplazo masivo de `'---'` por `0`, aplanamiento estructural de encabezados e inyección del metadato temporal en los 24 reportes.
- **[R] Resultado:** 24 archivos aislados y estructurados con encabezados en `snake_case` nativos para SQL y datos preparados para tipado `FLOAT64`/`INT64`.

---

## [Fase 2: Pipeline de Automatización y Tratamiento de Precisión Numérica con Python]

### 1. Ingesta Masiva, Conversión a CSV y Redondeo de Precisión (Python & Pandas)
- **[P] Problema:** La conversión manual de 24 archivos a `.csv` generaba alto consumo de tiempo. Adicionalmente, las transformaciones de hoja de cálculo introdujeron decimales flotantes extensos no corregibles masivamente con formato visual.
- **[D] Decisión:** Construir un script automatizado en Python (Google Colab) utilizando `pandas` y `glob` (para barrido recursivo de carpetas) que convierta los archivos a `.csv` e imponga un redondeo entero a los valores numéricos.
- **[A] Acción:** Ejecución del pipeline de lectura recursiva de directorios, aplicación de `round(0)` en columnas flotantes y exportación en codificación `UTF-8`:

```python
  import glob
  import os
  import pandas as pd

  # Barrido recursivo y conversión con redondeo de precisión
  for ruta_archivo in glob.glob(
      os.path.join(carpeta_origen, "**/*.csv"), recursive=True
  ):
    df = pd.read_csv(ruta_archivo)

    for col in df.select_dtypes(include=["float64", "float32"]).columns:
      df[col] = df[col].round(0)

    df.to_csv(ruta_salida, index=False, encoding="utf-8")
```
- **[R] Resultado:** 24 archivos CSV limpios para ser Cargados en Bigquery para su consolidacion

## [Fase: 03 — Consolidación Histórica e Ingesta en BigQuery (SQL)]

- **[P] Problema:** Fragmentación de la información en 24 archivos independientes (12 de colocaciones y 12 de activos), lo que impedía ejecutar consultas analíticas transversales y saturaba el procesamiento local.

- **[D] Decisión:** Centralizar el almacenamiento en Google BigQuery para aprovechar un entorno de Data Warehouse escalable y utilizar SQL (UNION ALL y sentencias DDL) para unificar los reportes mensuales en dos grandes tablas históricas (colocaciones_historico y activos_historico).

- **[A] Acción:** Creación del dataset en BigQuery, carga de los archivos CSV preprocesados, ejecución de scripts SQL para la unión de tablas y la correcta definición de esquemas mediante casteo explícito de datos (CAST a FLOAT64 e INT64 y parseo de fechas).

- **[R] Resultado:** Dos tablas históricas consolidadas y optimizadas en la nube, con trazabilidad completa de los 12 meses analizados, listas para ser consumidas directamente por Power BI reduciendo el tiempo de respuesta de las consultas a milisegundos.

## [Fase: 04 — Diseños de Dashboard y UI Ejecutiva en Power BI]

- **[P] Problema:**  Riesgo de caer en la "Ceguera de Escala" al comparar instituciones con volúmenes de activos muy dispares, sumado a la imposibilidad de filtrar simultáneamente dos tablas de hechos independientes (colocaciones_historico y activos_historico).

- **[D] Decisión:** Adoptar una arquitectura de modelo en estrella (Star Schema) mediante una tabla puente de dimensión (Dim_Banco) y diseñar una interfaz en cuadrícula (Grid Layout) que combine métricas de volumen absoluto con ratios relativos.

- **[A] Acción:** Construcción de la tabla dimensional Dim_Banco mediante DAX con relaciones 1:* hacia ambas tablas de hechos, desarrollo de títulos dinámicos condicionales (Titulo_Ficha_Ejecutiva) y maquetación de tarjetas KPI y gráficos bajo el patrón visual en "F".

- **[R] Resultado:** Un dashboard ejecutivo e interactivo que permite alternar fluidamente entre el resumen global del sistema y la ficha individual por banco, sincronizando filtros en tiempo real y revelando el volumen en dinero real en riesgo junto a los porcentajes de morosidad y cobertura.

Aprendizaje Clave: Un porcentaje bajo de morosidad en un banco gigante representa un volumen de dinero en riesgo significativamente mayor que un porcentaje alto en una entidad pequeña. El volumen absoluto en dinero siempre debe acompañar al ratio relativo porcentual.


