Rebol [
	Title:		"Munge functions"
	Owner:		"Ashley G Truter"
	Version:	3.1.5
	Date:		9-Jan-2026
	Purpose:	"Extract and manipulate tabular values in blocks, delimited files, and database tables."
	Licence:	"MIT. Free for both commercial and non-commercial use."
	Tested: {
		Rebol3/Core 3.21.0	github.com/Oldes/Rebol3
	}
	Usage: {
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
	}
]

system/codecs/zip/verbose: false

protect/words [backslash comma cr crlf dot escape lf newline null slash space tab]

ctx-munge: context [

	settings: context [

		stack: copy []

		start-time: start-used: none

		called: function [
			name [word! none!]
			/file path [file! url!]
		] [
			any [trace exit]
			either word? name [
				insert/dup message: reform ["Call" either file [reform [name "on" filename? path]] [name]] "  " length? stack
				all [
					empty? stack
					recycle
					settings/start-time: now/precise
					settings/start-used: stats
				]
				append stack name
			] [
				insert/dup message: reform ["Exit" last stack] "  " -1 + length? stack
				take/last stack
			]

			print [next next next to-string-time/precise difference now/precise start-time head insert/dup s: form to integer! stats - start-used / 1048576 space 4 - length? s message]
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

		cache: context [
			dmy: make map! 16384
			mdy: make map! 16384
			time: make map! 86400
		]

		;	load-xml and load-dsv

		threshold: 2
	]

	as-date: function [
		"Convert a string date to a YYYY-MM-DD string (does not handle Excel or YYYYDDMM)."
		string [string!]
		/mdy "Month/Day/Year format"
	] compose/deep [
		all [
			find trim string (space)
			8 < index? find/last string (space)
			string: copy/part string find string (space)
		]
		any [
			select either mdy [settings/cache/mdy] [settings/cache/dmy] string
			attempt [
				date: split-on string (make bitset! "/- ")
				date: to date! ajoin/with either mdy [[date/2 date/1 date/3]] [[date/1 date/2 date/3]] (slash)
				all [date/year < 100 date/year: date/year + 2000]
				put either mdy [settings/cache/mdy] [settings/cache/dmy] string ajoin/with [date/year next form 100 + date/month next form 100 + date/day] #"-"
			]
			settings/error reform [string "is not a valid date"]
		]
	]

	as-time: function [
		"Convert a string time to an HH:MM string (does not handle Excel or HHMMSS)."
		time [string!]
	] [
		any [
			select settings/cache/time trim time
			attempt [
				hhmm: to time! trim/with copy time "APM "
				all [
					find time "PM"
					hhmm/1 < 12
					hhmm/1: hhmm/1 + 12
				]
				all [#":" = second hhmm: form hhmm insert hhmm #"0"]
				put settings/cache/time time copy/part hhmm 5
			]
			settings/error reform [time "is not a valid time"]
		]
	]

	call-out: function [
		"Call OS command returning STDOUT."
		cmd [string!]
	] compose [
		all [settings/console settings/called 'call-out]
		(either system/platform = 'Windows [[call/wait/output/error]] [[call/wait/shell/output/error]]) cmd stdout: make string! 65536 stderr: make string! 1024
		any [empty? stderr settings/error trim/lines stderr]
		also deline read-string to binary! stdout all [settings/console settings/exited]
	]

	check: function [
		"Verify data structure."
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
				++ i
			]
		]
		either zero? messages [true] [false]
	]

	cols?: function [
		"Number of columns in a delimited file or string."
		data [file! url! string!]
		/with
			delimiter [char!]
		/sheet
			number [integer!]
	] [
		all [settings/console settings/called 'cols?]
		also either excel? data [
			either %.xls = suffix? data [
				length? first oledb data ajoin ["SELECT TOP 1 * FROM Sheet" any [number 1]]
			] [
				excel-cols? excel-load-sheet data any [number 1]
			]
		] [
			data: either string? data [copy/part data 4096] [read/string/part data 4096]
			unless with [
				set [delimiter data] delimiter? data
			]
			cols: 0
			foreach line split-lines data [
				cols: length? either find line {"} [
					load-dsv/flat/ignore/with/csv line delimiter
				] [
					either empty? line [make block! 0] [split-on line delimiter]
				]
				all [
					cols >= settings/threshold
					break
				]
			]
			cols
		] all [settings/console settings/exited]
	]

	deduplicate: function [
		"Remove earliest occurrences of duplicate non-empty key field."
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
		"Probable delimiter, with priority given to tab, comma, semi-colon, bar, then tilde."
		data [file! url! string!]
	] [
		blk: reduce [#"," 1]
		row: copy ""
		foreach line split-lines either string? data [copy/part data 4096] [read/string/part data 4096] [
			row: copy line
			blk: sort/skip/compare reduce [
				#";"  subtract length? line length? trim/with line #";"
				#"~"  subtract length? line length? trim/with line #"~"
				#"|"  subtract length? line length? trim/with line #"|"
				#"^-" subtract length? line length? trim/with line #"^-"
				#","  subtract length? line length? trim/with line #","
			] 2 2
			all [
				(last blk) >= (settings/threshold - 1)
				break
			]
		]
		reduce [penult blk row]
	]

	delta: function [
		"Return new rows not present in old."
		new [block!]
		old [block!]
	] [
		all [(next new) = next old return copy []]
		all [settings/console settings/called 'delta]
		also copy/deep difference new intersect new old all [settings/console settings/exited]
	]

	dezero: function [
		"Remove leading zeroes from string."
		string [string!]
	] [
		while [string/1 = #"0"] [remove string]
		string
	]

	digit: make bitset! [#"0" - #"9"]

	digits?: function [
		"Returns TRUE if data not empty and only contains digits."
		data [string! binary!]
	] compose/deep [
		all [not empty? data not find data (complement digit)]
	]

	discard: function [
		"Remove empty columns (ignore headings)."
		data [block!]
		/verbose
	] [
		all [settings/console settings/called 'discard]
		unless empty? data [
			unused: copy []
			repeat col length? first data [
				discard?: true
				foreach row next data [
					unless empty? form row/:col [
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
		"Remove duplicate and empty rows."
		data [block!]
	] [
		all [settings/console settings/called 'distinct]
		old-row: none
		remove-each row sort data [
			any [
				all [
					find ["" #(none)] row/1
					1 = length? unique row
				]
				either row = old-row [true] [old-row: row false]
			]
		]
		also data all [settings/console settings/exited]
	]

	drop: function [
		"Remove column."
		data [block!]
		column [integer! word!]
	] [
		all [any [empty? data empty? first data] return data]
		all [settings/console settings/called 'drop]
		unless integer? column [
			unless column: index? find to-field-spec first data column [
				settings/error "Column not found"
			]
		]
		foreach row data [
			remove at row column
		]
		also data all [settings/console settings/exited]
	]

	enblock: function [
		"Convert a block of values to a block of row blocks."
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
		"Add leading zeroes to a string."
		string [string!]
		length [integer!]
	] [
		insert/dup string #"0" length - length? string
		string
	]

	excel-cols?: function [
		"Number of columns in sheet."
		sheet [binary!]
	] [
		cols: cells: dimx: 0
		;	["<cols>" | "<x:cols>"] to ["</cols>" | "</x:cols>"]
		;	["<col " | "<x:col "]
		all [
			s: parse sheet [thru [#{3C636F6C733E} | #{3C783A636F6C733E}] return to [#{3C2F636F6C733E} | #{3C2F783A636F6C733E}]]
			parse s [any [thru [#{3C636F6C20} | #{3C783A636F6C20}] (++ cols)]]
		]
		;	["<c " | "<x:c "]
		parse excel-first-row sheet [any [thru [#{3C6320} | #{3C783A6320}] (++ cells)]]
		;	[{<dimension ref="} | {<x:dimension ref="}] to {"} then A1:B1 or A1
		all [
			s: parse sheet [thru [#{3C64696D656E73696F6E207265663D22} | #{3C783A64696D656E73696F6E207265663D22}] return to #{22}]
			dimx: to-column-number to string! parse any [find/tail s #{3A} s] [return to digit]
		]
		max-of reduce [cols cells dimx]
	]

	excel-fields?: function [
		"Column names of sheet."
		sheet [binary!]
		strings [block!]
		/local cell
	] [
		all [settings/console settings/called 'excel-fields]
		cols: excel-cols? sheet
		rows: excel-rows? sheet
		i: 1
		until [
			append/dup row: make block! cols copy "" cols
			either i <= rows [
				col: 1
				parse read-string excel-pick-row sheet ++ i [
					any [
						to ["<c"|"<x:c"] copy cell thru ["</c>"|"</x:c>"|"/>"] (
							if any [
								find cell "<v>"
								find cell "<x:v>"
								find cell "<t>"
								find cell {<t xml:space="preserve">}
							] [
								x: either find cell "r=" [to-column-number parse cell [thru { r="} return to digit]] [col]
								v: parse cell [thru ["<v>"|"<x:v>"|"<t>"|{<t xml:space="preserve">}] return to ["</v>"|"</x:v>"|"</t>"]]
								poke row x either find cell {t="s"} [copy pick strings 1 + to integer! v] [v]
							]
							++ col
						)
					]
				]
				(min settings/threshold cols) <= length? remove-each s copy row [empty? s]
			] [
				copy []
			]
		]

		also row all [settings/console settings/exited]
	]

	excel-first-row: function [
		"First binary row of a sheet."
		sheet [binary!]
	] compose/deep [
		parse sheet [to [(to binary! "<row ")|(to binary! "<x:row ")|(to binary! "<row>")] return thru [(to binary! "</row>")|(to binary! "</x:row>")|(to binary! "/>")]]
	]

	excel-info: function [
		"Name, rows, and fields of each sheet."
		file [file!]
	] [
		strings: excel-load-strings file
		blk: copy []
		repeat i length? sheets: sheets? file [
			sheet: excel-load-sheet file i
			append/only blk reduce [
				pick sheets i
				excel-rows? sheet
				excel-fields? sheet strings
			]
		]
		blk
	]

	excel-last-row: function [
		"Last binary row of a sheet."
		sheet [binary!]
	] compose/deep [
		excel-first-row any [find/last sheet (to binary! "<row ") find/last sheet (to binary! "<x:row ") find/last sheet (to binary! "<row>")]
	]

	excel-load-sheet: function [
		"Loads binary worksheet."
		file [file!]
		number [integer!]
	] [
		all [settings/console settings/called 'excel-load-sheet]
		also unzip/only file rejoin [%xl/worksheets/sheet either find codecs/zip/decode/info file %xl/worksheets/sheet.xml [%""] [number] %.xml] all [settings/console settings/exited]
	]

	excel-load-strings: function [
		"Loads shared strings."
		file [file!]
		/local s
	] [
		all [settings/console settings/called 'excel-load-strings]

		either find data: trim/lines trim/with read-string any [unzip/only file %xl/sharedStrings.xml copy #{}] newline {uniqueCount="} [
			entries: to integer! parse data [thru {uniqueCount="} return to {"}]
		] [
			entries: 0
			either find data "<si>" [
				parse data [any [thru "<si>" (++ entries)]]
			] [
				parse data [any [thru "<x:si>" (++ entries)]]
			]
		]

		strings: make block! entries

		;	<si><t xml:space="preserve"> string!</t></si>
		;	<si><t/></si>
		;	<si><t>integer!</t></si>
		;	<x:si><x:t>string!</x:t></x:si>

		tag: either find data "<si>" ["<si>"] ["<x:si>"]

		parse data [
			any [
				thru tag
				thru ">" copy s to "<" (
					append strings html-decode s
				)
			]
		]

		if settings/denull [
			foreach val strings [
				all [find/case ["NULL" "null"] val clear val]
			]
		]

		also strings all [settings/console settings/exited]
	]

	excel-pick-row: function [
		"First binary row of a sheet."
		sheet [binary!]
		index [integer!]
	] [
		either excel-row-numbers? sheet [
			any [
				parse sheet compose/deep [to [(to binary! ajoin [{<row r="} index {"}])|(to binary! ajoin [{<x:row r="} index {"}])] return thru [(to binary! "</row>")|(to binary! "</x:row>")]]
				copy #{}
			]
		] [
			pos: sheet
			loop index compose [
				pos: find next pos (to binary! "<row>")
			]
			any [
				parse pos compose [to (to binary! "<row>") return thru (to binary! "</row>")]
				copy #{}
			]
		]
	]

	excel-row-numbers?: function [
		"Row number present in row tag."
		sheet [binary!]
	] compose [
		binary? find/any copy/part find sheet (to binary! "sheetData>") 1024 (to binary! "<*row r=")
	]

	excel-rows?: function [
		"Number of rows in sheet."
		sheet [binary!]
	] compose/deep [
		to integer! to string! either excel-row-numbers? sheet [
			parse excel-last-row sheet [thru (to binary! {r="}) return to (to binary! {"})]
		] [
			parse sheet [thru (to binary! {<dimension ref="}) thru (to binary! ":") to digit return to (to binary! {"})]
		]
	]

	excel?: function [
		"Returns TRUE if file is Excel or worksheet is XML."
		data [file! url! binary! string!]
	] [
		switch/default type?/word data [
			string!		[false]
			binary!		[not none? find copy/part data 8 #{3C3F786D6C}]	; ignore UTF "<?xml" mark
		] [
			all [
				suffix? data
				%.xls = copy/part suffix? data 4
				true? find [#{504B0304} #{D0CF11E0}] read/binary/part data 4
			]
		]
	]

	export: function [
		"Export words to global context."
		words [block!] "Words to export"
	] [
		foreach word words [
			do compose [(to set-word! word) (to get-word! in self word)]
		]
		words
	]

	fields?: function [
		"Column names in a delimited file."
		data [file! url! string!]
		/with
			delimiter [char!]
		/sheet
			number [integer!]
	] [
		all [settings/console settings/called 'fields?]
		also either excel? data [
			either all [file? data %.xls = suffix? data] [
				first oledb data ajoin ["SELECT TOP 1 * FROM Sheet" any [number 1]]
			] [
				excel-fields? excel-load-sheet data any [number 1] excel-load-strings data
			]
		] [
			data: either string? data [copy/part data 4096] [read-string read/part data 4096]
			unless with [
				set [delimiter data] delimiter? data
			]
			cols: cols?/with data delimiter
			foreach line split-lines data [
				row: either find line {"} [
					load-dsv/flat/ignore/with/csv line delimiter
				] [
					either empty? line [make block! 0] [split-on line delimiter]
				]
				all [
					(min settings/threshold cols) <= length? remove-each s copy row [empty? s]
					break
				]
			]
			any [row copy []]
		] all [settings/console settings/exited]
	]

	filename?: function [
		"Return the file name of a path or url."
		path [file! url!]
	] [
		copy any [
			find/last/tail path slash
			find/last/tail path backslash
			path
		]
	]

	flatten: function [
		"Flatten nested block(s)."
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

	html-decode: function [
		"Decode HTML Entities."
		string [string!]
	] compose/deep [
		all [
			find string "&"
			foreach [code char] [
				{&amp;}		{&}
				{&lt;}		{<}
				{&gt;}		{>}
				{&quot;}	{"}
				{&apos;}	{'}
				{&NewLine;}	{^/}
				{&Tab;}		{^-}
				{&nbsp;}	{ }
				{&#xa0;}	{ }
			] [replace/all string code char]
		]
		all [
			find string (to string! #{E28093})
			replace/all string (to string! #{E28093}) "-"
		]
		trim string
	]

	html-encode: function [
		"Encode HTML Entities."
		string [string!]
	] compose/deep [
		all [
			find string (make bitset! {&<>"'^/^-})
			foreach [code char] [
				{&amp;}		{&}
				{&lt;}		{<}
				{&gt;}		{>}
				{&quot;}	{"}
				{&apos;}	{'}
				{&NewLine;}	{^/}
				{&Tab;}		{^-}
			] [replace/all string char code]
		]
		string
	]

	letter: make bitset! [#"A" - #"Z" #"a" - #"z"]

	letters?: function [
		"Returns TRUE if data only contains letters."
		data [string! binary!]
	] compose [
		not find data (complement letter)
	]

	list: function [
		"Uses settings to set the new-line marker."
		data [block!]
	] [
		if settings/console [
			if block? first data [
				foreach row data [new-line/all row false]
				new-line/all data true
			]
			settings/exited
		]
		data
	]

	load-dsv: function [
		"Parses delimiter-separated values into row blocks."
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
				settings/error reform [filename? source "is an Excel file"]
			]
			all [
				#{22} = either binary? source [copy/part source 1] [read/part source 1]
				csv: true
			]
			read-string source
		]

		recycle

		any [with delimiter: first delimiter? source]

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

		append last last rule compose/deep [
			++ line
			(either settings/as-is [] [[foreach val row [trim/lines val]]])
			(either settings/denull [[foreach val row [all [find/case ["NULL" "null"] val clear val]]]] [])
			all [
				(min settings/threshold cols) <= length? row
				(either where [condition] [])
				(either ignore [] [compose/deep [any [(cols) = len: length? row settings/error reform ["Expected" (cols) "values but found" len "on line" line]]]])
				(either part [
					part: copy/deep [reduce []]
					foreach col columns: to block! columns [
						append part/2 either integer? col [
							all [not ignore any [col < 1 col > cols] settings/error reform ["Invalid /part position:" col "of" cols]]
							compose [(append to path! 'row col)]
						] [col]
					]
					compose [row: (part)]
				] [])
				row <> last blk
				(either flat [[append]] [[append/only]]) blk row
			]
		]

		blk: make block! either flat [(rows? source) * either part [length? columns] [cols]] [rows? source]

		parse source bind rule 'row

		list blk
	]

	load-xml: function [
		"Loads an Office XML sheet."
		file [file!]
		/part "Offset position(s) to retrieve"
			columns [block! integer! word!]
		/where "Expression that can reference columns as row/1, row/2, etc or &field"
			condition [block!]
		/flat "Flatten rows"
		/sheet number [integer!]
		/local cell
	] [
		all [settings/console settings/called 'load-xml]

		any [
			excel? file
			settings/error reform [file "is not a valid Excel file"]
		]

		any [
			sheet: excel-load-sheet file number: any [number 1]
			settings/error reform [number "is not a valid sheet number"]
		]

		strings: excel-load-strings file

		cols: excel-cols? sheet

		all [
			find reform [columns condition] "&"
			row: excel-fields? sheet strings
			set [columns condition] munge/spec/part/where reduce [row] columns condition
		]

		sheet: trim/lines trim/with read-string parse sheet [to [#{3C726F77} | #{3C783A726F77}] return to [#{3C2F7368656574446174613E} | #{3C2F783A7368656574446174613E}]] newline

		;	<c r="A1" s="1" t="s"><v>0</v></c>
		;	<c r="A1" s="1" t="inlineStr"><is><t>0</t></is></c>
		;	<c s="1" t="s"><v>0</v></c>
		;	<c r="A1" s="1"></c>
		;	<x:c r="A1" s="1" t="s"><x:v>0</x:v></x:c>
		;	<x:c t="s" r="A1" s="1"><x:v>2</x:v></x:c>
		;	<x:c r="A1" s="1" />

		rule: either "<row" = copy/part sheet 4 [
			copy/deep [
				any [
					opt ["<row" (col: 1 append/dup row: make block! cols copy "" cols)]
					to "<c" copy cell thru ["</c>" | "/>"] (
						if any [
							find cell "<v>"
							find cell "<t>"
							find cell {<t xml:space="preserve">}
						] [
							all [find cell "r=" col: to-column-number parse cell [thru { r="} return to digit]]
							v: parse cell [thru ["<v>"|"<t>"|{<t xml:space="preserve">}] return to ["</v>"|"</t>"]]
							poke row col either find cell {t="s"} [copy pick strings 1 + to integer! v] [html-decode v]
						]
						++ col
					)
					opt ["</row>" ()]
				]
			]
		] [
			copy/deep [
				any [
					opt ["<x:row" (col: 1 append/dup row: make block! cols copy "" cols)]
					to "<x:c" copy cell thru ["</x:c>" | "/>"] (
						if find cell "<x:v>" [
							all [find cell "r=" col: to-column-number parse cell [thru { r="} return to digit]]
							v: parse cell [thru "<x:v>" return to "</x:v>"]
							poke row col either find cell {t="s"} [copy pick strings 1 + to integer! v] [html-decode v]
						]
						++ col
					)
					opt ["</x:row>" ()]
				]
			]
		]

		append last last last rule compose/deep [
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
				(either flat ['append] ['append/only]) blk row
			]
		]

		blk: copy []

		parse sheet bind rule 'row

		recycle

		list blk
	]

	max-of: function [
		"Returns the largest value in a series."
		series [series!] "Series to search"
	] [
		all [empty? series return none]
		val: series/1
		foreach v unique series [val: max val v]
		val
	]

	merge: function [
		"Join outer block to inner block on primary key."
		outer [block!] "Outer block"
		key1 [integer!]
		inner [block!] "Inner block to index"
		key2 [integer!]
		columns [block!] "Offset position(s) to retrieve in merged block"
		/default "Use none on inner block misses"
	] [
		;	build rowid map of inner block
		map: make map! length? inner
		i: 1
		foreach row inner [
			put map row/:key2 ++ i
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
		"Returns the smallest value in a series."
		series [series!] "Series to search"
	] [
		all [empty? series return none]
		val: series/1
		foreach v unique series [val: min val v]
		val
	]

	mixedcase: function [
		"Converts string of characters to mixedcase."
		string [string!]
	] compose/deep [
		uppercase/part lowercase string 1
		foreach char [#"'" (space) #"-" (dot) (comma)] [
			all [find string char string: next find string char mixedcase string]
		]
		string: head string
	]

	munge: function [
		"Load and / or manipulate a block of tabular (column and row) values."
		data [block!]
		/delete "Delete matching rows (returns original block)"
			clause
		/part "Offset position(s) and/or values to retrieve"
			columns [block! integer! word! none!]
		/where "Expression that can reference columns as row/1, row/2, etc"
			condition
		/group "One of avg, count, max, min or sum"
			having [word! block!] "Word or expression that can reference the initial result set column as count, max, etc"
		/flat "Flatten rows (requires part or where, but not group)"
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

			if spec [
				all [settings/console settings/exited]
				return reduce [columns condition]
			]
		]

		case [
			delete [
				remove-each row data bind compose/only [all (condition)] 'row
				all [settings/console settings/exited]
				return data
			]
			any [part where] [
				columns: either part [
					part: copy/deep [reduce []]
					cols: length? data/1
					foreach col to block! columns [
						append part/2 either all [integer? col not zero? col] [
							all [any [col < 1 col > cols] settings/error reform ["Invalid /part position:" col]]
							compose [(append to path! 'row col)]
						] [col]
					]
					part
				] ['row]
				blk: copy []
				flat: either all [flat not group] ['append] ['append/only]
				foreach row data compose [(
					either where [
						compose/deep [all [(condition) (flat) blk (columns)]]
					] [
						compose [(flat) blk (columns)]
					]
				)]
				if empty? blk [
					all [settings/console settings/exited]
					return blk
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
						either group = row [++ i] [
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
					all [settings/console settings/exited]
					return do compose [(operation) flatten data]
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
		"Execute an OLEDB statement."
		file [file! url!]
		statement [string!] "SQL statement in the form (Excel) 'SELECT F1 FROM SHEET1' or (Access) 'SELECT Column FROM Table'"
		/local sheet blk
	] either system/platform = 'Windows [[
		all [settings/console settings/called/file 'oledb file]
		statement: replace/all copy statement {'} {''}
		properties: either %.accdb = suffix? file [""] [
			parse statement [thru "FROM " copy sheet to [space | end]]
			replace statement reform ["FROM" sheet] ajoin ["FROM ['+$o.GetSchema('Tables').rows[" -1 + to integer! skip sheet 5 "].TABLE_NAME+']"]
			{;Extended Properties=''Excel 12.0 Xml;HDR=NO;IMEX=1;Mode=Read''}
		]
		old-threshold: settings/threshold
		settings/threshold: 1
		blk: remove load-dsv/csv/with call-out ajoin [
			{powershell -nologo -noprofile -command "}
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
		settings/threshold: old-threshold
		also either all [
			1 = length? blk
			[""] = unique first blk
		] [
			settings/error reform [file "is not a valid Excel file"]
		] [
			blk
		] all [settings/console settings/exited]
	]] [[
		settings/error "Windows only"
	]]

	penult: function [
		"Returns the second last value of a series."
		series [series!]
	] [
		pick series subtract length? series 1
	]

	read-string: function [
		"Read string from a text file."
		source [file! url! binary!]
	] [
		all [settings/console settings/called 'read-string]
		any [binary? source source: read/binary source]
		trim source
		;	replace char 160 with space
		mark: source
		while [mark: find mark #{C2A0}] [
			change/part mark #{20} 2
		]
		also deline either invalid-utf? source [iconv source 'latin1] [to string! source] all [settings/console settings/exited]
	]

	replace-deep: function [
		"Replaces all occurrences of search values with new values in a block or nested block."
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
		"Number of rows in a delimited file or string."
		data [file! url! string!]
		/sheet
			number [integer!]
	] [
		either excel? data [
			either %.xls = suffix? data [
				to integer! first first oledb data ajoin ["SELECT COUNT(1) FROM Sheet" any [number 1]]
			] [
				excel-rows? excel-load-sheet data any [number 1]
			]
		] [
			either any [
				all [file? data zero? size? data]
				empty? data
			] [0] [
				i: 1
				parse either file? data [read data] [data] [
					any [thru newline (++ i)]
				]
				i
			]
		]
	]

	sheets?: function [
		"Excel sheet names."
		file [file! url!]
		/local name
	] [
		all [settings/console settings/called 'sheets?]
		blk: copy []
		parse parse to string! unzip/only file %xl/workbook.xml [thru ["<sheets>" | "<x:sheets>"] return to ["</sheets>" | "</x:sheets>"]] [
			any [thru {name="} copy name to {"} (append blk trim name)]
		]
		also blk all [settings/console settings/exited]
	]

	split-on: function [
		"Split a series into pieces by delimiter."
		series [series!]
		dlm [char! bitset! string!]
		/local s
	] [
		blk: copy []
		parse series [any [copy s to [dlm | end] (append blk trim s) thru dlm]]
		blk
	]

	sqlcmd: function [
		"Execute a SQL Server statement."
		server [string!] "Username/Password if localhost"
		database [string!]
		statement [string!]
		/key "Columns to convert to integer"
			columns [integer! block!]
		/headings "Keep column headings"
		/string "Return string instead of block"
		/flat "Flatten rows"
		/identity
	] [
		all [settings/console settings/called 'sqlcmd]

		all [identity statement: rejoin [statement ";SELECT SCOPE_IDENTITY()"]]

		authentication: either find server slash [
			reform ["-U" parse server [return to slash] "-P" next find server slash "-d" database]
		] [
			reform ["-S" server "-d" database]
		]

		stdout: either 32000 > length? statement [
			call-out reform compose ["sqlcmd -m 1 -X" authentication "-I -Q" ajoin [{"} statement {"}] {-W -w 65535 -s"^-"} (either headings [] [{-h -1}])]
		] [
			write file: to file! append replace datetime space #"_" %.sql statement
			also call-out reform compose ["sqlcmd -m 1 -X" authentication "-I -i" file {-W -w 65535 -s"^-"} (either headings [] [{-h -1}])] attempt [delete file]
		]

		all [empty? stdout return either string [make string! 0] [make block! 0]]

		case [
			string [
				also stdout all [settings/console settings/exited]
			]
			identity [
				to integer! parse stdout [thru ")^/" return to "^/"]
			]
			stdout/1 = #"^/" [
				also make block! 0 all [settings/console settings/exited]
			]
			find/any/match stdout "Msg*,*Level*,*State*,*Server" [
				settings/error trim/lines find stdout "Line"
			]
			find/any/match stdout "Warning:*(0 rows affected)" [
				settings/error find/tail first split-lines stdout "Warning: "
			]
			true [
				stdout: copy/part stdout find stdout "^/^/("

				old-threshold: settings/threshold
				settings/threshold: 1

				either flat [
					cols: cols?/with stdout tab

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

				settings/threshold: old-threshold

				also stdout all [settings/console settings/exited]
			]
		]
	]

	to-column-alpha: function [
		"Convert numeric column reference to an alpha column reference."
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
		"Convert alpha column reference to a numeric column reference."
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
		"Convert field strings to words."
		fields [block!]
	] compose/deep [
		blk: copy []

		foreach field fields [
			remove-each char field: form field [find (complement make bitset! [#"A" - #"Z" #"a" - #"z" #"0" - #"9" #"-" #"_" #"."]) char]
			append blk to word! append copy "&" field
		]

		blk
	]

	to-string-date: function [
		"Convert a string or Rebol date to a YYYY-MM-DD string."
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
						all [find date dot attempt [to decimal! date] date: first split-on date dot]
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
							date: remove/part copy date index? find date space
						]
						date: either digits? date [
							;	YYYYDDMM
							reduce [copy/part date 4 copy/part skip date 4 2 copy/part skip date 6 2]
						] [
							split-on date (make bitset! "/- ")
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
		ajoin/with [date/year next form 100 + date/month next form 100 + date/day] #"-"
	]

	to-string-time: function [
		"Convert a string or Rebol time to a HH:MM:SS string."
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
							to time! ajoin/with [copy/part time 2 copy/part skip time 2 2 copy/part skip time 4 2] #":"
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

	transpose: function [
		"Rotate data from rows to columns or vice versa."
		data [block!]
	] [
		all [settings/console settings/called 'transpose]
		rows: length? data
		blk: make block! cols: length? data/1

		loop cols [
			append/only blk make block! rows
		]

		foreach row data [
			repeat i cols [append blk/:i row/:i]
		]

		insert clear data blk
		blk: none
		recycle
		also data all [settings/console settings/exited]
	]

	trim-rows: function [
		"Remove empty trailing column(s) and leading column(s)."
		data [block!]
	] [
		all [settings/console settings/called 'trim-rows]
		unless empty? data [
			;	trailing columns
			discard?: true
			while [all [data/1/1 discard?]] [
				foreach row data [
					unless "" = last row [
						discard?: false
						break
					]
				]
				if discard? [
					foreach row data [
						take/last row
					]
				]
			]
			;	leading columns
			discard?: true
			while [all [data/1/1 discard?]] [
				foreach row data [
					unless "" = first row [
						discard?: false
						break
					]
				]
				if discard? [
					foreach row data [
						remove row
					]
				]
			]
		]
		also data all [settings/console settings/exited]
	]

	unzip: function [
		"Decompresses file(s) from archive."
		source [file! url!]
		/only
			file [file!]
	] [
		either file [
			attempt [second second codecs/zip/decode/only source to block! file]
		] [
			make-dir path: join head clear find/last copy source %. %/
			foreach [file bin] codecs/zip/decode source [
				make-dir/deep join path first split-path file
				print file: join path file
				write file second bin
			]
			true
		]
	]

	write-dsv: function [
		"Write block(s) of values to a delimited text file."
		file [file! url!] "csv or tab-delimited text file"
		data [block!]
		/with
			delimiter [char!]
		/quoted "Only if delimiter specified"
		/utf8
	] [
		all [settings/console settings/called 'write-dsv]
		p: open/new/write file
		all [utf8 append p #{EFBBBF}]
		do compose/deep [
			foreach row copy/deep data [
				(either all [not delimiter %.csv = suffix? file] [[
					foreach value row [
						all [
							series? value
							find trim/with value #"^"" (make bitset! ",^/")
							append insert value #"^"" #"^""
						]
					]
				]] [])
				replace/all row none copy ""
				(either quoted [[foreach value row [append insert value #"^"" #"^""]]][])
				append p append ajoin/with row (any [delimiter either %.csv = suffix? file [comma] [tab]]) (lf)
			]
		]
		also close p all [settings/console settings/exited]
	]

	write-excel: function [
		"Write block(s) of values to an Excel file."
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

			all [
				31 < length? sheet-name
				cause-error 'user 'message "Sheet name cannot exceed 31 characters"
			]

			all [
				find sheet-name #"/"
				cause-error 'user 'message "Sheet name cannot contain forward slash"
			]

			unless empty? block [

				all [
					(length? first block) <> length? spec
					cause-error 'user 'message "Sheet data and widths do not match"
				]

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
								ajoin [{<c t="inlineStr"><is><t>} html-encode value "</t></is></c>"]
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
