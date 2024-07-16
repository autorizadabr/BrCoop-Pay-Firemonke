unit Services.Category;

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
  System.Classes,
  DataSet.Serialize,
  System.JSON, Entities.Category, Services.Storage;

type
  TServicesCategory = class(TServicesBase<TEntitiesCategory>)
  private
  public
    function SelectAll: TJSONObject; override;
    function SelectById(const AId: string): TJSONObject; override;
    function Insert(AEntity: TEntitiesCategory):TJSONObject; override;
    procedure Update(AEntity: TEntitiesCategory); override;
    procedure Delete(AEntity: TEntitiesCategory); override;
    procedure AfterConstruction; override;

  end;

implementation

{ TServicesCategory }


procedure TServicesCategory.AfterConstruction;
begin
  inherited;
  Route := 'city';
end;

procedure TServicesCategory.Delete(AEntity: TEntitiesCategory);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.categories');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('categoria não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from categories');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicesCategory.Insert(AEntity: TEntitiesCategory):TJSONObject;
begin
  inherited;

  var LPathImage:string := '';
  var LServiceStorage   := TServicesStorage.Create;
  try
    LPathImage := LServiceStorage.SaveImage(TMemoryStream(AEntity.Image));
  finally
    LServiceStorage.Free;
  end;

  AEntity.GenerateId;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.categories');
  Query.SQL.Add('      ( id,"name", image)');
  Query.SQL.Add('VALUES(:id, :name, :image )');
  Query.ParamByName('id').AsString    := AEntity.Id;
  Query.ParamByName('name').AsString  := AEntity.Name;
  Query.ParamByName('image').AsString := LPathImage;
  Query.ExecSQL();
end;

function TServicesCategory.SelectAll: TJSONObject;
begin
  DataBase := 'categories';
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from categories c');
  Query.SQL.Add('order by c.name');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesCategory.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from categories');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AId;
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesCategory.Update(AEntity: TEntitiesCategory);
begin
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.categories');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Categoria não encontrada!');
  end;

  var LPathImage:string := '';
  var LServiceStorage   := TServicesStorage.Create;
  try
    LPathImage := LServiceStorage.SaveImage(TMemoryStream(AEntity.Image));
  finally
    LServiceStorage.Free;
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.categories');
  Query.SQL.Add('SET "name" = :name, image = :image');
  Query.SQL.Add('WHERE id=:id');
  Query.ParamByName('id').AsString    := AEntity.Id;
  Query.ParamByName('name').AsString  := AEntity.Name;
  Query.ParamByName('image').AsString := LPathImage;
  Query.ExecSQL();
end;

end.
