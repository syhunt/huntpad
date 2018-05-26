--[[
  Huntpad Forge library
  
  Functions based on examples from Lua lists

  Copyright (c) 2011-2018, Syhunt Informatica
  License: 3-clause BSD license
  See https://github.com/felipedaragon/huntpad/ for details.
  
]]

forge = {}
forge.files = _forgefiles

function forge.getfibseq(x)
 function fib(n)
  return n<2 and n or fib(n-1)+fib(n-2)
 end
 local s = fib(1)
 for n=1,x do s = s..','..fib(n) end
 return s
end

function forge.rotn(s,n)
  local byte_a, byte_A = string.byte('a'), string.byte('A')
  s = string.gsub(s, "(%a)", function (c)
        c = string.byte(c)
        local offset = (c >= 97) and byte_a or byte_A
        c = math.mod(c+n-offset, 26)
        return string.char(c + offset)
      end)
  return s
end

function forge.stripspaces(s)
 return string.gsub(s,"%s+", "")
end

function forge.randomstr(Length, CharSet)
 local Chars = {}
 for Loop = 0, 255 do
    Chars[Loop+1] = string.char(Loop)
 end
 local String = table.concat(Chars) 
 
 local Built = {['.'] = Chars}

 local AddLookup = function(CharSet)
   local Substitute = string.gsub(String, '[^'..CharSet..']', '')
   local Lookup = {}
   for Loop = 1, string.len(Substitute) do
       Lookup[Loop] = string.sub(Substitute, Loop, Loop)
   end
   Built[CharSet] = Lookup

   return Lookup
 end

   local CharSet = CharSet or '.'

   if CharSet == '' then
      return ''
   else
      local Result = {}
      local Lookup = Built[CharSet] or AddLookup(CharSet)
      local Range = table.getn(Lookup)

      for Loop = 1,Length do
         Result[Loop] = Lookup[math.random(1, Range)]
      end

      return table.concat(Result)
   end
end

function forge.rot13(s)
  return forge.rotn(s,13)
end

-- hex encoding
function forge.strtohex(str,spacer)
  local s = (
    string.gsub(str,"(.)",
      function (c)
        return string.format("%02X%s",string.byte(c), spacer or "")
      end)
  )
 if spacer ~= '' then
  s = string.gsub(s, "[^\128-\191][\128-\191]*$", "")
 end
 return s
end

function forge.str_escape_css(s)
 if s ~= '' then
  s = '\\'..forge.strtohex(s,'\\')
 end
 return s
end

-- String to Binary
function forge.strtobin( str,sep ) 
 function numtobin( num ) --Number to Binary
        local ret = ""
        while( num > 0 ) do
                ret = tostring( num % 2 ) .. ret
                num = math.floor( num / 2 )
        end
        return ret
 end
        local ret = ""
        if sep == nil then
         sep = ""
        end
        for b in str:gmatch( "%S+" ) do
                for c in b:gmatch( "." ) do
                        ret = ret .. "0" .. numtobin( c:byte() )
                        ret = ret .. sep
                end
        end
        return ret
end

-- titlecase
local function tchelper(first, rest)
  return first:upper()..rest:lower()
end
function forge.titlecase(s)
 return s:gsub("(%a)([%w_']*)", tchelper)
end