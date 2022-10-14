; Red [] ; commented as 'red is undefined in Rebol3/Base
Rebol [
	Title:		"Munge functions"
	Owner:		"Ashley G Truter"
	Version:	3.1.1
	Date:		14-Oct-2022
	Purpose:	"Extract and manipulate tabular values in blocks, delimited files, and database tables."
	Licence:	"MIT. Free for both commercial and non-commercial use."
	Tested: {
		Windows x86
			CLI Red			14-Oct-2022		red-lang.org
		Windows x64
			Rebol3/Core		3.10.0			github.com/Oldes/Rebol3
		macOS x64
			Rebol3/Core		3.10.0			github.com/Oldes/Rebol3
	}
	Usage: {
		as-date				Convert a string date to a YYYY-MM-DD string (does not handle Excel or YYYYDDMM).
		as-time				Convert a string time to a HH:MM string (does not handle Excel).
		call-out			Call OS command returning STDOUT.
		check				Verify data structure.
		cols?				Number of columns in a delimited file or string.
		deduplicate			Remove earliest occurrences of duplicate non-empty key field.
		delimiter?			Probable delimiter, with priority given to comma, tab, bar, tilde, then semi-colon.
		delta				Remove source rows that exist in target.
		dezero				Remove leading zeroes from string.
		difference-only		Returns the difference of two tables.
		digit				DIGIT is a bitset! value: make bitset! #{000000000000FFC0}
		digits?				Returns TRUE if data not empty and only contains digits.
		discard				Remove empty columns.
		distinct			Remove duplicate and empty rows.
		enblock				Convert a block of values to a block of row blocks.
		enzero				Add leading zeroes to a string.
		excel?				Returns TRUE if file is Excel or worksheet is XML.
		export				Export words to global context.
		fields?				Column names in a delimited file or string.
		first-line			Returns the first non-empty line of a file.
		flatten				Flatten nested block(s).
		intersect-only		Returns the intersection of two tables.
		last-line			Returns the last non-empty line of a file.
		letter				LETTER is a bitset! value: make bitset! #{00000000000000007FFFFFE07FFFFFE0}
		letters?			Returns TRUE if data only contains letters.
		like				Finds a value in a series, expanding * (any characters) and ? (any one character), and returns TRUE if found.
		list				Uses settings to optionally trim strings and set the new-line marker.
		load-dsv			Parses delimiter-separated values into row blocks.
		load-fixed			Loads fixed-width values from a file.
		load-xml			Loads an Office XML sheet.
		max-of				Returns the largest value in a series.
		merge				Join outer block to inner block on primary key.
		min-of				Returns the smallest value in a series.
		mixedcase			Converts string of characters to mixedcase.
		munge				Load and/or manipulate a block of tabular (column and row) values.
		oledb				Execute an OLEDB statement.
		read-string			Read string from a text file.
		replace-deep		Replaces all occurences of search values with new values in a block or nested block.
		rows?				Number of rows in a delimited file or string.
		second-last/penult	Returns the second last value of a series.
		sheets?				Excel sheet names.
		sqlcmd				Execute a SQL Server statement.
		sqlite				Execute a SQLite statement.
		to-column-alpha		Convert numeric column reference to an alpha column reference.
		to-column-number	Convert alpha column reference to a numeric column reference.
		to-field-spec		Convert field strings to words.
		to-string-date		Convert a string or Rebol date to a YYYY-MM-DD string.
		to-string-time		Convert a string or Rebol time to a HH:MM:SS string.
		union-only			Returns the union of two tables.
		unzip				Decompresses file from archive.
		write-dsv			Write block(s) of values to a delimited text file.
		write-excel			Write block(s) of values to an Excel file.
	}
]

case [
	;	*** Red ***
	not rebol [

		foreach word [ajoin decimal! deline reform to-rebol-file] [
			all [value? word print [word "already defined!"]]
		]

		ajoin: function [
			block [block!]
			"Reduces and joins a block of values into a new string."
		] [
			make string! reduce block
		]

		decimal!: float!

		deline: function [
			string [any-string!]
			/lines "Return block of lines (works for LF, CR, CR-LF endings) (no modify)"
			"Converts string terminators to standard format, e.g. CRLF to LF"
		] [
			trim/with string cr
			either lines [split string lf] [string]
		]

		reform: function [
			"Forms a reduced block and returns a string"
			value "Value to reduce and form"
		] [
			form reduce value
		]

		to-month-number: function [
			"Convert month name to number"
			month [string!]
		] [
			index? any [
				find ["Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"] month
				find system/locale/months month
			]
		]

		to-rebol-file: :to-red-file
	]
	;	*** Oldes R3 ***
	3 = system/version/1 [

		average: function [
			"Returns the average of all values in a block"
			block [block!]
		] [
			all [empty? block return none]
			divide sum block length? block
		]

		sum: function [
			"Returns the sum of all values in a block"
			values [block!]
		] [
			result: 0
			foreach value values [result: result + value]
			result
		]
	]
	true [
		print "Unsupported Rebol version or derivative"
		quit
	]
]

ctx-munge: context [

	settings: context [

		version: system/script/header/version

		build: either rebol ['r3] ['red]

		;	Features

		windows?:	"a\b" = to-local-file %a/b
		x64?:		integer? 9223372036854775807
		zip?:		not none? attempt [codecs/zip system/options/log/zip: 0]

		stack: copy []

		start-time: start-used: none

		called: function [
			name [word! none!]
			/file path [file! url! binary!]
		] [
			all [
				file
				not binary! path
				not exists? path
				error reform ["Cannot open" path]
			]
			any [trace exit]
			either word? name [
				insert/dup message: reform ["Call" either all [file not binary? path] [reform [name "on" last split-path path]] [name]] "  " length? stack
				all [
					empty? stack
					recycle
					recycle
					settings/start-time: now/precise
					settings/start-used: stats
				]
				append stack name
			] [
				insert/dup message: reform ["Exit" last stack] "  " -1 + length? stack
				take/last stack
			]

			print [next next next to-string-time/precise difference now/precise start-time head insert/dup s: form to integer! stats - start-used / 1048576 " " 4 - length? s message]
		]

		exited: function [] [
			any [empty? stack called none]
		]

		error: function [
			message [string!]
		] [
			clear stack
			cause-error 'user 'message message
		]

		as-is: console: denull: trace: true

		field-scan: false
	]

	as-date: function [
		"Convert a string date to a YYYY-MM-DD string (does not handle Excel or YYYYDDMM)"
		string [string!]
		/mdy "Month/Day/Year format"
	] compose/deep [
		any [
			attempt [
				date: split string make bitset! "/- "
				(either settings/build = 'red [[
					date: to date! either mdy [
						reduce [to integer! date/2 either digits? date/1 [to integer! date/1] [to-month-number date/1] to integer! date/3]
					] [
						reduce [to integer! date/1 either digits? date/2 [to integer! date/2] [to-month-number date/2] to integer! date/3]
					]
				]] [[
					date: to date! either mdy [
						ajoin [date/2 "/" date/1 "/" date/3]
					] [
						ajoin [date/1 "/" date/2 "/" date/3]
					]
				]])
				all [date/year < 100 date/year: date/year + 2000]
				ajoin [date/year "-" next form 100 + date/month "-" next form 100 + date/day]
			]
			settings/error reform [string "is not a valid date"]
		]
	]

	as-time: function [
		"Convert a string time to an HH:MM string (does not handle Excel or YYYYDDMM)"
		time [string!]
	] [
		either attempt [hhmm: to time! trim/with copy time "APM "] [
			all [
				find time "PM"
				hhmm/1 < 12
				hhmm/1: hhmm/1 + 12
			]
			all [#":" = second hhmm: form hhmm insert hhmm #"0"]
			copy/part hhmm 5
		] [
			settings/error reform [time "is not a valid time"]
		]
	]

	call-out: function [
		"Call OS command returning STDOUT"
		cmd [string!]
	] compose [
		all [settings/console settings/called 'call-out]
		(either settings/windows? [[call/wait/output/error]] [[call/wait/shell/output/error]]) cmd stdout: make string! 65536 stderr: make string! 1024
		any [empty? stderr settings/error trim/lines stderr]
		also deline stdout all [settings/console settings/exited]
	]

	check: function [
		"Verify data structure"
		data [block!]
		/limit messages [integer!] "Limit messages to display"
	] [
		limit: any [messages 1000]
		messages: 0
		unless empty? data [
			cols: length? data/1
			i: 1
			foreach row data [
				if message: case [
					not block? row		[reform ["expected block but found" type? row]]
					zero? length? row	["empty"]
					cols <> length? row	[reform ["expected" cols "column(s) but found" length? row]]
					find row none		["contains a none value"]
					find row block!		["contains a block value"]
				] [
					all [
						messages < limit
						print reform ["Row" i message]
					]
					messages: messages + 1
				]
				i: i + 1
			]
		]
		either zero? messages [true] [false]
	]

	cols?: function [
		"Number of columns in a delimited file or string"
		data [file! url! binary! string!]
		/with
			delimiter [char!]
		/sheet
			number [integer!]
	] [
		all [settings/console settings/called 'cols?]
		also either excel? data [
			any [
				binary? data
				data: unzip data rejoin [%xl/worksheets/Sheet any [number 1] %.xml]
				settings/error reform [number "is not a valid sheet number"]
			]
			dim: cols: 0
			all [
				find data #{3C64696D}	; <dim
				parse to string! copy/part find data #{3C64696D} 32 [
					thru {<dimension ref="} thru ":" copy dim some letter (dim: to-column-number dim) to end
				]
			]
			all [
				find data #{3C636F6C}	; <col
				parse to string! copy/part find/last data #{3C636F6C} find data #{3C2F636F6C733E} [
					thru {="} copy cols to {"} (cols: to integer! cols) to end
				]
			]
			max dim cols
		] [
			length? either with [fields?/with data delimiter] [fields? data]
		] all [settings/console settings/exited]
	]

	deduplicate: function [
		"Remove earliest occurrences of duplicate non-empty key field"
		blk [block!]
		key [word! integer!]
		/latest "Remove latest occurrences of duplicate key field"
	] [
		any [1 < length? blk return blk]

		all [
			word? key
			any [
				key: index? find to-field-spec blk/1 key
				settings/error "Invalid key column"
			]
		]

		row-map: make map! length? blk

		any [latest reverse blk]

		remove-each row blk compose/deep [
			case [
				all [series? pick row (key) empty? pick row (key)]	[false]
				select row-map pick row (key)						[true]
				true [
					put row-map pick row (key) 0
					false
				]
			]
		]

		any [latest reverse blk]

		blk
	]

	delimiter?: function [
		"Probable delimiter, with priority given to comma, tab, bar, tilde, then semi-colon"
		data [file! url! string!]
	] [
		data: copy first-line data
		last sort/skip reduce [
			subtract length? data length? trim/with data #";" #";"
			subtract length? data length? trim/with data #"~" #"~"
			subtract length? data length? trim/with data #"|" #"|"
			subtract length? data length? trim/with data tab tab
			subtract length? data length? trim/with data #"," #","
		] 2
	]

	delta: function [
		"Remove source rows that exist in target"
		source [block!]
		target [block!]
	] [
		all [settings/console settings/called 'delta]
		remove-each row source [
			find/only target row
		]
		also source all [settings/console settings/exited]
	]

	dezero: function [
		"Remove leading zeroes from string"
		string [string!]
	] [
		while [string/1 = #"0"] [remove string]
		string
	]

	difference-only: function [
		"Returns the difference of two tables"
		table1 [block!]
		table2 [block!]
	] [
		all [
			not empty? table1
			not empty? table2
			(length? table1/1) <> length? table2/1
			settings/error "Column count mismatch"
		]

		blk: copy []

		map1: make map! length? table1: distinct copy table1

		foreach row table1 [
			put map1 form row 0
		]

		map2: make map! length? table2: distinct copy table2

		foreach row table2 [
			put map2 form row 0
		]

		blk: copy []

		foreach row table1 [
			any [
				select map2 form row
				append/only blk row
			]
		]

		foreach row table2 [
			any [
				select map1 form row
				append/only blk row
			]
		]

		blk
	]

	digit: charset [#"0" - #"9"]

	digits?: function [
		"Returns TRUE if data not empty and only contains digits"
		data [string! binary!]
	] compose/deep [
		all [not empty? data not find data (complement digit)]
	]

	discard: function [
		"Remove empty columns"
		data [block!]
		/verbose
	] [
		all [settings/console settings/called 'discard]
		unless empty? data [
			unused: copy []
			repeat col length? first data [
				discard?: true
				foreach row next data [
					unless empty? row/:col [
						discard?: false
						break
					]
				]
				all [
					discard?
					insert unused col
					verbose
					print ["Discard" data/1/:col]
				]
			]
			foreach row data [
				foreach col unused [
					remove at row col
				]
			]
		]
		also data all [settings/console settings/exited]
	]

	distinct: function [
		"Remove duplicate and empty rows"
		data [block!]
	] [
		all [settings/console settings/called 'distinct]
		old-row: none
		remove-each row sort data [
			any [
				all [
					find ["" #[none]] row/1
					1 = length? unique row
				]
				either row = old-row [true] [old-row: row false]
			]
		]
		also data all [settings/console settings/exited]
	]

	enblock: function [
		"Convert a block of values to a block of row blocks"
		data [block!]
		cols [integer!]
	] [
		all [block? data/1 return data]
		all [settings/console settings/called 'enblock]
		any [integer? rows: divide length? data cols settings/error "Cols not a multiple of length"]
		blk: copy data
		clear data
		loop rows compose [
			append/only data take/part/last blk (cols)
		]
		also reverse data all [settings/console settings/exited]
	]

	enzero: function [
		"Add leading zeroes to a string"
		string [string!]
		length [integer!]
	] [
		insert/dup string #"0" length - length? string
		string
	]

	excel?: function [
		"Returns TRUE if file is Excel or worksheet is XML"
		data [file! url! binary! string!]
	] [
		switch/default type?/word data [
			string!		[false]
			binary!		[not none? find copy/part data 8 #{3C3F786D6C}]	; ignore UTF mark
		] [
			all [
				suffix? data
				%.xls = copy/part suffix? data 4
				#{504B} = read/binary/part data 2	; PK
			]
		]
	]

	export: function [
		"Export words to global context"
		words [block!] "Words to export"
	] [
		foreach word words [
			do compose [(to set-word! word) (to get-word! in self word)]
		]
		words
	]

	fields?: function [
		"Column names in a delimited file"
		data [file! url! binary! string!]
		/with
			delimiter [char!]
		/sheet
			number [integer!]
	] [
		all [settings/console settings/called 'fields?]
		also either excel? data [
			load-xml/sheet/fields data any [number 1]
		] [
			data: first-line data
			delimiter: any [delimiter delimiter? data]
			case [
				empty? data [
					make block! 0
				]
				#"^"" = first data [
					load-dsv/flat/ignore/with/csv data delimiter
				]
				true [
					load-dsv/flat/ignore/with data delimiter
				]
			]
		] all [settings/console settings/exited]
	]

	first-line: function [
		"Returns the first non-empty line of a file"
		data [file! url! string! binary!]
		/local cols len row
	] [
		data: deline/lines either string? data [
			copy/part data 4096
		] [
			read-string either binary? data [copy/part data 4096] [read/binary/part data 4096]
		]

		either settings/field-scan [
			remove-each line data [find ["" "^L"] trim line]
			cols: 0
			row: copy ""
			foreach line copy/part data 10 [
				all [
					cols < len: length? unique load-dsv/flat/ignore/with line either find line tab [tab] [#","]
					cols: len
					row: line
				]
			]
			return row
		] [
			foreach line data [
				any [find ["" "^L"] line return line]
			]
		]

		copy ""
	]

	flatten: function [
		"Flatten nested block(s)"
		data [block!]
	] [
		;	http://www.rebol.org/view-script.r?script=flatten.r
		all [settings/console settings/called 'flatten]
		result: copy []
		foreach row copy/deep data [
			append result row
		]
		also result all [settings/console settings/exited]
	]

	intersect-only: function [
		"Returns the intersection of two tables"
		table1 [block!]
		table2 [block!]
	] [
		all [
			not empty? table1
			not empty? table2
			(length? table1/1) <> length? table2/1
			settings/error "Column count mismatch"
		]

		blk: copy []

		map: make map! length? table2: distinct copy table2

		foreach row table2 [
			put map form row 0
		]

		foreach row distinct copy table1 [
			all [
				select map form row
				append/only blk row
			]
		]

		blk
	]

	last-line: function [
		"Returns the last non-empty line of a file"
		data [file! url! string!]
	] [
		data: reverse deline/lines either string? data [skip data -4096 + length? data] [
			read-string read/binary/seek data max 0 -4096 + size? data
		]

		foreach line data [
			any [find ["" "^L"] line return line]
		]

		copy ""
	]

	letter: charset [#"A" - #"Z" #"a" - #"z"]

	letters?: function [
		"Returns TRUE if data only contains letters"
		data [string! binary!]
	] compose [
		not find data (complement letter)
	]

	like: function [
		"Finds a value in a series, expanding * (any characters) and ? (any one character), and returns TRUE if found"
		series [any-string!] "Series to search"
		value [any-string!] "Value to find"
		/local part
	] either settings/build = 'r3x [[
		;	blocked by https://github.com/Oldes/Rebol-issues/issues/2522
		all [find/any/match series value true]
	]] [compose [
		;	http://stackoverflow.com/questions/31612164/does-anyone-have-an-efficient-r3-function-that-mimics-the-behaviour-of-find-any
		all [empty? series return none]
		literal: (complement charset "*?")
		value: collect [
			parse value [
				end (keep [return (none)]) |
				some #"*" end (keep [to end]) |
				some [
					#"?" (keep 'skip) |
					copy part some literal (keep part) |
					some #"*" any [#"?" (keep 'skip)] opt [copy part some literal (keep 'thru keep part)]
				]
			]
		]
		any [parse series [some [result: value (return true)]] none]
	]]

	list: function [
		"Uses settings to optionally trim strings and set the new-line marker"
		data [block!]
	] [
		either settings/console [
			foreach row data [all [block? row new-line/all row false]]
			settings/exited
			new-line/all data true
		] [data]
	]

	load-dsv: function [
		"Parses delimiter-separated values into row blocks"
		source [file! url! binary! string!]
		/part "Offset position(s) to retrieve"
			columns [block! integer! word!]
		/where "Expression that can reference columns as row/1, row/2, etc or &field"
			condition [block!]
		/with "Alternate delimiter (default is tab, bar then comma)"
			delimiter [char!]
		/ignore "Ignore truncated row errors"
		/csv "Parse as CSV even though not comma-delimited"
		/flat "Flatten rows"
		/local v
	] compose [
		;	http://www.rebol.org/view-script.r?script=csv-tools.r
		all [settings/console settings/called 'load-dsv]

		source: either string? source [
			deline source
		] [
			all [
				excel? source
				settings/error reform [last split-path source "is an Excel file"]
			]
			all [
				#{22} = either binary? source [copy/part source 1] [to binary! read/part source 1]
				csv: true
			]
			read-string source
		]

		recycle
		recycle

		any [with delimiter: delimiter? source]

		value: either any [delimiter = #"," csv] [
			[
				any [#" "] {"} copy v to [{"} | end]
				any [{"} x: {"} to [{"} | end] y: (append/part v x y)]
				[{"} to [delimiter | lf | end]] (append row v)
				| any [#" "] copy v to [delimiter | lf | end] (append row trim/tail v)
			]
		] [
			[any [#" "] copy v to [delimiter | lf | end] (append row trim/tail v)]
		]

		rule: copy/deep [
			any [
				not end (row: make block! cols)
				value
				any [delimiter value] [lf | end] ()
			]
		]

		cols: either all [ignore not find source newline] [32] [length? fields: fields?/with source delimiter]

		;	Replace field references with row paths

		all [
			find reform [columns condition] "&"
			set [columns condition] munge/spec/part/where reduce [fields] columns condition
		]

		line: 0

		blk: copy []

		append last last rule compose/deep [
			line: line + 1
			(either settings/as-is [] [[foreach val row [trim/lines val]]])
			(either settings/denull [[foreach val row [all [find/case ["NULL" "null"] val clear val]]]] [])
			all [
				row <> [""]
				(either where [condition] [])
				(either ignore [] [compose/deep [any [(cols) = len: length? row settings/error reform ["Expected" (cols) "values but found" len "on line" line]]]])
				(either part [
					part: copy/deep [reduce []]
					foreach col columns: to block! columns [
						append part/2 either integer? col [
							all [not ignore any [col < 1 col > cols] settings/error reform ["Invalid /part position:" col]]
							compose [(append to path! 'row col)]
						] [col]
					]
					compose [row: (part)]
				] [])
				row <> last blk
				(either flat [[append]] [[append/only]]) blk row
			]
		]

		parse source bind rule 'row

		either flat [
			also either ignore [blk] [new-line/all/skip blk true cols] all [settings/console settings/exited]
		] [list blk]
	]

	load-fixed: function [
		"Loads fixed-width values from a file"
		file [file! url!]
		widths [block!]
		/part
			columns [integer! block!]
	] [
		all [settings/console settings/called 'load-fixed]

		spec: copy []
		pos: 1

		either part [
			part: copy []
			foreach width widths [
				append/only part reduce [pos width]
				pos: pos + width
			]
			foreach col to block! columns [
				append spec compose [trim/lines copy/part at line (part/:col/1) (part/:col/2)]
			]
		] [
			foreach width widths [
				append spec compose [trim/lines copy/part at line (pos) (width)]
				pos: pos + width
			]
		]

		blk: copy []

		foreach line read/lines file compose/deep [
			any [
				empty? trim copy line
				append/only blk reduce [(spec)]
			]
		]

		recycle
		recycle

		list blk
	]

	load-xml: function [
		"Loads an Office XML sheet"
		file [file!]
		/part "Offset position(s) to retrieve"
			columns [block! integer! word!]
		/where "Expression that can reference columns as row/1, row/2, etc or &field"
			condition [block!]
		/sheet number [integer!]
		/fields
		/local s v x col type val
	] compose [
		all [settings/console settings/called 'load-xml]

		any [
			excel? file
			settings/error reform [file "is not a valid Excel file"]
		]

		any [
			sheet: unzip file rejoin [%xl/worksheets/Sheet number: any [number 1] %.xml]
			settings/error reform [number "is not a valid sheet number"]
		]

		strings: make block! 65536

		parse read-string unzip file %xl/sharedStrings.xml [
			any [
				thru "<si>"
				thru ">" any [#" "] copy s to "<" (
					either s [
						all [
							find trim/lines s "&"
							foreach [code char] [
								{&amp;}		{&}
								{&lt;}		{<}
								{&gt;}		{>}
								{&quot;}	{"}
								{&apos;}	{'}
							] [replace/all s code char]
						]
					] [s: copy ""]
					append strings s
				)
			]
		]

		recycle
		recycle

		if settings/denull [
			foreach val strings [
				all [find/case ["NULL" "null"] val clear val]
			]
		]

		cols: cols? sheet

		rule: copy/deep [
			to "<row"
			any [
				opt [newline]
				opt ["<row" (append/dup row: make block! cols "" cols)]
				thru {<c r="} copy col to digit
				copy type thru ">"
				opt ["<v>" copy val to "</v></c>" (
					poke row to-column-number col either find type {t="s"} [copy pick strings 1 + to integer! val] [trim val]
				) "</v></c>"]
				opt [newline]
				opt ["</row>" ()]
			]
		]

		if any [fields find reform [columns condition] "&"] [
			parse read-string copy/part sheet find/tail sheet #{3C2F726F773E} rule
			recycle
			recycle
			all [fields return row]
			set [columns condition] munge/spec/part/where reduce [row] columns condition
		]

		append last last last rule compose/deep [
			(either settings/as-is [] [[foreach val row [trim/lines val]]])
			all [
				(either where [condition] [])
				(either part [
					part: copy/deep [reduce []]
					foreach col columns: to block! columns [
						append part/2 either integer? col [
							all [any [col < 1 col > (cols)] settings/error reform ["Invalid /part position:" col]]
							compose [(append to path! 'row col)]
						] [col]
					]
					compose [row: (part)]
				] [])
				row <> last blk
				append/only blk row
			]
		]

		blk: copy []

		parse read-string sheet bind rule 'row

		recycle
		recycle

		list blk
	]

	max-of: function [
		"Returns the largest value in a series"
		series [series!] "Series to search"
	] [
		all [empty? series return none]
		val: series/1
		foreach v series [val: max val v]
		val
	]

	merge: function [
		"Join outer block to inner block on primary key"
		outer [block!] "Outer block"
		key1 [integer!]
		inner [block!] "Inner block to index"
		key2 [integer!]
		columns [block!] "Offset position(s) to retrieve in merged block"
		/default "Use none on inner block misses"
	] [
		;	build rowid map of inner block
		map: make map! length? inner
		i: 0
		foreach row inner [
			put map row/:key2 i: i + 1
		]
		;	build column picker
		code: copy []
		foreach col columns [
			append code compose [(append to path! 'row col)]
		]
		;	iterate through outer block
		blk: make block! length? outer
		do compose/deep [
			either default [
				foreach row outer [
					all [
						i: select map row/:key1
						append row inner/:i
					]
					append/only blk reduce [(code)]
				]
			] [
				foreach row outer [
					all [
						i: select map row/:key1
						append row inner/:i
						append/only blk reduce [(code)]
					]
				]
			]
		]

		blk
	]

	min-of: function [
		"Returns the smallest value in a series"
		series [series!] "Series to search"
	] [
		all [empty? series return none]
		val: series/1
		foreach v series [val: min val v]
		val
	]

	mixedcase: function [
		"Converts string of characters to mixedcase"
		string [string!]
	] [
		uppercase/part lowercase string 1
		foreach char [#"'" #" " #"-" #"." #","] [
			all [find string char string: next find string char mixedcase string]
		]
		string: head string
	]

	munge: function [
		"Load and/or manipulate a block of tabular (column and row) values"
		data [block!]
		/delete "Delete matching rows (returns original block)"
			clause
		/part "Offset position(s) and/or values to retrieve"
			columns [block! integer! word! none!]
		/where "Expression that can reference columns as row/1, row/2, etc"
			condition
		/group "One of avg, count, max, min or sum"
			having [word! block!] "Word or expression that can reference the initial result set column as count, max, etc"
		/spec "Return columns and condition with field substitutions"
	] [
		all [empty? data return data]

		all [delete where: true condition: clause]

		if all [where condition not block? condition] [
			;	http://www.rebol.org/view-script.r?script=binary-search.r
			lo: 1
			hi: rows: length? data
			mid: to integer! hi + lo / 2
			while [hi >= lo] [
				if condition = key: first data/:mid [
					lo: hi: mid
					while [all [lo > 1 condition = first data/(lo - 1)]] [lo: lo - 1]
					while [all [hi < rows condition = first data/(hi + 1)]] [hi: hi + 1]
					break
				]
				either condition > key [lo: mid + 1] [hi: mid - 1]
				mid: to integer! hi + lo / 2
			]
			all [
				lo > hi
				return either delete [data] [make block! 0]
			]
			rows: hi - lo + 1
			either delete [
				return head remove/part at data lo rows
			] [
				data: copy/part at data lo rows
				where: condition: none
			]
		]

		all [settings/console settings/called 'munge]

		;	Replace field references with row paths

		if find reform [columns condition] "&" [

			fields: to-field-spec first head data

			if find form columns "&" [
				;	replace &Word with n
				number-map: make map! 32
				repeat i length? fields [
					put number-map fields/:i i
				]
				repeat i length? columns: to block! columns [
					all [
						word? word: columns/:i
						any [
							columns/:i: select number-map word
							settings/error reform ["Invalid /part position:" word]
						]
					]
				]
			]

			if find form condition "&" [
				;	replace &Word with row/n
				path-map: make block! 32
				repeat i length? fields [
					append path-map reduce [
						fields/:i
						append to path! 'row i
					]
				]
				replace-deep condition: copy/deep condition path-map
				if find form condition "&" [
					;	replace &Set-Word: with row/n:
					repeat i length? path-map [
						path-map/:i: either word? path-map/:i [to set-word! path-map/:i] [to set-path! path-map/:i]
					]
					replace-deep condition path-map
				]
			]

			all [spec also return reduce [columns condition] all [settings/console settings/exited]]
		]

		case [
			delete [
				remove-each row data bind compose/only [all (condition)] 'row
				also return data all [settings/console settings/exited]
			]
			any [part where] [
				columns: either part [
					part: copy/deep [reduce []]
					cols: length? data/1
					foreach col to block! columns [
						append part/2 either integer? col [
							all [any [col < 1 col > cols] settings/error reform ["Invalid /part position:" col]]
							compose [(append to path! 'row col)]
						] [col]
					]
					part
				] ['row]
				blk: copy []
				foreach row data compose [
					(
						either where [
							either settings/build = 'red [
								bind compose/deep [all [(condition) append/only blk (columns)]] 'row
							] [
								compose/deep [all [(condition) append/only blk (columns)]]
							]
						] [
							compose [append/only blk (columns)]
						]
					)
				]
				all [
					empty? blk
					also return blk all [settings/console settings/exited]
				]
				data: blk
			]
		]

		if group [
			words: unique flatten to block! having
			operation: case [
				find words 'avg		['average]
				find words 'count	['count]
				find words 'max		['max-of]
				find words 'min		['min-of]
				find words 'sum		['sum]
				true				[settings/error "Invalid group operation"]
			]
			case [
				operation = 'count [
					i: 0
					blk: copy []
					group: copy first sort data
					foreach row data [
						either group = row [i: i + 1] [
							append group i
							append/only blk group
							group: copy row
							i: 1
						]
					]
					append group i
					append/only blk group
				]
				1 = length? data/1 [
					also return do compose [(operation) flatten data] all [settings/console settings/exited]
				]
				true [
					val: copy []
					blk: copy []
					group: copy/part first sort data len: -1 + length? data/1
					foreach row data compose/deep [
						either group = copy/part row (len) [append val last row] [
							append group (operation) val
							append/only blk group
							group: copy/part row (len)
							append val: copy [] last row
						]
					]
					append group do compose [(operation) val]
					append/only blk group
				]
			]
			data: blk

			if block? having [
				replace-deep having: copy/deep having reduce [operation append to path! 'row length? data/1]
				data: munge/where data having
			]
		]

		list data
	]

	oledb: function [
		"Execute an OLEDB statement"
		file [file! url!]
		statement [string!] "SQL statement in the form (Excel) 'SELECT F1 FROM SHEET1' or (Access) 'SELECT Column FROM Table'"
		/local sheet blk
	] [
		if settings/windows? [
			all [settings/console settings/called/file 'oledb file]
			statement: replace/all copy statement {'} {''}
			properties: either %.accdb = suffix? file [""] [
				parse statement [thru "FROM " copy sheet [to " " | to end]]
				replace statement reform ["FROM" sheet] ajoin ["FROM ['+$o.GetSchema('Tables').rows[" -1 + to integer! skip sheet 5 "].TABLE_NAME+']"]
				{;Extended Properties=''Excel 12.0 Xml;HDR=NO;IMEX=1;Mode=Read''}
			]
			blk: remove load-dsv/csv/with call-out ajoin [
				either settings/x64? ["powershell "] ["C:\Windows\SysNative\WindowsPowerShell\v1.0\powershell.exe "]
				{-nologo -noprofile -command "}
					{$o=New-Object System.Data.OleDb.OleDbConnection('Provider=Microsoft.ACE.OLEDB.12.0;}
						{Data Source=\"} replace/all to-local-file clean-path file "'" "''" {\"} properties {');}
					{$o.Open();$s=New-Object System.Data.OleDb.OleDbCommand('} statement {');}
					{$s.Connection=$o;}
					{$t=New-Object System.Data.DataTable;}
					{$t.Load($s.ExecuteReader());}
					{$o.Close();}
					{$t|ConvertTo-CSV -Delimiter `t -NoTypeInformation}
				{"}
			] tab
			also either all [
				1 = length? blk
				[""] = unique first blk
			] [
				settings/error reform [file "is not a valid Excel file"]
			] [
				blk
			] all [settings/console settings/exited]
		]
	]

	read-string: function [
		"Read string from a text file"
		source [file! url! binary!]
	] compose/deep [
		all [settings/console settings/called 'read-string]
		also either binary? source [
			deline to string! source
		] [
			(either settings/build = 'r3 [[read/string]] [[read]]) source
		] all [settings/console settings/exited]
	]

	replace-deep: function [
		"Replaces all occurrences of search values with new values in a block or nested block"
		data [block!] "Block to replace within (modified)"
		map [map! block!] "Map of values to replace"
	] [
		repeat i length? data [
			either block? data/:i [replace-deep data/:i map] [
				all [
					not path? data/:i
					not set-path? data/:i
					val: select map data/:i
					any [
						equal? type? data/:i type? val
						all [word? data/:i path? val]
						all [set-word? data/:i set-path? val]
					]
					data/:i: val
				]
			]
		]
		data
	]

	rows?: function [
		"Number of rows in a delimited file or string"
		data [file! url! binary! string!]
		/sheet
			number [integer!]
		/local rows
	] [
		either excel? data [
			any [
				binary? data
				data: unzip data rejoin [%xl/worksheets/Sheet any [number 1] %.xml]
				settings/error reform [number "is not a valid sheet number"]
			]
			all [
				find data #{3C726F77}
				parse to string! find/last data #{3C726F77} [
					thru {"} copy rows to {"} (return to integer! rows)
				]
			]
			0
		] [
			either any [
				all [file? data zero? size? data]
				empty? data
			] [0] [
				i: 1
				parse either file? data [read data] [data] [
					any [thru newline (i: i + 1)]
				]
				i
			]
		]
	]

	second-last: penult: function [
		"Returns the second last value of a series"
		series [series!]
	] [
		pick series subtract length? series 1
	]

	sheets?: function [
		"Excel sheet names"
		file [file! url!]
		/local name
	] [
		all [settings/console settings/called 'sheets?]
		blk: copy []
		parse to string! unzip file %xl/workbook.xml [
			any [thru {<sheet name="} copy name to {"} (append blk trim name)]
		]
		also blk all [settings/console settings/exited]
	]

	sqlcmd: function [
		"Execute a SQL Server statement"
		server [string!]
		database [string!]
		statement [string!]
		/key "Columns to convert to integer"
			columns [integer! block!]
		/headings "Keep column headings"
		/string "Return string instead of block"
		/flat "Flatten rows"
		/identity
		/local id
	] [
		if settings/windows? [
			all [settings/console settings/called 'sqlcmd]

			all [identity statement: rejoin [statement ";SELECT SCOPE_IDENTITY()"]]

			stdout: either 32000 > length? statement [
				call-out reform compose ["sqlcmd -m 1 -X -S" server "-d" database "-I -Q" ajoin [{"} statement {"}] {-W -w 65535 -s"^-"} (either headings [] [{-h -1}])]
			] [
				write file: to file! append replace datetime " " "_" %.sql statement
				also call-out reform compose ["sqlcmd -m 1 -X -S" server "-d" database "-I -i" file {-W -w 65535 -s"^-"} (either headings [] [{-h -1}])] attempt [delete file]
			]

			all [empty? stdout return either string [make string! 0] [make block! 0]]

			case [
				string [
					also stdout all [settings/console settings/exited]
				]
				identity [
					parse stdout [thru ")^/" copy id to "^/" (return to integer! id)]
				]
				stdout/1 = #"^/" [
					also make block! 0 all [settings/console settings/exited]
				]
				like stdout "Msg*,*Level*,*State*,*Server" [
					settings/error trim/lines find stdout "Line"
				]
				like stdout "Warning:*(0 rows affected)" [
					settings/error find/tail first deline/lines stdout "Warning: "
				]
				true [
					stdout: copy/part stdout find stdout "^/^/("

					either flat [
						cols: cols?/with first-line stdout tab

						stdout: load-dsv/flat/with stdout tab

						all [headings remove/part skip stdout cols cols]

						if key [
							all [headings stdout: skip stdout cols]
							rows: divide length? stdout cols
							foreach i to block! columns [
								loop rows [
									stdout/:i: to integer! stdout/:i
									i: i + cols
								]
							]
							stdout: head stdout
						]
					] [
						stdout: load-dsv/with stdout tab

						all [headings remove next stdout]

						all [
							key
							foreach row either headings [next stdout] [stdout] [
								foreach i to block! columns [
									row/:i: to integer! row/:i
								]
							]
						]
					]

					also stdout all [settings/console settings/exited]
				]
			]
		]
	]

	sqlite: function [
		"Execute a SQLite statement"
		database [file! url!]
		statement [string!]
	] [
		load-dsv/with call-out ajoin [{sqlite3 -separator "^-" } to-local-file database { "} statement {"}] tab
	]

	to-column-alpha: function [
		"Convert numeric column reference to an alpha column reference"
		number [integer!] "Column number between 1 and 702"
	] [
		any [positive? number settings/error "Positive number expected"]
		any [number <= 702 settings/error "Number cannot exceed 702"]
		either number <= 26 [form #"@" + number] [
			ajoin [
				#"@" + to integer! number - 1 / 26
				either zero? r: mod number 26 ["Z"] [#"@" + r]
			]
		]
	]

	to-column-number: function [
		"Convert alpha column reference to a numeric column reference"
		alpha [word! string! char!]
	] [
		any [find [1 2] length? alpha: uppercase form alpha settings/error "One or two letters expected"]
		any [find letter last alpha settings/error "Valid characters are A-Z"]
		minor: subtract to integer! last alpha: uppercase form alpha 64
		either 1 = length? alpha [minor] [
			any [find letter alpha/1 settings/error "Valid characters are A-Z"]
			(26 * subtract to integer! alpha/1 64) + minor
		]
	]

	to-field-spec: function [
		"Convert field strings to words"
		fields [block!]
	] [
		invalid-spec-chars: complement charset [#"A" - #"Z" #"a" - #"z" #"0" - #"9" #"-" #"_" #"."]

		blk: copy []

		foreach field fields [
			remove-each char field: form field [find invalid-spec-chars char]
			append blk to word! append copy "&" field
		]

		blk
	]

	to-string-date: function [
		"Convert a string or Rebol date to a YYYY-MM-DD string"
		date [string! date!]
		/mdy "Month/Day/Year format"
		/ydm "Year/Day/Month format"
	] compose/deep [
		if string? date [
			string: date
			any [
				attempt [
					either any [ ; Excel
						all [digits? date 6 > length? date]
						all [find date "." attempt [to decimal! date] date: first split date "."]
					] [
						date: 30-Dec-1899 + to integer! date
						all [
							mdy
							day: date/3
							date/3: date/2
							date/2: day
						]
					] [
						all [
							find ["Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"] copy/part date 3
							date: remove/part copy date index? find date " "
						]
						date: either digits? date [
							;	YYYYDDMM
							reduce [copy/part date 4 copy/part skip date 4 2 copy/part skip date 6 2]
						] [
							split date make bitset! "/- "
						]
						date: to date! case [
							mdy		[reduce [to integer! date/2 to integer! date/1 to integer! date/3]]
							ydm		[reduce [to integer! date/2 to integer! date/3 to integer! date/1]]
							true	[reduce [to integer! date/1 to integer! date/2 to integer! date/3]]
						]
						all [
							date/year < 100
							date/year: date/year + either date/year <= (now/year - 1950) [2000] [1900]
						]
					]
					true
				]
				settings/error reform [string "is not a valid date"]
			]
		]
		ajoin [date/year "-" next form 100 + date/month "-" next form 100 + date/day]
	]

	to-string-time: function [
		"Convert a string or Rebol time to a HH:MM:SS string"
		time [string! date! time!]
		/minutes "HH:MM"
		/precise "HH:MM:SS.mmm"
	] [
		unless time? time [
			string: time
			any [
				attempt [
					time: case [
						date? time [time/time]
						all [not find time ":" find time "."] [	; Excel - don't match "00:00:00.000"
							24:00:00 * to decimal! find time "."
						]
						digits? time [
							to time! ajoin [copy/part time 2 ":" copy/part skip time 2 2 ":" copy/part skip time 4 2]
						]
						true [
							hhmm: to time! trim/with copy time "APM "
							all [
								find time "PM"
								hhmm/1 < 12
								hhmm/1: hhmm/1 + 12
							]
							hhmm
						]
					]
				]
				settings/error reform [string "is not a valid time"]
			]
		]
		all [#":" = second time: form time insert time #"0"]
		case [
			minutes	[copy/part time 5]
			precise	[
				clear skip time 12
				append time pick [":00.000" "" "" ".000" "" "00" "0" ""] -4 + length? time
			]
			true	[either 5 = length? time [append time ":00"] [copy/part time 8]]
		]
	]

	union-only: function [
		"Returns the union of two tables"
		table1 [block!]
		table2 [block!]
	] [
		all [
			not empty? table1
			not empty? table2
			(length? table1/1) <> length? table2/1
			settings/error "Column count mismatch"
		]
		distinct append copy table1 table2
	]

	unzip: function [
		"Decompresses file from archive"
		source [file! url! binary!]
		file [file!]
	] [
		attempt [second second codecs/zip/decode/only source to block! file]
	]

	write-dsv: function [
		"Write block(s) of values to a delimited text file"
		file [file! url!] "csv or tab-delimited text file"
		data [block!]
		/utf8
	] [
		all [settings/console settings/called 'write-dsv]
		b: make block! length? data
		foreach row data compose/deep [
			s: copy ""
			foreach value row [
				(
					either %.csv = suffix? file [
						[
							case [
								not series? value [
									append s value
								]
								any [find trim/with value {"} "," find value lf] [
									append s #"^""
									append s value
									append s #"^""
								]
								true [
									append s value
								]
							]
							append s #","
						]
					] [
						[
							append s value
							append s #"^-"
						]
					]
				)
			]
			take/last s
			any [empty? s append b s]
		]
		also either utf8 [
			write file #{EFBBBF}
			write/append/lines file b
		] [write/lines file b] all [settings/console settings/exited]
	]

	write-excel: function [
		"Write block(s) of values to an Excel file"
		file [file! url!]
		data [block!] "Name [string!] Data [block!] Widths [block!] records"
		/filter "Add auto filter"
	] [
		;	http://officeopenxml.com/anatomyofOOXML-xlsx.php
		any [%.xlsx = suffix? file settings/error "not a valid .xlsx file extension"]

		xml-content-types:	copy ""
		xml-workbook:		copy ""
		xml-workbook-rels:	copy ""
		xml-version:		{<?xml version="1.0" encoding="UTF-8" standalone="yes"?>}

		sheet-number:		1

		xml-archive:		copy []

		foreach [sheet-name block spec] data [
			unless empty? block [
				width: length? spec

				append xml-content-types ajoin [{<Override PartName="/xl/worksheets/Sheet} sheet-number {.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>}]
				append xml-workbook ajoin [{<sheet name="} sheet-name {" sheetId="} sheet-number {" r:id="rId} sheet-number {"/>}]
				append xml-workbook-rels ajoin [{<Relationship Id="rId} sheet-number {" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/Sheet} sheet-number {.xml"/>}]

				;	%xl/worksheets/Sheet<n>.xml

				blk: ajoin [
					xml-version
					{<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
						<cols>}
				]
				repeat i width [
					append blk ajoin [{<col min="} i {" max="} i {" width="} spec/:i {"/>}]
				]
				append blk "</cols><sheetData>"
				foreach row block [
					append blk "<row>"
					foreach value row [
						append blk case [
							number? value [
								ajoin ["<c><v>" value "</v></c>"]
							]
							"=" = copy/part value: form value 1 [
								ajoin ["<c><f>" next value "</f></c>"]
							]
							true [
								foreach [char code] [
									"&"		"&amp;"
									"<"		"&lt;"
									">"		"&gt;"
									{"}		"&quot;"
									{'}		"&apos;"
									"^/"	"&#10;"
								] [replace/all value char code]
								ajoin [{<c t="inlineStr"><is><t>} value "</t></is></c>"]
							]
						]
					]
					append blk "</row>"
				]
				append blk {</sheetData>}
				all [filter append blk ajoin [{<autoFilter ref="A1:} to-column-alpha width length? block {"/>}]]
				append blk {</worksheet>}
				append xml-archive reduce [rejoin [%xl/worksheets/Sheet sheet-number %.xml] to binary! blk]

				sheet-number: sheet-number + 1
			]
		]

		insert xml-archive reduce [
			%"[Content_Types].xml" to binary! ajoin [
				xml-version
				{<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
					<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
					<Default Extension="xml" ContentType="application/xml"/>
					<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>}
					xml-content-types
				{</Types>}
			]
			%_rels/.rels to binary! ajoin [
				xml-version
				{<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
					<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
				</Relationships>}
			]
			%xl/workbook.xml to binary! ajoin [
				xml-version
				{<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x15" xmlns:x15="http://schemas.microsoft.com/office/spreadsheetml/2010/11/main">
					<workbookPr defaultThemeVersion="153222"/>
					<sheets>}
						xml-workbook
					{</sheets>
				</workbook>}
			]
			%xl/_rels/workbook.xml.rels to binary! ajoin [
				xml-version
				{<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">}
					xml-workbook-rels
				{</Relationships>}
			]
		]

		write file codecs/zip/encode xml-archive

		file
	]
]