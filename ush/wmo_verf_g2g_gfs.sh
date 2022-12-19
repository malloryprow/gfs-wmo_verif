#!/bin/sh
##############################################################################
# Script Name:wmo_verf_g2g_gfs.sh 
# Purpose:  This script processes the grid-to-grid MET for GFS
# History:  Binbin Zhou 08-02-2017
###############################################################################
set -x

## HH: for backward mode, HH is validation (obsv) cycle (fixed in this script)
##     for forward mode,  HH is forecast cycle (fixed in this script)

export vday=$1
export model=$2
export MODEL=$3
export HH=$4
#export domain=$5
export fhr=$5


#(1) Set parameters
# Except for NAM from operational /com/nam/prod, all others from
# $FCSTDIR where copygbed model files over grid212 are stored   

export fcstdir=$FCSTDIR
export fhead=gfs
export fgrbtype=pgrb2.1p50.f

export obsvdir=$OBSVDIR
export ohead=gdas
export ogrbtype=pgrb2.1p50
export otail=anl


#typeset -Z2 fcyc 
#if [ $fcyc -lt 10 ]; then
#    fcyc=0$fcyc
#fi
#typeset -Z3 fhr
if [ $fhr -lt 100 ]; then
    fhr=0$fhr
elif [ $fhr -lt 10 ]; then
     fhr=00$fhr
fi
obsv_cyc=${vday}${HH}  #validation time: xxxx.tHHz.f00 
fcst_time=`$NDATE -$fhr $obsv_cyc`
fyyyymmdd=${fcst_time:0:8}
fcyc=${fcst_time:8:2} 

if [ $fcyc = '00' ] || [ $fcyc = '12' ] ; then

  export FCST_FILE=${fcstdir}.${fyyyymmdd}/${fhead}.t${fcyc}z.${fgrbtype}${fhr}$ftm
  export OBSV_FILE=${obsvdir}.${vday}/${ohead}.t${HH}z.${ogrbtype}.${otail}
  export CLIM=${obsvdir}.${vday}/clim.t${HH}z.${ogrbtype}.f000

  ############################################
  #
  # Run MET 
  #
  ###########################################

  CONFIG_FILE=$WORK/config
  grid_stat $FCST_FILE $OBSV_FILE  $CONFIG_FILE -outdir . -v 2

  CONFIG_FILE=$WORK/config.noAC
  grid_stat $FCST_FILE $OBSV_FILE  $CONFIG_FILE -outdir . -v 2

fi 

exit
 

