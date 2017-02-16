#!/bin/bash

function setup-dashboard {
  for file in dashboards/*-datasource.json ; do
    if [ -e "$file" ] ; then
      echo "importing $file" &&
        curl --silent --fail --show-error \
             --request POST http://admin:admin@localhost:3000/api/datasources \
             --header "Content-Type: application/json" \
             --data-binary "@$file" || return 1;
      echo "" ;
    fi
  done ;
  for file in dashboards/*-dashboard.json ; do
    if [ -e "$file" ] ; then
      echo "importing $file" &&
        cat "$file" \
          | xargs -0 printf '{"dashboard":%s,"overwrite":true,"inputs":[{"name":"DS_PROMETHEUS","type":"datasource","pluginId":"prometheus","value":"prometheus"}]}' \
          | jq -c '.' \
          | curl --silent --fail --show-error \
                 --request POST http://admin:admin@localhost:3000/api/dashboards/import \
                 --header "Content-Type: application/json" \
                 --data-binary "@-" || return 1;
      echo "" ;
    fi
  done
  return 0
}

while true; do
  setup-dashboard
  if [[ "$?" == "0" ]]; then
    break
  fi
  sleep 3
done

while true; do sleep 10000; done
