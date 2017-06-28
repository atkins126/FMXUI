unit uFrameMultiPathView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UI.Standard, UI.Base, UI.Frame, FMX.Layouts;

type
  TFrameMultiPathView = class(TFrame)
    LinearLayout1: TLinearLayout;
    tvTitle: TTextView;
    HorzScrollBox1: THorzScrollBox;
    btnBack: TTextView;
    procedure btnBackClick(Sender: TObject);
  private
    { Private declarations }
    FMultiPath: TMultiPathView;
  protected
    procedure DoCreate(); override;
  public
    { Public declarations }
    procedure DoItemClick(Sender: TObject; Index: Integer);
  end;

implementation

{$R *.fmx}

procedure TFrameMultiPathView.btnBackClick(Sender: TObject);
begin
  Finish;
end;

procedure TFrameMultiPathView.DoCreate;
var
  APath: TPathViewItem;
begin
  inherited DoCreate;
  FMultiPath := TMultiPathView.Create(Self);
  FMultiPath.Parent := HorzScrollBox1;
  FMultiPath.SetBounds(0, 0, 500, 500);
//  FMultiPath.Style.Hover.Fill.Color := $7f666600;
//  FMultiPath.Style.Hover.Fill.Kind := TBrushKind.Solid;
//  FMultiPath.Style.Pressed.Fill.Color := $ff0099cc;
//  FMultiPath.Style.Pressed.Fill.Kind := TBrushKind.Solid;
  FMultiPath.Paths.BeginUpdate;
  FMultiPath.ClickInPath := True;
  FMultiPath.OnItemClick := DoItemClick;
  APath := FMultiPath.Paths.Add;
  APath.Style.ItemDefault.Fill.Color := TAlphaColors.Gray;
  APath.Style.ItemHovered.Fill.Color := $ff666600;
  APath.Style.ItemPressed.Fill.Color := $ff0099cc;
  APath.Style.ItemActivated.Fill.Color := $ff574890;
  APath.DisplayName := '�Բ�';
  APath.Path.Data :=
    'M370.3,28c-1.3,0.6-2.4,2-2.2,2.5c0,0-1.3-0.2-2.3,1.8c-1,2-1.6,4.4-1.6,4.4s-0.6,0.5-0.5,1.4 '
    + 'c0,0-0.8,1.6-0.5,3.3c0.2,1.7,1.2,1.9,1.2,2.6c0,0-0.7,1.5,1.4,3c2,1.5,3.7,1.2,3.7,1.2s2.5,0.8,3.4,0.3c0,0,1.4-0.4,1.3,0.2 '
    + 'c0,0-0.7,0.6-0.6,1.2c0,0-0.4,0.9,0,1.7c0.4,0.8,0.8,0.5,0.9,1c0.2,0.5-0.3,0.9,0.3,1.6c0.6,0.7,1.6,0.3,1.8,0.6 '
    + 'c0.2,0.3,3.1,2.3,6.8,1.1c0,0,0.9,0.1,1.6-0.3c0.7-0.4,2-1.4,2-1.4l2.3-0.3l0.7,1.1c0,0-0.3,0.8,0.6,1.5c0.9,0.7,1.5,0.2,1.5,0.2 '
    + 's1,0.4,1.4,0.8c0.5,0.5,0.7,1.3,1.3,1.3c0.6,0,1.4-1.5,1.4-1.5s7-0.8,8.3-5.6l1.3-0.3c0,0,2.4-0.8,2.4-3c0,0,1.2-1.6,0.6-3.2 '
    + 'c0,0,0.5-0.6,0.5-1.2c0-0.5-0.3-0.6-0.3-0.6s0.4-0.8-0.5-2.9c-0.9-2.1-1-1.9-1-1.9s0.2-1.5-0.6-2.7c-0.8-1.3-1.7-1.5-1.7-1.5 '
    + 's-0.4-3-2.2-3.2c0,0,0.2-0.9-0.9-1.6c-1-0.7-1.6-1-1.6-1s-0.1-0.5-0.9-1c-0.9-0.5-1.7-0.4-1.7-0.4s0.5-0.7-2.2-1.8 '
    + 'c-2.7-1.1-2.4-0.6-2.4-0.6s-1.4-1-4.2-1c-2.8,0-3.3,0-3.5,0.5c0,0-0.9-0.7-4.1-0.2c-3.2,0.5-4.6,0.2-5.8,1.1 '
    + 'C374.5,26.1,370.5,27.3,370.3,28z';
  APath := FMultiPath.Paths.Add;
  APath.Style.ItemDefault.Fill.Color := $8f00cc66;
  APath.Style.ItemHovered.Fill.Color := $7f666600;
  APath.Style.ItemPressed.Fill.Color := $ff0099cc;
  APath.Style.ItemActivated.Fill.Color := $ff574890;
  APath.DisplayName := '�Ұ���';
  APath.Path.Data :=
    'M265.6,46.3v197.4c0,0,1.8,19,6.8,31c5,12,7.7,37,12.5,43.2c4.8,6.2,3.9,11.8,4.4,20.4 '
    + 'c0.4,8.5,8.1,29.9,8.3,41.5c0.2,11.6-1,20.4-0.8,24.5c0.2,4.2,0.8,5.8,7.5,4.8c6.6-1,14.8-0.6,13.5-3.7c-1.2-3.1-7.9-2.7-8.3-10.2 '
    + 'c-0.4-7.5-0.2-10.6,1.7-32c1.9-21.4-0.6-37.6-7.1-45.5c0,0,0.8-9.3-2.1-16.4c-2.9-7.1-1-10-0.6-20.6c0.4-10.6,3.1-30.7-0.2-52.6 '
    + 'c-3.3-21.8-10.8-41.1-7.5-51.1c3.3-10,6.6-20.4,6.6-20.4s4.4,12.1,4.2,17.9c-0.2,5.8,6.2,32.4,10.4,41.1c4.2,8.7,2.5,15.8,1.2,18.7 '
    + 'c-1.2,2.9-2.2,6.8-1.4,9.5c0.8,2.7,0.5,4.5,0.5,4.5s-1-0.9-2,0.6c-1,1.5-0.1,5.1,3,7.5c3,2.3,6.2,0.5,9.3-3c3.2-3.6,4.9-4.5,4.3-8.3 '
    + 'c-0.6-3.8-1.7-8.9-2.1-12.2c-0.4-3.3-0.6-14.9-1.4-24.7c-0.7-9.9-2.3-24.1-5.9-34.8c-3.6-10.7-6.8-25.2-5.8-33.3 '
    + 'c0.9-8.1,1.4-28.7-14-32.3c-15.4-3.6-23.1-8.7-23.1-18.7c0,0,0.2-3.4,1.4-5.8c0,0,0.9,0.4,1.7-0.5c0.9-0.9,0.8-3.4,2.5-5.5 '
    + 'c1.7-2,2.9-7.1-0.9-8.3c0,0,1.7-11.4-2.3-16.6C275.7,47.3,265.6,46.3,265.6,46.3z';
  APath := FMultiPath.Paths.Add;
  APath.DisplayName := '����';
  APath.Style.ItemDefault.Fill.Color := TAlphaColors.Black;
  APath.Style.ItemPressed.Fill.Color := $ff0099cc;
  APath.Path.Data :=
    'M144.3,33.2c0,0,5.7,5.5,1.4,13.5c0,0-0.9,3.8-8.1,7.4c-7.2,3.7-14.6,4.4-17.6-0.6c-3-5,2.2-14.1,4.1-15.4 '
    + 'c0,0,0.6-3.2,5.8-4.1c0,0,2.1-1.9,0.2-1.7c-1.9,0.1-4.6,0.2-4.9-0.6c-0.4-0.8,0-4,1.2-4.3c1.1-0.3,3.4,0.8,3.4,0.8s1.3-3.3-2-3.9 '
    + 'c0,0,0.5-2.4,2.4-2.1l0.1-1.3c0,0,0.3-0.4,1-0.4c0.6,0,1.1,0.4,1.1,0.4l0.1,0.9l0.7-0.1l0.2-1c0,0,0.2-0.5,1.1-0.3 '
    + 'c0.9,0.2,0.8,0.9,0.8,0.9s0.1,1,0.1,1.1c0,0.1,0.6,0.8,1.2,0.3l0.7-1.6c0,0,1.3-0.4,1.8,1c0,0-1.3,2,0.2,3.4c0,0,1.1,1.4,1.1,4.1 '
    + 'c0,0,0.4-3.3-0.2-4.4c0,0,0.7-0.8,2.1-0.2c0,0,0,2.3,0.6,2.4c0.6,0,0.7-2.2,0.7-2.2s0.1-0.5,1.3-0.2c1.1,0.3,1.1,1,1.1,1 '
    + 'S142,28.9,144.3,33.2z';
  APath := FMultiPath.Paths.Add;
  APath.DisplayName := '�β�';
  APath.Style.ItemDefault.Fill.Color := TAlphaColors.Red;
  APath.Style.ItemPressed.Fill.Color := $ff0099cc;
  APath.Path.Data :=
    'M80.5,196.1c0,0-3.7-19-15.2-19c0,0,0.5,4.4,0.6,8.5c0,0-0.1,0-0.1,0c-0.6-0.1-1.1-0.4-1.7-0.4'
    + 'c-0.2,0-0.5,0-0.7-0.1v-8.6h-2.3v8.6c-0.2,0-0.5,0-0.7,0c-0.6,0.1-1.2,0.3-1.7,0.4c-0.2,0.1-0.3,0.1-0.5,0.2c0-4.1,0.6-8.7,0.6-8.7'
    + 'c-11.6,0-15.2,19-15.2,19s-2.4,2.7-2.4,6.5c0,3.8,3,9.8,4.4,9.9c1.4,0.2,4.1-0.9,7.4-3.4c3.2-2.5,7.8-3.5,8.3-9'
    + 'c0.5-5.5-2.4-8.8-2.4-8.8c-0.3-0.8-0.5-2.2-0.6-3.7c0.3-0.1,0.6-0.1,1-0.2c1-0.1,2-0.3,3-0.2c0.5,0,1,0.1,1.5,0.1'
    + 'c0.5,0.1,1,0.1,1.5,0.2c0.2,0,0.4,0.1,0.6,0.1c-0.1,1.5-0.2,2.9-0.6,3.7c0,0-3,3.3-2.4,8.8c0.5,5.5,5.1,6.5,8.3,9'
    + 'c3.2,2.5,5.9,3.6,7.4,3.4c1.4-0.2,4.4-6.2,4.4-9.9C82.9,198.8,80.5,196.1,80.5,196.1z';

  APath := FMultiPath.Paths.Add;
  APath.Style.ItemDefault.Fill.Color := TAlphaColors.Blue;
  APath.Style.ItemPressed.Fill.Color := $ff0099cc;
  APath.DisplayName := '����';
  APath.Path.Data :=
    'M134.5,337.8c0.6-0.6,1-1.5,1-2.4c0-0.9-0.4-1.7-1-2.4c0.2-0.4,0.3-0.8,0.3-1.3c0-1.1-0.6-2.1-1.5-2.7'
    + 'c0.1-0.4,0.2-0.7,0.2-1.1c0-2.2-1.8-4-4-4c-1.7,0-3.1,1.1-3.7,2.6c-0.3-0.1-0.7-0.2-1.1-0.2c-1,0-2,0.6-2.4,1.4'
    + 'c-0.4-0.2-0.9-0.4-1.4-0.4c-0.9,0-1.7,0.4-2.3,0.9c-0.5-0.4-1.2-0.7-1.9-0.7c-0.7,0-1.4,0.3-1.9,0.7c-0.6-0.5-1.3-0.8-2.1-0.8'
    + 'c-0.5,0-0.9,0.1-1.3,0.3c-0.5-0.6-1.3-1-2.2-1c-0.1,0-0.1,0-0.2,0c-0.6-1.3-1.8-2.2-3.3-2.2c-1.8,0-3.3,1.3-3.6,3'
    + 'c-1.2,0.5-2.1,1.7-2.1,3c0,0.5,0.1,1,0.3,1.4c-0.8,0.6-1.4,1.6-1.4,2.7c0,0.1,0,0.1,0,0.2c-0.5,0.7-0.8,1.5-0.8,2.4'
    + 'c0,1,0.4,1.9,1,2.7c-0.1,0.4-0.2,0.8-0.2,1.2c0,0.9,0.3,1.7,0.8,2.4c-0.1,0.3-0.2,0.7-0.2,1.1c0,2.4,1.9,4.3,4.3,4.3'
    + 'c2.4,0,4.3-1.9,4.3-4.3c0-1.1-0.4-2.1-1.1-2.9c0-0.2,0.1-0.4,0.1-0.5c0-0.9-0.3-1.8-0.9-2.5c0.2-0.5,0.3-0.9,0.3-1.4'
    + 'c0-0.9-0.3-1.7-0.7-2.4c0-0.1,0-0.2,0-0.2c0-0.6-0.2-1.2-0.4-1.7c0.4-0.3,0.7-0.7,0.9-1.2c0.4-0.1,0.7-0.2,1.1-0.3'
    + 'c0.5,0.5,1.1,0.7,1.9,0.7c0.2,0,0.5,0,0.7-0.1c0.5,1,1.6,1.7,2.8,1.7c0.8,0,1.5-0.3,2-0.7c0.5,0.5,1.2,0.7,2,0.7'
    + 'c0.8,0,1.5-0.3,2.1-0.8c0.6,0.5,1.3,0.8,2.1,0.8c1.4,0,2.5-0.9,3-2c0.3,0.1,0.6,0.2,0.9,0.2c0.9,0,1.7-0.4,2.2-1'
    + 'c0.4,0.4,0.9,0.7,1.5,0.8c0,0.7,0.3,1.4,0.7,1.9c-0.3,0.5-0.5,1.1-0.5,1.7c0,0.2,0,0.4,0.1,0.5c-0.5,0.3-0.9,0.6-1.2,1'
    + 'c-0.6,0.2-1.1,0.5-1.6,0.9c-0.4-0.2-0.8-0.3-1.2-0.3c-1,0-1.8,0.5-2.4,1.2c-0.6-0.4-1.2-0.6-2-0.6c-1.9,0-3.4,1.5-3.4,3.4'
    + 'c0,0.1,0,0.2,0,0.4c-1.2,0.6-2.1,1.9-2.1,3.4c0,1,0.4,2,1.1,2.7c-0.7,0.7-1.1,1.6-1.1,2.6c0,1.7,1.2,3.2,2.8,3.6'
    + 'c0,0.1,0.1,0.3,0.2,0.4c0.3,0.7,0.7,1.4,0.7,1.4h0.2c0,0,0.4-0.7,0.7-1.4c0.1-0.1,0.1-0.3,0.2-0.4c1.6-0.4,2.8-1.9,2.8-3.6'
    + 'c0-1-0.4-2-1.1-2.6c0.7-0.7,1.1-1.6,1.1-2.7c0-0.3-0.1-0.6-0.1-0.9c0.4-0.3,0.8-0.7,1-1.2c0.4,0.2,0.9,0.4,1.4,0.4l0,0'
    + 'c0.8,1.7,2.5,2.9,4.5,2.9c2.6,0,4.7-2,4.9-4.6c0.5-0.7,0.8-1.5,0.8-2.4C134.9,338.9,134.8,338.3,134.5,337.8z';
  APath := FMultiPath.Paths.Add;
  APath.Style.ItemDefault.Fill.Color := TAlphaColors.Chartreuse;
  APath.Style.ItemPressed.Fill.Color := $ff0099cc;
  APath.DisplayName := 'θ��';
  APath.Path.Data :=
    'M433,331.6c0-4.6-3.7-8.3-8.3-8.3c-1.8,0-3.4,0.6-4.8,1.5c-2.7-4.8-1.7-12.7-1.7-12.8h-3.6'
    + 'c-0.1,0.5-1.4,9.8,2.8,15.7c-0.6,1.1-1,2.4-1,3.8c0,8-2.3,10.2-5.6,10.4c-1.8,0-3.4,0.7-4.5,1.9c-1.9-0.7-4.3-1.4-6.4-0.9'
    + 'c-1.5,0.4-2.8,1.3-3.6,2.6c-3.5,5.7,3.2,12.9,3.5,13.2l4.7,0.1c-1.3-1.4-7.5-7.6-5.1-11.3c0.3-0.5,0.7-0.8,1.3-1'
    + 'c1.1-0.3,2.6,0.1,3.9,0.6c-0.1,0.4-0.1,0.7-0.1,1.1c0,3.5,2.8,6.3,6.3,6.3C436.7,358.7,433,331.6,433,331.6z';
  APath := FMultiPath.Paths.Add;
  APath.Style.ItemDefault.Fill.Color := TAlphaColors.Chartreuse;
  APath.Style.ItemPressed.Fill.Color := $ff0099cc;
  APath.DisplayName := '�β�';
  APath.Path.Data :=
    'M464.4,180.3c0,0-1.9-1.5-5.8-1.4c-4,0.1-4.7,0.6-6.5,0.7c-1.8,0.1-8.8,0.2-12.5,5.6'
    + 'c-3.8,5.5-3.9,13.8-2.2,17.1c0,0,1.6,7.8,0.1,9.7c0,0,0.1,3.6,9.7-2.6c0,0,7.2,0.2,10.4-2.1c3.2-2.3,8.1-8,8.1-8s7.7-2.5,8.3-3.7'
    + 'c0.6-1.3,4-3.1,4.6-3.3c0.7-0.2,2.2-4.3,3.1-5.5c0.9-1.1,4.7-4.3,3.2-7.2c-1.5-2.8-7.3-0.1-9.7,0'
    + 'C472.8,179.7,467.8,178.1,464.4,180.3z';
  APath := FMultiPath.Paths.Add;
  APath.Style.ItemDefault.Fill.Color := TAlphaColors.Chartreuse;
  APath.Style.ItemPressed.Fill.Color := $ff0099cc;
  APath.DisplayName := '�����';
  APath.Path.Data :=
    'M249.1,68.1c-3.5,1.8-0.8,7-0.5,9.8c0.3,2.7,2,2.9,2,2.9c0.9,4.2,4.8,10.7,4.8,10.7'
    + 'c1.6,18.2-18.2,17.7-27.9,23.4c-9.6,5.7-7,22.1-7,35.7c0,13.5-4.4,25.8-8.3,42.7c-3.2,13.9-4.7,23.9-5.1,27.1'
    + 'c-1.3,0.2-4.2,1.2-7.5,5.9c-1.9,2.7-2.5,5.5-3.9,6.8c-1.4,1.4,1.6,4.6,5.2-1.3l-6.4,15c0,0-1.2,2.2,0.7,2.5'
    + 'c2.8,0.4,5.2-10.6,6.5-10.6c1,0-5.1,12.3-2.1,13.3c3.1,1,5.3-12.9,6-12.7c0.7,0.2-3.5,11.4-1.1,12.2c3.2,1.1,3.1-12.6,5.1-12.4'
    + 'c0.4,0-2.5,9.4-0.4,9.4c2.1,0,2.1-6.2,4.1-9.4c1.9-2.9,4.3-11.4,3.1-15.7c3.5-11.6,12.2-35,14.3-45.2c2.3-11.5,6.2-33.8,6.2-33.8'
    + 'c3.6,7.3,5.7,40.3,2.6,49.2c-3.1,8.9-10.4,30.2-7.3,50c3.1,19.8,5.7,46.6,4.7,69.8c-1,23.2,2.9,48.4,6,65.9'
    + 'c3.1,17.4-0.5,21.9-2.9,25c-2.3,3.1,2.3,5.5,2.3,5.5s7.5,0,12,0c4.4,0,3.1-3.1,1.6-12.2c-1.6-9.1-3.1-16.4-1.3-28.4'
    + 'c1.8-12,3.4-27.3,2.3-45.6c-1-18.2-0.8-21.9,2.6-35.4c3.4-13.5,6-52.8,6-52.8V46.3C244.7,46.3,249.1,68.1,249.1,68.1z';
  FMultiPath.Paths.EndUpdate;
end;

procedure TFrameMultiPathView.DoItemClick(Sender: TObject; Index: Integer);
begin
  tvTitle.Text := FMultiPath.Paths[Index].DisplayName;
end;

end.
