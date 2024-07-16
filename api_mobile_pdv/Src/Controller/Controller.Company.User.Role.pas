unit Controller.Company.User.Role;

interface

uses Horse,
  Services.Company.User.Role,
  Pkg.Json.DTO,
  System.Json,
  REST.Json,
  Entities.Company.User.Role;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Registry;

implementation

procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var
  LService := TServicesCompanyUserRole.Create(Req.Headers.Items['Authorization']);
  var
  LEntity := TJson.JsonToObject<TEntitiesCompanyUserRole>(Req.Body<TJSONObject>);
  try
    LService.Insert(LEntity);
    Res.Status(201).Send(TJSONObject.Create(TJSONPair.Create('mensagem',
      'Registro criado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var
  LService := TServicesCompanyUserRole.Create(Req.Headers.Items['Authorization']);
  try
    LService.ExtractParams(Req.Query);
    var
    LResponse := LService.SelectAll;
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure GetById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var
  LService := TServicesCompanyUserRole.Create(Req.Headers.Items['Authorization']);
  try
    var
    LResponse := LService.SelectById(Req.Params.Items['id']);
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var
  LService := TServicesCompanyUserRole.Create(Req.Headers.Items['Authorization']);
  var
  LEntity := TEntitiesCompanyUserRole.Create;
  LEntity.Id := Req.Params.Items['id'];
  try
    LService.Delete(LEntity);
    Res.Status(200).Send(TJSONObject.Create(TJSONPair.Create('mensagem',
      'Registro deletado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var
  LService := TServicesCompanyUserRole.Create(Req.Headers.Items['Authorization']);
  var
  LEntity := TJson.JsonToObject<TEntitiesCompanyUserRole>(Req.Body<TJSONObject>);
  LEntity.Id := Req.Params.Items['id'];
  try
    LService.Update(LEntity);
    Res.Status(200).Send(TJSONObject.Create(TJSONPair.Create('mensagem',
      'Registro alterado com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Post('company-user-role', Create);
  THorse.Get('company-user-role', Get);
  THorse.Get('company-user-role/:id', GetById);
  THorse.Put('company-user-role/:id', Update);
  THorse.Delete('company-user-role/:id', Delete);
end;

end.
