unit fWaveView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus, Spin, ToolWin, ComCtrls;

const
  DefaultCaption = 'WaveView';
  LineNumArray: array[0..3, 0..5] of Integer
      = ((10000, -10000, 20000, -20000, 30000, -30000),
         (5000, -5000, 10000, -10000, 15000, -15000),
         (2500, -2500, 5000, -5000, 7500, -7500),
         (500, -500, 1000, -1000, 1500, -1500)
        );
  
type
  PSmallInt = ^SmallInt;
  PSingle   = ^Single;
  PDouble   = ^Double;

  TReadDataFunc = function(data: PByteArray; Index: Integer): SmallInt;

  TWaveViewForm = class(TForm)
    PaintBox1: TPaintBox;
    PopupWaveView: TPopupMenu;
    miSetMaxWidth: TMenuItem;
    WaveView_ToolBar: TToolBar;
    lblMaxRange: TLabel;
    cmbMaxRange: TComboBox;
    Label1: TLabel;
    txtWaveMax: TEdit;
    Label2: TLabel;
    txtWaveMin: TEdit;
    ToolButton1: TToolButton;
    miViewToolbar: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure miSetMaxWidthClick(Sender: TObject);
    procedure cmbMaxRangeChange(Sender: TObject);
    procedure miViewToolbarClick(Sender: TObject);
  private
    { Private êÈåæ }
    FSampling: Integer;
    FBytePerSec: Integer;
    FbDrawLabel: Boolean;
    FnMaxRange: Integer;
    FnLastMaxWaveData: Integer;
    FnLastMinWaveData: Integer;
    FnImageCenter: Integer;
    FlinePos: array of integer;//(89, 167, 50, 206, 11, 246);
    FlineStr: array of string;
    FnOldLinePos: Integer;
    data: array of Byte;
    len: Integer;
    labelData: array of Real;
    lastFilename: String;
    divnum: Real;
    waveimg: TBitmap;

    ReadData: TReadDataFunc;
    
    procedure ReadLabelFile(filename: String);
    procedure SetDrawBaseLine;
    procedure WMEraseBkGnd(var vMsg: TWMEraseBkGnd);message WM_ERASEBKGND;
    
  public
    { Public êÈåæ }
    procedure SetParameter(nBit, nSampling: Integer; bDrawLabel: Boolean);
//    procedure WMEraseBkGnd(var vMsg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure DrawGraphBase;
    procedure DrawWaveGraph; overload;
    procedure DrawWaveGraph(const filename:String; lpData: Pointer; dwLength: DWORD); overload;
    procedure DrawPlayLine(pos: cardinal);
  end;

  function ReadData8(data: PByteArray; Index: Integer): SmallInt;
  function ReadData16(data: PByteArray; Index: Integer): SmallInt;
  function ReadData32(data: PByteArray; Index: Integer): SmallInt;
  function ReadData64(data: PByteArray; Index: Integer): SmallInt;

implementation
uses
  Math, FListPlayer;

{$R *.dfm}

procedure TWaveViewForm.FormCreate(Sender: TObject);
begin
  data := nil;
  len := 0;
  labelData := nil;
  lastFilename := '';
  FSampling := 16000;
  FBytePerSec := 2;
  FbDrawLabel := false;
  FnMaxRange := 32768;
  FnLastMaxWaveData := -32768;
  FnLastMinWaveData := 32768;
  FnOldLinePos := 0;
//  divnum := IfThen(Width>len,Width,len/Width);
  divnum := PaintBox1.Width;
  waveimg := TBitmap.Create;
  PaintBox1.ControlStyle := PaintBox1.ControlStyle + [csOpaque];
//  DoubleBuffered := true;
  SetDrawBaseLine;

end;

procedure TWaveViewForm.FormDestroy(Sender: TObject);
begin
  // Ç±Ç±Ç≈èàóùÇ∑ÇÈÇ∆ÉGÉâÅ[Ç…Ç»ÇÈÇ¡Ç€Ç¢?
  if Assigned(waveimg) then
    waveimg.Free;
  SetLength(data, 0);
  SetLength(labelData, 0);
end;

procedure TWaveViewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  if Assigned(data) then
//    FreeMem(data);
//  if Assigned(labelData) then
//    FreeMem(labelData);
end;

procedure TWaveViewForm.FormHide(Sender: TObject);
begin
  if Assigned(MainForm.tbtnViewWave) then
    MainForm.tbtnViewWave.Down := false;
end;

procedure TWaveViewForm.DrawWaveGraph(const filename: String; lpData: Pointer; dwLength: DWORD);
begin
  if lastFilename <> filename then
  begin
    try
      SetLength(data, dwLength);
      
      CopyMemory(data, lpData, dwLength);
      len := Floor(dwLength / FBytePerSec);
      lastFilename := filename;
      if FbDrawLabel then
        ReadLabelFile(filename)
      else
        SetLength(labelData, 0);
      Caption := DefaultCaption + ' - ' + filename;
    except
      on e: EOutOfMemory do
      begin
        ShowMessage(e.Message);
        //FreeMem(data);
        len := 0;
      end;
    end;
  end;

  DrawWaveGraph;
end;

procedure TWaveViewForm.DrawPlayLine(pos: cardinal);
var
  xpos: Integer;
  r: TRect;
begin
//  PaintBox1.Refresh;
  r := Rect(FnOldLinePos-20, 0, FnOldLinePos+20, PaintBox1.Height);
  PaintBox1.Canvas.CopyRect(r, waveimg.Canvas, r);

  xpos := Ceil(pos / FBytePerSec / divnum);
  With PaintBox1.Canvas do
  begin
      Pen.Color := clRed;
      // çƒê∂à íuÇï\Ç∑ècê¸Çï`âÊ
      PolyLine([Point(xpos, 0), Point(xpos, PaintBox1.Height)]);
  end;
  FnOldLinePos := xpos;
end;

procedure TWaveViewForm.DrawGraphBase;
var
  strOffset: integer;
  i, t, num, sample: Integer;
begin
  waveimg.FreeImage;
  waveimg.Width := PaintBox1.Width;
  waveimg.Height := PaintBox1.Height;
  With waveimg.Canvas do
  begin
    Pen.Color := clWhite;
    Brush.Color := clWhite;
    FillRect(ClientRect);

    // â°ê¸Åiècé≤ÅFêUïùÅjï`âÊ
    Pen.Style := psSolid;
    Pen.Color := clMaroon;
    PolyLine([Point(0, FnImageCenter), Point(Width, FnImageCenter)]);
    Pen.Color := clLtGray;
    Pen.Style := psDash;

    Font.Height := 16;
    Font.Color := clLtGray;
    strOffset := Floor(Font.Height/2);

    for i := Low(FlinePos) to High(FlinePos) do
    begin
      TextOut(0, FlinePos[i] - strOffset, FlineStr[i]);
      Polyline([Point(5, FlinePos[i]), Point(Width, FlinePos[i])]); // 128 - (10000 / 256 = 39.06)
    end;

    // ècê¸Åiâ°é≤ÅFéûä‘Åjï`âÊ
    if len > 0 then
    begin
      t := Floor(FSampling * Width / len);  // 1ïbä‘äu
      num := Floor(Width / t);
      sample := 2;
      if( num < 1000 )then
      begin
        if num < 6 then
        begin
          t := Ceil(t / 2);      // 6ñ{ÇÊÇËâ∫Ç»ÇÁ0.5ïbä‘äuÇ…
          sample := 1;
        end
        else if num > 20 then
        begin
          t := t*2;       //20ñ{ÇÊÇËè„Ç»ÇÁ2.0ïbä‘äu
          sample := 4;
        end
        else if num > 50 then
        begin
          t := t*5;       //50ñ{ÇÊÇËè„Ç»ÇÁ5.0ïbä‘äu
          sample := 10;
        end;
        Pen.Style := psDot;
        num := Floor(Width / t);    // çƒåvéZ
        for i := 1 to num do
        begin
          TextOut(t*i+1, PaintBox1.Height-Font.Height, Format('%2.1f', [i*sample/2]));
          PolyLine([Point(t*i, 0), Point(t*i, PaintBox1.Height)]);
        end;
      end;
    end;
  end;
//  PaintBox1.Refresh;
end;

procedure TWaveViewForm.DrawWaveGraph;
var
  i, k, h: Integer;
  j: Real;
  xpos: Integer;
  maxData: Smallint;
  minData: Smallint;
  tempData: SmallInt;
//  divnum: integer;
begin
  DrawGraphBase;
  h := PaintBox1.Height;
//  With PaintBox1.Canvas do
  With waveimg.Canvas do
  begin
    Font.Height := 12;
    Font.Color := clBlue;
    if(len > 0) then
    begin
      Pen.Color := clBlack;
      Pen.Style := psSolid;
      FnLastMaxWaveData := -32768;
      FnLastMinWaveData := 32768;
      maxData := -32766;
      minData := 32765;
      j := 0.0;
      k := 0;
//      divnum := IfThen(Width>len,Width,Ceil((len)/Width));
      divnum := IfThen(Width>len,Width,(len-1)/Width);
      // ÉoÉCÉgêîÇ©ÇÁì«Ç›Ç∆ÇËä÷êîê›íË
      case FBytePerSec of
        1: ReadData := ReadData8;
        2: ReadData := ReadData16;
        4: ReadData := ReadData32;
        8: ReadData := ReadData64;
      else
        begin
          ShowMessage('ñ¢ëŒâûÇÃÉrÉbÉgêîÇ≈Ç∑');
          Exit;
        end;
      end;

      for i:=0 to len - 1 do
      begin
        tempData := ReadData(PByteArray(data), i);

        if(maxData < tempData) then maxData := tempData
        else if(minData > tempData) then minData := tempData;
//        maxData := Max(tempData, maxData);
//        minData := Min(tempData, minData);

        if j > divnum then
        begin
          // ê¸Çà¯Ç≠
          xpos := Floor(i/divnum);
          MoveTo(xpos, FnImageCenter - Ceil(minData * h / FnMaxRange / 2));
          LineTo(xpos, FnImageCenter - Ceil(maxData * h / FnMaxRange / 2));

          // Max, MinílÇäoÇ¶ÇƒÇ®Ç≠
          FnLastMaxWaveData := Max(FnLastMaxWaveData, maxData);
          FnLastMinWaveData := Min(FnLastMinWaveData, minData);

          maxData := tempData;
          minData := tempData;
          j := j - divnum;
          if Length(labelData) > k then
          begin
            if labelData[k] < (i / FSampling) then
            begin
              Pen.Color := clBlue;
              Polyline([Point(xpos, FnImageCenter), Point(xpos, 16)]);
              TextOut(xpos, 16, FormatFloat('0.000', labelData[k]));
              Pen.Color := clBlack;
              Inc(k);
            end;  // if labelData[k] < (i / FSampling) then
          end;    // if Length(labelData) > k then
        end;      // if j > divnum then
        j := j + 1.0;
//        if i mod 1048576 = 1 then PaintBox1.Refresh;
      end;        // for i:=0 to len - 1 do
      // écÇËÇï`âÊ
      MoveTo(Floor(len/divnum), FnImageCenter - Ceil(minData * h / FnMaxRange / 2));
      LineTo(Floor(len/divnum), FnImageCenter - Ceil(maxData * h / FnMaxRange / 2));
    end;
    PaintBox1.Refresh;
  end;
end;

procedure TWaveViewForm.PaintBox1Paint(Sender: TObject);
begin
  if Assigned(waveimg) then
    PaintBox1.Canvas.Draw(0,0,waveimg);

  if(Max(Abs(FnLastMaxWaveData), Abs(FnLastMinWaveData)) > FnMaxRange) then
    lblMaxRange.Font.Color := clHotLight
  else
    lblMaxRange.Font.Color := clWindowText;
  
  txtWaveMax.Text := IntToStr(FnLastMaxWaveData);
  txtWaveMin.Text := IntToStr(FnLastMinWaveData);
end;

procedure TWaveViewForm.WMEraseBkGnd(var vMsg: TWMEraseBkGnd);
begin
//  vMsg.Result := 1; // ÉtÉHÅ[ÉÄÇÃîwåiÇåªç›ÇÃÉuÉâÉVÇ≈ìhÇËÇ¬Ç‘Ç≥Ç»Ç¢
end;

procedure TWaveViewForm.FormResize(Sender: TObject);
begin
  divnum := IfThen(Width>len,Width,len/Width);
  SetDrawBaseLine;
  DrawWaveGraph;
end;

procedure TWaveViewForm.ReadLabelFile(filename: String);
var
  i,j: Integer;
  labelfile: String;
  labelExt: TStringList;
  nextFlag: Boolean;
  tmpStr: String;
  tmpStrL: TStringList;
begin
  labelExt := TStringList.Create;
  labelExt.CommaText := '.txt,.lab';
  nextFlag := False;
  for i :=0  to labelExt.Count-1 do
  begin
    labelfile := ChangeFileExt(filename, labelExt[i]);
    if FileExists( labelfile ) then
    begin
      nextFlag := True;
      Break;
    end;
  end;
  labelExt.Free;
  if not nextFlag Then Exit;
  
//  labelfile := ChangeFileExt(filename, '.txt');
//  if FileExists( labelfile ) then
  tmpStrL := TStringList.Create;
  With TStringList.Create do
  try
    tmpStrL.Delimiter := Chr(9);
    LoadFromFile(labelfile);
    SetLength(labelData, Count);
    for i:=0 to Count - 1 do
    begin
      tmpStr := Trim(Strings[i]);
      If (tmpStr[1] = '#') Then Continue;
//      try
        tmpStrL.DelimitedText := tmpStr;
        for j:=0 to tmpStrL.Count -1 do
        try
          labelData[i] := StrToFloat(tmpStr[i]);
        except
          on e: EConvertError do ;
        end;
//      except
//        on e: EConvertError do
//        begin
//          ShowMessage(e.Message);
//          SetLength(labelData, 0);
//          Break;
//        end;
//      end;
    end;
  finally
    tmpStrL.Free;
    Free;
  end;
end;

procedure TWaveViewForm.SetParameter(nBit, nSampling: Integer; bDrawLabel: Boolean);
begin
  FSampling := nSampling;
  FBytePerSec := nBit shr 3;  // nBit / 8
  FbDrawLabel := bDrawLabel;
end;

procedure TWaveViewForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  if NewHeight < 100 then
    NewHeight := 100;
//  SetDrawBaseLine;
end;

procedure TWaveViewForm.miSetMaxWidthClick(Sender: TObject);
var
  DeskRect: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @DeskRect, 0);
  Left := DeskRect.Left;
  Width := DeskRect.Right - DeskRect.Left;
  FormResize(nil);
end;

procedure TWaveViewForm.SetDrawBaseLine;
var
  num, i: Integer;
  h, center: Real;
begin
  SetLength(FlinePos, 6);
  SetLength(FLineStr, 6);
  case FnMaxRange of
    10000..29999: num := 1;
    5000..9999: num := 2;
    1000..4999: num := 3;
  else num := 0;
  end;
        
  h := PaintBox1.Height;
  center := h / 2;
  for i := Low(FlinePos) to High(FlinePos) do
  begin
    FlinePos[i] := Floor(center - (h * LineNumArray[num][i] / FnMaxRange)/2);
    FLineStr[i] := IntToStr(LineNumArray[num][i]);
  end;
  FnImageCenter := Floor(center);

end;

procedure TWaveViewForm.cmbMaxRangeChange(Sender: TObject);
begin
  FnMaxRange := StrToInt(cmbMaxRange.Text);
  FormResize(nil);
end;

procedure TWaveViewForm.miViewToolbarClick(Sender: TObject);
begin
  WaveView_ToolBar.Visible := miViewToolBar.Checked;
  FormResize(nil);
end;

function ReadData8(data: PByteArray; Index: Integer): SmallInt;
begin
  Result := (data[Index] - 128) * 256; // 2^15 / 2^7 = 2^8
end;

function ReadData16(data: PByteArray; Index: Integer): SmallInt;
begin
  Result := PSmallInt(@data[Index*2])^;
end;

function ReadData32(data: PByteArray; Index: Integer): SmallInt;
var
  tmp: Real;
begin
  tmp := PSingle(@data[Index*4])^;
  Result := Floor(tmp);
end;

function ReadData64(data: PByteArray; Index: Integer): SmallInt;
var
  tmp: Real;
begin
  tmp := PDouble(@data[Index*8])^;
  Result := Floor(tmp);
end;


end.
