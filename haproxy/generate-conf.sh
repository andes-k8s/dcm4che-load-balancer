#!/bin/sh

echo "Este archivo genera la configuración del Load balancer"
echo "Ingrese las IPs de los nodos de Kubernetes. Finalice con una linea en blanco."

counter=1
#key = ''

# http => server serverA1 192.168.68.1:30443 check ssl verify none
# dicom => server dicom01 192.168.68.1:32762
# hl7 => server hl701 192.168.68.1:32575
# nema => server nema01 192.168.68.1:32112
cd conf
cp haproxy.tpl haproxy.cfg

while IFS= read -r line; do
    if [[ $line == '' ]] ; then
        echo "Configuration saved in conf/haproxy.cfg"
        sed 's/{{http}}/ /g' haproxy.cfg > haproxy.tmp
        mv haproxy.tmp haproxy.cfg
        sed 's/{{dicom}}/ /g' haproxy.cfg > haproxy.tmp
        mv haproxy.tmp haproxy.cfg
        sed 's/{{hl7}}/ /g' haproxy.cfg > haproxy.tmp
        mv haproxy.tmp haproxy.cfg
        sed 's/{{nema}}/ /g' haproxy.cfg > haproxy.tmp
        mv haproxy.tmp haproxy.cfg
        break;
    fi
    sed 's/{{http}}/server httpA'$counter' '$line':30443 check ssl verify none \
    {{http}}/g' haproxy.cfg > haproxy.tmp
    mv haproxy.tmp haproxy.cfg

    sed 's/{{dicom}}/server dicomA'$counter' '$line':32762 check ssl verify none \
    {{dicom}}/g' haproxy.cfg > haproxy.tmp
    mv haproxy.tmp haproxy.cfg    

    sed 's/{{hl7}}/server hl7A'$counter' '$line':32575 check ssl verify none \
    {{hl7}}/g' haproxy.cfg > haproxy.tmp
    mv haproxy.tmp haproxy.cfg      

    sed 's/{{nema}}/server nemaA'$counter' '$line':32112 check ssl verify none \
    {{nema}}/g' haproxy.cfg > haproxy.tmp
    mv haproxy.tmp haproxy.cfg        

    ((counter++))
    
done 
cd ..


#echo $lines