unit Controller.CEP;

interface
uses Horse,
  System.SysUtils,
  Services.CEP,
  Pkg.Json.DTO,
  System.Json,
  REST.Json,
  Entities.CEP;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Registry;

implementation

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesCEP.Create(Req.Headers.Items['Authorization']);
  try
    LService.ExtractParams(Req.Query);
    var
    LResponse := LService.SelectByCEP(Req.Params.Items['cep'].Trim);
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('cep/:cep', Get);
end;

end.
