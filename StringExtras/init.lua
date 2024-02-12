--[[
String Extras
Adds additional functions to strings

Added functions: 
* trim: Trim whitespace from beginning and end of a string
* ltrim: Trim whitespace from beginning of a string
* rtrim: Trim whitespace from end of a string
* endsWith: Returns true if the last portion of a string matches the specified value
* startsWith: Returns true if the beginning  portion of a string matches the specified value
* escape: Escape all nonprintable characters as \ddd (compatible with Lua string literals)
* hexescape: Escape all nonprintable characters as \xdd (compatible with every OTHER language... well, except VB)
* contains: Returns true if the string contains the specified value anywhere in it (case sensitive, pattern matching is disabled)

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

]]--


-- Trim whitespace from beginning and end of a string
string.trim = function(s)
    ret = string.gsub(s, "^%s*(.-)%s*$", "%1")
    return ret
end

-- Trim whitespace from beginning of a string
string.ltrim = function(s)
    ret = string.gsub(s, "^%s*(.-)$", "%1")
    return ret
end

-- Trim whitespace from end of a string
string.rtrim = function (s)
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
