unit Model.Pedido.CalculoDesconto;

interface

uses
  System.SysUtils,Model.Pedido.Valores.Desconto;
  type
  TModelPedidoCalculoDesconto = class
  private
    FValorBrutoSubTotal: Currency;
    procedure SetValorBrutoSubTotal(const Value: Currency);
  public
    property ValorBrutoSubTotal: Currency read FValorBrutoSubTotal write SetValorBrutoSubTotal;
    function CalcularPorPorcentagem(APorcentagem: Currency):TValoresDesconto;
    function CalcularPorValor(AValor: Currency):TValoresDesconto;
    function CalcularPorSubTotal(ASubtotal: Currency):TValoresDesconto;
  end;

implementation

{ TModelPedidoCalculoDesconto }

function TModelPedidoCalculoDesconto.CalcularPorPorcentagem
  (APorcentagem: Currency):TValoresDesconto;
begin
  Result.DescontoPorcentagem         := APorcentagem;
  Result.DescontoPorcentagemFomatado := FormatFloat('#,##0.00',APorcentagem);

  Result.DescontoReais               := FValorBrutoSubTotal * (APorcentagem / 100);
  Result.DescontoReaisFormatado      := 'R$ '+FormatFloat('#,##0.00',Result.DescontoReais);

  Result.ValorTotal                  := (FValorBrutoSubTotal - Result.DescontoReais);
  Result.ValorTotalFormatado         := 'R$ '+FormatFloat('#,##0.00',Result.ValorTotal);
end;

function TModelPedidoCalculoDesconto.CalcularPorSubTotal(
  ASubtotal: Currency): TValoresDesconto;
begin
  Result.DescontoReais               := FValorBrutoSubTotal - ASubtotal;
  Result.DescontoReaisFormatado      := 'R$ '+FormatFloat('#,##0.00',Result.DescontoReais);

  Result.DescontoPorcentagem         := ((Result.DescontoReais/FValorBrutoSubTotal)*100);
  Result.DescontoPorcentagemFomatado := FormatFloat('#,##0.00',Result.DescontoPorcentagem)+' %';

  Result.ValorTotal                  := (FValorBrutoSubTotal - Result.DescontoReais);
  Result.ValorTotalFormatado         := 'R$ '+FormatFloat('#,##0.00',Result.ValorTotal);
end;

function TModelPedidoCalculoDesconto.CalcularPorValor(
  AValor: Currency): TValoresDesconto;
begin
  Result.DescontoReais               := AValor;
  Result.DescontoReaisFormatado      := 'R$ '+FormatFloat('#,##0.00',Result.DescontoReais);

  Result.ValorTotal                  := (FValorBrutoSubTotal - Result.DescontoReais);
  Result.ValorTotalFormatado         := 'R$ '+FormatFloat('#,##0.00',(Result.ValorTotal));

  Result.DescontoPorcentagem         := ((Result.DescontoReais/FValorBrutoSubTotal)*100);
  Result.DescontoPorcentagemFomatado := FormatFloat('#,##0.00',Result.DescontoPorcentagem);
end;

procedure TModelPedidoCalculoDesconto.SetValorBrutoSubTotal
  (const Value: Currency);
begin
  FValorBrutoSubTotal := Value;
end;

end.
