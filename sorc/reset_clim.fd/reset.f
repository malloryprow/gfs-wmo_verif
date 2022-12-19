        Program test

        use grib_mod

        type(gribfield) :: gfld_z500, gfld_z850

       real, allocatable ,dimension(:) :: z500, z850
       character*50 gdss(400)
       integer GRID, kgdss(200), lengds,im,jm,jf
       character*40 fname,outfile
  



       if(GRID.eq.255) then  
         im=240
         jm=121
         jf=im*jm
       else
         call makgds(GRID, kgdss, gdss, lengds, ier)
         im=kgdss(2)
         jm=kgdss(3)
         jf=kgdss(2)*kgdss(3)
       end if

       allocate (z850(jf))
       allocate (z500(jf))

       write(*,*) 'GRID=', GRID, 'jf=',jf

        !fname='clim.t00z.pgrb2.1p50.f000'
        read(*,*) fname 
        write (*,*) 'fname=',fname

        call baopenr(50,fname,ierr)
        write(*,*) 'open ', fname, ' ierr=',ierr

        jpdtn=11    
        jpd1=3
        jpd2=5
        jpd10=100
        jpd12=50000

        call readGB2(50,jpdtn,jpd1,jpd2,jpd10,jpd12,jf,
     +        gfld_z500,ierr)

        jpdtn=8
        jpd1=3
        jpd2=5
        jpd10=100
        jpd12=85000
       

        call readGB2(50,jpdtn,jpd1,jpd2,jpd10,jpd12,jf,
     +        gfld_z850,ierr)

        call baclose(50,ierr)

        outfile=trim(fname)//'.z850'
        call baopen(40,outfile,ierr)
        gfld_z500%ipdtmpl(12)=85000
        gfld_z500%fld(:)=gfld_z850%fld(:)
        call putgb2(40,gfld_z500,ierr)
        call baclose(40,ierr)

      stop
      end


      subroutine readGB2(iunit,jpdtn,jpd1,jpd2,jpd10,jpd12,jf,gfld,
     +           iret)

        use grib_mod

        type(gribfield) :: gfld
 
        integer jids(200), jpdt(200), jgdt(200)
        integer jpd1,jpd2,jpd10,jpd12,jpdtn,jf
        logical :: unpack=.true. 

        jids=-9999  !array define center, master/local table, year,month,day, hour, etc, -9999 wildcard to accept any
        jpdt=-9999  !array define Product, to be determined
        jgdt=-9999  !array define Grid , -9999 wildcard to accept any

        jdisc=-1    !discipline#  -1 wildcard 
        jgdtn=-1    !grid template number,    -1 wildcard 
        jskp=0      !Number of fields to be skip, 0 search from beginning

        jpdt(1)=jpd1   !Category #     
        jpdt(2)=jpd2   !Product # under this category     
        jpdt(10)=jpd10
        jpdt(12)=jpd12
        ! jpdtn=-1     !tested, but got wrong results      

         call getgb2(iunit,0,jskp, jdisc,jids,jpdtn,jpdt,jgdtn,jgdt,
     +        unpack, jskp1, gfld,iret)
          write(*,*) 'call getgb2 iret=',iret
         

         IF (IRET.NE.0) THEN
           IF (IRET.EQ.99)WRITE(6,'(A)')' GETGB2P: ERROR REQUEST NOT'
     &          //' FOUND'
          return
         END IF 


        return
        end 
        
 
      subroutine packGB2(imean,vrbl,jpd1,jpd2,jpd10,jpd12,jf,
     +     gfld)

        use grib_mod

        type(gribfield) :: gfld


         INTEGER,intent(IN) :: imean,
     +     jpd1,jpd2,jpd10,jpd12,jf

        REAL,dimension(jf),intent(IN) :: vrbl

        INTEGER,allocatable,dimension(:) ::   ipdtmpl


        write(*,*) imean
     +     jpd1,jpd2,jpd10,jpd12,jf


            !redefine some of gfld%idsect() array elements 
            gfld%idsect(1)=7
            gfld%idsect(2)=2
            gfld%idsect(3)=0   !experimental, see Table 1.0
            gfld%idsect(4)=1   !experimental, see Table 1.1
            gfld%idsect(5)=1   !experimental, see Table 1.2
            !gfld%idsect(6)=iyr  !year
            !gfld%idsect(7)=imon !mon
            !gfld%idsect(8)=idy  !day
            !gfld%idsect(9)=ihr  !cycle time
            gfld%idsect(10)=0
            gfld%idsect(11)=0
            gfld%idsect(12)=0
            gfld%idsect(13)=1



            if (jpd1.eq.1.and.jpd2.eq.8 ) then  
             ipdtnum=12                  !ensemble APCP mean use Template 4.12
             ipdtlen=31
            else 
             ipdtnum=2                   !ensemble NON-accum mean use Template 4.2
             ipdtlen=17
            end if

            allocate (ipdtmpl(ipdtlen))

             ipdtmpl(1)=jpd1
             ipdtmpl(2)=jpd2
             ipdtmpl(3)=4
             ipdtmpl(4)=0
             ipdtmpl(5)=117              !shared with NARRE-TL suggested by Tom Hultquist
             ipdtmpl(6)=0
             ipdtmpl(7)=0
             ipdtmpl(8)=1
             !ipdtmpl(9)=ifhr             !fcst time    
             ipdtmpl(10)=jpd10
             ipdtmpl(11)=gfld%ipdtmpl(11)
             ipdtmpl(13)=gfld%ipdtmpl(13)
             ipdtmpl(14)=gfld%ipdtmpl(14)
             ipdtmpl(15)=gfld%ipdtmpl(15)
             ipdtmpl(16)=1               !weighted mean of all members
             !ipdtmpl(17)=iens            !number of members
             ipdtmpl(17)=10             !number of members
         
            if (jpd1.eq.1.and.jpd2.eq.8 ) then  !Template 4.12 has extra elements than Template 4.2
              ipdtmpl(18)=iyr   !year
              ipdtmpl(19)=imon  !mon 
              ipdtmpl(20)=idy   !day
              ipdtmpl(9) =ihr+ifhr-jpd27    !overwrite for APCP: Beginning time of accumulation
              ipdtmpl(21)=ihr+ifhr         !end time of accumulation   
              ipdtmpl(22)=0   
              ipdtmpl(23)=0  
              ipdtmpl(24)=1   
              ipdtmpl(25)=0   
              ipdtmpl(26)=1   
              ipdtmpl(27)=2                 !See Table 4.11, same start time (or same cycle time) 
              ipdtmpl(28)=1  
              ipdtmpl(29)=jpd27 
              ipdtmpl(30)=1
              ipdtmpl(31)=0   
             end if
 

          if(jpd10.eq.100) then
             ipdtmpl(12)=jpd12*100
          else
             ipdtmpl(12)=jpd12
          end if

          gfld%fld=vrbl 

          iret=0
          !write(*,*) 'ipdtnum, ipdtlen=',ipdtnum, ipdtlen
          !do k=1,ipdtlen
          !  write(*,*) k, ipdtmpl(k)
          !end do

          call Zputgb2(imean,gfld,ipdtmpl,ipdtnum,ipdtlen,iret)
          if(iret.ne.0) then
           write(*,*) 'Zputgb2 mean error:',iret
          end if


        return
        end


C-----------------------------------------------------------------------
      SUBROUTINE ZPUTGB2(LUGB,GFLD,ipdtmpl,ipdtnum,ipdtlen,IRET)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM: PUTGB2         PACKS AND WRITES A GRIB2 MESSAGE
C   PRGMMR: GILBERT          ORG: W/NP11     DATE: 2002-04-22
C
C ABSTRACT: PACKS A SINGLE FIELD INTO A GRIB2 MESSAGE
C   AND WRITES OUT THAT MESSAGE TO THE FILE ASSOCIATED WITH UNIT LUGB.
C   NOTE THAT FILE/UNIT LUGB SHOULD BE OPENED WOTH A CALL TO 
C   SUBROUTINE BAOPENW BEFORE THIS ROUTINE IS CALLED.
C
C   The information to be packed into the GRIB field
C   is stored in a derived type variable, gfld.
C   Gfld is of type gribfield, which is defined
C   in module grib_mod, so users of this routine will need to include
C   the line "USE GRIB_MOD" in their calling routine.  Each component of the
C   gribfield type is described in the INPUT ARGUMENT LIST section below.
C
C PROGRAM HISTORY LOG:
C 2002-04-22  GILBERT  
C 2005-02-28  GILBERT   - Changed dimension of array cgrib to be a multiple
C                         of gfld%ngrdpts instead of gfld%ndpts.
C 2009-03-10  VUONG     - Initialize variable coordlist
C 2011-06-09  VUONG     - Initialize variable gfld%list_opt
C 2012-02-28  VUONG     - Initialize variable ilistopt
C 2013-04-10  BINBIN    - Modified to change size of ipdtmpl
C                         for ensemble product generator
C
C USAGE:    CALL PUTGB2(LUGB,GFLD,ipdtmpl,ipdtnum,ipdtlen,IRET)
C   INPUT ARGUMENTS:
C     ipdtmpl      Prodoct ID array associated Product Template 4.ipdtnum
C     ipdtnum      Product Template # 4.ipdtnum 
C     ipdtlen      Size of Array ipdtmpl() 
C
C     LUGB         INTEGER UNIT OF THE UNBLOCKED GRIB DATA FILE.
C                  FILE MUST BE OPENED WITH BAOPEN OR BAOPENW BEFORE CALLING 
C                  THIS ROUTINE.
C     gfld - derived type gribfield ( defined in module grib_mod )
C            ( NOTE: See Remarks Section )
C        gfld%version = GRIB edition number ( currently 2 )
C        gfld%discipline = Message Discipline ( see Code Table 0.0 )
C        gfld%idsect() = Contains the entries in the Identification
C                        Section ( Section 1 )
C                        This element is actually a pointer to an array
C                        that holds the data.
C            gfld%idsect(1)  = Identification of originating Centre
C                                    ( see Common Code Table C-1 )
C                             7 - US National Weather Service
C            gfld%idsect(2)  = Identification of originating Sub-centre
C            gfld%idsect(3)  = GRIB Master Tables Version Number
C                                    ( see Code Table 1.0 )
C                             0 - Experimental
C                             1 - Initial operational version number
C            gfld%idsect(4)  = GRIB Local Tables Version Number
C                                    ( see Code Table 1.1 )
C                             0     - Local tables not used
C                             1-254 - Number of local tables version used
C            gfld%idsect(5)  = Significance of Reference Time (Code Table 1.2)
C                             0 - Analysis
C                             1 - Start of forecast
C                             2 - Verifying time of forecast
C                             3 - Observation time
C            gfld%idsect(6)  = Year ( 4 digits )
C            gfld%idsect(7)  = Month
C            gfld%idsect(8)  = Day
C            gfld%idsect(9)  = Hour
C            gfld%idsect(10)  = Minute
C            gfld%idsect(11)  = Second
C            gfld%idsect(12)  = Production status of processed data
C                                    ( see Code Table 1.3 )
C                              0 - Operational products
C                              1 - Operational test products
C                              2 - Research products
C                              3 - Re-analysis products
C            gfld%idsect(13)  = Type of processed data ( see Code Table 1.4 )
C                              0  - Analysis products
C                              1  - Forecast products
C                              2  - Analysis and forecast products
C                              3  - Control forecast products
C                              4  - Perturbed forecast products
C                              5  - Control and perturbed forecast products
C                              6  - Processed satellite observations
C                              7  - Processed radar observations
C        gfld%idsectlen = Number of elements in gfld%idsect().
C        gfld%local() = Pointer to character array containing contents
C                       of Local Section 2, if included
C        gfld%locallen = length of array gfld%local()
C        gfld%ifldnum = field number within GRIB message
C        gfld%griddef = Source of grid definition (see Code Table 3.0)
C                      0 - Specified in Code table 3.1
C                      1 - Predetermined grid Defined by originating centre
C        gfld%ngrdpts = Number of grid points in the defined grid.
C        gfld%numoct_opt = Number of octets needed for each
C                          additional grid points definition.
C                          Used to define number of
C                          points in each row ( or column ) for
C                          non-regular grids.
C                          = 0, if using regular grid.
C        gfld%interp_opt = Interpretation of list for optional points
C                          definition.  (Code Table 3.11)
C        gfld%igdtnum = Grid Definition Template Number (Code Table 3.1)
C        gfld%igdtmpl() = Contains the data values for the specified Grid
C                         Definition Template ( NN=gfld%igdtnum ).  Each
C                         element of this integer array contains an entry (in
C                         the order specified) of Grid Defintion Template 3.NN
C                         This element is actually a pointer to an array
C                         that holds the data.
C        gfld%igdtlen = Number of elements in gfld%igdtmpl().  i.e. number of
C                       entries in Grid Defintion Template 3.NN
C                       ( NN=gfld%igdtnum ).
C        gfld%list_opt() = (Used if gfld%numoct_opt .ne. 0)  This array
C                          contains the number of grid points contained in
C                          each row ( or column ).  (part of Section 3)
C                          This element is actually a pointer to an array
C                          that holds the data.  This pointer is nullified
C                          if gfld%numoct_opt=0.
C        gfld%num_opt = (Used if gfld%numoct_opt .ne. 0)  The number of entries
C                       in array ideflist.  i.e. number of rows ( or columns )
C                       for which optional grid points are defined.  This value
C                       is set to zero, if gfld%numoct_opt=0.
C        gfdl%ipdtnum = Product Definition Template Number (see Code Table 4.0)
C        gfld%ipdtmpl() = Contains the data values for the specified Product
C                         Definition Template ( N=gfdl%ipdtnum ).  Each element
C                         of this integer array contains an entry (in the
C                         order specified) of Product Defintion Template 4.N.
C                         This element is actually a pointer to an array
C                         that holds the data.
C        gfld%ipdtlen = Number of elements in gfld%ipdtmpl().  i.e. number of
C                       entries in Product Defintion Template 4.N
C                       ( N=gfdl%ipdtnum ).
C        gfld%coord_list() = Real array containing floating point values
C                            intended to document the vertical discretisation
C                            associated to model data on hybrid coordinate
C                            vertical levels.  (part of Section 4)
C                            This element is actually a pointer to an array
C                            that holds the data.
C        gfld%num_coord = number of values in array gfld%coord_list().
C        gfld%ndpts = Number of data points unpacked and returned.
C        gfld%idrtnum = Data Representation Template Number
C                       ( see Code Table 5.0)
C        gfld%idrtmpl() = Contains the data values for the specified Data
C                         Representation Template ( N=gfld%idrtnum ).  Each
C                         element of this integer array contains an entry
C                         (in the order specified) of Product Defintion
C                         Template 5.N.
C                         This element is actually a pointer to an array
C                         that holds the data.
C        gfld%idrtlen = Number of elements in gfld%idrtmpl().  i.e. number
C                       of entries in Data Representation Template 5.N
C                       ( N=gfld%idrtnum ).
C        gfld%unpacked = logical value indicating whether the bitmap and
C                        data values were unpacked.  If false,
C                        gfld%bmap and gfld%fld pointers are nullified.
C        gfld%ibmap = Bitmap indicator ( see Code Table 6.0 )
C                     0 = bitmap applies and is included in Section 6.
C                     1-253 = Predefined bitmap applies
C                     254 = Previously defined bitmap applies to this field
C                     255 = Bit map does not apply to this product.
C        gfld%bmap() = Logical*1 array containing decoded bitmap,
C                      if ibmap=0 or ibap=254.  Otherwise nullified.
C                      This element is actually a pointer to an array
C                      that holds the data.
C        gfld%fld() = Array of gfld%ndpts unpacked data points.
C                     This element is actually a pointer to an array
C                     that holds the data.
C
C   OUTPUT ARGUMENTS:
C     IRET         INTEGER RETURN CODE
C                    0      ALL OK
C                    2      MEMORY ALLOCATION ERROR
C                    10     No Section 1 info available
C                    11     No Grid Definition Template info available
C                    12     Missing some required data field info
C
C SUBPROGRAMS CALLED:
C   gribcreate     Start a new grib2 message
C   addlocal       Add local section to a GRIB2 message
C   addgrid        Add grid info to a GRIB2 message
C   addfield       Add data field to a GRIB2 message
C   gribend        End GRIB2 message
C
C REMARKS: 
C
C   Note that derived type gribfield contains pointers to many
C   arrays of data.  The memory for these arrays is allocated
C   when the values in the arrays are set, to help minimize
C   problems with array overloading.  Because of this users
C   are encouraged to free up this memory, when it is no longer
C   needed, by an explicit call to subroutine gf_free.
C   ( i.e.   CALL GF_FREE(GFLD) )
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 90
C
C$$$
      USE GRIB_MOD

      INTEGER,INTENT(IN) :: LUGB
      TYPE(GRIBFIELD),INTENT(IN) :: GFLD
      INTEGER,INTENT(OUT) :: IRET

      CHARACTER(LEN=1),ALLOCATABLE,DIMENSION(:) :: CGRIB
      integer :: listsec0(2)=(/0,2/)
      integer :: igds(5)=(/0,0,0,0,0/)
      real    :: coordlist=0.0
      integer :: ilistopt=0

      integer ipdtmpl(ipdtlen)

C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  ALLOCATE ARRAY FOR GRIB2 FIELD
      lcgrib=gfld%ngrdpts*4
      allocate(cgrib(lcgrib),stat=is)
      if ( is.ne.0 ) then
         print *,'putgb2: cannot allocate memory. ',is
         iret=2
      endif
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  CREATE NEW MESSAGE
      listsec0(1)=gfld%discipline
      listsec0(2)=gfld%version
      if ( associated(gfld%idsect) ) then
         call gribcreate(cgrib,lcgrib,listsec0,gfld%idsect,ierr)
         if (ierr.ne.0) then
            write(6,*) 'putgb2: ERROR creating new GRIB2 field = ',ierr
         endif
      else
         print *,'putgb2: No Section 1 info available. '
         iret=10
         deallocate(cgrib)
         return
      endif

C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  ADD LOCAL USE SECTION TO GRIB2 MESSAGE
      if ( associated(gfld%local).AND.gfld%locallen.gt.0 ) then
         call addlocal(cgrib,lcgrib,gfld%local,gfld%locallen,ierr)
         if (ierr.ne.0) then
            write(6,*) 'putgb2: ERROR adding local info = ',ierr
         endif
      endif

C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  ADD GRID TO GRIB2 MESSAGE
      igds(1)=gfld%griddef
      igds(2)=gfld%ngrdpts
      igds(3)=gfld%numoct_opt
      igds(4)=gfld%interp_opt
      igds(5)=gfld%igdtnum
      if ( associated(gfld%igdtmpl) ) then
         call addgrid(cgrib,lcgrib,igds,gfld%igdtmpl,gfld%igdtlen,
     &                ilistopt,gfld%num_opt,ierr)
         if (ierr.ne.0) then
            write(6,*) 'putgb2: ERROR adding grid info = ',ierr
         endif
      else
         print *,'putgb2: No GDT info available. '
         iret=11
         deallocate(cgrib)
         return
      endif

      !write(*,*) 'In Zpugb2: before addfield ' 
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  ADD DATA FIELD TO GRIB2 MESSAGE
      if ( associated(gfld%ipdtmpl).AND.
     &     associated(gfld%idrtmpl).AND.
     &     associated(gfld%fld) ) then

         !write(*,*) ipdtnum
         !write(*,*) ipdtmpl
         !write(*,*) ipdtlen
         !write(*,*) gfld%num_coord
         !write(*,*) gfld%idrtnum
         !write(*,*) gfld%idrtmpl
         !write(*,*) gfld%idrtlen
         !write(*,*) gfld%fld(10000)
         !write(*,*) gfld%ngrdpts
         !Ceiling mean (derived) still stuck here

         call addfield(cgrib,lcgrib,ipdtnum,ipdtmpl,           !Modified by Binbin Zhou
     &                 ipdtlen,coordlist,gfld%num_coord,
     &                 gfld%idrtnum,gfld%idrtmpl,gfld%idrtlen,
     &                 gfld%fld,gfld%ngrdpts,gfld%ibmap,gfld%bmap,
     &                 ierr)
         if (ierr.ne.0) then
            write(6,*) 'putgb2: ERROR adding data field = ',ierr
         endif
      else
         print *,'putgb2: Missing some field info. '
         iret=12
         deallocate(cgrib)
         return
      endif

      !write(*,*) 'In Zpugb2: ok3 here'

C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  CLOSE GRIB2 MESSAGE AND WRITE TO FILE
      call gribend(cgrib,lcgrib,lengrib,ierr)
      call wryte(lugb,lengrib,cgrib)
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      deallocate(cgrib)


      RETURN
      END
