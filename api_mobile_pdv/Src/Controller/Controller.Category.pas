unit Controller.Category;

interface
uses Horse,
  Services.Category,
  System.Json,
  REST.Json,
  Entities.Category;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Registry;

implementation

procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  //var LEntity  := TJson.JsonToObject<TEntitiesCategory>(Req.Body<TJSONObject>);
  var LService := TServicesCategory.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TEntitiesCategory.Create;
  LEntity.Name := Req.ContentFields.Field('name').AsString;
  if Req.ContentFields.Field('image').AsStream <> nil then
  begin
    if Req.ContentFields.Field('image').AsStream.Size <> 0 then
    begin
      LEntity.Image := Req.ContentFields.Field('image').AsStream;
    end;
  end;

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
  var LService := TServicesCategory.Create(Req.Headers.Items['Authorization']);
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
  var LService := TServicesCategory.Create(Req.Headers.Items['Authorization']);
  try
    var LResponse := LService.SelectById(Req.Params.Items['id']);
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesCategory.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TEntitiesCategory.Create;
  LEntity.Id := Req.Params.Items['id'];
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
  var LService := TServicesCategory.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TEntitiesCategory.Create;
  LEntity.Name := Req.ContentFields.Field('name').AsString;
  LEntity.Id   := Req.Params.Items['id'];
  if Req.ContentFields.Field('image').AsStream <> nil then
  begin
    if Req.ContentFields.Field('image').AsStream.Size <> 0 then
    begin
      LEntity.Image := Req.ContentFields.Field('image').AsStream;
    end;
  end;

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
  THorse.Post('category', Create);
  THorse.Get('category', Get);
  THorse.Get('category/:id', GetById);
  THorse.Put('category/:id', Update);
  THorse.Delete('category/:id', Delete);
end;

end.
