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
* [`contains`](#contains-search)
* [`endsWith`](#endswith-search)
* [`escape`](#escape)
* [`hexescape`](#hexescape)
* [`join`](#join-table-delimiter)
* [`multiply`](#multiply-character-quantity)
* [`padLeft`](#padleft-width-character)
* [`padRight`](#padright-width-character)
* [`partition`](#partition-delimiter)
* [`rpartition`](#rpartition-delimiter)
* [`split`](#split-delimiter)
* [`startsWith`](#startswith-search)
* [`trim`](#trim)
* [`trimStart`](#trimstart)
* [`trimEnd`](#trimend)

## Function Details

Most of these functions can either be called procedurally or as object methods, that is you can use `string.contains()` or `x:contains()` if `x` is a string. (`join` can only be called procedurally because it accepts a table as the first argument, in Python you could call `";".join(list)` but that won't work in Lua so we have to call `string.join(table, ";")`)


### `contains <search>`
Returns `true` if the string contains the specified value anywhere in it (case sensitive, pattern matching is disabled)

```
print(string.contains("hello, world!", "lo"))
-- prints true
```

### `endsWith <search>`
Returns `true` if the last portion of a string matches the specified value

```
print(string.endsWith("hello, world", "rld"))
-- prints true
```

### `escape`
Escape all nonprintable characters as \ddd (compatible with Lua string literals)

```
local s = "hello\r\nworld\009"
print(s:escape())
-- prints hello\013\010\009
```

### `hexescape`
Escape all nonprintable characters as \xdd (compatible with every OTHER language... well, except VB)

```
local s = "hello\r\nworld\009"
print(s:escape())
-- prints hello\x0d\x0a\x09
```

### `join <table> [delimiter]`
Combines elements of a table into a string, with each element separated by an optional delimiter

```
local t = {"a", "b", 3}
print(string.join(t, "-"))
-- prints a-b-3
```

### `multiply <character> <quantity>`
Returns the string repeated the specified number of times

```
print(string.multiply("*", 10))
-- prints **********
```

### `padLeft [width] [character]`
Pads the left (beginning) side of the string with the specified number of padding characters (if no character is specified, space is used)

```
print("'" .. string.padLeft("hello", 3) .. "'")
-- prints '   hello'
```

### `padRight [width] [character]`
Pads the right (end) side of the string with the specified number of padding characters (if no character is specified, space is used)

```
print("'" .. string.padRight("hello", 3, "!") .. "'")
-- prints 'hello!!!'
```

### `partition [delimiter]`
Split the string at the first occurrence of the specified partition value and return the left part, the delimiter, and the right part

```
local s = "My_name_is_mud"
print(s:partition(" "))
-- prints My    _    name_is_mud
```


### `rpartition [delimiter]`
Split the string at the last occurrence of the specified partition value and return the left part, the delimiter, and the right part

```
local s = "/usr/local/bin/program"
print(s:rpartition("/"))
-- prints /usr/local/bin    /   program
```

### `split <delimiter>`
Splits a string with the specified delimiter (if the delimiter is not specified or is an empty string, the string is split at each character)

```
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
Returns `true` if the beginning portion of a string matches the specified value

```
print(string.startsWith("hello, world", "he"))
-- prints true
```

### `trim`
Trim whitespace from beginning and end of a string

```
print(string.trim("  hello  "))
-- prints hello
local s = "  hello  "
print(s:trim())
-- prints hello
```

### `trimStart`
Trim whitespace from beginning of a string

```
local s = "  hello  "
print(string.format("'%s'", s:trimStart()))
-- prints 'hello  '
```

### `trimEnd`
Trim whitespace from end of a string

```
local s = "  hello  "
print(string.format("'%s'", s:trimEnd()))
-- prints '  hello'
```
