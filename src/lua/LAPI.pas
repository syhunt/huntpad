unit LAPI;

{
  Huntpad Lua API
  Copyright (c) 2011-2018, Syhunt Informatica
  License: 3-clause BSD license
  See https://github.com/felipedaragon/huntpad/ for details.
}

interface

uses SysUtils, Lua, Dialogs, ShellAPI;

procedure RegisterApp(L: plua_State);
procedure RegisterBrowser(L: plua_State);
procedure RegisterConsole(L: plua_State);
procedure RegisterRequestBuilder(L: plua_State);
procedure RegisterActiveCodeEdit(L: plua_State);
procedure RegisterPrefs(L: plua_State);
function app_showinputdialog(L: plua_State): Integer; cdecl;
function app_showmessage(L: plua_State): Integer; cdecl;
function app_getcurrentfilename(L: plua_State): Integer; cdecl;
function app_exit(L: plua_State): Integer; cdecl;

implementation

uses uMain, pLua, pLuaTable, LAPI_CodeEditor;

function app_showmessage(L: plua_State): Integer; cdecl;
begin
  ShowMessage(lua_tostring(L, 1));
  result := 1;
end;

function app_showabout(L: plua_State): Integer; cdecl;
begin
  ShowMessage(cAboutHuntPad);
  result := 1;
end;

function app_exit(L: plua_State): Integer; cdecl;
begin
  Hntpad.close;
  result := 1;
end;

function app_getcurrentfilename(L: plua_State): Integer; cdecl;
begin
  lua_pushstring(L, editmain.filename);
  result := 1;
end;

function app_showinputdialog(L: plua_State): Integer; cdecl;
var
  s, caption: string;
begin
  caption := lua_tostring(L, 3);
  if caption = emptystr then
    caption := 'Huntpad';
  s := inputbox(caption, lua_tostring(L, 1), lua_tostring(L, 2));
  lua_pushstring(L, s);
  result := 1;
end;

function browser_newtab(L: plua_State): Integer; cdecl;
begin
  ShellExecute(0, 'open', pWideChar(lua_tostring(L, 1)), '', '', 1);
  result := 1;
end;

function browser_dostring(L: plua_State): Integer; cdecl;
begin
  fLuaWrap.ExecuteCmd(lua_tostring(L, 1));
  result := 1;
end;

function lua_sandcatsettings_get(L: plua_State): integer; cdecl;
begin
  if lua_isnone(L, 2) then
    plua_pushvariant(L, Prefs.getvalue(lua_tostring(L, 1)))
  else
    plua_pushvariant(L, Prefs.getvalue(lua_tostring(L, 1),
      plua_tovariant(L, 2)));
  result := 1;
end;

function lua_console_writeln(L: plua_State): integer; cdecl;
begin
  Hntpad.AddOutput(plua_AnyToString(L, 1));
  result := 1;
end;

function lua_console_write(L: plua_State): integer; cdecl;
begin
  if editoutput.Visible = false then
    editoutput.Visible := true;
  editoutput.Lines.text := editoutput.Lines.text+plua_AnyToString(L, 1);
  result := 1;
end;

function lua_scriptlogerror(L: plua_State): integer; cdecl;
var msg:string;
begin
  msg := '('+inttostr(lua_tointeger(L, 1)+1)+'): '+lua_tostring(L, 2);
  Hntpad.AddOutput(msg);
  result := 1;
end;

function app_clearconsole(L: plua_State): integer; cdecl;
begin
  editoutput.Lines.Clear;
  result := 1;
end;

function app_runtiscript(L: plua_State): integer; cdecl;
var
  str: widestring;
  res: string;
begin
  str := lua_tostring(L, 1);
  if Tbmain <> nil then
  begin
    res := Tbmain.eval(str);
    lua_pushstring(L, res);
  end;
  result := 1;
end;

procedure RegisterRequestBuilder(L: plua_State);
const
  sandcatbuilder_table: array [1 .. 1] of luaL_reg = (
  (name: nil; func: nil)
  );
begin
  lual_register(L, 'reqbuilder', @sandcatbuilder_table);
  // sets reqbuilder.request
  //plua_SetFieldValue(L,'request', @lua_builder_getrequestoption, @lua_builder_setrequestoption);
end;

procedure RegisterBrowser(L: plua_State);
const
  sandcatbrowser_table: array [1 .. 3] of luaL_reg = (
  (name: 'dostring'; func: browser_dostring),
  (name: 'newtab'; func: browser_newtab),
  (name: nil; func: nil)
  );
begin
  lual_register(L, 'browser', @sandcatbrowser_table);
end;

procedure RegisterConsole(L: plua_State);
const
  console_table: array [1 .. 4] of luaL_reg = (
  (name: 'clear'; func: app_clearconsole),
  (name: 'writeln'; func: lua_console_writeln),
  (name: 'write'; func: lua_console_write),
  (name: nil; func: nil)
  );
const
  uconsole_table: array [1 .. 4] of luaL_reg = (
  (name: 'writeln'; func: lua_console_writeln),
  (name: 'write'; func: lua_console_write),
  (name: 'errorln'; func: lua_scriptlogerror),
  (name: nil; func: nil)
  );
begin
  // register console library
  lual_register(L, PAnsiChar('console'), @console_table);
  // register uconsole library for io redirect from Underscript.dll
  lual_register(L, PAnsiChar('uconsole'), @uconsole_table);
end;

procedure RegisterApp(L: plua_State);
const
  app_table: array [1 .. 7] of luaL_reg = (
  (name: 'exit'; func: app_exit),
  (name: 'getfilename'; func: app_getcurrentfilename),
  (name: 'runtiscript'; func: app_runtiscript),
  (name: 'showabout'; func: app_showabout),
  (name: 'showinputdialog'; func: app_showinputdialog),
  (name: 'showmessage'; func: app_showmessage),
  (name: nil; func: nil)
  );
begin
  lua_register(L, 'print', @lua_console_writeln);
  // register app library
  lual_register(L, PAnsiChar('app'), @app_table);
  plua_setfieldvalue(L,'dir',extractfilepath(paramstr(0)));
  //plua_setfieldvalue(L,'datadir',GetAppDataDir);
end;

procedure RegisterActiveCodeEdit(L: plua_State);
const
  sandcatcodeedit_table: array [1 .. 19] of luaL_reg = (
  (name: 'new'; func: lua_activecodeedit_new),
  (name: 'find'; func: lua_activecodeedit_find),
  (name: 'replace'; func: lua_activecodeedit_replace),
  (name: 'getfilename'; func: lua_activecodeedit_getfilename),
  (name: 'gettext'; func: lua_activecodeedit_gettext),
  (name: 'settext'; func: lua_activecodeedit_settext),
  (name: 'getsel'; func: lua_activecodeedit_getseltext),
  (name: 'insert'; func: lua_activecodeedit_inserttext),
  (name: 'replacesel'; func: lua_activecodeedit_replacesel),
  (name: 'copy'; func: lua_activecodeedit_copy),
  (name: 'cut'; func: lua_activecodeedit_cut),
  (name: 'paste'; func: lua_activecodeedit_paste),
  (name: 'openfile'; func: lua_activecodeedit_openfile),
  (name: 'save'; func: lua_activecodeedit_savetofile),
  (name: 'saveas'; func: lua_activecodeedit_saveas),
  (name: 'undo'; func: lua_activecodeedit_undo),
  (name: 'redo'; func: lua_activecodeedit_redo),
  (name: 'setfocus'; func: lua_activecodeedit_setfocus),
  (name: nil; func: nil)
  );
begin
  lual_register(L, 'activecodeedit', @sandcatcodeedit_table);
end;

procedure RegisterPrefs(L: plua_State);
const
  sandcatsettings_table: array [1 .. 2] of luaL_reg = (
  (name: 'get'; func: lua_sandcatsettings_get),
  (name: nil; func: nil));
begin
  lual_register(L, 'prefs', @sandcatsettings_table);
end;

end.
