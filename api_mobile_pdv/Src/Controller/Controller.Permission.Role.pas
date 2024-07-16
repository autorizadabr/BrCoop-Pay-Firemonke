unit Controller.Permission.Role;

interface
uses Horse,
  Services.Permission.Role,
  Pkg.Json.DTO,
  System.Json,
  REST.Json,
  Entities.Permission.Role;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Registry;


implementation

procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicePermissionRole.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TJson.JsonToObject<TEntitiesPermissionRole>(Req.Body<TJSONObject>);
  try
    LEntity.Validatede;
    LService.Insert(LEntity);
    Res.Status(201).Send(TJSONObject.Create(TJSONPair.Create('mensagem','Registro criado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicePermissionRole.Create(Req.Headers.Items['Authorization']);
  try
    Res.Send(LService.SelectAll);
  finally
    LService.Free;
  end;
end;
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicePermissionRole.Create(Req.Headers.Items['Authorization']);
  var LEntity := TJson.JsonToObject<TEntitiesPermissionRole>(Req.Body<TJSONObject>);
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
  THorse.Get('permission-role', Get);
  THorse.Post('permission-role', Create);
  THorse.Put('permission-role/:id', Update);
  THorse.Delete('permission-role/:id', Delete);
end;

end.

