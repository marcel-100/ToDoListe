       IDENTIFICATION DIVISION.
       PROGRAM-ID. TODOLIST-DRIVER.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 TODO-ACTION         PIC X(10).
       01 NEW-TODO-ITEM       PIC X(35).
       PROCEDURE DIVISION.
           CALL 'TODOLISTE' USING TODO-ACTION
                                  NEW-TODO-ITEM
           GOBACK.
