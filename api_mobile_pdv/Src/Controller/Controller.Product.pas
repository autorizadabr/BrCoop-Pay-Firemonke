unit Controller.Product;

interface
uses Horse,
  Services.Product,
  System.Json,
  REST.Json,
  Entities.Product;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetByCategory(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Registry;

implementation

procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  //var LEntity  := TJson.JsonToObject<TEntitiesProduct>(Req.Body<TJSONObject>);
  var LService             := TServicesProduct.Create(Req.Headers.Items['Authorization']);
  var LEntity              := TEntitiesProduct.Create;
  LEntity.UnityId          := Req.ContentFields.Field('unityId').AsString;
  LEntity.CategoryId       := Req.ContentFields.Field('categoryId').AsString;
  LEntity.TaxId            := Req.ContentFields.Field('taxId').AsString;
  LEntity.DeclarePisCofins := Req.ContentFields.Field('declarePisCofins').AsBoolean;
  LEntity.Description      := Req.ContentFields.Field('description').AsString;
  LEntity.Barcode          := Req.ContentFields.Field('barcode').AsString;
  LEntity.PriceCost        := Req.ContentFields.Field('priceCost').AsFloat;
  LEntity.SalePrice        := Req.ContentFields.Field('salePrice').AsFloat;
  LEntity.ProfitMargin     := Req.ContentFields.Field('profitMargin').AsFloat;
  LEntity.StockQuantity    := Req.ContentFields.Field('stockQuantity').AsFloat;
  LEntity.MinimumStock     := Req.ContentFields.Field('minimumStock').AsFloat;
  LEntity.Ncm              := Req.ContentFields.Field('ncm').AsString;
  LEntity.Cest             := Req.ContentFields.Field('cest').AsString;
  LEntity.ChangePrice      := Req.ContentFields.Field('changePrice').AsBoolean;
  LEntity.Active           := Req.ContentFields.Field('active').AsBoolean;
  LEntity.Image            := Req.ContentFields.Field('image').AsStream;
  LEntity.CompanyId        := Req.ContentFields.Field('companyId').AsString;

  try
    LService.Insert(LEntity);
    Res.Status(201).Send(TJSONObject.Create(TJSONPair.Create('mensagem','Registro criado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesProduct.Create(Req.Headers.Items['Authorization']);
  try
    LService.ExtractParams(Req.Query);
    var LResponse := LService.SelectAll;
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure GetById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesProduct.Create(Req.Headers.Items['Authorization']);
  try
    var LResponse := LService.SelectById(Req.Params.Items['id']);
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure GetByCategory(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesProduct.Create(Req.Headers.Items['Authorization']);
  try
    var LResponse := LService.SelectByCategory;
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesProduct.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TEntitiesProduct.Create;
  LEntity.Id   := Req.Params.Items['id'];
  try
    LService.Delete(LEntity);
    Res.Status(200).Send(TJSONObject.Create(TJSONPair.Create('mensagem','Registro deletado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  //var LEntity  := TJson.JsonToObject<TEntitiesProduct>(Req.Body<TJSONObject>);
  var LService             := TServicesProduct.Create(Req.Headers.Items['Authorization']);
  var LEntity              := TEntitiesProduct.Create;
  LEntity.Id               := Req.Params.Items['id'];
  LEntity.UnityId          := Req.ContentFields.Field('unityId').AsString;
  LEntity.CategoryId       := Req.ContentFields.Field('categoryId').AsString;
  LEntity.TaxId            := Req.ContentFields.Field('taxId').AsString;
  LEntity.DeclarePisCofins := Req.ContentFields.Field('declarePisCofins').AsBoolean;
  LEntity.Description      := Req.ContentFields.Field('description').AsString;
  LEntity.Barcode          := Req.ContentFields.Field('barcode').AsString;
  LEntity.PriceCost        := Req.ContentFields.Field('priceCost').AsFloat;
  LEntity.SalePrice        := Req.ContentFields.Field('salePrice').AsFloat;
  LEntity.ProfitMargin     := Req.ContentFields.Field('profitMargin').AsFloat;
  LEntity.StockQuantity    := Req.ContentFields.Field('stockQuantity').AsFloat;
  LEntity.MinimumStock     := Req.ContentFields.Field('minimumStock').AsFloat;
  LEntity.Ncm              := Req.ContentFields.Field('ncm').AsString;
  LEntity.Cest             := Req.ContentFields.Field('cest').AsString;
  LEntity.ChangePrice      := Req.ContentFields.Field('changePrice').AsBoolean;
  LEntity.Active           := Req.ContentFields.Field('active').AsBoolean;
  LEntity.Image            := Req.ContentFields.Field('image').AsStream;
  LEntity.CompanyId        := Req.ContentFields.Field('companyId').AsString;
  try
    LService.Update(LEntity);
    Res.Status(200).Send(TJSONObject.Create(TJSONPair.Create('mensagem','Registro alterado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Post('product', Create);
  THorse.Get('product', Get);
  THorse.Get('product/:id', GetById);
  THorse.Get('product/category', GetByCategory);
  THorse.Put('product/:id', Update);
  THorse.Delete('product/:id', Delete);
end;

end.
