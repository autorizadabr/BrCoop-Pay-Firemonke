unit DAO.Pedido.Item;

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
  DAO.Base,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  TPedidoItem = class
  private
    FDescontoValor: Double;
    FSubtotal: Double;
    FValorUnitario: Double;
    FPpis: Double;
    FTotal: Double;
    FPcofins: Double;
    FVpis: Double;
    FOrigin: String;
    FVcofins: Double;
    FCstPis: String;
    FCstCofins: String;
    FObservation: TArray<String>;
    FProductId: String;
    FCfop: String;
    FQuantidade: Integer;
    FDescontoPorcentagem: Double;
    FCsosnCst: String;
    FId: Integer;
    FPedidoId: Integer;
    FUserId: string;
    FIdOrderItemApi: string;
    FSync: Integer;
    FDescricao: string;
    FComanda: Integer;
  public
    property Id: Integer read FId write FId;
    property PedidoId: Integer read FPedidoId write FPedidoId;
    property ProductId: String read FProductId write FProductId;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property DescontoValor: Double read FDescontoValor write FDescontoValor;
    property DescontoPorcentagem: Double read FDescontoPorcentagem write FDescontoPorcentagem;
    property Cfop: String read FCfop write FCfop;
    property Observation: TArray<String> read FObservation write FObservation;
    property Origin: String read FOrigin write FOrigin;
    property CsosnCst: String read FCsosnCst write FCsosnCst;
    property CstPis: String read FCstPis write FCstPis;
    property Ppis: Double read FPpis write FPpis;
    property Vpis: Double read FVpis write FVpis;
    property CstCofins: String read FCstCofins write FCstCofins;
    property Pcofins: Double read FPcofins write FPcofins;
    property Vcofins: Double read FVcofins write FVcofins;
    property ValorUnitario: Double read FValorUnitario write FValorUnitario;
    property Subtotal: Double read FSubtotal write FSubtotal;
    property Total: Double read FTotal write FTotal;
    property IdOrderItemApi:string read FIdOrderItemApi write FIdOrderItemApi;
    property UserId:string read FUserId write FUserId;
    property Sync:Integer read FSync write FSync;
    property Comanda:Integer read FComanda write FComanda;
    property Descricao:string read FDescricao write FDescricao;
    function ObservarionString:string;
    procedure CarregarObservation(const AValue:string);
  end;
  TDAOPedidoItem = class(TDAOBase)
  private
    FConexao:TFDConnection;
    FPedidoItem:TPedidoItem;
  public
    constructor Create(const AConexao:TFDConnection);
    property Item:TPedidoItem read FPedidoItem;
    procedure Gravar(ASync:Integer = 0);
    procedure Atualizar;
    procedure RemoverItemPorId(const AId:Integer);
    procedure AlterarComanda(AIdBanco,ANumeroComanda:Integer;ADescricao:string);
    procedure CarregarItemPedido(const AId:Integer);
    function ListarPedidoItem(const AIdOrder:Integer): TList<TPedidoItem>;
    procedure AlterarUsuario(const AOrdeId:Integer;const AUserId:string);
  end;

implementation

{ TDAOPedidoItem }

procedure TDAOPedidoItem.AlterarComanda(AIdBanco, ANumeroComanda: Integer;
  ADescricao: string);
begin
  var LQueryPedidoItens        := TFDQuery.Create(nil);
  LQueryPedidoItens.Connection := FConexao;
  try
    LQueryPedidoItens.Close;
    LQueryPedidoItens.SQL.Clear;
    LQueryPedidoItens.SQL.Add('update order_itens set comanda = :comanda, descricao = :descricao');
    LQueryPedidoItens.SQL.Add('where id = :id');
    LQueryPedidoItens.SQL.Add('and (user_id = ''''  or user_id = null)');
    LQueryPedidoItens.ParamByName('id').AsInteger       := AIdBanco;
    LQueryPedidoItens.ParamByName('comanda').AsInteger  := ANumeroComanda;
    LQueryPedidoItens.ParamByName('descricao').AsString := ADescricao;
    LQueryPedidoItens.ExecSQL;
  finally
    FreeAndNil(LQueryPedidoItens);
  end;
end;

procedure TDAOPedidoItem.AlterarUsuario(const AOrdeId: Integer;
  const AUserId: string);
begin
  var LQueryPedidoItens        := TFDQuery.Create(nil);
  LQueryPedidoItens.Connection := FConexao;
  try
    LQueryPedidoItens.Close;
    LQueryPedidoItens.SQL.Clear;
    LQueryPedidoItens.SQL.Add('update order_itens set user_id = :user_id');
    LQueryPedidoItens.SQL.Add('where order_id = :order_id');
    LQueryPedidoItens.SQL.Add('and (user_id = ''''  or user_id = null)');
    LQueryPedidoItens.ParamByName('order_id').AsInteger := AOrdeId;
    LQueryPedidoItens.ParamByName('user_id').AsString   := AUserId;
    LQueryPedidoItens.ExecSQL;
  finally
    FreeAndNil(LQueryPedidoItens);
  end;
end;

procedure TDAOPedidoItem.Atualizar;
begin
  var LQueryPedidoItens        := TFDQuery.Create(nil);
  LQueryPedidoItens.Connection := FConexao;
  try
    LQueryPedidoItens.Close;
    LQueryPedidoItens.SQL.Clear;
    LQueryPedidoItens.SQL.Add('update order_itens set ');
    LQueryPedidoItens.SQL.Add('id = :id, number_item = :number_item, order_id = :order_id, product_id = :product_id,');
    LQueryPedidoItens.SQL.Add('amount = :amount, discount_value = :discount_value,');
    LQueryPedidoItens.SQL.Add('discount_percentage = :discount_percentage, cfop = :cfop, origin = :origin,');
    LQueryPedidoItens.SQL.Add('csosn_cst = :csosn_cst, cst_pis = :cst_pis, ppis = :ppis, vpis = :vpis, cst_cofins = :cst_cofins,');
    LQueryPedidoItens.SQL.Add('pcofins = :pcofins, vcofins = :vcofins, valor_unitario = :valor_unitario, subtotal = :subtotal, total = :total,');
    LQueryPedidoItens.SQL.Add('updated_at = :updated_at, observation = :observation,');
    LQueryPedidoItens.SQL.Add('id_order_item_api = :id_order_item_api, user_id = :user_id, sync = :sync');
    LQueryPedidoItens.SQL.Add('where id = :id');
    LQueryPedidoItens.ParamByName('id').AsInteger                := Item.Id;
    LQueryPedidoItens.ParamByName('number_item').AsInteger       := 0;
    LQueryPedidoItens.ParamByName('order_id').AsInteger          := Item.PedidoId;
    LQueryPedidoItens.ParamByName('product_id').AsString         := Item.ProductId;
    LQueryPedidoItens.ParamByName('amount').AsFloat              := Item.Quantidade;
    LQueryPedidoItens.ParamByName('discount_value').AsFloat      := Item.DescontoValor;
    LQueryPedidoItens.ParamByName('discount_percentage').AsFloat := Item.DescontoPorcentagem;
    LQueryPedidoItens.ParamByName('cfop').AsString               := Item.Cfop;
    LQueryPedidoItens.ParamByName('observation').AsString        := Item.ObservarionString;
    LQueryPedidoItens.ParamByName('origin').AsString             := Item.Origin;
    LQueryPedidoItens.ParamByName('csosn_cst').AsString          := Item.CsosnCst;
    LQueryPedidoItens.ParamByName('cst_pis').AsString            := Item.CstPis;
    LQueryPedidoItens.ParamByName('ppis').AsFloat                := Item.Ppis;
    LQueryPedidoItens.ParamByName('vpis').AsFloat                := Item.Vpis;
    LQueryPedidoItens.ParamByName('cst_cofins').AsString         := Item.CstCofins;
    LQueryPedidoItens.ParamByName('pcofins').AsFloat             := Item.Pcofins;
    LQueryPedidoItens.ParamByName('vcofins').AsFloat             := Item.Vcofins;
    LQueryPedidoItens.ParamByName('valor_unitario').AsFloat      := Item.ValorUnitario;
    LQueryPedidoItens.ParamByName('subtotal').AsFloat            := Item.Subtotal;
    LQueryPedidoItens.ParamByName('total').AsFloat               := Item.Total;
    LQueryPedidoItens.ParamByName('updated_at').AsString         := DateTimeToStr(Now);
    LQueryPedidoItens.ParamByName('id_order_item_api').AsString  := Item.IdOrderItemApi;
    LQueryPedidoItens.ParamByName('user_id').AsString            := Item.UserId;
    LQueryPedidoItens.ParamByName('sync').AsInteger              := 0;
    LQueryPedidoItens.ExecSQL;

    LQueryPedidoItens.Close;
    LQueryPedidoItens.SQL.Clear;
    LQueryPedidoItens.SQL.Add('select * from order_itens');
    LQueryPedidoItens.SQL.Add('where order_id = :order_id');
    LQueryPedidoItens.ParamByName('order_id').AsInteger := Item.PedidoId;
    LQueryPedidoItens.Open();

    var LValorTotal:Double := 0;
    var LSubtotal:Double   := 0;
    LQueryPedidoItens.First;
    while not LQueryPedidoItens.Eof do
    begin
      LValorTotal := LValorTotal + LQueryPedidoItens.FieldByName('total').AsFloat;
      LSubtotal   := LSubtotal + LQueryPedidoItens.FieldByName('subtotal').AsFloat;
      LQueryPedidoItens.Next;
    end;

    LQueryPedidoItens.Close;
    LQueryPedidoItens.SQL.Clear;
    LQueryPedidoItens.SQL.Add('update "order" set');
    LQueryPedidoItens.SQL.Add('subtotal = :subtotal, total = :total,');
    LQueryPedidoItens.SQL.Add('sync = :sync, updated_at = :updated_at');
    LQueryPedidoItens.SQL.Add('where id = :id');
    LQueryPedidoItens.ParamByName('id').AsInteger        := Item.PedidoId;
    LQueryPedidoItens.ParamByName('subtotal').AsFloat    := LSubtotal;
    LQueryPedidoItens.ParamByName('total').AsFloat       := LValorTotal;
    LQueryPedidoItens.ParamByName('updated_at').AsString := DateTimeToStr(Now);
    LQueryPedidoItens.ParamByName('sync').AsInteger      := 0;
    LQueryPedidoItens.ExecSQL;

  finally
    FreeAndNil(LQueryPedidoItens);
  end;
end;

procedure TDAOPedidoItem.CarregarItemPedido(const AId: Integer);
begin
  var LQuery        := TFDQuery.Create(nil);
  LQuery.Connection := FConexao;
  try
    LQuery.Close;
    LQuery.SQL.Clear;
    LQuery.SQL.Add('select * from order_itens where id = :id');
    LQuery.ParamByName('id').AsInteger := AId;
    LQuery.Open;
    if LQuery.RecordCount > 0 then
    begin
      Item.Id                  := LQuery.FieldByName('id').AsInteger;
      Item.PedidoId            := LQuery.FieldByName('order_id').AsInteger;
      Item.ProductId           := LQuery.FieldByName('product_id').AsString;
      Item.Quantidade          := LQuery.FieldByName('amount').AsInteger;
      Item.DescontoValor       := LQuery.FieldByName('discount_value').AsFloat;
      Item.DescontoPorcentagem := LQuery.FieldByName('discount_percentage').AsFloat;
      Item.Cfop                := LQuery.FieldByName('cfop').AsString;
      Item.CarregarObservation(LQuery.FieldByName('observation').AsString);
      Item.Origin              := LQuery.FieldByName('origin').AsString;
      Item.CsosnCst            := LQuery.FieldByName('csosn_cst').AsString;
      Item.CstPis              := LQuery.FieldByName('cst_pis').AsString;
      Item.Ppis                := LQuery.FieldByName('ppis').AsFloat;
      Item.Vpis                := LQuery.FieldByName('vpis').AsFloat;
      Item.CstCofins           := LQuery.FieldByName('cst_cofins').AsString;
      Item.Pcofins             := LQuery.FieldByName('pcofins').AsFloat;
      Item.Vcofins             := LQuery.FieldByName('vcofins').AsFloat;
      Item.ValorUnitario       := LQuery.FieldByName('valor_unitario').AsFloat;
      Item.Subtotal            := LQuery.FieldByName('subtotal').AsFloat;
      Item.Total               := LQuery.FieldByName('total').AsFloat;
      Item.IdOrderItemApi      := LQuery.FieldByName('id_order_item_api').AsString;
      Item.UserId              := '';
    end;
  finally
    FreeAndNil(LQuery);
  end;
end;

constructor TDAOPedidoItem.Create(const AConexao: TFDConnection);
begin
  FPedidoItem := TPedidoItem.Create;
  FConexao    := AConexao;
end;

procedure TDAOPedidoItem.Gravar(ASync:Integer = 0);
begin
  var LQueryPedidoItens        := TFDQuery.Create(nil);
  LQueryPedidoItens.Connection := FConexao;
  try
    LQueryPedidoItens.Close;
    LQueryPedidoItens.SQL.Clear;
    LQueryPedidoItens.SQL.Add('INSERT INTO order_itens');
    LQueryPedidoItens.SQL.Add('(id, number_item, order_id, product_id,');
    LQueryPedidoItens.SQL.Add('amount, discount_value,');
    LQueryPedidoItens.SQL.Add('discount_percentage, cfop, origin,');
    LQueryPedidoItens.SQL.Add('csosn_cst, cst_pis, ppis, vpis, cst_cofins,');
    LQueryPedidoItens.SQL.Add('pcofins, vcofins, valor_unitario, subtotal, total,');
    LQueryPedidoItens.SQL.Add('created_at, updated_at, observation,');
    LQueryPedidoItens.SQL.Add('id_order_item_api, user_id, sync)');
    LQueryPedidoItens.SQL.Add('VALUES(:id, :number_item, :order_id,');
    LQueryPedidoItens.SQL.Add(':product_id, :amount, :discount_value,');
    LQueryPedidoItens.SQL.Add(':discount_percentage, :cfop, :origin,');
    LQueryPedidoItens.SQL.Add(':csosn_cst, :cst_pis, :ppis, :vpis,');
    LQueryPedidoItens.SQL.Add(':cst_cofins, :pcofins, :vcofins,');
    LQueryPedidoItens.SQL.Add(':valor_unitario, :subtotal, :total,');
    LQueryPedidoItens.SQL.Add(':created_at, :updated_at, :observation,');
    LQueryPedidoItens.SQL.Add(':id_order_item_api, :user_id, :sync);');

    var LQuerySelectMax        := TFDQuery.Create(nil);
    LQuerySelectMax.Connection := FConexao;
    try
      LQuerySelectMax.Close;
      LQuerySelectMax.SQL.Clear;
      LQuerySelectMax.SQL.Add('select COALESCE(max(id),0) +1 as ID from order_itens');
      LQuerySelectMax.Open();

      Item.Id := LQuerySelectMax.FieldByName('id').AsInteger;
      LQueryPedidoItens.Close;
      LQueryPedidoItens.ParamByName('id').AsInteger                := Item.Id;
      LQueryPedidoItens.ParamByName('number_item').AsInteger       := 0;
      LQueryPedidoItens.ParamByName('order_id').AsInteger          := Item.PedidoId;
      LQueryPedidoItens.ParamByName('product_id').AsString         := Item.ProductId;
      LQueryPedidoItens.ParamByName('amount').AsFloat              := Item.Quantidade;
      LQueryPedidoItens.ParamByName('discount_value').AsFloat      := Item.DescontoValor;
      LQueryPedidoItens.ParamByName('discount_percentage').AsFloat := Item.DescontoPorcentagem;
      LQueryPedidoItens.ParamByName('cfop').AsString               := Item.Cfop;
      LQueryPedidoItens.ParamByName('observation').AsString        := Item.ObservarionString;
      LQueryPedidoItens.ParamByName('origin').AsString             := Item.Origin;
      LQueryPedidoItens.ParamByName('csosn_cst').AsString          := Item.CsosnCst;
      LQueryPedidoItens.ParamByName('cst_pis').AsString            := Item.CstPis;
      LQueryPedidoItens.ParamByName('ppis').AsFloat                := Item.Ppis;
      LQueryPedidoItens.ParamByName('vpis').AsFloat                := Item.Vpis;
      LQueryPedidoItens.ParamByName('cst_cofins').AsString         := Item.CstCofins;
      LQueryPedidoItens.ParamByName('pcofins').AsFloat             := Item.Pcofins;
      LQueryPedidoItens.ParamByName('vcofins').AsFloat             := Item.Vcofins;
      LQueryPedidoItens.ParamByName('valor_unitario').AsFloat      := Item.ValorUnitario;
      LQueryPedidoItens.ParamByName('subtotal').AsFloat            := Item.Subtotal;
      LQueryPedidoItens.ParamByName('total').AsFloat               := Item.Total;
      LQueryPedidoItens.ParamByName('created_at').AsString         := DateTimeToStr(Now);
      LQueryPedidoItens.ParamByName('updated_at').AsString         := DateTimeToStr(Now);
      LQueryPedidoItens.ParamByName('id_order_item_api').AsString  := Item.IdOrderItemApi;
      LQueryPedidoItens.ParamByName('user_id').AsString            := Item.UserId;
      LQueryPedidoItens.ParamByName('sync').AsInteger              := 0;
      LQueryPedidoItens.ExecSQL;

      LQueryPedidoItens.Close;
      LQueryPedidoItens.SQL.Clear;
      LQueryPedidoItens.SQL.Add('select * from order_itens');
      LQueryPedidoItens.SQL.Add('where order_id = :order_id');
      LQueryPedidoItens.ParamByName('order_id').AsInteger := Item.PedidoId;
      LQueryPedidoItens.Open();

      var LValorTotal:Double := 0;
      var LSubtotal:Double   := 0;
      LQueryPedidoItens.First;
      while not LQueryPedidoItens.Eof do
      begin
        LValorTotal := LValorTotal + LQueryPedidoItens.FieldByName('total').AsFloat;
        LSubtotal   := LSubtotal + LQueryPedidoItens.FieldByName('subtotal').AsFloat;
        LQueryPedidoItens.Next;
      end;

      LQueryPedidoItens.Close;
      LQueryPedidoItens.SQL.Clear;
      LQueryPedidoItens.SQL.Add('update "order" set');
      LQueryPedidoItens.SQL.Add('subtotal = :subtotal, total = :total,');
      LQueryPedidoItens.SQL.Add('sync = :sync, updated_at = :updated_at');
      LQueryPedidoItens.SQL.Add('where id = :id');
      LQueryPedidoItens.ParamByName('id').AsInteger        := Item.PedidoId;
      LQueryPedidoItens.ParamByName('subtotal').AsFloat    := LSubtotal;
      LQueryPedidoItens.ParamByName('total').AsFloat       := LValorTotal;
      LQueryPedidoItens.ParamByName('updated_at').AsString := DateTimeToStr(Now);
      LQueryPedidoItens.ParamByName('sync').AsInteger      := ASync;
      LQueryPedidoItens.ExecSQL;




    finally
       FreeAndNil(LQuerySelectMax);
    end;
  finally
    FreeAndNil(LQueryPedidoItens);
  end;
end;

function TDAOPedidoItem.ListarPedidoItem(const AIdOrder:Integer): TList<TPedidoItem>;
begin
  Result            := TList<TPedidoItem>.Create;
  var LQuery        := TFDQuery.Create(nil);
  LQuery.Connection := FConexao;
  try
    LQuery.Close;
    LQuery.SQL.Clear;
    LQuery.SQL.Add('select * from order_itens where order_id = :order_id');
    LQuery.ParamByName('order_id').AsInteger := AIdOrder;
    LQuery.Open;
    while not LQuery.Eof do
    begin
      var LPedidoItem                 := TPedidoItem.Create;
      LPedidoItem.Id                  := LQuery.FieldByName('id').AsInteger;
      LPedidoItem.PedidoId            := LQuery.FieldByName('order_id').AsInteger;
      LPedidoItem.ProductId           := LQuery.FieldByName('product_id').AsString;
      LPedidoItem.Quantidade          := LQuery.FieldByName('amount').AsInteger;
      LPedidoItem.DescontoValor       := LQuery.FieldByName('discount_value').AsFloat;
      LPedidoItem.DescontoPorcentagem := LQuery.FieldByName('discount_percentage').AsFloat;
      LPedidoItem.Cfop                := LQuery.FieldByName('cfop').AsString;
      LPedidoItem.CarregarObservation(LQuery.FieldByName('observation').AsString);
      LPedidoItem.Origin              := LQuery.FieldByName('origin').AsString;
      LPedidoItem.CsosnCst            := LQuery.FieldByName('csosn_cst').AsString;
      LPedidoItem.CstPis              := LQuery.FieldByName('cst_pis').AsString;
      LPedidoItem.Ppis                := LQuery.FieldByName('ppis').AsFloat;
      LPedidoItem.Vpis                := LQuery.FieldByName('vpis').AsFloat;
      LPedidoItem.CstCofins           := LQuery.FieldByName('cst_cofins').AsString;
      LPedidoItem.Pcofins             := LQuery.FieldByName('pcofins').AsFloat;
      LPedidoItem.Vcofins             := LQuery.FieldByName('vcofins').AsFloat;
      LPedidoItem.ValorUnitario       := LQuery.FieldByName('valor_unitario').AsFloat;
      LPedidoItem.Subtotal            := LQuery.FieldByName('subtotal').AsFloat;
      LPedidoItem.Total               := LQuery.FieldByName('total').AsFloat;
      LPedidoItem.IdOrderItemApi      := LQuery.FieldByName('id_order_item_api').AsString;
      LPedidoItem.UserId              := LQuery.FieldByName('user_id').AsString;
      LPedidoItem.Comanda             := LQuery.FieldByName('comanda').AsInteger;
      LPedidoItem.Descricao           := LQuery.FieldByName('descricao').AsString;
      Result.Add(LPedidoItem);
      LQuery.Next;
    end;
  finally
    FreeAndNil(LQuery);
  end;
end;

procedure TDAOPedidoItem.RemoverItemPorId(const AId: Integer);
begin
  var LQuery        := TFDQuery.Create(nil);
  LQuery.Connection := FConexao;
  try
    LQuery.Close;
    LQuery.SQL.Clear;
    LQuery.SQL.Add('delete from order_itens where id = :id');
    LQuery.ParamByName('id').AsInteger := AId;
    LQuery.ExecSQL;
  finally
    FreeAndNil(LQuery);
  end;
end;

{ TPedidoItem }

procedure TPedidoItem.CarregarObservation(const AValue: string);
begin
  var LStringList := TStringList.Create;
  try
    LStringList.Text := AValue;
    SetLength(FObservation, LStringList.Count);
    for var I := 0 to Pred(LStringList.Count) do
    begin
      FObservation[I] := LStringList[I];
    end;
  finally
    FreeAndNil(LStringList);
  end;
end;

function TPedidoItem.ObservarionString: string;
begin
  Result := EmptyStr;
  var LStringList := TStringList.Create;
  try
    for var I := Low(FObservation) to High(FObservation) do
    begin
      LStringList.Add(FObservation[I]);
    end;
    Result := LStringList.Text;
  finally
    FreeAndNil(LStringList);
  end;
end;

end.
