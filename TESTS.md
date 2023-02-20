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
9|as-date "1 Aug 2022 8:00"|"2022-08-01"
10|as-date/mdy "Aug 1 2022 8:00"|"2022-08-01"
11|as-time "1:00AM"|"01:00"
12|as-time "1:00 AM"|"01:00"
13|as-time "1:00PM"|"13:00"
14|as-time "1:00 PM"|"13:00"
15|as-time "13:00 PM"|"13:00"
16|as-time "13:00PM"|"13:00"
17|as-time "12:30 PM"|"12:30"
18|as-time "12:30PM"|"12:30"
19|call-out {sqlite3 a.db ""}|""
20|check []|true
21|check [[1]]|true
22|cols? ""|0
23|cols? ","|2
24|cols? "a,b"|2
25|cols? "a^-b"|2
26|cols? "^/a^-b"|2
27|cols? "a&#124;b"|2
28|cols? "a~b"|2
29|cols? "a;b"|2
30|cols?/with ":" #":"|2
31|cols? %test.xlsx|2
32|cols?/sheet %test.xlsx 1|2
33|cols?/sheet %test.xlsx 2|2
34|cols?/sheet %test.xlsx 3|2
35|deduplicate [["A" "B"] [0 1] [0 2]] '&A|[["A" "B"] [0 2]]
36|deduplicate [["A" "B"] [0 1] [0 2]] 1|[["A" "B"] [0 2]]
37|deduplicate/latest [["A" "B"] [0 1] [0 2]] '&A|[["A" "B"] [0 1]]
38|deduplicate/latest [["A" "B"] [0 1] [0 2]] 1|[["A" "B"] [0 1]]
39|deduplicate [["" a] ["" b]] 1|[["" a] ["" b]]
40|delimiter? ""|#","
41|delimiter? "a"|#","
42|delimiter? "^-"|#"^-"
43|delimiter? "&#124;"|#"|"
44|delimiter? "~"|#"~"
45|delimiter? ";"|#";"
46|delta [[1] [2]] [[1]]|[[2]]
47|dezero ""|""
48|dezero "0"|""
49|dezero "10"|"10"
50|dezero "01"|"1"
51|dezero "001"|"1"
52|difference-only [[a] [a] [b]] [[b] [c] [c]]|[[a] [c]]
53|digit|make bitset! #{000000000000FFC0}
54|digits? ""|none
55|digits? "a"|none
56|digits? "1"|true
57|discard [["a" ""] ["b" ""]]|[["a"] ["b"]]
58|distinct [["" ""] [a 1]]|[[a 1]]
59|distinct reduce [reduce [none none] [a 1]]|[[a 1]]
60|distinct [[a] [a]]|[[a]]
61|distinct [[a 1] [a 1]]|[[a 1]]
62|enblock [1 2 3 4] 1|[[1] [2] [3] [4]]
63|enblock [1 2 3 4] 2|[[1 2] [3 4]]
64|enzero "" 1|"0"
65|enzero "10" 1|"10"
66|enzero "10" 2|"10"
67|enzero "10" 3|"010"
68|excel? %test.xlsx|true
69|excel? %a.txt|none
70|excel? to-binary "<?xml"|true
71|excel? "Text"|false
72|export []|[]
73|export [distinct]|[distinct]
74|export [cols? rows?]|[cols? rows?]
75|fields? ""|[]
76|fields? ","|["" ""]
77|fields? "a,b"|["a" "b"]
78|fields? "^/a,b"|["a" "b"]
79|fields? "a:b"|["a:b"]
80|fields? {"a","b"}|["a" "b"]
81|fields? {"a" ,"b"}|["a" "b"]
82|fields? {"a", "b"}|["a" "b"]
83|fields?/with "a:b" #":"|["a" "b"]
84|fields? %test.xlsx|["A B" "S1"]
85|fields?/sheet %test.xlsx 1|["A B" "S1"]
86|fields?/sheet %test.xlsx 2|["AB" "S2"]
87|fields?/sheet %test.xlsx 3|["A-B" "S3"]
88|filename? %a.txt|%a.txt
89|filename? %a/b.txt|%b.txt
90|filename? %a/b.txt|%b.txt
91|first-line ""|""
92|first-line "a,1"|"a,1"
93|first-line "^/a,1"|"a,1"
94|first-line "a,1^/"|"a,1"
95|flatten []|[]
96|flatten [[a] [b]]|[a b]
97|flatten [[a 1] [b 2]]|[a 1 b 2]
98|intersect-only [[a] [b] [b]] [[b] [b] [c]]|[[b]]
99|last-line ""|""
100|last-line "a^/1^/"|"1"
101|last-line %a.txt|"33 44"
102|letter|make bitset! #{00000000000000007FFFFFE07FFFFFE0}
103|letters? ""|true
104|letters? "a"|true
105|letters? "1"|false
106|list []|[]
107|list [[a] [b]]|[[a] [b]]
108|load-dsv ""|[]
109|load-dsv ","|[["" ""]]
110|load-dsv {" a ^/ b "}|[["a b"]]
111|load-dsv "a,"|[["a" ""]]
112|load-dsv {"a" ,"b"}|[["a" "b"]]
113|load-dsv {"a", "b"}|[["a" "b"]]
114|load-dsv "a,NULL,b"|[["a" "" "b"]]
115|load-dsv/part "a,b,c" 1|[["a"]]
116|load-dsv/part "a,b,c" [1]|[["a"]]
117|load-dsv/part "a,b,c" [3 1]|[["c" "a"]]
118|load-dsv/part "a,b,c" [1 "Y"]|[["a" "Y"]]
119|load-dsv "a,1^/b,2"|[["a" "1"] ["b" "2"]]
120|load-dsv/where "a,1^/b,2" [row/1 = "a"]|[["a" "1"]]
121|load-dsv/where "a^/b^/c" [line = 2]|[["b"]]
122|load-dsv "a:b"|[["a:b"]]
123|load-dsv/with "a:b" #":"|[["a" "b"]]
124|load-dsv/part %a.csv '&F1|[["F1"] ["1"]]
125|load-dsv/where %a.csv [&F1 = "1"]|[["1" "2"]]
126|load-dsv/where "A^/0" [digits? &A &A: to-integer &A]|[[0]]
127|load-dsv/flat "A,B"|["A" "B"]
128|load-dsv/flat "A,B^/C,D"|["A" "B" "C" "D"]
129|load-fixed %a.txt [3 2]|[["1" "2"] ["33" "44"]]
130|load-fixed/part %a.txt [3 2] 1|[["1"] ["33"]]
131|load-xml %test.xlsx|[["A B" "S1"] ["1" "2"]]
132|load-xml/sheet %test.xlsx 2|[["AB" "S2"] ["1" "2"]]
133|load-xml/part %test.xlsx '&S1|[["S1"] ["2"]]
134|load-xml/where %test.xlsx [&S1 = "2"]|[["1" "2"]]
135|max-of []|none
136|max-of [1 2]|2
137|merge [] 1 [] 1 [1]|[]
138|merge [[a 1] [b 2]] 2 [[1 "A"]] 1 [1 4]|[[a "A"]]
139|merge [[a 1]] 2 [[2 1] [1 "A"]] 1 [1 4]|[[a "A"]]
140|merge/default [[a 1] [b 2]] 2 [[1 "A"]] 1 [1 4]|[[a "A"] [b none]]
141|min-of []|none
142|min-of [1 2]|1
143|mixedcase ""|""
144|mixedcase "aa"|"Aa"
145|mixedcase "aa bb"|"Aa Bb"
146|munge []|[]
147|munge/where [[a] [a] [b]] 'a|[[a] [a]]
148|munge [[a 1] [b 2]]|[[a 1] [b 2]]
149|munge/part [[a 1]] 1|[[a]]
150|munge/part [[a 1]] [2 1]|[[1 a]]
151|munge/part [[a 1]] [1 "Y"]|[[a "Y"]]
152|munge/where [[a 1]] [even? row/2]|[]
153|munge/where [[a 1]] [odd? row/2]|[[a 1]]
154|munge/where [[a 1] [a 2] [b 3]] 'a|[[a 1] [a 2]]
155|munge/where [[a 1]] [row/1: 0]|[[0 1]]
156|munge/delete [[a 1] [b 2]] [true]|[]
157|munge/delete [[a 1] [b 2]] 'a|[[b 2]]
158|munge/delete [[a 1] [b 2]] [row/1 = 'a]|[[b 2]]
159|munge/group [[1] [2]] 'count|[[1 1] [2 1]]
160|munge/group [[1] [2]] 'avg|1.5
161|munge/group [[1] [2]] 'sum|3
162|munge/group [[1] [2]] 'min|1
163|munge/group [[1] [2]] 'max|2
164|munge/group [[a] [b] [a]] [count > 1]|[[a 2]]
165|munge/group [[a 1] [a 2] [b 3]] 'avg|[[a 1.5] [b 3]]
166|munge/group [[a 1] [a 2] [b 3]] 'sum|[[a 3] [b 3]]
167|munge/group [[a 1] [a 2] [b 3]] 'min|[[a 1] [b 3]]
168|munge/group [[a 1] [a 2] [b 3]] 'max|[[a 2] [b 3]]
169|munge/part [[A B] [1 2]] '&A|[[A] [1]]
170|munge/part next [[A B] [1 2]] '&A|[[1]]
171|munge/part [[A B] [1 2]] [&A]|[[A] [1]]
172|munge/part next [[A B] [1 2]] [&A]|[[1]]
173|munge/where next [[A B] [1 2]] [even? &B]|[[1 2]]
174|munge/where [[A] [0]] [&A = 0 &A: 1]|[[1]]
175|oledb %test.xlsx "SELECT * FROM Sheet1"|[["A B" "S1"] ["1" "2"]]
176|oledb %test.xlsx "SELECT F1 FROM Sheet1"|[["A B"] ["1"]]
177|oledb %test.accdb "SELECT * FROM Table1"|[["1" "2"] ["3" "4"] ["5" "6"]]
178|oledb %test.accdb "SELECT A FROM Table1"|[["1"] ["3"] ["5"]]
179|penult []|none
180|penult [1]|none
181|penult [1 2]|1
182|penult [1 2 3]|2
183|penult ""|none
184|penult "1"|none
185|penult "12"|#"1"
186|penult "123"|#"2"
187|write-dsv %a.txt [[1] [2]] read-string %a.txt|"1^/2^/"
188|read-string %a.txt|"1^/2^/"
189|read-string #{E97C}|"é|"
190|read-string %latin1.txt|"Ashley Trüter"
191|replace-deep [a [a]] make map! [a b]|[b [b]]
192|rows? ""|0
193|rows? "a"|1
194|rows? "a^/"|2
195|rows? %test.xlsx|2
196|rows?/sheet %test.xlsx 2|2
197|sheets? %test.xlsx|["A B" "AB" "A-B"]
198|split-on "" #","|[""]
199|split-on "," #","|["" ""]
200|split-on "a,,b" #","|["a" "" "b"]
201|split-on " 1 , 2 " ","|["1" "2"]
202|split-on " 1 -> 2 " "->"|["1" "2"]
203|split-on "a,b c" make bitset! ", "|["a" "b" "c"]
204|sqlcmd sn db "select ''"|[]
205|sqlcmd sn db "select NULL"|[]
206|sqlcmd sn db "select 1 where 0 = 1"|[]
207|sqlcmd sn db "select NULL,NULL"|[["" ""]]
208|sqlcmd sn db "select 1,NULL"|[["1" ""]]
209|sqlcmd sn db "select NULL,1"|[["" "1"]]
210|sqlcmd sn db "select 0"|[["0"]]
211|sqlcmd sn db "select 0,1"|[["0" "1"]]
212|sqlcmd sn db "select 0,''"|[["0" ""]]
213|sqlcmd/key sn db "select 0" 1|[[0]]
214|sqlcmd/headings sn db "select 1 A"|[["A"] ["1"]]
215|sqlcmd/flat sn db "select 0,1"|["0" "1"]
216|sqlcmd/flat/key sn db "select 0" 1|[0]
217|sqlcmd/flat/headings sn db "select 1 A"|["A" "1"]
218|sqlcmd/identity sn db "INSERT INTO Test VALUES ('A')"|1
219|sqlite %a.db "select ''"|[]
220|sqlite %a.db "select NULL"|[]
221|sqlite %a.db "select 1 where 0 = 1"|[]
222|sqlite %a.db "select NULL,NULL"|[["" ""]]
223|sqlite %a.db "select 1,NULL"|[["1" ""]]
224|sqlite %a.db "select NULL,1"|[["" "1"]]
225|sqlite %a.db "select 0"|[["0"]]
226|sqlite %a.db "select 0,1"|[["0" "1"]]
227|sqlite %a.db "select 0,''"|[["0" ""]]
228|to-column-alpha 1|"A"
229|to-column-alpha 27|"AA"
230|to-column-number 'A|1
231|to-column-number "aa"|27
232|to-field-spec [a]|[&a]
233|to-field-spec ["A B:C"]|[&ABC]
234|to-string-date "01-02-68"|"2068-02-01"
235|to-string-date "01-02-75"|"1975-02-01"
236|to-string-date 1-Feb-2015|"2015-02-01"
237|to-string-date "20150201"|"2015-02-01"
238|to-string-date "01/02/2015"|"2015-02-01"
239|to-string-date "01/02/2015 12:30PM"|"2015-02-01"
240|to-string-date "Mon 01-02-2015"|"2015-02-01"
241|to-string-date "Monday 01-02-2015"|"2015-02-01"
242|to-string-date/mdy "01/02/2015"|"2015-01-02"
243|to-string-date/ydm "15/02/01"|"2015-01-02"
244|to-string-date "01-02-2015"|"2015-02-01"
245|to-string-date/mdy "01-02-2015"|"2015-01-02"
246|to-string-date/ydm "15-02-01"|"2015-01-02"
247|to-string-date "41506"|"2013-08-20"
248|to-string-time 0:00|"00:00:00"
249|to-string-time/precise 0:00|"00:00:00.000"
250|to-string-time 1:00|"01:00:00"
251|to-string-time/precise 1:00:00.001|"01:00:00.001"
252|to-string-time "013000000"|"01:30:00"
253|to-string-time "1:00AM"|"01:00:00"
254|to-string-time "1:00 AM"|"01:00:00"
255|to-string-time "1:00PM"|"13:00:00"
256|to-string-time "1:00 PM"|"13:00:00"
257|to-string-time "0.75"|"18:00:00"
258|to-string-time "12:30 PM"|"12:30:00"
259|to-string-time "12:30PM"|"12:30:00"
260|union-only [[a] [a] [b]] [[b] [c] [c]]|[[a] [b] [c]]
261|unzip %test.zip %test.txt|#{5265626F6C}
262|write-excel %a.xlsx ["A" [[A B] [1 2]] [5 10]]|%a.xlsx
263|write-excel/filter %a.xlsx ["A" [[A] [B]] [5]]|%a.xlsx
264|settings/as-is: true|true
265|load-dsv {" a ^/ b "}|[[" a ^/ b "]]
