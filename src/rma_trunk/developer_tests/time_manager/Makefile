# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: Makefile 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

# get the flag settings from the mkmf template directly

include ../../mkmf/mkmf.template

OBJS = types_mod.o utilities_mod.o time_manager_mod.o null_mpi_utilities_mod.o
MODS = types_mod.mod utilities_mod.mod time_manager_mod.mod mpi_utilities_mod.mod
EXES = timetest
LOGS = dart_log.out dart_log.nml

all: $(EXES)

check: $(EXES)
	./timetest

clean:
	rm -fr $(OBJS) $(MODS) $(EXES) timetest.o $(LOGS)

timetest: $(OBJS) timetest.o
	$(FC) -o timetest timetest.o $(OBJS) $(LDFLAGS)

types_mod.o: ../../common/types_mod.f90
	$(FC) -c ../../common/types_mod.f90 $(FFLAGS)

null_mpi_utilities_mod.o: ../../mpi_utilities/null_mpi_utilities_mod.f90 types_mod.o
	$(FC) -c ../../mpi_utilities/null_mpi_utilities_mod.f90 $(FFLAGS)

utilities_mod.o: ../../utilities/utilities_mod.f90 types_mod.o
	$(FC) -c ../../utilities/utilities_mod.f90 $(FFLAGS)

time_manager_mod.o: ../time_manager_mod.f90 utilities_mod.o types_mod.o
	$(FC) -c ../time_manager_mod.f90 $(FFLAGS)

timetest.o: timetest.f90 time_manager_mod.o
	$(FC) -c timetest.f90 $(FFLAGS)

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/developer_tests/time_manager/Makefile $
# $Revision: 11289 $
# $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
