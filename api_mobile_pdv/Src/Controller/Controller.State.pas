unit Controller.State;

interface

uses Horse,
  Services.State,
  System.Json,
  REST.Json,
  Entities.State;

procedure Get(Req: THorseRequest; Res: THorseResponse);
procedure GetById(Req: THorseRequest; Res: THorseResponse);
procedure Create(Req: THorseRequest; Res: THorseResponse);
procedure Delete(Req: THorseRequest; Res: THorseResponse);
procedure Update(Req: THorseRequest; Res: THorseResponse);

procedure Registry;

implementation

procedure Create(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesState.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TJson.JsonToObject<TEntitiesState>(Req.Body<TJSONObject>);
  try
    LService.Insert(LEntity);
    Res.Status(201).Send(TJSONObject.Create(TJSONPair.Create('mensagem','Registro criado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Get(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesState.Create(Req.Headers.Items['Authorization']);
  try
    LService.ExtractParams(Req.Query);
    var LResponse := LService.SelectAll;
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure GetById(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesState.Create(Req.Headers.Items['Authorization']);
  try
    var LResponse := LService.SelectById(Req.Params.Items['id']);
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure Delete(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesState.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TEntitiesState.Create;
  LEntity.Id := Req.Params.Items['id'];
  try
    LService.Delete(LEntity);
    Res.Status(200).Send(TJSONObject.Create(TJSONPair.Create('mensagem','Registro deletado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Update(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesState.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TJson.JsonToObject<TEntitiesState>(Req.Body<TJSONObject>);
  LEntity.Id := Req.Params.Items['id'];
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
  THorse.Post('state', Create);
  THorse.Get('state', Get);
  THorse.Get('state/:id', GetById);
  THorse.Put('state/:id', Update);
  THorse.Delete('state/:id', Delete);
end;

end.
