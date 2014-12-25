#!/bin/bash

hosts_v4="217.86.191.73 h2t.daniel-weber.eu"
hosts_v6="h2t.daniel-weber.eu"

self="h2t.preissler.me"
cd /root/h2t/

git pull --quiet

for ip_version in 4 6
do
  hosts=hosts_v$ip_version
  for host in ${!hosts}
  do
    mtr_dir="${self}_${host}_v$ip_version"
    [ -d "$mtr_dir" ] || mkdir "$mtr_dir"
    mtr --report --report-wide --report-cycles 1000 --psize 1024 -$ip_version "$host" > "$mtr_dir"/"$(date +%F_%H-%M-%S)" &
  done
done

wait

git add --all
git commit --message "added mtrs from $self" --quiet
git pull --quiet
git push --quiet

