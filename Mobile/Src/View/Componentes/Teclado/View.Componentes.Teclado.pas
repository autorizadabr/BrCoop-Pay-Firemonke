unit View.Componentes.Teclado;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, Model.Utils;

type
  TFrameComponentesTeclado = class(TFrame)
    layContentTeclado: TLayout;
    lay456: TLayout;
    lay4: TLayout;
    lay5: TLayout;
    lay6: TLayout;
    lay000Apagar: TLayout;
    lay00: TLayout;
    lbl00: TLabel;
    lay0: TLayout;
    lbl0: TLabel;
    layApagar: TLayout;
    lay123: TLayout;
    lay1: TLayout;
    lbl01: TLabel;
    lay2: TLayout;
    lbl02: TLabel;
    lay789: TLayout;
    lay7: TLayout;
    lbl07: TLabel;
    lay8: TLayout;
    lbl08: TLabel;
    lay9: TLayout;
    Image1: TImage;
    procedure FrameResize(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    FValorDigitado:string;
    FAtualizarValorDigitado: TProc<String>;
    FAntesDoClickNoTeclado: TProc;
    procedure OnClickNumero(Sender:TObject);
    procedure AjustarNumeros(ALayoutContent:TLayout);
    procedure AddValueItem(AValue: String);
    procedure SetAtualizarValorDigitado(const Value: TProc<String>);
    function GetNumberKeyboard(Sender: TObject): String;
  public
    procedure AfterConstruction; override;
    procedure SetValorDigitado(const AValue:string);
    property AtualizarValorDigitado:TProc<String> read FAtualizarValorDigitado write SetAtualizarValorDigitado;
    property AntesDoClickNoTeclado:TProc read FAntesDoClickNoTeclado write FAntesDoClickNoTeclado;
  end;

implementation

{$R *.fmx}

procedure TFrameComponentesTeclado.AfterConstruction;
begin
  inherited;
  for var I := 0 to Pred(Self.ComponentCount) do
  begin
    if Self.Components[i] is TLabel then
    begin
      TLabel(Self.Components[i]).HitTest := True;
      TLabel(Self.Components[i]).OnClick := OnClickNumero;
    end;
  end;
end;

procedure TFrameComponentesTeclado.AjustarNumeros(ALayoutContent: TLayout);
begin
  for var  I := 0 to Pred(ALayoutContent.ControlsCount) do
  begin
    ALayoutContent.Controls[I].Width := (ALayoutContent.Width / 3);
  end;
end;

procedure TFrameComponentesTeclado.FrameResize(Sender: TObject);
begin
  lay123.Height       := (Self.Height / 4);
  lay456.Height       := (Self.Height / 4);
  lay789.Height       := (Self.Height / 4);
  lay000Apagar.Height := (Self.Height / 4);

  AjustarNumeros(lay123);
  AjustarNumeros(lay456);
  AjustarNumeros(lay789);
  AjustarNumeros(lay000Apagar);
end;

procedure TFrameComponentesTeclado.OnClickNumero(Sender: TObject);
begin
  if Assigned(FAntesDoClickNoTeclado) then
    FAntesDoClickNoTeclado;
  AddValueItem(GetNumberKeyboard(Sender));
end;
procedure TFrameComponentesTeclado.SetAtualizarValorDigitado(
  const Value: TProc<String>);
begin
  FAtualizarValorDigitado := Value;
end;

procedure TFrameComponentesTeclado.SetValorDigitado(const AValue: string);
begin
  FValorDigitado := TModelUtils.ExtractNumber(AValue);
end;

procedure TFrameComponentesTeclado.AddValueItem(AValue: String);
begin
  //TLibVibrate.Vibrate(50);
  FValorDigitado :=  FValorDigitado + AValue;
  if Assigned(FAtualizarValorDigitado) then
    FAtualizarValorDigitado(FValorDigitado);
end;
function TFrameComponentesTeclado.GetNumberKeyboard(Sender: TObject): String;
begin
  Result := '-1';
  if Sender is TLabel then
  begin
    Result := TModelUtils.ExtractNumber(TLabel(Sender).Text);
  end;
end;

procedure TFrameComponentesTeclado.Image1Click(Sender: TObject);
begin
  FValorDigitado := Copy(FValorDigitado,1,Length(FValorDigitado) - 1);
  if Assigned(FAtualizarValorDigitado) then
    FAtualizarValorDigitado(FValorDigitado);
end;

end.
