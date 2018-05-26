--[[
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
end