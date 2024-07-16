unit View.Componentes.Teclado.Quantidade;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, View.Componentes.Teclado,
  Model.Pedido.CalculoDesconto, Model.Pedido.Valores.Desconto;

type
  TFrameComponentesTecladoQuantidade = class(TFrame)
    recBase: TRectangle;
    recPrincipal: TRectangle;
    layNomeProdutoValorTotal: TLayout;
    layValoresQuantidade: TLayout;
    layButtons: TLayout;
    lblQuantidade: TLabel;
    lblDecementar: TLabel;
    lblIncrementar: TLabel;
    lblNomeProduto: TLabel;
    lblCancelar: TLabel;
    lblConfirmar: TLabel;
    FrameComponentesTeclado1: TFrameComponentesTeclado;
    layQuantidade: TLayout;
    lblCaptionQuantidade: TLabel;
    layValorUnitarioDesconto: TLayout;
    lblValorUnitario: TLabel;
    lblValorTotalProduto: TLabel;
    lblDesconto: TLabel;
    layContentTecladoQuantidade: TLayout;
    layProduto: TLayout;
    procedure lblIncrementarClick(Sender: TObject);
    procedure lblDecementarClick(Sender: TObject);
    procedure lblCancelarClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure lblConfirmarClick(Sender: TObject);
  private
    FOnClickConfirmar: TProc<TObject>;
    FPercentualDesconto:Currency;
    FValorUnitatio:Currency;
    FValorDesconto:Currency;
    FQuantidade:Integer;
    FModelPedidoCalculoDesconto:TModelPedidoCalculoDesconto;
    FValoresDesconto:TValoresDesconto;
    FOnClickIncrementoDecremento:Boolean;
    FOnClickNoTecladoNumerico:Boolean;
    procedure AtualizarQuantidade(AValue:String);
    procedure SetOnClickConfirmar(const Value: TProc<TObject>);
    procedure AntesDoClickNoTeclado;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure OpenQuantidade;
    procedure SetNome(AValue:string);
    procedure SetValorUnitario(AValue:Currency);
    procedure SetPercentualDesconto(AValue:Currency);
    procedure SetValorDesconto(AValue:Currency);
    procedure SetQuantidade(AValue:Integer);
    procedure MostrarProduto;
    procedure CloseQuantidade;
    property OnClickConfirmar:TProc<TObject> read FOnClickConfirmar write SetOnClickConfirmar;
    function Quantidade:Integer;
    function ValoresDesconto:TValoresDesconto;
  end;

implementation

{$R *.fmx}

{ TFrameComponentesTecladoQuantidade }

procedure TFrameComponentesTecladoQuantidade.AfterConstruction;
begin
  inherited;
  FrameComponentesTeclado1.AtualizarValorDigitado := AtualizarQuantidade;
  FrameComponentesTeclado1.AntesDoClickNoTeclado  := AntesDoClickNoTeclado;
  CloseQuantidade;
  FModelPedidoCalculoDesconto := TModelPedidoCalculoDesconto.Create;
end;

procedure TFrameComponentesTecladoQuantidade.AtualizarQuantidade(
  AValue: String);
begin
  var LValue         := AValue;
  if FOnClickIncrementoDecremento then
    LValue := Copy(LValue,Lvalue.Length-1);
  var LValueCurrency := StrToCurrDef(LValue,0);
  if LValueCurrency <= 0 then
    LValue := '0';
  lblQuantidade.Text := FormatFloat('#,##',LValueCurrency);

  if lblQuantidade.Text.IsEmpty then
    lblQuantidade.Text := '0';

  FrameComponentesTeclado1.SetValorDigitado(LValue);
  lblConfirmar.Enabled := LValueCurrency > 0;
  lblDecementar.Enabled     := LValueCurrency > 0;

  if (layProduto.Visible) then
    MostrarProduto;
end;

procedure TFrameComponentesTecladoQuantidade.BeforeDestruction;
begin
  FreeAndNil(FModelPedidoCalculoDesconto);
  inherited;
end;

procedure TFrameComponentesTecladoQuantidade.CloseQuantidade;
begin
  Self.Visible := False;
//  layNomeProdutoValorTotal.Visible := False;
//  layValorUnitarioDesconto.Visible := False;
//  layQuantidade.Margins.Top        := 0;
end;

procedure TFrameComponentesTecladoQuantidade.AntesDoClickNoTeclado;
begin
  if FOnClickIncrementoDecremento then
    FrameComponentesTeclado1.SetValorDigitado('0');
  FOnClickNoTecladoNumerico    := True;
  FOnClickIncrementoDecremento := False;
end;

procedure TFrameComponentesTecladoQuantidade.FrameResize(Sender: TObject);
begin
  FrameComponentesTeclado1.OnResize(Self);
end;

procedure TFrameComponentesTecladoQuantidade.lblDecementarClick(Sender: TObject);
begin
  FOnClickIncrementoDecremento := True;
  FOnClickNoTecladoNumerico    := False;
  AtualizarQuantidade((StrToIntDef(lblQuantidade.Text.Replace('.','',[]),0) - 1).Tostring);
end;

procedure TFrameComponentesTecladoQuantidade.lblIncrementarClick(Sender: TObject);
begin
  FOnClickIncrementoDecremento := True;
  FOnClickNoTecladoNumerico    := False;
  AtualizarQuantidade((StrToIntDef(lblQuantidade.Text.Replace('.','',[]),0) + 1).Tostring);
end;

procedure TFrameComponentesTecladoQuantidade.lblCancelarClick(Sender: TObject);
begin
  CloseQuantidade;
end;

procedure TFrameComponentesTecladoQuantidade.lblConfirmarClick(Sender: TObject);
begin
  CloseQuantidade;
  if Assigned(FOnClickConfirmar) then
    FOnClickConfirmar(Self);
end;

procedure TFrameComponentesTecladoQuantidade.MostrarProduto;
begin
  FModelPedidoCalculoDesconto.ValorBrutoSubTotal := (FValorUnitatio * Quantidade);
  FValoresDesconto := FModelPedidoCalculoDesconto.CalcularPorPorcentagem(FPercentualDesconto);

  lblValorUnitario.Text     := lblQuantidade.Text+' UN x R$'+FormatFloat('#,##0.00',FValorUnitatio);
  lblDesconto.Text          := '(Dec.'+FormatFloat('#,##0.00',FPercentualDesconto)+')';
  lblDesconto.Visible       := FValorDesconto <> 0;
  lblValorTotalProduto.Text := 'R$'+FormatFloat('#,##0.00',FValoresDesconto.ValorTotal);
  layProduto.Visible        := True;
end;

procedure TFrameComponentesTecladoQuantidade.OpenQuantidade;
begin
  FrameComponentesTeclado1.OnResize(Self);
  FrameComponentesTeclado1.SetValorDigitado('1');
  lblQuantidade.Text           := '1';
  Self.Visible                 := True;
  layProduto.Visible           := False;
  FOnClickIncrementoDecremento := True;
  FOnClickNoTecladoNumerico    := False;
end;

function TFrameComponentesTecladoQuantidade.Quantidade: Integer;
begin
 Result := StrToIntDef(lblQuantidade.Text.Replace('.','',[]),1);
end;

procedure TFrameComponentesTecladoQuantidade.SetPercentualDesconto(AValue: Currency);
begin
  FPercentualDesconto := AValue;
end;

procedure TFrameComponentesTecladoQuantidade.SetQuantidade(AValue: Integer);
begin
  FQuantidade := AValue;
  AtualizarQuantidade(FQuantidade.ToString);
end;

procedure TFrameComponentesTecladoQuantidade.SetNome(AValue: string);
begin
  lblNomeProduto.Text := AValue;
end;

procedure TFrameComponentesTecladoQuantidade.SetOnClickConfirmar(
  const Value: TProc<TObject>);
begin
  FOnClickConfirmar := Value;
end;

procedure TFrameComponentesTecladoQuantidade.SetValorDesconto(AValue: Currency);
begin
  FValorDesconto := AValue;
end;

procedure TFrameComponentesTecladoQuantidade.SetValorUnitario(AValue: Currency);
begin
  FValorUnitatio := AValue;
end;

function TFrameComponentesTecladoQuantidade.ValoresDesconto: TValoresDesconto;
begin
  Result := FValoresDesconto;
end;

end.
