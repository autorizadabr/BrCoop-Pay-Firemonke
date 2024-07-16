unit Controller.Order.Itens;

interface
uses Horse,
  Services.Order.Itens,
  System.Json,
  REST.Json,
  Entities.Order.Itens;

procedure Get(Req: THorseRequest; Res: THorseResponse);
procedure GetById(Req: THorseRequest; Res: THorseResponse);
procedure Create(Req: THorseRequest; Res: THorseResponse);
procedure Delete(Req: THorseRequest; Res: THorseResponse);
procedure Update(Req: THorseRequest; Res: THorseResponse);

procedure Registry;

implementation

procedure Create(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesOrderItens.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TJson.JsonToObject<TEntitiesOrderItens>(Req.Body<TJSONObject>);
  try
    var LResult := LService.Insert(LEntity);
    Res.Status(201).Send(LResult);
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Update(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesOrderItens.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TJson.JsonToObject<TEntitiesOrderItens>(Req.Body<TJSONObject>);
  LEntity.Id := Req.Params.Items['id'];
  try
    LService.Update(LEntity);
    Res.Status(200).Send(TJSONObject.Create(TJSONPair.Create('mensagem','Registro alterado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Get(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesOrderItens.Create(Req.Headers.Items['Authorization']);
  try
    LService.ExtractParams(Req.Query);
    var LResponse := LService.SelectAll(Req.Params.Items['order']);
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure GetById(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesOrderItens.Create(Req.Headers.Items['Authorization']);
  try
    var LResponse := LService.SelectById(Req.Params.Items['id']);
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure Delete(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesOrderItens.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TEntitiesOrderItens.Create;
  LEntity.Id := Req.Params.Items['id'];
  try
    LService.Delete(LEntity);
    Res.Status(200).Send(TJSONObject.Create(TJSONPair.Create('mensagem','Registro deletado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Post('order-items', Create);
  THorse.Get('order-items/:order', Get);
  THorse.Get('order-items/:id', GetById);
  THorse.Put('order-items/:id', Update);
  THorse.Delete('order-items/:id', Delete);
end;

end.
