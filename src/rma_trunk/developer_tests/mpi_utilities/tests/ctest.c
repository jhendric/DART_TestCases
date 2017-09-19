/* 
 * DART software - Copyright UCAR. This open source software is provided
 * by UCAR, "as is", without charge, subject to all terms of use at
 * http://www.image.ucar.edu/DAReS/DART/DART_download
 *
 * DART $Id: ctest.c 10998 2017-02-03 22:23:13Z thoar@ucar.edu $
 */

/* A simple "c" program - no mpi calls, no netCDF - to test you have a      */
/* working c compiler.                                                      */
/*                                                                          */
/* DART contains no c code, but if you are having problems with either the  */
/* MPI or netCDF libraries and you want to diagnose whether the problem is  */
/* with the entire installation or with just the F90 interfaces, these      */
/* c programs will allow you to test the c interfaces for mpi and netCDF.   */

#include <stdlib.h>
#include <stdio.h>

main(int argc, char **argv)
{
   int i, j;

   i = 2;
   j = 3;

   printf("2 + 3 = %d\n", i+j);

   printf("'c' program ran successfully\n");

   exit(0);
}

/* <next few lines under version control, do not edit>
 * $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/developer_tests/mpi_utilities/tests/ctest.c $
 * $Revision: 10998 $
 * $Date: 2017-02-03 15:23:13 -0700 (Fri, 03 Feb 2017) $
 */
