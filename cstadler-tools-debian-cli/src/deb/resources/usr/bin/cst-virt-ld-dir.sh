#!/bin/bash

# Script for loading an rdf file into a virtuoso store using
# virtuoso's isql
# Usage: sourceFile graphName port userName passWord
# e.g. <cmd> myfile.n3.bzip2 http://mygraph.org 1115 dba dba

virt_isql="isql-vt"
virt_port="$1"
virt_userName="$2"
virt_passWord="$3"
virt_baseDir="$4"
virt_filePattern="$5"
virt_graphName="$6"


$virt_isql "$virt_port" "$virt_userName" "$virt_passWord" "EXEC=ld_dir('$virt_baseDir', '$virt_filePattern', '$virt_graphName')"
