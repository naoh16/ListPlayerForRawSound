unit fSetting;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

const
  DefaultExcludeExtension = '.txt,.exe,.dll,.com,.log';

type
  TSettingDlg = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    MoveDirectoryOpenDlg: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox2: TGroupBox;
    txtExcludeExtension: TEdit;
    Label1: TLabel;
    btnDefExcludeExtension: TButton;
    txtAppName: TLabeledEdit;
    txtAppPath: TLabeledEdit;
    txtAppArgv: TLabeledEdit;
    btnSetAppPath: TButton;
    AppPathOpenDlg: TOpenDialog;
    lvApps: TListView;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    rbFileDeleteD: TRadioButton;
    rbFileDeleteM: TRadioButton;
    rbFileDeleteNG: TRadioButton;
    cbDeleteNoDialog: TCheckBox;
    txtFileMoveDirectory: TEdit;
    btnSetMoveDirectory: TButton;
    chbNoTreeIcon: TCheckBox;
    chbUseTimer: TCheckBox;
    chbAutoWavHeader: TCheckBox;
    chbRawOnlyMode: TCheckBox;
    procedure btnSetMoveDirectoryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure gbDeleteFileClick(Sender: TObject);
    procedure btnSetAppPathClick(Sender: TObject);
    procedure txtAppChange(Sender: TObject);
    procedure lvAppsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnDefExcludeExtensionClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure chbRawOnlyModeClick(Sender: TObject);
  private
    { Private êÈåæ }
    FbAppChange: Boolean;
    FnFileDeleteRadioIndex: Integer;
  public
    { Public êÈåæ }
  end;

var
  SettingDlg: TSettingDlg;

implementation
uses
  Global, IniFiles;
{$R *.dfm}

procedure TSettingDlg.FormCreate(Sender: TObject);
var
  i: Integer;
  item: TListItem;
begin
  With AppGlobal.Ini do
  begin
    chbNoTreeIcon.Checked := ReadBool('Setting', 'NoTreeIcon', chbNoTreeIcon.Checked);
    chbUseTimer.Checked := ReadBool('Play', 'UseTimer', chbUseTimer.Checked);
    chbRawOnlyMode.Checked := ReadBool('Setting', 'RawOnlyMode', chbRawOnlyMode.Checked);
    chbAutoWavHeader.Checked := ReadBool('Setting', 'AutoWavHeader', chbAutoWavHeader.Checked);
    FnFileDeleteRadioIndex := ReadInteger('Setting', 'DeleteFile', 0);
    txtFileMoveDirectory.Text := ReadString('Setting', 'DeleteFileDirectory', txtFileMoveDirectory.Text);
    cbDeleteNoDialog.Checked := ReadBool('Setting', 'DeleteFileNoPrompt', cbDeleteNoDialog.Checked);
    txtExcludeExtension.Text := ReadString('Filter', 'ExcludeExtension', txtExcludeExtension.Text);

    if chbRawOnlyMode.Checked then chbAutoWavHeader.Enabled := false;

    // ToDo: How to apply icons for Windows10, or Win10-32bit?
    //chbNoTreeIcon.Checked := true;
    //chbNoTreeIcon.Enabled := false;
  end;
  gbDeleteFileClick(nil);

  case FnFileDeleteRadioIndex of
    0: rbFileDeleteD.Checked := true;
    1: rbFileDeleteM.Checked := true;
    2: rbFileDeleteNG.Checked := true;
  end;

  for i:= 0 to 3 do
  begin
    if i < AppGlobal.ExternalAppCount then
    begin
      item := lvApps.Items.Add;
      item.Caption := AppGlobal.ExternalAppData[i, 'Name'];
      item.SubItems.Add(AppGlobal.ExternalAppData[i, 'Path']);
      item.SubItems.Add(AppGlobal.ExternalAppData[i, 'Argv']);
    end
    else
    begin
      item := lvApps.Items.Add;
      item.Caption := '';
      item.SubItems.Add('');
      item.SubItems.Add('');
    end;
  end;
end;

procedure TSettingDlg.btnSetMoveDirectoryClick(Sender: TObject);
var
  path: String;
begin
  if DirectoryExists(txtFileMoveDirectory.Text) then
    MoveDirectoryOpenDlg.InitialDir := txtFileMoveDirectory.Text
  else
    MoveDirectoryOpenDlg.InitialDir := AppGlobal.ExePath;

  if MoveDirectoryOpenDlg.Execute then
    path := ExtractFilePath(MoveDirectoryOpenDlg.FileName);
  if DirectoryExists(path) then
    txtFileMoveDirectory.Text := path;
end;

procedure TSettingDlg.chbRawOnlyModeClick(Sender: TObject);
begin
  if chbRawOnlyMode.Checked then
    chbAutoWavHeader.Enabled := false
  else
    chbAutoWavHeader.Enabled := true;

end;

procedure TSettingDlg.gbDeleteFileClick(Sender: TObject);
begin
  if Assigned(Sender) then
    FnFileDeleteRadioIndex := (Sender as TRadioButton).Tag;
  if FnFileDeleteRadioIndex = 1 then
  begin
    btnSetMoveDirectory.Enabled := true;
    txtFileMoveDirectory.Enabled := true;
  end
  else
  begin
    btnSetMoveDirectory.Enabled := false;
    txtFileMoveDirectory.Enabled := false;
  end;
end;

procedure TSettingDlg.btnSetAppPathClick(Sender: TObject);
var
  path: String;
begin
  if DirectoryExists(txtAppPath.Text) then
    AppPathOpenDlg.InitialDir := ExtractFileDir(txtAppPath.Text)
  else
    AppPathOpenDlg.InitialDir := AppGlobal.ExePath;

  if AppPathOpenDlg.Execute then
    path := AppPathOpenDlg.FileName;
  if FileExists(path) then
    txtAppPath.Text := path;
  if txtAppName.Text = '' then
    txtAppName.Text := ChangeFileExt(ExtractFileName(path), '');
end;

procedure TSettingDlg.txtAppChange(Sender: TObject);
begin
  if (lvApps.ItemIndex = -1) then Exit;
  if FbAppChange then Exit;
  
  With lvApps.Selected do
  begin
    Caption := txtAppName.Text;
    SubItems[0] := txtAppPath.Text;
    SubItems[1] := txtAppArgv.Text;
  end;
end;

procedure TSettingDlg.lvAppsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if Change <> ctState then Exit;
  FbAppChange := true;
  if Assigned(Item) then
  begin
    txtAppName.Text := Item.Caption;
    txtAppPath.Text := Item.SubItems[0];
    txtAppArgv.Text := Item.SubItems[1];
  end
  else
  begin
    txtAppName.Text := '';
    txtAppPath.Text := '';
    txtAppArgv.Text := '';
  end;
  FbAppChange := false;
end;

procedure TSettingDlg.btnDefExcludeExtensionClick(Sender: TObject);
begin
  txtExcludeExtension.Text := DefaultExcludeExtension;
end;

procedure TSettingDlg.OKBtnClick(Sender: TObject);
var
  i: integer;
begin
  With AppGlobal.Ini do
  begin
    WriteBool('Setting', 'NoTreeIcon', chbNoTreeIcon.Checked);
    //WriteBool('Setting', 'NoTreeIcon', true);
    WriteBool('Play', 'UseTimer', chbUseTimer.Checked);
    WriteBool('Setting', 'RawOnlyMode', chbRawOnlyMode.Checked);
    WriteBool('Setting', 'AutoWavHeader', chbAutoWavHeader.Checked);
    WriteInteger('Setting', 'DeleteFile', FnFileDeleteRadioIndex);
    WriteString('Setting', 'DeleteFileDirectory', txtFileMoveDirectory.Text);
    WriteBool('Setting', 'DeleteFileNoPrompt', cbDeleteNoDialog.Checked);
    WriteString('Filter', 'ExcludeExtension', txtExcludeExtension.Text);
    for i:=0 to 3 do
    begin
      WriteString('ExternalApps' + IntToStr(i), 'Name', lvApps.Items[i].Caption);
      WriteString('ExternalApps' + IntToStr(i), 'Path', lvApps.Items[i].SubItems[0]);
      WriteString('ExternalApps' + IntToStr(i), 'Argv', lvApps.Items[i].SubItems[1]);
    end;
    UpdateFile;
  end;
end;

end.

 