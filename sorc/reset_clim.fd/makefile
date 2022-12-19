#!/bin/sh
#
#  This makefile is to compile ensembel production generator
#  Author: Binbin Zhou, Modifed: Mallory Row
#  OS: Cray WCOSS2

FC=     ifort 
#INC= /nwprod/lib/incmod/g2_4
#LIBS=  -L/nwprod/lib -lip_4 -lw3nco_4 -lw3emc_4  -lbacio_4 -lsp_4 -lg2_4 -ljasper -lpng -lz
INC= ${g2_ROOT}/include_4
LIBS= -L${ip_ROOT}/lib -lip_4  -L${w3nco_ROOT}/lib -lw3nco_4 -L${w3emc_ROOT}/lib -lw3emc_4 -L${bacio_ROOT}/lib -lbacio_4 -L${sp_ROOT}/lib -lsp_8 -L${g2_ROOT}/lib64 -lg2_4 -L${JASPER_ROOT}/lib -ljasper -L${LIBPNG_ROOT}/lib -lpng -L${ZLIB_ROOT}/lib -lz
FFLAGS =        -O3 -g -convert big_endian -I $(INC)
reset.x: 
	$(FC) $(FFLAGS) -o $(@) reset.f $(LIBS)
#

