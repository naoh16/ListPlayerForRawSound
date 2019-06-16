object Form1: TForm1
  Left = 234
  Top = 109
  Caption = 'ListPlayer for RawFile'
  ClientHeight = 411
  ClientWidth = 718
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Splitter1: TSplitter
    Left = 185
    Top = 0
    Width = 4
    Height = 392
    ExplicitHeight = 405
  end
  object LeftPanel: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 392
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object tvDirectory: TTreeView
      Left = 0
      Top = 20
      Width = 185
      Height = 372
      Align = alClient
      HideSelection = False
      Indent = 19
      ReadOnly = True
      RowSelect = True
      SortType = stText
      TabOrder = 1
      OnClick = tvDirectoryClick
      OnCollapsed = tvDirectoryCollapsed
      OnCompare = tvDirectoryCompare
      OnExpanded = tvDirectoryExpanded
      OnKeyDown = tvDirectoryKeyDown
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 20
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      OnResize = Panel1Resize
      object cbexDrive: TComboBoxEx
        Left = 0
        Top = -1
        Width = 185
        Height = 21
        ItemsEx = <>
        Style = csExDropDownList
        TabOrder = 0
        OnChange = cbxDriveChange
        OnKeyDown = KeyDownFocusMove
      end
    end
  end
  object RightPanel: TPanel
    Left = 189
    Top = 0
    Width = 529
    Height = 392
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object RBottomPanel: TPanel
      Left = 0
      Top = 80
      Width = 529
      Height = 312
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitTop = 82
      ExplicitHeight = 310
      object xlvFiles: TListView
        Left = -8
        Top = 24
        Width = 347
        Height = 292
        Checkboxes = True
        Columns = <
          item
            Caption = #12501#12449#12452#12523#21517
            Width = 300
          end
          item
            Caption = #12501#12449#12452#12523#12469#12452#12474
            Width = 150
          end>
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        PopupMenu = PopupFileList
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = xlvFilesChange
        OnClick = xlvFilesClick
        OnDblClick = xlvFilesDblClick
        OnKeyDown = xlvFilesKeyDown
      end
    end
    object ControlBar1: TControlBar
      Left = 0
      Top = 0
      Width = 529
      Height = 80
      Align = alTop
      AutoSize = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnResize = ControlBar1Resize
      object tbPlayPosition: TTrackBar
        Left = 11
        Top = 28
        Width = 511
        Height = 22
        Hint = #29694#22312#12398#20877#29983#20301#32622
        Align = alBottom
        Enabled = False
        Constraints.MinHeight = 20
        Constraints.MinWidth = 100
        TabOrder = 0
        ThumbLength = 12
      end
      object Main_ToolBar: TToolBar
        Left = 11
        Top = 2
        Width = 511
        Height = 20
        Anchors = [akLeft, akRight]
        AutoSize = True
        ButtonHeight = 20
        ButtonWidth = 21
        Caption = 'Main_ToolBar'
        Constraints.MinHeight = 20
        Constraints.MinWidth = 100
        Images = ImageList1
        TabOrder = 1
        Wrapable = False
        DesignSize = (
          511
          20)
        object cbStereo: TCheckBox
          Left = 0
          Top = 0
          Width = 60
          Height = 20
          Hint = #12481#12455#12483#12463#12377#12427#12392#12473#12486#12524#12458#12392#12375#12390#35501#12415#36796#12415#12414#12377
          Align = alClient
          Caption = 'Stereo'
          TabOrder = 1
        end
        object cbSwap: TCheckBox
          Left = 60
          Top = 0
          Width = 54
          Height = 20
          Hint = #12481#12455#12483#12463#12377#12427#12392#12487#12540#12479#12434#12473#12527#12483#12503#12375#12390#35501#12415#36796#12415#12414#12377
          Align = alClient
          Caption = 'Swap'
          TabOrder = 0
        end
        object cbxBit: TComboBox
          Left = 114
          Top = 0
          Width = 44
          Height = 20
          Hint = #12499#12483#12488#25968'(BitPerSample)'
          Style = csDropDownList
          Anchors = [akLeft, akTop, akBottom]
          ItemIndex = 1
          TabOrder = 2
          Text = '16'
          Items.Strings = (
            '8'
            '16'
            '32'
            '64')
        end
        object cbxSampling: TComboBox
          AlignWithMargins = True
          Left = 158
          Top = 0
          Width = 60
          Height = 20
          Hint = #12469#12531#12503#12522#12531#12464#12524#12540#12488'(SamplingPerSecond)'
          Anchors = [akLeft, akTop, akBottom]
          TabOrder = 3
          Text = '16000'
          Items.Strings = (
            '8000'
            '11025'
            '16000'
            '22050'
            '24000'
            '32000'
            '44100'
            '48000'
            '96000')
        end
        object ToolButton3: TToolButton
          Left = 218
          Top = 0
          Width = 10
          Caption = 'ToolButton3'
          ImageIndex = 3
          Style = tbsSeparator
        end
        object txtFilter: TEdit
          Left = 228
          Top = 0
          Width = 56
          Height = 20
          Hint = #12501#12449#12452#12523#12522#12473#12488#12398#12501#12451#12523#12479
          Anchors = [akLeft, akTop, akBottom]
          TabOrder = 4
          Text = '*.*'
          OnChange = txtFilterChange
        end
        object ToolButton1: TToolButton
          Left = 284
          Top = 0
          Width = 10
          Caption = 'ToolButton1'
          Style = tbsSeparator
        end
        object btnPlayAll: TToolButton
          Left = 294
          Top = 0
          Caption = 'btnPlayAll'
          ImageIndex = 0
          OnClick = btnPlayAllaClick
        end
        object btnStop: TToolButton
          Left = 315
          Top = 0
          Caption = 'btnStop'
          Enabled = False
          ImageIndex = 1
          OnClick = btnStopaClick
        end
        object tbMasterVolume: TTrackBar
          Left = 336
          Top = 0
          Width = 93
          Height = 20
          Hint = #12510#12473#12479#12540#12508#12522#12517#12540#12512#12398#35373#23450#12434#12375#12414#12377
          Max = 65535
          PageSize = 100
          Frequency = 8196
          Position = 60000
          TabOrder = 5
          ThumbLength = 10
        end
        object ToolButton2: TToolButton
          Left = 429
          Top = 0
          Width = 10
          Caption = 'ToolButton2'
          ImageIndex = 0
          Style = tbsSeparator
        end
        object tbtnViewWave: TToolButton
          Left = 439
          Top = 0
          Action = ViewWaveForm
          ImageIndex = 2
          Style = tbsCheck
        end
      end
      object ToolBar2: TToolBar
        Left = 11
        Top = 54
        Width = 512
        Height = 20
        Anchors = [akLeft, akRight]
        AutoSize = True
        ButtonHeight = 20
        ButtonWidth = 21
        Caption = 'ToolBar2'
        Constraints.MinHeight = 20
        Constraints.MinWidth = 100
        Images = ImageList1
        TabOrder = 2
        Wrapable = False
        object txtPath: TEdit
          Left = 0
          Top = 0
          Width = 433
          Height = 20
          Hint = #29694#22312#38283#12356#12390#12356#12427#12497#12473
          TabOrder = 0
          OnKeyDown = txtPathKeyDown
        end
        object tbtnOpenPath: TToolButton
          Left = 433
          Top = 0
          Hint = #12456#12463#12473#12503#12525#12540#12521#12391#38283#12367
          HelpType = htKeyword
          Action = ToolBarOpenPath
          ImageIndex = 3
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 392
    Width = 718
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object PopupFileList: TPopupMenu
    OnPopup = PopupFileListPopup
    Left = 344
    Top = 232
    object N2: TMenuItem
      Tag = -1
      Action = FileListPlayThis
      Default = True
    end
    object N1: TMenuItem
      Tag = -1
      Action = FileListPlayFromHere
    end
    object N3: TMenuItem
      Tag = -1
      Caption = '-'
    end
    object D1: TMenuItem
      Tag = -1
      Action = FileListDeleteFile
      ShortCut = 46
    end
    object Z1: TMenuItem
      Action = FileListUndoDelete
    end
    object N5: TMenuItem
      Tag = -1
      Caption = '-'
    end
  end
  object ActionList1: TActionList
    Left = 272
    Top = 152
    object FileListPlayFromHere: TAction
      Category = 'FileList'
      Caption = #36984#25246#20301#32622#12363#12425#20877#29983
      OnExecute = FileListPlayFromHereExecute
    end
    object ToolBarOpenPath: TAction
      Category = 'ToolBar'
      Caption = #12456#12463#12473#12503#12525#12540#12521#12391#38283#12367
      OnExecute = ToolBarOpenPathExecute
    end
    object FileListPlayThis: TAction
      Category = 'FileList'
      Caption = #12371#12398#12501#12449#12452#12523#12434#20877#29983
      OnExecute = FileListPlayThisExecute
    end
    object FileListDeleteFile: TAction
      Category = 'FileList'
      Caption = #12501#12449#12452#12523#12434#21066#38500'(&D)'
      OnExecute = FileListDeleteFileExecute
    end
    object HelpAboutBox: TAction
      Category = 'Help'
      Caption = #12496#12540#12472#12519#12531#24773#22577'(&A)'
      OnExecute = HelpAboutBoxExecute
    end
    object SettingOpenDialog: TAction
      Category = 'Setting'
      Caption = #35373#23450'...(&S)'
      OnExecute = SettingOpenDialogExecute
    end
    object ViewReload: TAction
      Category = 'View'
      Caption = #26368#26032#12398#24773#22577#12395#26356#26032'(&R)'
      OnExecute = ViewReloadExecute
    end
    object ViewWaveForm: TAction
      Category = 'View'
      AutoCheck = True
      Caption = #27874#24418#12454#12451#12531#12489#12454#34920#31034
      OnExecute = ViewWaveFormExecute
    end
    object FileListUndoDelete: TAction
      Category = 'FileList'
      Caption = #12450#12531#12489#12453'(&Z)'
      ShortCut = 16474
      OnExecute = FileListUndoDeleteExecute
    end
  end
  object MainMenu1: TMainMenu
    Left = 136
    Top = 72
    object Show1: TMenuItem
      Caption = #34920#31034'(&V)'
      object N6: TMenuItem
        Action = ViewReload
        ShortCut = 116
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object ViewWaveForm1: TMenuItem
        Action = ViewWaveForm
        AutoCheck = True
      end
    end
    object S1: TMenuItem
      Caption = #35373#23450'(&S)'
      object S2: TMenuItem
        Action = SettingOpenDialog
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object miAutoLabel: TMenuItem
        Caption = #33258#21205#12521#12505#12523'(&E)'
        Checked = True
        OnClick = miAutoLabelClick
      end
    end
    object Help1: TMenuItem
      Caption = #12504#12523#12503'(&H)'
      object miSimpleHelp: TMenuItem
        Caption = #31777#26131#12504#12523#12503#34920#31034
        OnClick = miSimpleHelpClick
      end
      object About1: TMenuItem
        Action = HelpAboutBox
      end
    end
  end
  object ImageList1: TImageList
    Height = 14
    Width = 14
    Left = 352
    Top = 168
    Bitmap = {
      494C01010400090004000E000E00FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000380000001C00000001002000000000008018
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      0000840000008400000084000000840000008400000084000000000000000000
      0000000000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00008484000000000000000000000000000000000000000000FF000000FF00
      0000FF0000008400000084000000000000000000000000000000000000000000
      00000000000000000000000000000000000084840000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000084000000000000000000
      0000000000008400000000000000000000000000000000000000000000000000
      0000848484000000000084848400000000008400000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000FFFF0000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000840000008400000000000000000000000000
      00000000000000000000000000000000000084840000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000084000000000000000000
      0000000000008400000000000000000000000000000000000000C6C6C6000000
      0000000000000000000000000000000000008400000000000000000000000000
      00000084840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000084
      840000FFFF0000FFFF0000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000840000000000
      00000000000000000000000000000000000084840000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000084000000000000000000
      0000000000008400000000000000000084000000840000008400000084000000
      0000000084000000840000008400000084008400000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      000000FFFF0000FFFF0000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      0000FF00000000000000000000000000000084840000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000084000000000000000000
      000000000000840000000000000084848400000000000000000000000000C6C6
      C600000000000000000000000000000000008400000000000000000000000084
      840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000084840000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      00000000000000000000000000000000000084840000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000084000000000000000000
      000000000000840000000000000000000000C6C6C60000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000084
      840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000848400000000
      00000000000000000000000000000000000084840000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000084000000000000000000
      0000000000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000008484000000000000000000000000
      00000000000000000000000000000000000084840000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000084000000000000000000
      0000000000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000FF000000FF00
      0000FF000000FF00000084840000000000000000000000000000000000000000
      00000000000000000000000000000000000084840000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000084000000000000000000
      0000000000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000008400000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000FF000000FF00
      0000FF0000008484000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484000084840000848400008484
      0000848400008484000084840000848400008484000084840000000000000000
      0000000000008400000000FF0000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000008400000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000FF0000008484
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      28000000380000001C0000000100010000000000E00000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FFFFFFFFFFFFFF00DFFFFFF800780100C7FF003BF1700100C1FF003BE4700100
      C07F003BCE600100C01F003800600100C0070038CF400100C00F003A5F400100
      C01F003B3F400100C07F003BFF700100C1FF003800700100C3FF0038007FC100
      CFFFFFF8007FC100FFFFFFFFFFFFFF0000000000000000000000000000000000
      000000000000}
  end
end
