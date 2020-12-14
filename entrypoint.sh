#!/bin/sh
JSON_STRING=".VUE_APP_OFI_ROOT:\"${VUE_APP_OFI_ROOT}\";"
for file in $(ls /tmp/); do 
  export ORIGINAL_NAME="${file##*/}";
done
sed "s@.VUE_APP_OFI_ROOT:\"https://delivery.apps.gov.bc.ca/pub/dwds-ofi/\";@${JSON_STRING}@" /tmp/app*.js > /app/js/$ORIGINAL_NAME
cd /etc
caddy 