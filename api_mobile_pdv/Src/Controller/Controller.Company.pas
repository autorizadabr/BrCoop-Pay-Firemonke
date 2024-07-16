unit Controller.Company;

interface
uses Horse,
  Services.Company,
  Pkg.Json.DTO,
  System.Json,
  REST.Json,
  Entities.Company;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetByUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Registry;


implementation

procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesCompany.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TJson.JsonToObject<TEntitiesCompany>(Req.Body<TJSONObject>);
  try
    LService.Insert(LEntity);
    Res.Status(201).Send(TJSONObject.Create(TJSONPair.Create('mensagem','Registro criado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure GetByUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesCompany.Create(Req.Headers.Items['Authorization']);
  try
    var LResponse := LService.SelectByUser(Req.Params.Items['id']);
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure GetById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesCompany.Create(Req.Headers.Items['Authorization']);
  try
    var LResponse := LService.SelectById(Req.Params.Items['id']);
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesCompany.Create(Req.Headers.Items['Authorization']);
  try
    LService.ExtractParams(Req.Query);
    var LResponse := LService.SelectAll;
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesCompany.Create(Req.Headers.Items['Authorization']);
  var LEntity := TJson.JsonToObject<TEntitiesCompany>(Req.Body<TJSONObject>);
  LEntity.Id := Req.Params.Required(false).Field('id').AsString;
  try
    LEntity.Validatede;
    LService.Update(LEntity);
    Res.Status(200).Send(TJSONObject.Create(TJSONPair.Create('mensagem','Registro alterado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesCompany.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TEntitiesCompany.Create;
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
  THorse.Get('company', Get);
  THorse.Get('company/user/:id', GetByUser);
  THorse.Get('company/:id', GetById);
  THorse.Post('company', Create);
  THorse.Put('company/:id', Update);
  THorse.Delete('company/:id', Delete);
end;

end.
