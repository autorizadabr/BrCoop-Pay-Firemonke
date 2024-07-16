unit Controller.Authentication;

interface
uses Horse,
  Services.Authentication,
  Pkg.Json.DTO,
  System.Json,
  REST.Json,
  System.SysUtils,
  Horse.Utils.ClientIP,
  Entities.User;
procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure RegisterUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure RefreshToekn(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ResetPassword(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure UpdatePassword(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Registry;

implementation

procedure RefreshToekn(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LBody := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
  var LService := TServicesAuthentication.Create(Req.Headers.Items['Authorization']);
  try
    var LIdUser       := LBody.GetValue<string>('idUser','');
    var LIdCompany    := LBody.GetValue<string>('idCompany','');
    var LJsonResponse := LService.RefreshToken(LIdUser,LIdCompany);
    Res.Send(LJsonResponse);
  finally
    LService.Free;
  end;
end;

procedure ResetPassword(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LBody    := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
  var LEntity  := TJson.JsonToObject<TEntitiesUser>(LBody);
  var LService := TServicesAuthentication.Create(Req.Headers.Items['Authorization']);
  var LIP      := ClientIP(Req);
  try
    var LCode          := LService.ResetPassword(LEntity,LIP);
    var LJsonResponse  := TJSONObject.Create;
    LJsonResponse.AddPair('meesege','E-mail com o código de acesso enviado com sucesso!');
    LJsonResponse.AddPair('code',LCode);
    Res.Send(LJsonResponse);
  finally
    if Assigned(LEntity) then
      LEntity.Free;
    LService.Free;
  end;
end;

procedure UpdatePassword(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LBody    := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
  var LEntity  := TJson.JsonToObject<TEntitiesUser>(LBody);
  var LService := TServicesAuthentication.Create(Req.Headers.Items['Authorization']);
  try
    LService.UpdatePassword(LEntity);
    var LJsonResponse  := TJSONObject.Create;
    LJsonResponse.AddPair('meesege','Senha redefinada com sucesso!');
    Res.Send(LJsonResponse);
  finally
    if Assigned(LEntity) then
      LEntity.Free;
    LService.Free;
  end;
end;

procedure RegisterUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LBody    := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
  var LEntity  := TJson.JsonToObject<TEntitiesUser>(LBody);
  var LService := TServicesAuthentication.Create(Req.Headers.Items['Authorization']);
  try
    LService.RegisterUser(LEntity);
    var LJsonResponse := TJSONObject.Create;
    LJsonResponse.AddPair('meesege','Usuário registrado com sucesso!');
    Res.Send(LJsonResponse);
  finally
    LService.Free;
  end;
end;
procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LEntity  := TJson.JsonToObject<TEntitiesUser>(Req.Body<TJSONObject>);
  var LService := TServicesAuthentication.Create(Req.Headers.Items['Authorization']);
  try
    var LResponse := LService.GetLoginUser(LEntity);
    Res.Send(LResponse);
  finally
    LEntity.Free;
    LService.Free;
  end;
end;
procedure Registry;
begin
  THorse.Post('authentication/login', Login);
  THorse.Post('authentication/register', RegisterUser);
  THorse.Post('authentication/reset-password', ResetPassword);
  THorse.Post('authentication/refresh-token', RefreshToekn);
  THorse.Post('authentication/update-password', UpdatePassword);
end;
end.
