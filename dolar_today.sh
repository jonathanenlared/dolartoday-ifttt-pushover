#!/bin/bash

# Script que controla la actualizacion 
# del precio del dolar en Venezuela manejado por 
# IFTTT y enviado por push via Pushover

# Dependecias: jq

#Env path

pwd_env=$(pwd)

#Constantes

LOCAL_CONFIG="${pwd_env}/bin/dolartoday_pushover/config.txt"
IFTTT_WEBHOOK_KEY=$(sed "1q;d" $LOCAL_CONFIG)
IFTTT_EVENT_NAME=$(sed "2q;d" $LOCAL_CONFIG)


#Consulta json dolartoday y almacena los valores.

curl -H "Accept: application/json" "https://s3.amazonaws.com/dolartoday/data.json" > ${pwd_env}/dolartoday.json
dolartoday=$(jq -r '.USD.dolartoday' ${pwd_env}/dolartoday.json)
dicom=$(jq -r '.USD.sicad2' ${pwd_env}/dolartoday.json)
bitcoin=$(jq -r '.USD.bitcoin_ref' ${pwd_env}/dolartoday.json)


#Hace llamado a webhook de IFTTT

curl -X POST -H "Content-Type: application/json" -d '{"value1":'${dolartoday}',"value2":'${dicom}',"value3":'${bitcoin}'}' https://maker.ifttt.com/trigger//with/key/${IFTTT_WEBHOOK_KEY}

exit 0