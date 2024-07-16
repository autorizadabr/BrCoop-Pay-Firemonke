unit Controller.Order;

interface
uses Horse,
  Services.Order,
  System.Json,
  REST.Json,
  System.SysUtils,
  DateUtils,
  System.Generics.Collections,
  Entities.Order, Entities.Order.Itens, Entities.Order.Payment;

procedure Get(Req: THorseRequest; Res: THorseResponse);
procedure GetLargeVolume(Req: THorseRequest; Res: THorseResponse);
procedure GetById(Req: THorseRequest; Res: THorseResponse);
procedure GetByIdItems(Req: THorseRequest; Res: THorseResponse);
procedure Create(Req: THorseRequest; Res: THorseResponse);
procedure CreateLagerVolume(Req: THorseRequest; Res: THorseResponse);
procedure Delete(Req: THorseRequest; Res: THorseResponse);
procedure Update(Req: THorseRequest; Res: THorseResponse);

procedure Registry;

implementation

procedure Create(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesOrder.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TJson.JsonToObject<TEntitiesOrder>(Req.Body<TJSONObject>);
  try
    var LResul := LService.Insert(LEntity);
    Res.Status(201).Send(LResul);
  finally
    LEntity.Free;
    LService.Free;
  end;
end;

procedure GetLargeVolume(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesOrder.Create(Req.Headers.Items['Authorization']);
  var LDateUpdateString     := Req.Params.Items['date-update'];
  LDateUpdateString         := LDateUpdateString.Replace('-','/',[rfReplaceAll]);
  var LDateUpdate:TDateTime := StrToDateTime(LDateUpdateString);
  try
    var LResul := LService.SelectLargeVolume(LDateUpdate);
    Res.Status(201).Send(LResul);
  finally
    LService.Free;
  end;
end;

procedure CreateLagerVolume(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesOrder.Create(Req.Headers.Items['Authorization']);

  var LJsonArrayOrder := Req.Body<TJSONArray>;
  var LArrayEntity:TArray<TEntitiesOrder>;
  SetLength(LArrayEntity,LJsonArrayOrder.Count);
  for var I := 0 to Pred(LJsonArrayOrder.Count) do
  begin

    var LObjectOrder := LJsonArrayOrder[i] as TJSONObject;
    LArrayEntity[I]  := TJson.JsonToObject<TEntitiesOrder>(LObjectOrder);
    LArrayEntity[I].List.Clear;
    if not Assigned(LArrayEntity[I].ListOrderPayment) then
      LArrayEntity[I].ListOrderPayment := TObjectList<TEntitiesOrderPayment>.Create;
    LArrayEntity[I].ListOrderPayment.Clear;
    //
    var LJsonArrayOrderItems := LObjectOrder.GetValue<TJSONArray>('order_items',nil);
    if Assigned(LJsonArrayOrderItems) then
    begin
      for var X := 0 to Pred(LJsonArrayOrderItems.Count) do
      begin
        var LJsonObjetOrderItems := LJsonArrayOrderItems.Items[x] as TJSONObject;
        LArrayEntity[I].List.Add(TJson.JsonToObject<TEntitiesOrderItens>(LJsonObjetOrderItems));
      end;
    end;

    //
    var LJsonArrayOrderPayments := LObjectOrder.GetValue<TJSONArray>('orderPayments',nil);
    if Assigned(LJsonArrayOrderPayments) then
    begin
      for var X := 0 to Pred(LJsonArrayOrderPayments.Count) do
      begin
        var LJsonObjetOrderPayments := LJsonArrayOrderPayments.Items[x] as TJSONObject;
        var LEntityOrderPayment     := TJson.JsonToObject<TEntitiesOrderPayment>(LJsonObjetOrderPayments);
        LEntityOrderPayment.OrderId := LArrayEntity[I].Id;
        LArrayEntity[I].ListOrderPayment.Add(LEntityOrderPayment);
      end;
    end;

  end;

  try
    var LResut := LService.InsertLagerVolume(LArrayEntity);
    Res.Status(201).Send(LResut);
    //Res.Status(201).Send(TJSONObject.Create(TJSONPair.Create('mensagem','Registro criado com sucesso!')));
  finally
    for var I := Low(LArrayEntity) to High(LArrayEntity) do
    begin
      LArrayEntity[I].Free;
    end;
    LService.Free;
  end;

end;

procedure Get(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesOrder.Create(Req.Headers.Items['Authorization']);
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
  var LService := TServicesOrder.Create(Req.Headers.Items['Authorization']);
  try
    var LResponse := LService.SelectById(Req.Params.Items['id']);
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure GetByIdItems(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesOrder.Create(Req.Headers.Items['Authorization']);
  try
    var LResponse := LService.SelectByIdItems(Req.Params.Items['id']);
    Res.Send(LResponse);
  finally
    LService.Free;
  end;
end;

procedure Delete(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TServicesOrder.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TEntitiesOrder.Create;
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
  var LService := TServicesOrder.Create(Req.Headers.Items['Authorization']);
  var LEntity  := TJson.JsonToObject<TEntitiesOrder>(Req.Body<TJSONObject>);
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
  THorse.Post('order', Create);
  THorse.Post('order/large-volume', CreateLagerVolume);
  THorse.Get('order/large-volume/:date-update', GetLargeVolume);
  THorse.Get('order', Get);
  THorse.Get('order/:id', GetById);
  THorse.Get('order/:id/items', GetByIdItems);
  THorse.Put('order/:id', Update);
  THorse.Delete('order/:id', Delete);
end;

end.
