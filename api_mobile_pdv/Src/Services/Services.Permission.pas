unit Services.Permission;

interface
uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option,FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PGDef, FireDAC.Phys.PG,FireDAC.Comp.UI,
  FireDAC.DApt,
  Services.Base,
  DataSet.Serialize,
  System.SysUtils,
  System.JSON,
  Entities.Permission,
  Horse.HandleException, Horse;
  type
  TServicesPermission = class(TServicesBase<TEntitiesPermission>)
  private
  public
    function Insert(AEntity: TEntitiesPermission):TJSONObject; override;
    procedure Update(AEntity:TEntitiesPermission);override;
    function SelectAll: TJSONObject; override;
    procedure AfterConstruction; override;
    function SelectByUserAndCompany(const AIdUser,AIdCompany:string):TJSONObject;
  end;

implementation

{ TServicesPermission }

procedure TServicesPermission.AfterConstruction;
begin
  inherited;
  Route := 'permission';
end;

function TServicesPermission.Insert(AEntity: TEntitiesPermission):TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.permissions');
  Query.SQL.Add('      ( id,"name", description)');
  Query.SQL.Add('VALUES(:id, :name, :description)');
  Query.ParamByName('id').AsString        := AEntity.Id;
  Query.ParamByName('name').AsString      := AEntity.Name;
  Query.ParamByName('description').AsString     := AEntity.Description;
  Query.ExecSQL();
end;

function TServicesPermission.SelectAll: TJSONObject;
begin
  DataBase := 'permissions';
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from permissions');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.Open();
  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesPermission.SelectByUserAndCompany(const AIdUser,
  AIdCompany: string): TJSONObject;
begin
  DataBase := 'permissions';
  ValidatePermission(methodGET);

  QueryRecordCount.Close;
  QueryRecordCount.SQL.Clear;
  QueryRecordCount.SQL.Add('select count (cur.id) from company_user_role cur');
  QueryRecordCount.SQL.Add('left join companies c on c.id = :id_company');
  QueryRecordCount.SQL.Add('left join roles r on r.id = cur.role_id');
  QueryRecordCount.SQL.Add('left join permission_role pr ON pr.role_id = cur.role_id');
  QueryRecordCount.SQL.Add('left join permissions p ON p.id = permission_id');
  QueryRecordCount.SQL.Add('where cur.user_id = :id_user and');
  QueryRecordCount.SQL.Add('cur.company_id  = :id_company');
  QueryRecordCount.ParamByName('id_company').AsString := AIdCompany;
  QueryRecordCount.ParamByName('id_user').AsString    := AIdUser;
  QueryRecordCount.Open();

  FServicesResponsePagination.SetRecords(QueryRecordCount.FieldByName('count').AsInteger);

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select p.*,c."name"  from company_user_role cur');
  Query.SQL.Add('left join companies c on c.id = :id_company');
  Query.SQL.Add('left join roles r on r.id = cur.role_id');
  Query.SQL.Add('left join permission_role pr ON pr.role_id = cur.role_id');
  Query.SQL.Add('left join permissions p ON p.id = permission_id');
  Query.SQL.Add('where cur.user_id = :id_user and');
  Query.SQL.Add('cur.company_id  = :id_company');
  Query.SQL.Add('order by p."name"');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.ParamByName('id_company').AsString := AIdCompany;
  Query.ParamByName('id_user').AsString    := AIdUser;
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesPermission.Update(AEntity: TEntitiesPermission);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('Select id from public.permissions');
  Query.SQL.Add('WHERE id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise EHorseException.New.Detail(Self.ClassName).Error('Permissão não encontrada!');
  end;


  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.permissions');
  Query.SQL.Add('SET "name" = :name, description = :description');
  Query.SQL.Add('WHERE id = :id');
  Query.ParamByName('id').AsString          := AEntity.Id;
  Query.ParamByName('name').AsString        := AEntity.Name;
  Query.ParamByName('description').AsString := AEntity.Description;
  Query.ExecSQL();
end;

end.
