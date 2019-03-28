           TESTSUITE 'UNIT TESTS for managing ToDo List Items'

           BEFORE-EACH
             PERFORM CLEAR-LIST
           END-BEFORE

           TESTCASE 'Adding a new item to empty list'
           MOVE "Zeiten buchen" TO NEW-TODO-ITEM
           PERFORM ADD-NEW-TODO-ITEM
           EXPECT TODO-ITEM(1) TO BE "Zeiten buchen"
           EXPECT LIST-IS-EMPTY TO BE FALSE

           TESTCASE 'Adding item and deleting gives empty list'
           MOVE "Zeiten buchen" TO NEW-TODO-ITEM
           PERFORM ADD-NEW-TODO-ITEM
           MOVE 1 TO ITEM-TO-DELETE
           PERFORM DELETE-ITEM
           EXPECT TODO-ITEM(1) TO BE SPACES

           TESTCASE 'Adding two items and deleting first gives second'
           MOVE "ToDo1" TO NEW-TODO-ITEM
           PERFORM ADD-NEW-TODO-ITEM
           MOVE "ToDo2" TO NEW-TODO-ITEM
           PERFORM ADD-NEW-TODO-ITEM
           MOVE 1 TO ITEM-TO-DELETE
           PERFORM DELETE-ITEM
           EXPECT TODO-ITEM(1) TO BE "ToDo2"

           TESTCASE 'Adding 3 items and deleting 2'
           MOVE "A" TO NEW-TODO-ITEM
           PERFORM ADD-NEW-TODO-ITEM
           MOVE "B" TO NEW-TODO-ITEM
           PERFORM ADD-NEW-TODO-ITEM
           MOVE "C" TO NEW-TODO-ITEM
           PERFORM ADD-NEW-TODO-ITEM
           MOVE 2 TO ITEM-TO-DELETE
           PERFORM DELETE-ITEM
           EXPECT TODO-ITEM(1) TO BE "A"
           EXPECT TODO-ITEM(2) TO BE "C"
           EXPECT TODO-ITEM(3) TO BE SPACES

           TESTCASE 'Adding 2 items and clearing list gives empty list'
           MOVE "A" TO NEW-TODO-ITEM
           PERFORM ADD-NEW-TODO-ITEM
           MOVE "B" TO NEW-TODO-ITEM
           PERFORM ADD-NEW-TODO-ITEM
           PERFORM CLEAR-LIST
           EXPECT LIST-IS-EMPTY TO BE TRUE
