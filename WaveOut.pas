unit WaveOut;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
Dialogs, MMSystem, StdCtrls, Buttons;

const
  HEAP_ZERO_MEMORY = $00000008;
  WM_WAVEOUT = WM_USER + 1;

type
  TWaveOutOnOpen = procedure of object;
  TWaveOutOnDone = procedure(lpHdr: PWaveHdr) of object;
  TWaveOutOnClose = procedure of object;

  TWavOut = class
  private
    FhWavOut: HWAVEOUT;
    FpWavEhdr: TWAVEHDR;
    FWaveFmt: TWaveFormatEx;  //データ情報
    FbStereo: Boolean;
    FnSampling: Integer;
    FnBit: Integer;
    FnStartTime: Cardinal;

    FbPlaying: Boolean;
    FbOpened: Boolean;
    FbUseTimer: Boolean;

    FOnClose: TWaveOutOnClose;
    FOnDone: TWaveOutOnDone;
    FOnOpen: TWaveOutOnOpen;
    procedure SetOnClose(const Value: TWaveOutOnClose);
    procedure SetOnDone(const Value: TWaveOutOnDone);
    procedure SetOnOpen(const Value: TWaveOutOnOpen);
    function GetPosition: Cardinal;
    procedure SetBit(const Value: Integer);
    procedure SetSampling(const Value: Integer);
    function GetVolume: WORD;
    procedure SetVolume(const Value: WORD);
  protected
    procedure Done(lpHdr: PWAVEHDR);
  public
    constructor Create;
    destructor Destroy;override;
    procedure Open;
    procedure Play(lpData: PAnsiChar; dwLength: DWORD);
    procedure Stop;
    procedure Close;
    procedure WaveOutProc(uMsg: UINT; dwParam: DWORD);
  published
    property OnOpen: TWaveOutOnOpen read FOnOpen write SetOnOpen;
    property OnClose: TWaveOutOnClose read FOnClose write SetOnClose;
    property OnDone: TWaveOutOnDone read FOnDone write SetOnDone;
    property Position: Cardinal read GetPosition;
    property IsPlaying: Boolean read FbPlaying;
    property Sampling: Integer read FnSampling write SetSampling;
    property Bit: Integer read FnBit write SetBit;
    property Stereo: Boolean read FbStereo write FbStereo;
    property Volume: WORD read GetVolume write SetVolume;
    property UseTimer: Boolean read FbUseTimer write FbUseTimer;
  end;

implementation
uses
  Math;
//  WAVEOUT デバイスが投げるメッセージへのハンドラ
//  このハンドラ内では使用できる関数が限られる。
// WAVEの再生状況を受け取るコールバック関数
procedure waveOutFunc( hwo: HWAVEOUT; uMsg: UINT; dwInstance,
dwParam1, dwParam2: DWORD); stdcall;
var
  wave: TWavOut;
begin
  wave := TWavOut(dwInstance);
  wave.WaveoutProc(uMsg, dwParam1);
end;

procedure TWavOut.WaveoutProc(uMsg: UINT; dwParam: DWORD);
begin
  case uMsg of
    WOM_DONE:
    begin
      Done(PWaveHdr(dwParam));
      if Assigned(FOnDone) then FOnDone(PWaveHdr(dwParam));
    end;
    WOM_OPEN: if Assigned(FOnOpen) then FOnOpen;
    WOM_CLOSE: if Assigned(FOnClose) then FOnClose;
  end;
end;

constructor TWavOut.Create;
begin
  FOnOpen := nil;
  FOnClose := nil;
  FOnDone := nil;

//  FhWavOut := 0;

  FnSampling := 16000;
  FnBit := 16;
  FbStereo := false;

  FbPlaying := false;
  FbOpened := false;
  FbUseTimer := false;
end;

destructor TWavOut.Destroy;
begin
  if FhWavOut <> 0 then Close;
  inherited;
end;

procedure TWavOut.Close;
begin
  if FbPlaying then Stop;
  waveOutReset(FhWavOut);
  waveOutUnprepareHeader(FhWavOut, @FpWavEhdr, SizeOf(WAVEHDR));
  waveOutClose(FhWavOut);
  FbOpened := false;
//  FhWavOut := 0;
end;

procedure TWavOut.Open;
var
   mmres: MMRESULT;
begin
  if FbOpened then Close;
  FbOpened := false;

  FillChar(FWaveFmt, SizeOf(TWaveFormatEx), 0); 
  With FWaveFmt do
  begin
    cbSize          := 0;
    wFormatTag      := WAVE_FORMAT_PCM;
    nChannels       := IfThen(FbStereo, 2, 1);
    nSamplesPerSec  := FnSampling;
    wBitsPerSample  := FnBit;
    nBlockAlign     := nChannels * Ceil(wBitsPerSample / 8);
    nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
  end;
  mmres := waveOutOpen(@FhWavOut,
                        WAVE_MAPPER,
                        PWaveFormatEx(@FWaveFmt),
                        DWORD(@waveOutFunc),
                        Cardinal(Pointer(Self)),
                        CALLBACK_FUNCTION);
  if mmres <> MMSYSERR_NOERROR then
  begin
//      HeapFree(GetProcessHeap, 0, FpSubchunk);
//      HeapFree(GetProcessHeap, 0, FpData);
      MessageDlg('ERROR "waveOutOpen" ', mtError, [mbOK], 0);
      Exit;
  end;
end;

procedure TWavOut.Play(lpData: PAnsiChar; dwLength: DWORD);
var
   mmres: MMRESULT;
   text: array[0..255] of Char;
begin
  if FbPlaying then Stop;

  FillChar(FpWaveHdr, SizeOf(TWAVEHDR), 0); 
   // WAVEHDRバッファの割り当て
//   FpWavEhdr := HeapAlloc(GetProcessHeap, HEAP_ZERO_MEMORY, SizeOf
//(WAVEHDR));

  FpWavEhdr.lpData := lpData;
  FpWavEhdr.dwBufferLength := dwLength;
  FpWavEhdr.dwFlags := WHDR_BEGINLOOP or WHDR_ENDLOOP;
  FpWavEhdr.dwLoops := 1;

  mmres := waveOutPrepareHeader(FhWavOut, @FpWavEhdr, SizeOf(WAVEHDR));
  waveOutPause(FhWavOut);
  if mmres <> MMSYSERR_NOERROR then
  begin
    waveOutGetErrorText(mmres, text, 256);
    MessageDlg('ERROR "waveOutPrepare" ', mtError, [mbOK], 0);
    MessageDlg(text, mtError, [mbOK], 0);
    Exit;
  end;
  mmres := waveOutWrite(FhWavOut, @FpWavEhdr, SizeOf(WAVEHDR));

  if FbUseTimer then FnStartTime := timeGetTime;

  waveOutRestart(FhWavOut);
  waveOutUnPrepareHeader(FhWavOut, @FpWavEhdr, SizeOf(WAVEHDR));
  if mmres <> MMSYSERR_NOERROR then
  begin
    waveOutGetErrorText(mmres, text, 256);
    MessageDlg(text, mtError, [mbOK], 0);
    Exit;
  end;

  FbPlaying := true;
end;

procedure TWavOut.Stop;
begin
  waveOutPause(FhWavOut);
  waveOutReset(FhWavOut);
  FbPlaying := false;
end;

procedure TWavOut.SetOnClose(const Value: TWaveOutOnClose);
begin
  FOnClose := Value;
end;

procedure TWavOut.SetOnDone(const Value: TWaveOutOnDone);
begin
  FOnDone := Value;
end;

procedure TWavOut.SetOnOpen(const Value: TWaveOutOnOpen);
begin
  FOnOpen := Value;
end;

function TWavOut.GetPosition: Cardinal;
var
  mmt: MMTime;
begin
  if FbUseTimer then
  begin
    Result := Floor((timeGetTime - FnStartTime) * FnSampling * FnBit / 8000);
  end
  else
  begin
    mmt.wType := TIME_BYTES;
    waveOutGetPosition(FhWavOut, @mmt, SizeOf(MMTime));
    Result := mmt.cb;
  end;
end;

procedure TWavOut.Done(lpHdr: PWAVEHDR);
begin
  FbPlaying := false;
end;

procedure TWavOut.SetBit(const Value: Integer);
begin
  FnBit := Value;
end;

procedure TWavOut.SetSampling(const Value: Integer);
begin
  FnSampling := Value;
end;

function TWavOut.GetVolume: WORD;
var
  vol: DWORD;
begin
  waveOutGetVolume(FhWavOut, @vol);
  Result := vol and $0000FFFF;
end;

procedure TWavOut.SetVolume(const Value: WORD);
var
  vol: DWORD;
begin
  vol := (Value shl 16) or Value;
  waveOutSetVolume(FhWavOut, vol);
end;

end.

