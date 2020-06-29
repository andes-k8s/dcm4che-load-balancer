#!/bin/bash

echo "Este archivo genera la configuración del Load balancer"

echo "Dominio a utilizar (Ej: hpn.andes.gob.ar)"
read -r domain
echo "Ingrese las IPs de los nodos de Kubernetes. Finalice con una linea en blanco."

counter=1
#key = ''

# http => server serverA1 192.168.68.1:30443 check ssl verify none
# dicom => server dicom01 192.168.68.1:32762
# hl7 => server hl701 192.168.68.1:32575
# nema => server nema01 192.168.68.1:32112
cd conf
cp nginx.tpl nginx.conf

sed 's/{{domain}}/'$domain'/g' nginx.conf > nginx.tmp
mv nginx.tmp nginx.conf

while IFS= read -r line; do
    if [[ $line == '' ]] ; then
        echo "Configuration saved in conf/nginx.conf"
        sed 's/{{http}}/ /g' nginx.conf > nginx.tmp
        mv nginx.tmp nginx.conf
        sed 's/{{dicom}}/ /g' nginx.conf > nginx.tmp
        mv nginx.tmp nginx.conf
        sed 's/{{hl7}}/ /g' nginx.conf > nginx.tmp
        mv nginx.tmp nginx.conf
        sed 's/{{nema}}/ /g' nginx.conf > nginx.tmp
        mv nginx.tmp nginx.conf
        break;
    fi
    sed 's/{{http}}/server '$line':30443; \
    {{http}}/g' nginx.conf > nginx.tmp
    mv nginx.tmp nginx.conf

    sed 's/{{dicom}}/server '$line':32762; \
    {{dicom}}/g' nginx.conf > nginx.tmp
    mv nginx.tmp nginx.conf    

    sed 's/{{hl7}}/server '$line':32575; \
    {{hl7}}/g' nginx.conf > nginx.tmp
    mv nginx.tmp nginx.conf      

    sed 's/{{nema}}/server '$line':32112; \
    {{nema}}/g' nginx.conf > nginx.tmp
    mv nginx.tmp nginx.conf        

    ((counter++))
    
done 
cd ..


#echo $lines