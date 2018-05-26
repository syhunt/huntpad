library Forge;

uses
  Lua, pLuaMin, CatResMin;

{$R *.res}
{$R Code.res}

procedure ExecResource(L: plua_State; const ResName: string);
begin
  plua_dostring(L, GetResourceAsString(ResName, 'LUA'));
end;

function lua_getfile(L: plua_State): integer; cdecl;
var
  s: string;
begin
  try
    s := GetResourceAsString(lua_tostring(L, 2), 'FILES');
  except
  end;
  lua_pushstring(L, s);
  result := 1;
end;

function luaopen_Forge(L: plua_State): integer; cdecl;
begin
  plua_RegisterLuaTable(L, '_forgefiles', @lua_getfile, nil);
  ExecResource(L, 'MAIN'); // Lua functions
  ExecResource(L, 'CHAR'); // JS functions - Char Conversion
  ExecResource(L, 'CONV'); // JS functions - Conversion
  ExecResource(L, 'IP'); // JS functions - IP related
  ExecResource(L, 'UTILS001'); // PHP functions
  ExecResource(L, 'UTILS002'); // Ruby functions
  result := 0;
end;

Exports luaopen_Forge;

begin

end.
