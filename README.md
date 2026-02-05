# Munge v3.1.5

> Updated 9-Jan-2026

Munge is a collection of data manipulation functions designed to work with the following Rebol distribution:

- [Oldes/Rebol3](https://github.com/Oldes/Rebol3)

Its functions are wrapped in a single context named `ctx-munge`.

	as-date				Convert a string date to a YYYY-MM-DD string (does not handle Excel or YYYYDDMM).
	as-time				Convert a string time to an HH:MM string (does not handle Excel or HHMMSS).
	call-out			Call OS command returning STDOUT.
	check				Verify data structure.
	cols?				Number of columns in a delimited file or string.
	deduplicate			Remove earliest occurrences of duplicate non-empty key field.
	delimiter?			Probable delimiter, with priority given to tab, comma, semi-colon, bar, then tilde.
	delta				Return new rows not present in old.
	dezero				Remove leading zeroes from string.
	digit				DIGIT is a bitset of value: make bitset! #{000000000000FFC0}
	digits?				Returns TRUE if data not empty and only contains digits.
	discard				Remove empty columns (ignore headings).
	distinct			Remove duplicate and empty rows.
	drop				Remove column.
	enblock				Convert a block of values to a block of row blocks.
	enzero				Add leading zeroes to a string.
	excel-cols?			Number of columns in sheet.
	excel-fields?		Column names of sheet.
	excel-first-row		First binary row of a sheet.
	excel-info			Name, rows, and fields of each sheet.
	excel-last-row		Last binary row of a sheet.
	excel-load-sheet	Loads binary worksheet.
	excel-load-strings	Loads shared strings.
	excel-pick-row		First binary row of a sheet.
	excel-row-numbers?	Row number present in row tag.
	excel-rows?			Number of rows in sheet.
	excel?				Returns TRUE if file is Excel or worksheet is XML.
	export				Export words to global context.
	fields?				Column names in a delimited file.
	filename?			Return the file name of a path or url.
	flatten				Flatten nested block(s).
	html-decode			Decode HTML Entities.
	html-encode			Encode HTML Entities.
	letter				LETTER is a bitset of value: make bitset! #{00000000000000007FFFFFE07FFFFFE0}
	letters?			Returns TRUE if data only contains letters.
	list				Uses settings to set the new-line marker.
	load-dsv			Parses delimiter-separated values into row blocks.
	load-xml			Loads an Office XML sheet.
	max-of				Returns the largest value in a series.
	merge				Join outer block to inner block on primary key.
	min-of				Returns the smallest value in a series.
	mixedcase			Converts string of characters to mixedcase.
	munge				Load and / or manipulate a block of tabular (column and row) values.
	oledb				Execute an OLEDB statement.
	penult				Returns the second last value of a series.
	read-string			Read string from a text file.
	replace-deep		Replaces all occurrences of search values with new values in a block or nested block.
	rows?				Number of rows in a delimited file or string.
	sheets?				Excel sheet names.
	split-on			Split a series into pieces by delimiter.
	sqlcmd				Execute a SQL Server statement.
	to-column-alpha		Convert numeric column reference to an alpha column reference.
	to-column-number	Convert alpha column reference to a numeric column reference.
	to-field-spec		Convert field strings to words.
	to-string-date		Convert a string or Rebol date to a YYYY-MM-DD string.
	to-string-time		Convert a string or Rebol time to a HH:MM:SS string.
	transpose			Rotate data from rows to columns or vice versa.
	trim-rows			Remove empty trailing column(s) and leading column(s).
	unzip				Decompresses file(s) from archive.
	write-dsv			Write block(s) of values to a delimited text file.
	write-excel			Write block(s) of values to an Excel file.

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

> Updated 15-Aug-2025

- [Function Guide](FUNCTIONS.md) - Lists all available functions in the munge script.
- [User Guide](GUIDE.md) - Describes the use of major functions in the munge script.
