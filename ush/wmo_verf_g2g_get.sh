#!/bin/sh
set -x

model_name=$1
VDAY=$2

export copygb=${COPYGB}
export copygb2=${COPYGB2}
export cnvgrib=${CNVGRIB}
export wgrib2=${WGRIB2}

if [ $model_name = gfsanl ]; then   # gfs analysis data

  COMGFSANL=${COMGFSANL:-${COMROOT}/gfs/${gfs_ver}/gdas}
  for cyc in 00 12 ; do

    gfsanl=$COMGFSANL.$VDAY/${cyc}/atmos/gdas.t${cyc}z.pgrb2.0p25.anl
    > $WORK/gdas.t${cyc}z.pgrb2.0p25.anl

    $wgrib2 -match "HGT:850 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "HGT:500 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "HGT:250 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "HGT:100 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl

    $wgrib2 -match "TMP:850 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "TMP:500 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "TMP:250 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "TMP:100 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl


    $wgrib2 -match "UGRD:925 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "UGRD:850 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "UGRD:700 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "UGRD:500 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "UGRD:250 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "UGRD:100 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl

    $wgrib2 -match "VGRD:925 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "VGRD:850 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "VGRD:700 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "VGRD:500 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "VGRD:250 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "VGRD:100 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl

    $wgrib2 -match "RH:700 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "RH:850 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl

    $wgrib2 -match "PRMSL" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/gdas.t${cyc}z.pgrb2.0p25.anl

    $copygb2 -g"0 6 0 0 0 0 0 0 240 121 0 0 90000000 0 48 -90000000 358500000 1500000 1500000 0" -x $WORK/gdas.t${cyc}z.pgrb2.0p25.anl $COM_OUT/gfs.$VDAY/gdas.t${cyc}z.pgrb2.1p50.anl
     
   rm retriev

  done

elif [ $model_name = clim ] ; then # CLIMATOLOGY data
 CLIM=${CLIM:-$HOMEverf_g2g/fix}

 for cyc in 00 12 ; do 
   mmdd=${VDAY:4:4}
   clim=$CLIM/cmean_1.5d.1959${mmdd}.grib2 
   $wgrib2 -match "${mmdd}${cyc}:" $clim|$wgrib2 -i $clim -grib $COM_OUT/gfs.$VDAY/clim.t${cyc}z.pgrb2.1p50.f000
 done 
 

elif [ $model_name = gfs ]; then   # GFS data
  COMGFS=${COMGFS:-${COMROOT}/gfs/${gfs_ver}/gfs}
  for cyc in 00 12 ; do
    fhr=12
    #typeset -Z3 fhr
   while [ $fhr -le 240 ] ; do
     if [ $fhr -lt 100 ]; then
         fhr=0$fhr
     elif [ $fhr -lt 10 ]; then
         fhr=00$fhr
     fi
    gfs=$COMGFS.$VDAY/${cyc}/atmos/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    > $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}

    $wgrib2 -match "HGT:850 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "HGT:500 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "HGT:250 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "HGT:100 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}

    $wgrib2 -match "TMP:850 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "TMP:500 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "TMP:250 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "TMP:100 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}

    $wgrib2 -match "UGRD:925 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "UGRD:850 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "UGRD:700 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "UGRD:500 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "UGRD:250 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "UGRD:100 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}

    $wgrib2 -match "VGRD:925 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "VGRD:850 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "VGRD:700 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "VGRD:500 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "VGRD:250 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "VGRD:100 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}

    $wgrib2 -match "RH:700 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "RH:850 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}

    $wgrib2 -match "PRMSL"     $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}

    $copygb2 -g"0 6 0 0 0 0 0 0 240 121 0 0 90000000 0 48 -90000000 358500000 1500000 1500000 0" -x $WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr} $COM_OUT/gfs.$VDAY/gfs.t${cyc}z.pgrb2.1p50.f${fhr}

     rm -f  retriev 
 
     fhr=`expr $fhr + 12`

    done
  done
  
  echo "copying of GFS done"
fi


