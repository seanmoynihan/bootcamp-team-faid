#!/bin/sh

set -e
set -u
set -o pipefail

script_dir=${0%/*}

if [ "Linux" == $(uname) ];
then
    yesterday_date=$(date --date="1 day ago" +"%Y-%m-%d")
else
    yesterday_date=$(date -v-1d +%Y-%m-%d)
fi


data_dir=${script_dir}/../data/transponder

transponder_source_url=http://history.adsbexchange.com/Aircraftlist.json/${yesterday_date}.zip
zipFile=${data_dir}/transponder-data-${yesterday_date}.zip

if [ -d ${data_dir} ];
then
    echo "Data file exists: $zipFile "
else
    mkdir -p ${data_dir}

    curl -o ${zipFile} ${transponder_source_url}
    unzip ${zipFile} -d ${data_dir}
fi






