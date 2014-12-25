#!/bin/sh

hosts="217.86.191.73"
self="h2t.preissler.me"
cd /root/h2t/

git pull

for host in $hosts
do
  mtr_dir="${self}_${host}"
  [ -d "$mtr_dir" ] || mkdir "$mtr_dir"
  mtr --report --report-wide --report-cycles 1000 --psize 1024 "$host" > "$mtr_dir"/"$(date +%F_%H-%M-%S)" &
done

wait

git add *
git commit -m "added mtrs from $self"
git pull
git push

