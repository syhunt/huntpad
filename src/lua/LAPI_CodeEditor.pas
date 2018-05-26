unit LAPI_CodeEditor;

{
  Huntpad CodeEdit Lua Library
  Copyright (c) 2011-2018, Syhunt Informatica
  License: 3-clause BSD license
  See https://github.com/felipedaragon/huntpad/ for details.
}

interface

uses Windows, Messages, Lua, LuaObject, SysUtils, Dialogs;

function lua_activecodeedit_find(L: PLua_State): integer; cdecl;
function lua_activecodeedit_replace(L: PLua_State): integer; cdecl;
function lua_activecodeedit_copy(L: PLua_State): integer; cdecl;
function lua_activecodeedit_cut(L: PLua_State): integer; cdecl;
function lua_activecodeedit_paste(L: PLua_State): integer; cdecl;
function lua_activecodeedit_undo(L: PLua_State): integer; cdecl;
function lua_activecodeedit_redo(L: PLua_State): integer; cdecl;
function lua_activecodeedit_getseltext(L: PLua_State): integer; cdecl;
function lua_activecodeedit_replacesel(L: PLua_State): integer; cdecl;
function lua_activecodeedit_inserttext(L: PLua_State): integer; cdecl;
function lua_activecodeedit_setfocus(L: PLua_State): integer; cdecl;
function lua_activecodeedit_gettext(L: PLua_State): integer; cdecl;
function lua_activecodeedit_settext(L: PLua_State): integer; cdecl;
function lua_activecodeedit_openfile(L: PLua_State): integer; cdecl;
function lua_activecodeedit_savetofile(L: PLua_State): integer; cdecl;
function lua_activecodeedit_saveas(L: plua_State): Integer; cdecl;
function lua_activecodeedit_print(L: plua_State): Integer; cdecl;
function lua_activecodeedit_new(L: PLua_State): integer; cdecl;

implementation

uses uMain, pLua, CatStrings;

function lua_activecodeedit_new(L: PLua_State): integer; cdecl;
begin
  if ActiveMemo <> nil then
    ActiveMemo.Clear;
  currentfilename := emptystr;
  hntpad.Caption := cUntitled;
  lasttext := emptystr;
  result := 1;
end;

function lua_activecodeedit_print(L: PLua_State): integer; cdecl;
begin
  //
  result := 1;
end;

function lua_activecodeedit_find(L: PLua_State): integer; cdecl;
begin
  if ActiveMemo <> nil then begin
      Fselpos := 0;
      Hntpad.FindDialog1.execute;
  end;
  result := 1;
end;

function lua_activecodeedit_replace(L: PLua_State): integer; cdecl;
begin
  if ActiveMemo <> nil then
    Hntpad.ReplaceDialog1.Execute;
  result := 1;
end;

function lua_activecodeedit_setfocus(L: PLua_State): integer; cdecl;
begin
  try
    if ActiveMemo <> nil then
      ActiveMemo.SetFocus;
  except
  end;
  result := 1;
end;

function lua_activecodeedit_inserttext(L: PLua_State): integer; cdecl;
begin
  if ActiveMemo <> nil then
    ActiveMemo.SelText := lua_tostring(L, 1);
  result := 1;
end;

function lua_activecodeedit_settext(L: PLua_State): integer; cdecl;
begin
  if ActiveMemo <> nil then
    ActiveMemo.lines.Text := lua_tostring(L, 1);
  result := 1;
end;

function lua_activecodeedit_gettext(L: PLua_State): integer; cdecl;
begin
  if ActiveMemo <> nil then
    lua_pushstring(L, ActiveMemo.lines.Text)
  else
    lua_pushstring(L, emptystr);
  result := 1;
end;

function lua_activecodeedit_getseltext(L: PLua_State): integer; cdecl;
begin
  if ActiveMemo <> nil then
    lua_pushstring(L, ActiveMemo.SelText)
  else
    lua_pushstring(L, emptystr);
  result := 1;
end;

function lua_activecodeedit_replacesel(L: PLua_State): integer; cdecl;
begin
  if ActiveMemo <> nil then
  begin
    if ActiveMemo.SelText <> emptystr then
      ActiveMemo.SelText := lua_tostring(L, 1);
  end;
  result := 1;
end;

function lua_activecodeedit_copy(L: PLua_State): integer; cdecl;
begin
  if ActiveMemo <> nil then
    ActiveMemo.CopyToClipboard;
  result := 1;
end;

function lua_activecodeedit_cut(L: PLua_State): integer; cdecl;
begin
  if ActiveMemo <> nil then
    ActiveMemo.CutToClipboard;
  result := 1;
end;

function lua_activecodeedit_paste(L: PLua_State): integer; cdecl;
begin
  if ActiveMemo <> nil then
    ActiveMemo.PasteFromClipboard;
  result := 1;
end;

function lua_activecodeedit_undo(L: PLua_State): integer; cdecl;
begin
  if ActiveMemo <> nil then
    ActiveMemo.Undo;
  result := 1;
end;

function lua_activecodeedit_redo(L: PLua_State): integer; cdecl;
begin
  if ActiveMemo <> nil then
  begin
    if ActiveMemo.HandleAllocated then
      ActiveMemo.Redo;
      //SendMessage(ActiveMemo.Handle, EM_UNDO, 1, 0);
  end;
  result := 1;
end;

function lua_activecodeedit_openfile(L: plua_State): Integer; cdecl;
var
  sd: topendialog;
  f: string;
begin
  f := emptystr;//lua_tostring(L, 3);
  f := replacestr(f, '\\', '\');
  sd := topendialog.Create(Hntpad);
  sd.InitialDir := emptystr;
  sd.DefaultExt := 'txt';//lua_tostring(L, 2); // eg 'cfg'
  sd.FileName := f;
  sd.Filter :=  cFilter;
  if sd.execute then
    Hntpad.LoadFromFile(sd.filename);
    //lua_pushstring(L, sd.FileName)
  //else
  //  lua_pushstring(L, emptystr);
  sd.free;
  result := 1;
end;

function lua_activecodeedit_saveas(L: plua_State): Integer; cdecl;
begin
   Hntpad.SaveAs(emptystr);
end;

function lua_activecodeedit_savetofile(L: plua_State): Integer; cdecl;
begin
   Hntpad.SaveToFile(currentfilename);
end;

end.
