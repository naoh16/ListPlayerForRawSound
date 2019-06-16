unit ShellIcon;

interface
uses
  Windows, Controls, Graphics, Classes;

const
  SHELLICON_CLOSEDFOLDER = 0;
  SHELLICON_OPENFOLDER = 1;
  SHELLICON_FDD = 2;
  SHELLICON_REMOVABLE = 3;
  SHELLICON_HDD = 4;
  SHELLICON_REMOTE = 5;
  SHELLICON_CDROM = 6;

  SHELLICON_REGKEY = '\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons';
  
type
  TShellIcon = class
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  private
    FImages: TImageList;
    procedure MakeImages;
    procedure AddIcon(RegString: String);overload;
    procedure AddIcon(filename: string; Index: Integer);overload;
  published
    property Images: TImageList read FImages;
  end;

implementation
uses
  ShellAPI, Registry, SysUtils, ImgList, Dialogs;
{ TShellIcon }

procedure TShellIcon.AddIcon(filename: string; Index: Integer);
var
  Icon: TIcon;
  hLargeIcon, hSmallIcon: HICON;
begin
  Icon := TIcon.Create;
//  Icon.Handle := ExtractIcon(hInstance, Pchar(fileName), Index);
  ExtractIconEx(PChar(filename), Index, hLargeIcon, hSmallIcon, 1);
  Icon.Handle := hSmallIcon;
  Images.AddIcon(Icon);
  Icon.Free;
end;

procedure TShellIcon.AddIcon(RegString: String);
begin
  With TStringList.Create do
  try
    CommaText := RegString;
    if Count < 2 then AddIcon(Strings[0], 0)
    else AddIcon(Strings[0], StrToInt(Strings[1]));
  finally
    Free;
  end;
end;

constructor TShellIcon.Create(AOwner: TComponent);
begin
//  inherited Create(AOwner);
  FImages := TImageList.Create(AOwner);
  MakeImages;
end;

destructor TShellIcon.Destroy;
begin
  FImages.Free;
  inherited;
end;

procedure TShellIcon.MakeImages;
var
  Reg: TRegistry;
begin
//  if FileExists('%WINDIR%\System32\Shell32.dll') then
//  begin
    AddIcon('Shell32.dll,3'); // 閉じたフォルダ
    AddIcon('Shell32.dll,4'); // 開いたフォルダ
//      AddIcon('Shell32.dll,5'); // 5 inch FD
    AddIcon('Shell32.dll,6'); // 3.5 inch FD
    AddIcon('Shell32.dll,7'); // リムーバブルディスク
    AddIcon('Shell32.dll,8'); // HDD
    AddIcon('Shell32.dll,9'); // ネットワーク
//      AddIcon('Shell32.dll,10'); // ネットワーク 切断
    AddIcon('Shell32.dll,11'); // CD
//      AddIcon('Shell32.dll,12'); // RAM ディスク
//  end;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.KeyExists(SHELLICON_REGKEY) and
        Reg.OpenKeyReadOnly(SHELLICON_REGKEY) then
    try
      if (Reg.ReadString('3') <> '') then
      begin
        AddIcon(Reg.ReadString('3')); // 閉じたフォルダ
        AddIcon(Reg.ReadString('4')); // 開いたフォルダ
  //      AddIcon(Reg.ReadString('5')); // 5 inch FD
        AddIcon(Reg.ReadString('6')); // 3.5 inch FD
        AddIcon(Reg.ReadString('7')); // リムーバブルディスク
        AddIcon(Reg.ReadString('8')); // HDD
        AddIcon(Reg.ReadString('9')); // ネットワーク
  //      AddIcon(Reg.ReadString('10')); // ネットワーク 切断
        AddIcon(Reg.ReadString('11')); // CD
  //      AddIcon(Reg.ReadString('12')); // RAM ディスク
      end;
      Reg.CloseKey;
    except
      ShowMessage('レジストリの読みとりエラー');
      raise;
    end;
  finally
    Reg.Free;
  end;
end;

end.
