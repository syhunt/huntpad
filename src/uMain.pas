unit uMain;

{
  Syhunt Huntpad
  Copyright (c) 2018, Syhunt Informatica

  License: 3-clause BSD license
  See https://github.com/felipedaragon/huntpad/ for details.

  This software uses the Catarinka components. Catarinka is distributed under
  the same license as Huntpad. Copyright (c) 2003-2018, Felipe Daragon
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CatSciterAx, CatSynEdit, SynEdit,
  LuaWrapper, CatPrefs, CatStrings,
  ShellAPI, CatHighlighters;

type
  THntpad = class(TForm)
    FindDialog1: TFindDialog;
    ReplaceDialog1: TReplaceDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure ReplaceDialog1Replace(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  protected
    procedure WMDropFiles(var Msg: TMessage); message WM_DROPFILES;
  private
    { Private declarations }
    procedure Load;
    procedure OpenFile(fn: string);
    procedure ScriptExceptionHandler(Title: string; line: Integer; Msg: string;
      var handled: boolean);
    procedure StdErr(ASender: TObject; const Msg: WideString);
    procedure StdOut(ASender: TObject; const Msg: WideString);
    procedure Save;
  public
    { Public declarations }
    procedure LoadFromFile(fn: string);
    procedure SaveToFile(fn: string);
    procedure SaveAs(fn: string);
  end;

var
  Hntpad: THntpad;
  Tbmain: TSciter;
  editmain: TCatSynEdit;
  fLuaWrap: TLua;
  activememo: TCatSynEdit;
  Highlighters: TCatHighlighters;
  progdir, pluginsdir: string;
  currentfilename: string;
  lasttext: string;
  Fselpos: Integer;
  Prefs: TCatPreferences;
  vConfigFile: string = 'Sandcat.json';

const
  cCaption = 'Huntpad';
  cUntitled = 'Untitled - '+cCaption;
  cAboutHuntPad = 'Syhunt Huntpad' +crlf+crlf+
    'Version 1.0.2' +crlf+crlf+
    'Copyright (c) 2018 Syhunt Application Security Company';
  cHTML = 'HTML';
  cWinName = ' - Huntpad';
  cFilter = 'Text files (*.txt)|*.txt|' +
    'HTML files (*.html, *.htm)|*.html;*.htm|' + 'CSS files (*.css)|*.css|' +
    'JavaScript files (*.js, *.tis)|*.js;*.tis|' + 'JSON files (*.json)|*.json|' +
    'Java files (*.java)|*.java|' +
    'PHP files (*.php*)|*.php*|' + 'Ruby files (*.rb)|*.rb|' +
    'Pascal files (*.pas, *.dpr)|*.pas;*.dpr|' + 'Perl files (*.pl)|*.pl|' +
    'Python files (*.py)|*.py|' + 'SQL files (*.sql)|*.sql|' +
    'VBScript files (*.vbs)|*.vbs|' + 'XML files (*.xml)|*.xml|' +
    'All files (*.*)|*.*';

implementation

uses CatRes, CatZIP, CatFiles, CatUI, CatJSON, LAPI, CatCLUtils;

{$R *.dfm}
{$R Pad.res}

function GetAppDataDir: string;
begin
  // if IsSandcatPortable then
  // result := extractfilepath(paramstr(0))
  // else
  result := GetSpecialFolderPath(CSIDL_LOCAL_APPDATA, true) +
    '\Syhunt\Sandcat\';
end;

const // Sandcat sub directories
  SCDIR_LOGS = 1;
  SCDIR_HEADERS = 2;
  SCDIR_TEMP = 3;
  SCDIR_PREVIEW = 4;
  SCDIR_CONFIG = 5;
  SCDIR_PLUGINS = 6;
  SCDIR_CACHE = 7;
  SCDIR_TASKS = 8;
  SCDIR_CONFIGSITE = 9;

const
  SCO_FORM_STATE = 'huntpad.form.state';
  SCO_FORM_TOP = 'huntpad.form.top';
  SCO_FORM_LEFT = 'huntpad.form.left';
  SCO_FORM_HEIGHT = 'huntpad.form.height';
  SCO_FORM_WIDTH = 'huntpad.form.width';

function GetSandcatDir(dir: Integer; Create: boolean = false): string;
var
  s, progdir: string;
begin
  progdir := extractfilepath(paramstr(0));
  case dir of
    SCDIR_CACHE:
      s := GetAppDataDir + 'Cache\';
    SCDIR_PLUGINS:
      s := progdir + 'Packs\Extensions\';
    SCDIR_CONFIG:
      s := GetAppDataDir + 'Config\';
    SCDIR_CONFIGSITE:
      s := GetAppDataDir + 'Config\Site\';
    SCDIR_LOGS:
      s := GetAppDataDir + 'Logs\';
    SCDIR_HEADERS:
      s := GetAppDataDir + 'Cache\Headers\';
    SCDIR_PREVIEW:
      s := GetAppDataDir + 'Temp\Preview\';
    SCDIR_TEMP:
      s := GetAppDataDir + 'Temp\';
    SCDIR_TASKS:
      s := GetAppDataDir + 'Temp\Tasks\';
  end;
  if Create then
    forcedir(s);
  result := s;
end;

procedure ConfigSynEdit(s: TCatSynEdit);
begin
  s.Gutter.ShowLineNumbers := true;
  s.Gutter.Font.Color := $00808080;
  s.Gutter.Font.Size := 8;
  s.Gutter.Color := $00F0F0F0;
  s.Gutter.BorderColor := $00EEEEEE;
  s.Gutter.UseFontStyle := true;
  s.options := s.options - [eoShowScrollHint];
  // Makes the horizontal bar behave normally
  s.options := s.options - [eoScrollPastEOL];
  s.RightEdge := 0;
end;

procedure THntpad.LoadFromFile(fn: string);
begin
  if fileexists(fn) = false then
    exit;
  editmain.Highlighter := Highlighters.GetByFileExtension(extractfileext(fn));
  editmain.Lines.LoadFromFile(fn);
  lasttext := editmain.Lines.Text;
  currentfilename := fn;
  caption := extractfilename(fn) + cWinName;
end;

procedure THntpad.OpenFile(fn: string);
begin
  LoadFromFile(fn);
end;

procedure THntpad.ReplaceDialog1Replace(Sender: TObject);
var
  SelPos, SPos, SLen, TextLength: Integer;
  SearchString: string;

begin
  with TReplaceDialog(Sender) do
  begin
    TextLength := Length(activememo.Lines.Text);

    SPos := activememo.SelStart;
    SLen := activememo.SelLength;

    SearchString := Copy(activememo.Lines.Text, SPos + SLen + 1,
      TextLength - SLen + 1);

    SelPos := Pos(FindText, SearchString);
    if SelPos > 0 then
    begin
      activememo.SelStart := (SelPos - 1) + (SPos + SLen);
      activememo.SelLength := Length(FindText);
      // remove this in the OnFind procedure:
      activememo.SelText := ReplaceText;
    end
    else
      MessageDlg('Could not find "' + FindText + '" in Huntpad.', mtError,
        [mbOk], 0);
  end;

end;

procedure THntpad.SaveAs(fn: string);
var
  sd: tsavedialog;
begin
  sd := tsavedialog.Create(Hntpad);
  sd.InitialDir := emptystr;
  sd.DefaultExt := 'txt';
  sd.FileName := fn;
  sd.options := sd.options + [ofoverwriteprompt];
  sd.Filter := cFilter;
  if sd.execute then
  begin
    editmain.Lines.SaveToFile(sd.FileName);
    caption := extractfilename(sd.FileName) + cWinName;
    currentfilename := sd.FileName;
  end;
  sd.free;
end;

procedure THntpad.SaveToFile(fn: string);
var
  f: string;
begin
  f := currentfilename;
  f := replacestr(f, '\\', '\');
  if currentfilename = emptystr then
    SaveAs(emptystr)
  else
  begin
    editmain.Lines.SaveToFile(currentfilename);
    caption := extractfilename(fn) + cWinName;
  end;
end;

procedure THntpad.WMDropFiles(var Msg: TMessage);
var
  FileName: array [0 .. 255] of WideChar;
  lastfilename: string;
  dropcount, i: Integer;
  files: TStringList;
begin
  dropcount := DragQueryFile(TWMDropFiles(Msg).Drop, $FFFFFFFF, nil, 0);
  if dropcount >= 1 then
  begin
    files := TStringList.Create;
    for i := 0 to dropcount - 1 do
    begin
      DragQueryFile(TWMDropFiles(Msg).Drop, i, FileName, 255);
      files.add(FileName);
      lastfilename := FileName;
    end;
    OpenFile(lastfilename);
    files.free;
  end;
  DragFinish(TWMDropFiles(Msg).Drop);
  Msg.result := 0;
end;

procedure THntpad.ScriptExceptionHandler(Title: string; line: Integer;
  Msg: string; var handled: boolean);
begin
  showmessage(inttostr(line) + format('%s: %s', [Title, Msg]));
  handled := true;
end;

procedure THntpad.StdErr(ASender: TObject; const Msg: WideString);
begin
  // if pos('assuming namespace declaration', string(msg)) = 0 then
  // Debug(msg, 'TIS Warning');
end;

procedure THntpad.StdOut(ASender: TObject; const Msg: WideString);
var
  d: TCatJSON;
  cmd: string;
begin
  if beginswith(Msg, '{') = false then
    exit;
  d := TCatJSON.Create;
  d.Text := Msg;
  cmd := d['cmd'];
  if cmd = 'run' then
  begin
    // showmessage(d['code']);
    fLuaWrap.ExecuteCmd(d['code']);
  end;
  d.free;
end;

procedure THntpad.FindDialog1Find(Sender: TObject);
var
  s: String;
  startpos: Integer;
begin
  // caption := finddialog1.FindText;
  with TFindDialog(Sender) do
  begin
     //If the stored position is 0 this cannot be a find next.
    If Fselpos = 0 Then
      options := options - [frFindNext];
    options := options - [frWholeWord];

    // Figure out where to start the search and get the corresponding
    // text from the memo.
    If frFindNext In options Then
    Begin
      //This is a find next, start after the end of the last found word.
      startpos := Fselpos + Length(FindText);
      s := Copy(activememo.Lines.Text, startpos, MaxInt);
    End
    Else
    Begin
      // This is a find first, start at the, well, start.
      s := activememo.Lines.Text;
      startpos := 1;
    End;
    // Perform a global case-sensitive search for FindText in S
    Fselpos := Pos(FindText, s);
    if Fselpos > 0 then
    begin
      // Found something, correct position for the location of the start of search.
      Fselpos := Fselpos + startpos - 1;
      activememo.SelStart := Fselpos - 1;
      activememo.SelLength := Length(FindText);
    end
    else
    begin
      // No joy, show a message. }
      If frFindNext In options Then
        s := Concat('There are no further occurences of "', FindText,
          '" in Huntpad.')
      Else
        s := Concat('Could not find "', FindText, '" in Huntpad.');
      MessageDlg(s, mtError, [mbOk], 0);
    end;
  end;
  // caption := finddialog1.FindText;
  Hntpad.BringToFront;

end;

procedure THntpad.Load;
var
  State: Integer;
begin
  if fileexists(Prefs.FileName) then
    Prefs.LoadFromFile(Prefs.FileName);
  State := Prefs.Current.getvalue(SCO_FORM_STATE, Ord(wsNormal)); // int
  Hntpad.Top := Prefs.Current.getvalue(SCO_FORM_TOP, Hntpad.Top); // int
  Hntpad.Left := Prefs.Current.getvalue(SCO_FORM_LEFT, Hntpad.Left); // int
  Hntpad.Height := Prefs.Current.getvalue(SCO_FORM_HEIGHT, Hntpad.Height);
  // int
  Hntpad.Width := Prefs.Current.getvalue(SCO_FORM_WIDTH, Hntpad.Width); // int
  if State = Ord(wsMinimized) then
  begin
    Hntpad.Visible := true;
    Application.Minimize;
  end
  else
  begin
    if State = Ord(wsMaximized) then
      SendMessage(Hntpad.Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0)
    else
      Hntpad.WindowState := TWindowState(State);
  end;
end;

procedure THntpad.Save;
var
  Pl: TWindowPlacement;
  R: TRect;
  State: Integer;
begin
  Pl.Length := SizeOf(TWindowPlacement);
  GetWindowPlacement(Hntpad.Handle, @Pl);
  R := Pl.rcNormalPosition;
  if IsIconic(Application.Handle) then
    State := Ord(wsMinimized)
  else
    State := Ord(Hntpad.WindowState);
  Prefs.setvalue(SCO_FORM_STATE, State); // int
  Prefs.setvalue(SCO_FORM_HEIGHT, R.Bottom - R.Top); // int
  Prefs.setvalue(SCO_FORM_WIDTH, R.Right - R.Left); // int
  Prefs.setvalue(SCO_FORM_TOP, R.Top); // int
  Prefs.setvalue(SCO_FORM_LEFT, R.Left); // int
  Prefs.SaveToFile(Prefs.FileName);
end;

procedure THntpad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Save;
end;

procedure THntpad.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  bs : Integer; msg:string;
begin
  CanClose := true;
  if currentfilename <> emptystr then
   msg := 'Save changes to "'+currentfilename+'"?'
  else
   msg := 'Save changes?';

  if lasttext <> editmain.Lines.Text then begin
    bs := messagedlg(msg,mtCustom,
                              [mbYes,mbNo,mbCancel], 0);
    case bs of
     mrYes: SaveToFile(currentfilename);
     mrNo: ;
     mrCancel: CanClose := false;
    end;
  end;
end;

procedure THntpad.FormCreate(Sender: TObject);
var
  qcode: string;
begin
  caption := cUntitled;
  progdir := extractfilepath(paramstr(0));
  pluginsdir := progdir + '\Packs\Extensions\';
  Prefs := TCatPreferences.Create;
  Prefs.FileName := (GetSandcatDir(SCDIR_CONFIG, true) + vConfigFile);
  Prefs.registerdefault('quickinject.shell.php.url',
    'http://somehost/shell.txt');
  Prefs.registerdefault('quickinject.shell.php.out', 'shell.php');
  Tbmain := TSciter.Create(self);
  Tbmain.Parent := self;
  Tbmain.Align := altop;
  Tbmain.Height := 35;
  Tbmain.OnonStdErr := StdErr;
  Tbmain.OnonStdOut := StdOut;
  editmain := TCatSynEdit.Create(self);
  editmain.Parent := self;
  editmain.Align := alClient;
  ConfigSynEdit(editmain);
  activememo := editmain;
  Highlighters := TCatHighlighters.Create(self);
  // lua engine creation
  fLuaWrap := TLua.Create(nil);
  fLuaWrap.UseDebug := false;
  fLuaWrap.OnException := ScriptExceptionHandler;
  RegisterApp(fLuaWrap.LuaState);
  RegisterBrowser(fLuaWrap.LuaState);
  RegisterRequestBuilder(fLuaWrap.LuaState);
  RegisterActiveCodeEdit(fLuaWrap.LuaState);
  RegisterPrefs(fLuaWrap.LuaState);
  fLuaWrap.ExecuteCmd(GetResourceAsString('HUNTPAD', 'Lua'));
  qcode := GetTextFileFromZIP(pluginsdir + 'Huntpad.scx',
    'quickinject/quickinject.lua');
  fLuaWrap.ExecuteCmd(qcode);
  DragAcceptFiles(Handle, true);
  if trim(GetCmdLine) <> emptystr then
    OpenFile(trim(GetCmdLine));
  Load;
end;

procedure THntpad.FormShow(Sender: TObject);
begin
  Tbmain.LoadHtml(GetResourceAsString('HUNTPAD_TB', cHTML), pluginsdir);
end;

end.
