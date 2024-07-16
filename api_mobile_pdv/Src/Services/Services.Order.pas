unit Services.Order;

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
  Rest.Json,
  DataSet.Serialize,
  System.JSON, Entities.Order;

type
  TServicesOrder = class(TServicesBase<TEntitiesOrder>)
  private
  public
    function SelectLargeVolume(const ADateUpdate:TDateTime):TJSONObject;
    function SelectAll: TJSONObject; override;
    function SelectById(const AId: string): TJSONObject; override;
    function SelectByIdItems(const AId: string): TJSONObject;
    function Insert(AEntity: TEntitiesOrder):TJSONObject; override;
    function InsertLagerVolume(AArrayEntity:TArray<TEntitiesOrder>):TJSONObject;
    procedure Update(AEntity: TEntitiesOrder); override;
    procedure Delete(AEntity: TEntitiesOrder); override;
    procedure AfterConstruction; override;

  end;

implementation

{ TServicesOrder }


procedure TServicesOrder.AfterConstruction;
begin
  inherited;
  Route := 'order';
end;

procedure TServicesOrder.Delete(AEntity: TEntitiesOrder);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.order');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Unidade de medida não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from order');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicesOrder.Insert(AEntity: TEntitiesOrder):TJSONObject;
begin
  inherited;
  AEntity.GenerateId;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public."order"');
  Query.SQL.Add('(id, company_id, user_id, customer_id, type_order, cpf_cnpj,');
  Query.SQL.Add('addition, discount, troco, subtotal, total,');
  Query.SQL.Add('created_at, status, comanda, mesa, nome_cliente)');
  Query.SQL.Add('VALUES(:id, :company_id, :user_id, :customer_id, :type_order,');
  Query.SQL.Add(':cpf_cnpj, :addition, :discount, :troco, :subtotal,');
  Query.SQL.Add(':total, :created_at, :status, :comanda, :mesa, :nome_cliente);');
  Query.ParamByName('id').AsString           := AEntity.Id;
  Query.ParamByName('company_id').AsString   := AEntity.CompanyId;
  Query.ParamByName('user_id').AsString      := AEntity.UserId;
  Query.ParamByName('customer_id').AsString  := AEntity.CustomerId;
  Query.ParamByName('type_order').AsInteger  := AEntity.TypeOrder;
  Query.ParamByName('cpf_cnpj').AsString     := AEntity.CpfCnpj;
  Query.ParamByName('addition').AsFloat      := AEntity.Addition;
  Query.ParamByName('discount').AsFloat      := AEntity.Discount;
  Query.ParamByName('troco').AsFloat         := AEntity.Troco;
  Query.ParamByName('subtotal').AsFloat      := AEntity.Subtotal;
  Query.ParamByName('total').AsFloat         := AEntity.Total;
  Query.ParamByName('created_at').AsDateTime := Now();
  Query.ParamByName('status').AsString       := AEntity.Status;
  Query.ParamByName('comanda').AsInteger     := AEntity.Comanda;
  Query.ParamByName('mesa').AsInteger        := AEntity.Mesa;
  Query.ParamByName('nome_cliente').AsString := AEntity.NomeCliente;
  Query.ExecSQL();
  Result := TJson.ObjectToJsonObject(AEntity);
  Result.RemovePair('list').Free;
end;

function TServicesOrder.InsertLagerVolume(
  AArrayEntity: TArray<TEntitiesOrder>): TJSONObject;
begin
  var LJsonArrayOrder := TJSONArray.Create;
  for var I := Low(AArrayEntity) to High(AArrayEntity) do
  begin

    AArrayEntity[i].GenerateId;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('INSERT INTO public."order"');
    Query.SQL.Add('(id, company_id, user_id, customer_id, type_order, cpf_cnpj,');
    Query.SQL.Add('addition, discount, troco, subtotal, total,');
    Query.SQL.Add('created_at)');
    Query.SQL.Add('VALUES(:id, :company_id, :user_id, :customer_id, :type_order,');
    Query.SQL.Add(':cpf_cnpj, :addition, :discount, :troco, :subtotal,');
    Query.SQL.Add(':total, :created_at);');
    Query.ParamByName('id').AsString           := AArrayEntity[i].Id;
    Query.ParamByName('company_id').AsString   := AArrayEntity[i].CompanyId;
    Query.ParamByName('user_id').AsString      := AArrayEntity[i].UserId;
    Query.ParamByName('customer_id').AsString  := AArrayEntity[i].CustomerId;
    Query.ParamByName('type_order').AsInteger  := AArrayEntity[i].TypeOrder;
    Query.ParamByName('cpf_cnpj').AsString     := AArrayEntity[i].CpfCnpj;
    Query.ParamByName('addition').AsFloat      := AArrayEntity[i].Addition;
    Query.ParamByName('discount').AsFloat      := AArrayEntity[i].Discount;
    Query.ParamByName('troco').AsFloat         := AArrayEntity[i].Troco;
    Query.ParamByName('subtotal').AsFloat      := AArrayEntity[i].Subtotal;
    Query.ParamByName('total').AsFloat         := AArrayEntity[i].Total;
    Query.ParamByName('created_at').AsDateTime := Now();
    Query.ExecSQL();

    var LJsonArrayOrderItems    := TJSONArray.Create;
    var LQueryOrderItems        := TFDQuery.Create(nil);
    LQueryOrderItems.Connection := Connection;
    try
      for var X := 0  to Pred(AArrayEntity[i].List.Count) do
      begin
        AArrayEntity[i].List[x].GenerateId;
        LQueryOrderItems.Close;
        LQueryOrderItems.SQL.Clear;
        LQueryOrderItems.SQL.Add('INSERT INTO public.order_itens');
        LQueryOrderItems.SQL.Add('(id, number_item, order_id, product_id, amount,');
        LQueryOrderItems.SQL.Add('discount_value, discount_percentage, cfop,');
        LQueryOrderItems.SQL.Add('origin, csosn_cst, cst_pis, ppis, vpis, cst_cofins, pcofins,');
        LQueryOrderItems.SQL.Add('vcofins, subtotal, total, created_at, observation)');
        LQueryOrderItems.SQL.Add('VALUES(:id, :number_item, :order_id, :product_id, :amount,');
        LQueryOrderItems.SQL.Add(':discount_value, :discount_percentage, :cfop,');
        LQueryOrderItems.SQL.Add(':origin, :csosn_cst, :cst_pis, :ppis, :vpis, :cst_cofins,');
        LQueryOrderItems.SQL.Add(':pcofins, :vcofins, :subtotal, :total, :created_at, :observation)');
        LQueryOrderItems.ParamByName('id').AsString                 := AArrayEntity[i].List[x].Id;
        LQueryOrderItems.ParamByName('number_item').AsInteger       := 0;
        LQueryOrderItems.ParamByName('order_id').AsString           := AArrayEntity[i].Id;
        LQueryOrderItems.ParamByName('product_id').AsString         := AArrayEntity[i].List[x].ProductId;
        LQueryOrderItems.ParamByName('amount').AsFloat              := AArrayEntity[i].List[x].Amount;
        LQueryOrderItems.ParamByName('discount_value').AsFloat      := AArrayEntity[i].List[x].DiscountValue;
        LQueryOrderItems.ParamByName('discount_percentage').AsFloat := AArrayEntity[i].List[x].DiscountPercentage;
        LQueryOrderItems.ParamByName('observation').AsString        := AArrayEntity[i].List[x].Observation;
        LQueryOrderItems.ParamByName('cfop').AsString               := AArrayEntity[i].List[x].Cfop;
        LQueryOrderItems.ParamByName('origin').AsString             := AArrayEntity[i].List[x].Origin;
        LQueryOrderItems.ParamByName('csosn_cst').AsString          := AArrayEntity[i].List[x].CsosnCst;
        LQueryOrderItems.ParamByName('cst_pis').AsString            := AArrayEntity[i].List[x].CstPis;
        LQueryOrderItems.ParamByName('ppis').AsFloat                := AArrayEntity[i].List[x].Ppis;
        LQueryOrderItems.ParamByName('vpis').AsFloat                := AArrayEntity[i].List[x].Vpis;
        LQueryOrderItems.ParamByName('cst_cofins').AsString         := AArrayEntity[i].List[x].CstCofins;
        LQueryOrderItems.ParamByName('pcofins').AsFloat             := AArrayEntity[i].List[x].Pcofins;
        LQueryOrderItems.ParamByName('vcofins').AsFloat             := AArrayEntity[i].List[x].Vcofins;
        LQueryOrderItems.ParamByName('subtotal').AsFloat            := AArrayEntity[i].List[x].Subtotal;
        LQueryOrderItems.ParamByName('total').AsFloat               := AArrayEntity[i].List[x].Total;
        LQueryOrderItems.ParamByName('created_at').AsDateTime       := Now();
        LQueryOrderItems.ExecSQL();

        LJsonArrayOrderItems.Add(TJson.ObjectToJsonObject(AArrayEntity[i].List[x]));
      end;

      var LQueryOrderPayment        := TFDQuery.Create(nil);
      LQueryOrderPayment.Connection := Connection;
      try
        for var Y := 0  to Pred(AArrayEntity[i].ListOrderPayment.Count) do
        begin
          AArrayEntity[i].ListOrderPayment[Y].GenerateId;
          Query.Close;
          Query.SQL.Clear;
          Query.SQL.Add('INSERT INTO public.order_payment');
          Query.SQL.Add('(id, order_id, payment_id, nsu, autorization_code,');
          Query.SQL.Add('date_time_autorization, flag, amount_paid, created_at)');
          Query.SQL.Add('VALUES(:id, :order_id, :payment_id, :nsu, :autorization_code,');
          Query.SQL.Add(':date_time_autorization, :flag, :amount_paid, :created_at);');
          Query.ParamByName('id').AsString                       := AArrayEntity[i].ListOrderPayment[Y].Id;
          Query.ParamByName('order_id').AsString                 := AArrayEntity[i].Id;
          Query.ParamByName('payment_id').AsString               := AArrayEntity[i].ListOrderPayment[Y].PaymentId;
          Query.ParamByName('nsu').AsString                      := AArrayEntity[i].ListOrderPayment[Y].Nsu;
          Query.ParamByName('autorization_code').AsString        := AArrayEntity[i].ListOrderPayment[Y].AutorizationCode;
          Query.ParamByName('date_time_autorization').AsDateTime := AArrayEntity[i].ListOrderPayment[Y].DateTimeAutorization;
          Query.ParamByName('flag').AsString                     := AArrayEntity[i].ListOrderPayment[Y].Flag;
          Query.ParamByName('amount_paid').AsFloat               := AArrayEntity[i].ListOrderPayment[Y].AmountPaid;
          Query.ParamByName('created_at').AsDateTime             := Now();
          Query.ExecSQL();
        end;
      finally
        FreeAndNil(LQueryOrderPayment);
      end;


    finally
      FreeAndNil(LQueryOrderItems);
    end;

    var LJsonObjectOrder := TJson.ObjectToJsonObject(AArrayEntity[i]);
    LJsonObjectOrder.RemovePair('list').Free;
    LJsonObjectOrder.AddPair('orderItems',LJsonArrayOrderItems);

    LJsonArrayOrder.Add(LJsonObjectOrder);
  end;

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Length(AArrayEntity));
  FServicesResponsePagination.SetData(LJsonArrayOrder);
  Result := FServicesResponsePagination.Content;
end;

function TServicesOrder.SelectAll: TJSONObject;
begin
  DataBase := '"order"';
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from "order"');
  Query.SQL.Add('where company_id = :company_id');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.ParamByName('company_id').AsString := CurrentCompany;
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesOrder.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from "order"');
  Query.SQL.Add('where id = :id and company_id = :company_id');
  Query.ParamByName('id').AsString         := AId;
  Query.ParamByName('company_id').AsString := CurrentCompany;
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

function TServicesOrder.SelectByIdItems(const AId: string): TJSONObject;
begin
  ValidatePermission(TMethodPermission.methodGET);
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from "order"');
  Query.SQL.Add('where id = :id and company_id = :company_id');
  Query.ParamByName('id').AsString         := AId;
  Query.ParamByName('company_id').AsString := CurrentCompany;
  Query.Open();

  var LJsonOrder := Query.ToJSONObject();


  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from "order_itens"');
  Query.SQL.Add('where order_id = :order_id');
  Query.ParamByName('order_id').AsString := AId;
  Query.Open();

  LJsonOrder.AddPair('items',Query.ToJSONArray());

  FServicesResponsePagination.SetPage(1);
  FServicesResponsePagination.SetLimit(1);
  FServicesResponsePagination.SetRecords(1);
  FServicesResponsePagination.SetData(LJsonOrder);
  Result := FServicesResponsePagination.Content;
end;

function TServicesOrder.SelectLargeVolume(
  const ADateUpdate: TDateTime): TJSONObject;
begin

  ValidatePermission(TMethodPermission.methodGET);
  var LMenorDataEncontrada:TDateTime := ADateUpdate;
  var LCountRegister:Integer          := 0;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from "order"');
  Query.SQL.Add('where company_id = :company_id and updated_at >= :updated_at');
  Query.SQL.Add('order by updated_at');
  Query.ParamByName('company_id').AsString   := CurrentCompany;
  Query.ParamByName('updated_at').AsDateTime := ADateUpdate;
  Query.Open();


  var LJsonResponse := TJSONObject.Create;
  LCountRegister := Query.RecordCount;
  LJsonResponse.AddPair('order',Query.ToJSONArray());

  Query.First;
  if Query.RecordCount > 0 then
    LMenorDataEncontrada := Query.FieldByName('updated_at').AsDateTime;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select oi.* from order_itens oi');
  Query.SQL.Add('left join "order" o ON o.id = oi.order_id');
  Query.SQL.Add('where o.company_id = :company_id and');
  Query.SQL.Add('oi.updated_at >= :updated_at');
  Query.SQL.Add('order by updated_at');
  Query.ParamByName('company_id').AsString   := CurrentCompany;
  Query.ParamByName('updated_at').AsDateTime := ADateUpdate;
  Query.Open();

  LCountRegister := LCountRegister + Query.RecordCount;
  LJsonResponse.AddPair('orderItens',Query.ToJSONArray());

  Query.First;
  if Query.RecordCount > 0 then
    LMenorDataEncontrada := Query.FieldByName('updated_at').AsDateTime;


  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select op.* from order_payment op');
  Query.SQL.Add('left join "order" o ON o.id = op.order_id');
  Query.SQL.Add('where o.company_id = :company_id and');
  Query.SQL.Add('op.updated_at >= :updated_at');
  Query.SQL.Add('order by updated_at');
  Query.ParamByName('company_id').AsString   := CurrentCompany;
  Query.ParamByName('updated_at').AsDateTime := ADateUpdate;
  Query.Open();

  LCountRegister := LCountRegister + Query.RecordCount;
  LJsonResponse.AddPair('orderPayment',Query.ToJSONArray());

  Query.First;
  if Query.RecordCount > 0 then
    LMenorDataEncontrada := Query.FieldByName('updated_at').AsDateTime;

  LJsonResponse.AddPair('firstDate',DateTimeToStr(LMenorDataEncontrada));

  FServicesResponsePagination.SetData(LJsonResponse);
  FServicesResponsePagination.SetRecords(LCountRegister);
  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesOrder.Update(AEntity: TEntitiesOrder);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.order');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Pedido não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public."order"');
  Query.SQL.Add('SET company_id = :company_id, user_id = :user_id,');
  Query.SQL.Add('customer_id = :customer_id, type_order = :type_order,');
  Query.SQL.Add('cpf_cnpj = :cpf_cnpj, addition = :addition, discount = :discount,');
  Query.SQL.Add('troco = :troco, subtotal = :subtotal, total = :total,');
  Query.SQL.Add('updated_at = :updated_at, status = :status, comanda = :comanda, mesa = :mesa,');
  Query.SQL.Add('nome_cliente = :nome_cliente');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString           := AEntity.Id;
  Query.ParamByName('company_id').AsString   := AEntity.CompanyId;
  Query.ParamByName('user_id').AsString      := AEntity.UserId;
  Query.ParamByName('customer_id').AsString  := AEntity.CustomerId;
  Query.ParamByName('type_order').AsInteger  := AEntity.TypeOrder;
  Query.ParamByName('cpf_cnpj').AsString     := AEntity.CpfCnpj;
  Query.ParamByName('addition').AsFloat      := AEntity.Addition;
  Query.ParamByName('discount').AsFloat      := AEntity.Discount;
  Query.ParamByName('troco').AsFloat         := AEntity.Troco;
  Query.ParamByName('subtotal').AsFloat      := AEntity.Subtotal;
  Query.ParamByName('total').AsFloat         := AEntity.Total;
  Query.ParamByName('updated_at').AsDateTime := Now();
  Query.ParamByName('status').AsString       := AEntity.Status;
  Query.ParamByName('comanda').AsInteger     := AEntity.Comanda;
  Query.ParamByName('mesa').AsInteger        := AEntity.Mesa;
  Query.ParamByName('nome_cliente').AsString := AEntity.NomeCliente;
  Query.ExecSQL();
end;

end.
