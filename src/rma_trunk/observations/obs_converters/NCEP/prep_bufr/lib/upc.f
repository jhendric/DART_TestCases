      SUBROUTINE UPC(CHR,NCHR,IBAY,IBIT)

C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:    UPC
C   PRGMMR: WOOLLEN          ORG: NP20       DATE: 1994-01-06
C
C ABSTRACT: THIS SUBROUTINE UNPACKS AND RETURNS A CHARACTER STRING OF
C   LENGTH NCHR CONTAINED WITHIN NCHR BYTES OF IBAY, STARTING WITH BIT
C   (IBIT+1).  ON OUTPUT, IBIT IS UPDATED TO POINT TO THE LAST BIT THAT
C   WAS UNPACKED.  NOTE THAT THE STRING TO BE UNPACKED DOES NOT
C   NECESSARILY NEED TO BE ALIGNED ON A BYTE BOUNDARY WITHIN IBAY.
C
C PROGRAM HISTORY LOG:
C 1994-01-06  J. WOOLLEN -- ORIGINAL AUTHOR
C 2003-11-04  J. ATOR    -- ADDED DOCUMENTATION
C 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
C                           INTERDEPENDENCIES
C 2003-11-04  D. KEYSER  -- UNIFIED/PORTABLE FOR WRF; ADDED HISTORY
C                           DOCUMENTATION
C DART $Id: upc.f 4942 2011-06-02 20:51:48Z thoar $
C
C USAGE:    CALL UPC (CHR, NCHR, IBAY, IBIT)
C   INPUT ARGUMENT LIST:
C     NCHR     - INTEGER: NUMBER OF BYTES OF IBAY WITHIN WHICH TO
C                UNPACK CHR (I,E, THE NUMBER OF CHARACTERS IN CHR)
C     IBAY     - INTEGER: *-WORD PACKED BINARY ARRAY CONTAINING PACKED
C                CHR
C     IBIT     - INTEGER: BIT POINTER WITHIN IBAY INDICATING BIT AFTER
C                WHICH TO START UNPACKING
C
C   OUTPUT ARGUMENT LIST:
C     CHR      - CHARACTER*(*): UNPACKED CHARACTER STRING OF LENGTH
C                NCHR
C     IBIT     - INTEGER: BIT POINTER WITHIN IBAY INDICATING LAST BIT
C                THAT WAS UNPACKED
C
C REMARKS:
C    THIS SUBROUTINE IS THE INVERSE OF BUFR ARCHIVE LIBRARY ROUTINE
C    PKC.
C
C    THIS ROUTINE CALLS:        IPKM     IUPM     UPB
C    THIS ROUTINE IS CALLED BY: RDCMPS   RDTREE   READLC   STNDRD
C                               UFBGET   UFBTAB   UFBTAM   WRCMPS   
C                               Normally not called by any application
C                               programs.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C   MACHINE:  PORTABLE TO ALL PLATFORMS
C
C$$$

      COMMON /CHARAC/ IASCII,IATOE(0:255),IETOA(0:255)
      COMMON /HRDWRD/ NBYTW,NBITW,NREV,IORD(8)

      CHARACTER*(*) CHR
      CHARACTER*8   CVAL
      DIMENSION     IBAY(*),IVAL(2)
      EQUIVALENCE   (CVAL,IVAL)

C----------------------------------------------------------------------
C----------------------------------------------------------------------

      LB = IORD(NBYTW)
      DO I=1,NCHR
      CALL UPB(IVAL(1),8,IBAY,IBIT)
      CHR(I:I) = CVAL(LB:LB)
      IF(IASCII.EQ.0) CALL IPKM(CHR(I:I),1,IATOE(IUPM(CHR(I:I),8)))
      ENDDO

      RETURN
      END
