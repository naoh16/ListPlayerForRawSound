unit fShortcutList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TShortcutListForm = class(TForm)
    Memo1: TMemo;
    procedure FormHide(Sender: TObject);
  private
    { Private �錾 }
  public
    { Public �錾 }
  end;

var
  ShortcutListForm: TShortcutListForm;

implementation
uses
  FListPlayer;

{$R *.dfm}

procedure TShortcutListForm.FormHide(Sender: TObject);
begin
  MainForm.miSimpleHelp.Checked := false;
end;

end.
