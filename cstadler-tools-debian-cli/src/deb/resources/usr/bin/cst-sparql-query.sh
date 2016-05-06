#!/bin/bash

serviceUrl="$1"
fileName="$2"

curl -X "POST" -H "Accept: application/sparql-results+json" -F query="@$fileName" "$serviceUrl"

