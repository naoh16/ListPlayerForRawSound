unit fAboutBox;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    OKButton: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private �錾 }
  public
    { Public �錾 }
  end;

var
  AboutBox: TAboutBox;

implementation
uses
  Global;

{$R *.dfm}

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  Version.Caption := 'Ver.' + IntToStr(AppMajorVersion) + '.'
                            + IntToStr(AppMinorVersion) + '.'
                            + IntToStr(AppRevision);
end;

end.
 
