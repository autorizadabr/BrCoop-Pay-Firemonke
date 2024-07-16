unit DAO.Pedido.Pagamento;

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
  TPedidoPagamento = class
  private
    FSalvoNoBanco:Boolean;
    FPagamentoId: string;
    FQuantiaPaga: Double;
    FPedidoId: Integer;
    FId:Integer;
  public
    property Id:Integer read FId write FId;
    property PedidoId: Integer read FPedidoId write FPedidoId;
    property PagamentoId: string read FPagamentoId write FPagamentoId;
    property QuantiaPaga: Double read FQuantiaPaga write FQuantiaPaga;
    property SalvoNoBanco:Boolean read FSalvoNoBanco write FSalvoNoBanco;
  end;

  TDAOPedidoPagamento = class
  private
    FConexao: TFDConnection;
    FPedidoItem:TPedidoPagamento;
  public
    constructor Create(const AConexao: TFDConnection);
    destructor Destroy;override;
    property Dados:TPedidoPagamento read FPedidoItem;
    procedure Gravar;
    function ListaPagamentoPorPedido(const APedidoId:Integer):TObjectList<TPedidoPagamento>;
    procedure RemoverTodosPorPedido(const APedidoId:Integer);
    procedure RemoverPorId(const AId:Integer);
  end;

implementation

{ TDAOPedidoPagamento }

constructor TDAOPedidoPagamento.Create(const AConexao: TFDConnection);
begin
  FConexao    := AConexao;
  FPedidoItem := TPedidoPagamento.Create;
end;

destructor TDAOPedidoPagamento.Destroy;
begin
  FreeAndNil(FPedidoItem);
  inherited;
end;

procedure TDAOPedidoPagamento.Gravar;
begin
  var LQueryPagamentoPedido        := TFDQuery.Create(nil);
  LQueryPagamentoPedido.Connection := FConexao;
  try
    LQueryPagamentoPedido.Close;
    LQueryPagamentoPedido.SQL.Clear;
    LQueryPagamentoPedido.SQL.Add('INSERT INTO order_payment');
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
      LQuerySelectMax.SQL.Add('select COALESCE(max(id),0) +1 as ID from order_payment');
      LQuerySelectMax.Open();

      Dados.Id := LQuerySelectMax.FieldByName('id').AsInteger;

      LQueryPagamentoPedido.Close;
      LQueryPagamentoPedido.ParamByName('id').AsInteger                    := Dados.Id;
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

function TDAOPedidoPagamento.ListaPagamentoPorPedido(
  const APedidoId: Integer): TObjectList<TPedidoPagamento>;
begin
  Result := TObjectList<TPedidoPagamento>.Create;

  var LQueryPagamentoPedido        := TFDQuery.Create(nil);
  LQueryPagamentoPedido.Connection := FConexao;
  try
    LQueryPagamentoPedido.Close;
    LQueryPagamentoPedido.SQL.Clear;
    LQueryPagamentoPedido.SQL.Add('select * from order_payment');
    LQueryPagamentoPedido.SQL.Add('where order_id = :order_id');
    LQueryPagamentoPedido.ParamByName('order_id').AsInteger := APedidoId;
    LQueryPagamentoPedido.Open();

    LQueryPagamentoPedido.First;
    while not LQueryPagamentoPedido.Eof do
    begin
      var LPedidoPagamento          := TPedidoPagamento.Create;
      LPedidoPagamento.Id           := LQueryPagamentoPedido.FieldByName('id').AsInteger;
      LPedidoPagamento.PagamentoId  := LQueryPagamentoPedido.FieldByName('payment_id').AsString;
      LPedidoPagamento.QuantiaPaga  := LQueryPagamentoPedido.FieldByName('amount_paid').AsFloat;
      LPedidoPagamento.PedidoId     := LQueryPagamentoPedido.FieldByName('order_id').AsInteger;
      LPedidoPagamento.id           := LQueryPagamentoPedido.FieldByName('id').AsInteger;
      LPedidoPagamento.SalvoNoBanco := LQueryPagamentoPedido.FieldByName('id_order_payment_api').AsString.Trim <> '' ;

      Result.Add(LPedidoPagamento);
      LQueryPagamentoPedido.Next;
    end;

  finally
    FreeAndNil(LQueryPagamentoPedido);
  end;
end;

procedure TDAOPedidoPagamento.RemoverPorId(const AId: Integer);
begin
  var LServicePedidoPagamento := TServicePedidoPagamento.Create;
  try
    try
      var LQueryPagamentoPedido        := TFDQuery.Create(nil);
      LQueryPagamentoPedido.Connection := FConexao;
      try

        LQueryPagamentoPedido.Close;
        LQueryPagamentoPedido.SQL.Clear;
        LQueryPagamentoPedido.SQL.Add('delete from order_payment');
        LQueryPagamentoPedido.SQL.Add('where id = :id');
        LQueryPagamentoPedido.ParamByName('id').AsInteger := AId;
        LQueryPagamentoPedido.ExecSQL;
      finally
        FreeAndNil(LQueryPagamentoPedido);
      end;

    except on E: Exception do
      begin

      end;
    end;
  finally
    FreeAndNil(LServicePedidoPagamento);
  end;
end;

procedure TDAOPedidoPagamento.RemoverTodosPorPedido(const APedidoId: Integer);
begin
  var LQueryPagamentoPedido        := TFDQuery.Create(nil);
  LQueryPagamentoPedido.Connection := FConexao;
  try
    LQueryPagamentoPedido.Close;
    LQueryPagamentoPedido.SQL.Clear;
    LQueryPagamentoPedido.SQL.Add('delete from order_payment');
    LQueryPagamentoPedido.SQL.Add('where order_id = :order_id and id_order_payment_api = null or id_order_payment_api = ''''');
    LQueryPagamentoPedido.ParamByName('order_id').AsInteger := APedidoId;
    LQueryPagamentoPedido.ExecSQL;
  finally
    FreeAndNil(LQueryPagamentoPedido);
  end;
end;

{ TPedidoPagamento }


end.
