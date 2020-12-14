#!/bin/sh
JSON_STRING=".VUE_APP_OFI_ROOT:\"${VUE_APP_OFI_ROOT}\";"
cp /app/js/app*.js /tmp/.
sed -i "s@.VUE_APP_OFI_ROOT:\"https://delivery.apps.gov.bc.ca/pub/dwds-ofi/\";@${JSON_STRING}@" /tmp/app*.js
rm -rf /app/js/app*.js
cp -rf /tmp/app*.js /app/js/
cd /etc
caddy 