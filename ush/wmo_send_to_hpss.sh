#!/bin/sh

year=2020
wmo_met_test_dir=/lfs/h2/emc/vpppg/noscrub/emc.vpppg/verification/global/archive/WMO/com/verf/dev/met_test
hpss_dir=/NCEPDEV/emc-global/5year/emc.verif/global/archive/WMO

source ../versions/run.ver
module load prod_util/${prod_util_version}

# Make year HPSS directory
hsi mkdir $hpss_dir/$year

# Send gfs_$year*.stat.tar files to HPSS
start_YYYYmmdd=${year}0101
end_YYYYmmdd=${year}1231
date=${start_YYYYmmdd}00
while [ $date -le ${end_YYYYmmdd}00 ] ; do
    YYYYmmdd=`echo $date |cut -c 1-8`
    hsi put $wmo_met_test_dir/gfs_$YYYYmmdd.stat.tar : $hpss_dir/$year/gfs_$YYYYmmdd.stat.tar
    date=$($NDATE +24 $date)
done

# Send wmo_report_$year to HPSS
htar -cvf $hpss_dir/$year/wmo_report_${year}.tar $wmo_met_test_dir/wmo_report_${year}/*
