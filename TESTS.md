| # |Test|Result|
|--:|----|------|
|1|archive ""|none|
|2|archive "12341234123412341234"|#{1F8B080000000000000A333432363144C300DD14A53C14000000}|
|3|archive "a"|#{1F8B080000000000000A4B040043BEB7E801000000}|
|4|archive [%a ""]|#{ 504B030414000000000000000000000000000000000000000000010000006150 4B01021400140000000000000000000000000000000000000000000100000000 0000000000000000000000000061504B050600000000010001002F0000001F00 00000000}|
|5|archive [%a "x"]|#{ 504B0304140000000000000000008316DC8C0100000001000000010000006178 504B01021400140000000000000000008316DC8C010000000100000001000000 000000000000000000000000000061504B050600000000010001002F00000020 0000000000}|
|6|archive [%a "1" %b "2"]|#{ 504B030414000000000000000000B7EFDC830100000001000000010000006131 504B0304140000000000000000000DBED51A0100000001000000010000006232 504B0102140014000000000000000000B7EFDC83010000000100000001000000 000000000000000000000000000061504B01021400140000000000000000000D BED51A010000000100000001000000000000000000000000002000000062504B 050600000000020002005E000000400000000000}|
|7|archive [%a "12341234123412341234"]|#{ 504B030414000000080000000000DD14A53C0800000014000000010000006133 3432363144C300504B0102140014000000080000000000DD14A53C0800000014 00000001000000000000000000000000000000000061504B0506000000000100 01002F000000270000000000}|
|8|as-date "01/02/2015"|"2015-02-01"|
|9|as-date "01/02/2015 12:30PM"|"2015-02-01"|
|10|as-date/mdy "01/02/2015"|"2015-01-02"|
|11|as-date "01/02/15"|"2015-02-01"|
|12|as-date "01-02-15"|"2015-02-01"|
|13|as-date "01-02-15 12:30PM"|"2015-02-01"|
|14|as-date/mdy "01-02-2015"|"2015-01-02"|
|15|as-date "01-02-15"|"2015-02-01"|
|16|as-date "1 Aug 2022 8:00"|"2022-08-01"|
|17|as-date/mdy "Aug 1 2022 8:00"|"2022-08-01"|
|18|as-time "1:00AM"|"01:00"|
|19|as-time "1:00 AM"|"01:00"|
|20|as-time "1:00PM"|"13:00"|
|21|as-time "1:00 PM"|"13:00"|
|22|as-time "13:00 PM"|"13:00"|
|23|as-time "13:00PM"|"13:00"|
|24|as-time "12:30 PM"|"12:30"|
|25|as-time "12:30PM"|"12:30"|
|26|call-out {sqlite3 a.db ""}|""|
|27|check []|true|
|28|check [[1]]|true|
|29|cols? ""|0|
|30|cols? ","|2|
|31|cols? "a,b"|2|
|32|cols? "a^-b"|2|
|33|cols? "^/a^-b"|2|
|34|cols? "a&#124;b"|2|
|35|cols? "a~b"|2|
|36|cols? "a;b"|2|
|37|cols?/with ":" #":"|2|
|38|cols? %test.xlsx|2|
|39|cols?/sheet %test.xlsx 1|2|
|40|cols?/sheet %test.xlsx 2|2|
|41|cols?/sheet %test.xlsx 3|2|
|42|deduplicate [["A" "B"] [0 1] [0 2]] '&A|[["A" "B"] [0 2]]|
|43|deduplicate [["A" "B"] [0 1] [0 2]] 1|[["A" "B"] [0 2]]|
|44|deduplicate/latest [["A" "B"] [0 1] [0 2]] '&A|[["A" "B"] [0 1]]|
|45|deduplicate/latest [["A" "B"] [0 1] [0 2]] 1|[["A" "B"] [0 1]]|
|46|deduplicate [["" a] ["" b]] 1|[["" a] ["" b]]|
|47|deflate r1|#{61}|
|48|delimiter? ""|#","|
|49|delimiter? "a"|#","|
|50|delimiter? "^-"|#"^-"|
|51|delimiter? "&#124;"|#"|"|
|52|delimiter? "~"|#"~"|
|53|delimiter? ";"|#";"|
|54|delta [[1] [2]] [[1]]|[[2]]|
|55|dezero ""|""|
|56|dezero "0"|""|
|57|dezero "10"|"10"|
|58|dezero "01"|"1"|
|59|dezero "001"|"1"|
|60|difference-only [[a] [a] [b]] [[b] [c] [c]]|[[a] [c]]|
|61|digit|make bitset! #{000000000000FFC0}|
|62|digits? ""|none|
|63|digits? "a"|none|
|64|digits? "1"|true|
|65|discard [["a" ""] ["b" ""]]|[["a"] ["b"]]|
|66|distinct [["" ""] [a 1]]|[[a 1]]|
|67|distinct reduce [reduce [none none] [a 1]]|[[a 1]]|
|68|distinct [[a] [a]]|[[a]]|
|69|distinct [[a 1] [a 1]]|[[a 1]]|
|70|enblock [1 2 3 4] 1|[[1] [2] [3] [4]]|
|71|enblock [1 2 3 4] 2|[[1 2] [3 4]]|
|72|enzero "" 1|"0"|
|73|enzero "10" 1|"10"|
|74|enzero "10" 2|"10"|
|75|enzero "10" 3|"010"|
|76|excel? %test.xlsx|true|
|77|excel? %a.txt|none|
|78|excel? to-binary "<?xml"|true|
|79|excel? "Text"|false|
|80|export []|[]|
|81|export [distinct]|[distinct]|
|82|export [cols? rows?]|[cols? rows?]|
|83|fields? ""|[]|
|84|fields? ","|["" ""]|
|85|fields? "a,b"|["a" "b"]|
|86|fields? "^/a,b"|["a" "b"]|
|87|fields? "a:b"|["a:b"]|
|88|fields? {"a","b"}|["a" "b"]|
|89|fields? {"a" ,"b"}|["a" "b"]|
|90|fields? {"a", "b"}|["a" "b"]|
|91|fields?/with "a:b" #":"|["a" "b"]|
|92|fields? %test.xlsx|["A B" "S1"]|
|93|fields?/sheet %test.xlsx 1|["A B" "S1"]|
|94|fields?/sheet %test.xlsx 2|["AB" "S2"]|
|95|fields?/sheet %test.xlsx 3|["A-B" "S3"]|
|96|first-line ""|""|
|97|first-line "a,1"|"a,1"|
|98|first-line "^/a,1"|"a,1"|
|99|first-line "a,1^/"|"a,1"|
|100|flatten []|[]|
|101|flatten [[a] [b]]|[a b]|
|102|flatten [[a 1] [b 2]]|[a 1 b 2]|
|103|intersect-only [[a] [b] [b]] [[b] [b] [c]]|[[b]]|
|104|last-line ""|""|
|105|last-line "a^/1^/"|"1"|
|106|last-line %a.txt|"33 44"|
|107|latin1-to-utf8 #{}|""|
|108|latin1-to-utf8 #{00}|""|
|109|latin1-to-utf8 #{C2A0}|" "|
|110|latin1-to-utf8 #{E28083}|" "|
|111|latin1-to-utf8 #{E280AF}|" "|
|112|latin1-to-utf8 #{E38080}|" "|
|113|latin1-to-utf8 #{FC}|"ü"|
|114|letter|make bitset! #{00000000000000007FFFFFE07FFFFFE0}|
|115|letters? ""|true|
|116|letters? "a"|true|
|117|letters? "1"|false|
|118|like "" ""|none|
|119|like %abc %a|true|
|120|like %abc %*a|true|
|121|like %abc %?a|none|
|122|like %abc %b|none|
|123|like %abc %*b|true|
|124|like %abc %?b|true|
|125|like %abc %a?c|true|
|126|like %abc %a?b|none|
|127|like %abc %a*c|true|
|128|like %abc %a*b|true|
|129|list []|[]|
|130|list [[a] [b]]|[[a] [b]]|
|131|load-basic %a.csv|[["F1" "F2"] ["1" "2"]]|
|132|load-basic/flat %a.csv|["F1" "F2" "1" "2"]|
|133|load-basic/flat to-binary ""|[""]|
|134|load-basic/flat to-binary ","|["" ""]|
|135|load-basic/flat to-binary " a  b "|["a b"]|
|136|load-dsv ""|[]|
|137|load-dsv ","|[["" ""]]|
|138|load-dsv {" a ^/ b "}|[["a b"]]|
|139|load-dsv "a,"|[["a" ""]]|
|140|load-dsv {"a" ,"b"}|[["a" "b"]]|
|141|load-dsv {"a", "b"}|[["a" "b"]]|
|142|load-dsv "a,NULL,b"|[["a" "" "b"]]|
|143|load-dsv/part "a,b,c" 1|[["a"]]|
|144|load-dsv/part "a,b,c" [1]|[["a"]]|
|145|load-dsv/part "a,b,c" [3 1]|[["c" "a"]]|
|146|load-dsv/part "a,b,c" [1 "Y"]|[["a" "Y"]]|
|147|load-dsv "a,1^/b,2"|[["a" "1"] ["b" "2"]]|
|148|load-dsv/where "a,1^/b,2" [row/1 = "a"]|[["a" "1"]]|
|149|load-dsv/where "a^/b^/c" [line = 2]|[["b"]]|
|150|load-dsv "a:b"|[["a:b"]]|
|151|load-dsv/with "a:b" #":"|[["a" "b"]]|
|152|load-dsv/part %a.csv '&F1|[["F1"] ["1"]]|
|153|load-dsv/where %a.csv [&F1 = "1"]|[["1" "2"]]|
|154|load-dsv/where "A^/0" [digits? &A &A: to-integer &A]|[[0]]|
|155|load-dsv/flat "A,B"|["A" "B"]|
|156|load-dsv/flat "A,B^/C,D"|["A" "B" "C" "D"]|
|157|load-fixed %a.txt|[["1" "2"] ["33" "44"]]|
|158|load-fixed/spec %a.txt [3 2]|[["1" "2"] ["33" "44"]]|
|159|load-fixed/part %a.txt 1|[["1"] ["33"]]|
|160|load-xml %test.xlsx|[["A B" "S1"] ["1" "2"]]|
|161|load-xml/sheet %test.xlsx 2|[["AB" "S2"] ["1" "2"]]|
|162|load-xml/part %test.xlsx '&S1|[["S1"] ["2"]]|
|163|load-xml/where %test.xlsx [&S1 = "2"]|[["1" "2"]]|
|164|max-of []|none|
|165|max-of [1 2]|2|
|166|merge [] 1 [] 1 [1]|[]|
|167|merge [[a 1] [b 2]] 2 [[1 "A"]] 1 [1 4]|[[a "A"]]|
|168|merge [[a 1]] 2 [[2 1] [1 "A"]] 1 [1 4]|[[a "A"]]|
|169|merge/default [[a 1] [b 2]] 2 [[1 "A"]] 1 [1 4]|[[a "A"] [b none]]|
|170|min-of []|none|
|171|min-of [1 2]|1|
|172|mixedcase ""|""|
|173|mixedcase "aa"|"Aa"|
|174|mixedcase "aa bb"|"Aa Bb"|
|175|munge []|[]|
|176|munge/where [[a] [a] [b]] 'a|[[a] [a]]|
|177|munge [[a 1] [b 2]]|[[a 1] [b 2]]|
|178|munge/part [[a 1]] 1|[[a]]|
|179|munge/part [[a 1]] [2 1]|[[1 a]]|
|180|munge/part [[a 1]] [1 "Y"]|[[a "Y"]]|
|181|munge/where [[a 1]] [even? row/2]|[]|
|182|munge/where [[a 1]] [odd? row/2]|[[a 1]]|
|183|munge/where [[a 1] [a 2] [b 3]] 'a|[[a 1] [a 2]]|
|184|munge/where [[a 1]] [row/1: 0]|[[0 1]]|
|185|munge/delete [[a 1] [b 2]] [true]|[]|
|186|munge/delete [[a 1] [b 2]] 'a|[[b 2]]|
|187|munge/delete [[a 1] [b 2]] [row/1 = 'a]|[[b 2]]|
|188|munge/group [[1] [2]] 'count|[[1 1] [2 1]]|
|189|munge/group [[1] [2]] 'avg|1.5|
|190|munge/group [[1] [2]] 'sum|3|
|191|munge/group [[1] [2]] 'min|1|
|192|munge/group [[1] [2]] 'max|2|
|193|munge/group [[a] [b] [a]] [count > 1]|[[a 2]]|
|194|munge/group [[a 1] [a 2] [b 3]] 'avg|[[a 1.5] [b 3]]|
|195|munge/group [[a 1] [a 2] [b 3]] 'sum|[[a 3] [b 3]]|
|196|munge/group [[a 1] [a 2] [b 3]] 'min|[[a 1] [b 3]]|
|197|munge/group [[a 1] [a 2] [b 3]] 'max|[[a 2] [b 3]]|
|198|munge/part [[A B] [1 2]] '&A|[[A] [1]]|
|199|munge/part next [[A B] [1 2]] '&A|[[1]]|
|200|munge/part [[A B] [1 2]] [&A]|[[A] [1]]|
|201|munge/part next [[A B] [1 2]] [&A]|[[1]]|
|202|munge/where next [[A B] [1 2]] [even? &B]|[[1 2]]|
|203|munge/where [[A] [0]] [&A = 0 &A: 1]|[[1]]|
|204|oledb %test.xlsx "SELECT * FROM Sheet1"|[["A B" "S1"] ["1" "2"]]|
|205|oledb %test.xlsx "SELECT F1 FROM Sheet1"|[["A B"] ["1"]]|
|206|oledb %test.accdb "SELECT * FROM Table1"|[["1" "2"] ["3" "4"] ["5" "6"]]|
|207|oledb %test.accdb "SELECT A FROM Table1"|[["1"] ["3"] ["5"]]|
|208|write-dsv %a.txt [[1] [2]] read-string %a.txt|"1^/2^/"|
|209|read-string %a.txt|"1^/2^/"|
|210|to binary! read-string %latin1.txt|#{4173686C6579205472C3BC746572}|
|211|replace-deep [a [a]] make map! [a b]|[b [b]]|
|212|rows? ""|0|
|213|rows? "a"|1|
|214|rows? "a^/"|2|
|215|rows? %test.xlsx|2|
|216|rows?/sheet %test.xlsx 2|2|
|217|penult []|none|
|218|penult [1]|none|
|219|penult [1 2]|1|
|220|penult [1 2 3]|2|
|221|second-last ""|none|
|222|second-last "1"|none|
|223|second-last "12"|#"1"|
|224|second-last "123"|#"2"|
|225|sheets? %test.xlsx|["A B" "AB" "A-B"]|
|226|sqlcmd sn db "select ''"|[]|
|227|sqlcmd sn db "select NULL"|[]|
|228|sqlcmd sn db "select 1 where 0 = 1"|[]|
|229|sqlcmd sn db "select NULL,NULL"|[["" ""]]|
|230|sqlcmd sn db "select 1,NULL"|[["1" ""]]|
|231|sqlcmd sn db "select NULL,1"|[["" "1"]]|
|232|sqlcmd sn db "select 0"|[["0"]]|
|233|sqlcmd sn db "select 0,1"|[["0" "1"]]|
|234|sqlcmd sn db "select 0,''"|[["0" ""]]|
|235|sqlcmd/key sn db "select 0" 1|[[0]]|
|236|sqlcmd/headings sn db "select 1 A"|[["A"] ["1"]]|
|237|sqlcmd/flat sn db "select 0,1"|["0" "1"]|
|238|sqlcmd/flat/key sn db "select 0" 1|[0]|
|239|sqlcmd/flat/headings sn db "select 1 A"|["A" "1"]|
|240|sqlcmd/identity sn db "INSERT INTO Test VALUES ('A')"|1|
|241|sqlite %a.db "select ''"|[]|
|242|sqlite %a.db "select NULL"|[]|
|243|sqlite %a.db "select 1 where 0 = 1"|[]|
|244|sqlite %a.db "select NULL,NULL"|[["" ""]]|
|245|sqlite %a.db "select 1,NULL"|[["1" ""]]|
|246|sqlite %a.db "select NULL,1"|[["" "1"]]|
|247|sqlite %a.db "select 0"|[["0"]]|
|248|sqlite %a.db "select 0,1"|[["0" "1"]]|
|249|sqlite %a.db "select 0,''"|[["0" ""]]|
|250|to-column-alpha 1|"A"|
|251|to-column-alpha 27|"AA"|
|252|to-column-number 'A|1|
|253|to-column-number "aa"|27|
|254|to-field-spec [a]|[&a]|
|255|to-field-spec ["A B:C"]|[&ABC]|
|256|to-string-date "01-02-68"|"2068-02-01"|
|257|to-string-date "01-02-75"|"1975-02-01"|
|258|to-string-date 1-Feb-2015|"2015-02-01"|
|259|to-string-date "20150201"|"2015-02-01"|
|260|to-string-date "01/02/2015"|"2015-02-01"|
|261|to-string-date "01/02/2015 12:30PM"|"2015-02-01"|
|262|to-string-date "Mon 01-02-2015"|"2015-02-01"|
|263|to-string-date "Monday 01-02-2015"|"2015-02-01"|
|264|to-string-date/mdy "01/02/2015"|"2015-01-02"|
|265|to-string-date/ydm "15/02/01"|"2015-01-02"|
|266|to-string-date "01-02-2015"|"2015-02-01"|
|267|to-string-date/mdy "01-02-2015"|"2015-01-02"|
|268|to-string-date/ydm "15-02-01"|"2015-01-02"|
|269|to-string-date "41506"|"2013-08-20"|
|270|to-string-time 0:00|"00:00:00"|
|271|to-string-time/precise 0:00|"00:00:00.000"|
|272|to-string-time 1:00|"01:00:00"|
|273|to-string-time/precise 1:00:00.001|"01:00:00.001"|
|274|to-string-time "013000000"|"01:30:00"|
|275|to-string-time "1:00AM"|"01:00:00"|
|276|to-string-time "1:00 AM"|"01:00:00"|
|277|to-string-time "1:00PM"|"13:00:00"|
|278|to-string-time "1:00 PM"|"13:00:00"|
|279|to-string-time "0.75"|"18:00:00"|
|280|to-string-time "12:30 PM"|"12:30:00"|
|281|to-string-time "12:30PM"|"12:30:00"|
|282|unarchive r1|#{61}|
|283|unarchive r2|[%a #{}]|
|284|unarchive r3|[%a #{78}]|
|285|unarchive/info r3|[%a 1]|
|286|unarchive/only r3 %a|#{78}|
|287|unarchive/only r3 %b|none|
|288|unarchive r4|[%a #{31} %b #{32}]|
|289|unarchive r5|[%a #{3132333431323334313233343132333431323334}]|
|290|union-only [[a] [a] [b]] [[b] [c] [c]]|[[a] [b] [c]]|
|291|write-dsv %a.txt [] read-string %a.txt|""|
|292|write-dsv %a.txt [[]] read-string %a.txt|""|
|293|write-dsv %a.csv [[a 1] [b 2]] read-string %a.csv|"a,1^/b,2^/"|
|294|write-dsv %a.txt [[a 1] [b 2]] read-string %a.txt|"a^-1^/b^-2^/"|
|295|write-excel %a.xlsx ["A" [[A B] [1 2]] [5 10]]|%a.xlsx|
|296|write-excel/filter %a.xlsx ["A" [[A] [B]] [5]]|%a.xlsx|
|297|settings/as-is: true|true|
|298|load-dsv {" a ^/ b "}|[[" a ^/ b "]]|
