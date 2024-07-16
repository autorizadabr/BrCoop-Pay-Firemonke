unit View.Componentes.Principal.Card;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TViewComponentesPrincipalCard = class(TFrame)
    recBaseCard: TRectangle;
    layTopTitle: TLayout;
    lblTitle: TLabel;
    imgSetaClick: TImage;
    layContentValue: TLayout;
    recLoad: TRectangle;
    AniIndicator: TAniIndicator;
    Label1: TLabel;
    procedure FrameClick(Sender: TObject);
    procedure FrameTap(Sender: TObject; const Point: TPointF);
  private
    FLoad: Boolean;
    FOnClickItem: TProc;
    FValue: string;
    procedure SetLoad(const Value: Boolean);
    procedure SetOnClickItem(const Value: TProc);
  protected
    procedure SetValue(const Value: string);virtual;
  public
    property Load:Boolean read FLoad write SetLoad;
    property Value:string read FValue write SetValue;
    property OnClickItem:TProc read FOnClickItem write SetOnClickItem;
  end;

implementation

{$R *.fmx}

{ TFrame1 }

procedure TViewComponentesPrincipalCard.FrameClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  if Assigned(FOnClickItem) then
  FOnClickItem();
  {$ENDIF}
end;

procedure TViewComponentesPrincipalCard.FrameTap(Sender: TObject;
  const Point: TPointF);
begin
  if Assigned(FOnClickItem) then
    FOnClickItem();
end;

procedure TViewComponentesPrincipalCard.SetLoad(const Value: Boolean);
begin
  FLoad := Value;
  recLoad.Visible := FLoad;
  AniIndicator.Enabled := FLoad;
end;

procedure TViewComponentesPrincipalCard.SetOnClickItem(const Value: TProc);
begin
  FOnClickItem := Value;
end;

procedure TViewComponentesPrincipalCard.SetValue(const Value: string);
begin
  FValue := Value;
end;

end.
