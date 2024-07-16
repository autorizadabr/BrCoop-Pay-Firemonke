unit Services.Company.User.Role;

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
  System.JSON, Entities.Company.User.Role;

type
  TServicesCompanyUserRole = class(TServicesBase<TEntitiesCompanyUserRole>)
  private
  public
    function SelectAll: TJSONObject; override;
    function SelectById(const AId: string): TJSONObject; override;
    function Insert(AEntity: TEntitiesCompanyUserRole):TJSONObject; override;
    procedure Update(AEntity: TEntitiesCompanyUserRole); override;
    procedure Delete(AEntity: TEntitiesCompanyUserRole); override;

  end;

implementation

{ TServicesCompanyUserRole }


procedure TServicesCompanyUserRole.Delete(AEntity: TEntitiesCompanyUserRole);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.company_user_role');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.id;
  Query.Open();

  if Query.RecordCount <= 0 then
    raise Exception.Create('Role não encontrada!');

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from company_user_role');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicesCompanyUserRole.Insert(AEntity: TEntitiesCompanyUserRole):TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.company_user_role');
  Query.SQL.Add('      ( id, user_id, company_id, role_id)');
  Query.SQL.Add('VALUES(:id, :user_id, :company_id, :role_id)');
  Query.ParamByName('id').AsString         := AEntity.Id;
  Query.ParamByName('user_id').AsString    := AEntity.UserId;
  Query.ParamByName('company_id').AsString := AEntity.CompanyId;
  Query.ParamByName('role_id').AsString    := AEntity.RoleId;
  Query.ExecSQL();
end;

function TServicesCompanyUserRole.SelectAll: TJSONObject;
begin
  DataBase := 'company_user_role';
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from company_user_role');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesCompanyUserRole.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from company_user_role');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AId;
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesCompanyUserRole.Update(AEntity: TEntitiesCompanyUserRole);
begin
  inherited;

end;

end.
