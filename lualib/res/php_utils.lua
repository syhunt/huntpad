--[[
  Huntpad PHP Utils

  Copyright (c) 2011-2021, Syhunt Informatica
  License: 3-clause BSD license
  See https://github.com/felipedaragon/huntpad/ for details.
  
]]

function forge.crypt_apr1_md5(s) _scriptq.php
 [[
// APR1-MD5 encryption method (windows compatible)
function crypt_apr1_md5($plainpasswd)
{
$salt = substr(str_shuffle("abcdefghijklmnopqrstuvwxyz0123456789"), 0, 8);
$len = strlen($plainpasswd);
$text = $plainpasswd.'$apr1$'.$salt;
$bin = pack("H32", md5($plainpasswd.$salt.$plainpasswd));
for($i = $len; $i > 0; $i -= 16) { $text .= substr($bin, 0, min(16, $i)); }
for($i = $len; $i > 0; $i >>= 1) { $text .= ($i & 1) ? chr(0) : $plainpasswd{0}; }
$bin = pack("H32", md5($text));
for($i = 0; $i < 1000; $i++)
{
$new = ($i & 1) ? $plainpasswd : $bin;
if ($i % 3) $new .= $salt;
if ($i % 7) $new .= $plainpasswd;
$new .= ($i & 1) ? $bin : $plainpasswd;
$bin = pack("H32", md5($new));
}
for ($i = 0; $i < 5; $i++)
{
$k = $i + 6;
$j = $i + 12;
if ($j == 16) $j = 5;
$tmp = $bin[$i].$bin[$k].$bin[$j].$tmp;
}
$tmp = chr(0).chr(0).$bin[11].$tmp;
$tmp = strtr(strrev(substr(base64_encode($tmp), 2)),
"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
"./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz");
 
return "$"."apr1"."$".$salt."$".$tmp;
}
 
$s = crypt_apr1_md5($s);
]]
 return s
end

function forge.crypt_default(s) _scriptq.php
 [[$s = crypt($s);]]
 return s
end

function forge.crypt(s,salt) _scriptq.php
 [[$s = crypt($s,$salt);]]
 return s
end

function forge.myip(s) _scriptq.php
 [[
 $hosts = gethostbynamel('');
 $s = $hosts[0];
 ]]
 return s
end

function forge.shuffle(s) _scriptq.php
 [[$s = str_shuffle($s);]]
 return s
end

function forge.soundex(s) _scriptq.php
 [[$s = soundex($s);]]
 return s
end

function forge.uuencode(s) _scriptq.php
 [[$s = convert_uuencode($s);]]
 return s
end

function forge.uudecode(s) _scriptq.php
 [[$s = convert_uudecode($s);]]
 return s
end

function forge.crc32(s) _scriptq.php
 [[$s = crc32($s);]]
 return s
end

-- CRC32 - MySQL (>=4.1)
function forge.crc32_mysql(s) _scriptq.php
 [[
 $s = crc32($s)+4294967296;
 ]]
 return s
end

function forge.crc16(s) _scriptq.php
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

function forge.hash(algo,s) _scriptq.php
 [[$s = hash($algo,$s);]]
 return s
end

function forge.addslashes(s) _scriptq.php
 [[$s = addslashes($s);]]
 return s
end