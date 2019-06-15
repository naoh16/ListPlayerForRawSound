unit uWaveFormThread;

interface

uses
  Classes;

type
  TWaveDrawThread = class(TThread)
  private
    { Private �錾 }
    n: Cardinal;
    procedure DotoForm1;
    procedure DotoForm2;
  protected
    procedure Execute; override;
  end;

implementation
uses
  FListPlayer, fWaveView;

{����: 
  �قȂ�X���b�h�����L���� VCL �܂��� CLX �̃��\�b�h/�֐�/
  �v���p�e�B��ʂ̃X���b�h�̒����爵���ꍇ�A�r�������̖�肪
  �������܂��B

  ���C���X���b�h�̏��L����I�u�W�F�N�g�ɑ΂��Ă� Synchronize
  ���\�b�h���g�������ł��܂��B���̃I�u�W�F�N�g���Q�Ƃ��邽��
  �̃��\�b�h���X���b�h�N���X�ɒǉ����ASynchronize ���\�b�h��
  �����Ƃ��ēn���܂��B

  ���Ƃ��΁AUpdateCaption ���\�b�h���ȉ��̂悤�ɒ�`���A

    procedure TWaveDrawThread.UpdateCaption;
    begin
      Form1.Caption := 'TWaveDrawThread �X���b�h���珑�������܂���';
    end;

  Execute ���\�b�h�̒��� Synchronize ���\�b�h�ɓn�����ƂŃ��C
  ���X���b�h�����L���� Form1 �� Caption �v���p�e�B�����S�ɕ�
  �X�ł��܂��B

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
  { ToDo : �X���b�h�Ƃ��Ď��s�������R�[�h�����̉��ɋL�q���Ă������� }  
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
 