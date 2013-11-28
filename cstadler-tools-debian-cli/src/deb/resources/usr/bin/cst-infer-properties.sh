#!/bin/bash
cut -f2 | sort -u | xargs -I@ echo "@ <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/1999/02/22-rdf-syntax-ns#Property> ."

