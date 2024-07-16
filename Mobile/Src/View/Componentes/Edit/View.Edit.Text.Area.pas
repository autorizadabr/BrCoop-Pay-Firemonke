unit View.Edit.Text.Area;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo;

type
  TViewEditTextArea = class(TFrame)
    recBase: TRectangle;
    StyleBook1: TStyleBook;
    Memo: TMemo;
    lblTextPrompt: TLabel;
    procedure MemoEnter(Sender: TObject);
    procedure MemoExit(Sender: TObject);
    procedure FrameTap(Sender: TObject; const Point: TPointF);
    procedure FrameClick(Sender: TObject);
    procedure MemoChange(Sender: TObject);
    procedure MemoChangeTracking(Sender: TObject);
  private
    { Private declarations }
  public
  protected
    FItemSelected:Boolean;
    FColorPattnerStroke:TAlphaColor;
    procedure SetColorEnter;
    procedure SetColorExit;
    procedure Loaded; override;
  end;

implementation

{$R *.fmx}

{ TViewEditTextArea }

procedure TViewEditTextArea.FrameClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  FrameTap(Sender,TPoint.Create(0,0));
  {$ENDIF}
end;

procedure TViewEditTextArea.FrameTap(Sender: TObject; const Point: TPointF);
begin
  if Memo.Enabled and not FItemSelected then
  begin
    FItemSelected := True;
  end;
end;

procedure TViewEditTextArea.Loaded;
begin
  inherited;
  FItemSelected := False;
  FColorPattnerStroke := recBase.Stroke.Color;
end;

procedure TViewEditTextArea.MemoChange(Sender: TObject);
begin
  lblTextPrompt.Visible := Memo.Lines.Text.IsEmpty;
end;

procedure TViewEditTextArea.MemoChangeTracking(Sender: TObject);
begin
  lblTextPrompt.Visible := Memo.Lines.Text.IsEmpty;
end;

procedure TViewEditTextArea.MemoEnter(Sender: TObject);
begin
  SetColorEnter;
end;

procedure TViewEditTextArea.MemoExit(Sender: TObject);
begin
  SetColorExit;
end;

procedure TViewEditTextArea.SetColorEnter;
begin
  recBase.Stroke.Color := $FFF7941D;
end;

procedure TViewEditTextArea.SetColorExit;
begin
  recBase.Stroke.Color := FColorPattnerStroke;
  FItemSelected := False;
end;

end.
