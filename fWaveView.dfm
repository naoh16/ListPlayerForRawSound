object Form2: TForm2
  Left = 391
  Top = 109
  BorderIcons = [biSystemMenu]
  Caption = 'WaveView'
  ClientHeight = 246
  ClientWidth = 478
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupWaveView
  OnCanResize = FormCanResize
  OnClose = FormClose
  OnCreate = FormCreate
  OnHide = FormHide
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 12
  object PaintBox1: TPaintBox
    Left = 0
    Top = 24
    Width = 478
    Height = 222
    Align = alClient
    OnPaint = PaintBox1Paint
    ExplicitWidth = 486
    ExplicitHeight = 234
  end
  object WaveView_ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 478
    Height = 24
    ButtonHeight = 20
    ButtonWidth = 20
    Caption = 'WaveView_ToolBar'
    EdgeInner = esNone
    EdgeOuter = esNone
    TabOrder = 0
    DesignSize = (
      478
      24)
    object lblMaxRange: TLabel
      Left = 0
      Top = 0
      Width = 100
      Height = 20
      Alignment = taRightJustify
      Caption = #34920#31034#12377#12427#26368#22823#20516#65306
      Color = clBtnFace
      ParentColor = False
      Layout = tlCenter
    end
    object cmbMaxRange: TComboBox
      Left = 100
      Top = 0
      Width = 80
      Height = 20
      Style = csDropDownList
      ItemIndex = 7
      TabOrder = 0
      Text = '32768'
      OnChange = cmbMaxRangeChange
      Items.Strings = (
        '1000'
        '2000'
        '5000'
        '10000'
        '15000'
        '20000'
        '30000'
        '32768')
    end
    object ToolButton1: TToolButton
      Left = 180
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
    object Label2: TLabel
      Left = 188
      Top = 0
      Width = 70
      Height = 20
      Alignment = taRightJustify
      Caption = ' '#27874#26368#23567#20516' '
      Layout = tlCenter
    end
    object txtWaveMax: TEdit
      Left = 258
      Top = 0
      Width = 50
      Height = 20
      Anchors = [akLeft, akTop, akBottom]
      AutoSize = False
      Color = clBtnText
      Constraints.MaxHeight = 20
      Constraints.MinHeight = 12
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clBtnFace
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = 'txtWaveMax'
    end
    object Label1: TLabel
      Left = 308
      Top = 0
      Width = 70
      Height = 20
      Alignment = taRightJustify
      Caption = ' '#27874#26368#22823#20516' '
      Layout = tlCenter
    end
    object txtWaveMin: TEdit
      Left = 378
      Top = 0
      Width = 50
      Height = 20
      Anchors = [akLeft, akTop, akBottom]
      Color = clBtnText
      Constraints.MaxHeight = 20
      Constraints.MinHeight = 20
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clBtnFace
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      Text = 'txtWaveMin'
    end
  end
  object PopupWaveView: TPopupMenu
    Left = 168
    Top = 72
    object miSetMaxWidth: TMenuItem
      Caption = #27178#24133#12434#12487#12473#12463#12488#12483#12503#12398#24133#12395#21512#12431#12379#12427
      OnClick = miSetMaxWidthClick
    end
    object miViewToolbar: TMenuItem
      AutoCheck = True
      Caption = #12484#12540#12523#12496#12540#34920#31034
      Checked = True
      OnClick = miViewToolbarClick
    end
  end
end
