// Delphi-MLのやつ。
//
// http://leed.issp.u-tokyo.ac.jp/~takeuchi/delphi/browse.cgi?index=23838
//
// 一応、クラス名は TMandom -> ThtListViewEx に変えてみた・・・
//

//===========================================================
//  ListView派生クラス
//-----------------------------------------------------------
//  < 初期表示までの時間を短縮すること[も]できるListView >
//  ListItem表示直前時のイベントを追加
//    -> OnDispItem TLVDispEvent
//  Create :  1998/07/09  HANAI Tohru
//===========================================================
unit htListViewEx;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics,
  CommCtrl, ComCtrls;

type
  TLVDispKind = (dkCaption, dkSubItem, dkImage);
  TLVDispEvent = procedure (Sender: TObject; Item: TListItem;
    Kind: TLVDispKind; SubItemIndex: Integer) of Object;

  ThtListViewEx = class(TListView)
  private
    FLVDispItem: TLVDispEvent;
    FDenyRedraw: Boolean;
  protected
    procedure DoDispItem(LVItem: TLVItem); virtual;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure LVMInsertItem(var Message: TMessage); message LVM_INSERTITEM;
    procedure LVMRedrawItems(var Message: TMessage); message LVM_REDRAWITEMS;
    procedure LVMSetItemText(var Message: TMessage); message LVM_SETITEMTEXT;
  published
    property OnDispItem: TLVDispEvent read FLVDispItem write FLVDispItem;
  end;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Sample', [ThtListViewEx]);
end;

procedure ThtListViewEx.LVMInsertItem(var Message: TMessage);
begin
  with PLVItem(Message.lParam)^ do
  begin
    mask := mask or LVIF_TEXT or LVIF_IMAGE;
    pszText := LPSTR_TEXTCALLBACK;
//    cchTextMax := 260;  CALLBACKだと、入力値は無意味みたい...
    iImage := I_IMAGECALLBACK;
  end;

  inherited;
end;

procedure ThtListViewEx.LVMRedrawItems(var Message: TMessage);
begin
  if not FDenyRedraw then
    inherited;
end;

procedure ThtListViewEx.LVMSetItemText(var Message: TMessage);
begin
  if not FDenyRedraw then
    inherited;
end;

procedure ThtListViewEx.CNNotify(var Message: TWMNotify);
begin
  with (PLVDispInfo(Message.NMHdr))^ do
    if (hdr.Code = LVN_GETDISPINFO) and Assigned(FLVDispItem) then
      DoDispItem(Item);

  inherited;
end;

procedure ThtListViewEx.DoDispItem(LVItem: TLVItem);
begin
  FDenyRedraw := True;
  with LVItem do
  begin
    if (Mask and LVIF_TEXT) <> 0 then
      if iSubItem = 0 then
        FLVDispItem(Self, TListItem(lParam), dkCaption, 0)
      else if iSubItem <= TListItem(lParam).SubItems.Count then
        FLVDispItem(Self, TListItem(lParam), dkSubItem, iSubItem - 1);

    if (Mask and LVIF_IMAGE) <> 0 then
      FLVDispItem(Self, TListItem(lParam), dkImage, 0);
  end;
  FDenyRedraw := False;
end;

end.

