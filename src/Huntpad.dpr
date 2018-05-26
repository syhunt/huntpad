program Huntpad;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {Hntpad};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(THntpad, Hntpad);
  Application.Run;
end.
