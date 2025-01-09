#!/bin/zsh

result_parser () {
        for i in xx*; do
		host_ip=$(grep -E 'Nmap scan report' $i |  grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')  
		open_ports=$(grep -E '^([0-9]{1,5}/)(tcp|udp) +open' $i | grep -E -o '^([0-9]{1,5}/)(tcp|udp)')
		service=$(grep -E '^([0-9]{1,5}/)(tcp|udp) +open' $i | awk '{print $3}')  
		if [ $host_ip ]; then
			cat <<EOFIP
          		<tr>
          		<td>$host_ip</td>
			$(if [ $open_ports ]; then
            			echo "<td>$open_ports \n</td>"
				echo "<td>$service</td>"
		  	  else
		    		echo "<td>No hay puertos abiertos</td>"
				echo "<td>No hay servicios expuestos</td>"
   	  		fi)
          		
          		</tr>
EOFIP
    		fi
	done
}

generar_html () {

cat <<EOF	
<html>
	<head>
    		<title>$TITULO</title>
		<style>
			table{
			font-family:arial, sans-serif;
			border-collapse: collapse;
			width: 100%
			}
			
			td, th {
			border: 1px solid #dddddd;
			text-align: left;
			padding: 8px;
			}

			tr: nth-child(even){
			backgound-color: #dddddd;
			}
		</style>
    	</head>
        <body>
		<h1>$TITULO</h1>
        	<p1>$TIMESTAMP</p1>     	
		<table>
		  <tr>
		    <th>Host IP</th>
		    <th>Puertos Abiertos</th>
		    <th>Servicio</th>
		  </tr>
$(result_parser)
		</table>
        </body>
</html> 
EOF
}
