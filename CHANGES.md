# 3.1.4 - August 2025

## Removed

- discard-last
- first-line
- last-line
- load-fixed
- first-value
- sqlite

## Added

- trim-rows
- excel-row-numbers?

## Updated

- excel-cols?
- load-xml
- html-decode
- excel-pick-row
- excel-fields?
- settings/theshold now used by cols?, delimiter?, excel-fields?, fields?, load-dsv
- sqlcmd

## Optimized
- max-of
- min-of

# 3.1.3 - February 2025

## Removed

- sum (now included in 3.16.0+)
- average (now included in 3.16.0+)
- difference-only
- intersect-only
- union-only
- settings/field-scan

## Added

- munge/flat
- load-xml/flat
- transpose
- excel-cols?
- excel-fields?
- excel-first-row
- excel-info
- excel-last-row
- excel-load-sheet
- excel-load-strings
- excel-pick-row
- excel-rows?
- discard-last
- html-decode
- html-encode
- settings/threshold

## Updated

- munge now accepts 0 as column literal (useful for to map! munge/part/flat blk [1 0])
- Added Excel support for cols?
- Added Excel support for rows?
- load-xml better handles Excel variants
- sheets? better handles Excel variants
- Various minor help text changes

## Optimized

- Enhanced as-date to cache
- Enhanced as-time to cache
- Delta refactored to use natives (but no longer modifies series)
- parse use (return keyword)
- `i: i + 1` replaced with `++ i`

# 3.1.2 - February 2023

## Removed

- Support for Red
- like
- second-last

## Added

- write-dsv/utf8
- filename?
- split-on

## Updated

- read-string
- Replaced use of charset with make bitset!
- Replaced use of character literals with words (e.g. `#" "` with `space`)
- Added `protect` for the following words: `backslash`, `comma`, `cr`, `crlf`, `dot`, `escape`, `lf`, `newline`, `null`, `slash`, `space`, `tab`

## Optimized

- write-dsv

# 3.1.1 - October 2022

## Removed

- Support for Atronix R3
- archive
- deflate
- unarchive
- latin1-to-utf8
- load-basic
- /spec from load-fixed

## Added

- unzip function using Rebol3/Core codecs/zip/decode

## Updated

- write-xml to use Rebol3/Core codecs/zip/encode

## Optimized

- load-fixed
- load-xml

## Fixed

- read-string no longer reads 256Kb chunks

# 3.1.0 - September 2022

## Removed

- Support for Rebol 2
- join (for Red)
- /day refinement from to-string-date
- read-binary
- parse-series
- crc32

## Added

- last-line
- to-field-spec
- deduplicate
- deflate
- as-time for basic time string processing
- as-date for basic date string processing
- discard to remove empty columns
- delta to remove source rows existing in target
- difference-only
- intersect-only
- union-only
- settings/denull
- settings/field-scan
- support for Oldes Rebol3
- load-basic

## Updated

- Added /flat refinements to load-dsv and sqlcmd
- Replaced /affected refinement of sqlcmd with /string
- Added unarchive support for Red
- Added limited archive support for Red
- cause-error logic simplified
- replaced to-datatype with to datatype!
- to-string-date now auto-detects /day
- Added /limit refinement to check
- sqlcmd error handling
- Added /identity refinement to sqlcmd
- Added /minutes refinement to to-string-time
- to-string-date now handles Excel dates in decimal format
- load-dsv and load-xml check for denull
- first-line checks for field-scan
- Added /utf8 refinement to write-dsv
- Oldes Rebol3 uses codecs/zip if present (Core and Bulk)
- latin1-to-utf8 catches more UTF space encodings
- latin1-to-utf8 now honors as-is

## Optimized

- read-string / latin1-to-utf8
- enblock
- to-string-time
- as-time
- write-dsv
- delimiter?

## Fixed

- sqlcmd now writes statement > 32k to file
- having block is now copy/deep
- first-line
- missing settings/exited in munge
- missing copy in load-xml (strings inadvertently shared)
- added missing 'flatten console message
- to-string-time Excel bug
- load-xml checks if file is Excel
- flatten was missing copy/deep
- avg was missing from munge/group help text
- several failing Red test cases (distinct, to-time, and to-string-time)
- oledb now detects invalid Excel
- Some minor Red incompatibilities
- call-out preserves strings returned by sqlcmd
