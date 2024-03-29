        ��  ��                  Z  (   ��
 C H A R         0           --[[
  Huntpad Char Conversion functions

  Copyright (c) 2011-2018, Syhunt Informatica
  License: 3-clause BSD license
  See https://github.com/felipedaragon/huntpad/ for details.
  
]]

function forge.strtocharseq(str,func) _script.jscript
 [[ 
    var dec;
    var charArray = new Array;
    var res = '';
    for ( var c = 0 ; c < str.length ; c++ ) {
      dec = str.charCodeAt( c );
      charArray.push( dec );
    }
    switch ( func )
    {
      case "mysqlChar":
        res = 'CHAR(' + charArray.join(', ') + ')';
        break;
      case "mssqlChar":
        res = 'CHAR(' + charArray.join(') + CHAR(') + ')';
        break;
      case "phpChar":
        res = 'chr(' + charArray.join(').chr(') + ')';
        break;
      case "oracleChr":
        res = 'CHR(' + charArray.join(') || CHR(') + ')';
        break;
      case "stringFromCharCode":
        res = 'String.fromCharCode(' + charArray.join(',') + ')';
        break;
      case "htmlChar":
        res = '&#' + charArray.join(';&#') + ';';
        break;
    }
    str = res;
 ]]
 return str
end

function forge.strtodechtml(s)
 return forge.strtocharseq(s,'htmlChar')
end

function forge.str_escape_js(s)
 return forge.strtocharseq(s,'stringFromCharCode')
end

function forge.str_escape_mysql(s)
 return forge.strtocharseq(s,'mysqlChar')
end

function forge.str_escape_mssql(s)
 return forge.strtocharseq(s,'mssqlChar')
end

function forge.str_escape_php(s)
 return forge.strtocharseq(s,'phpChar')
end

function forge.str_escape_oracle(s)
 return forge.strtocharseq(s,'oracleChr')
end  �  (   ��
 C O N V         0           --[[
  Huntpad Conversion functions
 
  JJEncode code by Yosuke HASEGAWA
  Integer to integer representation function provided by Reiners
  Other functions based on examples from security-related web sites and forums

  Copyright (c) 2011-2018, Syhunt Informatica
  License: 3-clause BSD license
  See https://github.com/felipedaragon/huntpad/ for details.
  
]]

-- Hasegawa Encoders
function forge.jsencode_hasegawa(s)
 _script.jscript(forge.files.hasegawa..' s = getnonalphanum_js(s)')
 return s
end
function forge.jsencode_jj(s)
 _script.jscript(forge.files.hasegawa..' s = jjencode("$",s)')
 return s
end

-- Misc Hack
function forge.dechtmltostr(s) _script.jscript
[[
 matched = 0;
 s = s.replace(/&#[0-9]+;?/g,function(c) {
        c = c.replace(/[^0-9]/g,'');
        matched = 1;
        return String.fromCharCode(parseInt(c,10));
    }); 
]]
 return s
end

function forge.hexhtmltostr(s) _script.jscript
 [[
    matched = 0;
    s = s.replace(/(?:&#|\\)x?[a-fA-F0-9]{2,5};?/g,function(c) {
        c = c.replace(/[^0-9a-fA-F]/g,'');
        matched = 1;
        return String.fromCharCode(parseInt(c,16));
    });
    if(!matched && /^[xa-f0-9]$/i.test(s)) {
        s = parseInt(s, 16);
    }
 ]]
 return s
end

function forge.octaltostr(s) _script.jscript
 [[
    function octtostr(txt) {
    matched = 0;
    txt = txt.replace(/\\[0-9]{1,3}/g,function(c) {
        c = c.replace(/[^0-9]/g,'');
        matched = 1;
        return String.fromCharCode(parseInt(c,8));
    });
    if(!matched) {
        return parseInt(txt, 8);
    }
    return txt;
    }
    s = octtostr(s);
 ]]
 return s
end

function forge.hash_fletcher(s) _script.jscript
 [[
 var fletcher = function(a,b,c,d,e){for(b=c=d=0;e=a.charCodeAt(d++);c=(c+b)%255)b=(b+e)%255;return(c<<8)|b}
 s = fletcher(s);
 ]]
 return s
end

-- Separate chars with...
function forge.sepchars(s,sep) _script.jscript
 [[
 sep=eval("'"+sep+"'");
 s=s.split('').join(sep);
 ]]
 return s
end

-- Standard JS string escape
function forge.strtojsstr(s) _script.jscript
 [[
 s=s.replace(/[\s"\\]/g,function(c){
        if(c === ' ') {
          return c;
        } else if(c === '\\') {
            return '\\';
        } else {
            return'\\u'+/....$/.exec('0000'+c.charCodeAt().toString(16));
        }
    });
 ]]
 return s
end

function forge.strtocharcode(s) _script.jscript
 [[
    var splitChar = "";
    var joinChar = ',';
    s = s.split(splitChar);
    for(var i=0;i<s.length;i++) {
        s[i] = s[i].charCodeAt();
    }
    s = s.join(joinChar);
 ]]
 return s
end

function forge.charcodetostr(s) _script.jscript
 [[
 var codes = s.split(/[^0-9]/);
 var unchanged = s;
    s = '';
    var len = codes.length;
    for(var i=0;i<len;i++) {
        if(/[^d]/.test(codes[i])) {            
            if (codes[i] > 0xFFFF) {  
                codes[i] -= 0x10000;  
                s += String.fromCharCode(0xD800 + (codes[i] >> 10), 0xDC00 +  
(codes[i] & 0x3FF));  
            }  else {  
                s += String.fromCharCode(codes[i]);  
            }            
        } else {
            s = unchanged;
            break;
        }
    }
 ]]
 return s
end

-- percent obfuscation
function forge.mysql_percobfusc(s) _script.jscript
 [[ s = s.replace(new RegExp("(.{"+(+1)+"})","gi"),'$1%').replace(/%$/,''); ]]
 return s
end

function forge.mysql_concat(s) _script.jscript
 [[    s = s.split("");
        for(var i=0;i<s.length;i++) {
            s[i] = "'" + s[i] + "'";
        }
       s = "concat("+s.join(",")+")";
  ]]
 return s
end

-- concat with quotes
function forge.sql_concat(s) _script.jscript
[[
       s = s.split("");
        for(var i=0;i<s.length;i++) {
         s[i] = "'"+s[i]+"'";
        }
       s = s.join(" ");
]]
 return s
end

-- Binary To Decimal
function forge.bintodec(s) _script.jscript
[[
 s = parseInt(s, 2);
]]
 return s
end

-- Integer to integer representation
-- Credits: Reiners
function forge.mysql_intrep(s) _script.jscript
[[
 num = function(n) {
    return numbers[n][Math.floor(Math.random()*numbers[n].length)];
}

var numbers = [
        [     "pi()-pi()",
            "!pi()",
            "false",
            "(current_time^curtime())",
            "@@new",
            "log(-cos(pi()))"
        ],
        [    "true",
            "cos(!pi())",
            "!!!pi()",
            "sign(rand())"
        ],
        [    "!!!pi()--true"
        ],
        [    "floor(pi())",
            "coercibility(user())"
        ],
        [    "ceil(pi())",
            "coercibility(now())"
        ],
        [    "floor(@@version)"
        ],
        [    "ceil(@@version)"
        ],
        [    "ceil(pi()--pi())"
        ],
        [    "floor(pi()--@@version)",
            "bit_length(ceil(pi()))"
        ],
        [    "floor(pi()*pi())"
        ],
        [    "ceil(pi()*pi())"
        ]
    ];

s = s.replace(/\d+/g, function(n){
            var r = '';
            for (var i = 0; i < n.length-1; i++){
                if (n.length-i == 2){
            r += '--'+num(10);
            if (n.slice(-2) == "10")
            {    return r.slice(2); }
        } else{
            r += '--pow('+num(10)+','+num(n.length-1-i)+')'; }
        r += '*('+num(n.charAt(i))+')';
            }
            return (r + '--'+num(n.charAt(n.length-1))).slice(2);
    });
    s = s.replace(/--/g, '+');
]]
 return s
end   �  $   ��
 I P         0           --[[
  Huntpad IP related functions
  
  Functions based on examples from security-related web sites and forums

  Copyright (c) 2011-2018, Syhunt Informatica
  License: 3-clause BSD license
  See https://github.com/felipedaragon/huntpad/ for details.
  
]]

function forge.iptodword(ip) _script.jscript
[[
  var level = '0';
  n=ip.split('.'); 
  for(i=0;i<4;i++) {
    n[i]=parseInt(n[i]);
  } 
  var dword=(n[0]*16777216)+(n[1]*65536)+(n[2]*256)+n[3]+(parseInt(level)*4294967296);
  ip = dword;
]]
 return ip
end

function forge.iptohex(ip) _script.jscript
[[
function numlet(num){ 
  if(num==10){return 'a';} 
  if(num==11){return 'b';}
  if(num==12){return 'c';} 
  if(num==13){return 'd';} 
  if(num==14){return 'e';}
  if(num==15){return 'f';} 
  return num;
} 

function iptohex(s){
  n=s.split('.'); 
  for(i=0;i<4;i++) { 
    n[i]=parseInt(n[i]);
    if(n[i]>255||isNaN(n[i])){
      return s; // invalid IP
    }
    var two=numlet(n[i]%16); 
    var one=numlet(Math.floor(n[i]/16));
    n[i]='0x'+one+two;
  } 
  var hexip=n.join('.');
  if(hexip.substring(hexip.length-1,hexip.length)=='.') {
    hexip=hexip.substring(0,hexip.length-1);
  } 
  return hexip;
}
 ip = iptohex(ip);
]]
 return ip
end

function forge.iptooctal(ip) _script.jscript
[[
function iptooct(s){
  n=s.split('.'); 
  for(i=0;i<4;i++) { 
    n[i]=parseInt(n[i]);
    if(n[i]>255||isNaN(n[i])){
      return s; // invalid IP
    }
    var one=Math.floor(n[i]/64); 
    var t=n[i]%64; 
    var two=Math.floor(t/8);
    var three=n[i]%8; 
    n[i]='0'+one+two+three; 
  } 
  var octip=n.join('.');
  if(octip.substring(octip.length-1,octip.length)=='.') {
    octip=octip.substring(0,octip.length-1);
  } 
  return octip;
}
 ip = iptooct(ip);
]]
 return ip
end

function forge.strtohexhtml(s) _script.jscript
[[
function convertToHexHTML(num) { 
  var hexhtml = ''; 
  for (i=0;i<num.length;i++) {
    if (num.charCodeAt(i).toString(16).toUpperCase().length < 2) {
      hexhtml += "&#x0" + num.charCodeAt(i).toString(16).toUpperCase() + ";"; 
    } else {
      hexhtml += "&#x" + num.charCodeAt(i).toString(16).toUpperCase() + ";"; 
    }
  }
  return hexhtml; 
} 
 s = convertToHexHTML(s)
]]
 return s
end   �  (   ��
 M A I N         0           --[[
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
end�
  0   ��
 U T I L S 0 0 1         0           --[[
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
end�  0   ��
 U T I L S 0 0 2         0           --[[
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
end S  0   ��
 U T I L S 0 0 3         0           --[[
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
end   0   ��
 H A S E G A W A         0           function jjencode(gv,text) {
    var r="";
    var n;
    var t;
    var b=[ "___", "__$", "_$_", "_$$", "$__", "$_$", "$$_", "$$$", "$___", "$__$", "$_$_", "$_$$", "$$__", "$$_$", "$$$_", "$$$$", ];
    var s = "";
    for( var i = 0; i < text.length; i++ ){
        n = text.charCodeAt( i );
        if( n == 0x22 || n == 0x5c ){
            s += "\\\\\\" + text.charAt( i ).toString(16);
        }else if( (0x21 <= n && n <= 0x2f) || (0x3A <= n && n <= 0x40) || ( 0x5b <= n && n <= 0x60 ) || ( 0x7b <= n && n <= 0x7f ) ){
        //}else if( (0x20 <= n && n <= 0x2f) || (0x3A <= n == 0x40) || ( 0x5b <= n && n <= 0x60 ) || ( 0x7b <= n && n <= 0x7f ) ){
            s += text.charAt( i );
        }else if( (0x30 <= n && n <= 0x39 ) || (0x61 <= n && n <= 0x66 ) ){
            if( s ) r += "\"" + s +"\"+";
            r += gv + "." + b[ n < 0x40 ? n - 0x30 : n - 0x57 ] + "+";
            s="";
        }else if( n == 0x6c ){ // 'l'
            if( s ) r += "\"" + s + "\"+";
            r += "(![]+\"\")[" + gv + "._$_]+";
            s = "";
        }else if( n == 0x6f ){ // 'o'
            if( s ) r += "\"" + s + "\"+";
            r += gv + "._$+";
            s = "";
        }else if( n == 0x74 ){ // 'u'
            if( s ) r += "\"" + s + "\"+";
            r += gv + ".__+";
            s = "";
        }else if( n == 0x75 ){ // 'u'
            if( s ) r += "\"" + s + "\"+";
            r += gv + "._+";
            s = "";
        }else if( n < 128 ){
            if( s ) r += "\"" + s;
            else r += "\"";
            r += "\\\\\"+" + n.toString( 8 ).replace( /[0-7]/g, function(c){ return gv + "."+b[ c ]+"+" } );
            s = "";
        }else{
            if( s ) r += "\"" + s;
            else r += "\"";
            r += "\\\\\"+" + gv + "._+" + n.toString(16).replace( /[0-9a-f]/gi, function(c){ return gv + "."+b[parseInt(c,16)]+"+"} );
            s = "";
        }
    }
    if( s ) r += "\"" + s + "\"+";

    r = 
    gv + "=~[];" + 
    gv + "={___:++" + gv +",$$$$:(![]+\"\")["+gv+"],__$:++"+gv+",$_$_:(![]+\"\")["+gv+"],_$_:++"+
    gv+",$_$$:({}+\"\")["+gv+"],$$_$:("+gv+"["+gv+"]+\"\")["+gv+"],_$$:++"+gv+",$$$_:(!\"\"+\"\")["+
    gv+"],$__:++"+gv+",$_$:++"+gv+",$$__:({}+\"\")["+gv+"],$$_:++"+gv+",$$$:++"+gv+",$___:++"+gv+",$__$:++"+gv+"};"+
    gv+".$_="+
    "("+gv+".$_="+gv+"+\"\")["+gv+".$_$]+"+
    "("+gv+"._$="+gv+".$_["+gv+".__$])+"+
    "("+gv+".$$=("+gv+".$+\"\")["+gv+".__$])+"+
    "((!"+gv+")+\"\")["+gv+"._$$]+"+
    "("+gv+".__="+gv+".$_["+gv+".$$_])+"+
    "("+gv+".$=(!\"\"+\"\")["+gv+".__$])+"+
    "("+gv+"._=(!\"\"+\"\")["+gv+"._$_])+"+
    gv+".$_["+gv+".$_$]+"+
    gv+".__+"+
    gv+"._$+"+
    gv+".$;"+
    gv+".$$="+
    gv+".$+"+
    "(!\"\"+\"\")["+gv+"._$$]+"+
    gv+".__+"+
    gv+"._+"+
    gv+".$+"+
    gv+".$$;"+
    gv+".$=("+gv+".___)["+gv+".$_]["+gv+".$_];"+
    gv+".$("+gv+".$("+gv+".$$+\"\\\"\"+" + r + "\"\\\"\")())();";

    return r;
};

function getnonalphanum_js(s) {
getRandom = function(minVal, maxVal) {    
     var randVal = minVal+(Math.random()*(maxVal-minVal));
    return Math.round(randVal);    
}

var symbols = ('������������������������������������������������������������$_').split('');
                var func = '';
                var symbol = '$';
                var symbol1 = "$";    
                var symbol2 = "$$";    
                var symbol3 = "$$$";
                var symbol4 = "$$$$";
                var symbol5 = "$$$$$";
                var symbol6 = "$$$$$$";
                
                for(var i=0;i<6;i++) {
                    if (symbols.length > 0) {
                        var pos = getRandom(0, symbols.length - 1);
                        var symbol = symbols[pos];
                        symbols.splice(pos, 1);
                    } else {
                        symbol += symbol;
                    }
                    switch(i) {
                        case 0:
                            symbol1 = symbol;
                        break;
                        case 1:
                            symbol2 = symbol;
                        break;
                        case 2:
                            symbol3 = symbol;
                        break;
                        case 3:
                            symbol4 = symbol;
                        break;
                        case 4:
                            symbol5 = symbol;
                        break;
                        case 5:
                            symbol6 = symbol;
                        break;                                                                                                                        
                    }
                }
                                
                var nums = [symbol1+"-"+symbol1,symbol1+"-"+symbol2,symbol2,symbol1,symbol2+"+"+symbol2,symbol2+"+"+symbol1,symbol1+"+"+symbol1,symbol3,symbol4,symbol1+"*"+symbol1];                    
                func += symbol2+"=-~-~[],"+symbol1+"=-~"+symbol2+","+symbol4+"="+symbol2+"<<"+symbol2+","+symbol3+"="+symbol4+"+~[];";
                func += symbol5+"=("+nums[0]+")["+symbol6+"=(''+{})["+nums[5]+"]+(''+{})["+nums[1]+"]+([]."+symbol1+"+'')["+nums[1]+"]+(!!''+'')["+nums[3]+"]+({}+'')["+nums[6]+"]+(!''+'')["+nums[1]+"]+(!''+'')["+nums[2]+"]+(''+{})["+nums[5]+"]+({}+'')["+nums[6]+"]+(''+{})["+nums[1]+"]+(!''+'')["+nums[1]+"]]["+symbol6+"]";                
                
                s = s.replace(/.+/,function(c) {
                    var output = [];
                    c = c + '';
                    for (var j = 0; j < c.length; j++) {
                        var cc = c.charCodeAt(j).toString(8).split('');
                        for (var i = 0; i < cc.length; i++) {
                            cc[i] = "(" + nums[cc[i]] + ")";
                        }
                        output.push('\'\\\\\'+' + cc.join('+'));
                    }                                    
                    return "+"+symbol5+"((!''+'')["+nums[1]+"]+(!''+'')["+nums[3]+"]+(!''+'')["+nums[0]+"]+(!''+'')["+nums[2]+"]+((!''+''))["+nums[1]+"]+([].$+'')["+nums[1]+"]"+"+\'\\''"+"+"+'\'\'+'+output.join('+')+"+\'\\'')()";
                });
                return func+';'+''+symbol5+'('+s.replace(/^\+/,'')+')()';

} 