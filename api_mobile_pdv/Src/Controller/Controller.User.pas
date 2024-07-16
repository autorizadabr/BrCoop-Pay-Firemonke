unit Controller.User;

interface
uses Horse,
  Services.User,
  Pkg.Json.DTO,
  System.Json,
  REST.Json,
  Entities.User;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetByCompany(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetUserEmailExist(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Registry;

implementation

procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesUser.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TJson.JsonToObject<TEntitiesUser>(Req.Body<TJSONObject>);
  try
    LService.Insert(LEntity);
    Res.Status(201).Send(TJSONObject.Create(TJSONPair.Create('mensagem','Registro criado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure GetUserEmailExist(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService  := TServicesUser.Create(Req.Headers.Items['Authorization']);
  var LEntity   := TEntitiesUser.Create;
  LEntity.Email := Req.Params.Items['email'];
  try
    var LResult:Boolean  := LService.GetEmailUserExist(LEntity);
    var LResonse         := TJSONObject.Create;
    LResonse.AddPair('emailExist',LResult);
    Res.Status(200).Send(LResonse);
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesUser.Create(Req.Headers.Items['Authorization']);
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
  var LService := TServicesUser.Create(Req.Headers.Items['Authorization']);
  try
    var LResponse := LService.SelectById(Req.Params.Items['id']);
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure GetByCompany(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesUser.Create(Req.Headers.Items['Authorization']);
  try
    var LResponse := LService.SelectByCompany;
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesUser.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TEntitiesUser.Create;
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
  var LService := TServicesUser.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TJson.JsonToObject<TEntitiesUser>(Req.Body<TJSONObject>);
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
  THorse.Post('user', Create);
  THorse.Get('user', Get);
  THorse.Get('user/company', GetByCompany);
  THorse.Get('user/email/:email', GetUserEmailExist);
  THorse.Get('user/:id', GetById);
  THorse.Put('user/:id', Update);
  THorse.Delete('user/:id', Delete);
end;

end.
