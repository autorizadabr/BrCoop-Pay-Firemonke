unit DAO.Carrinho.Pagamento;

interface
  uses
{$REGION 'Firedac'}
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
{$ENDREGION}
  System.SysUtils,
  System.Classes,
  System.Generics.Collections, Service.Pedido.Pagamento;

type
  TCarrinhoPagamento = class
  private
    FPagamentoId: string;
    FQuantiaPaga: Double;
    FPedidoId: Integer;
    FId:Integer;
  public
    property Id:Integer read FId write FId;
    property PedidoId: Integer read FPedidoId write FPedidoId;
    property PagamentoId: string read FPagamentoId write FPagamentoId;
    property QuantiaPaga: Double read FQuantiaPaga write FQuantiaPaga;
  end;

  TDAOCarrinhoPagamento = class
  private
    FConexao: TFDConnection;
    FPedidoItem:TCarrinhoPagamento;
  public
    constructor Create(const AConexao: TFDConnection);
    destructor Destroy;override;
    property Dados:TCarrinhoPagamento read FPedidoItem;
    procedure Gravar;
    function ListaPagamento:TObjectList<TCarrinhoPagamento>;
  end;

implementation

{ TDAOCarrinhoPagamento }

constructor TDAOCarrinhoPagamento.Create(const AConexao: TFDConnection);
begin
  FConexao    := AConexao;
  FPedidoItem := TCarrinhoPagamento.Create;
end;

destructor TDAOCarrinhoPagamento.Destroy;
begin
  FreeAndNil(FPedidoItem);
  inherited;
end;

procedure TDAOCarrinhoPagamento.Gravar;
begin
  var LQueryPagamentoPedido        := TFDQuery.Create(nil);
  LQueryPagamentoPedido.Connection := FConexao;
  try
    LQueryPagamentoPedido.Close;
    LQueryPagamentoPedido.SQL.Clear;
    LQueryPagamentoPedido.SQL.Add('INSERT INTO cart_payment');
    LQueryPagamentoPedido.SQL.Add('(id, order_id, payment_id, nsu,');
    LQueryPagamentoPedido.SQL.Add('autorization_code, date_time_autorization,');
    LQueryPagamentoPedido.SQL.Add('flag, amount_paid, created_at,updated_at)');
    LQueryPagamentoPedido.SQL.Add('VALUES(:id, :order_id, :payment_id, :nsu,');
    LQueryPagamentoPedido.SQL.Add(':autorization_code, :date_time_autorization,');
    LQueryPagamentoPedido.SQL.Add(':flag, :amount_paid, :created_at,:updated_at)');

    var LQuerySelectMax        := TFDQuery.Create(nil);
    LQuerySelectMax.Connection := FConexao;
    try
      LQuerySelectMax.Close;
      LQuerySelectMax.SQL.Clear;
      LQuerySelectMax.SQL.Add('select COALESCE(max(id),0) +1 as ID from cart_payment');
      LQuerySelectMax.Open();

      var LIdPagamentoPedido := LQuerySelectMax.FieldByName('id').AsInteger;

      LQueryPagamentoPedido.Close;
      LQueryPagamentoPedido.ParamByName('id').AsInteger                    := LIdPagamentoPedido;
      LQueryPagamentoPedido.ParamByName('order_id').AsInteger              := Dados.PedidoId;
      LQueryPagamentoPedido.ParamByName('payment_id').AsString             := Dados.PagamentoId;
      LQueryPagamentoPedido.ParamByName('nsu').AsString                    := '';
      LQueryPagamentoPedido.ParamByName('autorization_code').AsString      := '';
      LQueryPagamentoPedido.ParamByName('date_time_autorization').AsString := DateTimeToStr(Now);
      LQueryPagamentoPedido.ParamByName('flag').AsString                   := '';
      LQueryPagamentoPedido.ParamByName('amount_paid').AsFloat             := Dados.QuantiaPaga;
      LQueryPagamentoPedido.ParamByName('created_at').AsString             := DateTimeToStr(Now);
      LQueryPagamentoPedido.ParamByName('updated_at').AsString             := DateTimeToStr(Now);
      LQueryPagamentoPedido.ExecSQL;

    finally
      FreeAndNil(LQuerySelectMax);
    end;

  finally
    FreeAndNil(LQueryPagamentoPedido);
  end;
end;

function TDAOCarrinhoPagamento.ListaPagamento: TObjectList<TCarrinhoPagamento>;
begin
  Result := TObjectList<TCarrinhoPagamento>.Create;

  var LQueryPagamentoPedido        := TFDQuery.Create(nil);
  LQueryPagamentoPedido.Connection := FConexao;
  try
    LQueryPagamentoPedido.Close;
    LQueryPagamentoPedido.SQL.Clear;
    LQueryPagamentoPedido.SQL.Add('select * from cart_payment');
    LQueryPagamentoPedido.Open();

    LQueryPagamentoPedido.First;
    while not LQueryPagamentoPedido.Eof do
    begin
      var LPedidoPagamento := TCarrinhoPagamento.Create;
      LPedidoPagamento.PagamentoId := LQueryPagamentoPedido.FieldByName('payment_id').AsString;
      LPedidoPagamento.QuantiaPaga := LQueryPagamentoPedido.FieldByName('amount_paid').AsFloat;
      LPedidoPagamento.PedidoId    := LQueryPagamentoPedido.FieldByName('order_id').AsInteger;
      LPedidoPagamento.id          := LQueryPagamentoPedido.FieldByName('id').AsInteger;

      Result.Add(LPedidoPagamento);
      LQueryPagamentoPedido.Next;
    end;

  finally
    FreeAndNil(LQueryPagamentoPedido);
  end;
end;

end.
