unit Services.City;

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
  System.JSON, Entities.City;

type
  TServicesCity = class(TServicesBase<TEntitiesCity>)
  private
  public
    function SelectAll: TJSONObject; override;
    function SelectById(const AId: string): TJSONObject; override;
    function Insert(AEntity: TEntitiesCity):TJSONObject; override;
    procedure Update(AEntity: TEntitiesCity); override;
    procedure Delete(AEntity: TEntitiesCity); override;
    procedure AfterConstruction; override;

  end;

implementation

{ TServicesCity }


procedure TServicesCity.AfterConstruction;
begin
  inherited;
  Route := 'city';
end;

procedure TServicesCity.Delete(AEntity: TEntitiesCity);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.cities');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsInteger := StrToIntDef(AEntity.Id,0);
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Cidade não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from cities');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsInteger := StrToIntDef(AEntity.Id,0);
  Query.ExecSQL();
end;

function TServicesCity.Insert(AEntity: TEntitiesCity):TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.cities');
  Query.SQL.Add('      ( id,"name", state_id)');
  Query.SQL.Add('VALUES(:id, :name, :state_id )');
  Query.ParamByName('id').AsInteger      := StrToIntDef(AEntity.Id,0);
  Query.ParamByName('name').AsString     := AEntity.Name;
  Query.ParamByName('state_id').AsInteger := AEntity.StateId;
  Query.ExecSQL();
end;

function TServicesCity.SelectAll: TJSONObject;
begin
  DataBase := 'cities';
  GetRecordCount;
  //inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from cities');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesCity.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from cities');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsInteger := StrToIntDef(AId,0);
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesCity.Update(AEntity: TEntitiesCity);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.cities');
  Query.ParamByName('id').AsInteger := StrToIntDef(AEntity.Id,0);
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Cidade não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.cities');
  Query.SQL.Add('SET "name" = :name, state_id = :state_id');
  Query.SQL.Add('WHERE id=:id');
  Query.ParamByName('id').AsString        := AEntity.Id;
  Query.ParamByName('name').AsString      := AEntity.Name;
  Query.ParamByName('state_id').AsInteger := AEntity.StateId;
  Query.ExecSQL();
end;

end.
