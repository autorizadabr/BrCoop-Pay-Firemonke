unit Model.Pagamento.Pedido;

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
  Model.Carrinho.Item,
  System.SysUtils, Model.Records.Pagamento.Pedido,
  System.Classes,
  System.Generics.Collections, Model.Static.Credencial, Model.Connection;

type
  TModelPagamentoPedido = class
  private
    FListaPagamentoPedido: TList<TPagamentoPedido>;
    FConexao: TFDConnection;
  public
    constructor Create();
    destructor Destroy; override;
    procedure AddItem(APagamentoPedido:TPagamentoPedido);
    procedure LimparLista;
    procedure Gravar;
    function ListaPagamentos:TList<TPagamentoPedido>;
  end;

implementation

{ TModelPagamentoPedido }

procedure TModelPagamentoPedido.AddItem(APagamentoPedido:TPagamentoPedido);
begin
  FListaPagamentoPedido.Add(APagamentoPedido);
end;

constructor TModelPagamentoPedido.Create();
begin
  FConexao              := ModelConnection.Connection;
  FListaPagamentoPedido := TList<TPagamentoPedido>.Create;
end;

destructor TModelPagamentoPedido.Destroy;
begin
  FreeAndNil(FListaPagamentoPedido);
  inherited;
end;

procedure TModelPagamentoPedido.Gravar;
begin
  TThread.CreateAnonymousThread(
  procedure
  begin
    var LQueryPagamentoPedido        := TFDQuery.Create(nil);
    LQueryPagamentoPedido.Connection := FConexao;
    try
      LQueryPagamentoPedido.Close;
      LQueryPagamentoPedido.SQL.Clear;
      LQueryPagamentoPedido.SQL.Add('delete from cart_payment');
      LQueryPagamentoPedido.ExecSQL();

      if FListaPagamentoPedido.Count > 0 then
      begin
        LQueryPagamentoPedido.Close;
        LQueryPagamentoPedido.SQL.Clear;
        LQueryPagamentoPedido.SQL.Add('INSERT INTO cart_payment');
        LQueryPagamentoPedido.SQL.Add('(id, order_id, payment_id, nsu,');
        LQueryPagamentoPedido.SQL.Add('autorization_code, date_time_autorization,');
        LQueryPagamentoPedido.SQL.Add('flag, amount_paid, created_at)');
        LQueryPagamentoPedido.SQL.Add('VALUES(:id, :order_id, :payment_id, :nsu,');
        LQueryPagamentoPedido.SQL.Add(':autorization_code, :date_time_autorization,');
        LQueryPagamentoPedido.SQL.Add(':flag, :amount_paid, :created_at)');

        var LId := 1;
        for var I := 0 to Pred(FListaPagamentoPedido.Count) do
        begin
          LQueryPagamentoPedido.Close;
          LQueryPagamentoPedido.ParamByName('id').AsInteger                    := LId;
          LQueryPagamentoPedido.ParamByName('order_id').AsString               := FListaPagamentoPedido[i].OrderId;
          LQueryPagamentoPedido.ParamByName('payment_id').AsString             := FListaPagamentoPedido[i].PaymentId;
          LQueryPagamentoPedido.ParamByName('nsu').AsString                    := '';
          LQueryPagamentoPedido.ParamByName('autorization_code').AsString      := DateTimeToStr(Now);
          LQueryPagamentoPedido.ParamByName('date_time_autorization').AsString := '';
          LQueryPagamentoPedido.ParamByName('flag').AsString                   := '';
          LQueryPagamentoPedido.ParamByName('amount_paid').AsFloat             := FListaPagamentoPedido[i].ValorPago;
          LQueryPagamentoPedido.ParamByName('created_at').AsString             := DateTimeToStr(Now);
          LQueryPagamentoPedido.ExecSQL;

          Inc(LId);
        end;
        FListaPagamentoPedido.Clear;
      end;
    finally
      FreeAndNil(LQueryPagamentoPedido);
    end;
  end).Start;
end;

procedure TModelPagamentoPedido.LimparLista;
begin
  FListaPagamentoPedido.Clear;
end;

function TModelPagamentoPedido.ListaPagamentos: TList<TPagamentoPedido>;
begin
  Result := FListaPagamentoPedido;
end;

end.
