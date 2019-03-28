           TESTSUITE 'Tests for URL Parsing tool CGIUTIL'

           TESTCASE 'Parse String (word=4)'
           MOVE "word=4" TO REQUEST-STRING
           MOVE "word" TO PARAMETER-NAME
           PERFORM PARSE-PARAMETER
           EXPECT PARAMETER-VALUE TO BE "4"

           TESTCASE 'Parse second Parameter of (word=4&word2=7)'
           MOVE "word=4&word2=7" TO REQUEST-STRING
           MOVE "word2" TO PARAMETER-NAME
           PERFORM PARSE-PARAMETER
           EXPECT PARAMETER-VALUE TO BE "7"

           TESTCASE 'Parse first Parameter of two'
           MOVE "content=frank&action=add" TO REQUEST-STRING
           MOVE "content" TO PARAMETER-NAME
           PERFORM PARSE-PARAMETER
           EXPECT PARAMETER-VALUE TO BE "frank"

           TESTCASE 'Parse third Parameter of (word=4&word2=7&word3=t)'
           MOVE "word=4&word2=7&word3=t" TO REQUEST-STRING
           MOVE "word3" TO PARAMETER-NAME
           PERFORM PARSE-PARAMETER
           EXPECT PARAMETER-VALUE TO BE "t"

           TESTCASE 'Parse middle Parameter of (word=4&word2=7&word3=t)'
           MOVE "word=4&word2=7&word3=t" TO REQUEST-STRING
           MOVE "word2" TO PARAMETER-NAME
           PERFORM PARSE-PARAMETER
           EXPECT PARAMETER-VALUE TO BE "7"

           TESTCASE 'Unknown parameter yields SPACES'
           MOVE "word=4&word2=7" TO REQUEST-STRING
           MOVE "word3" TO PARAMETER-NAME
           PERFORM PARSE-PARAMETER
           EXPECT PARAMETER-VALUE TO BE SPACES
