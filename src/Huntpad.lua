package.path = package.path .. ";"..app.dir.."/Lib/lua/?.lua"
--package.path = package.path .. ";"..app.datadir.."/Lib/lua/?.lua"
package.cpath = package.cpath .. ";"..app.dir.."/Lib/clibs/?.dll"
ctk = require "Catalunya"
require "Underscript"
usrun = require "Underscript.Runner"
usrun.options.redirectio = true
require "Forge"
require "luaonlua.preloaded"

local reqbuildermenu = {}
reqbuildermenu.msgnotext = 'No text selected.'
reqbuildermenu.msgnourl = 'Not a valid URL.'
reqbuildermenu.warnedualimit = false

function reqbuildermenu:openinbrowser()
 local text = reqbuilder.edit.gettext()
 if ctk.string.beginswith(string.lower(text),'http') then
  browser.newtab(text)
 else
  app.showmessage(reqbuildermenu.msgnourl)
 end
end

function reqbuildermenu:run(func)
 local sel = reqbuilder.edit.getsel()
 if sel ~= '' then
  local res = func(sel)
  reqbuilder.edit.replacesel(res)
 else
  app.showmessage(reqbuildermenu.msgnotext)
 end
end

function reqbuildermenu:spliturl()
 local text = reqbuilder.edit.gettext()
 if text ~= '' then
  text = ctk.string.replace(text,'?','?'..string.char(10))
  text = ctk.string.replace(text,'&',string.char(10)..'&')
  reqbuilder.edit.settext(text)
 end
end

reqbuilder.edit = activecodeedit
reqbuilder.menu = reqbuildermenu
Sandcat = {}
Sandcat.reqbuildermenu = reqbuildermenu