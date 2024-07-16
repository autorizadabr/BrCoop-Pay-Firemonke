unit Controller.Order.Payment;

interface

uses Horse,
  Services.Order.Payment,
  System.Json,
  REST.Json,
  Entities.Order.Payment;

procedure Get(Req: THorseRequest; Res: THorseResponse);
procedure GetById(Req: THorseRequest; Res: THorseResponse);
procedure Create(Req: THorseRequest; Res: THorseResponse);
procedure Delete(Req: THorseRequest; Res: THorseResponse);
procedure Update(Req: THorseRequest; Res: THorseResponse);

procedure Registry;

implementation

procedure Create(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesOrderPayment.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TJson.JsonToObject<TEntitiesOrderPayment>(Req.Body<TJSONObject>);
  try
    var LResult := LService.Insert(LEntity);
    Res.Status(201).Send(LResult);
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure Get(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesOrderPayment.Create(Req.Headers.Items['Authorization']);
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
  var LService := TServicesOrderPayment.Create(Req.Headers.Items['Authorization']);
  try
    var LResponse := LService.SelectById(Req.Params.Items['id']);
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure Delete(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesOrderPayment.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TEntitiesOrderPayment.Create;
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
  var LService := TServicesOrderPayment.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TJson.JsonToObject<TEntitiesOrderPayment>(Req.Body<TJSONObject>);
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
  THorse.Post('order-payment', Create);
  THorse.Get('order-payment', Get);
  THorse.Get('order-payment/:id', GetById);
  THorse.Put('order-payment/:id', Update);
  THorse.Delete('order-payment/:id', Delete);
end;

end.
