unit Model.Records.Pagamento.Pedido;

interface
  type
  TPagamentoPedido = record
    Id:Integer;
    OrderId:string;
    PaymentId:string;
    ValorPago:Double;
  end;
implementation

end.
