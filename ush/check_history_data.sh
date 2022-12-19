#!/bin/sh

set -x

for past_day in 1 2 3 4 5 6 7 8 9 10 11 12 ; do 

hour=$((past_day*24))
past=`$NDATE -$hour ${vday}00` 
day=`echo ${past} | cut -c 1-8`

echo "get date:" $day 

  if [ ! -s $COM_OUT/gfs.$day/gfs.t12z.pgrb2.1p50.f240 ] ; then

     mkdir -p $COM_OUT/gfs.$day
    
     if [ -d $COMGFS.$day ] ; then
       $USHverf_g2g/wmo_verf_g2g_get.sh gfs $day
     else
       $USHverf_g2g/wmo_verf_g2g_get_HPSS.sh gfs $day
     fi  
  fi 

done  
