unit Controller.Account;

interface
uses Horse,
  Services.Account,
  Pkg.Json.DTO,
  System.Json,
  REST.Json,
  Entities.Account, Entities.User, Entities.Company;

procedure New(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ReleaseCompany(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Verify(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure VeriryCNPJAndIE(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Registry;

implementation

procedure VeriryCNPJAndIE(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService      := TServicesAccount.Create(Req.Headers.Items['Authorization']);
  var LEntity       := TEntitiesAccount.Create;
  try
    var LCnpj := Req.Params.Items['cnpj'];
    var LIe   := Req.Params.Items['ie'];
    var LJsonResponse := LService.VeriryCNPJAndIE(LCnpj,LIe);

    Res.Status(200).Send(LJsonResponse);
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Verify(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService      := TServicesAccount.Create(Req.Headers.Items['Authorization']);
  var LJsonBody     := Req.Body<TJSONObject>;
  var LEntity       := TEntitiesAccount.Create;
  try
    var LUserEmail := LJsonBody.GetValue<string>('userEmail','');
    var LJsonResponse := LService.Verify(LUserEmail);

    Res.Status(200).Send(LJsonResponse);
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure New(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService      := TServicesAccount.Create(Req.Headers.Items['Authorization']);
  var LJsonBody     := Req.Body<TJSONObject>;
  var LJsonUser     := LJsonBody.GetValue<TJSONObject>('user',nil);
  var LJsonCompany  := LJsonBody.GetValue<TJSONObject>('company',nil);

  var LEntity       := TEntitiesAccount.Create;
  try
    LEntity.User      := TJson.JsonToObject<TEntitiesUser>(LJsonUser);
    LEntity.Company   := TJson.JsonToObject<TEntitiesCompany>(LJsonCompany);
    var LJsonResponse := LService.New(LEntity);
    LJsonResponse.AddPair('mensagem','Conta criada com sucesso!');
    Res.Status(201).Send(LJsonResponse);
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure ReleaseCompany(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  // O certo é ter um token de autenticação aqui
  var LService      := TServicesAccount.Create(Req.Headers.Items['Authorization']);
  var LJsonBody     := Req.Body<TJSONObject>;
  var LEntity       := TEntitiesAccount.Create;
  try
    var LCompanyId := LJsonBody.GetValue<string>('companyId','');
    LService.ReleaseCompany(LCompanyId);
    Res.Status(200).Send(TJSONObject.Create(TJSONPair.Create('mensagem','Conta ativada com sucesso!')));
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Post('account/new', New);
  THorse.Post('account/release-company', ReleaseCompany);
  THorse.Post('account/verify', Verify);
  THorse.Get('account/verify/cnpj/:cnpj/ie/:ie', VeriryCNPJAndIE);
end;

end.
