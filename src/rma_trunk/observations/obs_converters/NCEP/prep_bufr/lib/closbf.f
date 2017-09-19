      SUBROUTINE CLOSBF(LUNIT)

C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:    CLOSBF
C   PRGMMR: WOOLLEN          ORG: NP20       DATE: 1994-01-06
C
C ABSTRACT: THIS SUBROUTINE IS CALLED IN ORDER TO TERMINATE BUFR
C   ARCHIVE LIBRARY SOFTWARE ACCESS TO A LOGICAL UNIT LUNIT FOR INPUT
C   OR OUTPUT OPERATIONS (PREVIOUSLY OPENED BY A FORTRAN "OPEN" ON THE
C   LOGICAL UNIT AND BY BUFR ARCHIVE LIBRARY SUBROUTINE OPENBF).
C   CLOSBF MUST BE CALLED WHEN LUNIT IS CONNECTED TO A BUFR FILE OPEN
C   FOR OUTPUT IN ORDER TO PROPERLY CLOSE AND WRITE ANY CURRENT BUFR
C   MESSAGE WHICH MAY STILL EXIST IN INTERNAL MEMORY (AND MOST LIKELY
C   NOT BE FULL).  IT IS NOT MANDATORY THAT CLOSBF BE CALLED WHEN LUNIT
C   IS CONNECTED TO A BUFR FILE OPEN FOR INPUT, BUT IT IS STILL A GOOD
C   IDEA TO DO SO.
C
C PROGRAM HISTORY LOG:
C 1994-01-06  J. WOOLLEN -- ORIGINAL AUTHOR
C 2003-11-04  J. ATOR    -- DON'T CLOSE LUNIT IF OPENED AS A NULL FILE
C                           BY OPENBF {NULL(LUN) = 1 IN NEW COMMON
C                           BLOCK /NULBFR/} (WAS IN DECODER VERSION)
C 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
C                           INTERDEPENDENCIES
C 2003-11-04  D. KEYSER  -- UNIFIED/PORTABLE FOR WRF; ADDED
C                           DOCUMENTATION (INCLUDING HISTORY)
C DART $Id: closbf.f 4942 2011-06-02 20:51:48Z thoar $
C
C USAGE:    CALL CLOSBF (LUNIT)
C   INPUT ARGUMENT LIST:
C     LUNIT    - INTEGER: FORTRAN LOGICAL UNIT NUMBER FOR BUFR FILE
C
C   INPUT FILES:
C     UNIT "LUNIT"  - BUFR FILE
C
C   OUTPUT FILES:
C     UNIT "LUNIT"  - BUFR FILE
C
C REMARKS:
C    THIS ROUTINE CALLS:        CLOSMG   STATUS   WTSTAT
C    THIS ROUTINE IS CALLED BY: UFBINX   UFBMEM   UFBTAB
C                               Also called by application programs.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C   MACHINE:  PORTABLE TO ALL PLATFORMS
C
C$$$

      INCLUDE 'bufrlib.prm'

      COMMON /NULBFR/ NULL(NFILES)

      CALL STATUS(LUNIT,LUN,IL,IM)
      IF(IL.GT.0 .AND. IM.NE.0) CALL CLOSMG(LUNIT)
      CALL WTSTAT(LUNIT,LUN,0,0)

C  CLOSE LUNIT IF NULL(LUN) = 0
C  ----------------------------

      IF(NULL(LUN).EQ.0) CLOSE(LUNIT)

      RETURN
      END
