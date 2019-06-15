unit uFileListview;

interface
uses
	Controls,Classes, ComCtrls, SysUtils, htListViewEx;

type
  TSortListView = class(ThtListViewEx)
  private
    FListSortMode: Integer;
    procedure CompareProc(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
  protected
    procedure ColClick(Column: TListColumn); override;
  public
  	constructor Create(AOwner: TComponent); override;
  end;

  TFileListview = class(TSortListView)
  public
  	constructor Create(AOwner: TComponent); override;
  	destructor Destroy; override;
  end;

function MyCompare(s1, s2: String): Integer;

implementation
uses
  StrUtils;

{ TFileListview }

constructor TFileListview.Create(AOwner: TComponent);
var
  item: TListColumn;
begin
  inherited Create(AOwner);

  align := alClient;
  HideSelection := false;
  RowSelect := true;
  ReadOnly := true;
  ViewStyle := vsReport;
  item := Columns.Add;
  item.Caption := '  ';
  item := Columns.Add;
  item.Caption := '�t�@�C����';
  item := Columns.Add;
  item.Caption := '�T�C�Y';
  item := Columns.Add;
  item.Caption := '����';
  item := Columns.Add;
  item.Caption := '�X�V���t';

  OnCompare := CompareProc;
end;

destructor TFileListview.Destroy;
begin

  inherited;
end;

{ TSortListView }

constructor TSortListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Parent := TWinControl(AOwner);
end;

// �R�����w�b�_���N���b�N���ꂽ��\�[�g���Ȃ����B
procedure TSortListView.ColClick(Column: TListColumn);
var
  i: Integer;
begin
  inherited ColClick(Column);

  if Abs(FListSortMode)=Column.Index+1 then begin
      FListSortMode:=-FListSortMode;
  end else begin
      FListSortMode:=Column.Index+1;
  end;
  SortType:=stNone;
  SortType:=stData;

  // �C���f�b�N�X�t������
  for i:=0 to Items.Count -1 do
    Items[i].Caption := IntToStr(i+1);
end;

// �ėp�I�Ɏg�����r���[�`��
procedure TSortListView.CompareProc(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  case FListSortMode of
  0:
    Compare := 0;
  1,-1:
//    Compare := AnsiCompareStr(Item1.Caption,Item2.Caption);
    Compare := MyCompare(Item1.Caption,Item2.Caption);
  else
    Compare := MyCompare(Item1.SubItems[Abs(FListSortMode)-2],
                       Item2.SubItems[Abs(FListSortMode)-2]);
  end;
  if FListSortMode<0 then Compare := -Compare;
end;

function MyCompare(s1, s2: String): Integer;
var
  i1, i2, code1, code2: integer;
begin
  s1 := AnsiReplaceStr(s1, ',',''); // �J���}������
  s2 := AnsiReplaceStr(s2, ',','');
  Val(s1, i1, code1);
  Val(s2, i2, code2);

  if code1 + code2 <> 0 then
    Result := AnsiCompareStr(s1, s2)
  else
    Result := i1 - i2;
end;

end.
