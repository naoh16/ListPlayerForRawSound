program ListPlayer;

uses
  Forms,
  FListPlayer in 'FListPlayer.pas' {Form1},
  WaveOut in 'WaveOut.pas',
  ShellIcon in 'ShellIcon.pas',
  htListViewEx in 'htListViewEx.pas',
  Global in 'Global.pas',
  fWaveView in 'fWaveView.pas' {Form2},
  uFileListview in 'uFileListview.pas',
  fAboutBox in 'fAboutBox.pas' {AboutBox},
  fSetting in 'fSetting.pas' {SettingDlg},
  fShortcutList in 'fShortcutList.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ListPlayer for rawfile';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TSettingDlg, SettingDlg);
  Application.Run;
end.
