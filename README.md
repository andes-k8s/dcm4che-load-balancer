# Load Balancer para DCM4Che

Balanceador de carga para el ingress de DCM4Che. 

Versión: NGINX

## Instrucciones

- Clonar el repositorio
- Correr el script ```./generate-conf.sh``` (el mismo preguntara por el nombre de dominio y las IPs de los nodos del cluster)
- Copiar los certificados de Let's Encrypt en la carpeta ./certs
- Iniciar el servicio ```docker-compose up -d```

