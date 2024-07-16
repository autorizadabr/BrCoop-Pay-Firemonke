unit Services.Product;

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
  System.JSON,
  System.Classes,
  Entities.Product, Services.Storage;

type
  TServicesProduct = class(TServicesBase<TEntitiesProduct>)
  private
  public
    function SelectAll: TJSONObject; override;
    function SelectById(const AId: string): TJSONObject; override;
    function SelectByCategory: TJSONObject;
    function Insert(AEntity: TEntitiesProduct):TJSONObject; override;
    procedure Update(AEntity: TEntitiesProduct); override;
    procedure Delete(AEntity: TEntitiesProduct); override;
    procedure AfterConstruction; override;

  end;

implementation

{ TServicesProduct }


procedure TServicesProduct.AfterConstruction;
begin
  inherited;
  Route := 'Product';
end;

procedure TServicesProduct.Delete(AEntity: TEntitiesProduct);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.Products');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Produto não encontrado!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from Products');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicesProduct.Insert(AEntity: TEntitiesProduct):TJSONObject;
begin
  inherited;
  var LPathImage:string := EmptyStr;
  try
    var LServiceStorage   := TServicesStorage.Create;
    try
      LPathImage := LServiceStorage.SaveImage(TMemoryStream(AEntity.Image));
    finally
      LServiceStorage.Free;
    end;
  except on E: Exception do
    begin
      raise Exception.Create('Erro ao salvar a imagem '+E.Message);
    end;
  end;

  AEntity.GenerateId;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.products');
  Query.SQL.Add('(id, unity_id,');
  if not AEntity.CategoryId.IsEmpty then
    Query.SQL.Add('category_id,');
  Query.SQL.Add('tax_id, declare_pis_cofins,');
  Query.SQL.Add('description, barcode, price_cost, sale_price, profit_margin,');
  Query.SQL.Add('stock_quantity, minimum_stock, ncm, cest, change_price, active,');
  Query.SQL.Add('created_at, image, company_id)');
  Query.SQL.Add('VALUES(:id, :unity_id,');
  if not AEntity.CategoryId.IsEmpty then
    Query.SQL.Add(':category_id,');
  Query.SQL.Add(':tax_id, :declare_pis_cofins,');
  Query.SQL.Add(':description, :barcode, :price_cost, :sale_price,');
  Query.SQL.Add(':profit_margin, :stock_quantity, :minimum_stock, :ncm,');
  Query.SQL.Add(':cest, :change_price, :active, :created_at, :image, :company_id);');
  Query.ParamByName('id').AsString                  := AEntity.Id;
  Query.ParamByName('unity_id').AsString            := AEntity.UnityId;
  if not AEntity.CategoryId.IsEmpty then
    Query.ParamByName('category_id').AsString         := AEntity.CategoryId;
  Query.ParamByName('tax_id').AsString              := AEntity.TaxId;
  Query.ParamByName('declare_pis_cofins').AsBoolean := AEntity.DeclarePisCofins;
  Query.ParamByName('description').AsString         := AEntity.Description;
  Query.ParamByName('barcode').AsString             := AEntity.Barcode;
  Query.ParamByName('price_cost').AsFloat           := AEntity.PriceCost;
  Query.ParamByName('sale_price').AsFloat           := AEntity.SalePrice;
  Query.ParamByName('profit_margin').AsFloat        := AEntity.ProfitMargin;
  Query.ParamByName('stock_quantity').AsFloat       := AEntity.StockQuantity;
  Query.ParamByName('minimum_stock').AsFloat        := AEntity.MinimumStock;
  Query.ParamByName('ncm').AsString                 := AEntity.Ncm;
  Query.ParamByName('cest').AsString                := AEntity.Cest;
  Query.ParamByName('change_price').AsBoolean       := AEntity.ChangePrice;
  Query.ParamByName('active').AsBoolean             := True;
  Query.ParamByName('image').AsString               := LPathImage;
  Query.ParamByName('created_at').AsDateTime        := Now();
  Query.ParamByName('company_id').AsString          := AEntity.CompanyId;
  Query.ExecSQL();
end;

function TServicesProduct.SelectAll: TJSONObject;
begin
  DataBase := 'Products';
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from Products');
  Query.SQL.Add('where company_id = :company_id');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.ParamByName('company_id').AsString := CurrentCompany;
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesProduct.SelectByCategory: TJSONObject;
begin
  ValidatePermission(TMethodPermission.methodGET);

  var LJsonArratResult := TJSONArray.Create;

  var LQueryCategory        := TFDQuery.Create(nil);
  LQueryCategory.Connection := Connection;
  var LQueryProdutct        := TFDQuery.Create(nil);
  LQueryProdutct.Connection := Connection;
  var LQueryTaxModel        := TFDQuery.Create(nil);
  LQueryTaxModel.Connection := Connection;
  try
    LQueryCategory.Close;
    LQueryCategory.SQL.Clear;
    LQueryCategory.SQL.Add('select distinct c.* from categories c');
    LQueryCategory.SQL.Add('right join products p on p.category_id = c.id');
    LQueryCategory.SQL.Add('where p.company_id = :company_id');
    LQueryCategory.SQL.Add('and p.category_id is not null');
    LQueryCategory.SQL.Add('order by c.name');
    LQueryCategory.ParamByName('company_id').AsString  := CurrentCompany;
    LQueryCategory.Open();

    LQueryProdutct.Close;
    LQueryProdutct.SQL.Clear;
    LQueryProdutct.SQL.Add('select * from products p');
    LQueryProdutct.SQL.Add('where p.category_id = :category_id and');
    LQueryProdutct.SQL.Add('company_id = :company_id ');

    LQueryTaxModel.Close;
    LQueryTaxModel.SQL.Clear;
    LQueryTaxModel.SQL.Add('select * from tax_model tm');
    LQueryTaxModel.SQL.Add('where id = :id');


    LQueryCategory.First;
    while not LQueryCategory.Eof do
    begin
      var LJsonCategory := LQueryCategory.ToJSONObject();

      LQueryProdutct.Close;
      LQueryProdutct.ParamByName('category_id').AsString := LQueryCategory.FieldByName('id').AsString;
      LQueryProdutct.ParamByName('company_id').AsString  := CurrentCompany;
      LQueryProdutct.Open();

      var LJosnArrayProduto := TJSONArray.Create;
      LQueryProdutct.First;
      while not (LQueryProdutct.Eof) do
      begin
        var LJsonProduto :=  LQueryProdutct.ToJSONObject();

        LQueryTaxModel.Close;
        LQueryTaxModel.ParamByName('id').AsString := LQueryProdutct.FieldByName('tax_id').AsString;
        LQueryTaxModel.Open();

        LJsonProduto.AddPair('taxModel',LQueryTaxModel.ToJSONObject());
        LJosnArrayProduto.Add(LJsonProduto);
        LQueryProdutct.Next;
      end;

      LJsonCategory.AddPair('products',LJosnArrayProduto);

      LJsonArratResult.Add(LJsonCategory);
      LQueryCategory.Next;
    end;


    LQueryProdutct.Close;
    LQueryProdutct.SQL.Clear;
    LQueryProdutct.SQL.Add('select * from products');
    LQueryProdutct.SQL.Add('where company_id = :company_id and');
    LQueryProdutct.SQL.Add('category_id is null or category_id = '''' ');
    LQueryProdutct.ParamByName('company_id').AsString := CurrentCompany;
    LQueryProdutct.Open();

    if LQueryProdutct.RecordCount > 0 then
    begin
      var LJsonCategoryEmpty := TJSONObject.Create;
      LJsonCategoryEmpty.AddPair('id','EMPTY');
      LJsonCategoryEmpty.AddPair('name','Sem categoria');
      LJsonCategoryEmpty.AddPair('image','EMPTY');


      var LJosnArrayProduto := TJSONArray.Create;
      LQueryProdutct.First;
      while not (LQueryProdutct.Eof) do
      begin
        var LJsonProduto :=  LQueryProdutct.ToJSONObject();

        LQueryTaxModel.Close;
        LQueryTaxModel.ParamByName('id').AsString := LQueryProdutct.FieldByName('tax_id').AsString;
        LQueryTaxModel.Open();

        LJsonProduto.AddPair('taxModel',LQueryTaxModel.ToJSONObject());
        LJosnArrayProduto.Add(LJsonProduto);
        LQueryProdutct.Next;
      end;


      LJsonCategoryEmpty.AddPair('products',LJosnArrayProduto);
      LJsonArratResult.Add(LJsonCategoryEmpty);
    end;

    FServicesResponsePagination.SetRecords(LQueryCategory.RecordCount);
  finally
    LQueryCategory.Free;
    LQueryProdutct.Free;
  end;


  FServicesResponsePagination.SetData(LJsonArratResult);
  Result := FServicesResponsePagination.Content;
end;

function TServicesProduct.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from Products');
  Query.SQL.Add('where id = :id and company_id = :company_id');
  Query.ParamByName('id').AsString         := AId;
  Query.ParamByName('company_id').AsString := CurrentCompany;
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesProduct.Update(AEntity: TEntitiesProduct);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.Products');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Produto não encontrado!');
  end;

  var LPathImage:string := '';
  try
    var LServiceStorage   := TServicesStorage.Create;
    try
      LPathImage := LServiceStorage.SaveImage(TMemoryStream(AEntity.Image));
    finally
      LServiceStorage.Free;
    end;
  except on E: Exception do
    begin
      raise Exception.Create('Erro ao salvar a imagem '+E.Message);
    end;
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.products');
  Query.SQL.Add('SET unity_id = :unity_id,');
  if not AEntity.CategoryId.IsEmpty then
    Query.SQL.Add('category_id = :category_id,')
  else
    Query.SQL.Add('category_id = null,');
  Query.SQL.Add('tax_id = :tax_id, declare_pis_cofins = :declare_pis_cofins,');
  Query.SQL.Add('description = :description, barcode = :barcode,');
  Query.SQL.Add('price_cost = :price_cost, sale_price = :sale_price,');
  Query.SQL.Add('profit_margin = :profit_margin,');
  Query.SQL.Add('stock_quantity = :stock_quantity, minimum_stock = :minimum_stock,');
  Query.SQL.Add('ncm = :ncm, cest = :cest, image = :image, company_id = :company_id,');
  Query.SQL.Add('change_price = :change_price, active = :active, updated_at = :updated_at');
  Query.SQL.Add('WHERE id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ParamByName('unity_id').AsString            := AEntity.UnityId;
  if not AEntity.CategoryId.IsEmpty then
    Query.ParamByName('category_id').AsString         := AEntity.CategoryId;
  Query.ParamByName('tax_id').AsString              := AEntity.TaxId;
  Query.ParamByName('declare_pis_cofins').AsBoolean := AEntity.DeclarePisCofins;
  Query.ParamByName('description').AsString         := AEntity.Description;
  Query.ParamByName('barcode').AsString             := AEntity.Barcode;
  Query.ParamByName('price_cost').AsFloat           := AEntity.PriceCost;
  Query.ParamByName('sale_price').AsFloat           := AEntity.SalePrice;
  Query.ParamByName('profit_margin').AsFloat        := AEntity.ProfitMargin;
  Query.ParamByName('stock_quantity').AsFloat       := AEntity.StockQuantity;
  Query.ParamByName('minimum_stock').AsFloat        := AEntity.MinimumStock;
  Query.ParamByName('ncm').AsString                 := AEntity.Ncm;
  Query.ParamByName('cest').AsString                := AEntity.Cest;
  Query.ParamByName('change_price').AsBoolean       := AEntity.ChangePrice;
  Query.ParamByName('active').AsBoolean             := AEntity.Active;
  Query.ParamByName('image').AsString               := LPathImage;
  Query.ParamByName('updated_at').AsDateTime        := Now();
  Query.ParamByName('company_id').AsString          := AEntity.CompanyId;
  Query.ExecSQL();
end;

end.
