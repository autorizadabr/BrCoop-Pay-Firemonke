unit Services.Company;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PGDef, FireDAC.Phys.PG,
  FireDAC.Comp.UI,
  FireDAC.DApt,
  Services.Base,
  DataSet.Serialize,
  System.SysUtils,
  System.DateUtils,
  System.JSON,
  Entities.Company;

type
  TServicesCompany = class(TServicesBase<TEntitiesCompany>)
  private
  public
    function SelectAll: TJSONObject; override;
    function SelectById(const AId: string): TJSONObject; override;
    function SelectByUser(const AId: string): TJSONObject;
    function Insert(AEntity: TEntitiesCompany):TJSONObject; override;
    procedure Update(AEntity: TEntitiesCompany); override;
    procedure Delete(AEntity: TEntitiesCompany); override;
    procedure AfterConstruction; override;
  end;

implementation

{ TServicesCompany }


procedure TServicesCompany.AfterConstruction;
begin
  inherited;
  Route := 'company';
end;

procedure TServicesCompany.Delete(AEntity: TEntitiesCompany);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.companies');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.id;
  Query.Open();

  if Query.RecordCount <= 0 then
    raise Exception.Create('Empresa não encontrada!');

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from companies');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicesCompany.Insert(AEntity: TEntitiesCompany):TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.companies');
  Query.SQL.Add('(id, cpf_cnpj, ie, ie_st, im, "name", fantasy,');
  Query.SQL.Add('public_place, "number", complement, neighborhood,');
  Query.SQL.Add('city_id, zip_code, phone, crt, email, dou_date, is_active, is_block)');
  Query.SQL.Add('VALUES(:id, :cpf_cnpj, :ie, :ie_st, :im, :"name", :fantasy,');
  Query.SQL.Add(':public_place, :"number", :complement, :neighborhood,');
  Query.SQL.Add(':city_id, :zip_code, :phone, :crt, :email, :dou_date, :is_active, :is_block);');
  Query.ParamByName('id').AsString            := AEntity.Id;
  Query.ParamByName('cpf_cnpj').AsString      := AEntity.CpfCnpj;
  Query.ParamByName('ie').AsString            := AEntity.Ie;
  Query.ParamByName('ie_st').AsString         := AEntity.IeSt;
  Query.ParamByName('im').AsString            := AEntity.Im;
  Query.ParamByName('name').AsString          := AEntity.Name;
  Query.ParamByName('fantasy').AsString       := AEntity.Fantasy;
  Query.ParamByName('public_place').AsString  := AEntity.PublicPlace;
  Query.ParamByName('number').AsString        := AEntity.Number;
  Query.ParamByName('complement').AsString    := AEntity.Complement;
  Query.ParamByName('neighborhood').AsString  := AEntity.Neighborhood;
  Query.ParamByName('city_id').AsInteger      := AEntity.CityId;
  Query.ParamByName('zip_code').AsString      := AEntity.ZipCode;
  Query.ParamByName('phone').AsString         := AEntity.Phone;
  Query.ParamByName('crt').AsString           := AEntity.Crt;
  Query.ParamByName('email').AsString         := AEntity.Email;
  Query.ParamByName('dou_date').AsDate        := IncDay(Now,15);
  Query.ParamByName('is_active').AsBoolean    := True;
  Query.ParamByName('is_block').AsBoolean     := False;

  Query.ExecSQL();
end;

function TServicesCompany.SelectAll: TJSONObject;
begin
  DataBase := '';
  inherited;

  QueryRecordCount.Close;
  QueryRecordCount.SQL.Clear;
  QueryRecordCount.SQL.Add('select count(id) from companies c');
  QueryRecordCount.SQL.Add('where 1=1');
  if FListParams.ContainsKey('name') then
  begin
    QueryRecordCount.SQL.Add('and lower(name) like lower(:name)');
    QueryRecordCount.ParamByName('name').AsString := '%'+FListParams.Items['name']+'%';
  end;

  if FListParams.ContainsKey('fantasy') then
  begin
    QueryRecordCount.SQL.Add('and lower(fantasy) like lower(:fantasy)');
    QueryRecordCount.ParamByName('fantasy').AsString := '%'+FListParams.Items['fantasy']+'%';
  end;

  if FListParams.ContainsKey('cpf_cnpj') then
  begin
    QueryRecordCount.SQL.Add('and cpf_cnpj = :cpf_cnpj');
    QueryRecordCount.ParamByName('cpf_cnpj').AsString := FListParams.Items['cpf_cnpj'];
  end;

  if FListParams.ContainsKey('ie') then
  begin
    QueryRecordCount.SQL.Add('and ie = :ie');
    QueryRecordCount.ParamByName('ie').AsString := '%'+FListParams.Items['ie']+'%';
  end;
  QueryRecordCount.Open();
  FServicesResponsePagination.SetRecords(QueryRecordCount.FieldByName('count').AsInteger);

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select c.*, ci."name" as city, s."name" as state ,ci.state_id  from companies c');
  Query.SQL.Add('left join cities ci on ci.id = c.city_id');
  Query.SQL.Add('left join states s on s.id = ci.state_id ');
  Query.SQL.Add('where 1=1');

  if FListParams.ContainsKey('name') then
  begin
    Query.SQL.Add('and lower(name) like lower(:name)');
    Query.ParamByName('name').AsString := '%'+FListParams.Items['name']+'%';
  end;

  if FListParams.ContainsKey('fantasy') then
  begin
    Query.SQL.Add('and lower(fantasy) like lower(:fantasy)');
    Query.ParamByName('fantasy').AsString := '%'+FListParams.Items['fantasy']+'%';
  end;

  if FListParams.ContainsKey('cpf_cnpj') then
  begin
    Query.SQL.Add('and cpf_cnpj = :cpf_cnpj');
    Query.ParamByName('cpf_cnpj').AsString := FListParams.Items['cpf_cnpj'];
  end;


  if FListParams.ContainsKey('ie') then
  begin
    Query.SQL.Add('and ie = :ie');
    Query.ParamByName('ie').AsString := '%'+FListParams.Items['ie']+'%';
  end;

  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesCompany.SelectByUser(const AId: string): TJSONObject;
begin
  ValidatePermission(TMethodPermission.methodGET);

  // O proprio horse trata se o ID veio ou não

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.users');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AId;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Usuário não encontrado!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select c.*, ci."name" as city, s."name" as state ,ci.state_id  from companies c');
  Query.SQL.Add('inner join company_user_role cur ON cur.company_id = c.id');
  Query.SQL.Add('left join cities ci on ci.id = c.city_id');
  Query.SQL.Add('left join states s on s.id = ci.state_id ');
  Query.SQL.Add('where cur.user_id  = :id');
  Query.ParamByName('id').AsString := AId;
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesCompany.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select c.*, ci."name" as city, s."name" as state ,ci.state_id  from companies c');
  Query.SQL.Add('left join cities ci on ci.id = c.city_id');
  Query.SQL.Add('left join states s on s.id = ci.state_id ');
  Query.SQL.Add('where c.id = :id');
  Query.ParamByName('id').AsString := AId;
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesCompany.Update(AEntity: TEntitiesCompany);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.companies');
  Query.SQL.Add('SET cpf_cnpj = :cpf_cnpj, ie = :ie, ie_st = :id_st, im = :im,');
  Query.SQL.Add('"name" = :name, fantasy = :fantasy, public_place = :public_place,');
  Query.SQL.Add('"number" = :number, complement = :complement,');
  Query.SQL.Add('neighborhood = :neighborhood, city_id = :city_id,');
  Query.SQL.Add('zip_code = :zip_code, phone = :phone, crt = :crt, email = :email,');
  Query.SQL.Add('dou_date = :dou_date, is_active = :is_active, is_block = :is_block');
  Query.SQL.Add('WHERE id=:id');
  Query.ParamByName('id').AsString            := AEntity.Id;
  Query.ParamByName('cpf_cnpj').AsString      := AEntity.CpfCnpj;
  Query.ParamByName('ie').AsString            := AEntity.Ie;
  Query.ParamByName('ie_st').AsString         := AEntity.IeSt;
  Query.ParamByName('im').AsString            := AEntity.Im;
  Query.ParamByName('name').AsString          := AEntity.Name;
  Query.ParamByName('fantasy').AsString       := AEntity.Fantasy;
  Query.ParamByName('public_place').AsString  := AEntity.PublicPlace;
  Query.ParamByName('number').AsString        := AEntity.Number;
  Query.ParamByName('complement').AsString    := AEntity.Complement;
  Query.ParamByName('neighborhood').AsString  := AEntity.Neighborhood;
  Query.ParamByName('city_id').AsInteger      := AEntity.CityId;
  Query.ParamByName('zip_code').AsString      := AEntity.ZipCode;
  Query.ParamByName('phone').AsString         := AEntity.Phone;
  Query.ParamByName('crt').AsString           := AEntity.Crt;
  Query.ParamByName('dou_date').AsDate        := AEntity.DuoDate;
  Query.ParamByName('is_active').AsBoolean    := AEntity.IsActive;
  Query.ParamByName('is_block').AsBoolean     := AEntity.IsBlock;

  Query.ExecSQL();

end;

end.
