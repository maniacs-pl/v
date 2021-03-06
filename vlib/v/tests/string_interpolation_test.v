fn test_simple_string_interpolation() {
	a := 'Hello'
	b := 'World'
	res := '$a $b'
	assert res == 'Hello World'
}

fn test_mixed_string_interpolation() {
	num := 7
	str := 'abc'
	s1 := 'number=$num'
	assert s1 == 'number=7'
	s2 := 'string=$str'
	assert s2 == 'string=abc'
	s3 := 'a: $num | b: $str'
	assert s3 == 'a: 7 | b: abc'
}

fn test_formatted_string_interpolation() {
	x := 'abc'
	axb := 'a:$x:b'
	assert axb == 'a:abc:b'
	x_10 := 'a:${x:10s}:b'
	x10_ := 'a:${x:-10s}:b'
	assert x_10 == 'a:       abc:b'
	assert x10_ == 'a:abc       :b'
	i := 23
	si_right := '${i:10d}'
	si__left := '${i:-10d}'
	assert si_right == '        23'
	assert si__left == '23        '
}

fn test_excape_dollar_in_string() {
	i := 42
	assert '($i)' == '(42)'
	assert '(\$i)'.contains('i') && !'(\$i)'.contains('42')
	assert !'(\\$i)'.contains('i') && '(\\$i)'.contains('42') && '(\\$i)'.contains('\\')
	assert '(\\\$i)'.contains('i') && !'(\\\$i)'.contains('42') && '(\\$i)'.contains('\\')
	assert !'(\\\\$i)'.contains('i') && '(\\\\$i)'.contains('42') && '(\\\\$i)'.contains('\\\\')
	assert '(${i})' == '(42)'
	assert '(\${i})'.contains('i') && !'(\${i})'.contains('42')
	assert !'(\\${i})'.contains('i') && '(\\${i})'.contains('42') && '(\\${i})'.contains('\\')
	assert '(\\\${i})'.contains('i') && !'(\\\${i})'.contains('42') && '(\\${i})'.contains('\\')
	assert !'(\\\\${i})'.contains('i') && '(\\\\${i})'.contains('42') && '(\\\\${i})'.contains('\\\\')
	assert i == 42
}

fn test_implicit_str() {
	i := 42
	assert 'int $i' == 'int 42'
	assert '$i' == '42'
	check := '$i' == '42'
	assert check
	text := '$i' + '42'
	assert text == '4242'
}

fn test_string_interpolation_percent_escaping(){
	test := 'hello'
	hello := 'world'
	x := '%.*s$hello$test |${hello:-30s}|'
	assert x == '%.*sworldhello |world                         |'
}

fn test_string_interpolation_string_prefix() {
	// `r`, `c` and `js` are also used as a string prefix.
	r := 'r'
	rr := '$r$r'
	assert rr == 'rr'
	c := 'c'
	cc := '$c$c'
	assert cc == 'cc'
	js := 'js'
	jsjs := '$js$js'
	assert jsjs == 'jsjs'
}

fn test_inttypes_string_interpolation() {
	c := i8(-103)
	uc := byte(217)
	uc2 := byte(13)
	s := i16(-23456)
	us := u16(54321)
	i := -1622999040
	ui := u32(3421958087)
	vp := voidptr(ui)
	bp := byteptr(15541149836)
	l := i64(-7694555558525237396)
	ul := u64(17234006112912956370)
	assert '$s $us' == '-23456 54321'
	assert '$ui $i' == '3421958087 -1622999040'
	assert '$l $ul' == '-7694555558525237396 17234006112912956370'
	assert '>${s:11}:${us:-13}<' == '>     -23456:54321        <'
	assert '0x${ul:-19x}:${l:22d}' == '0xef2b7d4001165bd2   :  -7694555558525237396'
	assert '${c:5}${uc:-7}x' == ' -103217    x'
	assert '${c:x}:${uc:x}:${uc2:02X}' == '99:d9:0D'
	assert '${s:X}:${us:x}:${u16(uc):04x}' == 'A460:d431:00d9'
	assert '${i:x}:${ui:X}:${int(s):x}' == '9f430000:CBF6EFC7:ffffa460'
	assert '${l:x}:${ul:X}' == '9537727cad98876c:EF2B7D4001165BD2'
	// TODO this does not work on Windows
	// assert '${vp:p}:$bp' == '0xcbf6efc7:0x39e53208c'
}

fn test_utf8_string_interpolation() {
	a := 'à-côté'
	st := 'Sträßle'
	m := '10€'
	assert '$a $st $m' == 'à-côté Sträßle 10€'
	assert '>${a:10}< >${st:-8}< >${m:5}<-' == '>    à-côté< >Sträßle < >  10€<-'
	e := '\u20AC' // Eurosign
	// TODO: this fails with MSVC and tcc
	// assert '100.00 $e' == '100.00 €'
	m2 := 'Москва́' // cyrillic а́: combination of U+0430 and U+0301, UTF-8: d0 b0 cc 81
	d := 'Antonín Dvořák' // latin á: U+00E1, UTF-8: c3 a1
	assert ':${m2:7}:${d:-15}:' == ': Москва́:Antonín Dvořák :'
	g := 'Πελοπόννησος'
	assert '>${g:-13}<' == '>Πελοπόννησος <'
}

struct S {
	v1 int
	v2 f64
}

fn (s S) str() string {
	return '[${s.v1}, ${s.v2:.3f}]'
}

fn test_string_interpolation_str_evaluation() {
	mut x := S{17, 13.455893}
	assert '$x' == '[17, 13.456]'
}
