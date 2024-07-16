unit Model.Sincronizacao.Mesa;

interface
  uses
  {$REGION 'Firedac'}
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  {$ENDREGION}
  System.SysUtils, Model.Connection, System.JSON, System.Classes, RESTRequest4D,
  Model.Static.Credencial, DAO.Pedido;

type
  TModelSincronizacaoMesa = class
  private
    procedure EnviarDadosPedidoPagamento(const AQuery: TFDQuery);
    procedure EnviarDadosPedidoItem(const AQuery: TFDQuery; AOrderId: string);
  public
    procedure EnviarParaServidor;
  end;

implementation

{ TModelSincronizacaoMesa }

procedure TModelSincronizacaoMesa.EnviarDadosPedidoItem(const AQuery: TFDQuery;AOrderId:string);
begin
  var LJsonObjetoPedidoItem := TJSONObject.Create;

  LJsonObjetoPedidoItem.AddPair('orderId',AOrderId);
  LJsonObjetoPedidoItem.AddPair('productId',AQuery.FieldByName('product_id').AsString);
  LJsonObjetoPedidoItem.AddPair('amount',AQuery.FieldByName('amount').AsString);
  LJsonObjetoPedidoItem.AddPair('discountValue',AQuery.FieldByName('discount_value').AsFloat);
  LJsonObjetoPedidoItem.AddPair('discountPercentage',AQuery.FieldByName('discount_percentage').AsFloat);
  LJsonObjetoPedidoItem.AddPair('observation',AQuery.FieldByName('observation').AsString);
  LJsonObjetoPedidoItem.AddPair('cfop',AQuery.FieldByName('cfop').AsString);
  LJsonObjetoPedidoItem.AddPair('origin',AQuery.FieldByName('origin').AsString);
  LJsonObjetoPedidoItem.AddPair('csosnCst',AQuery.FieldByName('csosn_cst').AsString);
  LJsonObjetoPedidoItem.AddPair('cstPis',AQuery.FieldByName('cst_pis').AsString);
  LJsonObjetoPedidoItem.AddPair('ppis',AQuery.FieldByName('ppis').AsFloat);
  LJsonObjetoPedidoItem.AddPair('vpis',AQuery.FieldByName('vpis').AsFloat);
  LJsonObjetoPedidoItem.AddPair('cstCofins',AQuery.FieldByName('cst_cofins').AsString);
  LJsonObjetoPedidoItem.AddPair('pcofins',AQuery.FieldByName('pcofins').AsFloat);
  LJsonObjetoPedidoItem.AddPair('vcofins',AQuery.FieldByName('vcofins').AsFloat);
  LJsonObjetoPedidoItem.AddPair('subtotal',AQuery.FieldByName('subtotal').AsFloat);
  LJsonObjetoPedidoItem.AddPair('total',AQuery.FieldByName('total').AsFloat);
  LJsonObjetoPedidoItem.AddPair('userId',AQuery.FieldByName('user_id').AsString);
  LJsonObjetoPedidoItem.AddPair('comanda',AQuery.FieldByName('comanda').AsInteger);
  LJsonObjetoPedidoItem.AddPair('descricao',AQuery.FieldByName('descricao').AsString);

  var LIdOrderItemApi:string;
  var LResponsePedidoItem: IResponse;
  var LRequestPedidoItem:IRequest;
  try
    LRequestPedidoItem := TRequest.New
      .BaseURL(TModelStaticCredencial.GetInstance.BASEURL)
      .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
      .AddBody(LJsonObjetoPedidoItem)
      .Accept('application/json');

    if AQuery.FieldByName('id_order_item_api').AsString.IsEmpty then
    begin
      LRequestPedidoItem.Resource('order-items');
      LResponsePedidoItem := LRequestPedidoItem.Post
    end
    else
    begin
      LRequestPedidoItem.Resource('order-items/'+AQuery.FieldByName('id_order_item_api').AsString);
      LResponsePedidoItem := LRequestPedidoItem.Put;
    end;

    var LJsonResponse := TJSONObject.ParseJSONValue(LResponsePedidoItem.Content);
    try
      // Verificando o status code

      if LResponsePedidoItem.StatusCode = 401 then
      begin
        raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro de autenticação!'));
        Exit;
      end
      else if (LResponsePedidoItem.StatusCode <> 201) and (LResponsePedidoItem.StatusCode <> 200)  then
      begin
        // Tratando o erro
        raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
      end;

      if AQuery.FieldByName('id_order_item_api').AsString.IsEmpty then
        LIdOrderItemApi := LJsonResponse.GetValue<string>('id','')
      else
        LIdOrderItemApi := AQuery.FieldByName('id_order_item_api').AsString;

    finally
      LJsonResponse.Free;
    end;

  except on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;


  var LQueryUpdate        := TFDQuery.Create(nil);
  LQueryUpdate.Connection := ModelConnection.Connection;
  try
    LQueryUpdate.Close;
    LQueryUpdate.SQL.Clear;
    LQueryUpdate.SQL.Add('update order_itens set id_order_item_api = :id_order_item_api,');
    LQueryUpdate.SQL.Add('sync = :sync');
    LQueryUpdate.SQL.Add('where id = :id');
    LQueryUpdate.ParamByName('id').AsInteger               := AQuery.FieldByName('id').AsInteger;
    LQueryUpdate.ParamByName('id_order_item_api').AsString := LIdOrderItemApi;
    LQueryUpdate.ParamByName('sync').AsInteger             := 1;
    LQueryUpdate.ExecSQL;
  finally
    FreeAndNil(LQueryUpdate);
  end;
end;

procedure TModelSincronizacaoMesa.EnviarDadosPedidoPagamento(
  const AQuery: TFDQuery);
begin
  var LJsonObjetoPedidoPagamento := TJSONObject.Create;

  LJsonObjetoPedidoPagamento.AddPair('orderId',AQuery.FieldByName('id_order_api').AsString);
  LJsonObjetoPedidoPagamento.AddPair('paymentId',AQuery.FieldByName('payment_id').AsString);
  LJsonObjetoPedidoPagamento.AddPair('nsu',AQuery.FieldByName('nsu').AsString);
  LJsonObjetoPedidoPagamento.AddPair('autorizationCode',AQuery.FieldByName('autorization_code').AsString);
  //LJsonObjetoPedidoPagamento.AddPair('dateTimeAutorization',AQuery.FieldByName('date_time_autorization').AsString);
  LJsonObjetoPedidoPagamento.AddPair('flag',AQuery.FieldByName('flag').AsString);
  LJsonObjetoPedidoPagamento.AddPair('amountPaid',AQuery.FieldByName('amount_paid').AsFloat);

  var LIdOrderItemApi:string;
  var LResponsePedidoItem: IResponse;
  var LRequestPedidoItem:IRequest;
  try
    LRequestPedidoItem := TRequest.New
      .BaseURL(TModelStaticCredencial.GetInstance.BASEURL)
      .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
      .AddBody(LJsonObjetoPedidoPagamento)
      .Accept('application/json');

    if AQuery.FieldByName('id_order_payment_Api').AsString.IsEmpty then
    begin
      LRequestPedidoItem.Resource('order-payment');
      LResponsePedidoItem := LRequestPedidoItem.Post
    end
    else
    begin
      Exit;
    end;

    var LJsonResponse := TJSONObject.ParseJSONValue(LResponsePedidoItem.Content);
    try
      // Verificando o status code

      if LResponsePedidoItem.StatusCode = 401 then
      begin
        raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro de autenticação!'));
        Exit;
      end
      else if (LResponsePedidoItem.StatusCode <> 201) and (LResponsePedidoItem.StatusCode <> 200)  then
      begin
        // Tratando o erro
        raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
      end;

      if AQuery.FieldByName('id_order_payment_Api').AsString.IsEmpty then
        LIdOrderItemApi := LJsonResponse.GetValue<string>('id','')
      else
        LIdOrderItemApi := AQuery.FieldByName('id_order_payment_Api').AsString;

    finally
      LJsonResponse.Free;
    end;

  except on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;

  var LQueryUpdate        := TFDQuery.Create(nil);
  LQueryUpdate.Connection := ModelConnection.Connection;
  try
    LQueryUpdate.Close;
    LQueryUpdate.SQL.Clear;
    LQueryUpdate.SQL.Add('update order_payment set id_order_payment_Api = :id_order_payment_Api,');
    LQueryUpdate.SQL.Add('sync = :sync');
    LQueryUpdate.SQL.Add('where id = :id');
    LQueryUpdate.ParamByName('id').AsInteger                  := AQuery.FieldByName('id').AsInteger;
    LQueryUpdate.ParamByName('id_order_payment_Api').AsString := LIdOrderItemApi;
    LQueryUpdate.ParamByName('sync').AsInteger                := 1;
    LQueryUpdate.ExecSQL;
  finally
    FreeAndNil(LQueryUpdate);
  end;
end;

procedure TModelSincronizacaoMesa.EnviarParaServidor;
begin
  TMonitor.Enter(ModelConnection.Connection);
  try
    ModelConnection.Connection.StartTransaction;
    try
      var LQueryPedido                 := TFDQuery.Create(nil);
      LQueryPedido.Connection          := ModelConnection.Connection;

      var LQueryPedidoItens            := TFDQuery.Create(nil);
      LQueryPedidoItens.Connection     := ModelConnection.Connection;

      var LQueryUpdate                 := TFDQuery.Create(nil);
      LQueryUpdate.Connection          := ModelConnection.Connection;

      var LQueryPedidoPagamento        := TFDQuery.Create(nil);
      LQueryPedidoPagamento.Connection := ModelConnection.Connection;
      try

        LQueryPedido.Close;
        LQueryPedido.SQL.Clear;
        LQueryPedido.SQL.Add('select * from "order"');
        LQueryPedido.SQL.Add('where sync = :sync and mesa > :mesa');
        LQueryPedido.ParamByName('sync').AsInteger  := -1;
        LQueryPedido.ParamByName('mesa').AsInteger  := 0;
        LQueryPedido.Open();
        LQueryPedido.First;
        var LDAOPedido := TDAOPedido.Create(ModelConnection.Connection);
        try
          while not LQueryPedido.Eof do
          begin
            LDAOPedido.ApagarDadosPeloId(LQueryPedido.FieldByName('id').AsInteger);
            LQueryPedido.Next;
          end;
        finally
          LDAOPedido.Free;
        end;


        LQueryPedido.Close;
        LQueryPedido.SQL.Clear;
        LQueryPedido.SQL.Add('select * from "order" o');
        LQueryPedido.SQL.Add('where o.sync = :sync and mesa > :mesa');
        LQueryPedido.ParamByName('sync').AsInteger  := 0;
        LQueryPedido.ParamByName('mesa').AsInteger  := 0;
        LQueryPedido.Open();

        if LQueryPedido.RecordCount > 0 then
        begin
          LQueryPedidoItens.Close;
          LQueryPedidoItens.SQL.Clear;
          LQueryPedidoItens.SQL.Add('select * from order_itens oi');
          LQueryPedidoItens.SQL.Add('where oi.order_id = :id_order and oi.sync = 0');

          LQueryPedido.First;
          while not LQueryPedido.Eof do
          begin
            var LJsonObjetoPedido := TJSONObject.Create;
            LJsonObjetoPedido.AddPair('companyId',LQueryPedido.FieldByName('company_id').AsString);
            LJsonObjetoPedido.AddPair('userId',LQueryPedido.FieldByName('user_id').AsString);
            LJsonObjetoPedido.AddPair('customerId',LQueryPedido.FieldByName('customer_id').AsString);
            LJsonObjetoPedido.AddPair('typeOrder',LQueryPedido.FieldByName('type_order').AsString);
            LJsonObjetoPedido.AddPair('cpfCnpj',LQueryPedido.FieldByName('cpf_cnpj').AsString);
            // Desconto valor e percentual na API
            LJsonObjetoPedido.AddPair('discount',LQueryPedido.FieldByName('discount_value').AsFloat);
            LJsonObjetoPedido.AddPair('troco',LQueryPedido.FieldByName('troco').AsFloat);
            LJsonObjetoPedido.AddPair('subtotal',LQueryPedido.FieldByName('subtotal').AsFloat);
            LJsonObjetoPedido.AddPair('total',LQueryPedido.FieldByName('total').AsFloat);
            LJsonObjetoPedido.AddPair('status',LQueryPedido.FieldByName('status').AsString);
            LJsonObjetoPedido.AddPair('mesa',LQueryPedido.FieldByName('mesa').AsInteger);
            LJsonObjetoPedido.AddPair('comanda',LQueryPedido.FieldByName('comanda').AsInteger);

            var LIdOrderApi:string;
            var LResponsePedido: IResponse;
            var LRequestPedido:IRequest;
            try
              LRequestPedido := TRequest.New
                .BaseURL(TModelStaticCredencial.GetInstance.BASEURL)
                .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
                .AddBody(LJsonObjetoPedido)
                .Accept('application/json');

              if LQueryPedido.FieldByName('id_order_api').AsString.IsEmpty then
              begin
                LRequestPedido.Resource('order');
                LResponsePedido := LRequestPedido.Post
              end
              else
              begin
                LRequestPedido.Resource('order/'+LQueryPedido.FieldByName('id_order_api').AsString);
                LResponsePedido := LRequestPedido.Put;
              end;

              var LJsonResponse := TJSONObject.ParseJSONValue(LResponsePedido.Content);
              try
                // Verificando o status code

                if LResponsePedido.StatusCode = 401 then
                begin
                  // Quando cair aqui ele vai mostrar uma tela de erro
                  // E quando fechar essa tela de erro o sistema vai executar
                  // o código na procedure "AposFecharATelaDeErro"
                  Exit;
                end
                else if (LResponsePedido.StatusCode <> 200) AND (LResponsePedido.StatusCode <> 201)  then
                begin
                  // Tratando o erro
                  raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
                end;

                if LQueryPedido.FieldByName('id_order_api').AsString.IsEmpty then
                  LIdOrderApi := LJsonResponse.GetValue<string>('id','')
                else
                  LIdOrderApi := LQueryPedido.FieldByName('id_order_api').AsString;

                LQueryUpdate.Close;
                LQueryUpdate.SQL.Clear;
                LQueryUpdate.SQL.Add('update "order" set id_order_api = :id_order_api');
                LQueryUpdate.SQL.Add('where id = :id');
                LQueryUpdate.ParamByName('id').AsInteger          := LQueryPedido.FieldByName('id').AsInteger;
                LQueryUpdate.ParamByName('id_order_api').AsString := LIdOrderApi;
                LQueryUpdate.ExecSQL;

              finally
                LJsonResponse.Free;
              end;

            except on E: Exception do
              begin
                raise Exception.Create(E.Message);
              end;
            end;

            // Enviar os ITENS DO PEDIDO


            LQueryPedidoItens.Close;
            LQueryPedidoItens.ParamByName('id_order').AsInteger := LQueryPedido.FieldByName('id').AsInteger;
            LQueryPedidoItens.Open();


            LQueryPedidoItens.First;
            while not LQueryPedidoItens.Eof do
            begin
              EnviarDadosPedidoItem(LQueryPedidoItens,LIdOrderApi);
              LQueryPedidoItens.Next;
            end;

            LQueryPedido.Next;
          end;

          LQueryPedido.First;
          while not (LQueryPedido.Eof) do
          begin
            LQueryUpdate.Close;
            LQueryUpdate.SQL.Clear;
            LQueryUpdate.SQL.Add('update "order" set sync  = 1');
            LQueryUpdate.SQL.Add('where id = :id');
            LQueryUpdate.ParamByName('id').AsInteger := LQueryPedido.FieldByName('id').AsInteger;
            LQueryUpdate.ExecSQL;
            LQueryPedido.Next;
          end;

        end;

        // Enviar os PAGAMENTOS

        // Pagamentos


        LQueryPedidoPagamento.Close;
        LQueryPedidoPagamento.SQL.Clear;
        LQueryPedidoPagamento.SQL.Add('Select order_payment.*,o.id_order_api  from order_payment');
        LQueryPedidoPagamento.SQL.Add('inner join "order" o on o.id = order_payment.order_id');
        LQueryPedidoPagamento.SQL.Add('where order_payment.sync = 0 and o.mesa > 0');
        LQueryPedidoPagamento.Open();

        LQueryPedidoPagamento.First;
        while not LQueryPedidoPagamento.Eof do
        begin
          EnviarDadosPedidoPagamento(LQueryPedidoPagamento);
          LQueryPedidoPagamento.Next;
        end;



      finally
        FreeAndNil(LQueryPedido);
        FreeAndNil(LQueryPedidoItens);
        FreeAndNil(LQueryPedidoPagamento);
        FreeAndNil(LQueryUpdate);
      end;

      ModelConnection.Connection.Commit;
    except on E: Exception do
      begin
        ModelConnection.Connection.Rollback;
      end;
    end;
  finally
    TMonitor.Exit(ModelConnection.Connection);
  end;
end;

end.
