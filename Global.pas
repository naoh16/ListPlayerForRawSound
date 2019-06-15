unit Global;

interface
uses
  IniFiles, Classes;

const
  AppMajorVersion = 0;
  AppMinorVersion = 3;
  AppRevision = 0;

type
  TGlobal = class
  private
    FExePath: String;
    FExeName: String;
    FAppVersion: String;
    FExternalApps: array[0..3] of TStringList;
    FExternalAppCount: Integer;
    FExcludeExtension: TStringList;
    FIni: TCustomIniFile;
    function GetExternalAppData(i: Integer; Name: string): String;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadSetting;
    property ExternalAppData[i: Integer;Name:string]: String read GetExternalAppData;
  published
    property ExePath: String read FExePath;
    property ExeName: String read FExeName;
    property AppVersion: String read FAppVersion;
    property ExternalAppCount: Integer read FExternalAppCount;
    property ExcludeExtension: TStringList read FExcludeExtension;
    property Ini: TCustomIniFile read FIni;
  end;

var
  AppGlobal: TGlobal;

implementation
uses
  SysUtils, Forms, Dialogs;

{ TGlobal }

constructor TGlobal.Create;
begin
  FExePath := ExtractFilePath(Application.ExeName);
  FExeName := ChangeFileExt(ExtractFileName(Application.ExeName), '');
  FAppVersion := Format('ver.%d.%d.%d', [AppMajorVersion, AppMinorVersion, AppRevision]);

  FIni := TMemIniFile.Create(FExePath + FExeName + '.ini');

  LoadSetting;
end;

destructor TGlobal.Destroy;
var
  i: integer;
begin
  FIni.UpdateFile;

  for i:= 0 to FExternalAppCount - 1 do
    FExternalApps[i].Free;

  FExcludeExtension.Free;
  FIni.Free;

  inherited;
end;

function TGlobal.GetExternalAppData(i: Integer; Name: string): String;
begin
  if i > FExternalAppCount then Result := ''
  else Result := FExternalApps[i].Values[Name];
end;

procedure TGlobal.LoadSetting;
var
  i: integer;
begin
  // 外部アプリ関連
  i := 0;
  while FIni.SectionExists('ExternalApps' + IntToStr(i)) do
  begin
    if Assigned(FExternalApps[i]) then FExternalApps[i].Clear
    else FExternalApps[i] := TStringList.Create;
    FIni.ReadSectionValues('ExternalApps' + IntToStr(i), FExternalApps[i]);
    i := i + 1;
    if (i >= 4) then Break;
  end;
  FExternalAppCount := i;

  // 除外拡張子関連
  if Assigned(FExcludeExtension) then FExcludeExtension.Clear
  else FExcludeExtension := TStringList.Create;
  FExcludeExtension.CommaText := FIni.ReadString('Filter', 'ExcludeExtension', '.txt,.exe');
end;

initialization
	AppGlobal := TGlobal.Create;
finalization
	AppGlobal.Free;

end.
