#! /usr/bin/perl

my $yyyy = $ARGV[0];
my $mm = $ARGV[1];
my $hh = $ARGV[2];
my $data = $ARGV[3];

my @input_dirs = qw (
 ./
);


my @fhr = qw ( 12 24 36 48 60 72 84 96 108 120 132 144 156 168 180 192 204 216 228 240 );
my @domain  =  qw ( NHM SHM TRP NAM ASA AUS EUR NPR SPR );
my @var  = qw ( PRMSL HGT  TMP  HGT  TMP  HGT  TMP  WIND WIND WIND );
my @lev = qw  ( L0    P850 P850 P500 P500 P250 P250 P850 P500 P250 );
my @var_sl1l2_noAC  = qw (HGT  TMP  RH   RH   WIND WIND WIND );
my @lev_sl1l2_noAC = qw  (P100 P100 P850 P700 P925 P700 P100 );

# For Wind vector RMSE (RMSVE) 
my @var_vl1l2 = qw ( UGRD_VGRD UGRD_VGRD UGRD_VGRD UGRD_VGRD UGRD_VGRD UGRD_VGRD );
my @lev_vl1l2 = qw (   P850      P500      P250      P925      P700      P100    );
my @var_wmo_vl1l2 = qw ( w850hPa w500hPa w250hPa w925hPa w700hPa w100hPa );

my @dom_wmo = qw ( nhem shem tropics namer asia austnz eurnafr npol spol );
my @var_wmo = qw ( mslp z850hPa t850hPa z500hPa t500hPa z250hPa t250hPa w850hPa w500hPa w250hPa z100hPa t100hPa r850hPa r700hPa w925hPa w700hPa w100hPa );


my $infile_sal1l2;
my $infile_sl1l2;
my $infile_sl1l2_noAC;
my $infile_s1_mslp;
my $infile_vl1l2;

my @r;
my @data; 
my @mkr;
my @n;

 $infile_sal1l2 = $data . '/agg_stat_SAL1L2_to_CNT.sta.' . $yyyy . $mm . '.' . $hh . 'Z';
 $infile_sl1l2 =  $data . '/agg_stat_SL1L2_to_CNT.sta.'  . $yyyy . $mm . '.' . $hh . 'Z';
 $infile_sl1l2_noAC = $data . '/agg_stat_SL1L2_to_CNT.sta.' . $yyyy . $mm . '.' . $hh . 'Z';
 $infile_s1_mslp = $data . '/agg_stat_GRAD_sta.' . $yyyy . $mm . '.' . $hh . 'Z';
 $infile_vl1l2 =  $data . '/agg_stat_VL1L2_to_VCNT.sta.'  . $yyyy . $mm . '.' . $hh . 'Z';

##########################################################################################
#
# SAL1L2 
#
#########################################################################################

open ( INFILE, "$infile_sal1l2" );
my $m=0;

while ( defined( my $one_rec = <INFILE> )) {
    @r  = split( /\s+/, $one_rec );
    for ($i=0; $i<=$#r; $i++) { 
     $data[$m][$i]=$r[$i];
    }
    $m++;
}

my $indx_lead;
my $indx_AC;
my $indx_RMSFA;
my $indx_RMSOA;
for ($i=0; $i<=$#r; $i++) {
   if ( $data[0][$i] eq "FCST_LEAD" ) {
     $indx_lead = $i;
  } elsif ( $data[0][$i] eq  "ANOM_CORR" ) {
      $indx_AC = $i;
  } elsif ( $data[0][$i] eq   "RMSFA" ) {
      $indx_RMSFA = $i;
  } elsif ( $data[0][$i] eq   "RMSOA" ) {
      $indx_RMSOA = $i;
  } else {
    ;
  }
}

#print "$indx_AC $data[0][$indx_AC] $indx_RMSFA $data[0][$indx_RMSFA] $indx_RMSOA $data[0][$indx_RMSOA] \n";

for ($i=0; $i<=$#r; $i++){
   if ( $data[1][$i] ne 'NA' ) {
        $mkr[$i]=1;
   } else { 
        $mkr[$i]=0
   } 
}  


#print "STAT of SAL1L2\n";

my @search_sal1l2;

for ( $v=0; $v<=$#var; $v++) {
    for ( $d=0; $d<=$#domain; $d++) { 
      for ( $f=0; $f<=$#fhr; $f++) {

        for ($j=1; $j<$m; $j++) {
            my $lead=$data[$j][3]/10000;
            if ( $lead == $fhr[$f] &&  $data[$j][9] eq $var[$v] && $data[$j][11] eq $lev[$v] && $data[$j][16] eq $domain[$d]) {
              
              for ($i=0; $i<=$#r; $i++) {
                $search_sal1l2[$v][$d][$f][$i]=$data[$j][$i]; 
              }
            }
        }

     }
   }
} 


for ( $v=0; $v<=$#var; $v++) {
    for ( $d=0; $d<=$#domain; $d++) {
      for ( $f=0; $f<=$#fhr; $f++) {
         
         #for ($i=3; $i<=5; $i++) { print "$search_sal1l2[$v][$d][$f][$i] "};
         #for ($i=9; $i<=10; $i++) { print "$search_sal1l2[$v][$d][$f][$i] "};

         if ( $v==0 ) { # mslp 
           $search_sal1l2[$v][$d][$f][$indx_RMSFA] = $search_sal1l2[$v][$d][$f][$indx_RMSFA] / 100;
           $search_sal1l2[$v][$d][$f][$indx_RMSOA] = $search_sal1l2[$v][$d][$f][$indx_RMSOA] / 100;
         }
         #print "$search_sal1l2[$v][$d][$f][14] $search_sal1l2[$v][$d][$f][21] $search_sal1l2[$v][$d][$f][$indx_AC]  $search_sal1l2[$v][$d][$f][$indx_RMSFA]  $search_sal1l2[$v][$d][$f][$indx_RMSOA]\n ",  
       }
     }
   
} 


##################################################################################################
#
#     SL1L2
#
##################################################################################################
       
#print "STAT of SL1L2\n";

  open ( INFILE, "$infile_sl1l2" );
$m=0;

  while ( defined( my $one_rec = <INFILE> )) {
    @r  = split( /\s+/, $one_rec );
    for ($i=0; $i<=$#r; $i++) {
     $data[$m][$i]=$r[$i];
    }
    $m++;
  }

  for ($i=0; $i<=$#r; $i++){
     if ( $data[1][$i] ne 'NA' ) {
        $mkr[$i]=1;
     } else {
        $mkr[$i]=0
     }
  }


my @search_sl1l2;

for ( $v=0; $v<=$#var; $v++) {
    for ( $d=0; $d<=$#domain; $d++) {
      for ( $f=0; $f<=$#fhr; $f++) {


        for ($j=1; $j<$m; $j++) {
            my $lead=$data[$j][3]/10000;
            if ( $lead == $fhr[$f] &&  $data[$j][9] eq $var[$v] && $data[$j][11] eq $lev[$v] && $data[$j][16] eq $domain[$d]) {
              for ($i=0; $i<=$#r; $i++) {
                $search_sl1l2[$v][$d][$f][$i]=$data[$j][$i];
              }
            }
        }

     }
   }
  
}


my $indx_lead;
my $indx_RMSE;
my $indx_ME;
my $indx_MAE;
my $indx_FSTDEV;
my $indx_OSTDEV;

for ($i=0; $i<=$#r; $i++) {
   if ( $data[0][$i] eq "FCST_LEAD" ) {
     $indx_lead = $i;
  } elsif ( $data[0][$i] eq  "RMSE" ) {
      $indx_RMSE = $i;
  } elsif ( $data[0][$i] eq   "ME" ) {
      $indx_ME = $i;
  } elsif ( $data[0][$i] eq   "MAE" ) {
      $indx_MAE = $i;
  } elsif ( $data[0][$i] eq   "FSTDEV" ) {
      $indx_FSTDEV = $i;
  } elsif ( $data[0][$i] eq   "OSTDEV" ) {
      $indx_OSTDEV = $i;
  } else {
    ;
  }
}

#print "$indx_RMSE $data[0][$indx_RMSE] $indx_ME $data[0][$indx_ME]  $indx_MAE $data[0][$indx_MAE] $indx_FSTDEV $data[0][$indx_FSTDEV] $indx_OSTDEV $data[0][$indx_OSTDEV] \n";

 
for ( $v=0; $v<=$#var; $v++) {
    for ( $d=0; $d<=$#domain; $d++) {
      for ( $f=0; $f<=$#fhr; $f++) {

          if ( $v == 0 ) { # mslp 
            $search_sl1l2[$v][$d][$f][$indx_RMSE]=$search_sl1l2[$v][$d][$f][$indx_RMSE]/100;
            $search_sl1l2[$v][$d][$f][$indx_ME]=$search_sl1l2[$v][$d][$f][$indx_ME]/100;
            $search_sl1l2[$v][$d][$f][$indx_MAE]=$search_sl1l2[$v][$d][$f][$indx_MAE]/100;
            $search_sl1l2[$v][$d][$f][$indx_FSTDEV]=$search_sl1l2[$v][$d][$f][$indx_FSTDEV]/100;
            $search_sl1l2[$v][$d][$f][$indx_OSTDEV]=$search_sl1l2[$v][$d][$f][$indx_OSTDEV] /100;
          } 

         #for ($i=3; $i<=5; $i++) { print "$search_sl1l2[$v][$d][$f][$i] "};
         #for ($i=9; $i<=10; $i++) { print "$search_sl1l2[$v][$d][$f][$i] "};
         #print "$search_sl1l2[$v][$d][$f][14] $search_sl1l2[$v][$d][$f][21] $search_sl1l2[$v][$d][$f][$indx_RMSE]  $search_sl1l2[$v][$d][$f][$indx_ME]  $search_sl1l2[$v][$d][$f][$indx_MAE] $search_sl1l2[$v][$d][$f][$indx_FSTDEV]  $search_sl1l2[$v][$d][$f][$indx_OSTDEV] \n ",

       }
     }
   
}



#################################################################################################
##
##     SL1L2 for no AC Stat  
##
###################################################################################################

#print "STAT of noAC SL1L2 \n";

  open ( INFILE, "$infile_sl1l2_noAC" );
$m=0;

  while ( defined( my $one_rec = <INFILE> )) {
    @r  = split( /\s+/, $one_rec );
    for ($i=0; $i<=$#r; $i++) {
     $data[$m][$i]=$r[$i];
    }
    $m++;
  }

  for ($i=0; $i<=$#r; $i++){
     if ( $data[1][$i] ne 'NA' ) {
        $mkr[$i]=1;
     } else {
        $mkr[$i]=0
     }
  }


for ( $v=0; $v<=$#var_sl1l2_noAC; $v++) {

    for ( $d=0; $d<=$#domain; $d++) {
      for ( $f=0; $f<=$#fhr; $f++) {


        for ($j=1; $j<$m; $j++) {
            my $lead=$data[$j][3]/10000;
            if ( $lead == $fhr[$f] &&  $data[$j][9] eq $var_sl1l2_noAC[$v] && $data[$j][11] eq $lev_sl1l2_noAC[$v] && $data[$j][16] eq $domain[$d]) {
              for ($i=0; $i<=$#r; $i++) {
                $search_sl1l2[$v+1+$#var][$d][$f][$i]=$data[$j][$i];
              }
            }
        }

     }
   }

}


###############################################################################################
#
#  S1 for PRMSL 
#
##############################################################################################
#  print "STAT of S1 for PRMSL \n";

  open ( INFILE, "$infile_s1_mslp" );
  $m=0;

  while ( defined( my $one_rec = <INFILE> )) {
    @r  = split( /\s+/, $one_rec );
    for ($i=0; $i<=$#r; $i++) {
     $data[$m][$i]=$r[$i];
    }
    $m++;
  }

  for ($i=0; $i<=$#r; $i++){
     if ( $data[1][$i] ne 'NA' ) {
        $mkr[$i]=1;
     } else {
        $mkr[$i]=0
     }
  }


my @search_s1;

for ( $v=0; $v<=0; $v++) {
    for ( $d=0; $d<=$#domain; $d++) {
      for ( $f=0; $f<=$#fhr; $f++) {


        for ($j=1; $j<$m; $j++) {
            my $lead=$data[$j][3]/10000;
            if ( $lead == $fhr[$f] &&  $data[$j][9] eq $var[$v] && $data[$j][11] eq $lev[$v] && $data[$j][16] eq $domain[$d]) {
              for ($i=0; $i<=$#r; $i++) {
                $search_s1[$v][$d][$f][$i]=$data[$j][$i];
              }
            }
        }

     }
   }

}


my $indx_S1;

for ($i=0; $i<=$#r; $i++) {
   if ( $data[0][$i] eq "FCST_LEAD" ) {
     $indx_lead = $i;
  } elsif ( $data[0][$i] eq  "S1" ) {
     $indx_S1 = $i;
  } else {
    ;
  }
}

#print "$indx_S1 $data[0][$indx_S1]  \n";


for ( $v=0; $v<=0; $v++) {
    for ( $d=0; $d<=$#domain; $d++) {
      for ( $f=0; $f<=$#fhr; $f++) {

          if ( $v == 0 ) { # mslp
            #Binbin Z: 20210325, modify for request from CMC not divided by 100
            #$search_s1[$v][$d][$f][$indx_S1]=$search_s1[$v][$d][$f][$indx_S1]/100;
            $search_s1[$v][$d][$f][$indx_S1]=$search_s1[$v][$d][$f][$indx_S1];
          }

         #for ($i=3; $i<=5; $i++) { print "$search_s1[$v][$d][$f][$i] "};
         #for ($i=9; $i<=10; $i++) { print "$search_s1[$v][$d][$f][$i] "};
         #print "$search_s1[$v][$d][$f][14] $search_s1[$v][$d][$f][21] $search_s1[$v][$d][$f][$indx_S1] \n ",

       }
     }

}


#################################################################################################
###
###     VL1L2 for both has-AC or noAC wind vector 
###
####################################################################################################
##
###print "STAT of VL1L2\n";
##

  open ( INFILE, "$infile_vl1l2" );
  $m=0;

  while ( defined( my $one_rec = <INFILE> )) {
    @r  = split( /\s+/, $one_rec );
    for ($i=0; $i<=$#r; $i++) {
     $data[$m][$i]=$r[$i];
    }
    $m++;
  }

  for ($i=0; $i<=$#r; $i++){
     if ( $data[1][$i] ne 'NA' ) {
        $mkr[$i]=1;
     } else {
        $mkr[$i]=0
     }
  }


my @search_vl1l2;

for ( $v=0; $v<=$#var_vl1l2; $v++) {
    for ( $d=0; $d<=$#domain; $d++) {
      for ( $f=0; $f<=$#fhr; $f++) {


        for ($j=1; $j<$m; $j++) {
            my $lead=$data[$j][3]/10000;
            if ( $lead == $fhr[$f] &&  $data[$j][9] eq $var_vl1l2[$v] && $data[$j][11] eq $lev_vl1l2[$v] && $data[$j][16] eq $domain[$d]) {
              for ($i=0; $i<=$#r; $i++) {
                $search_vl1l2[$v][$d][$f][$i]=$data[$j][$i];
              }
            }
        }

     }
   }

}


my $indx_RMSVE;
for ($i=0; $i<=$#r; $i++) {
  if ( $data[0][$i] eq  "RMSVE" ) {
     $indx_RMSVE = $i;
  } else {
    ;
  }
}




################################################################################################
# Output in WMO Report Format 
# ##############################################################################################

my @score_wmo      = qw ( rmse mae me sd ccaf rmsaf rmsav );
my @score_wmo_noAC = qw ( rmse mae me sd );
my @score_wmo_mslp = qw ( rmse mae me sd ccaf rmsaf rmsav s1 );
#my @score_wmo_vl1l2 = qw ( rmsve );
my @score_wmo_vl1l2 = qw ( rmse );

my @score_wmo_indx =       ( $indx_RMSE, $indx_MAE, $indx_ME, $indx_FSTDEV, $indx_AC, $indx_RMSFA, $indx_RMSOA );
my @score_wmo_noAC_indx =  ( $indx_RMSE, $indx_MAE, $indx_ME, $indx_FSTDEV );
my @score_wmo_mslp_indx =  ( $indx_RMSE, $indx_MAE, $indx_ME, $indx_FSTDEV, $indx_AC, $indx_RMSFA, $indx_RMSOA, $indx_S1 );
my @score_wmo_vl1l2_indx = ( $indx_RMSVE );


print "centre=kwbc,ref=an,model=GFS,d=$yyyy$mm,t=$hh, ";

# mlsp 
for ($d=0; $d<=$#domain; $d++) { 
  #SL1L2 types
  for ($s=0; $s<=$#score_wmo_noAC; $s++) {

     print "dom=$dom_wmo[$d],par=mslp,sc=$score_wmo_mslp[$s],";

     if ( $score_wmo_mslp[$s] eq "sd" ) { 
       printf "s=0,v=%4.3f\n", $search_sl1l2[0][$d][0][$indx_OSTDEV];
       for($f=0; $f<=19; $f++) {
         printf "s=%d,v=%4.3f\n", $fhr[$f],$search_sl1l2[0][$d][$f][$score_wmo_mslp_indx[$s]];
       }
     }else {
       printf "s=%d,v=%4.3f\n",$fhr[0],$search_sl1l2[0][$d][0][$score_wmo_mslp_indx[$s]];
       for($f=1; $f<=19; $f++) {
         printf "s=%d,v=%4.3f\n", $fhr[$f],$search_sl1l2[0][$d][$f][$score_wmo_mslp_indx[$s]];
       }
     }
  
  }
  
  #SAL1L2 types
  for ($s=$#score_wmo_noAC+1; $s<=$#score_wmo_mslp-1; $s++) {

     print "dom=$dom_wmo[$d],par=mslp,sc=$score_wmo_mslp[$s],";
     if ( $score_wmo_mslp[$s] eq "ccaf" ) {
       printf "s=%d,v=%4.4f\n", $fhr[0],$search_sal1l2[0][$d][0][$score_wmo_mslp_indx[$s]];
       for($f=1; $f<=19; $f++) {
         printf "s=%d,v=%4.4f\n", $fhr[$f],$search_sal1l2[0][$d][$f][$score_wmo_mslp_indx[$s]];
       }
     }else {
       printf "s=%d,v=%4.3f\n", $fhr[0],$search_sal1l2[0][$d][0][$score_wmo_mslp_indx[$s]];
       for($f=1; $f<=19; $f++) {
         printf "s=%d,v=%4.3f\n", $fhr[$f],$search_sal1l2[0][$d][$f][$score_wmo_mslp_indx[$s]];
       } 
     }
  }
  
  #S1 score
  for ($s=$#score_wmo_mslp; $s<=$#score_wmo_mslp; $s++) {

   print "dom=$dom_wmo[$d],par=mslp,sc=$score_wmo_mslp[$s],";
    #Binbin Z: 20210325, modify for request from CMC not divided by 100, so keep 1 digit after point
    #printf "s=%d,v=%4.3f\n", $fhr[0],$search_s1[0][$d][0][$score_wmo_mslp_indx[$s]];
    printf "s=%d,v=%4.1f\n", $fhr[0],$search_s1[0][$d][0][$score_wmo_mslp_indx[$s]];
   
     for($f=1; $f<=19; $f++) {
       #Binbin Z: 20210325, modify for request from CMC not divided by 100, so keep 1 digit after point
       #printf "s=%d,v=%4.3f\n", $fhr[$f],$search_s1[0][$d][$f][$score_wmo_mslp_indx[$s]];
       printf "s=%d,v=%4.1f\n", $fhr[$f],$search_s1[0][$d][$f][$score_wmo_mslp_indx[$s]];
     }

  }

}

# Other variables: (1) both SAL1L2 and SL1L2 variables 

for ($v=1; $v<=$#var; $v++) {
 for ($d=0; $d<=$#domain; $d++) {

  #SL1L2 types
  for ($s=0; $s<=$#score_wmo_noAC; $s++) {

    if( $score_wmo[$s] eq "rmse" && $var_wmo[$v] =~ /^w/ ) {
      ;
    } else { 
 
      print "dom=$dom_wmo[$d],par=$var_wmo[$v],sc=$score_wmo[$s],";
 
      if ( $score_wmo[$s] eq "sd" ) {
        printf "s=0,v=%4.3f\n", $search_sl1l2[$v][$d][0][$indx_OSTDEV];
        for($f=0; $f<=19; $f++) {
         printf "s=%d,v=%4.3f\n", $fhr[$f],$search_sl1l2[$v][$d][$f][$score_wmo_indx[$s]];
       }

      }else{
        printf "s=%d,v=%4.3f\n", $fhr[0],$search_sl1l2[$v][$d][0][$score_wmo_indx[$s]];
        for($f=1; $f<=19; $f++) {
          printf "s=%d,v=%4.3f\n", $fhr[$f],$search_sl1l2[$v][$d][$f][$score_wmo_indx[$s]];
        }
      }
    }
  }

  #SAL1L2 types
  for ($s=$#score_wmo_noAC+1; $s<=$#score_wmo; $s++) {

     print "dom=$dom_wmo[$d],par=$var_wmo[$v],sc=$score_wmo[$s],";
    
     if($score_wmo[$s] eq "ccaf" ){
       printf "s=%d,v=%4.4f\n", $fhr[0],$search_sal1l2[$v][$d][0][$score_wmo_indx[$s]];
       for($f=1; $f<=19; $f++) {
         printf "s=%d,v=%4.4f\n", $fhr[$f],$search_sal1l2[$v][$d][$f][$score_wmo_indx[$s]];
       }
     }else{
       printf "s=%d,v=%4.3f\n", $fhr[0],$search_sal1l2[$v][$d][0][$score_wmo_indx[$s]];
       for($f=1; $f<=19; $f++) {
         printf "s=%d,v=%4.3f\n", $fhr[$f],$search_sal1l2[$v][$d][$f][$score_wmo_indx[$s]];
       }
     }
  }

 }
}


# Other variables: only SL1L2 variables (i.e. noAC varibles)

for ( $v=0; $v<=$#var_sl1l2_noAC; $v++) {
  for ( $d=0; $d<=$#domain; $d++) {

   for ($s=0; $s<=$#score_wmo_noAC; $s++) {

    if( $score_wmo[$s] eq "rmse" && $var_wmo[$v+$#var+1] =~ /^w/ ) {
     ;
    } else { 

      print "dom=$dom_wmo[$d],par=$var_wmo[$v+$#var+1],sc=$score_wmo[$s],";


      if ( $score_wmo[$s] eq "sd" ) {
        if ($var_wmo[$v+$#var+1] =~ /^r/ ) {
         # RH range from 0 ~ 1
         printf "s=0,v=%4.3f\n", $search_sl1l2[$v+$#var+1][$d][0][$indx_OSTDEV]/100;
        } else {
         printf "s=0,v=%4.3f\n", $search_sl1l2[$v+$#var+1][$d][0][$indx_OSTDEV];
        }
       for($f=0; $f<=19; $f++) {
         if ($var_wmo[$v+$#var+1] =~ /^r/ ) {
          printf "s=%d,v=%4.3f\n", $fhr[$f],$search_sl1l2[$v+$#var+1][$d][$f][$score_wmo_indx[$s]]/100;
         } else {
          printf "s=%d,v=%4.3f\n", $fhr[$f],$search_sl1l2[$v+$#var+1][$d][$f][$score_wmo_indx[$s]];
         }
       }
      }else {
        if ($var_wmo[$v+$#var+1] =~ /^r/ ) {
         printf "s=%d,v=%4.3f\n", $fhr[0],$search_sl1l2[$v+$#var+1][$d][0][$score_wmo_indx[$s]]/100;
        } else {
         printf "s=%d,v=%4.3f\n", $fhr[0],$search_sl1l2[$v+$#var+1][$d][0][$score_wmo_indx[$s]];
        }
       for($f=1; $f<=19; $f++) {
        if ($var_wmo[$v+$#var+1] =~ /^r/ ) {
          printf "s=%d,v=%4.3f\n", $fhr[$f],$search_sl1l2[$v+$#var+1][$d][$f][$score_wmo_indx[$s]]/100;
        } else {
          printf "s=%d,v=%4.3f\n", $fhr[$f],$search_sl1l2[$v+$#var+1][$d][$f][$score_wmo_indx[$s]];
        }
       }
      }
    }

   }
 }
}


#VL1L2 RMSVE

for ( $v=0; $v<=$#var_vl1l2; $v++) {
  for ( $d=0; $d<=$#domain; $d++) {

   for ($s=0; $s<=$#score_wmo_vl1l2; $s++) {

       print "dom=$dom_wmo[$d],par=$var_wmo_vl1l2[$v],sc=$score_wmo_vl1l2[$s],";
       printf "s=%d,v=%4.3f\n", $fhr[0],$search_vl1l2[$v][$d][0][$score_wmo_vl1l2_indx[$s]];

       for($f=1; $f<=19; $f++) {
         printf "s=%d,v=%4.3f\n", $fhr[$f],$search_vl1l2[$v][$d][$f][$score_wmo_vl1l2_indx[$s]];
       }
     }

   }
}

