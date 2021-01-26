import std/json
import std/strutils

import grok

proc toAnything[T: enum|string|float|int|bool](node: JsonNode): T =
  when T is int:
    result = node.getInt
  when T is string:
    result = node.getStr
  when T is bool:
    result = node.getBool
  when T is float:
    result = node.getFloat
  when T is enum:
    const
      validInts = enumValuesAsSetOfOrds T
    if node == nil:
      result = default T
    else:
      case node.kind
      of JInt:
        let i = node.getInt
        if i notin validInts:
          raise newException ValueError:
            $T & " has no enum field for " & $i
        else:
          result = T(i)
      else:
        result = parseEnum[T](node.getStr)

proc get*[T: enum|string|float|int|bool](node: JsonNode;
                                         name: string; default: T): T =
  let js = node.getOrDefault(name)
  if js == nil:
    result = default
  else:
    result = toAnything[T](js)

when isMainModule:
  import balls

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

  suite "don't use jsonconvert, nimlets":

    block:
      ## get with default
      check foo.get("1", Two) == One
      check foo.get("2", One) == Two
      check foo.get("3", Two) == Two
      check foo.get("3", One) == One
      check foo.get("int", 99) == 45
      check foo.get("flint", 99) == 99
      check foo.get("flat", 22.0) == 22.0
      check foo.get("float", 22.0) == 34.0
      check foo.get("string", "") == "hello, world"
      check foo.get("nah", "dummy") == "dummy"
      check foo.get("bool", false) == true
      check foo.get("bill", false) == false

    block:
      ## improper conversion
      expect ValueError:
        discard foo.get("int", Two)
