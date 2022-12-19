#!/bin/sh

year=$1
mon=$2

dir=$COMMET/wmo_report_${year}
mkdir -p $dir

#for mon in 01 02 03 04 05 06 07 08 09 10 11 12 ; do
 cat $dir/wmo_report_${year}${mon}.00Z  > $dir/${year}${mon}_kwbc_monthly.rec2
 cat $dir/wmo_report_${year}${mon}.12Z >> $dir/${year}${mon}_kwbc_monthly.rec2
#done


if [ $mon = '01' ] || [ $mon = '03' ] || [ $mon = '05' ] || [ $mon = '07' ] || [ $mon = '08' ] || [ $mon = '10' ] || [ $mon = '12' ] ; then
 >$dir/${year}${mon}_kwbc_daily.rec2
 for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 ; do
   cat $dir/wmo_report_${year}${mon}${day}.00Z >> $dir/${year}${mon}_kwbc_daily.rec2
   cat $dir/wmo_report_${year}${mon}${day}.12Z >> $dir/${year}${mon}_kwbc_daily.rec2
 done
#done
fi


if [ $mon = '04' ] || [ $mon = '06' ] || [ $mon = '09' ] || [ $mon = '11' ] ; then
#for mon in 04 06 09 11 ; do
 >$dir/${year}${mon}_kwbc_daily.rec2
 for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 ; do
   cat $dir/wmo_report_${year}${mon}${day}.00Z >> $dir/${year}${mon}_kwbc_daily.rec2
   cat $dir/wmo_report_${year}${mon}${day}.12Z >> $dir/${year}${mon}_kwbc_daily.rec2
 done
#done
fi


if [ $mon = '02' ] ; then 
  y=$(( $year % 4 ))
  if [ $y -eq 0 ] ; then
    echo "$year is Leap Year!"
    end=29
  else
    echo "$year is not a Leap Year!"
    end=28
  fi

# typeset -Z2 day
[[ $fday -lt 10 ]] && fday=0$fday
 #for mon in 02 ; do
  >$dir/${year}${mon}_kwbc_daily.rec2
  day=1
  while [ $day -le $end ] ; do
    cat $dir/wmo_report_${year}${mon}${day}.00Z >> $dir/${year}${mon}_kwbc_daily.rec2
    cat $dir/wmo_report_${year}${mon}${day}.12Z >> $dir/${year}${mon}_kwbc_daily.rec2
    day=$(( $day + 1 )) 
  done
 #done
fi

