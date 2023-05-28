#!/bin/bash

export mysql_cmd="mysql -h $MYSQL_HOST -u $MYSQL_USER -p${MYSQL_PASSWORD} -D $MYSQL_DATABASE"

mysql_exec() {
  local sql="$1"
  # $mysql_cmd -e "$sql" 2> /dev/null
  $mysql_cmd -e "$sql"
}

main() {
  for i in {1..65535}; do
    mysql_exec "select sleep(0.5)"
    mysql_exec "select sleep(0.5)"
    j="50"
    if [[ "${i:0-1}" -eq "0" ]]; then
      echo "$(date)  ---  i=$i  j=$j"
      for k in $(seq 1 $j); do
        mysql_exec "select sleep(0.3)" &
      done
      sleep 10
      if echo $i | grep -E '[16][0-9]{2}$' > /dev/null ; then
        sleep 10
      else
        sleep 60
      fi
    fi
    wait
  done
}

main
