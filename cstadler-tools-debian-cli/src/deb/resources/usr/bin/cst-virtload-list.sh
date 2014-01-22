#!/bin/bash
# Usage: script.sh 1111 dba dba httpuser httppass

virtPort="$1"
virtUser="$2"
virtPass="$3"

httpUser="$4"
httpPass="$5"


while read url graphName; do

    if echo "$url" | egrep -q '^ *#'; then
        continue
    fi

    if [ -z "$graphName" ]; then
        continue
    fi

    fileName=${url##*/}
    if [ ! -f "$fileName" ]; then
        wget --http-user="$httpUser" --http-password="$httpPass" "$url"
    fi

    echo "$fileName -> $graphName"

    cst-virtload.sh "$fileName" "$graphName" "$virtPort" "$virtUser" "$virtPass"
done

#wget  --http-user="$httpUser" --http-password="$httpPass" http://data.geoknow.eu/internal/demo/sparqlify/2014-01-21-unister-hotel-reviews.sparqlify.sorted.nt.bz2



