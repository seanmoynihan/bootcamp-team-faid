#!/bin/sh

set -e
set -u
set -o pipefail

script_dir=${0%/*}

yesterday_date=$(date -j -v-1d +%Y-%m-%d)

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






