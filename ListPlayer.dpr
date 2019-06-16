program ListPlayer;

uses
  Forms,
  FListPlayer in 'FListPlayer.pas' {MainForm},
  WaveOut in 'WaveOut.pas',
  ShellIcon in 'ShellIcon.pas',
  htListViewEx in 'htListViewEx.pas',
  Global in 'Global.pas',
  fWaveView in 'fWaveView.pas' {WaveViewForm},
  uFileListview in 'uFileListview.pas',
  fAboutBox in 'fAboutBox.pas' {AboutBox},
  fSetting in 'fSetting.pas' {SettingDlg},
  fShortcutList in 'fShortcutList.pas' {ShortbutListForm},
  SoundFile in 'SoundFile.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ListPlayer for rawfile';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSettingDlg, SettingDlg);
  Application.Run;
end.
