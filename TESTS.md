#|Test|Result
--:|----|------
1|as-date "01/02/2015"|"2015-02-01"
2|as-date "01/02/2015 12:30PM"|"2015-02-01"
3|as-date/mdy "01/02/2015"|"2015-01-02"
4|as-date "01/02/15"|"2015-02-01"
5|as-date "01-02-15"|"2015-02-01"
6|as-date "01-02-15 12:30PM"|"2015-02-01"
7|as-date/mdy "01-02-2015"|"2015-01-02"
8|as-date "01-02-15"|"2015-02-01"
9|as-date "1 Aug 2022"|"2022-08-01"
10|as-date/mdy "Aug 1 2022"|"2022-08-01"
11|as-time "1:00AM"|"01:00"
12|as-time "1:00 AM"|"01:00"
13|as-time "1:00PM"|"13:00"
14|as-time "1:00 PM"|"13:00"
15|as-time "13:00 PM"|"13:00"
16|as-time "13:00PM"|"13:00"
17|as-time "12:30 PM"|"12:30"
18|as-time "12:30PM"|"12:30"
19|call-out {sqlite3 a.db ""}|""
20|check []|#(true)
21|check [[]]|#(false)
22|check [[[]]]|#(false)
23|check [[1]]|#(true)
24|check [[#(none)]]|#(false)
25|check [[1] [2]]|#(true)
26|check [[1] [2 3]]|#(false)
27|cols? ""|0
28|cols? ","|2
29|cols? "a,b"|2
30|cols? "a^-b"|2
31|cols? "^/a^-b"|2
32|cols? "a&#124;b"|2
33|cols? "a~b"|2
34|cols? "a;b"|2
35|cols?/with ":" #":"|2
36|cols? %test.xlsx|2
37|cols?/sheet %test.xlsx 1|2
38|cols?/sheet %test.xlsx 2|2
39|cols?/sheet %test.xlsx 3|2
40|discard-last [[""]]|[[]]
41|discard-last [["A"]]|[["A"]]
42|discard-last [["A" ""]]|[["A"]]
43|discard-last [["A" "" ""]]|[["A"]]
44|deduplicate [["A" "B"] [0 1] [0 2]] '&A|[["A" "B"] [0 2]]
45|deduplicate [["A" "B"] [0 1] [0 2]] 1|[["A" "B"] [0 2]]
46|deduplicate/latest [["A" "B"] [0 1] [0 2]] '&A|[["A" "B"] [0 1]]
47|deduplicate/latest [["A" "B"] [0 1] [0 2]] 1|[["A" "B"] [0 1]]
48|deduplicate [["" a] ["" b]] 1|[["" a] ["" b]]
49|deduplicate [[1 a] [1 b]] 1|[[1 b]]
50|deduplicate/latest [[1 a] [1 b]] 1|[[1 a]]
51|delimiter? ""|#","
52|delimiter? "a"|#","
53|delimiter? "^-"|#"^-"
54|delimiter? "&#124;"|#"|"
55|delimiter? "~"|#"~"
56|delimiter? ";"|#";"
57|delta [[1] [2]] [[1]]|[[2]]
58|dezero ""|""
59|dezero "0"|""
60|dezero "10"|"10"
61|dezero "01"|"1"
62|dezero "001"|"1"
63|digit|make bitset! #{000000000000FFC0}
64|digits? ""|#(none)
65|digits? "a"|#(none)
66|digits? "1"|#(true)
67|discard [["a" ""] ["b" ""]]|[["a"] ["b"]]
68|distinct [["" ""] [a 1]]|[[a 1]]
69|distinct [[#(none) #(none)] [a 1]]|[[a 1]]
70|distinct [[a] [a]]|[[a]]
71|distinct [[a 1] [a 1]]|[[a 1]]
72|drop [[a b c] [1 2 3]] '&b|[[a c] [1 3]]
73|drop [[a b c] [1 2 3]] 2|[[a c] [1 3]]
74|enblock [1 2 3 4] 1|[[1] [2] [3] [4]]
75|enblock [1 2 3 4] 2|[[1 2] [3 4]]
76|enzero "" 1|"0"
77|enzero "10" 1|"10"
78|enzero "10" 2|"10"
79|enzero "10" 3|"010"
80|excel-cols? data|2
81|excel-fields? data strings|["A B" "S1"]
82|excel-first-row data|#{3C726F7720723D223122207370616E73...
83|excel-info %test.xlsx|[["A B" 2 ["A B" "S1"]] ["AB" 2 ["AB" "S2"]] ["A-B" 2 ["A-B" "S3"]]]
84|excel-last-row data|#{3C726F7720723D223222207370616E73...
85|excel-load-sheet %test.xlsx 1|#{3C3F786D6C2076657273696F6E3D2231...
86|excel-load-strings %test.xlsx|["AB" "A B" "A-B" "S1" "S2" "S3"]
87|excel-pick-row data 2|#{3C726F7720723D223222207370616E73...
88|excel-rows? data|2
89|excel? %test.xlsx|#(true)
90|excel? %a.txt|#(none)
91|excel? to-binary "<?xml"|#(true)
92|excel? "Text"|#(false)
93|export []|[]
94|export [distinct]|[distinct]
95|export [cols? rows?]|[cols? rows?]
96|fields? %a.csv|["F1" "F2"]
97|fields? %test.xlsx|["A B" "S1"]
98|fields?/sheet %test.xlsx 1|["A B" "S1"]
99|fields?/sheet %test.xlsx 2|["AB" "S2"]
100|fields?/sheet %test.xlsx 3|["A-B" "S3"]
101|fields? ""|[]
102|fields? "A,B,C^/1,2,3"|["A" "B" "C"]
103|fields? "A,B,^/1,2,3"|["A" "B" ""]
104|fields? "A,,^/1,2,3"|["1" "2" "3"]
105|fields? ","|["" ""]
106|fields? "a,b"|["a" "b"]
107|fields? "^/a,b"|["a" "b"]
108|fields? "a:b"|["a:b"]
109|fields? {"a","b"}|["a" "b"]
110|fields? {"a" ,"b"}|["a" "b"]
111|fields? {"a", "b"}|["a" "b"]
112|fields?/with "a:b" #":"|["a" "b"]
113|filename? %a.txt|%a.txt
114|filename? %a/b.txt|%b.txt
115|filename? %a/b.txt|%b.txt
116|first-line ""|""
117|first-line "a,1"|"a,1"
118|first-line "^/a,1"|"a,1"
119|first-line "a,1^/"|"a,1"
120|first-value []|#(none)
121|first-value [""]|#(none)
122|first-value [1 ""]|1
123|first-value ["" 1]|1
124|flatten []|[]
125|flatten [[a] [b]]|[a b]
126|flatten [[a 1] [b 2]]|[a 1 b 2]
127|html-decode "A &amp; B"|"A & B"
128|html-encode "A & B"|"A &amp; B"
129|last-line ""|""
130|last-line "a^/1^/"|"1"
131|last-line %a.txt|"33 44"
132|letter|make bitset! #{00000000000000007FFFFFE07FFFFFE0}
133|letters? ""|#(true)
134|letters? "a"|#(true)
135|letters? "1"|#(false)
136|list []|[]
137|list [[a] [b]]|[[a] [b]]
138|load-dsv ""|[]
139|load-dsv ","|[["" ""]]
140|load-dsv {" a ^/ b "}|[["a b"]]
141|load-dsv "a,"|[["a" ""]]
142|load-dsv {"a" ,"b"}|[["a" "b"]]
143|load-dsv {"a", "b"}|[["a" "b"]]
144|load-dsv "a,NULL,b"|[["a" "" "b"]]
145|load-dsv "a,1^/b,2"|[["a" "1"] ["b" "2"]]
146|load-dsv "a:b"|[["a:b"]]
147|load-dsv {"a"&#124;"b"}|[[{"a"} {"b"}]]
148|load-dsv/csv {"a"&#124;"b"}|[["a" "b"]]
149|load-dsv/part "a,b,c" 1|[["a"]]
150|load-dsv/part "a,b,c" [1]|[["a"]]
151|load-dsv/part "a,b,c" [3 1]|[["c" "a"]]
152|load-dsv/part "a,b,c" [1 "Y"]|[["a" "Y"]]
153|load-dsv/part %a.csv '&F1|[["F1"] ["1"]]
154|load-dsv/where "a,1^/b,2" [row/1 = "a"]|[["a" "1"]]
155|load-dsv/where "a^/b^/c" [line = 2]|[["b"]]
156|load-dsv/where %a.csv [&F1 = "1"]|[["1" "2"]]
157|load-dsv/where "A^/0" [digits? &A &A: to-integer &A]|[[0]]
158|load-dsv/with "a:b" #":"|[["a" "b"]]
159|load-dsv/flat "A,B"|["A" "B"]
160|load-dsv/flat "A,B^/C,D"|["A" "B" "C" "D"]
161|load-dsv/ignore "a^/b,c"|[["a"] ["b" "c"]]
162|load-fixed %a.txt [3 2]|[["1" "2"] ["33" "44"]]
163|load-fixed/part %a.txt [3 2] 1|[["1"] ["33"]]
164|load-xml %test.xlsx|[["A B" "S1"] ["1" "2"]]
165|load-xml/sheet %test.xlsx 2|[["AB" "S2"] ["1" "2"]]
166|load-xml/part %test.xlsx '&S1|[["S1"] ["2"]]
167|load-xml/where %test.xlsx [&S1 = "2"]|[["1" "2"]]
168|load-xml/flat %test.xlsx|["A B" "S1" "1" "2"]
169|max-of []|#(none)
170|max-of [1 2]|2
171|merge [] 1 [] 1 [1]|[]
172|merge [[a 1] [b 2]] 2 [[1 "A"]] 1 [1 4]|[[a "A"]]
173|merge [[a 1]] 2 [[2 1] [1 "A"]] 1 [1 4]|[[a "A"]]
174|merge/default [[a 1] [b 2]] 2 [[1 "A"]] 1 [1 4]|[[a "A"] [b #(none)]]
175|min-of []|#(none)
176|min-of [1 2]|1
177|mixedcase ""|""
178|mixedcase "aa"|"Aa"
179|mixedcase "aa bb"|"Aa Bb"
180|mixedcase "o'brien"|"O'Brien"
181|munge []|[]
182|munge/where [[a] [a] [b]] 'a|[[a] [a]]
183|munge [[a 1] [b 2]]|[[a 1] [b 2]]
184|munge/part [[a 1]] 1|[[a]]
185|munge/part [[a 1]] [2 1]|[[1 a]]
186|munge/part [[a 1]] [1 "Y"]|[[a "Y"]]
187|munge/where [[a 1]] [even? row/2]|[]
188|munge/where [[a 1]] [odd? row/2]|[[a 1]]
189|munge/where [[a 1] [a 2] [b 3]] 'a|[[a 1] [a 2]]
190|munge/where [[a 1]] [row/1: 0]|[[0 1]]
191|munge/delete [[a 1] [b 2]] [true]|[]
192|munge/delete [[a 1] [b 2]] 'a|[[b 2]]
193|munge/delete [[a 1] [b 2]] [row/1 = 'a]|[[b 2]]
194|munge/group [[1] [2]] 'count|[[1 1] [2 1]]
195|munge/group [[1] [2]] 'avg|1.5
196|munge/group [[1] [2]] 'sum|3
197|munge/group [[1] [2]] 'min|1
198|munge/group [[1] [2]] 'max|2
199|munge/group [[a] [b] [a]] [count > 1]|[[a 2]]
200|munge/group [[a 1] [a 2] [b 3]] 'avg|[[a 1.5] [b 3]]
201|munge/group [[a 1] [a 2] [b 3]] 'sum|[[a 3] [b 3]]
202|munge/group [[a 1] [a 2] [b 3]] 'min|[[a 1] [b 3]]
203|munge/group [[a 1] [a 2] [b 3]] 'max|[[a 2] [b 3]]
204|munge/part [[A B] [1 2]] '&A|[[A] [1]]
205|munge/part next [[A B] [1 2]] '&A|[[1]]
206|munge/part [[A B] [1 2]] [&A]|[[A] [1]]
207|munge/part next [[A B] [1 2]] [&A]|[[1]]
208|munge/where next [[A B] [1 2]] [even? &B]|[[1 2]]
209|munge/where [[A] [0]] [&A = 0 &A: 1]|[[1]]
210|oledb %test.xlsx "SELECT * FROM Sheet1"|[["A B" "S1"] ["1" "2"]]
211|oledb %test.xlsx "SELECT F1 FROM Sheet1"|[["A B"] ["1"]]
212|oledb %test.accdb "SELECT * FROM Table1"|[["1" "2"] ["3" "4"] ["5" "6"]]
213|oledb %test.accdb "SELECT A FROM Table1"|[["1"] ["3"] ["5"]]
214|penult []|#(none)
215|penult [1]|#(none)
216|penult [1 2]|1
217|penult [1 2 3]|2
218|penult ""|#(none)
219|penult "1"|#(none)
220|penult "12"|#"1"
221|penult "123"|#"2"
222|write-dsv %a.txt [[1] [2]] read-string %a.txt|"1^/2^/"
223|read-string %a.txt|"1^/2^/"
224|read-string #{E97C}|"é|"
225|read-string %latin1.txt|"Ashley Trüter"
226|replace-deep [a [a]] make map! [a b]|[b [b]]
227|rows? ""|0
228|rows? "a"|1
229|rows? "a^/"|2
230|rows? %test.xlsx|2
231|rows?/sheet %test.xlsx 2|2
232|sheets? %test.xlsx|["A B" "AB" "A-B"]
233|split-on "" #","|[""]
234|split-on "," #","|["" ""]
235|split-on "a,,b" #","|["a" "" "b"]
236|split-on " 1 , 2 " ","|["1" "2"]
237|split-on " 1 -> 2 " "->"|["1" "2"]
238|split-on "a,b c" make bitset! ", "|["a" "b" "c"]
239|sqlcmd sn db "select ''"|[]
240|sqlcmd sn db "select NULL"|[]
241|sqlcmd sn db "select 1 where 0 = 1"|[]
242|sqlcmd sn db "select NULL,NULL"|[["" ""]]
243|sqlcmd sn db "select 1,NULL"|[["1" ""]]
244|sqlcmd sn db "select NULL,1"|[["" "1"]]
245|sqlcmd sn db "select 0"|[["0"]]
246|sqlcmd sn db "select 0,1"|[["0" "1"]]
247|sqlcmd sn db "select 0,''"|[["0" ""]]
248|sqlcmd/key sn db "select 0" 1|[[0]]
249|sqlcmd/headings sn db "select 1 A"|[["A"] ["1"]]
250|sqlcmd/flat sn db "select 0,1"|["0" "1"]
251|sqlcmd/flat/key sn db "select 0" 1|[0]
252|sqlcmd/flat/headings sn db "select 1 A"|["A" "1"]
253|sqlcmd/identity sn db "INSERT INTO Test VALUES ('A')"|1
254|sqlite %a.db "select ''"|[]
255|sqlite %a.db "select NULL"|[]
256|sqlite %a.db "select 1 where 0 = 1"|[]
257|sqlite %a.db "select NULL,NULL"|[["" ""]]
258|sqlite %a.db "select 1,NULL"|[["1" ""]]
259|sqlite %a.db "select NULL,1"|[["" "1"]]
260|sqlite %a.db "select 0"|[["0"]]
261|sqlite %a.db "select 0,1"|[["0" "1"]]
262|sqlite %a.db "select 0,''"|[["0" ""]]
263|to-column-alpha 1|"A"
264|to-column-alpha 27|"AA"
265|to-column-number 'A|1
266|to-column-number "aa"|27
267|to-field-spec [a]|[&a]
268|to-field-spec ["A B:C"]|[&ABC]
269|to-string-date "01-02-68"|"2068-02-01"
270|to-string-date "01-02-76"|"1976-02-01"
271|to-string-date 1-Feb-2015|"2015-02-01"
272|to-string-date "20150201"|"2015-02-01"
273|to-string-date "01/02/2015"|"2015-02-01"
274|to-string-date "01/02/2015 12:30PM"|"2015-02-01"
275|to-string-date "Mon 01-02-2015"|"2015-02-01"
276|to-string-date "Monday 01-02-2015"|"2015-02-01"
277|to-string-date/mdy "01/02/2015"|"2015-01-02"
278|to-string-date/ydm "15/02/01"|"2015-01-02"
279|to-string-date "01-02-2015"|"2015-02-01"
280|to-string-date/mdy "01-02-2015"|"2015-01-02"
281|to-string-date/ydm "15-02-01"|"2015-01-02"
282|to-string-date "41506"|"2013-08-20"
283|to-string-time 0:00|"00:00:00"
284|to-string-time/precise 0:00|"00:00:00.000"
285|to-string-time 1:00|"01:00:00"
286|to-string-time/precise 1:00:00.001|"01:00:00.001"
287|to-string-time "013000000"|"01:30:00"
288|to-string-time "1:00AM"|"01:00:00"
289|to-string-time "1:00 AM"|"01:00:00"
290|to-string-time "1:00PM"|"13:00:00"
291|to-string-time "1:00 PM"|"13:00:00"
292|to-string-time "0.75"|"18:00:00"
293|to-string-time "12:30 PM"|"12:30:00"
294|to-string-time "12:30PM"|"12:30:00"
295|transpose [[a 1] [b 2] [c 3]]|[[a b c] [1 2 3]]
296|transpose [[a b c] [1 2 3]]|[[a 1] [b 2] [c 3]]
297|unzip/only %test.zip %test.txt|#{5265626F6C}
298|write-dsv %a.txt [] read-string %a.txt|""
299|write-dsv %a.txt [[]] read-string %a.txt|"^/"
300|write-dsv %a.csv [['a 1] ['b 2]] read-string %a.csv|"a,1^/b,2^/"
301|write-dsv %a.txt [['a 1] ['b 2]] read-string %a.txt|"a^-1^/b^-2^/"
302|write-excel %a.xlsx ["A" [[A B] [1 2]] [5 10]]|%a.xlsx
303|write-excel/filter %a.xlsx ["A" [[A] [B]] [5]]|%a.xlsx
304|settings/as-is: true|#(true)
305|load-dsv {" a ^/ b "}|[[" a ^/ b "]]