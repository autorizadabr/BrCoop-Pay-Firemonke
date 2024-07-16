unit Services.Role;

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
  System.JSON, Entities.Role;

type
  TServicesRole = class(TServicesBase<TEntitiesRole>)
  private
  public
    function SelectAll: TJSONObject; override;
    function SelectById(const AId: string): TJSONObject; override;
    function Insert(AEntity: TEntitiesRole):TJSONObject; override;
    procedure Update(AEntity: TEntitiesRole); override;
    procedure Delete(AEntity: TEntitiesRole); override;

  end;

implementation

{ TServicesRole }


procedure TServicesRole.Delete(AEntity: TEntitiesRole);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.Roles');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.id;
  Query.Open();

  if Query.RecordCount <= 0 then
    raise Exception.Create('Role não encontrada!');

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from Roles');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicesRole.Insert(AEntity: TEntitiesRole):TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.Roles');
  Query.SQL.Add('      ( id,"name")');
  Query.SQL.Add('VALUES(:id, :name)');
  Query.ParamByName('id').AsString        := AEntity.Id;
  Query.ParamByName('name').AsString      := AEntity.Name;
  Query.ExecSQL();
end;

function TServicesRole.SelectAll: TJSONObject;
begin
  DataBase := 'roles';
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from Roles');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesRole.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from Roles');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AId;
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesRole.Update(AEntity: TEntitiesRole);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.Roles');
  Query.ParamByName('id').AsString := AEntity.id;
  Query.Open();

  if Query.RecordCount <= 0 then
    raise Exception.Create('Role não encontrada!');

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.Roles');
  Query.SQL.Add('SET "name" = :name ');
  Query.SQL.Add('WHERE id=:id');
  Query.ParamByName('id').AsString   := AEntity.Id;
  Query.ParamByName('name').AsString := AEntity.Name;
  Query.ExecSQL();
end;

end.
