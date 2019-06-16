unit FListPlayer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, WaveOut, ComCtrls, ExtCtrls, ActiveX, ShellIcon, htListViewEx,
  Menus, ActnList, ToolWin, ShellAPI, MMSystem,
  fWaveView, fShortcutList, Global, ImgList, System.ImageList, System.Actions;
//  Menus, ActnList, DropSource, DropTarget, ToolWin, ShellAPI,

type
  TMainForm = class(TForm)
    tbPlayPosition: TTrackBar;
    cbSwap: TCheckBox;
    LeftPanel: TPanel;
    RightPanel: TPanel;
    Splitter1: TSplitter;
    RBottomPanel: TPanel;
    cbxSampling: TComboBox;
    cbxBit: TComboBox;
    tvDirectory: TTreeView;
    xlvFiles: TListView;
    txtFilter: TEdit;
    Panel1: TPanel;
    PopupFileList: TPopupMenu;
    N1: TMenuItem;
    ActionList1: TActionList;
    FileListPlayFromHere: TAction;
    ControlBar1: TControlBar;
    Main_ToolBar: TToolBar;
    txtPath: TEdit;
    ToolBar2: TToolBar;
    tbtnOpenPath: TToolButton;
    ToolBarOpenPath: TAction;
    tbMasterVolume: TTrackBar;
    cbStereo: TCheckBox;
    FileListPlayThis: TAction;
    N2: TMenuItem;
    N3: TMenuItem;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    tbtnViewWave: TToolButton;
    cbexDrive: TComboBoxEx;
    MainMenu1: TMainMenu;
    miAutoLabel: TMenuItem;
    StatusBar1: TStatusBar;
    FileListDeleteFile: TAction;
    D1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    HelpAboutBox: TAction;
    SettingOpenDialog: TAction;
    S1: TMenuItem;
    S2: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Show1: TMenuItem;
    N6: TMenuItem;
    ViewReload: TAction;
    miSimpleHelp: TMenuItem;
    ViewWaveForm: TAction;
    ViewWaveForm1: TMenuItem;
    N7: TMenuItem;
    FileListUndoDelete: TAction;
    Z1: TMenuItem;
    ImageList1: TImageList;
    btnPlayAll: TToolButton;
    btnStop: TToolButton;
    ToolButton3: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPlayAllaClick(Sender: TObject);
    procedure tvDirectoryExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvDirectoryClick(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure cbxDriveChange(Sender: TObject);
    procedure txtFilterChange(Sender: TObject);
    procedure xlvFilesDblClick(Sender: TObject);
    procedure tvDirectoryCollapsed(Sender: TObject; Node: TTreeNode);
    procedure btnStopaClick(Sender: TObject);
    procedure PopupFileListPopup(Sender: TObject);
    procedure FileListPlayFromHereExecute(Sender: TObject);
    procedure FileListExecExternalApp(Sender: TObject);
//    procedure DropFileTarget1Drop(Sender: TObject; ShiftState: TShiftState;
//      Point: TPoint; var Effect: Integer);
    procedure ToolBarOpenPathExecute(Sender: TObject);
    procedure tbMasterVolumeChange(Sender: TObject);
    procedure FileListPlayThisExecute(Sender: TObject);
    procedure xlvFilesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure xlvFilesClick(Sender: TObject);
    procedure xlvFilesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FileListDeleteFileExecute(Sender: TObject);
    procedure HelpAboutBoxExecute(Sender: TObject);
    procedure miAutoLabelClick(Sender: TObject);
    procedure SettingOpenDialogExecute(Sender: TObject);
    procedure ViewReloadExecute(Sender: TObject);
    procedure miSimpleHelpClick(Sender: TObject);
    procedure ViewWaveFormExecute(Sender: TObject);
    procedure txtPathKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvDirectoryCompare(Sender: TObject; Node1, Node2: TTreeNode;
      Data: Integer; var Compare: Integer);
    procedure FileListUndoDeleteExecute(Sender: TObject);
    procedure tvDirectoryKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ControlBar1Resize(Sender: TObject);
    procedure KeyDownFocusMove(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    waveOut: TWavOut;
    FShellIcon: TShellIcon;
    FStrDirectory: String;
    FbStopping: Boolean;
    FStrUndoSrcFilename: String;
    FStrUndoDestFilename: String;
    FbPlayWaveWithUseTimer: Boolean;
    procedure LoadSetting;
    procedure SaveSetting;
    procedure SwapData(lpData: PAnsiChar; dwLength: DWORD);
    function GetFileData(var lpData: Pointer; filename: String; bSwap: Boolean; var waveHeader: TWaveFormatEx): Cardinal;
    function GetFileData_RAW(var lpData: Pointer; var msWave: TMemoryStream): Cardinal;
    function GetFileData_WAV(var lpData: Pointer; var msWave: TMemoryStream; var waveHeader: TWaveFormatEx): Cardinal;
    procedure PlaySound(filename :String);
    procedure PlayList(Index: Integer);
    procedure InitDirectoryTree(const Path: String);
    procedure BuildDirectoryTree(Node: TTreeNode; const Path: string; Depth: Integer);
    procedure InitFileList(const Path: String);
    function BuildFileList(const Path: string): Integer;
    procedure BuildDriveList(ADriveList: TStrings);
    procedure BuildDriveListEx;
    procedure ReadDriveList(ADriveList: TStrings);
    function GetPathFromNode(Node: TTreeNode): String;
    procedure OpenDirectory(dir: String);
    function UnListFileFilter(filename: String): Boolean;
    function FindChild(Node: TTreeNode; SearchText: string): TTreeNode;
    procedure AddFilelistPopupMenu;
    procedure SetAutoCompleteEdit;
    procedure ReadAdditionalDriveList(ADriveList: TStrings);
  public
    lvFiles: ThtListViewEx;
    { Public 宣言 }
  published
    property WavOut: TWavOut read waveOut;
  end;
        
var
  MainForm: TMainForm;
  WaveViewForm: TWaveViewForm;
  ShortcutListForm: TShortcutListForm;
//  AppGlobal: TGlobal;

implementation
uses
  Math, IniFiles, uFileListView, fAboutBox, fSetting;
{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
//  AppGlobal := TGlobal.Create;
  // とりあえず メインフォームにバージョン追加
  Caption := Caption + ' - ' + AppGlobal.AppVersion;
  
  WaveViewForm := TWaveViewForm.Create(Self);
  ShortcutListForm := TShortcutListForm.Create(Self);
//  // DnD用
//  DropFileTarget1.Register(MainForm);
  // リストボックスの作成
  xlvFiles.Free;
  lvFiles := TFileListView.Create(RBottomPanel);
  With lvFiles do
  begin
    OnClick := xlvFilesClick;
    OnDblClick := xlvFilesDblClick;
    OnKeyDown := xlvFilesKeyDown;
    OnChange := xlvFilesChange;
    PopupMenu := PopupFileList;
  end;

  // waveOutクラス作成
  waveOut := TWavOut.Create;
  
  LoadSetting;

  Application.HintPause := 100;
  
  // アイコン設定
  if not (AppGlobal.Ini.ReadBool('Setting', 'NoTreeIcon', true)) then
  begin
    FShellIcon := TShellIcon.Create(Self);
    tvDirectory.Images := FShellIcon.Images;
    cbexDrive.Images := FShellIcon.Images;
  end;
  // リスト、ツリーの初期化
  BuildDriveListEx;

  // コマンドライン引数解釈
  if ParamCount > 0 then
  begin
    if DirectoryExists(ParamStr(1)) then
      txtPath.Text := ParamStr(1)
    else
      txtPath.Text := ExtractFilePath(ParamStr(1));
  end;

  if not DirectoryExists(txtPath.Text) then txtPath.Text := '';
  
  if (txtPath.Text = '') then
    cbexDrive.OnChange(nil);

  OpenDirectory(txtPath.Text);

  SetAutoCompleteEdit;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SaveSetting;

  if Assigned(waveOut) then waveOut.Free;
  if Assigned(FShellIcon) then FShellIcon.Free;
  if Assigned(lvFiles) then lvFiles.Free;
//  if Assigned(AppGlobal) then AppGlobal.Free;
//  // DnD用
//  DropFileTarget1.Unregister;
end;

procedure TMainForm.LoadSetting;
var
  i: Integer;
begin
  // ウィンドウ位置読み込み
  With AppGlobal.Ini do
  begin
    Width := ReadInteger('Window', 'Width', Width);
    Height := ReadInteger('Window', 'Height', Height);
    Left := ReadInteger('Window', 'Left', Left);
    Top := ReadInteger('Window', 'Top', Top);
    LeftPanel.Width := ReadInteger('Window', 'LeftPanelWidth', LeftPanel.Width);
    WaveViewForm.Visible := ReadBool('Window', 'F2Visible', WaveViewForm.Visible);
    WaveViewForm.Width := ReadInteger('Window', 'F2Width', WaveViewForm.Width);
    WaveViewForm.Height := ReadInteger('Window', 'F2Height', WaveViewForm.Height);
    WaveViewForm.Left := ReadInteger('Window', 'F2Left', WaveViewForm.Left);
    WaveViewForm.Top := ReadInteger('Window', 'F2Top', WaveViewForm.Top);
    WaveViewForm.cmbMaxRange.ItemIndex := ReadInteger('Window', 'F2MaxRange', WaveViewForm.cmbMaxRange.ItemIndex);
    ShortcutListForm.Visible := ReadBool('Window', 'SimpleHelpVisible', ShortcutListForm.Visible);
    for i:=0 to lvFiles.Columns.Count - 1 do
      lvFiles.Column[i].Width := ReadInteger('Filelist', 'Col' + IntToStr(i), lvFiles.Column[i].Width);
    cbSwap.Checked := ReadBool('Play', 'Swap', cbSwap.Checked);
    cbStereo.Checked := ReadBool('Play', 'Stereo', cbStereo.Checked);
    cbxBit.ItemIndex := ReadInteger('Play', 'Bit', cbxBit.ItemIndex);
    cbxSampling.ItemIndex := ReadInteger('Play', 'Sampling', cbxSampling.ItemIndex);
    txtFilter.Text := ReadString('Play', 'Filter', txtFilter.Text);
    tbMasterVolume.Position := ReadInteger('Play', 'Volume', tbMasterVolume.Position);
    txtPath.Text := ReadString('Directories', 'Last0', txtPath.Text);
    miAutoLabel.Checked := ReadBool('Menu', 'AutoLabel', miAutoLabel.Checked);

    waveOut.UseTimer := ReadBool('Play', 'UseTimer', FbPlayWaveWithUseTimer);
  end;

  tbtnViewWave.Down := WaveViewForm.Visible;
  WaveViewForm.cmbMaxRangeChange(nil);

  // ポップアップに外部アプリの登録
  AddFilelistPopupMenu;

end;

procedure TMainForm.SaveSetting;
var
  i: integer;
begin
  // ウィンドウ位置書き込み
  With AppGlobal.Ini do
  begin 
    WriteInteger('Window', 'Width', Width);
    WriteInteger('Window', 'Height', Height);
    WriteInteger('Window', 'Left', Left);
    WriteInteger('Window', 'Top', Top);
    WriteInteger('Window', 'LeftPanelWidth', LeftPanel.Width);
    WriteBool('Window', 'F2Visible', WaveViewForm.Visible);
    WriteInteger('Window', 'F2Width', WaveViewForm.Width);
    WriteInteger('Window', 'F2Height', WaveViewForm.Height);
    WriteInteger('Window', 'F2Left', WaveViewForm.Left);
    WriteInteger('Window', 'F2Top', WaveViewForm.Top);
    WriteInteger('Window', 'F2MaxRange', WaveViewForm.cmbMaxRange.ItemIndex);
    WriteBool('Window', 'SimpleHelpVisible', ShortcutListForm.Visible);
    for i:=0 to lvFiles.Columns.Count - 1 do
      WriteInteger('Filelist', 'Col' + IntToStr(i), lvFiles.Column[i].Width);
    WriteBool('Play', 'Swap', cbSwap.Checked);
    WriteBool('Play', 'Stereo', cbStereo.Checked);
    WriteInteger('Play', 'Bit', cbxBit.ItemIndex);
    WriteInteger('Play', 'Sampling', cbxSampling.ItemIndex);
    WriteString('Play', 'Filter', txtFilter.Text);
    WriteInteger('Play', 'Volume', tbMasterVolume.Position);
    WriteString('Directories', 'Last0', txtPath.Text);
    WriteBool('Menu', 'AutoLabel', miAutoLabel.Checked);
  end;
end;

procedure TMainForm.btnPlayAllaClick(Sender: TObject);
begin
  PlayList(0);
end;

procedure TMainForm.SwapData(lpData: PAnsiChar; dwLength: DWORD);
var
  i: DWORD;
  temp: AnsiChar;
begin
  if Ceil(dwLength/2) <> Floor(dwLength/2) then Exit;
  i := 0;
  while i < dwLength do
  begin
    temp := lpData[i+1];
    lpData[i+1] := lpData[i];
    lpData[i] := temp;
    i := i + 2;
  end;
end;

procedure TMainForm.PlaySound(filename: String);
var
  Buffer: Pointer;
  dwLength: Cardinal;
  n: Cardinal;
  waveHeader: TWaveFormatEx;
  nSampling: Integer;
  nBit: Integer;
begin
  btnPlayAll.Enabled := false;
  btnStop.Enabled := true;

  // RAWファイル専用モードの場合は，フォーマットを0にしておく
  // このprocedure中で呼ばれる関数で利用される
  if AppGlobal.Ini.ReadBool('Setting', 'RawOnlyMode', true) then
    waveHeader.wFormatTag := 0
  else
    waveHeader.wFormatTag := 1;
  dwLength := GetFileData(Buffer, filename, cbSwap.Checked, waveHeader);

  try
    if AppGlobal.Ini.ReadBool('Setting', 'AutoWavHeader', true) and (waveHeader.wFormatTag > 0) then
    begin
      waveOut.Bit := waveHeader.wBitsPerSample;
      waveOut.Sampling := waveHeader.nSamplesPerSec;
    end else begin
      waveOut.Bit := StrToInt(cbxBit.Text);
      waveOut.Sampling := StrToInt(cbxSampling.Text);
    end;

    WaveViewForm.SetParameter(waveOut.Bit, waveOut.Sampling, miAutoLabel.Checked);
    WaveViewForm.DrawWaveGraph(filename, Buffer, dwLength);
    
    tbPlayPosition.Max := dwLength;
    tbPlayPosition.Position := 0;
    tbPlayPosition.Frequency := waveOut.Sampling;

    with waveOut do
    try
      Volume := tbMasterVolume.Position;
      Stereo := cbStereo.Checked;

      Open;
      Play(PAnsiChar(Buffer), dwLength);
      while IsPlaying do
      begin
        Sleep(20);  // 適当にウェイト掛けておく（処理落ち防止）
        Application.ProcessMessages;
        n := Position;
        WaveViewForm.DrawPlayLine(n);
        tbPlayPosition.Position := n;
      end;
    finally
      Stop;
      Close;
//    tbPlayPosition.Position := tbPlayPosition.Max;
    end;
  finally
    FreeMem(Buffer);
  end;

  btnPlayAll.Enabled := true;
  btnStop.Enabled := false;
end;

procedure TMainForm.BuildDirectoryTree(Node: TTreeNode; const Path: string; Depth: Integer);
var
  Rec     : TSearchRec; {ファイル情報}
  TreeNode: TTreeNode;  {TreeView追加ノード}
begin
  if Assigned(Node) and (Node.Count > 1) then Exit;
  if (Depth > 0) and Assigned(Node) then Node.getFirstChild.Delete;
  //最初のファイル検索  (成功した場合は 0 を返す)
  if  (FindFirst(Path + '*', faAnyFile, Rec) = 0) then  begin
    repeat
      // . と .. は処理しません
      if  ((Rec.Name <> '.') and (Rec.Name <> '..')) then  begin
        //ディレクトリかどうかをチェック
        if  ((Rec.Attr and faDirectory) > 0)  then  begin
          //ツリーにノードを追加
          TreeNode := tvDirectory.Items.AddChild(Node, Rec.Name);
          TreeNode.ImageIndex := SHELLICON_CLOSEDFOLDER;
          if Depth > 0 then
          begin
            BuildDirectoryTree(TreeNode, Path + Rec.Name + '\', Depth-1);
          end
          else
            Break;
        end;
      end;
    //次のファイル (成功した場合は 0 を返す)
    until (FindNext(Rec) <> 0);
    FindClose(Rec);
  end;

  Node.CustomSort(nil, 0);
end;

function TMainForm.GetPathFromNode(Node: TTreeNode): String;
begin
  Result := Node.Text + '\';
  if Node.Parent <> nil then
    Result := GetPathFromNode(Node.Parent) + Result;
end;

procedure TMainForm.tvDirectoryExpanded(Sender: TObject; Node: TTreeNode);
begin
  Node.Selected := true;
  Node.ImageIndex := SHELLICON_OPENFOLDER;
  tvDirectory.Items.BeginUpdate;
  try
    BuildDirectoryTree(Node, GetPathFromNode(Node), 1);
  finally
    tvDirectory.Items.EndUpdate;
  end;
//  tvDirectory.Repaint;
end;

procedure TMainForm.tvDirectoryClick(Sender: TObject);
begin
  if tvDirectory.Selected = nil then Exit;

  FStrDirectory := GetPathFromNode(tvDirectory.Selected);
  InitFileList(FStrDirectory);

  txtPath.Text := FStrDirectory;
end;

function TMainForm.BuildFileList(const Path: string): Integer;
var
  Rec: TSearchRec; {ファイル情報}
  i: Integer;
  t: Real;
  sumSize: Integer;
begin
  i := 0;
  sumSize := 0;
  //最初のファイル検索  (成功した場合は 0 を返す)
  if  (FindFirst(Path + txtFilter.Text, faAnyFile, Rec) = 0) then  begin
    repeat
      // . と .. は処理しません
//      if  ((Rec.Name <> '.') and (Rec.Name <> '..')) then  begin
        if (not DirectoryExists(Path + Rec.Name))
            and not UnListFileFilter(Rec.Name) then
        begin
          Inc(sumSize, Rec.Size);
          t := Rec.Size / (StrToInt(cbxBit.Text) / 8) / StrToInt(cbxSampling.Text);
          With lvFiles.Items.Insert(i) do
          begin
            Caption := IntToStr(i+1);
            SubItems.Add(Rec.Name);
            SubItems.Add(FormatFloat('#,##0',Rec.Size));
            SubItems.Add(Format('%.2d:%.2d.%.3d',
                                [Floor(t/60), Floor(t) mod 60, Floor(t*1000) mod 1000]));
            SubItems.Add(DateTimeToStr(FileDateToDateTime(Rec.Time)));
          end;
          Inc(i);
        end;
//      end;
    //次のファイル (成功した場合は 0 を返す)
    until (FindNext(Rec) <> 0);
    FindClose(Rec);
  end;
  Result := sumSize;
end;

function TMainForm.UnListFileFilter(filename: String): Boolean;
var
  ext: string;
  extList:TStringList;
  i: integer;
begin
  extList := AppGlobal.ExcludeExtension;
  ext := ExtractFileExt(filename);
  Result := false;
  for i:=0 to extList.Count - 1 do
  begin
    if (ext = extList[i]) then
    begin
      Result := true;
      Break;
    end;
  end;
end;

procedure TMainForm.Panel1Resize(Sender: TObject);
begin
  cbexDrive.Width := Panel1.Width;
end;

procedure TMainForm.BuildDriveList(ADriveList: TStrings);
var
  DriveStr: array[0..128] of Char;
  CurrentDriveStr: string;
  CurrentPos: PChar;
begin
  if Assigned(ADriveList) then
  begin
    ADriveList.Clear;
    FillChar(DriveStr, SizeOf(DriveStr), 0);
    GetLogicalDriveStrings(SizeOf(DriveStr), DriveStr);
    CurrentDriveStr := DriveStr;
    CurrentPos := DriveStr;
    while CurrentDriveStr <> '' do
    begin
      ADriveList.Add(CurrentDriveStr);
      CurrentPos := StrScan(CurrentPos, #0);
      Inc(CurrentPos);
      CurrentDriveStr := CurrentPos;
    end;
  end;
end;

procedure TMainForm.cbxDriveChange(Sender: TObject);
begin
  if cbexDrive.ItemIndex = -1 then Exit;

  InitDirectoryTree(cbexDrive.ItemsEx[cbexDrive.ItemIndex].Caption);
  txtPath.Text := cbexDrive.ItemsEx[cbexDrive.ItemIndex].Caption;
end;

procedure TMainForm.InitDirectoryTree(const Path: String);
var
  root: TTreeNode;
begin
  tvDirectory.Items.Clear;
  root := tvDirectory.Items.Add(nil, ExcludeTrailingPathDelimiter(Path));
  tvDirectory.Items.AddChild(root, 'dummy');
  tvDirectory.Items.BeginUpdate;
  try
    BuildDirectoryTree(root, Path, 1);
    root.Expand(false);
  finally
    tvDirectory.Items.EndUpdate;
  end;
//  tvDirectory.SortType := stNone;
//  tvDirectory.SortType := stText;
  tvDirectory.CustomSort(nil, 0);
end;

procedure TMainForm.InitFileList(const Path: String);
var
  sumSize: Integer;
  t: Real;
begin
  lvFiles.Clear;
  lvFiles.Items.BeginUpdate;
  try
    sumSize := BuildFileList(Path);
    t := sumSize / (StrToInt(cbxSampling.Text) * StrToInt(cbxBit.Text) / 8);
  finally
    lvFiles.Items.EndUpdate;
  end;

  // ステータスバーのテキスト変更
  StatusBar1.Panels[1].Text := Format('ファイル数:%d (合計:%s byte [%d:%.2d:%.2d.%.3d])',
                              [lvFiles.Items.Count,
                               FormatFloat(',##0', sumSize),
                               Floor(t/3600),
                               Floor(t/60),
                               Floor(t) mod 60,
                               Floor(t*1000) mod 1000
                              ]);
end;

procedure TMainForm.txtFilterChange(Sender: TObject);
begin
  InitFileList(FStrDirectory);
end;

procedure TMainForm.xlvFilesDblClick(Sender: TObject);
begin
  if lvFiles.SelCount = 0 then Exit;

  btnStop.Click;
//  PlaySound(FStrDirectory + lvFiles.Selected.Caption);
  PlaySound(FStrDirectory + lvFiles.Selected.SubItems[0]);
end;

procedure TMainForm.tvDirectoryCollapsed(Sender: TObject; Node: TTreeNode);
begin
  Node.ImageIndex := SHELLICON_CLOSEDFOLDER;
  tvDirectory.Update;
end;

procedure TMainForm.btnStopaClick(Sender: TObject);
begin
  waveOut.Stop;
  FbStopping := true;
end;

procedure TMainForm.PopupFileListPopup(Sender: TObject);
var
  i: Integer;
begin
  if lvFiles.ItemIndex = -1 then
  begin
    for i:= 0 to PopupFileList.Items.Count -1 do
    begin
      PopupFileList.Items[i].Enabled := false;
    end;
  end
  else
  begin
    for i:= 0 to PopupFileList.Items.Count -1 do
    begin
      PopupFileList.Items[i].Enabled := true;
    end;
  end;
end;

procedure TMainForm.PlayList(Index: Integer);
begin
  if lvFiles.Items.Count = 0 then Exit;

  btnPlayAll.Enabled := false;
  btnStop.Enabled := true;
  
  btnStop.Click;
  lvFiles.ItemIndex := Index - 1;
  FbStopping := false;
  With lvFiles do
  begin
    SetFocus;
    Sleep(0);
    repeat
    begin
      if FbStopping then Break;
      ItemIndex := ItemIndex + 1;
      Items[ItemIndex].Selected := true;
      Items[ItemIndex].Focused := true;
      if ItemIndex < Items.Count - 1 then
        Items[ItemIndex+1].MakeVisible(false);
      try
        PlaySound(FStrDirectory + Items[ItemIndex].SubItems[0]);
        Sleep(100);
      except
        FbStopping := true;
      end;
    end;
    until not Assigned(Items[ItemIndex+1]);
  end;
  btnPlayAll.Enabled := true;
  btnStop.Enabled := false;
end;

procedure TMainForm.FileListPlayFromHereExecute(Sender: TObject);
begin
  PlayList(lvFiles.ItemIndex);
end;

//procedure TForm1.DropFileTarget1Drop(Sender: TObject;
//  ShiftState: TShiftState; Point: TPoint; var Effect: Integer);
//var
//  dir: String;
//begin
//  if DirectoryExists(DropFileTarget1.Files[0]) then
//    dir := DropFileTarget1.Files[0]
//  else
//    dir := ExtractFilePath(DropFileTarget1.Files[0]);
//
//  OpenDirectory(dir);
//  SetForegroundWindow(Application.Handle);
//end;

function TMainForm.FindChild(Node: TTreeNode; SearchText: string): TTreeNode;
var
  CurItem: TTreeNode;
begin
  Result := nil;
  CurItem := Node.getFirstChild;
  while CurItem <> nil do
  begin
    if CurItem.Text = SearchText then
    begin
      Result := CurItem;
      Break;
    end;
    CurItem := CurItem.GetNext;
  end;
end;

procedure TMainForm.ToolBarOpenPathExecute(Sender: TObject);
begin
  if DirectoryExists(txtPath.Text) then
    ShellExecute(Handle, 'explore', PChar(txtPath.Text), nil, nil, SW_SHOW);
end;

procedure TMainForm.AddFilelistPopupMenu;
var
  i: Integer;
  menu: TMenuItem;
  text: String;
begin
  i := PopupFileList.Items.Count - 1;
  while i > -1 do
  begin
    if (PopupFileList.Items[i].tag > -1) then
      PopupFileList.Items.Delete(i);
    Dec(i);
  end;

  for i:= 0 to AppGlobal.ExternalAppCount - 1 do
  begin
    text := AppGlobal.ExternalAppData[i, 'Name'];
    if text <> '' then
    begin
      menu := TMenuItem.Create(PopupFileList);
      menu.Caption := text + ' で開く';
      menu.Tag := i;
      menu.OnClick := FileListExecExternalApp;
      PopupFileList.Items.Add(menu);
    end;
  end;
end;

procedure TMainForm.FileListExecExternalApp(Sender: TObject);
var
  menu: TMenuItem;
  ParmStr: String;
  function GetChanelNum(): String;
  begin
    if cbStereo.Checked then Result := '2'
    else Result := '1';
  end;
  function GetFormat(): String;
  begin
    if cbSwap.Checked then Result := 'swap'
    else Result := 'raw';
  end;
begin
  menu := Sender as TMenuItem;
  if Assigned(menu) then
  begin
//             AppGlobal.ExternalAppData[menu.Tag, 'Argv'] + FStrDirectory + lvFiles.Selected.Caption
    ParmStr := AppGlobal.ExternalAppData[menu.Tag, 'Argv'];
    ParmStr := StringReplace(ParmStr, '%b', cbxBit.Text, [rfReplaceAll]);
    ParmStr := StringReplace(ParmStr, '%f', cbxSampling.Text, [rfReplaceAll]);
    ParmStr := StringReplace(ParmStr, '%c', GetChanelNum(), [rfReplaceAll]);
    ParmStr := StringReplace(ParmStr, '%t', GetFormat(), [rfReplaceAll]);
    ShellExecute(Handle,
                 'open',
                 PChar(AppGlobal.ExternalAppData[menu.Tag, 'Path']),
                 PChar(ParmStr + ' ' + FStrDirectory + lvFiles.Selected.SubItems[0]),
                 PChar(FStrDirectory),
                 SW_SHOW);
  end;
end;

procedure TMainForm.tbMasterVolumeChange(Sender: TObject);
begin
  waveOut.Volume := tbMasterVolume.Position;
end;

procedure TMainForm.FileListPlayThisExecute(Sender: TObject);
begin
//  PlaySound(FStrDirectory + lvFiles.Selected.Caption);
  PlaySound(FStrDirectory + lvFiles.Selected.SubItems[0]);
end;

procedure TMainForm.xlvFilesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    Ord('p'), Ord('P'):begin
      PlayList(lvFiles.ItemIndex);
      Key := 0;
    end;
    Ord('d'), Ord('D'), Ord('x'), Ord('X'): FileListDeleteFile.Execute;
    Ord('z'), Ord('Z'): FileListUndoDelete.Execute;
    Ord('b'), Ord('B'): Key := VK_HOME;
    Ord('n'), Ord('N'): Key := VK_END;
  end;

  KeyDownFocusMove(Sender, Key, Shift);

  case Key of
    VK_RETURN, VK_RIGHT:
    begin
      xlvFilesDblClick(Sender);
      Key := 0;
    end;
    VK_SPACE:
      if btnStop.Enabled then
        btnStop.Click
      else if lvFiles.ItemIndex < lvFiles.Items.Count then
      begin
        lvFiles.Items[lvFiles.ItemIndex + 1].Selected := true;
        lvFiles.Selected.Focused := true;
        if lvFiles.ItemIndex < lvFiles.Items.Count - 1 then
          lvFiles.Items[lvFiles.ItemIndex+1].MakeVisible(false);
        xlvFilesDblClick(Sender);
        Key := 0;
      end;
    VK_LEFT:
    With lvFiles do
    begin
      PopupMenu.Popup(ClientToScreen(Selected.Position).X, ClientToScreen(Selected.Position).Y+15);
      Key := 0;
    end;
  end;
end;

procedure TMainForm.xlvFilesClick(Sender: TObject);
var
  Buffer: Pointer;
  dwLength: DWORD;
  filename: String;
  waveHeader: TWaveFormatEx;
begin
  if lvFiles.SelCount = 0 then Exit;
  if not WaveViewForm.Showing then Exit;
//  filename := FStrDirectory + lvFiles.Selected.Caption;
  filename := FStrDirectory + lvFiles.Selected.SubItems[0];
  if not FileExists(filename) then Exit;

  // RAWファイル専用モードの場合は，フォーマットを0にしておく
  // このprocedure中で呼ばれる関数で利用される
  if AppGlobal.Ini.ReadBool('Setting', 'RawOnlyMode', true) then
    waveHeader.wFormatTag := 0
  else
    waveHeader.wFormatTag := 1;

  dwLength := GetFileData(Buffer, filename, cbSwap.Checked, waveHeader);
  try
    // WAVヘッダーの自動適用がONで，解析にも成功していれば
    if AppGlobal.Ini.ReadBool('Setting', 'AutoWavHeader', true) and (waveHeader.wFormatTag > 0) then
      WaveViewForm.SetParameter(waveHeader.wBitsPerSample, waveHeader.nSamplesPerSec, miAutoLabel.Checked)
    else
      WaveViewForm.SetParameter(StrToInt(cbxBit.Text), StrToInt(cbxSampling.Text), miAutoLabel.Checked);

    WaveViewForm.DrawWaveGraph(filename, Buffer, dwLength);
  finally
    FreeMem(Buffer);
  end;
end;

function TMainForm.GetFileData(var lpData: Pointer; filename: String;
  bSwap: Boolean; var waveHeader: TWaveFormatEx): Cardinal;
var
  fileStream: TMemoryStream;
begin
  Result := 0;

  fileStream := TMemoryStream.Create;
  fileStream.LoadFromFile(filename);

  // try to load as WAV file, if no 'RAW-ONLY-MODE'
  if waveHeader.wFormatTag > 0 then
  begin
    fileStream.Position := 0;
    Result := GetFileData_WAV(lpData, fileStream, waveHeader);
  end;

  // try to read as RAW file
  if Result = 0 then
  begin
    waveHeader.wFormatTag := 0;
    fileStream.Position := 0;
    Result := GetFileData_RAW(lpData, fileStream);
    if(bSwap) then SwapData(lpData, Result);
  end;

  fileStream.Clear;
  fileStream.Free;
end;

function TMainForm.GetFileData_RAW(var lpData: Pointer; var msWave: TMemoryStream): Cardinal;
var
  iBufferLength: LongInt;
begin
  iBufferLength := msWave.Size;
  System.GetMem(lpData, iBufferLength);
  msWave.ReadBuffer(lpData^, iBufferLength);
  Result := Cardinal(iBufferLength);
end;

function TMainForm.GetFileData_WAV(var lpData: Pointer; var msWave: TMemoryStream; var waveHeader: TWaveFormatEx): Cardinal;
var
  chunk: Array[0..4] of AnsiChar;
  iBufferLength: LongInt;
  iFileAllLength: LongInt;
begin
  Result := 0;

  msWave.ReadBuffer(chunk[0], 4);  // 'RIFF'
  chunk[4] := AnsiChar(0);
  if chunk = 'RIFF' then
  begin
    msWave.ReadBuffer(Pointer(iFileAllLength), 4);  // 全体 - 8 byte
    msWave.ReadBuffer(chunk[0], 4);  // 'WAVE'
    iBufferLength := 0;

    // チャンクのパ―ス
    repeat
    begin
      msWave.Seek(iBufferLength, soFromCurrent);
      msWave.ReadBuffer(chunk[0], 4);
      msWave.ReadBuffer(Pointer(iBufferLength), 4);

      // 'fmt 'チャンク
      if chunk = 'fmt ' then
      begin
        msWave.ReadData(waveHeader.wFormatTag);       // 2
        msWave.ReadData(waveHeader.nChannels);        // 2
        msWave.ReadData(waveHeader.nSamplesPerSec);   // 4
        msWave.ReadData(waveHeader.nAvgBytesPerSec);  // 4
        msWave.ReadData(waveHeader.nBlockAlign);      // 2
        msWave.ReadData(waveHeader.wBitsPerSample);   // 2
        waveHeader.cbSize := 0;
        msWave.Seek(-iBufferLength, soFromCurrent);
      end;
    end
    until chunk = 'data';

    // 'data'チャンク
    //lpData := Pointer(AllocMem(iBufferLength));
    System.GetMem(lpData, iBufferLength);
    msWave.ReadBuffer(lpData^, iBufferLength);

    Result := Cardinal(iBufferLength);
  end;
  // RIFFヘッダーがないと Reult は0のままである
end;

procedure TMainForm.ReadDriveList(ADriveList: TStrings);
begin
  ADriveList.Clear;
  AppGlobal.Ini.ReadSection('DriveList', ADriveList);
end;

procedure TMainForm.ReadAdditionalDriveList(ADriveList: TStrings);
var
  i: Integer;
  strs: TStringList;
  NRW: TNetResource;
  Err: Cardinal;
begin
//  ADriveList.Clear;
  strs := TStringList.Create;
  AppGlobal.Ini.ReadSection('AdditionalDriveList', strs);
  for i := 0 to strs.Count-1 do
  begin
    with NRW do
    begin
      dwType := RESOURCETYPE_ANY;
      lpLocalName := nil;
      lpRemoteName := PChar(ExcludeTrailingPathDelimiter(Trim(strs[i])));
      lpProvider := nil;
    end;
    Err := WNetAddConnection2(NRW, nil, nil, 0);
    if Err <> NO_ERROR then
      ShowMessage('エラー:' + NRW.lpRemoteName +':'+ IntToStr(Err))
    else
      ADriveList.Add(IncludeTrailingPathDelimiter(Trim(strs[i])));
//    Err := WNetCancelConnection2(NRW.lpRemoteName, 0, FALSE);
  end;
end;

procedure TMainForm.BuildDriveListEx;
var
  i: Integer;
  num: Cardinal;
begin
  if AppGlobal.Ini.SectionExists('DriveList') then
    ReadDriveList(cbexDrive.Items)
  else
  begin
    BuildDriveList(cbexDrive.Items);
    if AppGlobal.Ini.SectionExists('AdditionalDriveList') then
      ReadAdditionalDriveList(cbexDrive.Items);
  end;
//  for i:=0 to cbexDrive.ItemsEx.Count - 1 do
  for i:=cbexDrive.ItemsEx.Count - 1 downto 0 do
  begin
    num := GetDriveType(PChar(cbexDrive.Items[i]));
    if num = DRIVE_REMOVABLE then
    begin
      if (Pos('A', cbexDrive.Items[i]) = 1) or (Pos('B', cbexDrive.Items[i]) = 1) then
        cbexDrive.ItemsEx[i].ImageIndex := SHELLICON_FDD
      else
        cbexDrive.ItemsEx[i].ImageIndex := SHELLICON_REMOVABLE;
    end
    else if num = DRIVE_FIXED then
    begin
      cbexDrive.ItemsEx[i].ImageIndex := SHELLICON_HDD;
      cbexDrive.ItemIndex := i;
    end
    else if num = DRIVE_REMOTE then
      cbexDrive.ItemsEx[i].ImageIndex := SHELLICON_REMOTE
    else if num = DRIVE_CDROM then
      cbexDrive.ItemsEx[i].ImageIndex := SHELLICON_CDROM
    ;  
//    else if num = DRIVE_RAMDISK then
//      cbexDrive.ItemsEx[i].ImageIndex := SHELLICON_RAMDISK;
  end;
end;

procedure TMainForm.xlvFilesChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if Change = ctState then
    xlvFilesClick(Sender);
end;

procedure TMainForm.OpenDirectory(dir: String);
var
  drive: String;
  i: Integer;
  node: TTreeNode;
begin
  drive := IncludeTrailingPathDelimiter(ExtractFileDrive(dir));
  dir := ExcludeTrailingPathDelimiter(dir);

//  If not DirectoryExists(dir) Then dir := 'c:\';
  
  // まずはドライブ指定
  if cbexDrive.Text <> drive then
    With TStringList.Create do
    try
      Assign(cbexDrive.Items);
      cbexDrive.ItemIndex := IndexOf(drive);
    finally
      Free;
    end;
  cbexDrive.OnChange(cbexDrive);

  // ディレクトリを指定
  With TStringList.Create do
  try
    Delimiter := Char('\');
    DelimitedText := dir;
    node := tvDirectory.Items.GetFirstNode;
    for i:=1 to Count - 1 do
    begin
      node := FindChild(node, Strings[i]);
      node.Expand(false);
      node.Selected := true;
    end;
  finally
    Free;
  end;
  tvDirectoryClick(nil);
end;

procedure TMainForm.FileListDeleteFileExecute(Sender: TObject);
var
  filename: String;
  path: String;
  Index: Integer;
  NewIndex: Integer;
  bNoPrompt: Boolean;
begin
  if not Assigned(lvFiles.Selected) then Exit;
//  filename := FStrDirectory + lvFiles.Selected.Caption;
  filename := FStrDirectory + lvFiles.Selected.SubItems[0];

  if not FileExists(filename) then Exit;

  if lvFiles.ItemIndex = lvFiles.Items.Count -1 then
    NewIndex := -1
  else
    NewIndex := lvFiles.ItemIndex;
  
  Index := AppGlobal.Ini.ReadInteger('Setting', 'DeleteFile', 0);
  bNoPrompt := AppGlobal.Ini.ReadBool('Setting', 'DeleteFileNoPrompt', false);
  if Index = 0 then
  begin
    if bNoPrompt or
        (MessageDlg('次のファイルを削除します。' + #13#10 +
               filename + #13#10 +
               'よろしいですか？', mtConfirmation, mbOKCancel, 0) = mrOK) then
      if DeleteFile(filename) then
      begin
        lvFiles.Selected.Delete;
        lvFiles.ItemIndex := NewIndex;
      end
      else
        ShowMessage('削除に失敗しました');
  end
  else
  begin
    if Index = 1 then
    begin
      path := IncludeTrailingPathDelimiter( AppGlobal.Ini.ReadString('Setting', 'DeleteFileDirectory', '') );
      if (path = '\') or (not DirectoryExists(path)) then
      begin
        MessageDlg('移動先ディレクトリが存在しません' + #13#10 +
                   path,
                   mtError, [mbOK],0 );
        Exit;
      end;
    end
    else
    begin
      path := ExtractFilePath(filename) + 'NG' + PathDelim;
      CreateDir(path);
    end;
    if bNoPrompt or 
        (MessageDlg('次のファイルを移動します。' + #13#10#13#10 +
               '  元：' + filename + #13#10 +
               '  先：' + path + ExtractFileName(filename) + #13#10#13#10 +
               'よろしいですか？', mtConfirmation, mbOKCancel, 0) = mrOK) then
//    ShowMessage(path + ExtractFileName(filename));
      if RenameFile(filename, path + ExtractFileName(filename) ) then
      begin
        lvFiles.Selected.Delete;
        lvFiles.ItemIndex := NewIndex;
        FStrUndoSrcFilename := path + ExtractFileName(filename);
        FStrUndoDestFilename := filename;
      end
      else
        ShowMessage('移動に失敗しました');
  end;

end;

procedure TMainForm.HelpAboutBoxExecute(Sender: TObject);
begin
  AboutBox := TAboutBox.CreateParented(Handle);
  AboutBox.ShowModal;
  AboutBox.Free;
end;

procedure TMainForm.miAutoLabelClick(Sender: TObject);
begin
  if miAutoLabel.Checked then
    miAutoLabel.Checked := false
  else
    miAutoLabel.Checked := true;
end;

procedure TMainForm.SettingOpenDialogExecute(Sender: TObject);
begin
  SettingDlg.ShowModal;
  AppGlobal.LoadSetting;
  LoadSetting;
end;

procedure TMainForm.ViewReloadExecute(Sender: TObject);
begin
  // リスト、ツリーの初期化
  BuildDriveListEx;

  if (txtPath.Text = '') then
    cbexDrive.OnChange(cbexDrive);

  OpenDirectory(txtPath.Text);

end;

procedure TMainForm.miSimpleHelpClick(Sender: TObject);
begin
  if miSimpleHelp.Checked then
    miSimpleHelp.Checked := false
  else
    miSimpleHelp.Checked := true;

  ShortcutListForm.Visible := miSimpleHelp.Checked;
end;

procedure TMainForm.ViewWaveFormExecute(Sender: TObject);
begin
  WaveViewForm.Visible := ViewWaveForm.Checked;
end;

procedure TMainForm.SetAutoCompleteEdit;
type
  SHAUTOCOMPLETE = function(hwndEdit:HWND; dwFlags:DWORD):HRESULT;stdcall;
const
  SHACF_FILESYSTEM = $00000001;  // This includes the File System as well as the rest of 
var
  SHAutoCompleteAPI: SHAUTOCOMPLETE;
  hSHlwapi: DWORD;
begin
  hSHlwapi := LoadLibrary('SHLWAPI.DLL');
  if (hSHlwapi <> NULL) then
  begin
      SHAutoCompleteAPI := SHAUTOCOMPLETE( GetProcAddress(hSHlwapi, 'SHAutoComplete') );
      if Assigned(SHAutoCompleteAPI) then
          SHAutoCompleteAPI(txtPath.Handle, 0);
      FreeLibrary(hSHlwapi);
  end;
end;

procedure TMainForm.txtPathKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  dir: String;
begin
  if (Key = VK_RETURN) then
  begin
    dir := txtPath.Text;
    if not DirectoryExists(dir) then
      dir := ExtractFilePath(dir);
    OpenDirectory(dir);
    Key := 0;
  end;
end;

procedure TMainForm.tvDirectoryCompare(Sender: TObject; Node1,
  Node2: TTreeNode; Data: Integer; var Compare: Integer);
begin
  Compare := MyCompare(Node1.Text, Node2.Text);
end;

procedure TMainForm.FileListUndoDeleteExecute(Sender: TObject);
var
  i: Integer;
begin
  if FStrUndoSrcFilename = '' then Exit;
  if RenameFile(FStrUndoSrcFilename, FStrUndoDestFilename ) then
  begin
    i := lvFiles.ItemIndex;
    ViewReload.Execute;
    lvFiles.ItemIndex := i;
    lvFiles.Selected.Focused := true;
    if lvFiles.ItemIndex < lvFiles.Items.Count - 1 then
      lvFiles.Items[lvFiles.ItemIndex+1].MakeVisible(false);
    FStrUndoSrcFilename := '';
  end
  else
    ShowMessage('移動に失敗しました');
end;

procedure TMainForm.tvDirectoryKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
    begin
      tvDirectoryClick(Sender);
      Key := 0;
    end;
  end;
  KeyDownFocusMove(Sender, Key, Shift);
end;

procedure TMainForm.ControlBar1Resize(Sender: TObject);
begin
  Main_ToolBar.ClientWidth := ControlBar1.ClientWidth;
  ToolBar2.ClientWidth := ControlBar1.ClientWidth;
  tbPlayPosition.ClientWidth := ControlBar1.ClientWidth;

  txtPath.Width := ToolBar2.ClientWidth - tbtnOpenPath.Width;
end;

procedure TMainForm.KeyDownFocusMove(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not (ssAlt in Shift) then Exit;

  case Key of
    VK_UP:
    begin
      Key := 0;
      cbexDrive.SetFocus;
    end;
    VK_RIGHT:
    begin
      tvDirectoryClick(Sender);
      if lvFiles.Items.Count > 0 then
      begin
        lvFiles.SetFocus;
        if lvFiles.ItemIndex < 0 then lvFiles.ItemIndex := 0;
        Key := 0;
      end;
    end;
    VK_LEFT, VK_DOWN:
    begin
      tvDirectory.SetFocus;
      Key := 0;
    end;
  end;
end;

initialization
  OleInitialize( nil );
finalization
  OleUnInitialize;

end.
