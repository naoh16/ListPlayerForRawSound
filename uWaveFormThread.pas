unit uWaveFormThread;

interface

uses
  Classes;

type
  TWaveDrawThread = class(TThread)
  private
    { Private 宣言 }
    n: Cardinal;
    procedure DotoForm1;
    procedure DotoForm2;
  protected
    procedure Execute; override;
  end;

implementation
uses
  FListPlayer, fWaveView;

{注意: 
  異なるスレッドが所有する VCL または CLX のメソッド/関数/
  プロパティを別のスレッドの中から扱う場合、排他処理の問題が
  発生します。

  メインスレッドの所有するオブジェクトに対しては Synchronize
  メソッドを使う事ができます。他のオブジェクトを参照するため
  のメソッドをスレッドクラスに追加し、Synchronize メソッドの
  引数として渡します。

  たとえば、UpdateCaption メソッドを以下のように定義し、

    procedure TWaveDrawThread.UpdateCaption;
    begin
      Form1.Caption := 'TWaveDrawThread スレッドから書き換えました';
    end;

  Execute メソッドの中で Synchronize メソッドに渡すことでメイ
  ンスレッドが所有する Form1 の Caption プロパティを安全に変
  更できます。

      Synchronize(UpdateCaption);
}

{ TWaveDrawThread }

procedure TWaveDrawThread.DotoForm1;
begin
    Form1.tbPlayPosition.Position := n;
end;

procedure TWaveDrawThread.DotoForm2;
begin
    Form2.DrawPlayLine(n);
end;

procedure TWaveDrawThread.Execute;
begin
  { ToDo : スレッドとして実行したいコードをこの下に記述してください }  
//  while Form1.WavOut.IsPlaying do
  while true do
  begin
    n := Form1.WavOut.Position;
    Synchronize(DotoForm1);
    Synchronize(DotoForm1);
//      Form2.DrawPlayLine(tbPlayPosition.Position);
  end;
end;

end.
 