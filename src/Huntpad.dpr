program Huntpad;

{$I CatCompactBin.inc}

uses
  Vcl.Forms,
  winapi.Windows,
  LAPI in 'lua\LAPI.pas',
  LAPI_CodeEditor in 'lua\LAPI_CodeEditor.pas',
  uMain in 'uMain.pas' {Hntpad};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(THntpad, Hntpad);
  Application.Run;
end.
