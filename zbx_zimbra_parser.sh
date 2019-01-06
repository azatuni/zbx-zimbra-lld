#!/bin/bash
ZIMBRA_PARSE_FILE="/usr/local/scripts/zimbra_stats.txt"


#function zimbra_discover() {
DISCOVERED_SERVICES=`sed -n '1!p' $ZIMBRA_PARSE_FILE | awk  '{if ($2 == "Running" || $2 == "Stopped" ) print $1; else print $1"_"$2}'`

function get-services-json () {
echo "{"
echo -e "\t\"data\":["
for service in $DISCOVERED_SERVICES
do
        if echo $DISCOVERED_SERVICES | grep -vq $service$
                then ENDLINE=','
                else ENDLINE=""
        fi
        echo -e '\t\t{"{#ZIMBRA_SERVICE}":'\"$service\"'}'$ENDLINE
done
echo -e "\t]"
echo "}"
}

function get-service-status () {
grep "`echo $1| awk -F'_' '{print $1,$2}'`" $ZIMBRA_PARSE_FILE | grep -q Running
if [ $? == 0 ]
        then    echo 1
        else    echo 0
fi
}

case $1 in
        --get-json)
                get-services-json
        ;;
        --status)
                get-service-status $2
        ;;
esac
