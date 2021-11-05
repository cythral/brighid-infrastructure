#!/bin/bash

cwd=$(dirname "${BASH_SOURCE[0]}")


for file in $(ls ${cwd}/../params/*.json); do
    envName=$(echo $file | xargs basename | sed "s/\.json//")
    params=$(cat $file)
    
    config=$(cat $cwd/../config.json)
    config=$(echo $config | jq --argjson params "$params" '.Parameters=$params')
    echo $config > brighid-infrastructure.${envName}.config.json
done