      SUBROUTINE MVB(IB1,NB1,IB2,NB2,NBM)

C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:    MVB
C   PRGMMR: WOOLLEN          ORG: NP20       DATE: 1994-01-06
C
C ABSTRACT: THIS SUBROUTINE COPIES A SPECIFIED NUMBER OF BYTES FROM
C   ONE PACKED BINARY ARRAY TO ANOTHER.
C
C PROGRAM HISTORY LOG:
C 1994-01-06  J. WOOLLEN -- ORIGINAL AUTHOR
C 1998-07-08  J. WOOLLEN -- REPLACED CALL TO CRAY LIBRARY ROUTINE
C                           "ABORT" WITH CALL TO NEW INTERNAL BUFRLIB
C                           ROUTINE "BORT"
C 1998-10-27  J. WOOLLEN -- MODIFIED TO CORRECT PROBLEMS CAUSED BY IN-
C                           LINING CODE WITH FPP DIRECTIVES
C 2002-05-14  J. WOOLLEN -- REMOVED OLD CRAY COMPILER DIRECTIVES
C 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
C                           INTERDEPENDENCIES
C 2003-11-04  D. KEYSER  -- UNIFIED/PORTABLE FOR WRF; ADDED
C                           DOCUMENTATION (INCLUDING HISTORY); OUTPUTS
C                           MORE COMPLETE DIAGNOSTIC INFO WHEN ROUTINE
C                           TERMINATES ABNORMALLY
C 2005-11-29  J. ATOR    -- MAXIMUM NUMBER OF BYTES TO COPY INCREASED
C                           FROM 24000 TO MXIMB
C DART $Id: mvb.f 4942 2011-06-02 20:51:48Z thoar $
C
C USAGE:    CALL MVB (IB1, NB1, IB2, NB2, NBM)
C   INPUT ARGUMENT LIST:
C     IB1      - INTEGER: *-WORD PACKED INPUT BINARY ARRAY
C     NB1      - INTEGER: POINTER TO FIRST BYTE IN IB1 TO COPY FROM
C     NB2      - INTEGER: POINTER TO FIRST BYTE IN IB2 TO COPY TO
C     NBM      - INTEGER: NUMBER OF BYTES TO COPY 
C
C   OUTPUT ARGUMENT LIST:
C     IB2      - INTEGER: *-WORD PACKED OUTPUT BINARY ARRAY
C
C REMARKS:
C    THIS ROUTINE CALLS:        BORT     PKB      UPB
C    THIS ROUTINE IS CALLED BY: CNVED4   CPYUPD   MSGUPD   STNDRD
C                               SUBUPD
C                               Normally not called by any application
C                               programs.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C   MACHINE:  PORTABLE TO ALL PLATFORMS
C
C$$$

      INCLUDE 'bufrlib.prm'

      CHARACTER*128 BORT_STR
      DIMENSION     IB1(*),IB2(*),NVAL(MXIMB)

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

      IF(NBM.GT.MXIMB) GOTO 900
      JB1 = 8*(NB1-1)
      JB2 = 8*(NB2-1)

      DO N=1,NBM
      CALL UPB(NVAL(N),8,IB1,JB1)
      ENDDO

      DO N=1,NBM
      CALL PKB(NVAL(N),8,IB2,JB2)
      ENDDO

C  EXITS
C  -----

      RETURN
900   WRITE(BORT_STR,'("BUFRLIB: MVB - THE NUMBER OF BYTES BEING '//
     . 'REQUESTED TO COPY (",I7,") EXCEEDS THE LIMIT (",I7,")")')
     . NBM, MXIMB
      CALL BORT(BORT_STR)
      END