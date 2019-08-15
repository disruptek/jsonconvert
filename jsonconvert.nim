#? replace(sub = "\t", by = " ")
import json
import strutils

proc toAnything[T: enum|string|float|int|bool](node: JsonNode): T =
	when T is int:
		result = cast[T](node.getInt)
	when T is string:
		result = cast[T](node.getStr)
	when T is bool:
		result = cast[T](node.getBool)
	when T is float:
		result = cast[T](node.getFloat)
	when T is enum:
		assert node == nil or node.kind == JString
		result = parseEnum[T](node.getStr)

proc get*[T: enum|string|float|int|bool](node: JsonNode; name: string; default: T): T =
	#echo "get ", T, " or default of ", default.repr
	let js = node.getOrDefault(name)
	if js == nil:
		result = default
	else:
		#echo "convert to ", typeof(T), " using " & $js
		result = toAnything[T](js)
	#echo "result is ", typeof(result), " dollar: ", result

if isMainModule:
	type Foo = enum One, Two
	let foo = %* {
		"1": "One",
		"2": "Two",
		"string": "hello, world",
		"int": 45,
		"float": 34.0,
		"null": nil,
		"bool": true,
	}
	assert foo.get("1", Two) == One
	assert foo.get("2", One) == Two
	assert foo.get("3", Two) == Two
	assert foo.get("3", One) == One
	assert foo.get("int", 99) == 45
	assert foo.get("flint", 99) == 99
	assert foo.get("flat", 22.0) == 22.0
	assert foo.get("float", 22.0) == 34.0
	assert foo.get("string", "") == "hello, world"
	assert foo.get("nah", "dummy") == "dummy"
	assert foo.get("bool", false) == true
	assert foo.get("bill", false) == false
	try:
		discard foo.get("int", Two)
		assert false, "dainbramaged json conversion"
	except:
		discard
