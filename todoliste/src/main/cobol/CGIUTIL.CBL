       IDENTIFICATION DIVISION.
       PROGRAM-ID. CGIUTIL.

       WORKING-STORAGE SECTION.
       01 TEMP-FIELDS.
           05 FIRST-PARAMETER-PAIR PIC X(2000).
           05 REMAINDING-PARAMETERS PIC X(2000).
           05 CURRENT-PARAMETER-NAME PIC X(2000).
           05 CURRENT-PARAMETER-VALUE PIC X(2000).
           05 PARAMETER-FOUND-SWITCH PIC X VALUE ZERO.
               88 PARAMETER-NOT-FOUND VALUE 0.
               88 PARAMETER-FOUND VALUE 1.
           05 NO-PARAMETER-REMAINDING-SWITCH PIC X VALUE ZERO.
               88 PARAMETER-REMAINDING VALUE 0.
               88 NO-PARAMETER-REMAINDING VALUE 1.
           05 COUNTER PIC 9(5).
           05 CURRENT-AMPERSAND-POSITION PIC 9(5).
           05 LENGTH-OF-TARGET PIC 9(05).

       LINKAGE SECTION.
       COPY cgiutildata.

      * -------------------------------------------------------------- *

       PROCEDURE DIVISION USING REQUEST-PARAMETERS.

           PERFORM PARSE-PARAMETER
           GOBACK.

      * -------------------------------------------------------------- *

       SPLIT-ON-AMPERSAND SECTION.

           INITIALIZE CURRENT-AMPERSAND-POSITION
               FIRST-PARAMETER-PAIR REMAINDING-PARAMETERS

           PERFORM VARYING COUNTER FROM 1 BY 1 UNTIL
               COUNTER > LENGTH OF REQUEST-STRING

               EVALUATE REQUEST-STRING(COUNTER:1)
                   WHEN "&"
                       MOVE COUNTER TO CURRENT-AMPERSAND-POSITION
                       EXIT PERFORM
                   WHEN SPACES
                       EXIT PERFORM
                   WHEN OTHER
                       CONTINUE
               END-EVALUATE

           END-PERFORM

           IF CURRENT-AMPERSAND-POSITION = ZERO THEN

               IF REQUEST-STRING = SPACES
                   SET NO-PARAMETER-REMAINDING TO TRUE
               ELSE
                   MOVE REQUEST-STRING TO FIRST-PARAMETER-PAIR
               END-IF

           ELSE

               MOVE REQUEST-STRING (1:CURRENT-AMPERSAND-POSITION - 1)
                   TO FIRST-PARAMETER-PAIR

               COMPUTE LENGTH-OF-TARGET = LENGTH OF REQUEST-STRING

               MOVE REQUEST-STRING
                   (CURRENT-AMPERSAND-POSITION + 1 : LENGTH-OF-TARGET)
                   TO REMAINDING-PARAMETERS

           END-IF

           EXIT.

      * -------------------------------------------------------------- *

       CHECK-PARAMETER-PAIR SECTION.

           UNSTRING FIRST-PARAMETER-PAIR DELIMITED BY "="
               INTO CURRENT-PARAMETER-NAME CURRENT-PARAMETER-VALUE

           IF CURRENT-PARAMETER-NAME = PARAMETER-NAME THEN

               SET PARAMETER-FOUND TO TRUE
               MOVE CURRENT-PARAMETER-VALUE TO PARAMETER-VALUE

           END-IF

           EXIT.

      * -------------------------------------------------------------- *

       PARSE-PARAMETER SECTION.

           INITIALIZE TEMP-FIELDS PARAMETER-VALUE

           PERFORM WITH TEST AFTER UNTIL

               NO-PARAMETER-REMAINDING OR PARAMETER-FOUND
               PERFORM SPLIT-ON-AMPERSAND
               PERFORM CHECK-PARAMETER-PAIR
               MOVE REMAINDING-PARAMETERS TO REQUEST-STRING

           END-PERFORM

           EXIT.

      * -------------------------------------------------------------- *

       END PROGRAM CGIUTIL.
