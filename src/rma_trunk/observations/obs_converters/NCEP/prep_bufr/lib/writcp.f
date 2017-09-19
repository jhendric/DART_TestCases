      SUBROUTINE WRITCP(LUNIT)

C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:    WRITCP
C   PRGMMR: WOOLLEN          ORG: NP20       DATE: 2002-05-14
C
C ABSTRACT: THIS SUBROUTINE SHOULD ONLY BE CALLED WHEN LOGICAL UNIT
C   LUNIT HAS BEEN OPENED FOR OUTPUT OPERATIONS.  IT NOW SIMPLY CALLS
C   BUFR ARCHIVE LIBRARY SUBROUTINE CMPMSG TO TOGGLE ON MESSAGE
C   COMPRESSION, FOLLOWED BY A CALL TO WRITSB TO PACK UP THE CURRENT
C   SUBSET WITHIN MEMORY AND TRY TO ADD IT TO THE COMPRESSED BUFR
C   MESSAGE THAT IS CURRENTLY OPEN WITHIN MEMORY FOR THIS LUNIT,
C   FOLLOWED BY ANOTHER CALL TO CMPMSG TO TOGGLE OFF MESSAGE
C   COMPRESSION.  THIS SUBROUTINE USES THE SAME INPUT AND OUTPUT
C   PARAMETERS AS WRITSB.
C
C PROGRAM HISTORY LOG:
C 2002-05-14  J. WOOLLEN -- ORIGINAL AUTHOR
C 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
C                           INTERDEPENDENCIES
C 2003-11-04  D. KEYSER  -- UNIFIED/PORTABLE FOR WRF; ADDED
C                           DOCUMENTATION (INCLUDING HISTORY); OUTPUTS
C                           MORE COMPLETE DIAGNOSTIC INFO WHEN ROUTINE
C                           TERMINATES ABNORMALLY
C 2005-03-09  J. ATOR    -- MODIFIED TO USE CMPMSG AND WRITSB
C DART $Id: writcp.f 4942 2011-06-02 20:51:48Z thoar $
C
C USAGE:    CALL WRITCP (LUNIT)
C   INPUT ARGUMENT LIST:
C     LUNIT    - INTEGER: FORTRAN LOGICAL UNIT NUMBER FOR BUFR FILE
C
C REMARKS:
C    THIS ROUTINE CALLS:        CMPMSG   WRITSB
C    THIS ROUTINE IS CALLED BY: None
C                               Normally called only by application
C                               programs.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C   MACHINE:  PORTABLE TO ALL PLATFORMS
C
C$$$

      CALL CMPMSG('Y')

      CALL WRITSB(LUNIT)

      CALL CMPMSG('N')

      RETURN
      END
