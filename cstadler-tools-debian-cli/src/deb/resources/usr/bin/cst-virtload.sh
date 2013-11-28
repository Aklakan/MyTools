#!/bin/bash

# Script for loading an rdf file into a virtuoso store using
# virtuoso's isql
# Usage: sourceFile graphName port userName passWord
# e.g. <cmd> myfile.n3.bzip2 http://mygraph.org 1115 dba dba


virt_isql="/home/cstadler/Workspace/System/opt/virtuoso/vos/7.0.0-rc1/bin/isql"

unzip_source=$1

virt_graphName=$2
virt_port=$3
virt_userName=$4
virt_passWord=$5

unzip_extension=${unzip_source##*.}
unzip_target=${unzip_source%.*}

# Phase 1: Unzip
#echo "Target: $unzip_target, Extension: $unzip_extension"

if [ $unzip_extension = "bz2" ]; then
	bzip2 -dk $unzip_source
elif [ $unzip_extension = "gz" ]; then
	gzip -d $unzip_source
elif [ $unzip_extension = "zip" ]; then
	unzip $unzip_source
else
	unzip_target=$unzip_source
fi


# Phase 2: Convert to n-triple
# FIXME Skip this step if the source file is already in n-triples format


rapper_source=$unzip_target
rapper_extension=${rapper_source##*.}
rapper_target="${rapper_source%.*}.nt"

if [ $rapper_extension != "nt" ]; then
    rapper_target=`mktemp`
    rapper_target="$rapper_target.nt"
    echo "Converting to n-triples. File is $rapper_target"
    rapper $rapper_source -i guess -o ntriples >> $rapper_target
fi

#echo "Unzip target= $unzip_target"
split_size=$(stat -c%s "$rapper_target")

echo "Size = $split_size"


createGraphStmt="EXEC=Sparql Create Silent Graph <$virt_graphName>"
echo $virt_isql "$virt_port" "$virt_userName" "$virt_passWord" "$createGraphStmt"
$virt_isql "$virt_port" "$virt_userName" "$virt_passWord" "$createGraphStmt"


if [ $split_size -gt 5000000 ]; then
	echo "File is large."

	# Phase 3: Split
	split_source=$rapper_target
	split_dir=`mktemp -d`
        echo "Performing split on file $split_source"

	split -a 10 -l 50000 $split_source "${split_dir}/file"

	# Phase 4: Load
	slitIndex=0
	echo "creating load statement"
	for file in `ls $split_dir`
	do
		load_target="$split_dir/$file"
       		load_query="EXEC=TTLP(file_to_string_output('$load_target'), '', '$virt_graphName', 255);"
	        $virt_isql "$virt_port" "$virt_userName" "$virt_passWord" "$load_query"

		splitIndex=$((splitIndex+1))
		isCheckpointTime=$((splitIndex%5))

		if [ $isCheckpointTime -eq 10 ]; then
			echo "Checkoint..."
	                checkpointQuery="EXEC=checkpoint"
        	        $virt_isql "$virt_port" "$virt_userName" "$virt_passWord" "$checkpointQuery"
		fi

#		echo "$virt_isql" "$virt_port" "$virt_userName" "$virt_passWord" "$load_query"
	done;
	echo "done"
else
	echo "File is small. Loading directly."
	load_source=$rapper_target
	load_target=`mktemp`

	# NOTE By default virtuoso restricts access to files to only explicitely
	# allowed directories. By default /tmp is allowed, therefore we copy the
	# file there.
	cp $load_source $load_target

	load_query="EXEC=TTLP(file_to_string_output('$load_target'), '', '$virt_graphName', 255)"


	echo "$virt_isql $virt_port $virt_userName $virt_passWord $load_query"


	$virt_isql "$virt_port" "$virt_userName" "$virt_passWord" "$load_query"
fi
