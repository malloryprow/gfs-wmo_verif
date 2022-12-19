#!/bin/sh
###################################################################
# script:wmo_verf_g2g_run.sh 
#         To run grid-to-grid MET 
#  Author: Binbin Zhou
#         Apr. 5, 2017
###################################################################
set -x

vday=$1 
model=$2 

MODEL=`echo $model | tr '[a-z]' '[A-Z]'`
obsv_cycles="00 12" 

for obsv_cycle in $obsv_cycles ; do  #loop for validation times in backward-mode 
fhr=12
  while [ $fhr -le 240 ] ; do 
    $USHverf_g2g/wmo_verf_g2g_gfs.sh $vday $model $MODEL $obsv_cycle $fhr 
    echo "doing for $model for cycle: $obsv_cycle forecast-hour: $fhr ....."  
    fhr=$((fhr+12))
  done 
done 
echo "waiting for $model .........."

tar cvf ${model}_${vday}.stat.tar grid_stat_${MODEL}_*.stat  
cp ${model}_${vday}.stat.tar $COMMET/.

echo "done for $model!"

