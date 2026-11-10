import os
import pandas as pd
from google.colab import drive
drive.mount('/content/drive')
ruta_proyecto = '/content/drive/MyDrive/Caso de estudio 1 Morosidad bancos/Hojas de calculos/Meses listos'
ruta_destino_csv = os.path.join(ruta_proyecto, 'CSV')

if not os.path.exists(ruta_destino_csv):
    os.makedirs(ruta_destino_csv)
    print(f"Carpeta creada: {ruta_destino_csv}")
archivos_procesados = 0
for raíz, directorios, archivos in os.walk(ruta_proyecto):
    if 'CSV' in raíz or 'original' in raíz.lower():
        continue
    for archivo in archivos:
        if archivo.endswith('.xlsx') or archivo.endswith('.xls'):
            ruta_excel = os.path.join(raíz, archivo)
            try:
                xls = pd.ExcelFile(ruta_excel)
                for nombre_hoja in xls.sheet_names:
                    df = pd.read_excel(xls, sheet_name=nombre_hoja)
                    nombre_csv = f"{nombre_hoja}.csv" if len(xls.sheet_names) > 1 else f"{os.path.splitext(archivo)[0]}.csv"
                    ruta_salida = os.path.join(ruta_destino_csv, nombre_csv)
                    df.to_csv(ruta_salida, index=False, encoding='utf-8')
                    print(f"✅ Convertido: {nombre_csv}")
                    archivos_procesados += 1
            except Exception as e:
                print(f"❌ No funciona {archivo}: {e}")
print(f"\n Completado bien /CSV: {archivos_procesados}")
