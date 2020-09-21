program Huntpad;

uses
  Vcl.Forms,
  winapi.Windows,
  LAPI in 'lua\LAPI.pas',
  LAPI_CodeEditor in 'lua\LAPI_CodeEditor.pas',
  uMain in 'uMain.pas' {Hntpad};

{$R *.res}

 // Reduces executable size
{$IFDEF RELEASE}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$ENDIF}
{$O+} {$SetPEFlags IMAGE_FILE_RELOCS_STRIPPED}
 // Reduces exe size end

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(THntpad, Hntpad);
  Application.Run;
end.
