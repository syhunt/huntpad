--[[
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
end