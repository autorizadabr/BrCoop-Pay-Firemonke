unit View.Check;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Effects;

type
  TViewCheck = class(TFrame)
    Image1: TImage;
    Circle1: TCircle;
    procedure Circle1Click(Sender: TObject);
  private
    FOnChageCheck: TNotifyEvent;
    FCheck: Boolean;
    procedure SetOnChageCheck(const Value: TNotifyEvent);
    procedure SetCheck(const Value: Boolean);
  public
    procedure AfterConstruction; override;
    property Check:Boolean read FCheck write SetCheck;
    property OnChageCheck:TNotifyEvent read FOnChageCheck write SetOnChageCheck;
  end;

implementation

{$R *.fmx}

{ TFrame1 }


procedure TViewCheck.AfterConstruction;
begin
  inherited;
  Check := True;
end;

procedure TViewCheck.Circle1Click(Sender: TObject);
begin
  Check :=  not(Check);
end;

procedure TViewCheck.SetCheck(const Value: Boolean);
begin
  FCheck := Value;

  if Check then
  begin
    Image1.Opacity := 1;
    Circle1.Fill.Color := TAlphaColorRec.White;
  end
  else
  begin
    Circle1.Fill.Color := TAlphaColorRec.Gray;
    Image1.Opacity := 0.2;
  end;
  if Assigned(OnChageCheck) then
    FOnChageCheck(Self);
end;

procedure TViewCheck.SetOnChageCheck(const Value: TNotifyEvent);
begin
  FOnChageCheck := Value;
end;

end.
