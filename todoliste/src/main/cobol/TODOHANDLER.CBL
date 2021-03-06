       IDENTIFICATION DIVISION.
       PROGRAM-ID. TODOHANDLER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT WEBINPUT ASSIGN TO KEYBOARD
               FILE STATUS IS IN-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD WEBINPUT.
       01 CHUNK-OF-POST PIC X(2048).

       WORKING-STORAGE SECTION.
       01 IN-STATUS PIC 9999.
       01 NEWLINE PIC X VALUE X'0A'.
       01 PARAMETER-VALUE-1 PIC X(1024).
       01 PARAMETER-VALUE-2 PIC X(1024).
       COPY todoactions.
       COPY cgiutildata.

      * -------------------------------------------------------------- *

       PROCEDURE DIVISION.

           PERFORM U01-PRINT-HEADER

           PERFORM U00-PARSE-WEBINPUT

           PERFORM READ-TODOLIST-ACTION

          *>  DISPLAY CHUNK-OF-POST UPON SYSERR

           EVALUATE TRUE
               WHEN ACTION-ADD
                   PERFORM ADD-TODOLIST-ENTRY
               WHEN ACTION-SHOW
                   PERFORM SHOW-TODOLIST
               WHEN ACTION-DELETE
                   PERFORM DELETE-TODOLIST
               WHEN ACTION-DELETE-ITEM
                   PERFORM DELETE-ITEM
               WHEN ACTION-EDIT-ITEM
                   PERFORM EDIT-ITEM
               WHEN ACTION-MOVE-ITEM
                   PERFORM MOVE-ITEM
               WHEN OTHER
                   DISPLAY "Action unbekannt: " TODO-ACTION
           END-EVALUATE

           GOBACK.

      * -------------------------------------------------------------- *

       U00-PARSE-WEBINPUT SECTION.

           OPEN INPUT WEBINPUT

           IF IN-STATUS < 10 THEN

               READ WEBINPUT END-READ

               IF IN-STATUS > 9 THEN
                   MOVE SPACES TO CHUNK-OF-POST
               END-IF

           END-IF

           CLOSE WEBINPUT

           MOVE CHUNK-OF-POST TO REQUEST-STRING


           EXIT.

      * -------------------------------------------------------------- *

       U01-PRINT-HEADER SECTION.

           DISPLAY "CONTENT-TYPE: TEXT/HTML"
           NEWLINE



           EXIT.

      * -------------------------------------------------------------- *

       READ-PARAMETER-VALUE SECTION.

           MOVE CHUNK-OF-POST TO REQUEST-STRING
           CALL "CGIUTIL" USING REQUEST-PARAMETERS


           EXIT.

      * -------------------------------------------------------------- *

       READ-TODOLIST-ACTION SECTION.

           MOVE "action" TO PARAMETER-NAME
           PERFORM READ-PARAMETER-VALUE
           MOVE PARAMETER-VALUE TO TODO-ACTION

           EXIT.

      * -------------------------------------------------------------- *

       ADD-TODOLIST-ENTRY SECTION.

           MOVE "content" TO PARAMETER-NAME
           PERFORM READ-PARAMETER-VALUE
           CALL "TODOLISTE" USING TODO-ACTION PARAMETER-VALUE

           EXIT.

      * -------------------------------------------------------------- *

       SHOW-TODOLIST SECTION.

           CALL "TODOLISTE" USING TODO-ACTION

           EXIT.

      * -------------------------------------------------------------- *

       DELETE-TODOLIST SECTION.

           CALL "TODOLISTE" USING TODO-ACTION

           EXIT.

      * -------------------------------------------------------------- *

       DELETE-ITEM SECTION.

           MOVE "id" TO PARAMETER-NAME
           PERFORM READ-PARAMETER-VALUE
           MOVE PARAMETER-VALUE TO PARAMETER-VALUE-1
           CALL "TODOLISTE" USING
               TODO-ACTION PARAMETER-VALUE-1
           EXIT.
      * -------------------------------------------------------------- *
       EDIT-ITEM SECTION.
           MOVE "id" TO PARAMETER-NAME
           PERFORM READ-PARAMETER-VALUE
           MOVE PARAMETER-VALUE TO PARAMETER-VALUE-1

           MOVE "content" TO PARAMETER-NAME
           PERFORM READ-PARAMETER-VALUE
           MOVE PARAMETER-VALUE TO PARAMETER-VALUE-2

           CALL "TODOLISTE" USING
               TODO-ACTION PARAMETER-VALUE-1 PARAMETER-VALUE-2

       EXIT.
      * -------------------------------------------------------------- *

       MOVE-ITEM SECTION.

           MOVE "id" TO PARAMETER-NAME
           PERFORM READ-PARAMETER-VALUE
           MOVE PARAMETER-VALUE TO PARAMETER-VALUE-1

           MOVE "direction" TO PARAMETER-NAME
           PERFORM READ-PARAMETER-VALUE
           MOVE PARAMETER-VALUE TO PARAMETER-VALUE-2

           CALL "TODOLISTE" USING
               TODO-ACTION PARAMETER-VALUE-1 PARAMETER-VALUE-2
       EXIT.

      * -------------------------------------------------------------- *

       END PROGRAM TODOHANDLER.
