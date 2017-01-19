#!/bin/sh

set -e
set -u
set -o pipefail

script_dir=${0%/*}

data_dir=${script_dir}/../data/FAA

faa_source_url=http://registry.faa.gov/database/ReleasableAircraft.zip
zipFile=${data_dir}/ReleasableAircraft.zip

if [ -d ${data_dir} ]; then
  rm -rf ${data_dir}
fi

mkdir -p ${data_dir}
curl -o ${zipFile} ${faa_source_url}
echo "Data dir is: ${data_dir}"

unzip ${zipFile} -d ${data_dir}


