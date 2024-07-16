unit View.Componentes.Censura;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Edit,FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;


type
  TViewComponentesCensura = class(TFrame)
    imgVisible: TImage;
    imgVisibleOff: TImage;
    procedure FrameClick(Sender: TObject);
    procedure FrameTap(Sender: TObject; const Point: TPointF);
  private
    FEdit:TEdit;
    FVisibility:Boolean;
    procedure SetVisibility(const Value: Boolean);
    procedure SetEdit(const Value: TEdit);
  public
    procedure AfterConstruction; override;
    property Edit:TEdit read FEdit write SetEdit;
    property Visibility:Boolean read FVisibility write SetVisibility;

  end;

implementation

{$R *.fmx}

procedure TViewComponentesCensura.AfterConstruction;
begin
  inherited;
  imgVisible.Visible := False;
end;

procedure TViewComponentesCensura.FrameClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  Visibility := not(Visibility);
  {$ENDIF}
end;

procedure TViewComponentesCensura.FrameTap(Sender: TObject;
  const Point: TPointF);
begin
  {$IFDEF ANDROID}
  Visibility := not(Visibility);
  {$ENDIF}
end;

procedure TViewComponentesCensura.SetEdit(const Value: TEdit);
begin
  FEdit := Value;
  SetVisibility(FVisibility);
end;

procedure TViewComponentesCensura.SetVisibility(const Value: Boolean);
begin
  FVisibility := Value;

  imgVisibleOff.Visible := (FVisibility = True);
  imgVisible.Visible    := not (imgVisibleOff.Visible);

  if Assigned(FEdit) then
    FEdit.Password := not(FVisibility);
end;

end.
