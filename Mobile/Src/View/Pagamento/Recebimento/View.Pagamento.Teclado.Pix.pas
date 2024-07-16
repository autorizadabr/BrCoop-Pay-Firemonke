unit View.Pagamento.Teclado.Pix;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Componentes.Teclado, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects,
  Model.Utils;

type
  TFramePagamentoTecladoPix = class(TFrame)
    recBase: TRectangle;
    recPrincipal: TRectangle;
    layButtons: TLayout;
    lblCancelar: TLabel;
    lblConfirmar: TLabel;
    layContentTecladoQuantidade: TLayout;
    FrameComponentesTeclado1: TFrameComponentesTeclado;
    layValoresQuantidade: TLayout;
    lblValor: TLabel;
    layValorFaltaReceber: TLayout;
    lblFaltaPagar: TLabel;
    procedure lblCancelarClick(Sender: TObject);
    procedure lblConfirmarClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    FValor:Currency;
    FOnClickConfirmar: TProc<TObject>;
    FLimparValor:Boolean;
    procedure SetValor(const AValue:Currency);
    procedure AtualizarValor(AValue:string);
    procedure AntesDeDigitarNoTeclado();
  public
    procedure AfterConstruction; override;
    procedure OpenPix;
    procedure ClosePix;
    procedure FaltaPagar(const AValue:Currency);
    property OnClickConfirmar:TProc<TObject> read FOnClickConfirmar write FOnClickConfirmar;
    function Valor:Currency;
  end;

implementation

{$R *.fmx}

procedure TFramePagamentoTecladoPix.AfterConstruction;
begin
  inherited;
  FrameComponentesTeclado1.AtualizarValorDigitado := AtualizarValor;
  FrameComponentesTeclado1.AntesDoClickNoTeclado := AntesDeDigitarNoTeclado;
  FLimparValor := False;
end;

procedure TFramePagamentoTecladoPix.AntesDeDigitarNoTeclado;
begin
  if FLimparValor then
    FrameComponentesTeclado1.SetValorDigitado('0');
  FLimparValor := False;
end;

procedure TFramePagamentoTecladoPix.AtualizarValor(AValue: string);
begin
  var LFormatValue             := TModelUtils.FormatCurrencyValue(AValue);
  var LFormatValueReplacePonto := LFormatValue.Replace('.', '', [rfReplaceAll]);
  var LCurrencyValue           := StrToCurrDef(LFormatValueReplacePonto, 0);
  SetValor(LCurrencyValue);
end;

procedure TFramePagamentoTecladoPix.ClosePix;
begin
  Self.Visible := False;
end;

procedure TFramePagamentoTecladoPix.FaltaPagar(const AValue: Currency);
begin
  lblFaltaPagar.Text := 'Falta pagar R$ '+FormatFloat('#,##0.00',AValue);
  SetValor(AValue);
  FrameComponentesTeclado1.SetValorDigitado(FormatFloat('#,##0.00',AValue));
  FLimparValor := True;
end;

procedure TFramePagamentoTecladoPix.FrameResize(Sender: TObject);
begin
  recPrincipal.Height := Self.Height - 160;
  FrameComponentesTeclado1.OnResize(Sender);
end;

procedure TFramePagamentoTecladoPix.lblCancelarClick(Sender: TObject);
begin
  ClosePix;
end;


procedure TFramePagamentoTecladoPix.lblConfirmarClick(Sender: TObject);
begin
  ClosePix;
  if Assigned(FOnClickConfirmar) then
    FOnClickConfirmar(Self);
end;

procedure TFramePagamentoTecladoPix.OpenPix;
begin
  Self.OnResize(Self);
  Self.Visible := True;
end;

procedure TFramePagamentoTecladoPix.SetValor(const AValue: Currency);
begin
  FValor        := AValue;
  lblValor.Text := 'R$ '+FormatFloat('#,##0.00',FValor);
end;

function TFramePagamentoTecladoPix.Valor: Currency;
begin
  Result := FValor;
end;

end.
