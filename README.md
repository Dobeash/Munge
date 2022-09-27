# Introduction

Munge is a very useful function that enables you to get blocks of tabular (row and column) data from a variety of sources, manipulate the data in various ways, then store the result as a REBOL block or even save back as a CSV or Excel file!

# Quick Start

```plain
>> do http://www.dobeash.com/files/munge.r
>> blk: ctx-munge/load-dsv "Name,Age^/Ben,20^/Bob,30^/Rob,40"
== [
	["Name" "Age"]
	["Ben" "20"]
	["Bob" "30"]
	["Rob" "40"]
]
>> ctx-munge/munge/where next blk [&Age: to-integer &Age]
== [
	["Ben" 20]
	["Bob" 30]
	["Rob" 40]
]
```
