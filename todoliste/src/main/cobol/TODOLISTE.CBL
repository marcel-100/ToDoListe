       IDENTIFICATION DIVISION.
       PROGRAM-ID. TODOLISTE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TDLIST ASSIGN TO 'todolist.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT PRINT-FILE ASSIGN TO 'todolist.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD TDLIST.
       01 TDLIST-FILE.
           05 ITEM-ID PIC 9(5).
           05 ITEM-CONTENT PIC X(1024).

       WORKING-STORAGE SECTION.
       01 TEMP-FIELDS.
           05 ITEM-TO-DELETE PIC 99999.
           05 NUMBER-OF-TODOS PIC 99999.
               88 LIST-IS-EMPTY VALUE ZERO.
           05 COUNTER PIC 99999.
           05 TODOLISTE.
               07 TODO-ITEM PIC X(1024) OCCURS 99999.
       01 WS-EOF PIC A(1).
       01 WS-TDLIST.
           05 ITEM-ID PIC 9(5).
           05 ITEM-CONTENT PIC X(1024).

       LINKAGE SECTION.
       COPY todoactions.
       COPY todoitem.
           01 PARAMETER-VALUE-2 PIC X(1024).

      * ------------------------ACTION-------------------------------- *

       PROCEDURE DIVISION USING TODO-ACTION NEW-TODO-ITEM
           PARAMETER-VALUE-2.

           PERFORM COUNT-LINES-IN-FILE

           EVALUATE TRUE
               WHEN ACTION-SHOW
                   PERFORM READ-TODOLIST-FROM-FILE-AS-JSON
               WHEN ACTION-ADD
                   PERFORM ADD-NEW-TODO-ITEM
               WHEN ACTION-DELETE
                   PERFORM CLEAR-LIST
               WHEN ACTION-DELETE-ITEM
                   PERFORM DELETE-ITEM
               WHEN ACTION-EDIT-ITEM
                   PERFORM EDIT-ITEM
           END-EVALUATE

           GOBACK.

      * ------------------------ADD----------------------------------- *
       ADD-NEW-TODO-ITEM SECTION.

           ADD 1 TO NUMBER-OF-TODOS

           MOVE NEW-TODO-ITEM
            TO TODO-ITEM (NUMBER-OF-TODOS)
           MOVE NUMBER-OF-TODOS
            TO ITEM-ID IN WS-TDLIST
           MOVE NEW-TODO-ITEM
            TO ITEM-CONTENT IN WS-TDLIST

           OPEN EXTEND TDLIST
           WRITE TDLIST-FILE FROM WS-TDLIST
           CLOSE TDLIST

           EXIT.

      * ------------------------CLEAR--------------------------------- *
       CLEAR-LIST SECTION.

           OPEN OUTPUT TDLIST
           CLOSE TDLIST
           EXIT.

      * ------------------------DISPLAY------------------------------- *
       DISPLAY-ITEM SECTION.

           DISPLAY
               '<li>'
               '<input type="button" value="×" '
                   'onclick="deleteItem('
                   ITEM-ID IN WS-TDLIST
               ');"/> '
                   ITEM-CONTENT IN WS-TDLIST  '</li>'
       EXIT.

      * ------------------------WRITE--------------------------------- *
       WRITE-FILE SECTION.

              OPEN OUTPUT TDLIST
                  PERFORM VARYING COUNTER FROM 1 BY 1
                  UNTIL COUNTER > NUMBER-OF-TODOS
                      MOVE COUNTER
                       TO ITEM-ID IN WS-TDLIST
                      MOVE TODO-ITEM (COUNTER)
                       TO ITEM-CONTENT IN WS-TDLIST
                      WRITE TDLIST-FILE FROM WS-TDLIST
                  END-PERFORM
              CLOSE TDLIST

       EXIT.

      * ------------------------MOVE---------------------------------- *
       MOVE-ITEM SECTION.
           PERFORM READ-TODOLIST-FROM-FILE-TO-RAM

           COMPUTE ITEM-TO-DELETE = FUNCTION NUMVAL(NEW-TODO-ITEM)

           MOVE TODO-ITEM(ITEM-TO-DELETE)
            TO ITEM-CONTENT IN WS-TDLIST

           IF PARAMETER-VALUE-2 = "up" THEN
               MOVE TODO-ITEM(ITEM-TO-DELETE + 1)
                TO TODO-ITEM(ITEM-TO-DELETE)
               MOVE ITEM-CONTENT IN WS-TDLIST
                TO TODO-ITEM(ITEM-TO-DELETE + 1)
           ELSE
               MOVE TODO-ITEM(ITEM-TO-DELETE + 1)
                TO TODO-ITEM(ITEM-TO-DELETE)
               MOVE ITEM-CONTENT IN WS-TDLIST
                TO TODO-ITEM(ITEM-TO-DELETE + 1)
           END-IF

           PERFORM WRITE-FILE

       EXIT.

      *v3 == der dritte Parameter
      *ITEM-TO-DELETE == die ID

      * ------------------------DELETE-------------------------------- *
       DELETE-ITEM SECTION.
           PERFORM READ-TODOLIST-FROM-FILE-TO-RAM
           COMPUTE ITEM-TO-DELETE = FUNCTION NUMVAL(NEW-TODO-ITEM)
           PERFORM WITH TEST AFTER
               VARYING COUNTER FROM ITEM-TO-DELETE BY 1
                UNTIL COUNTER = NUMBER-OF-TODOS
               MOVE TODO-ITEM(COUNTER + 1)
                TO TODO-ITEM(COUNTER)
           END-PERFORM
           SUBTRACT 1 FROM NUMBER-OF-TODOS GIVING NUMBER-OF-TODOS
           PERFORM WRITE-FILE

       EXIT.

      * ------------------------EDIT---------------------------------- *
       EDIT-ITEM SECTION.
           PERFORM READ-TODOLIST-FROM-FILE-TO-RAM
           COMPUTE ITEM-TO-DELETE = FUNCTION NUMVAL(NEW-TODO-ITEM)
           MOVE PARAMETER-VALUE-2 TO TODO-ITEM(ITEM-TO-DELETE)
           PERFORM WRITE-FILE
       EXIT.

      * ------------------------READ---------------------------------- *
       READ-TODOLIST-FROM-FILE SECTION.

           OPEN INPUT TDLIST
           MOVE "N" TO WS-EOF

           PERFORM UNTIL WS-EOF = "Y"
               READ TDLIST INTO WS-TDLIST
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END PERFORM DISPLAY-ITEM
               END-READ
           END-PERFORM

           CLOSE TDLIST
       EXIT.

      * ------------------------READ-JSON----------------------------- *
       READ-TODOLIST-FROM-FILE-AS-JSON SECTION.
           OPEN INPUT TDLIST
           MOVE "N" TO WS-EOF
           MOVE 0 TO COUNTER

           DISPLAY '{ "items" : ['

           PERFORM UNTIL WS-EOF = "Y"
               READ TDLIST INTO WS-TDLIST
                   AT END
                       MOVE 'Y' TO WS-EOF
                   NOT AT END
                       IF COUNTER = 0 THEN
                           DISPLAY '  "' WITH NO ADVANCING
                       ELSE
                           DISPLAY ', '
                           DISPLAY '  "' WITH NO ADVANCING
                       END-IF
                       DISPLAY
                           FUNCTION TRIM(ITEM-CONTENT IN WS-TDLIST) '"'
                            WITH NO ADVANCING
                       ADD 1 TO COUNTER
               END-READ
           END-PERFORM

           DISPLAY ''
           DISPLAY ']}'

           CLOSE TDLIST
           EXIT.

      * ------------------------READ-RAM------------------------------ *

       READ-TODOLIST-FROM-FILE-TO-RAM SECTION.

           OPEN INPUT TDLIST
           MOVE "N" TO WS-EOF

           MOVE 1 TO COUNTER

           PERFORM UNTIL WS-EOF = "Y"
               READ TDLIST INTO WS-TDLIST
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END MOVE ITEM-CONTENT IN WS-TDLIST
                    TO TODO-ITEM(COUNTER)
                    ADD 1 TO COUNTER
               END-READ
           END-PERFORM

           CLOSE TDLIST
           EXIT.

      * ------------------------COUNT--------------------------------- *

       COUNT-LINES-IN-FILE SECTION.

           OPEN INPUT TDLIST
           MOVE "N" TO WS-EOF

           PERFORM UNTIL WS-EOF = "Y"
               READ TDLIST INTO WS-TDLIST
                   AT END MOVE "Y" TO WS-EOF
                   NOT AT END ADD 1 TO NUMBER-OF-TODOS
               END-READ
           END-PERFORM

           CLOSE TDLIST

           EXIT.

      * -------------------------------------------------------------- *

       END PROGRAM TODOLISTE.
