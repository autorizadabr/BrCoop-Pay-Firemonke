unit View.Check.Basic;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Effects;

type
  TViewCheckBasic = class(TFrame)
    recBase: TRectangle;
    ShadowEffect1: TShadowEffect;
    procedure FrameTap(Sender: TObject; const Point: TPointF);
    procedure FrameClick(Sender: TObject);
  private
    FOnChageCheck: TNotifyEvent;
    FCheck: Boolean;
    procedure SetCheck(const Value: Boolean);
    procedure SetOnChageCheck(const Value: TNotifyEvent);
  public
    procedure AfterConstruction; override;
    property Check:Boolean read FCheck write SetCheck;
    property OnChageCheck:TNotifyEvent read FOnChageCheck write SetOnChageCheck;
  end;

implementation

{$R *.fmx}

procedure TViewCheckBasic.AfterConstruction;
begin
  inherited;
  Check := False;
end;

procedure TViewCheckBasic.FrameClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  FrameTap(Sender,TPointF.Create(0,0));
  {$ENDIF}
end;

procedure TViewCheckBasic.FrameTap(Sender: TObject; const Point: TPointF);
begin
  Check := not(Check);
end;

procedure TViewCheckBasic.SetCheck(const Value: Boolean);
begin
  FCheck := Value;
  if FCheck then
  begin
    recBase.Fill.Color := $FFF7941D;
  end
  else
  begin
    recBase.Fill.Color := $FFFFFFFF;
  end;
end;

procedure TViewCheckBasic.SetOnChageCheck(const Value: TNotifyEvent);
begin
  FOnChageCheck := Value;
end;

end.
