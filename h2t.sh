#!/bin/bash

hosts_v4="freyr.kunesch.net 80.147.118.52 80.152.244.206 80.147.49.10 80.147.42.45 87.139.29.180 87.139.62.124 80.147.118.55 089-asb52-vdsl50.spdns.de v4cohsrt.mine.nu kunde-01.die-bauer.de kunde-02.die-bauer.de kunde-03.die-bauer.de kunde-04.die-bauer.de firewall.remko.de mpf.ff-leopoldshoehe.de fms.it-kessler.de"
hosts_v6="089-asb52-vdsl50.spdns.de v6cohsrt.mine.nu"

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
    sleep 1
  done
done

wait

git add "$self"*
git commit --message "added mtrs from $self" --quiet
git pull --quiet
git push --quiet

