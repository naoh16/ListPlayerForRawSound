unit fShortcutList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm3 = class(TForm)
    Memo1: TMemo;
    procedure FormHide(Sender: TObject);
  private
    { Private �錾 }
  public
    { Public �錾 }
  end;

var
  Form3: TForm3;

implementation
uses
  FListPlayer;

{$R *.dfm}

procedure TForm3.FormHide(Sender: TObject);
begin
  Form1.miSimpleHelp.Checked := false;
end;

end.
