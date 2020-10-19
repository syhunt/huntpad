--[[
  Huntpad Ruby Utils

  Copyright (c) 2011-2020, Syhunt Informatica
  License: 3-clause BSD license
  See https://github.com/felipedaragon/huntpad/ for details.
  
]]

function forge.securerandom_hex(n) 
 local s = ''
 _script.ruby
 [[
 require 'securerandom'
 s = SecureRandom.hex(n)
 ]]
 return s
end

function forge.securerandom_b64(n) 
 local s = ''
 _script.ruby
 [[
 require 'securerandom'
 s = SecureRandom.base64(n)
 ]]
 return s
end

function forge.securerandom_num(n) 
 local s = ''
 _script.ruby
 [[
 require 'securerandom'
 s = SecureRandom.random_number(n)
 ]]
 return s
end

function forge.securerandom_alphanum(n) 
 local s = ''
 _script.ruby
 [[
 require 'securerandom'
 ALPHANUMERIC = [*'A'..'Z', *'a'..'z', *'0'..'9']
 s = SecureRandom.choose(ALPHANUMERIC, n)
 ]]
 return s
end

function forge.securerandom_uuid()
 local s = ''
 _script.ruby
 [[
 require 'securerandom'
 s = SecureRandom.uuid
 ]]
 return s
end