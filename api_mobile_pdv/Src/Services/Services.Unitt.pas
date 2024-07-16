unit Services.Unitt;

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
  System.JSON, Entities.Unitt;

type
  TServicesUnitt = class(TServicesBase<TEntititesUnitt>)
  private
  public
    function SelectAll: TJSONObject; override;
    function SelectById(const AId: string): TJSONObject; override;
    function Insert(AEntity: TEntititesUnitt):TJSONObject; override;
    procedure Update(AEntity: TEntititesUnitt); override;
    procedure Delete(AEntity: TEntititesUnitt); override;
    procedure AfterConstruction; override;

  end;

implementation

{ TServicesUnitt }


procedure TServicesUnitt.AfterConstruction;
begin
  inherited;
  Route := 'city';
end;

procedure TServicesUnitt.Delete(AEntity: TEntititesUnitt);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.unities');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Unidade de medida não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from unities');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicesUnitt.Insert(AEntity: TEntititesUnitt):TJSONObject;
begin
  inherited;
  AEntity.GenerateId;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.unities');
  Query.SQL.Add('      ( id,"description", sigra, active)');
  Query.SQL.Add('VALUES(:id, :description, :sigra, :active )');
  Query.ParamByName('id').AsString          := AEntity.Id;
  Query.ParamByName('description').AsString := AEntity.Description;
  Query.ParamByName('sigra').AsString       := AEntity.Sigra;
  Query.ParamByName('active').AsBoolean     := True;
  Query.ExecSQL();
end;

function TServicesUnitt.SelectAll: TJSONObject;
begin
  DataBase := 'unities';
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from unities');
  Query.SQL.Add('order by description');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesUnitt.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from unities');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AId;
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesUnitt.Update(AEntity: TEntititesUnitt);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.unities');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Unidade de medida não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.unities');
  Query.SQL.Add('SET "description" = :description, sigra = :sigra, active = :active');
  Query.SQL.Add('WHERE id=:id');
  Query.ParamByName('id').AsString          := AEntity.Id;
  Query.ParamByName('description').AsString := AEntity.Description;
  Query.ParamByName('sigra').AsString       := AEntity.Sigra;
  Query.ParamByName('active').AsBoolean     := AEntity.Active;

  Query.ExecSQL();
end;

end.
