unit Services.Types.Payment;

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
  System.JSON, Entities.Types.Payment;

type
  TServicesTypeOfPayment = class(TServicesBase<TEntitiesTypesPayment>)
  private
  public
    function SelectAll: TJSONObject; override;
    function SelectAllPosPayment:TJSONObject;
    function SelectById(const AId: string): TJSONObject; override;
    function Insert(AEntity: TEntitiesTypesPayment):TJSONObject; override;
    procedure Update(AEntity: TEntitiesTypesPayment); override;
    procedure Delete(AEntity: TEntitiesTypesPayment); override;
    procedure AfterConstruction; override;

  end;

implementation

{ TServicesTypeOfPayment }


procedure TServicesTypeOfPayment.AfterConstruction;
begin
  inherited;
  Route := 'type-of-payment';
end;

procedure TServicesTypeOfPayment.Delete(AEntity: TEntitiesTypesPayment);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.types_of_payments');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Tipo de pagamento não encontrado!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from types_of_payments');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicesTypeOfPayment.Insert(AEntity: TEntitiesTypesPayment):TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.types_of_payments');
  Query.SQL.Add('(id, description, code, active, generates_installment, is_tef, company_id)');
  Query.SQL.Add('VALUES(:id, :description, :code, :active, :generates_installment, :is_tef, :company_id);');
  Query.ParamByName('id').AsString                     := AEntity.Id;
  Query.ParamByName('description').AsString            := AEntity.Description;
  Query.ParamByName('code').AsString                   := AEntity.Code;
  Query.ParamByName('active').AsBoolean                := AEntity.Active;
  Query.ParamByName('generates_installment').AsBoolean := AEntity.GeneratesInstallment;
  Query.ParamByName('is_tef').AsBoolean                := AEntity.Active;
  Query.ParamByName('company_id').AsString             := AEntity.CompanyId;
  Query.ExecSQL();
end;

function TServicesTypeOfPayment.SelectAll: TJSONObject;
begin
  DataBase := 'types_of_payments';
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from types_of_payments');
  Query.SQL.Add('where company_id = :company_id');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.ParamByName('company_id').AsString := CurrentCompany;
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesTypeOfPayment.SelectAllPosPayment: TJSONObject;
begin
  DataBase := 'types_of_payments';
  ValidatePermission(TMethodPermission.methodGET);
  GetRecordCount;

  // Tenho que buscar Type_Of_Payment do tipo Dinheiro Code = 1
  // Pois esse tipo de pagamento vai ser o padrão do app


  // Com esse select eu busco o primeiro registro que foi salvo com o code 01
  // Usando o order by combinado com o limit 1
  var LDataResult             := TJSONArray.Create;
  var LQueryPosPayment        := TFDQuery.Create(nil);
  LQueryPosPayment.Connection := Connection;
  try
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select types_of_payments.* from types_of_payments');
    Query.SQL.Add('where code = :code');
    Query.SQL.Add('and company_id = :company_id');
    Query.SQL.Add('order by created_at');
    Query.SQL.Add('limit 1');
    Query.ParamByName('company_id').AsString := CurrentCompany;
    Query.ParamByName('code').AsInteger      := 1;
    Query.Open();

    // Dinehiro
    LDataResult.Add(Query.ToJSONObject());

    // Cartões Code 3,4,5
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select types_of_payments.* from types_of_payments');
    Query.SQL.Add('where code in (3,4,5) and company_id = :company_id');
    Query.SQL.Add('order by created_at');
    Query.ParamByName('company_id').AsString := CurrentCompany;
    Query.Open();

    LQueryPosPayment.Close;
    LQueryPosPayment.SQL.Clear;
    LQueryPosPayment.SQL.Add('select * from pos_payments');
    LQueryPosPayment.SQL.Add('where payment_id = :payment_id');
    LQueryPosPayment.SQL.Add('order by payment_id ');

    Query.First;
    while not Query.Eof do
    begin
      var LJsonObjectCartao := Query.ToJSONObject();

      LQueryPosPayment.Close;
      LQueryPosPayment.ParamByName('payment_id').AsInteger := LJsonObjectCartao.GetValue<Integer>('code',0);
      LQueryPosPayment.Open();

      LJsonObjectCartao.AddPair('posPayment',LQueryPosPayment.ToJSONArray());
      LDataResult.Add(LJsonObjectCartao);
      Query.Next;
    end;

    // Pix
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select types_of_payments.* from types_of_payments');
    Query.SQL.Add('where code = :code');
    Query.SQL.Add('and company_id = :company_id');
    Query.SQL.Add('order by created_at');
    Query.SQL.Add('limit 1');
    Query.ParamByName('company_id').AsString := CurrentCompany;
    Query.ParamByName('code').AsInteger      := 20;
    Query.Open();

    // Pix
    LDataResult.Add(Query.ToJSONObject());




  finally
    FreeAndNil(LQueryPosPayment);
  end;

  FServicesResponsePagination.SetRecords(0);
  FServicesResponsePagination.SetData(LDataResult);
  Result := FServicesResponsePagination.Content;
end;

function TServicesTypeOfPayment.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from types_of_payments');
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

procedure TServicesTypeOfPayment.Update(AEntity: TEntitiesTypesPayment);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.types_of_payments');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Tipo de pagamento não encontrado!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.types_of_payments');
  Query.SQL.Add('SET id = :id, description = :description, code = :code,');
  Query.SQL.Add('active = :active, generates_installment = :generates_installment,');
  Query.SQL.Add('is_tef = :is_tef, company_id = :company_id;');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString                     := AEntity.Id;
  Query.ParamByName('description').AsString            := AEntity.Description;
  Query.ParamByName('code').AsString                   := AEntity.Code;
  Query.ParamByName('active').AsBoolean                := AEntity.Active;
  Query.ParamByName('generates_installment').AsBoolean := AEntity.GeneratesInstallment;
  Query.ParamByName('is_tef').AsBoolean                := AEntity.Active;
  Query.ParamByName('company_id').AsString             := AEntity.CompanyId;
  Query.ExecSQL();
end;

end.
