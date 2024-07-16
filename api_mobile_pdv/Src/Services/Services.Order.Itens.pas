unit Services.Order.Itens;

interface
uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PGDef, FireDAC.Phys.PG,
  FireDAC.Comp.UI,
  FireDAC.DApt,
  Services.Base,
  System.SysUtils,
  DataSet.Serialize,
  System.JSON,
  REST.Json,
  Entities.Order.Itens;

type
  TServicesOrderItens = class(TServicesBase<TEntitiesOrderItens>)
  private
  public
    function SelectAll(const AOrder:string): TJSONObject;
    function SelectById(const AId: string): TJSONObject; override;
    function Insert(AEntity: TEntitiesOrderItens):TJSONObject; override;
    procedure Update(AEntity: TEntitiesOrderItens); override;
    procedure Delete(AEntity: TEntitiesOrderItens); override;
    procedure AfterConstruction; override;

  end;

implementation

{ TServicesOrderItens }


procedure TServicesOrderItens.AfterConstruction;
begin
  inherited;
  Route := 'order-itens';
end;

procedure TServicesOrderItens.Delete(AEntity: TEntitiesOrderItens);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.order_itens');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Pedido Item não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from order_itens');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicesOrderItens.Insert(AEntity: TEntitiesOrderItens):TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.order_itens');
  Query.SQL.Add('(id, number_item, order_id, product_id, amount,');
  Query.SQL.Add('discount_value, discount_percentage, cfop, user_id,');
  Query.SQL.Add('origin, csosn_cst, cst_pis, ppis, vpis, cst_cofins, pcofins,');
  Query.SQL.Add('vcofins, subtotal, total, created_at, comanda, descricao)');
  Query.SQL.Add('VALUES(:id, :number_item, :order_id, :product_id, :amount,');
  Query.SQL.Add(':discount_value, :discount_percentage, :cfop, :user_id,');
  Query.SQL.Add(':origin, :csosn_cst, :cst_pis, :ppis, :vpis, :cst_cofins,');
  Query.SQL.Add(':pcofins, :vcofins, :subtotal, :total, :created_at, :comanda, :descricao)');
  Query.ParamByName('id').AsString                    := AEntity.Id;
  Query.ParamByName('number_item').AsInteger          := 0;
  Query.ParamByName('order_id').AsString              := AEntity.OrderId;
  Query.ParamByName('product_id').AsString            := AEntity.ProductId;
  Query.ParamByName('amount').AsFloat                 := AEntity.Amount;
  Query.ParamByName('discount_value').AsFloat         := AEntity.DiscountValue;
  Query.ParamByName('discount_percentage').AsFloat    := AEntity.DiscountPercentage;
  Query.ParamByName('cfop').AsString                  := AEntity.Cfop;
  Query.ParamByName('origin').AsString                := AEntity.Origin;
  Query.ParamByName('csosn_cst').AsString             := AEntity.CsosnCst;
  Query.ParamByName('cst_pis').AsString               := AEntity.CstPis;
  Query.ParamByName('ppis').AsFloat                   := AEntity.Ppis;
  Query.ParamByName('vpis').AsFloat                   := AEntity.Vpis;
  Query.ParamByName('cst_cofins').AsString            := AEntity.CstCofins;
  Query.ParamByName('pcofins').AsFloat                := AEntity.Pcofins;
  Query.ParamByName('vcofins').AsFloat                := AEntity.Vcofins;
  Query.ParamByName('subtotal').AsFloat               := AEntity.Subtotal;
  Query.ParamByName('total').AsFloat                  := AEntity.Total;
  Query.ParamByName('created_at').AsDateTime          := Now();
  Query.ParamByName('user_id').AsString               := AEntity.UserId;
  Query.ParamByName('comanda').AsInteger              := AEntity.Comanda;
  Query.ParamByName('descricao').AsString             := AEntity.Descricao;
  Query.ExecSQL();

  Result := TJson.ObjectToJsonObject(AEntity);
  Result.RemovePair('list').Free;
end;

function TServicesOrderItens.SelectAll(const AOrder:string): TJSONObject;
begin
  DataBase := 'order_itens';
  ValidatePermission(TMethodPermission.methodGET);

  QueryRecordCount.Close;
  QueryRecordCount.SQL.Clear;
  QueryRecordCount.SQL.Add('select count(id) from order_itens');
  QueryRecordCount.SQL.Add('where order_id = :order_id');
  QueryRecordCount.ParamByName('order_id').AsString := AOrder;
  QueryRecordCount.Open();

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from order_itens');
  Query.SQL.Add('where order_id = :order_id');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.ParamByName('order_id').AsString := AOrder;
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesOrderItens.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from order_itens');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AId;
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesOrderItens.Update(AEntity: TEntitiesOrderItens);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.order_itens');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Pedido Itens não encontrado!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('update public.order_itens set');
  Query.SQL.Add('number_item = :number_item, order_id = :order_id,');
  Query.SQL.Add('product_id = :product_id, amount = :amount,  discount_value = :discount_value,');
  Query.SQL.Add('discount_percentage = :discount_percentage, cfop = :cfop,');
  Query.SQL.Add('origin = :origin, csosn_cst = :csosn_cst, cst_pis = :cst_pis,');
  Query.SQL.Add('ppis = :ppis, vpis = :vpis, cst_cofins = :cst_cofins,comanda = :comanda, descricao = :descricao,');
  Query.SQL.Add('pcofins = :pcofins, vcofins = :vcofins, subtotal = :subtotal,');
  Query.SQL.Add('total = :total, updated_at = :updated_at, observation = :observation');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString                    := AEntity.Id;
  Query.ParamByName('number_item').AsInteger          := 0;
  Query.ParamByName('order_id').AsString              := AEntity.OrderId;
  Query.ParamByName('product_id').AsString            := AEntity.ProductId;
  Query.ParamByName('amount').AsFloat                 := AEntity.Amount;
  Query.ParamByName('discount_value').AsFloat         := AEntity.DiscountValue;
  Query.ParamByName('discount_percentage').AsFloat    := AEntity.DiscountPercentage;
  Query.ParamByName('cfop').AsString                  := AEntity.Cfop;
  Query.ParamByName('origin').AsString                := AEntity.Origin;
  Query.ParamByName('csosn_cst').AsString             := AEntity.CsosnCst;
  Query.ParamByName('cst_pis').AsString               := AEntity.CstPis;
  Query.ParamByName('ppis').AsFloat                   := AEntity.Ppis;
  Query.ParamByName('vpis').AsFloat                   := AEntity.Vpis;
  Query.ParamByName('cst_cofins').AsString            := AEntity.CstCofins;
  Query.ParamByName('pcofins').AsFloat                := AEntity.Pcofins;
  Query.ParamByName('vcofins').AsFloat                := AEntity.Vcofins;
  Query.ParamByName('subtotal').AsFloat               := AEntity.Subtotal;
  Query.ParamByName('total').AsFloat                  := AEntity.Total;
  Query.ParamByName('updated_at').AsDateTime          := Now();
  Query.ParamByName('observation').AsString           := AEntity.Observation;
  Query.ParamByName('comanda').AsInteger              := AEntity.Comanda;
  Query.ParamByName('descricao').AsString             := AEntity.Descricao;

  // Não altera usuário que lança
  Query.ExecSQL();
end;

end.
