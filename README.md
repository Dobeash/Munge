# Munge v3.1.2

> Updated 20-Feb-2023

Munge is a collection of data manipulation functions designed to work with the following Rebol distribution:

- [Oldes/Rebol3](https://github.com/Oldes/Rebol3)

Its functions are wrapped in a single context named `ctx-munge`.

	as-date			Convert a string date to a YYYY-MM-DD string (does not handle Excel or YYYYDDMM).
	as-time			Convert a string time to a HH:MM string (does not handle Excel or HHMMSS).
	call-out		Call OS command returning STDOUT.
	check			Verify data structure.
	cols?			Number of columns in a delimited file or string.
	deduplicate		Remove earliest occurrences of duplicate non-empty key field.
	delimiter?		Probable delimiter, with priority given to comma, tab, bar, tilde, then semi-colon.
	delta			Remove source rows that exist in target.
	dezero			Remove leading zeroes from string.
	difference-only		Returns the difference of two tables.
	digit			DIGIT is a bitset! value: make bitset! #{000000000000FFC0}
	digits?			Returns TRUE if data not empty and only contains digits.
	discard			Remove empty columns.
	distinct		Remove duplicate and empty rows.
	enblock			Convert a block of values to a block of row blocks.
	enzero			Add leading zeroes to a string.
	excel?			Returns TRUE if file is Excel or worksheet is XML.
	export			Export words to global context.
	fields?			Column names in a delimited file or string.
	filename?		Return the file name of a path or url.
	first-line		Returns the first non-empty line of a file.
	flatten			Flatten nested block(s).
	intersect-only		Returns the intersection of two tables.
	last-line		Returns the last non-empty line of a file.
	letter			LETTER is a bitset! value: make bitset! #{00000000000000007FFFFFE07FFFFFE0}
	letters?		Returns TRUE if data only contains letters.
	list			Uses settings to optionally trim strings and set the new-line marker.
	load-dsv		Parses delimiter-separated values into row blocks.
	load-fixed		Loads fixed-width values from a file.
	load-xml		Loads an Office XML sheet.
	max-of			Returns the largest value in a series.
	merge			Join outer block to inner block on primary key.
	min-of			Returns the smallest value in a series.
	mixedcase		Converts string of characters to mixedcase.
	munge			Load and/or manipulate a block of tabular (column and row) values.
	oledb			Execute an OLEDB statement.
	penult			Returns the second last value of a series.
	read-string		Read string from a text file.
	replace-deep		Replaces all occurences of search values with new values in a block or nested block.
	rows?			Number of rows in a delimited file or string.
	sheets?			Excel sheet names.
	split-on		Split a series into pieces by delimiter.
	sqlcmd			Execute a SQL Server statement.
	sqlite			Execute a SQLite statement.
	to-column-alpha		Convert numeric column reference to an alpha column reference.
	to-column-number	Convert alpha column reference to a numeric column reference.
	to-field-spec		Convert field strings to words.
	to-string-date		Convert a string or Rebol date to a YYYY-MM-DD string.
	to-string-time		Convert a string or Rebol time to a HH:MM:SS string.
	union-only		Returns the union of two tables.
	unzip			Decompresses file from archive.
	write-dsv		Write block(s) of values to a delimited text file.
	write-excel		Write block(s) of values to an Excel file.

## Quick Start

	>> do %munge.r
	>> ctx-munge/export bind words-of ctx-munge 'self
	>> blk: load-dsv "Name,Age^/Ben,20^/Bob,30^/Rob,40"
	== [
	    ["Name" "Age"]
	    ["Ben" "20"]
	    ["Bob" "30"]
	    ["Rob" "40"]
	]
	>> munge/where next blk [&Age: to-integer &Age]
	== [
	    ["Ben" 20]
	    ["Bob" 30]
	    ["Rob" 40]
	]

## Documentation

> Updated 20-Feb-2023

- [Function Guide](FUNCTIONS.md) - Lists all available functions in the munge script.
- [User Guide](GUIDE.md) - Describes the use of major functions in the munge script.
