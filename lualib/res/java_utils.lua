--[[
  Huntpad Java Utils

  Copyright (c) 2011-2020, Syhunt Informatica
  License: 3-clause BSD license
  See https://github.com/felipedaragon/huntpad/ for details.
  
]]

function forge.securerandom_uuid_java() 
 local s = ''
 _scriptq.java
[[
  UUID random = UUID.randomUUID();
  s = random.toString();
]]
 return s
end