#!/bin/bash

set -eo pipefail

cwd=$(dirname "${BASH_SOURCE[0]}")
bin=$cwd/../../bin
artifact_store=$1

create_infrastructure_config_files()
{
    for file in $(ls ${cwd}/../stacks/brighid-infrastructure/params/*.json); do
        envName=$(echo $file | xargs basename | sed "s/\.json//")
        params=$(cat $file)
        
        config=$(cat $cwd/../stacks/brighid-infrastructure/config.json)
        config=$(echo $config | jq --argjson params "$params" '.Parameters=$params')
        echo $config > $bin/brighid-infrastructure.${envName}.config.json
    done
}

package_static_assets_pipeline()
{
    sam package \
        --template-file $cwd/../stacks/static-assets-pipeline/template.yml \
        --s3-bucket $artifact_store \
        --output-template-file $bin/static-assets-pipeline.template.yml
}


mkdir -p $bin

create_infrastructure_config_files
package_static_assets_pipeline
cp $cwd/../stacks/brighid-infrastructure/template.yml $bin/brighid-infrastructure.template.yml
cp $cwd/../stacks/dns/template.yml $bin/dns.template.yml