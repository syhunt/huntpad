--[[
  Huntpad PHP Utils

  Copyright (c) 2011-2018, Syhunt Informatica
  License: 3-clause BSD license
  See https://github.com/felipedaragon/huntpad/ for details.
  
]]

function forge.crypt(s) _script.php
 [[$s = crypt($s);]]
 return s
end

function forge.myip(s)
 _script.php([[
 $hosts = gethostbynamel('');
 $s = $hosts[0];
 ]]
 )
 return s
end

function forge.shuffle(s) _script.php
 [[$s = str_shuffle($s);]]
 return s
end

function forge.soundex(s) _script.php
 [[$s = soundex($s);]]
 return s
end

function forge.uuencode(s) _script.php
 [[$s = convert_uuencode($s);]]
 return s
end

function forge.uudecode(s) _script.php
 [[$s = convert_uudecode($s);]]
 return s
end

function forge.crc32(s) _script.php
 [[$s = crc32($s);]]
 return s
end

-- CRC32 - MySQL (>=4.1)
function forge.crc32_mysql(s) _script.php
 [[
 $s = crc32($s)+4294967296;
 ]]
 return s
end

function forge.crc16(s) _script.php
 [[
   $crc = 0xFFFF; 
   for ($x = 0; $x < strlen ($s); $x++) { 
     $crc = $crc ^ ord($s[$x]); 
     for ($y = 0; $y < 8; $y++) { 
       if (($crc & 0x0001) == 0x0001) { 
         $crc = (($crc >> 1) ^ 0xA001); 
       } else { $crc = $crc >> 1; } 
     } 
   } 
   $s = $crc; 
 ]]
 return s
end

function forge.hash(algo,s) _script.php
 [[$s = hash($algo,$s);]]
 return s
end

function forge.addslashes(s) _script.php
 [[$s = addslashes($s);]]
 return s
end