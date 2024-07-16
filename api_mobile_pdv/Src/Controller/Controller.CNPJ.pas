unit Controller.CNPJ;

interface

uses Horse,
  System.SysUtils,
  Services.CNPJ,
  Pkg.Json.DTO,
  System.Json,
  REST.Json,
  Entities.CNPJ;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Registry;

implementation

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var LService := TServicesCNPJ.Create(Req.Headers.Items['Authorization']);
  try
    LService.ExtractParams(Req.Query);
    var
    LResponse := LService.SelectByCNPJ(Req.Params.Items['cnpj'].Trim);
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('cnpj/:cnpj', Get);
end;

end.
