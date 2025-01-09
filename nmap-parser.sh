#!/bin/zsh

# Este programa parsea los resultados de nmap y construye un documento html
# para su visualización
# Ultima modificación: 3 de Enero del 2025 por nssmelmsr
# 20 - dic - 2024 se agrega la opción de argumento para IP y nombre de archivo
# 3 - ene - 2025 se agrega limitación de sudo


clear
[ $USER != root ] && echo "[ERROR] Se requiere ser usuario root. Cancelando" && exit

if [ $# -gt 0 ]; then
	case "$#" in
	   1) TARGET_IP=$1
	      echo "[INFO] La dirección a utilizar es $TARGET_IP"
	      ;;
	   2) TARGET_IP=$1
	      NMAP_OUTPUT=$2
	      echo "[INFO] La dirección a utilizar es $TARGET_IP"
	      echo "[INFO] El archivo de salida es $NMAP_OUTPUT"
	      ;;
	esac
else

	TARGET_IP=$(ip addr | grep 'wlo1$' | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,3}')
	NMAP_OUTPUT="salida_nmap.raw"

	echo "[INFO] Se usará elvalor automático de IP: $TARGET_IP"
	echo "[INFO] Se utilizará el valor automático para archivo $NMAP_OUTPUT"

fi

TITULO="Resultados de Nmap para $TARGET_IP"
FECHA_ACTUAL="$(date)"
TIMESTAMP="Informe generado el $FECHA_ACTUAL por el usuario $USER"
HTML_OUTPUT="resultados_nmap.html"


function nmap_exec () {
	echo "[INFO] Ejecutando nmap en $TARGET_IP"
	sudo nmap -sV $1 > $2	#$1 porque se utiliza el primer argumento y $2 por el segundo argumento de la llamada de la función
	echo "[OK] Fichero $2 generado"

}



# Generamos reporte raw
if [ $(find $NMAP_OUTPUT -mmin -30) ]; then

	while true; do 

		read "REPLY?[INFO] Existe un archivo con creado hace menos de 30 min. sobreescribir? [y/n]: "	#el ? se refiere a esperar argumento,
				#solo funciona en zsh, en bash es -p
		
		case $REPLY in

                        #generamos reporte .raw
                	y|Y) nmap_exec $TARGET_IP $NMAP_OUTPUT
        		   	break
				;;
			n|N) break
				;;
              	
			*) echo "[ERROR] Opción no válida"
		esac
	done
else
	#generamos reporte .raw
	nmap_exec $TARGET_IP $NMAP_OUTPUT 

fi

# Generamos archivo html

source html_rep.sh	#importamos script que genera el archivo

echo "[INFO] Dividiendo resultado de Nmap"
csplit $NMAP_OUTPUT '/^$/' '{*}' > /dev/null
echo "[OK] Resultado dividido en los ficheros:"
echo ""
ls xx*
echo ""
echo "[INFO] Generando reporte html..."
generar_html > $HTML_OUTPUT
echo "[OK] ¡Reporte $HTML_OUTPUT generado correctamente!"

rm xx*

