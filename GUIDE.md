# Introduction

`munge.r` is a single Rebol script that provides a set of functions that enable you to get blocks of tabular (row and column) data from a variety of sources, manipulate the data in various ways, then store the result as a Rebol `block!` or save as a CSV, tab-delimited, or Excel file!

# Getting started

Download latest [Rebol release](https://github.com/Oldes/Rebol3/releases), run, and then from the Rebol console:

    >> do %munge.r
    >> ctx-munge/list [1 2 3]
    == [
        1 
        2 
        3
    ]

Alternatively, you can selectively export functions to the global context:

    >> ctx-munge/export [list munge]

Or export all functions with:

    >> ctx-munge/export bind words-of ctx-munge 'self

# Data Structure

Rows are represented as blocks of data within a "table" block.

    >> load-dsv "a,1^/b,2"
    == [["a" "1"] ["b" "2"]]

# Settings

## Working in the console

By default `trace` and `list` are enabled. They can be disabled with `settings/console: false`.

    >> load-xml %abc.xlsx
    00:00.000    0 Call load-xml
    00:00.001    0   Call unarchive on sheet1.xml
    00:00.001    0     Call read-binary on abc.xlsx
    00:00.053    2     Exit read-binary
    00:00.277   33   Exit unarchive
    00:00.280   35   Call unarchive on sharedStrings.xml
    00:00.280   35     Call read-binary on abc.xlsx
    00:00.290   30     Exit read-binary
    00:00.335   35   Exit unarchive
    00:00.335   35   Call read-string
    00:00.412   40   Exit read-string
    00:00.412   40   Call parse
    00:00.512   38   Exit parse
    00:00.513   38   Call cols?
    00:00.555   38   Exit cols?
    00:00.556   38   Call read-string
    00:00.860   52   Exit read-string
    00:00.861   52   Call parse
    00:03.064   77   Exit parse
    00:03.097   77 Exit load-xml
    == [
        ["Cardholder Name" "Lan ID" "Entry Clock" "Entry Card" "Entry Date/Time"]
        ["John Citizen" "jcitizen" "L10 West Foyer Entry Door" "632306" "2/10/2018 10:10:16 AM"]
        ["John Citizen" "jcitizen" "L10 West Foyer Entry Door" "632306" "2/10/2018 12:55:17 PM"]
        ["John Citizen" "jcitizen" "L10 East Foyer Entry Door" "632306" "2/10/2018 2:26:28 PM"]
        ["John Citizen" "jcitizen" "L3 East Foyer Entry Door" "632306" "2/10/2018 2:59:30 PM"]
        ["John Citizen" "jcitizen" "L10 West ...
    >>

`trace` mode shows three columns:

1. **mm:ss:mmm** since start of initial function call.
2. **MB** used since start of initial function call.
3. **Function** called / exited (indentation indicates nesting level).

`list` mode is the equivalent of `new-line/all block true` ... it ensures each row within a block is displayed on a new line.

## Whitespace handling

By default `as-is` is enabled. It can be disabled with `settings/as-is: false`.

    >> load-dsv " a   b "
    == [
        ["a   b"]
    ]
    >> settings/as-is: false
    >> load-dsv " a   b "
    == [
        ["a b"]
    ]

Leading and trailing whitespace is always trimmed, but `as-is` preserves embedded whitespace.

## NULL handling

By default `denull` is enabled. It can be disabled with `settings/denull: false`.

    >> load-dsv "1,NULL,2"
    == [
        ["1" "" "2"]
    ]

## Threshold

By default `settings/threshold` is set to `2`. This is the number of non-blank values that must be present in a row before `fields?` returns it.

    >> fields? "Report,,^/A,B,C"
    == ["A" "B" "C"]

# Reading files

## Delimiter Seperated Values (DSV)

    >> load-dsv %file.csv
    >> load-dsv/part %file.csv 1
    >> load-dsv/part %file.csv [1 2]
    >> load-dsv/where %file.csv [row/1 = "1"]

## Excel

    >> load-xml %file.xlsx
    >> load-xml/sheet %file.xlsx 'Sheet1
    >> load-xml/part %file.xlsx [1 2]
    >> load-xml/where %file.xlsx [row/1 = "1"]

`load-xml` can return different results from `oledb`. Here is some code to check for differences:

    >> a: oledb file "SELECT * FROM Sheet1"
    >> b: load-xml file
    >> repeat i length? a [all [a/:i <> b/:i print [i difference form a/:i form b/:i] halt]]

Common differences include:

- Accented characters (oledb doesn't handle them).
- Row length.
- Dates (`oledb` returns the styled date, `load-xml` may return a 5-digit date).
- Times (`oledb` returns the styled time, `load-xml` may return a decimal time).

Note that `to-string-date` and `to-string-time` handle Excel raw date and time formats.

# Writing files

## DSV

    >> write-dsv %file.csv block
    >> write-dsv %file.txt block

## Excel

    >> write-excel %file.xlsx ["Sheet1" [[a b][1 2]] [5 10]]
    >> write-excel/filter %file.xlsx ["Sheet1" [[a b][1 2]] [5 10]]

# Querying databases

## OLEDB

    >> oledb %file.xlsx "SELECT * FROM Sheet1"
    >> oledb %file.xlsx "SELECT * FROM Sheet2"
    >> oledb %file.xlsx "SELECT F1, F2 FROM Sheet1"
    >> oledb %file.xlsx "SELECT * FROM Sheet1 WHERE F1 = '1'"

This only works on Windows and requires the [Microsoft Access Database Engine 2016 Redistributable](https://www.microsoft.com/en-us/download/details.aspx?id=54920) (or later) to first be installed.

## SQL Server

    >> sqlcmd sn db "SELECT * FROM TABLE"
    >> sqlcmd/headings sn db "SELECT * FROM TABLE"

This requires the SQLCMD utility to be installed.

### Installing SQL Server on macOS

To install SQL Server (and SQLCMD) on non-Windows systems you will need to download and install the following:

1. [Docker](https://www.docker.com)
3. [Azure SQL Edge](https://hub.docker.com/r/microsoft/azure-sql-edge)
2. [Azure Data Studio](https://learn.microsoft.com/en-us/azure-data-studio/download-azure-data-studio?tabs=win-install%2Cwin-user-install%2Credhat-install%2Cwindows-uninstall%2Credhat-uninstall)
4. [go-sqlcmd](https://github.com/microsoft/go-sqlcmd)

You will then need to inclue SQLCMD in your path. If it's located in the same folder as `munge.r` you can do this with:

    >> set-env "PATH" ajoin [get-env "PATH" ":" to-local-file pwd]
    
Also note that the `server` argument will need to be `sa/password`.

    >> sqlcmd "sa/password" "master" "SELECT * FROM sys.databases"

# Munging blocks

The main function, `munge`, is typically used to manipulate blocks of data retrieved from files and databases.

## /where

The `/where` refinement (implied when using `/delete`) lets you specify a block of Rebol conditions (wrapped within an `all` block) that can reference row values as `row/1`, `row/2`, etc).

    >> munge/where data [row/1 = 1]
    >> munge/delete data [row/1 > 1 row/1 < 10]
    >> munge/where data [row/1: row/1 + 1]  ; this is an example of an "Update"

Alternatively, if the data is sorted a key value may be specified. The key value does not need to be unique, but it must be the first value of each row retrieved.

    >> sort data
    >> munge/where data 1
    >> munge/delete data 1

This initiates a [binary search](https://en.wikipedia.org/wiki/Binary_search_algorithm) that can be thousands of times faster than a block predicate.

## /part

The `/part` refinement allows you to retrieve columns by `integer!` position. The same column can be repeated.

    >> munge/part blk [1 2 1]

A `string!` position will return that string.

    >> munge/part [["a"] ["b"]] [1 "Yes"]
    == [["a" "Yes"] ["b" "Yes"]]

## Field Names

If the first row of data are column headings then `load-dsv` and `munge` may reference by `&` prefixed field name (sans whitespace).

    >> blk: [["First Name" "Age"] ["Ben" "25"] ["Bob" "35"]]
    >> munge/part/where blk '&FirstName [&Age = 25]

If you need to exclude the first row from processing then you can use `next`.

    >> munge/where next blk [&Age: to-integer &Age]  ; skip "Age" value
    >> blk
    >> [["First Name" "Age"] ["Ben" 25] ["Bob" 35]]
