#/bin/bash
realhostname="" 							# Wenn der tatsächliche hostname "versteckt" werden soll diesen hier eintragen

self=""												# eigenen Hostname eintragen, sollte identisch zum h2t-script sein
cd /root/h2t									# das Verzeichnis, in dem das Repo gecloned wurde

host="h2t.preissler.me"

git pull --quiet
ctime="$(date +%F_%H-%M-%S)"	# Wird in eine Variable gespeichert um den Ordnernamen rekonstruieren zu können
for ip_version in 4 6   			# ändern falls nur IPv4 oder IPv6 zur Verfügung steht
do
  mtr_dir="${self}_${host}_v$ip_version"
  [ -d "$mtr_dir" ] || mkdir "$mtr_dir"
  mtr --report --report-wide --report-cycles 1 --psize 1024 -$ip_version "$host" > "$mtr_dir"/"$ctime" &
done

wait

if [ "$realhostname" != "" ]
then
	for ip_version in 4 6
	do
		mtr_dir="${self}_${host}_v$ip_version"
		if [ -d "$mtr_dir" ]
		then
			sed -i "s/$realhostname/$self/" "$mtr_dir"/"$ctime"
		fi
	done
fi


git add "$self"*
git commit --message "added mtrs from $self" --quiet
git pull --quiet
git push --quiet
