#!/bin/sh
JSON_STRING=".VUE_APP_OFI_ROOT:\"${VUE_APP_OFI_ROOT}\";"
sed -i "s@.VUE_APP_OFI_ROOT:\"https://delivery.apps.gov.bc.ca/pub/dwds-ofi/\";@${JSON_STRING}@" /app/js/app*.js
cd /etc
caddy 