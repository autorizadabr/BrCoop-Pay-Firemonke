unit Model.Pedido.Gerar.Pedido;

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
 DAO.Pedido, DAO.Pedido.Item;
type
  TModelPedidoGerarPedido = class
  private
    FConexao:TFDConnection;
    procedure GravarPagamentoPedido(const APedido:Integer);
    procedure GravarPedidoItens(const APedido: Integer;AQueryCarrihno:TFDQuery);
    procedure GravarPedido;
  public
    constructor Create(AConexao:TFDConnection);
    procedure GerarPedido;
  end;

implementation

{ TModelPedidoGerarPedido }

constructor TModelPedidoGerarPedido.Create(AConexao: TFDConnection);
begin
  FConexao := AConexao;
end;

procedure TModelPedidoGerarPedido.GerarPedido;
begin
  GravarPedido;
  var LQueryDelete        := TFDQuery.Create(nil);
  LQueryDelete.Connection := FConexao;
  try
    LQueryDelete.Close;
    LQueryDelete.SQL.Clear;
    LQueryDelete.SQL.Add('delete from cart');
    LQueryDelete.ExecSQL();

    LQueryDelete.Close;
    LQueryDelete.SQL.Clear;
    LQueryDelete.SQL.Add('delete from cart_itens');
    LQueryDelete.ExecSQL();

    LQueryDelete.Close;
    LQueryDelete.SQL.Clear;
    LQueryDelete.SQL.Add('delete from cart_payment');
    LQueryDelete.ExecSQL();
  finally
    FreeAndNil(LQueryDelete);
  end;
end;

procedure TModelPedidoGerarPedido.GravarPagamentoPedido(const APedido:Integer);
begin
  var LQueryCarrinhoPagamento        := TFDQuery.Create(nil);
  LQueryCarrinhoPagamento.Connection := FConexao;
  try

    LQueryCarrinhoPagamento.Close;
    LQueryCarrinhoPagamento.SQL.Clear;
    LQueryCarrinhoPagamento.SQL.Add('select * from cart_payment');
    LQueryCarrinhoPagamento.Open();


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

        var LIdPagamentoPedido := LQuerySelectMax.FieldByName('id').AsInteger;

        LQueryCarrinhoPagamento.First;
        while not (LQueryCarrinhoPagamento.Eof) do
        begin
          LQueryPagamentoPedido.Close;
          LQueryPagamentoPedido.ParamByName('id').AsInteger                    := LIdPagamentoPedido;
          LQueryPagamentoPedido.ParamByName('order_id').AsInteger              := APedido;
          LQueryPagamentoPedido.ParamByName('payment_id').AsString             := LQueryCarrinhoPagamento.FieldByName('payment_id').AsString;
          LQueryPagamentoPedido.ParamByName('nsu').AsString                    := '';
          LQueryPagamentoPedido.ParamByName('autorization_code').AsString      := '';
          LQueryPagamentoPedido.ParamByName('date_time_autorization').AsString := DateToStr(Now);
          LQueryPagamentoPedido.ParamByName('flag').AsString                   := '';
          LQueryPagamentoPedido.ParamByName('amount_paid').AsFloat             := LQueryCarrinhoPagamento.FieldByName('amount_paid').AsFloat;
          LQueryPagamentoPedido.ParamByName('created_at').AsString             := DateTimeToStr(Now);
          LQueryPagamentoPedido.ParamByName('updated_at').AsString             := DateTimeToStr(Now);
          LQueryPagamentoPedido.ExecSQL;
          LQueryCarrinhoPagamento.Next;
          Inc(LIdPagamentoPedido);
        end;

      finally
        FreeAndNil(LQuerySelectMax);
      end;

    finally
      FreeAndNil(LQueryPagamentoPedido);
    end;
  finally
    FreeAndNil(LQueryCarrinhoPagamento);
  end;

end;

procedure TModelPedidoGerarPedido.GravarPedidoItens(const APedido: Integer;AQueryCarrihno:TFDQuery);
begin
  var LDaoPedidotItem := TDAOPedidoItem.Create(FConexao);
  try
    LDaoPedidotItem.Item.PedidoId            := APedido;
    LDaoPedidotItem.Item.ProductId           := AQueryCarrihno.FieldByName('product_id').AsString;
    LDaoPedidotItem.Item.Quantidade          := AQueryCarrihno.FieldByName('amount').AsInteger;
    LDaoPedidotItem.Item.DescontoValor       := AQueryCarrihno.FieldByName('discount_value').AsFloat;
    LDaoPedidotItem.Item.DescontoPorcentagem := AQueryCarrihno.FieldByName('discount_percentage').AsFloat;
    LDaoPedidotItem.Item.Cfop                := AQueryCarrihno.FieldByName('cfop').AsString;
    LDaoPedidotItem.Item.CarregarObservation(AQueryCarrihno.FieldByName('observation').AsString);
    LDaoPedidotItem.Item.Origin              := AQueryCarrihno.FieldByName('origin').AsString;
    LDaoPedidotItem.Item.CsosnCst            := AQueryCarrihno.FieldByName('csosn_cst').AsString;
    LDaoPedidotItem.Item.CstPis              := AQueryCarrihno.FieldByName('cst_pis').AsString;
    LDaoPedidotItem.Item.Ppis                := AQueryCarrihno.FieldByName('ppis').AsFloat;
    LDaoPedidotItem.Item.Vpis                := AQueryCarrihno.FieldByName('vpis').AsFloat;
    LDaoPedidotItem.Item.CstCofins           := AQueryCarrihno.FieldByName('cst_cofins').AsString;
    LDaoPedidotItem.Item.Pcofins             := AQueryCarrihno.FieldByName('pcofins').AsFloat;
    LDaoPedidotItem.Item.Vcofins             := AQueryCarrihno.FieldByName('vcofins').AsFloat;
    LDaoPedidotItem.Item.ValorUnitario       := AQueryCarrihno.FieldByName('valor_unitario').AsFloat;
    LDaoPedidotItem.Item.Subtotal            := AQueryCarrihno.FieldByName('subtotal').AsFloat;
    LDaoPedidotItem.Item.Total               := AQueryCarrihno.FieldByName('total').AsFloat;
    LDaoPedidotItem.Gravar;
  finally
    FreeAndNil(LDaoPedidotItem);
  end;
end;

procedure TModelPedidoGerarPedido.GravarPedido;
begin
  var LQueryCarrinho        := TFDQuery.Create(nil);
  LQueryCarrinho.Connection := FConexao;
  try
    LQueryCarrinho.Close;
    LQueryCarrinho.SQL.Clear;
    LQueryCarrinho.SQL.Add('select * from cart c');
    LQueryCarrinho.SQL.Add('left join cart_itens ci');
    LQueryCarrinho.Open();

    try
      var LIdPedido:Integer;
      var LDaoPedido := TDAOPedido.Create(FConexao);
      try
        LQueryCarrinho.First;
        while not LQueryCarrinho.Eof do
        begin

          LDaoPedido.Dados.EmpresaId          := LQueryCarrinho.FieldByName('company_id').AsString;
          LDaoPedido.Dados.UsuarioId          := LQueryCarrinho.FieldByName('user_id').AsString;
          LDaoPedido.Dados.ClienteId          := LQueryCarrinho.FieldByName('customer_id').AsString;
          LDaoPedido.Dados.TypeOrder          := LQueryCarrinho.FieldByName('type_order').AsInteger;
          LDaoPedido.Dados.CpfCnpj            := LQueryCarrinho.FieldByName('cpf_cnpj').AsString;
          LDaoPedido.Dados.DescontoValor      := LQueryCarrinho.FieldByName('discount').AsFloat;
          LDaoPedido.Dados.DescontoPorcentage := LQueryCarrinho.FieldByName('discount').AsFloat;
          LDaoPedido.Dados.Troco              := LQueryCarrinho.FieldByName('troco').AsFloat;
          LDaoPedido.Dados.Subtotal           := LQueryCarrinho.FieldByName('subtotal').AsFloat;
          LDaoPedido.Dados.Total              := LQueryCarrinho.FieldByName('total').AsFloat;
          LDaoPedido.Dados.Status             := stFechado;
          LDaoPedido.Gravar;
          LIdPedido := LDaoPedido.Dados.Id;

          GravarPedidoItens(LIdPedido,LQueryCarrinho);
          GravarPagamentoPedido(LIdPedido);

          LQueryCarrinho.Next;
        end;
      finally
        FreeAndNil(LDaoPedido);
      end;
    except
      on E: Exception do
      begin
        raise Exception.Create(e.Message);
      end;
    end;

  finally
    FreeAndNil(LQueryCarrinho);
  end;
end;

end.
