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
40|deduplicate [["A" "B"] [0 1] [0 2]] '&A|[["A" "B"] [0 2]]
41|deduplicate [["A" "B"] [0 1] [0 2]] 1|[["A" "B"] [0 2]]
42|deduplicate/latest [["A" "B"] [0 1] [0 2]] '&A|[["A" "B"] [0 1]]
43|deduplicate/latest [["A" "B"] [0 1] [0 2]] 1|[["A" "B"] [0 1]]
44|deduplicate [["" a] ["" b]] 1|[["" a] ["" b]]
45|deduplicate [[1 a] [1 b]] 1|[[1 b]]
46|deduplicate/latest [[1 a] [1 b]] 1|[[1 a]]
47|delimiter? ""|[#"," ""]
48|delimiter? "a"|[#"," "a"]
49|delimiter? "^-"|[#"^-" "^-"]
50|delimiter? "&#124;"|[#"|" "|"]
51|delimiter? "~"|[#"~" "~"]
52|delimiter? ";"|[#";" ";"]
53|delimiter? "a&#124;b,c"|[#"," "a|b,c"]
54|delta [[1] [2]] [[1]]|[[2]]
55|dezero ""|""
56|dezero "0"|""
57|dezero "10"|"10"
58|dezero "01"|"1"
59|dezero "001"|"1"
60|digit|make bitset! #{000000000000FFC0}
61|digits? ""|#(none)
62|digits? "a"|#(none)
63|digits? "1"|#(true)
64|discard [["a" ""] ["b" ""]]|[["a"] ["b"]]
65|distinct [["" ""] [a 1]]|[[a 1]]
66|distinct [[#(none) #(none)] [a 1]]|[[a 1]]
67|distinct [[a] [a]]|[[a]]
68|distinct [[a 1] [a 1]]|[[a 1]]
69|drop [[a b c] [1 2 3]] '&b|[[a c] [1 3]]
70|drop [[a b c] [1 2 3]] 2|[[a c] [1 3]]
71|enblock [1 2 3 4] 1|[[1] [2] [3] [4]]
72|enblock [1 2 3 4] 2|[[1 2] [3 4]]
73|enzero "" 1|"0"
74|enzero "10" 1|"10"
75|enzero "10" 2|"10"
76|enzero "10" 3|"010"
77|excel-cols? data|2
78|excel-fields? data strings|["A B" "S1"]
79|excel-first-row data|#{3C726F7720723D223122207370616E73...
80|excel-info %test.xlsx|[["A B" 2 ["A B" "S1"]] ["AB" 2 ["AB" "S2"]] ["A-B" 2 ["A-B" "S3"]]]
81|excel-last-row data|#{3C726F7720723D223222207370616E73...
82|excel-load-sheet %test.xlsx 1|#{3C3F786D6C2076657273696F6E3D2231...
83|excel-load-strings %test.xlsx|["AB" "A B" "A-B" "S1" "S2" "S3"]
84|excel-pick-row data 2|#{3C726F7720723D223222207370616E73...
85|excel-row-numbers? data|#(true)
86|excel-rows? data|2
87|excel? %test.xlsx|#(true)
88|excel? %a.txt|#(none)
89|excel? to-binary "<?xml"|#(true)
90|excel? "Text"|#(false)
91|export []|[]
92|export [distinct]|[distinct]
93|export [cols? rows?]|[cols? rows?]
94|fields? %a.csv|["F1" "F2"]
95|fields? %test.xlsx|["A B" "S1"]
96|fields?/sheet %test.xlsx 1|["A B" "S1"]
97|fields?/sheet %test.xlsx 2|["AB" "S2"]
98|fields?/sheet %test.xlsx 3|["A-B" "S3"]
99|fields? ""|[]
100|fields? "A,B,C^/1,2,3"|["A" "B" "C"]
101|fields? "A,B,^/1,2,3"|["A" "B" ""]
102|fields? "A^/1,2,3"|["1" "2" "3"]
103|fields? ","|["" ""]
104|fields? "a,b"|["a" "b"]
105|fields? "^/a,b"|["a" "b"]
106|fields? "a:b"|["a:b"]
107|fields? {"a","b"}|["a" "b"]
108|fields? {"a" ,"b"}|["a" "b"]
109|fields? {"a", "b"}|["a" "b"]
110|fields?/with "a:b" #":"|["a" "b"]
111|filename? %a.txt|%a.txt
112|filename? %a/b.txt|%b.txt
113|filename? %a/b.txt|%b.txt
114|flatten []|[]
115|flatten [[a] [b]]|[a b]
116|flatten [[a 1] [b 2]]|[a 1 b 2]
117|html-decode "A &amp; B"|"A & B"
118|html-encode "A & B"|"A &amp; B"
119|letter|make bitset! #{00000000000000007FFFFFE07FFFFFE0}
120|letters? ""|#(true)
121|letters? "a"|#(true)
122|letters? "1"|#(false)
123|list []|[]
124|list [[a] [b]]|[[a] [b]]
125|load-dsv ""|[]
126|load-dsv ","|[["" ""]]
127|load-dsv {" a ^/ b ",AB}|[["a b" "AB"]]
128|load-dsv "a,"|[["a" ""]]
129|load-dsv {"a" ,"b"}|[["a" "b"]]
130|load-dsv {"a", "b"}|[["a" "b"]]
131|load-dsv "a,NULL,b"|[["a" "" "b"]]
132|load-dsv "a,1^/b,2"|[["a" "1"] ["b" "2"]]
133|load-dsv "a:b,c:d"|[["a:b" "c:d"]]
134|load-dsv {"a"&#124;"b"}|[[{"a"} {"b"}]]
135|load-dsv/csv {"a"&#124;"b"}|[["a" "b"]]
136|load-dsv/part "a,b,c" 1|[["a"]]
137|load-dsv/part "a,b,c" [1]|[["a"]]
138|load-dsv/part "a,b,c" [3 1]|[["c" "a"]]
139|load-dsv/part "a,b,c" [1 "Y"]|[["a" "Y"]]
140|load-dsv/part %a.csv '&F1|[["F1"] ["1"]]
141|load-dsv/where "a,1^/b,2" [row/1 = "a"]|[["a" "1"]]
142|load-dsv/where "a,1^/b,2^/c,3" [line = 2]|[["b" "2"]]
143|load-dsv/where %a.csv [&F1 = "1"]|[["1" "2"]]
144|load-dsv/where "A,B^/0,1" [digits? &A &A: to integer! &A]|[[0 "1"]]
145|load-dsv/with "a:b" #":"|[["a" "b"]]
146|load-dsv/flat "A,B"|["A" "B"]
147|load-dsv/flat "A,B^/C,D"|["A" "B" "C" "D"]
148|load-dsv/ignore "a^/b,c"|[["b" "c"]]
149|load-xml %test.xlsx|[["A B" "S1"] ["1" "2"]]
150|load-xml/sheet %test.xlsx 2|[["AB" "S2"] ["1" "2"]]
151|load-xml/part %test.xlsx '&S1|[["S1"] ["2"]]
152|load-xml/where %test.xlsx [&S1 = "2"]|[["1" "2"]]
153|load-xml/flat %test.xlsx|["A B" "S1" "1" "2"]
154|max-of []|#(none)
155|max-of [1 2]|2
156|merge [] 1 [] 1 [1]|[]
157|merge [[a 1] [b 2]] 2 [[1 "A"]] 1 [1 4]|[[a "A"]]
158|merge [[a 1]] 2 [[2 1] [1 "A"]] 1 [1 4]|[[a "A"]]
159|merge/default [[a 1] [b 2]] 2 [[1 "A"]] 1 [1 4]|[[a "A"] [b #(none)]]
160|min-of []|#(none)
161|min-of [1 2]|1
162|mixedcase ""|""
163|mixedcase "aa"|"Aa"
164|mixedcase "aa bb"|"Aa Bb"
165|mixedcase "o'brien"|"O'Brien"
166|munge []|[]
167|munge/where [[a] [a] [b]] 'a|[[a] [a]]
168|munge [[a 1] [b 2]]|[[a 1] [b 2]]
169|munge/part [[a 1]] 1|[[a]]
170|munge/part [[a 1]] [2 1]|[[1 a]]
171|munge/part [[a 1]] [1 "Y"]|[[a "Y"]]
172|munge/where [[a 1]] [even? row/2]|[]
173|munge/where [[a 1]] [odd? row/2]|[[a 1]]
174|munge/where [[a 1] [a 2] [b 3]] 'a|[[a 1] [a 2]]
175|munge/where [[a 1]] [row/1: 0]|[[0 1]]
176|munge/delete [[a 1] [b 2]] [true]|[]
177|munge/delete [[a 1] [b 2]] 'a|[[b 2]]
178|munge/delete [[a 1] [b 2]] [row/1 = 'a]|[[b 2]]
179|munge/group [[1] [2]] 'count|[[1 1] [2 1]]
180|munge/group [[1] [2]] 'avg|1.5
181|munge/group [[1] [2]] 'sum|3
182|munge/group [[1] [2]] 'min|1
183|munge/group [[1] [2]] 'max|2
184|munge/group [[a] [b] [a]] [count > 1]|[[a 2]]
185|munge/group [[a 1] [a 2] [b 3]] 'avg|[[a 1.5] [b 3]]
186|munge/group [[a 1] [a 2] [b 3]] 'sum|[[a 3] [b 3]]
187|munge/group [[a 1] [a 2] [b 3]] 'min|[[a 1] [b 3]]
188|munge/group [[a 1] [a 2] [b 3]] 'max|[[a 2] [b 3]]
189|munge/part [[A B] [1 2]] '&A|[[A] [1]]
190|munge/part next [[A B] [1 2]] '&A|[[1]]
191|munge/part [[A B] [1 2]] [&A]|[[A] [1]]
192|munge/part next [[A B] [1 2]] [&A]|[[1]]
193|munge/where next [[A B] [1 2]] [even? &B]|[[1 2]]
194|munge/where [[A] [0]] [&A = 0 &A: 1]|[[1]]
195|oledb %test.xlsx "SELECT * FROM Sheet1"|[["A B" "S1"] ["1" "2"]]
196|oledb %test.xlsx "SELECT F1 FROM Sheet1"|[["A B"] ["1"]]
197|oledb %test.accdb "SELECT * FROM Table1"|[["1" "2"] ["3" "4"] ["5" "6"]]
198|oledb %test.accdb "SELECT A FROM Table1"|[["1"] ["3"] ["5"]]
199|penult []|#(none)
200|penult [1]|#(none)
201|penult [1 2]|1
202|penult [1 2 3]|2
203|penult ""|#(none)
204|penult "1"|#(none)
205|penult "12"|#"1"
206|penult "123"|#"2"
207|write-dsv %a.txt [[1] [2]] read-string %a.txt|"1^/2^/"
208|read-string %a.txt|"1^/2^/"
209|read-string #{E97C}|"é|"
210|read-string %latin1.txt|"Ashley Trüter"
211|replace-deep [a [a]] make map! [a b]|[b [b]]
212|rows? ""|0
213|rows? "a"|1
214|rows? "a^/"|2
215|rows? %test.xlsx|2
216|rows?/sheet %test.xlsx 2|2
217|sheets? %test.xlsx|["A B" "AB" "A-B"]
218|split-on "" #","|[""]
219|split-on "," #","|["" ""]
220|split-on "a,,b" #","|["a" "" "b"]
221|split-on " 1 , 2 " ","|["1" "2"]
222|split-on " 1 -> 2 " "->"|["1" "2"]
223|split-on "a,b c" make bitset! ", "|["a" "b" "c"]
224|sqlcmd sn db "select ''"|[]
225|sqlcmd sn db "select NULL"|[[""]]
226|sqlcmd sn db "select 1 where 0 = 1"|[]
227|sqlcmd sn db "select NULL,NULL"|[["" ""]]
228|sqlcmd sn db "select 1,NULL"|[["1" ""]]
229|sqlcmd sn db "select NULL,1"|[["" "1"]]
230|sqlcmd sn db "select 0"|[["0"]]
231|sqlcmd sn db "select 0,1"|[["0" "1"]]
232|sqlcmd sn db "select 0,''"|[["0" ""]]
233|sqlcmd/key sn db "select 0" 1|[[0]]
234|sqlcmd/headings sn db "select 1 A"|[["A"] ["1"]]
235|sqlcmd/flat sn db "select 0,1"|["0" "1"]
236|sqlcmd/flat/key sn db "select 0" 1|[0]
237|sqlcmd/flat/headings sn db "select 1 A"|["A" "1"]
238|sqlcmd/identity sn db "INSERT INTO Test VALUES ('A')"|1
239|to-column-alpha 1|"A"
240|to-column-alpha 27|"AA"
241|to-column-number 'A|1
242|to-column-number "aa"|27
243|to-field-spec [a]|[&a]
244|to-field-spec ["A B:C"]|[&ABC]
245|to-string-date "01-02-68"|"2068-02-01"
246|to-string-date "01-02-76"|"1976-02-01"
247|to-string-date 1-Feb-2015|"2015-02-01"
248|to-string-date "20150201"|"2015-02-01"
249|to-string-date "01/02/2015"|"2015-02-01"
250|to-string-date "01/02/2015 12:30PM"|"2015-02-01"
251|to-string-date "Mon 01-02-2015"|"2015-02-01"
252|to-string-date "Monday 01-02-2015"|"2015-02-01"
253|to-string-date/mdy "01/02/2015"|"2015-01-02"
254|to-string-date/ydm "15/02/01"|"2015-01-02"
255|to-string-date "01-02-2015"|"2015-02-01"
256|to-string-date/mdy "01-02-2015"|"2015-01-02"
257|to-string-date/ydm "15-02-01"|"2015-01-02"
258|to-string-date "41506"|"2013-08-20"
259|to-string-time 0:00|"00:00:00"
260|to-string-time/precise 0:00|"00:00:00.000"
261|to-string-time 1:00|"01:00:00"
262|to-string-time/precise 1:00:00.001|"01:00:00.001"
263|to-string-time "013000000"|"01:30:00"
264|to-string-time "1:00AM"|"01:00:00"
265|to-string-time "1:00 AM"|"01:00:00"
266|to-string-time "1:00PM"|"13:00:00"
267|to-string-time "1:00 PM"|"13:00:00"
268|to-string-time "0.75"|"18:00:00"
269|to-string-time "12:30 PM"|"12:30:00"
270|to-string-time "12:30PM"|"12:30:00"
271|transpose [[a 1] [b 2] [c 3]]|[[a b c] [1 2 3]]
272|transpose [[a b c] [1 2 3]]|[[a 1] [b 2] [c 3]]
273|trim-rows [[""]]|[[]]
274|trim-rows [["A"]]|[["A"]]
275|trim-rows [["A" ""]]|[["A"]]
276|trim-rows [["" "A"]]|[["A"]]
277|trim-rows [["" "A" ""]]|[["A"]]
278|unzip/only %test.zip %test.txt|#{5265626F6C}
279|write-dsv %a.txt [] read-string %a.txt|""
280|write-dsv %a.txt [[]] read-string %a.txt|"^/"
281|write-dsv %a.csv [['a 1] ['b 2]] read-string %a.csv|"a,1^/b,2^/"
282|write-dsv %a.txt [['a 1] ['b 2]] read-string %a.txt|"a^-1^/b^-2^/"
283|write-excel %a.xlsx ["A" [[A B] [1 2]] [5 10]]|%a.xlsx
284|write-excel/filter %a.xlsx ["A" [[A] [B]] [5]]|%a.xlsx
285|settings/as-is: true|#(true)
286|load-dsv {" a ^/ b ",AB}|[[" a ^/ b " "AB"]]