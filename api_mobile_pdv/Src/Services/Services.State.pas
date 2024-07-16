unit Services.State;

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
  System.JSON, Entities.State;

type
  TServicesState = class(TServicesBase<TEntitiesState>)
  private
  public
    function SelectAll: TJSONObject; override;
    function SelectById(const AId: string): TJSONObject; override;
    function Insert(AEntity: TEntitiesState):TJSONObject; override;
    procedure Update(AEntity: TEntitiesState); override;
    procedure Delete(AEntity: TEntitiesState); override;
    procedure AfterConstruction; override;

  end;

implementation

{ TServicesState }


procedure TServicesState.AfterConstruction;
begin
  inherited;
  Route := 'state';
end;

procedure TServicesState.Delete(AEntity: TEntitiesState);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.states');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsInteger := StrToIntDef(AEntity.Id,0);
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Estado não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from states');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsInteger := StrToIntDef(AEntity.Id,0);;
  Query.ExecSQL();
end;

function TServicesState.Insert(AEntity: TEntitiesState):TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.states');
  Query.SQL.Add('      ( id,"name", uf)');
  Query.SQL.Add('VALUES(:id, :name, :uf )');
  Query.ParamByName('id').AsInteger  := StrToIntDef(AEntity.Id,0);
  Query.ParamByName('name').AsString := AEntity.Name;
  Query.ParamByName('uf').AsString   := AEntity.Uf;
  Query.ExecSQL();
end;

function TServicesState.SelectAll: TJSONObject;
begin
  DataBase := 'states';
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from states');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesState.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from states');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsInteger := StrToIntDef(AId,0);
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesState.Update(AEntity: TEntitiesState);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.states');
  Query.ParamByName('id').AsInteger := StrToIntDef(AEntity.Id,0);
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Estado não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.states');
  Query.SQL.Add('SET "name" = :name, uf = :uf');
  Query.SQL.Add('WHERE id=:id');
  Query.ParamByName('id').AsInteger  := StrToIntDef(AEntity.Id,0);
  Query.ParamByName('name').AsString := AEntity.Name;
  Query.ParamByName('uf').AsString   := AEntity.Uf;
  Query.ExecSQL();
end;

end.
