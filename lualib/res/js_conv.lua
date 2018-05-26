--[[
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
end