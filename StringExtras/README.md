# StringExtras

## Overview
Adds additional functions to strings

## Generic Usage
Add the `StringExtras` folder to somewhere on your Lua package path and then use `require "StringExtras"` at the top of your script. All strings will now have these new functions added to them.

## Q-SYS Usage
1. Copy the `StringExtras` folder to `%USERPROFILE%\Documents\QSC\Q-Sys Designer\Modules\`
2. Install the module in Tools > Show Design Resources
3. Add `require "StringExtras"` to the top of each script that will use it

## Added Functions
* [contains](#contains-search)
* [endsWith](#endswith-search)
* [escape](#escape)
* [fromHexString](#fromhexstring)
* [hexescape](#hexescape)
* [join](#join-table-delimiter)
* [multiply](#multiply-character-quantity)
* [padLeft](#padleft-width-character)
* [padRight](#padright-width-character)
* [partition](#partition-delimiter)
* [rpartition](#rpartition-delimiter)
* [split](#split-delimiter)
* [startsWith](#startswith-search)
* [toHexString](#tohexstring)
* [trim](#trim)
* [trimStart](#trimstart)
* [trimEnd](#trimend)
* [unescape](#unescape)




## Function Details

### `contains <search>`
Returns true if the string contains the specified value anywhere in it (case sensitive, pattern matching is disabled)

```lua
print(string.contains("hello, world!", "lo"))
-- prints true
```

### `endsWith <search>`
Returns true if the last portion of a string matches the specified value

```lua
print(string.endsWith("hello, world", "rld"))
-- prints true
```

### `escape`
Escape all nonprintable characters as \ddd (compatible with Lua string literals)

```lua
local s = "hello\r\nworld\009"
print(s:escape())
-- prints hello\013\010\009
```

### `fromHexString`
Convert two-digit hex character pairs into bytes (whitespace and newlines are ignored, but other characters will cause an error)

```lua
local s = "41 42 20 30 31"
print(s:fromHexString())
-- prints AB 01
```

### `hexescape`
Escape all nonprintable characters as \xdd (compatible with every OTHER language... well, except VB)

```lua
local s = "hello\r\nworld\009"
print(s:escape())
-- prints hello\x0d\x0a\x09
```

### `join <table> [delimiter]`
Combines elements of a table into a string, with each element separated by an optional delimiter

```lua
local t = {"a", "b", 3}
print(string.join(t, "-"))
-- prints a-b-3
```

### `multiply <character> <quantity>`
Returns the string repeated the specified number of times
```lua
print(string.multiply("*", 10))
-- prints **********
```

### `padLeft [width] [character]`
Pads the left (beginning) side of the string with the specified number of padding characters (if no character is specified, space is used)

```lua
print("'" .. string.padLeft("hello", 3) .. "'")
-- prints '   hello'
```

### `padRight [width] [character]`
Pads the right (end) side of the string with the specified number of padding characters (if no character is specified, space is used)

```lua
print("'" .. string.padRight("hello", 3, "!") .. "'")
-- prints 'hello!!!'
```

### `partition [delimiter]`
Split the string at the first occurrence of the specified partition value and return the left part, the delimiter, and the right part

```lua
local s = "My_name_is_mud"
print(s:partition(" "))
-- prints My    _    name_is_mud
```


### `rpartition [delimiter]`
Split the string at the last occurrence of the specified partition value and return the left part, the delimiter, and the right part

```lua
local s = "/usr/local/bin/program"
print(s:rpartition("/"))
-- prints /usr/local/bin    /   program
```

### `split <delimiter>`
Splits a string with the specified delimiter (if the delimiter is not specified or is an empty string, the string is split at each character)

```lua
local x = "abcd;1234;"
local t = x:split(";")
for _, v in ipairs(t) do
    print(string.format("'%s", v))
end
-- prints
-- 'abcd'
-- '1234'
-- ''
```

### `startsWith <search>`
Returns true if the beginning  portion of a string matches the specified value

```lua
print(string.startsWith("hello, world", "he"))
-- prints true
```

### `toHexString`
Converts each character (byte) from a string to two-digit hex pairs separated by a delimiter (defaults to a single space)

```lua
local s = "AB 12"
print(s:toHexString())
-- prints 41 42 20 31 32

print(s:toHexString("."))
-- prints 41.42.20.31.32
```

### `trim`
Trim whitespace from beginning and end of a string

```lua
print(string.trim("  hello  "))
-- prints hello
local s = "  hello  "
print(s:trim())
-- prints hello
```

### `trimStart`
Trim whitespace from beginning of a string

```lua
local s = "  hello  "
print(string.format("'%s'", s:trimStart()))
-- prints 'hello  '
```

### `trimEnd`
Trim whitespace from end of a string

```lua
local s = "  hello  "
print(string.format("'%s'", s:trimEnd()))
-- prints '  hello'
```

### `unescape`
Convert Lua escape sequences to the associated characters

Supports all escape sequences that Lua string literals support:

* `\a`: bell (`0x07`)
* `\b`: backspace (`0x08`)
* `\f`: form feed (`0x0c`)
* `\n`: newline (`0x0a`)
* `\r`: carriage return (`0x0d`)
* `\t`: tab (`0x09`)
* `\v`: vertical tab (`0x0b`)
* `\\`: backslash (`\`)
* `\"`: double quote (`"`)
* `\'`: single quote/apostrophe (`'`)
* `\ddd`: decimal ASCII value between `0` to `255`, leading zeros unnecessary
* `\u{hhhhhhhh}`: hexadecimal UTF-8 code point between `00000000` and `7FFFFFFF`, leading zeroes unnecessary; if you use UTF-8 characters, remember that they may be multiple bytes, so you can not use the length of the string to determin the number of characters ()
* `\<newline>`: ignores newline character in string

_Note that these are slightly different from the usual C-style escape sequences, notably: `\nnn` is a decimal value, not octal; the unicode sequence must be surrounded by curly-brackets; there's no `\x` hex escape sequence; a backslash as the last character of a line before the newline will ignore the newline and continue the string._

```lua
-- we have to escape the backslashes here in this string literal so the actual string contains only one backslash before we unescape it
local s = "hello\\nworld\\33\\u{1f602}"
print(s:unescape())

--[[ Output:
hello
world!😂
]]--

-- UTF-8 characters may be multiple bytes, even though they're only actually one character
-- the length operator in Lua will only see the individual bytes, so using it on a string that
-- contains UTF-8 characters may return unexpected values
s = string.unescape("\\u{1f602}") -- one single UTF-8 glyph
print(#s)
-- prints 4
```

[Back to top](#stringextras)