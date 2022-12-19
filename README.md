# gfs-wmo_verif

This code is used to run the daily and monthly WMO verification jobs for the operational GFS. The reports produced from this verification get sent to WMO.

Set up:
Change directories to gfs-wmo_verif (cd gfs-wmo_verif)
Link the fix files from /lfs/h2/emc/vpppg/noscrub/emc.vpppg/verification/global/gfs-wmo_verif_fix as fix (ln -sf /lfs/h2/emc/vpppg/noscrub/emc.vpppg/verification/global/gfs-wmo_verif_fix fix)

Run:
The script to run is in gfs-wmo_verif/ecf. Make sure the configuration is set up as needed. Then submit the job to the queue using "qsub".
