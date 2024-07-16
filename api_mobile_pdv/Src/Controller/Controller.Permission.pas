unit Controller.Permission;

interface
uses Horse,
  Services.Permission,
  Pkg.Json.DTO,
  System.Json,
  REST.Json,
  Entities.Permission;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetByUserAndCompany(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Registry;


implementation

procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesPermission.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TJson.JsonToObject<TEntitiesPermission>(Req.Body<TJSONObject>);
  try
    LEntity.Validatede;
    LService.Insert(LEntity);
    Res.Status(201).Send(TJSONObject.Create(TJSONPair.Create('mensagem','Registro criado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure GetByUserAndCompany(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LIdUser    := Req.Params.Items['id_user'];
  var LIdCompany := Req.Params.Items['id_company'];
  var LService   := TServicesPermission.Create(Req.Headers.Items['Authorization']);
  try
    LService.ExtractParams(Req.Query);
    Res.Send(LService.SelectByUserAndCompany(LIdUser,LIdCompany));
  finally
    LService.Free;
  end;
end;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesPermission.Create(Req.Headers.Items['Authorization']);
  try
    Res.Send(LService.SelectAll);
  finally
    LService.Free;
  end;
end;
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesPermission.Create(Req.Headers.Items['Authorization']);
  var LEntity := TJson.JsonToObject<TEntitiesPermission>(Req.Body<TJSONObject>);
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

end;

procedure Registry;
begin
  THorse.Get('permission', Get);
  THorse.Get('permission/user/:id_user/compnany/:id_company', GetByUserAndCompany);
  THorse.Post('permission', Create);
  THorse.Put('permission/:id', Update);
  THorse.Delete('permission/:id', Delete);
end;

end.
