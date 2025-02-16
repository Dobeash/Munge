### as-date

	USAGE:
	  AS-DATE string

	DESCRIPTION:
	  Convert a string date to a YYYY-MM-DD string (does not handle Excel or YYYYDDMM). 
	  AS-DATE is a #(function!) value.

	ARGUMENTS:
	  string        [string!]  

	REFINEMENTS:
	  /mdy          Month/Day/Year format

### as-time

	USAGE:
	  AS-TIME time

	DESCRIPTION:
	  Convert a string time to an HH:MM string (does not handle Excel or HHMMSS). 
	  AS-TIME is a #(function!) value.

	ARGUMENTS:
	  time          [string!]  

### call-out

	USAGE:
	  CALL-OUT cmd

	DESCRIPTION:
	  Call OS command returning STDOUT. 
	  CALL-OUT is a #(function!) value.

	ARGUMENTS:
	  cmd           [string!]  

### check

	USAGE:
	  CHECK data

	DESCRIPTION:
	  Verify data structure. 
	  CHECK is a #(function!) value.

	ARGUMENTS:
	  data          [block!]   

	REFINEMENTS:
	  /limit        
	    messages     [integer!] Limit messages to display.

### cols?

	USAGE:
	  COLS? data

	DESCRIPTION:
	  Number of columns in a delimited file or string. 
	  COLS? is a #(function!) value.

	ARGUMENTS:
	  data          [file! url! string!] 

	REFINEMENTS:
	  /with         
	    delimiter    [char!] 
	  /sheet        
	    number       [integer!] 

### deduplicate

	USAGE:
	  DEDUPLICATE blk key

	DESCRIPTION:
	  Remove earliest occurrences of duplicate non-empty key field. 
	  DEDUPLICATE is a #(function!) value.

	ARGUMENTS:
	  blk           [block!]   
	  key           [word! integer!] 

	REFINEMENTS:
	  /latest       Remove latest occurrences of duplicate key field

### delimiter?

	USAGE:
	  DELIMITER? data

	DESCRIPTION:
	  Probable delimiter, with priority given to comma, tab, bar, tilde, then semi-colon. 
	  DELIMITER? is a #(function!) value.

	ARGUMENTS:
	  data          [file! url! string!] 

### delta

	USAGE:
	  DELTA new old

	DESCRIPTION:
	  Return new rows not present in old. 
	  DELTA is a #(function!) value.

	ARGUMENTS:
	  new           [block!]   
	  old           [block!]   

### dezero

	USAGE:
	  DEZERO string

	DESCRIPTION:
	  Remove leading zeroes from string. 
	  DEZERO is a #(function!) value.

	ARGUMENTS:
	  string        [string!]  

### digits?

	USAGE:
	  DIGITS? data

	DESCRIPTION:
	  Returns TRUE if data not empty and only contains digits. 
	  DIGITS? is a #(function!) value.

	ARGUMENTS:
	  data          [string! binary!] 

### discard

	USAGE:
	  DISCARD data

	DESCRIPTION:
	  Remove empty columns (ignore headings). 
	  DISCARD is a #(function!) value.

	ARGUMENTS:
	  data          [block!]   

	REFINEMENTS:
	  /verbose      

### discard-last

	USAGE:
	  DISCARD-LAST data

	DESCRIPTION:
	  Remove empty trailing column(s). 
	  DISCARD-LAST is a #(function!) value.

	ARGUMENTS:
	  data          [block!]   

### distinct

	USAGE:
	  DISTINCT data

	DESCRIPTION:
	  Remove duplicate and empty rows. 
	  DISTINCT is a #(function!) value.

	ARGUMENTS:
	  data          [block!]   

### drop

	USAGE:
	  DROP data column

	DESCRIPTION:
	  Remove column. 
	  DROP is a #(function!) value.

	ARGUMENTS:
	  data          [block!]   
	  column        [integer! word!] 

### enblock

	USAGE:
	  ENBLOCK data cols

	DESCRIPTION:
	  Convert a block of values to a block of row blocks. 
	  ENBLOCK is a #(function!) value.

	ARGUMENTS:
	  data          [block!]   
	  cols          [integer!] 

### enzero

	USAGE:
	  ENZERO string length

	DESCRIPTION:
	  Add leading zeroes to a string. 
	  ENZERO is a #(function!) value.

	ARGUMENTS:
	  string        [string!]  
	  length        [integer!] 

### excel-cols?

	USAGE:
	  EXCEL-COLS? sheet

	DESCRIPTION:
	  Number of columns in sheet. 
	  EXCEL-COLS? is a #(function!) value.

	ARGUMENTS:
	  sheet         [binary!]  

### excel-fields?

	USAGE:
	  EXCEL-FIELDS? sheet strings

	DESCRIPTION:
	  Column names of sheet. 
	  EXCEL-FIELDS? is a #(function!) value.

	ARGUMENTS:
	  sheet         [binary!]  
	  strings       [block!]   

### excel-first-row

	USAGE:
	  EXCEL-FIRST-ROW sheet

	DESCRIPTION:
	  First binary row of a sheet. 
	  EXCEL-FIRST-ROW is a #(function!) value.

	ARGUMENTS:
	  sheet         [binary!]  

### excel-info

	USAGE:
	  EXCEL-INFO file

	DESCRIPTION:
	  Name, rows, and fields of each sheet. 
	  EXCEL-INFO is a #(function!) value.

	ARGUMENTS:
	  file          [file!]    

### excel-last-row

	USAGE:
	  EXCEL-LAST-ROW sheet

	DESCRIPTION:
	  Last binary row of a sheet. 
	  EXCEL-LAST-ROW is a #(function!) value.

	ARGUMENTS:
	  sheet         [binary!]  

### excel-load-sheet

	USAGE:
	  EXCEL-LOAD-SHEET file number

	DESCRIPTION:
	  Loads binary worksheet. 
	  EXCEL-LOAD-SHEET is a #(function!) value.

	ARGUMENTS:
	  file          [file!]    
	  number        [integer!] 

### excel-load-strings

	USAGE:
	  EXCEL-LOAD-STRINGS file

	DESCRIPTION:
	  Loads shared strings. 
	  EXCEL-LOAD-STRINGS is a #(function!) value.

	ARGUMENTS:
	  file          [file!]    

### excel-pick-row

	USAGE:
	  EXCEL-PICK-ROW sheet index

	DESCRIPTION:
	  First binary row of a sheet. 
	  EXCEL-PICK-ROW is a #(function!) value.

	ARGUMENTS:
	  sheet         [binary!]  
	  index         [integer!] 

### excel-rows?

	USAGE:
	  EXCEL-ROWS? sheet

	DESCRIPTION:
	  Number of rows in sheet. 
	  EXCEL-ROWS? is a #(function!) value.

	ARGUMENTS:
	  sheet         [binary!]  

### excel?

	USAGE:
	  EXCEL? data

	DESCRIPTION:
	  Returns TRUE if file is Excel or worksheet is XML. 
	  EXCEL? is a #(function!) value.

	ARGUMENTS:
	  data          [file! url! binary! string!] 

### export

	USAGE:
	  EXPORT words

	DESCRIPTION:
	  Export words to global context. 
	  EXPORT is a #(function!) value.

	ARGUMENTS:
	  words         [block!]   Words to export.

### fields?

	USAGE:
	  FIELDS? data

	DESCRIPTION:
	  Column names in a delimited file. 
	  FIELDS? is a #(function!) value.

	ARGUMENTS:
	  data          [file! url! string!] 

	REFINEMENTS:
	  /with         
	    delimiter    [char!] 
	  /sheet        
	    number       [integer!] 

### filename?

	USAGE:
	  FILENAME? path

	DESCRIPTION:
	  Return the file name of a path or url. 
	  FILENAME? is a #(function!) value.

	ARGUMENTS:
	  path          [file! url!] 

### first-line

	USAGE:
	  FIRST-LINE data

	DESCRIPTION:
	  Returns the first non-empty line of a file. 
	  FIRST-LINE is a #(function!) value.

	ARGUMENTS:
	  data          [file! url! string! binary!] 

### first-value

	USAGE:
	  FIRST-VALUE blk

	DESCRIPTION:
	  Returns the first non-empty value of a block. 
	  FIRST-VALUE is a #(function!) value.

	ARGUMENTS:
	  blk           [block!]   

### flatten

	USAGE:
	  FLATTEN data

	DESCRIPTION:
	  Flatten nested block(s). 
	  FLATTEN is a #(function!) value.

	ARGUMENTS:
	  data          [block!]   

### html-decode

	USAGE:
	  HTML-DECODE string

	DESCRIPTION:
	  Decode HTML Entities. 
	  HTML-DECODE is a #(function!) value.

	ARGUMENTS:
	  string        [string!]  

### html-encode

	USAGE:
	  HTML-ENCODE string

	DESCRIPTION:
	  Encode HTML Entities. 
	  HTML-ENCODE is a #(function!) value.

	ARGUMENTS:
	  string        [string!]  

### last-line

	USAGE:
	  LAST-LINE data

	DESCRIPTION:
	  Returns the last non-empty line of a file. 
	  LAST-LINE is a #(function!) value.

	ARGUMENTS:
	  data          [file! url! string!] 

### letters?

	USAGE:
	  LETTERS? data

	DESCRIPTION:
	  Returns TRUE if data only contains letters. 
	  LETTERS? is a #(function!) value.

	ARGUMENTS:
	  data          [string! binary!] 

### list

	USAGE:
	  LIST data

	DESCRIPTION:
	  Uses settings to set the new-line marker. 
	  LIST is a #(function!) value.

	ARGUMENTS:
	  data          [block!]   

### load-dsv

	USAGE:
	  LOAD-DSV source

	DESCRIPTION:
	  Parses delimiter-separated values into row blocks. 
	  LOAD-DSV is a #(function!) value.

	ARGUMENTS:
	  source        [file! url! binary! string!] 

	REFINEMENTS:
	  /part         Offset position(s) to retrieve
	    columns      [block! integer! word!] 
	  /where        Expression that can reference columns as row/1, row/2, etc or &field
	    condition    [block!] 
	  /with         Alternate delimiter (default is tab, bar then comma)
	    delimiter    [char!] 
	  /ignore       Ignore truncated row errors
	  /csv          Parse as CSV even though not comma-delimited
	  /flat         Flatten rows

### load-fixed

	USAGE:
	  LOAD-FIXED file widths

	DESCRIPTION:
	  Loads fixed-width values from a file. 
	  LOAD-FIXED is a #(function!) value.

	ARGUMENTS:
	  file          [file! url!] 
	  widths        [block!]   

	REFINEMENTS:
	  /part         
	    columns      [integer! block!] 

### load-xml

	USAGE:
	  LOAD-XML file

	DESCRIPTION:
	  Loads an Office XML sheet. 
	  LOAD-XML is a #(function!) value.

	ARGUMENTS:
	  file          [file!]    

	REFINEMENTS:
	  /part         Offset position(s) to retrieve
	    columns      [block! integer! word!] 
	  /where        Expression that can reference columns as row/1, row/2, etc or &field
	    condition    [block!] 
	  /flat         Flatten rows
	  /sheet        
	    number       [integer!] 

### max-of

	USAGE:
	  MAX-OF series

	DESCRIPTION:
	  Returns the largest value in a series. 
	  MAX-OF is a #(function!) value.

	ARGUMENTS:
	  series        [series!]  Series to search.

### merge

	USAGE:
	  MERGE outer key1 inner key2 columns

	DESCRIPTION:
	  Join outer block to inner block on primary key. 
	  MERGE is a #(function!) value.

	ARGUMENTS:
	  outer         [block!]   Outer block.
	  key1          [integer!] 
	  inner         [block!]   Inner block to index.
	  key2          [integer!] 
	  columns       [block!]   Offset position(s) to retrieve in merged block.

	REFINEMENTS:
	  /default      Use none on inner block misses

### min-of

	USAGE:
	  MIN-OF series

	DESCRIPTION:
	  Returns the smallest value in a series. 
	  MIN-OF is a #(function!) value.

	ARGUMENTS:
	  series        [series!]  Series to search.

### mixedcase

	USAGE:
	  MIXEDCASE string

	DESCRIPTION:
	  Converts string of characters to mixedcase. 
	  MIXEDCASE is a #(function!) value.

	ARGUMENTS:
	  string        [string!]  

### munge

	USAGE:
	  MUNGE data

	DESCRIPTION:
	  Load and / or manipulate a block of tabular (column and row) values. 
	  MUNGE is a #(function!) value.

	ARGUMENTS:
	  data          [block!]   

	REFINEMENTS:
	  /delete       Delete matching rows (returns original block)
	    clause       [any-type!] 
	  /part         Offset position(s) and/or values to retrieve
	    columns      [block! integer! word! none!] 
	  /where        Expression that can reference columns as row/1, row/2, etc
	    condition    [any-type!] 
	  /group        One of avg, count, max, min or sum
	    having       [word! block!] Word or expression that can reference the initial result set column as count, max, etc.
	  /flat         Flatten rows (requires part or where, but not group)
	  /spec         Return columns and condition with field substitutions

### oledb

	USAGE:
	  OLEDB file statement

	DESCRIPTION:
	  Execute an OLEDB statement. 
	  OLEDB is a #(function!) value.

	ARGUMENTS:
	  file          [file! url!] 
	  statement     [string!]  SQL statement in the form (Excel) 'SELECT F1 FROM SHEET1' or (Access) 'SELECT Column FROM Table'.

### penult

	USAGE:
	  PENULT series

	DESCRIPTION:
	  Returns the second last value of a series. 
	  PENULT is a #(function!) value.

	ARGUMENTS:
	  series        [series!]  

### read-string

	USAGE:
	  READ-STRING source

	DESCRIPTION:
	  Read string from a text file. 
	  READ-STRING is a #(function!) value.

	ARGUMENTS:
	  source        [file! url! binary!] 

### replace-deep

	USAGE:
	  REPLACE-DEEP data map

	DESCRIPTION:
	  Replaces all occurrences of search values with new values in a block or nested block. 
	  REPLACE-DEEP is a #(function!) value.

	ARGUMENTS:
	  data          [block!]   Block to replace within (modified).
	  map           [map! block!] Map of values to replace.

### rows?

	USAGE:
	  ROWS? data

	DESCRIPTION:
	  Number of rows in a delimited file or string. 
	  ROWS? is a #(function!) value.

	ARGUMENTS:
	  data          [file! url! string!] 

	REFINEMENTS:
	  /sheet        
	    number       [integer!] 

### sheets?

	USAGE:
	  SHEETS? file

	DESCRIPTION:
	  Excel sheet names. 
	  SHEETS? is a #(function!) value.

	ARGUMENTS:
	  file          [file! url!] 

### split-on

	USAGE:
	  SPLIT-ON series dlm

	DESCRIPTION:
	  Split a series into pieces by delimiter. 
	  SPLIT-ON is a #(function!) value.

	ARGUMENTS:
	  series        [series!]  
	  dlm           [char! bitset! string!] 

### sqlcmd

	USAGE:
	  SQLCMD server database statement

	DESCRIPTION:
	  Execute a SQL Server statement. 
	  SQLCMD is a #(function!) value.

	ARGUMENTS:
	  server        [string!]  
	  database      [string!]  
	  statement     [string!]  

	REFINEMENTS:
	  /key          Columns to convert to integer
	    columns      [integer! block!] 
	  /headings     Keep column headings
	  /string       Return string instead of block
	  /flat         Flatten rows
	  /identity     

### sqlite

	USAGE:
	  SQLITE database statement

	DESCRIPTION:
	  Execute a SQLite statement. 
	  SQLITE is a #(function!) value.

	ARGUMENTS:
	  database      [file! url!] 
	  statement     [string!]  

### to-column-alpha

	USAGE:
	  TO-COLUMN-ALPHA number

	DESCRIPTION:
	  Convert numeric column reference to an alpha column reference. 
	  TO-COLUMN-ALPHA is a #(function!) value.

	ARGUMENTS:
	  number        [integer!] Column number between 1 and 702.

### to-column-number

	USAGE:
	  TO-COLUMN-NUMBER alpha

	DESCRIPTION:
	  Convert alpha column reference to a numeric column reference. 
	  TO-COLUMN-NUMBER is a #(function!) value.

	ARGUMENTS:
	  alpha         [word! string! char!] 

### to-field-spec

	USAGE:
	  TO-FIELD-SPEC fields

	DESCRIPTION:
	  Convert field strings to words. 
	  TO-FIELD-SPEC is a #(function!) value.

	ARGUMENTS:
	  fields        [block!]   

### to-string-date

	USAGE:
	  TO-STRING-DATE date

	DESCRIPTION:
	  Convert a string or Rebol date to a YYYY-MM-DD string. 
	  TO-STRING-DATE is a #(function!) value.

	ARGUMENTS:
	  date          [string! date!] 

	REFINEMENTS:
	  /mdy          Month/Day/Year format
	  /ydm          Year/Day/Month format

### to-string-time

	USAGE:
	  TO-STRING-TIME time

	DESCRIPTION:
	  Convert a string or Rebol time to a HH:MM:SS string. 
	  TO-STRING-TIME is a #(function!) value.

	ARGUMENTS:
	  time          [string! date! time!] 

	REFINEMENTS:
	  /minutes      HH:MM
	  /precise      HH:MM:SS.mmm

### transpose

	USAGE:
	  TRANSPOSE data

	DESCRIPTION:
	  Rotate data from rows to columns or vice versa. 
	  TRANSPOSE is a #(function!) value.

	ARGUMENTS:
	  data          [block!]   

### unzip

	USAGE:
	  UNZIP source

	DESCRIPTION:
	  Decompresses file(s) from archive. 
	  UNZIP is a #(function!) value.

	ARGUMENTS:
	  source        [file! url!] 

	REFINEMENTS:
	  /only         
	    file         [file!] 

### write-dsv

	USAGE:
	  WRITE-DSV file data

	DESCRIPTION:
	  Write block(s) of values to a delimited text file. 
	  WRITE-DSV is a #(function!) value.

	ARGUMENTS:
	  file          [file! url!] Csv or tab-delimited text file.
	  data          [block!]   

	REFINEMENTS:
	  /utf8         

### write-excel

	USAGE:
	  WRITE-EXCEL file data

	DESCRIPTION:
	  Write block(s) of values to an Excel file. 
	  WRITE-EXCEL is a #(function!) value.

	ARGUMENTS:
	  file          [file! url!] 
	  data          [block!]   Name [string!] Data [block!] Widths [block!] records.

	REFINEMENTS:
	  /filter       Add auto filter

