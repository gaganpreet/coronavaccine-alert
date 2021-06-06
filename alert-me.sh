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
}

hour=$(date +%H)

# Only run between 10.00 to 14.00
if [ $hour -gt 10 -a $hour -lt 14 ]
then
    start
fi
