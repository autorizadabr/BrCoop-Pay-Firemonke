unit Model.Carrinho;

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
  System.SysUtils,
  System.Generics.Collections, Model.Static.Credencial;

type
  TModelCarrinho = class
  private
    FListaCarrinhoItem: TList<TModelCarrinhoItem>;
    FConexao: TFDConnection;
    FTroco: Currency;
    FSubtotal: Currency;
    FTotal: Currency;
  public
    function ListaItens:TList<TModelCarrinhoItem>;
    constructor Create(AConexao: TFDConnection);
    procedure AddItem(ACarrinhoItem: TModelCarrinhoItem);
    procedure Limpar;
    procedure Gravar;
    destructor Destroy; override;
  end;

implementation

{ TModelCarrinho }

procedure TModelCarrinho.AddItem(ACarrinhoItem: TModelCarrinhoItem);
begin
  FListaCarrinhoItem.Add(ACarrinhoItem);
end;

constructor TModelCarrinho.Create(AConexao: TFDConnection);
begin
  FConexao           := AConexao;
  FListaCarrinhoItem := TList<TModelCarrinhoItem>.Create;
end;

destructor TModelCarrinho.Destroy;
begin
  FreeAndNil(FListaCarrinhoItem);
  inherited;
end;

procedure TModelCarrinho.Gravar;
begin
  FTotal := 0;
  FTroco := 0;
  FSubtotal := 0;
  var
  LQueryCarrinho := TFDQuery.Create(nil);
  LQueryCarrinho.Connection := FConexao;
  try
    LQueryCarrinho.Close;
    LQueryCarrinho.SQL.Clear;
    LQueryCarrinho.SQL.Add('INSERT INTO cart');
    LQueryCarrinho.SQL.Add('(id, company_id, user_id, customer_id, type_order,');
    LQueryCarrinho.SQL.Add('cpf_cnpj, addition, discount, troco, subtotal,');
    LQueryCarrinho.SQL.Add('total, created_at, updated_at)');
    LQueryCarrinho.SQL.Add('VALUES(:id, :company_id, :user_id, :customer_id,');
    LQueryCarrinho.SQL.Add(':type_order, :cpf_cnpj, :addition, :discount,');
    LQueryCarrinho.SQL.Add(':troco, :subtotal, :total, :created_at, :updated_at);');
    LQueryCarrinho.ParamByName('id').AsString          := '1';
    LQueryCarrinho.ParamByName('company_id').AsString  := TModelStaticCredencial.GetInstance.Company;
    LQueryCarrinho.ParamByName('user_id').AsString     := TModelStaticCredencial.GetInstance.User;;
    LQueryCarrinho.ParamByName('customer_id').AsString := TModelStaticCredencial.GetInstance.CustomerDefault;
    LQueryCarrinho.ParamByName('type_order').AsInteger := 1;
    LQueryCarrinho.ParamByName('cpf_cnpj').AsString    := '';
    LQueryCarrinho.ParamByName('addition').AsFloat     := 0;
    LQueryCarrinho.ParamByName('discount').AsFloat     := 0;
    LQueryCarrinho.ParamByName('troco').AsFloat        := FTroco;
    LQueryCarrinho.ParamByName('subtotal').AsFloat     := FSubtotal;
    LQueryCarrinho.ParamByName('total').AsFloat        := FTotal;
    LQueryCarrinho.ParamByName('created_at').AsString  := DateTimeToStr(Now);
    LQueryCarrinho.ParamByName('updated_at').AsString  := DateTimeToStr(Now);
    LQueryCarrinho.ExecSQL;

    var LQueryCarrinhoItens        := TFDQuery.Create(nil);
    LQueryCarrinhoItens.Connection := FConexao;
    try
      LQueryCarrinhoItens.Close;
      LQueryCarrinhoItens.SQL.Clear;
      LQueryCarrinhoItens.SQL.Add('INSERT INTO cart_itens');
      LQueryCarrinhoItens.SQL.Add('(id, number_item, order_id, product_id,');
      LQueryCarrinhoItens.SQL.Add('amount, discount_value,');
      LQueryCarrinhoItens.SQL.Add('discount_percentage, cfop, origin,');
      LQueryCarrinhoItens.SQL.Add('csosn_cst, cst_pis, ppis, vpis, cst_cofins,');
      LQueryCarrinhoItens.SQL.Add('pcofins, vcofins, valor_unitario, subtotal, total,');
      LQueryCarrinhoItens.SQL.Add('created_at, updated_at, observation)');
      LQueryCarrinhoItens.SQL.Add('VALUES(:id, :number_item, :order_id,');
      LQueryCarrinhoItens.SQL.Add(':product_id, :amount, :discount_value,');
      LQueryCarrinhoItens.SQL.Add(':discount_percentage, :cfop, :origin,');
      LQueryCarrinhoItens.SQL.Add(':csosn_cst, :cst_pis, :ppis, :vpis,');
      LQueryCarrinhoItens.SQL.Add(':cst_cofins, :pcofins, :vcofins,');
      LQueryCarrinhoItens.SQL.Add(':valor_unitario, :subtotal, :total,');
      LQueryCarrinhoItens.SQL.Add(':created_at, :updated_at, :observation);');

      FTotal := 0;
      FTroco := 0;
      FSubtotal := 0;
      var LDesconto:Currency := 0;
      for var I := 0 to Pred(FListaCarrinhoItem.Count) do
      begin
        LQueryCarrinhoItens.Close;
        LQueryCarrinhoItens.ParamByName('id').AsString                 := (I+1).ToString;
        LQueryCarrinhoItens.ParamByName('number_item').AsInteger       := FListaCarrinhoItem[i].NumberId;
        LQueryCarrinhoItens.ParamByName('order_id').AsString           := '1';
        LQueryCarrinhoItens.ParamByName('product_id').AsString         := FListaCarrinhoItem[i].Produto;
        LQueryCarrinhoItens.ParamByName('amount').AsFloat              := FListaCarrinhoItem[i].Quantidade;
        LQueryCarrinhoItens.ParamByName('discount_value').AsFloat      := FListaCarrinhoItem[i].DescontoValor;
        LQueryCarrinhoItens.ParamByName('discount_percentage').AsFloat := FListaCarrinhoItem[i].DescontoPorcentagem;
        LQueryCarrinhoItens.ParamByName('cfop').AsString               := FListaCarrinhoItem[i].RegraFiscal.CfopInterno;
        LQueryCarrinhoItens.ParamByName('observation').AsString        := FListaCarrinhoItem[i].ObservacaoList.Text;
        LQueryCarrinhoItens.ParamByName('origin').AsString             := FListaCarrinhoItem[i].RegraFiscal.Origin;
        LQueryCarrinhoItens.ParamByName('csosn_cst').AsString          := FListaCarrinhoItem[i].RegraFiscal.CsosnCst;
        LQueryCarrinhoItens.ParamByName('cst_pis').AsString            := FListaCarrinhoItem[i].RegraFiscal.CstPis;
        LQueryCarrinhoItens.ParamByName('ppis').AsString               := FListaCarrinhoItem[i].RegraFiscal.PPis;
        LQueryCarrinhoItens.ParamByName('vpis').AsString               := '';
        LQueryCarrinhoItens.ParamByName('cst_cofins').AsString         := FListaCarrinhoItem[i].RegraFiscal.CstCofins;
        LQueryCarrinhoItens.ParamByName('pcofins').AsString            := FListaCarrinhoItem[i].RegraFiscal.PCofins;
        LQueryCarrinhoItens.ParamByName('vcofins').AsString            := '';
        LQueryCarrinhoItens.ParamByName('valor_unitario').AsFloat      := FListaCarrinhoItem[i].ValorUnitario;
        LQueryCarrinhoItens.ParamByName('subtotal').AsFloat            := FListaCarrinhoItem[i].Subtoal;
        LQueryCarrinhoItens.ParamByName('total').AsFloat               := FListaCarrinhoItem[i].Total;
        LQueryCarrinhoItens.ParamByName('created_at').AsString         := DateTimeToStr(Now);
        LQueryCarrinhoItens.ParamByName('updated_at').AsString         := DateTimeToStr(Now);
        LQueryCarrinhoItens.ExecSQL;
        LDesconto := LDesconto + FListaCarrinhoItem[i].DescontoValor;
        FTotal    := FTotal + FListaCarrinhoItem[i].Total;
        FSubtotal := FSubtotal + FListaCarrinhoItem[i].Subtoal;
      end;

      LQueryCarrinho.Close;
      LQueryCarrinho.SQL.Clear;
      LQueryCarrinho.SQL.Add('update cart');
      LQueryCarrinho.SQL.Add('set total = :total, subtotal = :subtotal,');
      LQueryCarrinho.SQL.Add('discount = :discount, updated_at = :updated_at');
      LQueryCarrinho.SQL.Add('where id = :id');
      LQueryCarrinho.ParamByName('id').AsString          := '1';
      LQueryCarrinho.ParamByName('discount').AsFloat     := LDesconto;
      LQueryCarrinho.ParamByName('subtotal').AsFloat     := FSubtotal;
      LQueryCarrinho.ParamByName('total').AsFloat        := FTotal;
      LQueryCarrinho.ParamByName('updated_at').AsString  := DateToStr(Now);
      LQueryCarrinho.ExecSQL;

    finally
      LQueryCarrinhoItens.Free;
    end;
    for var X := Pred(FListaCarrinhoItem.Count) downto 0  do
      FListaCarrinhoItem[X].Free;
    FListaCarrinhoItem.Clear;
  finally
    FreeAndNil(LQueryCarrinho);
  end;
end;

procedure TModelCarrinho.Limpar;
begin
  var LQueryCarrinho        := TFDQuery.Create(nil);
  LQueryCarrinho.Connection := FConexao;
  try
    LQueryCarrinho.Close;
    LQueryCarrinho.SQL.Clear;
    LQueryCarrinho.SQL.Add('delete from cart');
    LQueryCarrinho.ExecSQL;

    LQueryCarrinho.Close;
    LQueryCarrinho.SQL.Clear;
    LQueryCarrinho.SQL.Add('delete from cart_itens');
    LQueryCarrinho.ExecSQL;

    LQueryCarrinho.Close;
    LQueryCarrinho.SQL.Clear;
    LQueryCarrinho.SQL.Add('delete from cart_payment');
    LQueryCarrinho.ExecSQL;
  finally
    FreeAndNil(LQueryCarrinho);
  end;
end;

function TModelCarrinho.ListaItens: TList<TModelCarrinhoItem>;
begin
  Result := TList<TModelCarrinhoItem>.Create;
  var LQueryCarrinhoItens        := TFDQuery.Create(nil);
  LQueryCarrinhoItens.Connection := FConexao;
  try

    LQueryCarrinhoItens.Close;
    LQueryCarrinhoItens.SQL.Clear;
    LQueryCarrinhoItens.SQL.Add('Select * from  cart_itens');
    LQueryCarrinhoItens.SQL.Add('order by number_item');
    LQueryCarrinhoItens.Open();

    LQueryCarrinhoItens.First;
    while not LQueryCarrinhoItens.Eof do
    begin
      var LModelCattinhoItens := TModelCarrinhoItem.Create;

      LModelCattinhoItens
          .NumberId(LQueryCarrinhoItens.FieldByName('number_item').AsInteger)
          .Sequencial(LQueryCarrinhoItens.FieldByName('number_item').AsInteger)
          .Produto(LQueryCarrinhoItens.FieldByName('product_id').AsString)
          .Quantidade(LQueryCarrinhoItens.FieldByName('amount').AsInteger)
          .CarregarObservacaoPorText(LQueryCarrinhoItens.FieldByName('observation').AsString)
          .DescontoPorcentagem(LQueryCarrinhoItens.FieldByName('discount_percentage').AsFloat)
          .DescontoValor(LQueryCarrinhoItens.FieldByName('discount_value').AsFloat)
          .ValorUnitario(LQueryCarrinhoItens.FieldByName('valor_unitario').AsFloat)
          .Subtoal(LQueryCarrinhoItens.FieldByName('subtotal').AsFloat)
          .Total(LQueryCarrinhoItens.FieldByName('total').AsFloat);
      Result.Add(LModelCattinhoItens);
      LQueryCarrinhoItens.Next;
    end;
  finally
    LQueryCarrinhoItens.Free;
  end;
end;

end.
