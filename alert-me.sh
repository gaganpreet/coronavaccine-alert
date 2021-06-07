#!/bin/bash -eou pipefail

BIRTH_YEAR=1988
LAST_SIX_MONTHS_POSITIVE=NEE  # Or JA
MEDICAL_RISK_GROUP=NEE   # Or JA


function start() {
    resp=$(curl -s "https://user-api.coronatest.nl/vaccinatie/programma/bepaalbaar/$BIRTH_YEAR/$LAST_SIX_MONTHS_POSITIVE/$MEDICAL_RISK_GROUP") 
    current_status=$(echo "$resp" | jq '.success')

    if [ "$current_status" = "true" ]
    then
        echo "Yay"
        success
    else
        echo "Not yet"
    fi
}

function success() {
    ###### Run this first
    #`telegram-send --configure`
    telegram-send "You can now book a vaccination slot. Go go go!"
    exit 1
}


# Only run between 10.00 to 14.00
while (( 1  ))
do
    hour=$(date +%H)
    if [ $hour -ge 10 -a $hour -le 14 ]
    then
        echo "Running at $(date)"
        start
    else
        echo "Skipping run at $(date) (outside time interval)"
    fi
    sleep 5m
done
