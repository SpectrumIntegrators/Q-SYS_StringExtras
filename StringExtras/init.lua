--[[
String Extras
Adds additional functions to strings

2024-02-13
Jonathan Dean (jonathand@spectrumintegrators.com)

See readme for usage information

]]--


-- Trim whitespace from beginning and end of a string
string.trim = function(s)
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
    ret = string.gsub(s, "^%s*(.-)%s*$", "%1")
    return ret
end

-- Trim whitespace from beginning of a string
string.trimStart = function(s)
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
    ret = string.gsub(s, "^%s*(.-)$", "%1")
    return ret
end

-- Trim whitespace from end of a string
string.trimEnd = function (s)
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
    ret = string.gsub(s, "^(.-)%s*$", "%1")
    return ret
end

-- Returns true if the last portion of a string matches a specified value
string.endsWith = function(s, x)
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
    assert(type(x) == "string", string.format("string expected, got %s", type(x)))
    return (string.sub(s, -(#x)) == x)
end

-- Returns true if the beginning  portion of a string matches a specified value
string.startsWith = function(s, x)
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
    assert(type(x) == "string", string.format("string expected, got %s", type(x)))
    return (string.sub(s, 1, #x) == x)
end

-- Escape all nonprintable characters (compatible with Lua string literals)
string.escape = function(s)
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
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
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
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
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
    assert(type(x) == "string", string.format("string expected, got %s", type(x)))
    return s:find(x, 1, true) ~= nil
end

-- Returns the string repeated the specified number of times
string.multiply = function(s, n)
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
    assert(type(n) ~= number, "number expected, got %s", type(n))
    local ret = ""
    for i=1,n do
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

string.padLeft = function(s, n, d)
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
    assert(type(n) == "number" or n == nil, string.format("number expected, got %s", type(n)))
    assert(type(d) == "string" or d == nil, string.format("string expected, got %s", type(d)))
    if n == nil then n = 0 end
    if d == nil then d = " " end
    if type(n) ~= "number" then n = tonumber(n) end
    if type(d) ~= "string" then d = tostring(d) end

    local pad  = ""
    for i=1,n do
        pad = pad .. d
    end
    return pad .. s
end

string.padRight = function(s, n, d)
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
    assert(type(n) == "number" or n == nil, string.format("number expected, got %s", type(n)))
    assert(type(d) == "string" or d == nil, string.format("string expected, got %s", type(d)))
    if n == nil then n = 0 end
    if d == nil then d = " " end
    if type(n) ~= "number" then n = tonumber(n) end
    if type(d) ~= "string" then d = tostring(d) end

    local pad = ""
    for i=1,n do
        pad = pad .. d
    end
    return s .. pad
end

-- Converts all characters to two-digit hex pairs
string.toHexString = function(s, d)
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
    if d == nil then d = " " end
    assert(type(d)=="string", string.format("Delimiter must be a string, not %s", type(d)))
    return s:gsub(".", function(x) return string.format("%02X ", string.byte(x)) end):gsub("^(.-)%s*$", "%1"):gsub(" ", d)
end

-- Converts all two-digit hex pairs to the corresponding byte
string.fromHexString = function(s)
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
    return s:gsub("%X*(%x%x)%X*", function(x) return string.char(tonumber(x, 16)) end)
end