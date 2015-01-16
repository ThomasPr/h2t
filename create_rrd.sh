#!/bin/bash

rrd="h2t.rrd"


rrdtool create $rrd \
--step 3600 \
--start $(date -d "-1 year" "+%s") \
DS:H2Tv4loss:GAUGE:3900:0:100 \
DS:H2Tv4rtt:GAUGE:3900:0:1000 \
DS:H2Tv6loss:GAUGE:3900:0:100 \
DS:H2Tv6rtt:GAUGE:3900:0:1000 \
DS:T2Hv4loss:GAUGE:3900:0:100 \
DS:T2Hv4rtt:GAUGE:3900:0:1000 \
DS:T2Hv6loss:GAUGE:3900:0:100 \
DS:T2Hv6rtt:GAUGE:3900:0:1000 \
RRA:AVERAGE:0.5:1:8760



function pair {
  tail -q -n1 $@ 2> /dev/null | awk '{if($3 < 100){loss+=$3; avg+=$6; count++}} END {printf "%f:%f", loss/count, avg/count}' | sed "s/-nan/U/g"
}

mtr_dir="/root/www/h2t/"
for hour in $(seq 8759 -1 0)
do
  seconds=$(date --date="- $hour hours" "+%s")

  date=$(date --date="- $hour hours" "+%F_%H")
  H2Tv4=$(pair $mtr_dir/h2t.preissler.me_*_v4/$date*)
  H2Tv6=$(pair $mtr_dir/h2t.preissler.me_*_v6/$date*)
  T2Hv4=$(pair $mtr_dir/*_h2t.preissler.me_v4/$date*)
  T2Hv6=$(pair $mtr_dir/*_h2t.preissler.me_v6/$date*)

  rrdtool update $rrd $seconds:$H2Tv4:$H2Tv6:$T2Hv4:$T2Hv6
done



rrdtool graph loss_daily.png \
--imgformat PNG \
--slope-mode \
--start -86400 --end now \
--lower-limit 0 --upper-limit 100 \
--title "Daily Packet Loss" \
--watermark "$(date '+%F %T')" \
DEF:H2Tv4=$rrd:H2Tv4loss:AVERAGE \
DEF:H2Tv6=$rrd:H2Tv6loss:AVERAGE \
DEF:T2Hv4=$rrd:T2Hv4loss:AVERAGE \
DEF:T2Hv6=$rrd:T2Hv6loss:AVERAGE \
LINE:H2Tv4#00FF00:"H2Tv4" \
LINE:H2Tv6#7FB37C:"H2Tv6" \
LINE:T2Hv4#0000FF:"T2Hv4" \
LINE:T2Hv6#8BBFFF:"T2Hv6" \
TEXTALIGN:center > /dev/null

rrdtool graph rtt_daily.png \
--imgformat PNG \
--slope-mode \
--start -86400 --end now \
--lower-limit 0 \
--title "Daily Round Trip Time" \
--watermark "$(date '+%F %T')" \
DEF:H2Tv4=$rrd:H2Tv4rtt:AVERAGE \
DEF:H2Tv6=$rrd:H2Tv6rtt:AVERAGE \
DEF:T2Hv4=$rrd:T2Hv4rtt:AVERAGE \
DEF:T2Hv6=$rrd:T2Hv6rtt:AVERAGE \
LINE:H2Tv4#00FF00:"H2Tv4" \
LINE:H2Tv6#7FB37C:"H2Tv6" \
LINE:T2Hv4#0000FF:"T2Hv4" \
LINE:T2Hv6#8BBFFF:"T2Hv6" \
TEXTALIGN:center > /dev/null


rrdtool graph loss_weekly.png \
--imgformat PNG \
--slope-mode \
--start -604800 --end now \
--lower-limit 0 --upper-limit 100 \
--title "Weekly Packet Loss" \
--watermark "$(date '+%F %T')" \
DEF:H2Tv4=$rrd:H2Tv4loss:AVERAGE \
DEF:H2Tv6=$rrd:H2Tv6loss:AVERAGE \
DEF:T2Hv4=$rrd:T2Hv4loss:AVERAGE \
DEF:T2Hv6=$rrd:T2Hv6loss:AVERAGE \
LINE:H2Tv4#00FF00:"H2Tv4" \
LINE:H2Tv6#7FB37C:"H2Tv6" \
LINE:T2Hv4#0000FF:"T2Hv4" \
LINE:T2Hv6#8BBFFF:"T2Hv6" \
TEXTALIGN:center > /dev/null

rrdtool graph rtt_weekly.png \
--imgformat PNG \
--slope-mode \
--start -604800 --end now \
--lower-limit 0 \
--title "Weekly Round Trip Time" \
--watermark "$(date '+%F %T')" \
DEF:H2Tv4=$rrd:H2Tv4rtt:AVERAGE \
DEF:H2Tv6=$rrd:H2Tv6rtt:AVERAGE \
DEF:T2Hv4=$rrd:T2Hv4rtt:AVERAGE \
DEF:T2Hv6=$rrd:T2Hv6rtt:AVERAGE \
LINE:H2Tv4#00FF00:"H2Tv4" \
LINE:H2Tv6#7FB37C:"H2Tv6" \
LINE:T2Hv4#0000FF:"T2Hv4" \
LINE:T2Hv6#8BBFFF:"T2Hv6" \
TEXTALIGN:center > /dev/null


rrdtool graph loss_monthly.png \
--imgformat PNG \
--slope-mode \
--start -2592000 --end now \
--lower-limit 0 --upper-limit 100 \
--title "Monthly Packet Loss" \
--watermark "$(date '+%F %T')" \
DEF:H2Tv4=$rrd:H2Tv4loss:AVERAGE \
DEF:H2Tv6=$rrd:H2Tv6loss:AVERAGE \
DEF:T2Hv4=$rrd:T2Hv4loss:AVERAGE \
DEF:T2Hv6=$rrd:T2Hv6loss:AVERAGE \
LINE:H2Tv4#00FF00:"H2Tv4" \
LINE:H2Tv6#7FB37C:"H2Tv6" \
LINE:T2Hv4#0000FF:"T2Hv4" \
LINE:T2Hv6#8BBFFF:"T2Hv6" \
TEXTALIGN:center > /dev/null

rrdtool graph rtt_monthly.png \
--imgformat PNG \
--slope-mode \
--start -2592000 --end now \
--lower-limit 0 \
--title "Monthly Round Trip Time" \
--watermark "$(date '+%F %T')" \
DEF:H2Tv4=$rrd:H2Tv4rtt:AVERAGE \
DEF:H2Tv6=$rrd:H2Tv6rtt:AVERAGE \
DEF:T2Hv4=$rrd:T2Hv4rtt:AVERAGE \
DEF:T2Hv6=$rrd:T2Hv6rtt:AVERAGE \
LINE:H2Tv4#00FF00:"H2Tv4" \
LINE:H2Tv6#7FB37C:"H2Tv6" \
LINE:T2Hv4#0000FF:"T2Hv4" \
LINE:T2Hv6#8BBFFF:"T2Hv6" \
TEXTALIGN:center > /dev/null


rrdtool graph loss_yearly.png \
--imgformat PNG \
--slope-mode \
--start -31536000 --end now \
--lower-limit 0 --upper-limit 100 \
--title "Yearly Packet Loss" \
--watermark "$(date '+%F %T')" \
DEF:H2Tv4=$rrd:H2Tv4loss:AVERAGE \
DEF:H2Tv6=$rrd:H2Tv6loss:AVERAGE \
DEF:T2Hv4=$rrd:T2Hv4loss:AVERAGE \
DEF:T2Hv6=$rrd:T2Hv6loss:AVERAGE \
LINE:H2Tv4#00FF00:"H2Tv4" \
LINE:H2Tv6#7FB37C:"H2Tv6" \
LINE:T2Hv4#0000FF:"T2Hv4" \
LINE:T2Hv6#8BBFFF:"T2Hv6" \
TEXTALIGN:center > /dev/null

rrdtool graph rtt_yearly.png \
--imgformat PNG \
--slope-mode \
--start -31536000 --end now \
--lower-limit 0 \
--title "Yearly Round Trip Time" \
--watermark "$(date '+%F %T')" \
DEF:H2Tv4=$rrd:H2Tv4rtt:AVERAGE \
DEF:H2Tv6=$rrd:H2Tv6rtt:AVERAGE \
DEF:T2Hv4=$rrd:T2Hv4rtt:AVERAGE \
DEF:T2Hv6=$rrd:T2Hv6rtt:AVERAGE \
LINE:H2Tv4#00FF00:"H2Tv4" \
LINE:H2Tv6#7FB37C:"H2Tv6" \
LINE:T2Hv4#0000FF:"T2Hv4" \
LINE:T2Hv6#8BBFFF:"T2Hv6" \
TEXTALIGN:center > /dev/null
