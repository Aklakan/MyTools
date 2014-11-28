#!/bin/bash
echo "TODO: Path is fixed to ./app but should be read from .bowerrc"

rm -rf app/bower_components
bower cache clean
bower install
grunt bowerInstall

