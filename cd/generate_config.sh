CONFIGFILE="/opt/signatry/react-client/build/config.js"
rm -rf "${CONFIGFILE}"
touch "${CONFIGFILE}"
echo "window.__env__ = {" >> "${CONFIGFILE}"
while read -r line || [[ -n "$line" ]];
do
  name=$(sed -e 's/=.*//' <<< "${line}")
  value=$(sed -e 's/^[^=]*=//' <<< "${line}")
  echo "${name}: \"${value}\"," >> "${CONFIGFILE}"
done <<< $(grep "REACT_APP" /opt/signatry/.env)
echo "};" >> "${CONFIGFILE}"
