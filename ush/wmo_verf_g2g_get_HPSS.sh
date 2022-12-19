#!/bin/sh
set -x

model_name=$1
vday=$2

export copygb=${COPYGB}
export copygb2=${COPYGB2}
export cnvgrib=${CNVGRIB}
export wgrib2=${WGRIB2}

if [ $model_name = gfsanl ]; then   # gfs analysis data

  HPSSGFSANL=${HPSSGFSANL:-/NCEPPROD/hpssprod/runhistory}
  yyyy=${vday:0:4} 
  yyyymm=${vday:0:6}

  for cyc in 00 12 ; do

   if [ $vday -ge 20210317 ] ; then
    gfsanl_tar=${HPSSGFSANL}/rh${yyyy}/$yyyymm/$vday/com_gfs_prod_gdas.${vday}_${cyc}.gdas_pgrb2.tar
    htar -xf ${gfsanl_tar} ./gdas.$vday/${cyc}/atmos/gdas.t${cyc}z.pgrb2.0p25.anl
    gfsanl=$WORK/gdas.$vday/${cyc}/atmos/gdas.t${cyc}z.pgrb2.0p25.anl
   elif [ $vday -ge 20200226 ] && [ $vday -lt 20210317 ] ; then
    gfsanl_tar=${HPSSGFSANL}/rh${yyyy}/$yyyymm/$vday/com_gfs_prod_gdas.${vday}_${cyc}.gdas_pgrb2.tar
    htar -xf ${gfsanl_tar} ./gdas.$vday/${cyc}/gdas.t${cyc}z.pgrb2.0p25.anl
    gfsanl=$WORK/gdas.$vday/${cyc}/gdas.t${cyc}z.pgrb2.0p25.anl
   #if [ $vday -ge 20200226 ] ; then
   # gfsanl_tar=${HPSSGFSANL}/rh${yyyy}/$yyyymm/$vday/com_gfs_prod_gdas.${vday}_${cyc}.gdas_pgrb2.tar
   # htar -xf ${gfsanl_tar} ./gdas.$vday/${cyc}/gdas.t${cyc}z.pgrb2.0p25.anl
   # gfsanl=$WORK/gdas.$vday/${cyc}/gdas.t${cyc}z.pgrb2.0p25.anl
   elif [ $vday -ge 20190612 ] && [ $vday -lt 20200226 ] ; then
    gfsanl_tar=${HPSSGFSANL}/rh${yyyy}/$yyyymm/$vday/gpfs_dell1_nco_ops_com_gfs_prod_gdas.${vday}_${cyc}.gdas_pgrb2.tar
    htar -xf ${gfsanl_tar} ./gdas.$vday/${cyc}/gdas.t${cyc}z.pgrb2.0p25.anl
    gfsanl=$WORK/gdas.$vday/${cyc}/gdas.t${cyc}z.pgrb2.0p25.anl
   elif [ $vday -ge 20170720 ] && [ $vday -lt 20190612 ] ; then
    gfsanl_tar=${HPSSGFSANL}/rh${yyyy}/$yyyymm/$vday/gpfs_hps_nco_ops_com_gfs_prod_gdas.${vday}${cyc}.tar
    htar -xf ${gfsanl_tar} ./gdas.t${cyc}z.pgrb2.0p25.anl
    gfsanl=$WORK/gdas.t${cyc}z.pgrb2.0p25.anl
   elif [ $vday -ge 20160510 ] && [ $vday -lt 20170720 ] ; then
    gfsanl_tar=${HPSSGFSANL}/rh${yyyy}/$yyyymm/$vday/com2_gfs_prod_gdas.${vday}${cyc}.tar
    htar -xf ${gfsanl_tar} ./gdas1.t${cyc}z.pgrb2.0p25.anl
    gfsanl=$WORK/gdas1.t${cyc}z.pgrb2.0p25.anl
   else
    gfsanl_tar=${HPSSGFSANL}/rh${yyyy}/$yyyymm/$vday/com_gfs_prod_gdas.${vday}${cyc}.tar
    htar -xf ${gfsanl_tar} ./gdas1.t${cyc}z.pgrb2.0p25.anl
    gfsanl=$WORK/gdas1.t${cyc}z.pgrb2.0p25.anl
   fi

  if [ $vday -eq 20160317 ] || [ $vday -eq 20160319 ] ; then
    gfsanl_tar=${HPSSGFSANL}/rh${yyyy}/$yyyymm/$vday/com_gfs_prod_gdas.${vday}${cyc}.tar
    hsi get $gfsanl_tar
    tar -xvf com_gfs_prod_gdas.${vday}${cyc}.tar ./gdas1.t${cyc}z.pgrb2.0p25.anl
    gfsanl=$WORK/gdas1.t${cyc}z.pgrb2.0p25.anl
  fi
  if [ $vday -eq 20161026 ] ; then
    gfsanl_tar=${HPSSGFSANL}/rh${yyyy}/$yyyymm/$vday/com2_gfs_prod_gdas.${vday}${cyc}.tar
    hsi get $gfsanl_tar
    tar -xvf com2_gfs_prod_gdas.${vday}${cyc}.tar ./gdas1.t${cyc}z.pgrb2.0p25.anl
    gfsanl=$WORK/gdas1.t${cyc}z.pgrb2.0p25.anl
  fi


    > $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl

    $wgrib2 -match "HGT:850 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "HGT:500 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "HGT:250 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "HGT:100 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl

    $wgrib2 -match "TMP:850 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "TMP:500 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "TMP:250 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "TMP:100 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl

    $wgrib2 -match "UGRD:925 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "UGRD:850 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "UGRD:700 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "UGRD:500 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "UGRD:250 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev 
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "UGRD:100 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
   

    $wgrib2 -match "VGRD:925 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "VGRD:850 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev           
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "VGRD:700 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "VGRD:500 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "VGRD:250 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "VGRD:100 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl

    $wgrib2 -match "RH:700 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl
    $wgrib2 -match "RH:850 mb" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl

    $wgrib2 -match "PRMSL" $gfsanl|$wgrib2 -i $gfsanl -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl

    $copygb2 -g"0 6 0 0 0 0 0 0 240 121 0 0 90000000 0 48 -90000000 358500000 1500000 1500000 0" -x $WORK/retrieved.t${cyc}z.pgrb2.0p25.anl $COM_OUT/gfs.$vday/gdas.t${cyc}z.pgrb2.1p50.anl

    rm retriev
  done


elif [ $model_name = gfs ]; then   # GFS data

  HPSSGFS=${HPSSGFS:-/NCEPPROD/hpssprod/runhistory}
  yyyy=${vday:0:4}
  yyyymm=${vday:0:6}

  for cyc in 00 12 ; do
    fhr=12
    #typeset -Z3 fhr
    
    if [ $vday -eq 20160317 ] || [ $vday -eq 20160319 ] ; then
     gfs_tar=${HPSSGFS}/rh${yyyy}/$yyyymm/$vday/com_gfs_prod_gfs.${vday}${cyc}.pgrb2_0p25.tar
     hsi get $gfs_tar
     tar xvf com_gfs_prod_gfs.${vday}${cyc}.pgrb2_0p25.tar
    fi

    if [ $vday -eq 20161026 ] ; then
     gfs_tar=${HPSSGFS}/rh${yyyy}/$yyyymm/$vday/com2_gfs_prod_gfs.${vday}${cyc}.pgrb2_0p25.tar
     hsi get $gfs_tar
     tar xvf com2_gfs_prod_gfs.${vday}${cyc}.pgrb2_0p25.tar
    fi



   while [ $fhr -le 240 ] ; do
     if [ $fhr -lt 100 ]; then
         fhr=0$fhr
     elif [ $fhr -lt 10 ]; then 
         fhr=0$fhr
     fi
    if [ $vday -ge 20200226 ]; then
     gfs_tar=${HPSSGFS}/rh${yyyy}/$yyyymm/$vday/com_gfs_prod_gfs.${vday}_${cyc}.gfs_pgrb2.tar
    elif [ $vday -ge 20190612 ] && [ $vday -lt 20200226 ]; then
     gfs_tar=${HPSSGFS}/rh${yyyy}/$yyyymm/$vday/gpfs_dell1_nco_ops_com_gfs_prod_gfs.${vday}_${cyc}.gfs_pgrb2.tar
    elif [ $vday -ge 20170720 ] && [ $vday -lt 20190612 ]; then
     gfs_tar=${HPSSGFS}/rh${yyyy}/$yyyymm/$vday/gpfs_hps_nco_ops_com_gfs_prod_gfs.${vday}${cyc}.pgrb2_0p25.tar
    elif [ $vday -ge 20160510 ] && [ $vday -lt 20170720 ] ; then
     gfs_tar=${HPSSGFS}/rh${yyyy}/$yyyymm/$vday/com2_gfs_prod_gfs.${vday}${cyc}.pgrb2_0p25.tar
    else
     gfs_tar=${HPSSGFS}/rh${yyyy}/$yyyymm/$vday/com_gfs_prod_gfs.${vday}${cyc}.pgrb2_0p25.tar
    fi

    if [ $vday -ge 20210317 ]; then
     htar -xf ${gfs_tar} ./gfs.$vday/${cyc}/atmos/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
     gfs=$WORK/gfs.$vday/${cyc}/atmos/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    elif [ $vday -ge 20190612 ] && [ $vday -lt 20210317 ] ; then
     htar -xf ${gfs_tar} ./gfs.$vday/${cyc}/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
     gfs=$WORK/gfs.$vday/${cyc}/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    #if [ $vday -ge 20190612 ]; then
    # htar -xf ${gfs_tar} ./gfs.$vday/${cyc}/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    # gfs=$WORK/gfs.$vday/${cyc}/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    else
     htar -xf ${gfs_tar} ./gfs.t${cyc}z.pgrb2.0p25.f${fhr}
     gfs=$WORK/gfs.t${cyc}z.pgrb2.0p25.f${fhr}
    fi

     > $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}

    $wgrib2 -match "HGT:850 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "HGT:500 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "HGT:250 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "HGT:100 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}

    $wgrib2 -match "TMP:850 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "TMP:500 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "TMP:250 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "TMP:100 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}

    $wgrib2 -match "UGRD:925 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "UGRD:850 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "UGRD:700 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "UGRD:500 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "UGRD:250 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "UGRD:100 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}

    $wgrib2 -match "VGRD:925 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "VGRD:850 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "VGRD:700 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "VGRD:500 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "VGRD:250 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "VGRD:100 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}

    $wgrib2 -match "RH:700 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}
    $wgrib2 -match "RH:850 mb" $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}

    $wgrib2 -match "PRMSL"     $gfs|$wgrib2 -i $gfs -grib retriev
    cat retriev >> $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr}

    $copygb2 -g"0 6 0 0 0 0 0 0 240 121 0 0 90000000 0 48 -90000000 358500000 1500000 1500000 0" -x $WORK/retrieved.t${cyc}z.pgrb2.0p25.f${fhr} $COM_OUT/gfs.$vday/gfs.t${cyc}z.pgrb2.1p50.f${fhr}

     rm -f  retriev 
 
     fhr=`expr $fhr + 12`

    done
  done
  
  echo "copying of GFS done"
fi


