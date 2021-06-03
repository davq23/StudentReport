      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT FS-STUDENT-INPUT ASSIGN 'INPUT-STUDENT'
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS WS-EOF-SW.
      *
       SELECT FS-STUDENT-OUTPUT ASSIGN 'OUTPUT-STUDENT'
           ORGANIZATION IS SEQUENTIAL
           FILE STATUS IS WS-EOF-SW.
      *
       SELECT FS-STUDENT-WORK ASSIGN 'WORK-STUDENT'
           ORGANIZATION IS SEQUENTIAL.
      *
       SELECT FS-STUDENT-REPORT ASSIGN 'STUDENT-REPORT.txt'
           ORGANIZATION IS LINE SEQUENTIAL.
      **
      **
       DATA DIVISION.
       FILE SECTION.
       FD  FS-STUDENT-INPUT.
       01  FS-STUDENT-IN-RECORD.
           05  STUDENT-ID           PIC 9(05).
           05  STUDENT-NAME         PIC A(30).
           05  STUDENT-LASTNAME     PIC A(30).
           05  STUDENT-GENGRADE     PIC 9(03)V99.
      *
       FD  FS-STUDENT-OUTPUT.
       01  FS-STUDENT-OUT-RECORD.
           05  STUDENT-ID           PIC 9(05).
           05  STUDENT-NAME         PIC A(30).
           05  STUDENT-LASTNAME     PIC A(30).
           05  STUDENT-GENGRADE     PIC 9(03)V99.
      *
      ****************************************************************
      *         Instrumental file for sorting sequential data
      ****************************************************************
       SD  FS-STUDENT-WORK.
       01  FS-STUDENT-WRK-RECORD.
           05  STUDENT-ID           PIC 9(05).
           05  STUDENT-NAME         PIC A(30).
           05  STUDENT-LASTNAME     PIC A(30).
           05  STUDENT-GENGRADE     PIC 9(03)V99.
      *
      ****************************************************************
      *                 Student Report Output file
      ****************************************************************
       FD  FS-STUDENT-REPORT
           RECORDING MODE IS F
           RECORD CONTAINS 75 CHARACTERS.
       01  FS-STUDENT-REP-RECORD.
           05  STUDENT-ID           PIC 9(05).
           05  FILLER               PIC X                   VALUE SPACE.
           05  STUDENT-NAME         PIC X(30).
           05  FILLER               PIC X                   VALUE SPACE.
           05  STUDENT-LASTNAME     PIC X(30).
           05  FILLER               PIC X                   VALUE SPACE.
           05  STUDENT-GENGRADE     PIC ZZ9.999.
      **
      **
       WORKING-STORAGE SECTION.
       01  WS-STUDENT-NUM           PIC 9(5) COMP-3         VALUE 0.
      *
       01  WS-EOF-SW                PIC X(02).
           88  EOF-SW                                       VALUE 10.
      *
       01  WS-FILE-OPEN-STATUS      PIC 9(02).
           88  FILE-NOT-FOUND                               VALUE 35.
           88  FILE-REC-MISMATCH                            VALUE 38.
      *
       01  WS-STUDENT-OUT-RECORD.
           05  STUDENT-ID           PIC 9(05).
           05  FILLER               PIC X(2) VALUE '-.'.
           05  STUDENT-NAME         PIC X(30).
           05  STUDENT-LASTNAME     PIC X(30).
           05  STUDENT-GENGRADE     PIC ZZ9.999.
      *
       01  WS-STUDENT-COMP-RECORD.
           05  STUDENT-GENGRADE     PIC S9(03)V9(03) COMP-3.
      *
       01  WS-STUDENT-COMP-GRADE    PIC S9(03)V9(03) COMP-3  VALUE 0.
      *
       01  WS-STUDENT-REP-HEADER1.
           05  FILLER               PIC X(05)  VALUE 'ID.'.
           05  FILLER               PIC X VALUE SPACE.
           05  FILLER               PIC A(30)  VALUE 'NAME'.
           05  FILLER               PIC X VALUE SPACE.
           05  FILLER               PIC A(30)  VALUE 'LAST NAME'.
           05  FILLER               PIC X VALUE SPACE.
           05  FILLER               PIC X(06)  VALUE 'GRADE'.
      *
       01  WS-STUDENT-REP-HEADER2.
           05  FILLER               PIC X(75)  VALUE ALL '-'.
      **
      **
       PROCEDURE DIVISION.
      ****************************************************************
      *                     Sort students by ID
      ****************************************************************
           SORT FS-STUDENT-WORK
               ON ASCENDING KEY
               STUDENT-ID
               OF      FS-STUDENT-OUT-RECORD
               USING   FS-STUDENT-INPUT
               GIVING  FS-STUDENT-OUTPUT
      *
      ****************************************************************
      *           Open files for input/output operations
      ****************************************************************
           OPEN INPUT  FS-STUDENT-OUTPUT
               OUTPUT  FS-STUDENT-REPORT
      *
           WRITE   FS-STUDENT-REP-RECORD FROM WS-STUDENT-REP-HEADER1
           END-WRITE
      *
           WRITE   FS-STUDENT-REP-RECORD FROM WS-STUDENT-REP-HEADER2
           END-WRITE
      *     
           MOVE    SPACES TO FS-STUDENT-REP-RECORD
      *  
           PERFORM UNTIL EOF-SW
      *
              READ FS-STUDENT-OUTPUT
              NOT AT END
                  MOVE    CORRESPONDING  FS-STUDENT-OUT-RECORD
                      TO  WS-STUDENT-OUT-RECORD
      *
                  MOVE    CORRESPONDING WS-STUDENT-OUT-RECORD
                      TO  FS-STUDENT-REP-RECORD
      *
                  WRITE   FS-STUDENT-REP-RECORD
                  END-WRITE
      *
                  MOVE    CORRESPONDING FS-STUDENT-OUT-RECORD
                      TO WS-STUDENT-COMP-RECORD
      *
                  ADD     STUDENT-GENGRADE OF WS-STUDENT-COMP-RECORD
                      TO  WS-STUDENT-COMP-GRADE
                  END-ADD
      *
                  MOVE    SPACES TO FS-STUDENT-OUT-RECORD
      *
                  ADD 1   TO WS-STUDENT-NUM 
                  END-ADD
      *
              END-READ
      *
           END-PERFORM
      *
           WRITE FS-STUDENT-REP-RECORD
               FROM WS-STUDENT-REP-HEADER2
           END-WRITE
      *
           IF WS-STUDENT-NUM NOT EQUAL 0 THEN
               DIVIDE WS-STUDENT-COMP-GRADE BY WS-STUDENT-NUM
                   GIVING  WS-STUDENT-COMP-GRADE ROUNDED
               END-DIVIDE
           END-IF
      *
           MOVE SPACES TO FS-STUDENT-REP-RECORD
      *     
           MOVE WS-STUDENT-COMP-GRADE TO
               STUDENT-GENGRADE OF FS-STUDENT-REP-RECORD
      *
           MOVE 'AVERAGE GRADE OF ALL STUDENTS' TO
               STUDENT-LASTNAME OF FS-STUDENT-REP-RECORD
      *
           WRITE FS-STUDENT-REP-RECORD END-WRITE
      *
           CLOSE FS-STUDENT-OUTPUT, FS-STUDENT-REPORT
           STOP RUN.
      *
       END PROGRAM MAIN.
