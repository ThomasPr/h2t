#/bin/bash

self="xxx.dip0.t-ipconnect.de"   # eigenen Hostname eintragen, sollte identisch zum h2t-script sein
cd /root/h2t/                    # das Verzeichnis, in dem das Repo gecloned wurde

host="h2t.preissler.me"

git pull --quiet

for ip_version in 4 6   # ändern falls nur IPv4 oder IPv6 zur Verfügung steht
do
  mtr_dir="${self}_${host}_v$ip_version"
  [ -d "$mtr_dir" ] || mkdir "$mtr_dir"
  mtr --report --report-wide --report-cycles 1000 --psize 1024 -$ip_version "$host" > "$mtr_dir"/"$(date +%F_%H-%M-%S)" &
done

wait


# die folgenden Zeilen auskommentieren, falls ein Hostname entfernt werden soll 
#hostname_to_supress=""   # Hostnamen zum Entfernen hier eintragen
#for dir in "${self}_${host}_v"*
#do
#  file=$dir/$(ls -1 "$dir"/ | tail -n1)
#  supress_length=$(echo $hostname_to_supress | wc -c)
#  substitution=$(printf "%-${supress_length}s" xxx)
#  sed -i "s/$hostname_to_supress/$substitution/g" $file
#done


git add "$self"*
git commit --message "added mtrs from $self" --quiet
git pull --quiet
git push --quiet
