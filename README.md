# nmap_parser
generador de reporte HTML para nmap

Es necesario tener nmap instalado 

# Cómo Utilizar

./nmap-parser.sh [IP]/[MASK] [filename].raw

Donde:
IP. Es la IP en la que se realizará el escaneo
MASK. Es la mascara de subred
filename. Será el nombre del archivo .raw donde se guardará la salida de nmap

Se requiere especificar IP con máscara para especificar nombre de archivo .raw

En caso de no especificar filename se utilizará un nombre predeterminado "salida_nmap.raw"
En caso de no especificar IP/MASK se utilizarán las del host

El reporte HTML se guardará con el nombre "resultados_nmap.html"
