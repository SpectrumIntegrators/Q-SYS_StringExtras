--[[
String Extras
Adds additional functions to strings

2024-02-13
Jonathan Dean (jonathand@spectrumintegrators.com)

Added functions: 
* trim: Trim whitespace from beginning and end of a string
* trimStart: Trim whitespace from beginning of a string
* trimEnd: Trim whitespace from end of a string
* endsWith: Returns true if the last portion of a string matches the specified value
* startsWith: Returns true if the beginning  portion of a string matches the specified value
* escape: Escape all nonprintable characters as \ddd (compatible with Lua string literals)
* hexescape: Escape all nonprintable characters as \xdd (compatible with every OTHER language... well, except VB)
* contains: Returns true if the string contains the specified value anywhere in it (case sensitive, pattern matching is disabled)
* multiply: Returns the string repeated the specified number of times
* split: Splits a string with the specified delimiter (if the delimiter is not specified or is an empty string, the string is split at each character)
* join: Combines elements of a table into a string, with each element separated by an optional delimiter
* partition: Split the string at the first occurance of the specified partition value and return the left part, the delimiter, and the right part
* rpartition: Split the string at the last occurance of the specified partition value and return the left part, the delimiter, and the right part

Usage:
1. Copy this folder to %USERPROFILE%\Documents\QSC\Q-Sys Designer\Modules
2. Install the module from Tools > Show Design Resources
3. Add at the top of your Lua script: `require "StringExtras"`

Use these functions as you would any other string function, either string.func(thestring, argument) or thestring:func(argument)

Examples:
```
require "StringExtras"
local x = "  abcd1234  "
print(x:trim():endsWith("1234"))
-- prints true
print(string.endsWith(x, "1234"))
-- prints false because the string was not trimmed
```

```
require "StringExtras"
local x = "Hello, world. my name is Joe."
print(x:contains("world"))
-- prints true
print(x:contains("World"))
-- prints false because the W is capitalized in the search term
```

```
require "StringExtras"
print(string.multiply("*", 10))
-- prints **********
```

```
require "StringExtras"
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

```
require "StringExtras"

local t = {"a", "b", 3}
print(string.join(t, "-"))
-- prints a-b-3
```

```
require "StringExtras"
local s = "/usr/local/bin/program"
print(s:rpartition("/"))
-- prints /usr/local/bin    /   program
```

]]--


-- Trim whitespace from beginning and end of a string
string.trim = function(s)
    ret = string.gsub(s, "^%s*(.-)%s*$", "%1")
    return ret
end

-- Trim whitespace from beginning of a string
string.trimStart = function(s)
    ret = string.gsub(s, "^%s*(.-)$", "%1")
    return ret
end

-- Trim whitespace from end of a string
string.trimEnd = function (s)
    ret = string.gsub(s, "^(.-)%s*$", "%1")
    return ret
end

-- Returns true if the last portion of a string matches a specified value
string.endsWith = function(s, x)
    return (string.sub(s, -(#x)) == x)
end

-- Returns true if the beginning  portion of a string matches a specified value
string.startsWith = function(s, x)
    return (string.sub(s, 1, #x) == x)
end

-- Escape all nonprintable characters (compatible with Lua string literals)
string.escape = function(s)
    local ret = ""
    local curChar, curCharB
    for i=1, #s do
        curChar = s:sub(i,i)
        curCharB = string.byte(curChar)
        if curCharB < 0x20 or curCharB > 0x7e then 
            -- not printable
            ret = ret .. string.format("\\%03d", curCharB)
        else 
            --printable
            ret = ret .. curChar
        end
    end
    return ret
end

-- Escape all nonprintable characters (compatible with every OTHER language... well, except VB)
string.hexescape = function(s)
    local ret = ""
    local curChar, curCharB
    for i=1, #s do
        curChar = s:sub(i,i)
        curCharB = string.byte(curChar)
        if curCharB < 0x20 or curCharB > 0x7e then 
            -- not printable
            ret = ret .. string.format("\\x%02x", curCharB)
        else 
            --printable
            ret = ret .. curChar
        end
    end
    return ret
end

-- Returns true if the string s contains the string x anywhere in it (pattern matching is disabled)
string.contains = function(s, x)
    return s:find(x, 1, true) ~= nil
end

-- Returns the string repeated the specified number of times
string.multiply = function(s, n)
    local ret = ""
    for i=1,tonumber(n) do
        ret = ret .. s
    end
    return ret
end

-- Splits a string with the specified delimiter (if the delimiter is not specified or is an empty string, the string is split at each character)
string.split = function(s, x)
    assert(type(s) == "string", string.format("string expected, got %s",type(s)))
    assert(type(x) == "string" or x == nil, string.format("string expected, got %s",type(x)))

    local ret = {}
    local startAt = 1
    local delimStart = 1
    local delimEnd = 0
    
    if (x ~= "" and x ~= nil) then
        while true do
            delimStart, delimEnd = s:find(x, startAt, true)
            if not delimStart then
                table.insert(ret, s:sub(startAt))
                break
            end
            table.insert(ret, s:sub(startAt, delimStart-1))
            startAt = delimEnd + 1
        end
    else
        for i=1,#s do
            table.insert(ret, s:sub(i,i))
        end
    end
    return ret
end

-- Combines elements of a table into a string, with each element separated by an optional delimiter
string.join = function(t, d)
    assert(type(t) == "table", string.format("table expected, got %s", type(t)))
    assert(type(d) == "string" or d == nil, string.format("string expected, got %s", type(d)))
    if d == nil then d = "" end
    local ret = ""
    if #t == 0 then return ret end
    for _, v in ipairs(t) do
        ret = ret .. tostring(v) .. d
    end
    ret = ret:sub(1, #ret - #d)
    return ret
end

-- Split the string at the first occurance of the specified partition value and return the left part, the delimiter, and the right part
string.partition = function(s, d)
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
    assert(type(d) == "string" or d == nil, string.format("string expected, got %s", type(d)))
    local delimStart, delimEnd
    if d == nil or #d == 0 then
        return s, "", ""
    end
    delimStart, delimEnd = s:find(d)
    if delimStart == nil then
        return s, "", ""
    end
    return s:sub(1, delimStart-1), s:sub(delimStart, delimEnd), s:sub(delimEnd+1)
end

-- Split the string at the last occurance of the specified partition value and return the left part, the delimiter, and the right part
string.rpartition = function(s, d)
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
    assert(type(d) == "string" or d == nil, string.format("string expected, got %s", type(d)))
    local delimStart, delimEnd
    if d == nil or #d == 0 then
        return s, "", ""
    end
    delimStart, delimEnd = s:reverse():find(d)
    if delimStart == nil then
        return s, "", ""
    end
    delimStart = #s -delimStart + 1
    delimEnd = #s - delimEnd + 1
    return s:sub(1, delimStart-1), s:sub(delimStart, delimEnd), s:sub(delimEnd+1)
end
