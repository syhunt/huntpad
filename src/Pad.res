        ��  ��                  S  ,   ��
 H U N T P A D       0 	        package.path = package.path .. ";"..app.dir.."/Lib/lua/?.lua"
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
Sandcat.reqbuildermenu = reqbuildermenu !  4   ��
 H U N T P A D _ T B         0 	        <html>

<head>
<include src="Resources.pak#head.html"/>
<link rel="stylesheet" type="text/css" href="Resources.pak#tab_navbar.css">
<link rel="stylesheet" type="text/css" href="Resources.pak#toolbar.css">
<style>
#mdcrack, #mdoffline, #mdonline {display:none;}
#logpoison, #fiprefs, #fiprefsep {display:none;}
#fiupsep, #fiupua, #fiupost {display:none;}
#runjsbtn, #runjssep, #runjslp, #runjslpsep {display:none;}
</style>
<script type="text/tiscript">
$(#ignorecache).onClick = function() {
 this.checked = !this.checked;
 if (this.checked) {
  Sandcat.RunLua("reqbuilder.request.ignorecache = true");
 } else {
  Sandcat.RunLua("reqbuilder.request.ignorecache = false");
 }
}
</script>

</head>

<body engine="reqbuilder.toolbar">
  
<div id="toolbar" class="toolbar" style="vertical-align:middle;">
    <div .button style="foreground-image: url(Resources.pak#16\icon_page.png)" onclick="reqbuilder.edit.new()" titleid="for_new"/>
    <div .button style="foreground-image: url(Resources.pak#16\icon_open.png)" onclick="reqbuilder.edit.openfile()" titleid="for_openfile"/>
    <div .button style="foreground-image: @ICON_SAVE" onclick="reqbuilder.edit.save()" titleid="for_savetofile"/>
	<div .sepv />
	<div .button style="foreground-image: url(Resources.pak#16\icon_opennewtab.png)" onclick="Sandcat.reqbuildermenu:openinbrowser()" titleid="for_openbrw"/>
	<div .button style="foreground-image: url(Resources.pak#16\icon_filesplit.png)" onclick="Sandcat.reqbuildermenu:spliturl()" titleid="for_spliturl"/>
	<div .button style="foreground-image: @ICON_CUT" onclick="reqbuilder.edit.cut()" titleid="for_cut"/>
	<div .button style="foreground-image: @ICON_COPY" onclick="reqbuilder.edit.copy()" titleid="for_copy"/>
	<div .button style="foreground-image: @ICON_PASTE" onclick="reqbuilder.edit.paste()" titleid="for_paste"/>
	<div .sepv />
	<div .button style="foreground-image: @ICON_UNDO" onclick="reqbuilder.edit.undo()" titleid="for_undo"/>
	<div .button style="foreground-image: @ICON_REDO" onclick="reqbuilder.edit.redo()" titleid="for_redo"/>
    <include src="Huntpad.scx#quickinject/toolbar.html"/>
    <div .sepv />
	<include src="HuntpadPro.scx#quickinject/toolbar.html"/>
	<div #optionsmenu class="button" style="behavior: ~ popup-menu;foreground-image: url(Resources.pak#16\icon_menu.png)" titleid="for_optionsmenu">6
   <menu.popup id="optionsmenu">
    <li style="foreground-image: url(Resources.pak#16\icon_page.png)" onclick="reqbuilder.edit.new()">New</li>
    <li style="foreground-image: url(Resources.pak#16\icon_open.png)" onclick="reqbuilder.edit.openfile()">Open...</li>
    <li style="foreground-image: @ICON_SAVE" onclick="reqbuilder.edit.save()">Save</li>
    <li style="foreground-image: @ICON_SAVE" onclick="reqbuilder.edit.saveas()">Save As...</li>
    <hr/>
    <li onclick="reqbuilder.edit.find()">Find...</li>
    <li onclick="reqbuilder.edit.replace()">Replace...</li>
    <hr/>
    <li onclick="app.showabout()">About Huntpad</li>
    <hr/>
    <li onclick="app.exit()">Exit</li>
   </menu>
	</div>
</div>

<popup id="for_spliturl">Split URL</popup>
<popup id="for_view-reqdata">View POST Data</popup>
<popup id="for_addtosel">Add To Selection</popup>
<popup id="for_subtosel">Subtract From Selection</popup>
<popup id="for_loadreq">Load Request</popup>
<popup id="for_openbrw">Load As URL in Default Browser</popup>
<popup id="for_clear">Clear</popup>
<popup id="for_undo">Undo</popup>
<popup id="for_redo">Redo</popup>
<popup id="for_copy">Copy</popup>
<popup id="for_paste">Paste</popup>
<popup id="for_cut">Cut</popup>
<popup id="for_new">New...</popup>
<popup id="for_openfile">Open...</popup>
<popup id="for_savetofile">Save</popup>
<popup id="for_scancode">Scan File for Vulnerabilities</popup>
<popup id="for_optionsmenu">Menu</popup>


</body>
</html>   