unit View.Pagamento.Teclado.Dinheiro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Componentes.Teclado, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects,
  Model.Utils;

type
  TFramePagamentoTecladoDinheiro = class(TFrame)
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
    Layout1: TLayout;
    layPrimeiraLinhaValores: TLayout;
    lblDoisReais: TLabel;
    layDoisReais: TLayout;
    layDezReais: TLayout;
    lblDezReais: TLabel;
    layCincoReais: TLayout;
    lblCincoReais: TLabel;
    laySegundaLinha: TLayout;
    layVinteReais: TLayout;
    lblVinteReais: TLabel;
    layCinquentaReais: TLayout;
    lblCinquentaReais: TLabel;
    layTerceiraLinha: TLayout;
    lblCemReais: TLabel;
    procedure FrameResize(Sender: TObject);
    procedure lblCancelarClick(Sender: TObject);
    procedure lblConfirmarClick(Sender: TObject);
    procedure lblDoisReaisClick(Sender: TObject);
    procedure lblCincoReaisClick(Sender: TObject);
    procedure lblDezReaisClick(Sender: TObject);
    procedure lblVinteReaisClick(Sender: TObject);
    procedure lblCinquentaReaisClick(Sender: TObject);
    procedure lblCemReaisClick(Sender: TObject);
  private
    FValor:Currency;
    FOnClickConfirmar: TProc<TObject>;
    FLimparValor:Boolean;
    procedure SetValor(const AValue:Currency);
    procedure AtualizarValor(AValue:string);
    procedure AntesDeDigitarNoTeclado();
  public
    procedure AfterConstruction; override;
    procedure OpenDinheiro;
    procedure CloseDinheiro;
    procedure FaltaPagar(const AValue:Currency);
    property OnClickConfirmar:TProc<TObject> read FOnClickConfirmar write FOnClickConfirmar;
    function Valor:Currency;
  end;

implementation

{$R *.fmx}

procedure TFramePagamentoTecladoDinheiro.AfterConstruction;
begin
  inherited;
  FrameComponentesTeclado1.AtualizarValorDigitado := AtualizarValor;
  FrameComponentesTeclado1.AntesDoClickNoTeclado := AntesDeDigitarNoTeclado;
  FLimparValor := False;
end;

procedure TFramePagamentoTecladoDinheiro.AntesDeDigitarNoTeclado;
begin
  if FLimparValor then
    FrameComponentesTeclado1.SetValorDigitado('0');
  FLimparValor := False;
end;

procedure TFramePagamentoTecladoDinheiro.AtualizarValor(AValue: string);
begin
  var LFormatValue             := TModelUtils.FormatCurrencyValue(AValue);
  var LFormatValueReplacePonto := LFormatValue.Replace('.', '', [rfReplaceAll]);
  var LCurrencyValue           := StrToCurrDef(LFormatValueReplacePonto, 0);
  SetValor(LCurrencyValue);
end;

procedure TFramePagamentoTecladoDinheiro.CloseDinheiro;
begin
  Self.Visible := False;
end;

procedure TFramePagamentoTecladoDinheiro.FaltaPagar(const AValue: Currency);
begin
  lblFaltaPagar.Text := 'Falta pagar R$ '+FormatFloat('#,##0.00',AValue);
  SetValor(AValue);
  FrameComponentesTeclado1.SetValorDigitado(FormatFloat('#,##0.00',AValue));
  FLimparValor := True;
end;

procedure TFramePagamentoTecladoDinheiro.FrameResize(Sender: TObject);
begin
  recPrincipal.Height := Self.Height - 80;
  FrameComponentesTeclado1.OnResize(Sender);
  layDoisReais.Width      := layPrimeiraLinhaValores.Width / 3;
  layCincoReais.Width     := layPrimeiraLinhaValores.Width / 3;
  layDezReais.Width       := layPrimeiraLinhaValores.Width / 3;

  layVinteReais.Width     := laySegundaLinha.Width / 2;
  layCinquentaReais.Width := laySegundaLinha.Width / 2;
end;

procedure TFramePagamentoTecladoDinheiro.lblCancelarClick(Sender: TObject);
begin
  CloseDinheiro;
end;

procedure TFramePagamentoTecladoDinheiro.lblCemReaisClick(Sender: TObject);
begin
  if FLimparValor then
    FValor := 0;
  FValor := FValor + 100;
  FrameComponentesTeclado1.SetValorDigitado(FormatFloat('#,##0.00',FValor));
  SetValor(FValor);
  FLimparValor := False;
end;

procedure TFramePagamentoTecladoDinheiro.lblCincoReaisClick(Sender: TObject);
begin
  if FLimparValor then
    FValor := 0;
  FValor := FValor + 5;
  FrameComponentesTeclado1.SetValorDigitado(FormatFloat('#,##0.00',FValor));
  SetValor(FValor);
  FLimparValor := False;
end;

procedure TFramePagamentoTecladoDinheiro.lblCinquentaReaisClick(
  Sender: TObject);
begin
  if FLimparValor then
    FValor := 0;
  FValor := FValor + 50;
  FrameComponentesTeclado1.SetValorDigitado(FormatFloat('#,##0.00',FValor));
  SetValor(FValor);
  FLimparValor := False;
end;

procedure TFramePagamentoTecladoDinheiro.lblConfirmarClick(Sender: TObject);
begin
  CloseDinheiro;
  if Assigned(FOnClickConfirmar) then
    FOnClickConfirmar(Self);
end;

procedure TFramePagamentoTecladoDinheiro.lblDezReaisClick(Sender: TObject);
begin
  if FLimparValor then
    FValor := 0;
  FValor := FValor + 10;
  FrameComponentesTeclado1.SetValorDigitado(FormatFloat('#,##0.00',FValor));
  SetValor(FValor);
  FLimparValor := False;
end;

procedure TFramePagamentoTecladoDinheiro.lblDoisReaisClick(Sender: TObject);
begin
  if FLimparValor then
    FValor := 0;
  FValor := FValor + 2;
  FrameComponentesTeclado1.SetValorDigitado(FormatFloat('#,##0.00',FValor));
  SetValor(FValor);
  FLimparValor := False;
end;

procedure TFramePagamentoTecladoDinheiro.lblVinteReaisClick(Sender: TObject);
begin
  if FLimparValor then
    FValor := 0;
  FValor := FValor + 20;
  FrameComponentesTeclado1.SetValorDigitado(FormatFloat('#,##0.00',FValor));
  SetValor(FValor);
  FLimparValor := False;
end;

procedure TFramePagamentoTecladoDinheiro.OpenDinheiro;
begin
  Self.OnResize(Self);
  Self.Visible := True;
end;

procedure TFramePagamentoTecladoDinheiro.SetValor(const AValue: Currency);
begin
  FValor        := AValue;
  lblValor.Text := 'R$ '+FormatFloat('#,##0.00',FValor);
end;

function TFramePagamentoTecladoDinheiro.Valor: Currency;
begin
  Result := FValor;
end;

end.
