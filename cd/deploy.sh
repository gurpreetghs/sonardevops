#!/bin/bash -eux

#export VERSION="${1}"
#export NGINX_HOST="${2}"

CONFIGFILE="./config.js"
rm -rf "${CONFIGFILE}"
touch "${CONFIGFILE}"
echo "window.__env__ = {" >> "${CONFIGFILE}"
while read -r line || [[ -n "$line" ]];
do
  name=$(sed -e 's/=.*//' <<< "${line}")
  value=$(sed -e 's/^[^=]*=//' <<< "${line}")
  echo "${name}: \"${value}\"," >> "${CONFIGFILE}"
done <<< $(grep "REACT_APP" configuration)
echo "};" >> "${CONFIGFILE}"

docker swarm init || true

docker stop $(docker ps -aq) || true

base64 -d ./gcr.credentials | docker login -u _json_key --password-stdin https://gcr.io

docker stack deploy --with-registry-auth --compose-file=./docker-compose.live.yml signatry

docker logout

rm ./gcr.credentials
