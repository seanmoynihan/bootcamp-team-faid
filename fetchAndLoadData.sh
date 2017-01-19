#!/bin/sh

hive_db_name=flight_info
data_dir=/data


set -e
set -u
set -o pipefail

script_dir=${0%/*}

${script_dir}/data_load/download_faa_data.sh
${script_dir}/data_load/download_transponder_data.sh


cat ${script_dir}/load-model-data.hql | hive -d DB=${hive_db_name} -d DATA=${data_dir}


