unit SoundFile;

interface
uses
  Classes, MMSystem, System.Math;
type
  TSoundFile = class

  protected
    FBuffer: Pointer;
    FBufferLength: UInt32;  {in bytes}
    FWaveFormat: TWaveFormatEx;

  public
    property BufferLength: UInt32 read FBufferLength;
    property Buffer: Pointer read FBuffer;
    property WaveFormat: TWaveFormatEx read FWaveFormat;

    destructor Destroy; override;
    procedure Load(filename: String; bSwap: Boolean; bRawFileOnly: Boolean);

  private
    function GetFileData_RAW(var lpData: Pointer; var msWave: TMemoryStream): Cardinal;
    function GetFileData_WAV(var lpData: Pointer; var msWave: TMemoryStream; var waveHeader: TWaveFormatEx): Cardinal;
    procedure SwapData(lpData: PAnsiChar; dwLength: UInt32);

end;

implementation

destructor TSoundFile.Destroy;
begin
  if FBufferLength > 0 then
    FreeMem(FBuffer);

  inherited;
end;

procedure TSoundFile.Load(filename: string; bSwap: Boolean; bRawFileOnly: Boolean);
var
  fileStream: TMemoryStream;
begin
  fileStream := TMemoryStream.Create;
  fileStream.LoadFromFile(filename);
  try
// try to load as WAV file, if no 'RAW-ONLY-MODE'
    if not bRawFileOnly then
    begin
      fileStream.Position := 0;
      FBufferLength := GetFileData_WAV(FBuffer, fileStream, FWaveFormat);
    end;

    // try to read as RAW file
    if FBufferLength = 0 then
    begin
      FWaveFormat.wFormatTag := 0;
      fileStream.Position := 0;
      FBufferLength := GetFileData_RAW(FBuffer, fileStream);
      if(bSwap) then SwapData(FBuffer, FBufferLength);
    end;
  finally
    fileStream.Clear;
    fileStream.Free;
  end;
end;

function TSoundFile.GetFileData_RAW(var lpData: Pointer; var msWave: TMemoryStream): Cardinal;
var
  iBufferLength: LongInt;
begin
  iBufferLength := msWave.Size;
  System.GetMem(lpData, iBufferLength);
  msWave.ReadBuffer(lpData^, iBufferLength);
  Result := Cardinal(iBufferLength);
end;

function TSoundFile.GetFileData_WAV(var lpData: Pointer; var msWave: TMemoryStream; var waveHeader: TWaveFormatEx): Cardinal;
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

procedure TSoundFile.SwapData(lpData: PAnsiChar; dwLength: UInt32);
var
  i: UInt32;
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

end.
