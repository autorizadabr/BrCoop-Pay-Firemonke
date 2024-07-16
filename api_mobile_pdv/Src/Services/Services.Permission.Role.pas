unit Services.Permission.Role;

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
  System.JSON, Entities.Permission.Role;

type
  TServicePermissionRole = class(TServicesBase<TEntitiesPermissionRole>)
  private
  public
    function SelectAll: TJSONObject; override;
    function SelectById(const AId: string): TJSONObject; override;
    function Insert(AEntity: TEntitiesPermissionRole):TJSONObject; override;
    procedure Update(AEntity: TEntitiesPermissionRole); override;
    procedure Delete(AEntity: TEntitiesPermissionRole); override;

  end;

implementation

{ TServicePermissionRole }


procedure TServicePermissionRole.Delete(AEntity: TEntitiesPermissionRole);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.permission_role');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.id;
  Query.Open();

  if Query.RecordCount <= 0 then
    raise Exception.Create('Permissão da regra não encontrada!');

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from permission_role');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicePermissionRole.Insert(AEntity: TEntitiesPermissionRole):TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.permission_role');
  Query.SQL.Add('      ( id,permission_id, role_id)');
  Query.SQL.Add('VALUES(:id, :permission_id, :role_id)');
  Query.ParamByName('id').AsString            := AEntity.Id;
  Query.ParamByName('permission_id').AsString := AEntity.PermissionId;
  Query.ParamByName('role_id').AsString       := AEntity.RoleId;
  Query.ExecSQL();
end;

function TServicePermissionRole.SelectAll: TJSONObject;
begin
  DataBase := 'permission_role';
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from permission_role');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicePermissionRole.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from permission_role');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AId;
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicePermissionRole.Update(AEntity: TEntitiesPermissionRole);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.permission_role');
  Query.ParamByName('id').AsString := AEntity.id;
  Query.Open();

  if Query.RecordCount <= 0 then
    raise Exception.Create('Permissão da regra não encontrada!');

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.permission_role');
  Query.SQL.Add('SET permission_id = :permission_id, role_id = :role_id');
  Query.SQL.Add('WHERE id=:id');
  Query.ParamByName('id').AsString            := AEntity.Id;
  Query.ParamByName('permission_id').AsString := AEntity.PermissionId;
  Query.ParamByName('role_id').AsString       := AEntity.RoleId;
  Query.ExecSQL();
end;

end.
