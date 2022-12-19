#!/bin/sh 

yyyy=$1
mm=$2
day=$3
month=$4

mkdir -p $WORK/stat
stat=$WORK/stat

cd $stat

if [ $month = "no" ] ; then 
 if [ -e $COMMET/gfs_${yyyy}${mm}${day}.stat.tar ] ; then
   ln -sf $COMMET/gfs_${yyyy}${mm}${day}.stat.tar $stat/.
   tar xvf $stat/gfs_${yyyy}${mm}${day}.stat.tar
 fi

 for valid in 00 12 ; do
   stat_analysis -lookin $stat/grid_stat*${yyyy}${mm}${day}*.stat -tmp_dir $WORK -fcst_valid_hour ${valid}  -job aggregate_stat -line_type SAL1L2 -out_line_type CNT -by FCST_VAR,FCST_LEV,FCST_LEAD,VX_MASK -out_stat agg_stat_SAL1L2_to_CNT.sta.${yyyy}${mm}${day}.${valid}Z

   stat_analysis -lookin $stat/grid_stat*${yyyy}${mm}${day}*.stat -tmp_dir $WORK -fcst_valid_hour ${valid}  -job aggregate_stat -line_type SL1L2 -out_line_type CNT -by FCST_VAR,FCST_LEV,FCST_LEAD,VX_MASK -out_stat agg_stat_SL1L2_to_CNT.sta.${yyyy}${mm}${day}.${valid}Z

   stat_analysis -lookin $stat/grid_stat*${yyyy}${mm}${day}*.stat -tmp_dir $WORK -fcst_valid_hour ${valid} -fcst_var PRMSL -job aggregate -line_type GRAD -by FCST_LEAD,VX_MASK -out_stat agg_stat_GRAD_sta.${yyyy}${mm}${day}.${valid}Z


   stat_analysis -lookin $stat/grid_stat*${yyyy}${mm}${day}*.stat -tmp_dir $WORK -fcst_valid_hour ${valid}  -job aggregate_stat -line_type VL1L2 -out_line_type VCNT -by FCST_VAR,FCST_LEV,FCST_LEAD,VX_MASK -out_stat agg_stat_VL1L2_to_VCNT.sta.${yyyy}${mm}${day}.${valid}Z


 done

 rm -f $stat/grid_stat*${yyyy}${mm}${day}*.stat $stat/gfs_${yyyy}${mm}${day}.stat.tar

else 

 for dd in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 ; do
  if [ -e $COMMET/gfs_${yyyy}${mm}${dd}.stat.tar ] ; then
   ln -sf $COMMET/gfs_${yyyy}${mm}${dd}.stat.tar $stat/.
   tar xvf $stat/gfs_${yyyy}${mm}${dd}.stat.tar
  fi
 done


 for valid in 00 12 ; do
   stat_analysis -lookin $stat/grid_stat*${yyyy}${mm}*.stat -tmp_dir $WORK -fcst_valid_hour ${valid}  -job aggregate_stat -line_type SAL1L2 -out_line_type CNT -by FCST_VAR,FCST_LEV,FCST_LEAD,VX_MASK -out_stat agg_stat_SAL1L2_to_CNT.sta.${yyyy}${mm}.${valid}Z

   stat_analysis -lookin $stat/grid_stat*${yyyy}${mm}*.stat -tmp_dir $WORK -fcst_valid_hour ${valid}  -job aggregate_stat -line_type SL1L2 -out_line_type CNT -by FCST_VAR,FCST_LEV,FCST_LEAD,VX_MASK -out_stat agg_stat_SL1L2_to_CNT.sta.${yyyy}${mm}.${valid}Z

   stat_analysis -lookin $stat/grid_stat*${yyyy}${mm}*.stat -tmp_dir $WORK -fcst_valid_hour ${valid} -fcst_var PRMSL -job aggregate -line_type GRAD -by FCST_LEAD,VX_MASK -out_stat agg_stat_GRAD_sta.${yyyy}${mm}.${valid}Z

   stat_analysis -lookin $stat/grid_stat*${yyyy}${mm}*.stat -tmp_dir $WORK -fcst_valid_hour ${valid}  -job aggregate_stat -line_type VL1L2 -out_line_type VCNT -by FCST_VAR,FCST_LEV,FCST_LEAD,VX_MASK -out_stat agg_stat_VL1L2_to_VCNT.sta.${yyyy}${mm}.${valid}Z


 done

 rm -f $WORK/stat/*.stat $WORK/stat/*.tar

fi 
