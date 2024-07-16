unit Services.Customer;

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
  System.JSON, Entities.Customer;

type
  TServicesCustomer = class(TServicesBase<TEntitiesCustomer>)
  private
  public
    function SelectAll: TJSONObject; override;
    function SelectById(const AId: string): TJSONObject; override;
    function Insert(AEntity: TEntitiesCustomer):TJSONObject; override;
    procedure Update(AEntity: TEntitiesCustomer); override;
    procedure Delete(AEntity: TEntitiesCustomer); override;
    procedure AfterConstruction; override;

  end;

implementation

{ TServicesCustomer }


procedure TServicesCustomer.AfterConstruction;
begin
  inherited;
  Route := 'customer';
end;

procedure TServicesCustomer.Delete(AEntity: TEntitiesCustomer);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.customers');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Cliente não encontrado!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from customers');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicesCustomer.Insert(AEntity: TEntitiesCustomer):TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.customers');
  Query.SQL.Add('(id, cpf_cnpj, ie, type_of_taxpayer, "name", fantasy,');
  Query.SQL.Add('public_place, "number", complement, neighborhood, city_id,');
  Query.SQL.Add('phone, email, is_active, zip_code, company_id)');
  Query.SQL.Add('VALUES(:id, :cpf_cnpj, :ie, :type_of_taxpayer, :"name",');
  Query.SQL.Add(':fantasy, :public_place, :number, :complement, :neighborhood,');
  Query.SQL.Add(':city_id, :phone, :email, :is_active, :zip_code, :company_id)');
  Query.ParamByName('id').AsString                := AEntity.Id;
  Query.ParamByName('cpf_cnpj').AsString          := AEntity.CpfCnpj;
  Query.ParamByName('ie').AsString                := AEntity.Ie;
  Query.ParamByName('type_of_taxpayer').AsInteger := AEntity.TypeOfTaxpayer;
  Query.ParamByName('name').AsString              := AEntity.Name;
  Query.ParamByName('fantasy').AsString           := AEntity.Fantasy;
  Query.ParamByName('public_place').AsString      := AEntity.PublicPlace;
  Query.ParamByName('number').AsString            := AEntity.Number;
  Query.ParamByName('complement').AsString        := AEntity.Complement;
  Query.ParamByName('neighborhood').AsString      := AEntity.Neighborhood;
  Query.ParamByName('city_id').AsInteger          := AEntity.CityId;
  Query.ParamByName('phone').AsString             := AEntity.Phone;
  Query.ParamByName('email').AsString             := AEntity.Email;
  Query.ParamByName('is_active').AsBoolean        := AEntity.IsActive;
  Query.ParamByName('zip_code').AsString          := AEntity.ZipCode;
  Query.ParamByName('company_id').AsString        := AEntity.CompanyId;
  Query.ExecSQL();
end;

function TServicesCustomer.SelectAll: TJSONObject;
begin
  DataBase := 'customers';
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from customers');
  Query.SQL.Add('where company_id = :company_id');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.ParamByName('company_id').AsString := CurrentCompany;
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesCustomer.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from customers');
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

procedure TServicesCustomer.Update(AEntity: TEntitiesCustomer);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.customers');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Cliente não encontrado!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.customers');
  Query.SQL.Add('SET cpf_cnpj = :cpf_cnpj, ie = :ie, type_of_taxpayer = :type_of_taxpayer,');
  Query.SQL.Add('"name" = :name, fantasy = :fantasy, public_place = :public_place,');
  Query.SQL.Add('"number" = :number, complement = :complement, neighborhood = :neighborhood,');
  Query.SQL.Add('city_id = :city_id, phone = :phone, email = :email, is_active = :is_active,');
  Query.SQL.Add('zip_code = :zip_code, company_id = :company_id');
  Query.SQL.Add('where id=:id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ParamByName('cpf_cnpj').AsString          := AEntity.CpfCnpj;
  Query.ParamByName('ie').AsString                := AEntity.Ie;
  Query.ParamByName('type_of_taxpayer').AsInteger := AEntity.TypeOfTaxpayer;
  Query.ParamByName('name').AsString              := AEntity.Name;
  Query.ParamByName('fantasy').AsString           := AEntity.Fantasy;
  Query.ParamByName('public_place').AsString      := AEntity.PublicPlace;
  Query.ParamByName('number').AsString            := AEntity.Number;
  Query.ParamByName('complement').AsString        := AEntity.Complement;
  Query.ParamByName('neighborhood').AsString      := AEntity.Neighborhood;
  Query.ParamByName('city_id').AsInteger          := AEntity.CityId;
  Query.ParamByName('phone').AsString             := AEntity.Phone;
  Query.ParamByName('email').AsString             := AEntity.Email;
  Query.ParamByName('is_active').AsBoolean        := AEntity.IsActive;
  Query.ParamByName('zip_code').AsString          := AEntity.ZipCode;
  Query.ParamByName('company_id').AsString        := AEntity.CompanyId;
  Query.ExecSQL();
end;

end.
