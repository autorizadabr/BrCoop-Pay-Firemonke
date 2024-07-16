unit Services.Tax.Model;

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
  System.JSON,
  Entities.Tax.Model;

type
  TServicesTaxModel = class(TServicesBase<TEntitiesTaxModel>)
  private
  public
    function SelectAll: TJSONObject; override;
    function SelectById(const AId: string): TJSONObject; override;
    function Insert(AEntity: TEntitiesTaxModel):TJSONObject; override;
    procedure Update(AEntity: TEntitiesTaxModel); override;
    procedure Delete(AEntity: TEntitiesTaxModel); override;
    procedure AfterConstruction; override;

  end;

implementation

{ TServicesTaxModel }


procedure TServicesTaxModel.AfterConstruction;
begin
  inherited;
  Route := 'city';
end;

procedure TServicesTaxModel.Delete(AEntity: TEntitiesTaxModel);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.tax_model');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('categoria não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from tax_model');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicesTaxModel.Insert(AEntity: TEntitiesTaxModel):TJSONObject;
begin
  inherited;

  AEntity.GenerateId;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.tax_model');
  Query.SQL.Add('(id, description, origin, csosn_cst, cst_pis, ppis,');
  Query.SQL.Add('cst_cofins, pcofins, internal_cfop, external_cfop, active)');
  Query.SQL.Add('VALUES(id, :description, :origin, :csosn_cst, :cst_pis, :ppis,');
  Query.SQL.Add(':cst_cofins, :pcofins, :internal_cfop, :external_cfop, :active);');
  Query.ParamByName('id').AsString            := AEntity.Id;
  Query.ParamByName('description').AsString   := AEntity.Description;
  Query.ParamByName('origin').AsString        := AEntity.Origin;
  Query.ParamByName('csosn_cst').AsString     := AEntity.CsosnCst;
  Query.ParamByName('cst_pis').AsString       := AEntity.CstPis;
  Query.ParamByName('ppis').AsString          := AEntity.Ppis;
  Query.ParamByName('cst_cofins').AsString    := AEntity.CstCofins;
  Query.ParamByName('pcofins').AsString       := AEntity.PCofins;
  Query.ParamByName('internal_cfop').AsString := AEntity.InternalCfop;
  Query.ParamByName('external_cfop').AsString := AEntity.ExternalCfop;
  Query.ParamByName('active').AsBoolean       := True;
  Query.ExecSQL();
end;

function TServicesTaxModel.SelectAll: TJSONObject;
begin
  DataBase := 'tax_model';
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from tax_model');
  Query.SQL.Add('order by description');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesTaxModel.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from tax_model');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AId;
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesTaxModel.Update(AEntity: TEntitiesTaxModel);
begin
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.tax_model');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Categoria não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.tax_model');
  Query.SQL.Add('SET "name" = :name, image = :image');
  Query.SQL.Add('WHERE id=:id');
  Query.ParamByName('id').AsString    := AEntity.Id;
//  Query.ParamByName('name').AsString  := AEntity.Name;
//  Query.ParamByName('image').AsString := LPathImage;
  Query.ExecSQL();
end;

end.
