--[[
String Extras
Adds additional functions to strings

2024-02-13
Jonathan Dean (jonathand@spectrumintegrators.com)

See readme for usage information

]]--


ESCAPE_CHARS = {
    ["a"] = "\a",
    ["b"] = "\b",
    ["f"] = "\f",
    ["n"] = "\n",
    ["r"] = "\r",
    ["t"] = "\t",
    ["v"] = "\v",
    ["\\"] = "\\",
    ["\""] = "\"",
    ["\'"] = "\'",
    ["\n"] = "",
    ["\r"] = ""
}
UNESCAPE_CHARS = {
    ["\a"] = "\\a",
    ["\b"] = "\\b",
    ["\f"] = "\\f",
    ["\n"] = "\\n",
    ["\r"] = "\\r",
    ["\t"] = "\\t",
    ["\v"] = "\\v",
}

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
        print(curCharB)
        if curCharB >= 0x20 and curCharB <= 0x7e then 
            --printable, just add it
            ret = ret .. curChar
            goto escape_nextloop
        end

        -- not printable
        -- first look for common escape sequences
        for esc_c, unesc_c in pairs(UNESCAPE_CHARS) do
            if curChar == esc_c then
                ret = ret .. unesc_c
                goto escape_nextloop
            end
        end

        -- if we didn't find one, we end up here and just convert it to a plain ol decimal escape sequence
        ret = ret .. string.format("\\%03d", curCharB)

        ::escape_nextloop::
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
    local ret = ""
    -- get rid of all whitespace and line breaks
    s = s:gsub(" ", ""):gsub("\n", ""):gsub("\r", ""):gsub("\t", "")
    -- if the string is an odd number of characters, put a zero at the start
    if #s % 2 ~= 0 then
        s = "0" .. s
    end
    for i=1,#s, 2 do
        local hexpair = s:sub(i, i+1)
        local hexval = tonumber(hexpair, 16)
        assert(hexval ~= nil, string.format("invalid hex value: %s", hexpair))
        ret = ret .. string.char(hexval)
    end
    return ret
end

-- Unescape escaped characters
string.unescape = function(s)
    assert(type(s) == "string", string.format("string expected, got %s", type(s)))
    local ret = ""
    local i = 1
    while i <= #s do
        local c = s:sub(i,i)
        
        if c ~= "\\" then
            -- just a regular character, so keep it
            ret = ret .. c
            goto unescape_nextloop
        else
            assert(i + 1 <= #s, "unfinished escape sequence at end of string")
            i=i+1 -- skip the backslash
            c = s:sub(i,i)
            for ec, ev in pairs(escapechars) do
                -- look for common single-character sequences
                if c == ec then
                    ret = ret .. ev
                    goto unescape_nextloop
                end
            end

            -- check for \nnn decimal character string
            local chardecimalstr = ""
            local chardecimal = nil
            local escapegood = false
            local j = 0
            for j=i,i+2 do
                if j > #s then
                    if escapegood then
                        -- we got at least a partial three-digit number
                        break
                    else
                        -- we're past the end of the string but didn't find any numbers
                        err("unfinished escape sequence at end of string")
                    end
                end
                if s:byte(j) >= 0x30 and s:byte(j) <= 0x39 then
                    escapegood = true
                    i = j -- step over this character
                    chardecimalstr = chardecimalstr .. s:sub(j,j)
                else
                    -- not a number, so we're done now
                    break
                end
            end
            if escapegood then

                chardecimal = tonumber(chardecimalstr)
                assert(chardecimal < 256, string.format("invalid decimal escape sequence, must be between 0 and 255 but we found %d", chardecimal))
                ret = ret .. string.char(chardecimal)
                goto unescape_nextloop
            end

            if c == "u" then
                -- look for unicode escape sequence
                assert(s:sub(i+1,i+1) == "{", "invalid unicode escape sequence, expecting {")
                local bracketend = s:find("}", i+2)
                assert(bracketend ~= nil, "invalid unicode escape sequence, expecting }")

                local codepointstr = s:sub(i+2, bracketend-1)
                assert(codepointstr ~= "", "invalid unicode escape sequence, hexadecimal value expected")
                assert(#codepointstr <= 8, "UTF-8 sequence too long, must be 8 or fewer hex characters")
                local codepoint = tonumber(codepointstr, 16)
                assert(codepoint ~= nil, "invalid unicode escape sequence, hexadecimal value expected")
                assert(codepoint <= 0x7FFFFFFF, "UTF-8 value too large, must be less than 0x80000000")
                i = bracketend -- move the pointer to the end of this escape sequence
                -- ripped this unicode logic from stackoverflow, haven't messed with optimizing it
                -- https://stackoverflow.com/questions/7983574/how-to-write-a-unicode-symbol-in-lua
                if codepoint < 128 then 
                    ret = ret .. string.char(codepoint)
                elseif codepoint < 2048 then 
                    local byte2 = (128 + (codepoint % 64))
                    local byte1 = (192 + math.floor(codepoint / 64))
                    ret = ret .. string.char(byte1, byte2)
                elseif codepoint < 65536 then 
                    local byte3 = (128 + (codepoint % 64))
                    codepoint = math.floor(codepoint / 64)
                    local byte2 = (128 + (codepoint % 64))
                    local byte1 = (224 + math.floor(codepoint / 64))
                    ret = ret .. string.char(byte1, byte2, byte3)
                elseif codepoint < 1114112 then
                    local byte4 = (128 + (codepoint % 64))
                    codepoint = math.floor(codepoint / 64)
                    local byte3 = (128 + (codepoint % 64))
                    codepoint = math.floor(codepoint / 64)
                    local byte2 = (128 + (codepoint % 64))
                    local byte1 = (240 + math.floor(codepoint / 64))
                    ret = ret .. string.char(byte1, byte2, byte3, byte4)
                else
                    error(string.format("invalid unicode codepoint %x", codepoint))
                end
                goto unescape_nextloop
            end
            
            if c == "z" then
                -- look for whitespace zap
                while s:sub(i,i) == " " do
                    -- skip all spaces
                    i = i + 1
                end
                goto unescape_nextloop
            end

            -- fail if we didn't find a good escape sequence
            error(string.format("invalid escape character: \\%s", c))
        end

        ::unescape_nextloop::
        print(i)
        i = i + 1
    end
    return ret
end