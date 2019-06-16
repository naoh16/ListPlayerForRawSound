object SettingDlg: TSettingDlg
  Left = 199
  Top = 188
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #35373#23450
  ClientHeight = 234
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 381
    Height = 200
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    ParentColor = True
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 5
      Top = 5
      Width = 371
      Height = 190
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #20840#33324
        object GroupBox2: TGroupBox
          Left = 8
          Top = 96
          Width = 345
          Height = 57
          Caption = #38500#22806#25313#24373#23376
          TabOrder = 0
          object Label1: TLabel
            Left = 8
            Top = 16
            Width = 258
            Height = 12
            Caption = #65290#12459#12531#12510#21306#20999#12426#12289#12489#12483#12488#12388#12365' ('#20363#65306'.txt,.exe,.dll,.com,.log)'
          end
          object txtExcludeExtension: TEdit
            Left = 8
            Top = 32
            Width = 249
            Height = 20
            TabOrder = 0
          end
          object btnDefExcludeExtension: TButton
            Left = 264
            Top = 32
            Width = 75
            Height = 20
            Caption = #27161#28310#12395#25147#12377
            TabOrder = 1
            OnClick = btnDefExcludeExtensionClick
          end
        end
        object chbNoTreeIcon: TCheckBox
          Left = 8
          Top = 8
          Width = 345
          Height = 17
          Caption = #12487#12451#12524#12463#12488#12522#12484#12522#12540#12395#12450#12452#12467#12531#12434#34920#31034#12375#12394#12356'('#20877#36215#21205#24460#26377#21177')'
          TabOrder = 1
        end
        object chbUseTimer: TCheckBox
          Left = 8
          Top = 29
          Width = 345
          Height = 17
          Caption = #20877#29983#20301#32622#12398#21462#24471#12395#12469#12454#12531#12489#12459#12540#12489#12398#26178#38291#12434#20351#12431#12394#12356
          TabOrder = 2
        end
        object chbAutoWavHeader: TCheckBox
          Left = 8
          Top = 73
          Width = 345
          Height = 17
          Caption = #12300'.wav'#12301#12398#12504#12483#12480#12434#33258#21205#12391#36969#29992#12377#12427
          TabOrder = 3
        end
        object chbRawOnlyMode: TCheckBox
          Left = 8
          Top = 51
          Width = 345
          Height = 17
          Caption = 'RAW'#12501#12449#12452#12523#23554#29992#12514#12540#12489
          TabOrder = 4
          OnClick = chbRawOnlyModeClick
        end
      end
      object TabSheet2: TTabSheet
        Caption = #22806#37096#12450#12503#12522
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object txtAppName: TLabeledEdit
          Left = 32
          Top = 88
          Width = 297
          Height = 20
          EditLabel.Width = 24
          EditLabel.Height = 12
          EditLabel.Caption = #21517#21069
          LabelPosition = lpLeft
          TabOrder = 0
          OnChange = txtAppChange
        end
        object txtAppPath: TLabeledEdit
          Left = 32
          Top = 112
          Width = 297
          Height = 20
          EditLabel.Width = 24
          EditLabel.Height = 12
          EditLabel.Caption = #22580#25152
          LabelPosition = lpLeft
          TabOrder = 1
          OnChange = txtAppChange
        end
        object txtAppArgv: TLabeledEdit
          Left = 32
          Top = 136
          Width = 297
          Height = 20
          EditLabel.Width = 24
          EditLabel.Height = 12
          EditLabel.Caption = #24341#25968
          LabelPosition = lpLeft
          TabOrder = 2
          OnChange = txtAppChange
        end
        object btnSetAppPath: TButton
          Left = 336
          Top = 112
          Width = 20
          Height = 20
          Caption = '...'
          TabOrder = 3
          OnClick = btnSetAppPathClick
        end
        object lvApps: TListView
          Left = 0
          Top = 0
          Width = 361
          Height = 81
          Columns = <
            item
              Caption = #21517#21069
              Width = 100
            end
            item
              Caption = #22580#25152
              Width = 150
            end
            item
              Caption = #24341#25968
              Width = 100
            end>
          GridLines = True
          HideSelection = False
          ReadOnly = True
          RowSelect = True
          TabOrder = 4
          ViewStyle = vsReport
          OnChange = lvAppsChange
        end
      end
      object TabSheet3: TTabSheet
        Caption = #12501#12449#12452#12523#21066#38500
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object GroupBox1: TGroupBox
          Left = 8
          Top = 8
          Width = 345
          Height = 105
          Caption = #12501#12449#12452#12523#21066#38500
          TabOrder = 0
          object rbFileDeleteD: TRadioButton
            Left = 8
            Top = 16
            Width = 113
            Height = 20
            Caption = #21066#38500
            Checked = True
            TabOrder = 0
            TabStop = True
            OnClick = gbDeleteFileClick
          end
          object rbFileDeleteM: TRadioButton
            Tag = 1
            Left = 8
            Top = 37
            Width = 113
            Height = 20
            Caption = #31227#21205
            TabOrder = 1
            OnClick = gbDeleteFileClick
          end
          object rbFileDeleteNG: TRadioButton
            Tag = 2
            Left = 8
            Top = 58
            Width = 193
            Height = 17
            Caption = #20877#29983#12501#12457#12523#12480#20197#19979#12398'NG'#12501#12457#12523#12480
            TabOrder = 2
            OnClick = gbDeleteFileClick
          end
          object cbDeleteNoDialog: TCheckBox
            Left = 56
            Top = 80
            Width = 201
            Height = 17
            Caption = #21066#38500#12398#26178#12395#12480#12452#12450#12525#12464#12434#20986#12373#12394#12356
            TabOrder = 3
          end
          object txtFileMoveDirectory: TEdit
            Left = 56
            Top = 37
            Width = 257
            Height = 20
            TabOrder = 4
          end
          object btnSetMoveDirectory: TButton
            Left = 312
            Top = 37
            Width = 20
            Height = 20
            Caption = '...'
            TabOrder = 5
            OnClick = btnSetMoveDirectoryClick
          end
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 200
    Width = 381
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object OKBtn: TButton
      Left = 211
      Top = 2
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TButton
      Left = 299
      Top = 2
      Width = 75
      Height = 25
      Cancel = True
      Caption = #12461#12515#12531#12475#12523
      ModalResult = 2
      TabOrder = 1
    end
  end
  object MoveDirectoryOpenDlg: TOpenDialog
    FileName = '[This Directory]'
    Title = #12501#12449#12452#12523#12398#31227#21205#20808#12501#12457#12523#12480#12434#25351#23450
    Left = 24
    Top = 200
  end
  object AppPathOpenDlg: TOpenDialog
    Filter = #23455#34892#12501#12449#12452#12523'(*.exe)|*.exe|'#20840#12390#12398#12501#12449#12452#12523'(*.*)|*.*'
    Left = 72
    Top = 200
  end
end
