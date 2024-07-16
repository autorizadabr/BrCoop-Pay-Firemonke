unit Model.Sincronizacao.Pedido;

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
  System.SysUtils, Model.Connection, System.JSON,System.Generics.Collections,
  System.Classes, RESTRequest4D,
  Model.Static.Credencial, System.DateUtils, DAO.Pedido, Model.Utils;
type
  TModelSincronizacaoPedido = class
  private
  procedure InsertUpdatePedidoItens(const AJsonObject:TJSONObject);
  public
    constructor Create;
    destructor Destroy; override;
    function EnviarParaServidor:Integer;
    function BuscarDadosServidor(const ADateTime:TDateTime):TDateTime;
  end;

implementation

{ TModelSincronizacaoPedido }

function TModelSincronizacaoPedido.BuscarDadosServidor(
  const ADateTime: TDateTime): TDateTime;
begin
  var LDateRequest := DateTimeToStr(ADateTime);
  LDateRequest     := LDateRequest.Replace('/','-',[rfReplaceAll]);
  var LResponsePedido: IResponse;
  var LRequestPedido:IRequest;
  try
    LRequestPedido := TRequest.New
      .BaseURL(TModelStaticCredencial.GetInstance.BASEURL)
      .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
      .Resource('order/large-volume/'+LDateRequest)
      .Accept('application/json');
      LResponsePedido := LRequestPedido.Get;

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
      else if LResponsePedido.StatusCode <> 201  then
      begin
        // Tratando o erro
        raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
      end;

      var LData := LJsonResponse.GetValue<TJSONObject>('data',nil);
      var LPrimeiraDataEncontrada:TDateTime := ADateTime;
      if Assigned(LData) then
      begin
        LPrimeiraDataEncontrada := StrToDateTime(LData.GetValue<string>('firstDate',''));

        var LJsonArrayPedidos           := LData.GetValue<TJSONArray>('order',nil);
        var LJsonArrayPedidosItens      := LData.GetValue<TJSONArray>('orderItens',nil);
        var LJsonArrayPedidosPagamentos := LData.GetValue<TJSONArray>('orderPayment',nil);

        if Assigned(LJsonArrayPedidos) then
        begin
          var LDAOPedido             := TDAOPedido.Create(ModelConnection.Connection);
          var LQueryPedido           := TFDQuery.Create(nil);
          LQueryPedido.Connection    := ModelConnection.Connection;

          var LQuerySelectMax        := TFDQuery.Create(nil);
          LQuerySelectMax.Connection := ModelConnection.Connection;
          try
            try
              ModelConnection.Connection.StartTransaction;
              for var LIndexPedido := 0 to Pred(LJsonArrayPedidos.Count) do
              begin
                var LJsonObjetoItemPedido := TJSONObject(LJsonArrayPedidos[LIndexPedido]);
                var LIdOrderApi := LJsonObjetoItemPedido.GetValue<string>('id','');
                LQueryPedido.Close;
                LQueryPedido.SQL.Clear;
                LQueryPedido.SQL.Add('select * from "order"');
                LQueryPedido.SQL.Add('where id_order_api = :id_order_api');
                LQueryPedido.ParamByName('id_order_api').AsString := LIdOrderApi;
                LQueryPedido.Open();

                var LIdPedido:Integer;
                if LQueryPedido.RecordCount <= 0 then
                begin
                  LQueryPedido.Close;
                  LQueryPedido.SQL.Clear;
                  LQueryPedido.SQL.Add('INSERT INTO "order"');
                  LQueryPedido.SQL.Add('(id, company_id, user_id, customer_id, type_order,');
                  LQueryPedido.SQL.Add('cpf_cnpj, discount_value, discount_percentage, troco, subtotal,');
                  LQueryPedido.SQL.Add('total, created_at, updated_at, status,mesa, comanda, sync, id_order_api)');
                  LQueryPedido.SQL.Add('VALUES(:id, :company_id, :user_id, :customer_id,');
                  LQueryPedido.SQL.Add(':type_order, :cpf_cnpj, :discount_value, :discount_percentage,');
                  LQueryPedido.SQL.Add(':troco, :subtotal, :total, :created_at, :updated_at, :status,');
                  LQueryPedido.SQL.Add(':mesa,:comanda, :sync, :id_order_api);');
                  LQueryPedido.ParamByName('id_order_api').AsString := LIdOrderApi;

                  LQuerySelectMax.Close;
                  LQuerySelectMax.SQL.Clear;
                  LQuerySelectMax.SQL.Add('select COALESCE(max(id),0) +1 as ID from "order"');
                  LQuerySelectMax.Open();
                  LIdPedido := LQuerySelectMax.FieldByName('id').AsInteger;
                end
                else
                begin
                  LIdPedido := LQueryPedido.FieldByName('id').AsInteger;
                  LQueryPedido.Close;
                  LQueryPedido.SQL.Clear;
                  LQueryPedido.SQL.Add('update "order" set');
                  LQueryPedido.SQL.Add('user_id = :user_id,');
                  LQueryPedido.SQL.Add('customer_id = :customer_id, type_order = :type_order,');
                  LQueryPedido.SQL.Add('cpf_cnpj = :cpf_cnpj, discount_value = :discount_value');
                  LQueryPedido.SQL.Add(',discount_percentage  = :discount_percentage, troco = :troco,');
                  LQueryPedido.SQL.Add('subtotal = :subtotal, total = :total, sync = :sync,created_at = :created_at,');
                  LQueryPedido.SQL.Add('updated_at = :updated_at, status = :status, mesa = :mesa, comanda = :comanda');
                  LQueryPedido.SQL.Add('where id = :id and company_id = :company_id');
                end;

                LQueryPedido.ParamByName('id').AsInteger                := LIdPedido;
                LQueryPedido.ParamByName('company_id').AsString         := LJsonObjetoItemPedido.GetValue<string>('companyId','');
                LQueryPedido.ParamByName('user_id').AsString            := LJsonObjetoItemPedido.GetValue<string>('userId','');
                LQueryPedido.ParamByName('customer_id').AsString        := LJsonObjetoItemPedido.GetValue<string>('customerId','');
                LQueryPedido.ParamByName('type_order').AsInteger        := LJsonObjetoItemPedido.GetValue<Integer>('typeOrder',0);
                LQueryPedido.ParamByName('cpf_cnpj').AsString           := LJsonObjetoItemPedido.GetValue<string>('cpfCnpj','');
                LQueryPedido.ParamByName('discount_value').AsFloat      := LJsonObjetoItemPedido.GetValue<Float64>('discount',0);
                LQueryPedido.ParamByName('discount_percentage').AsFloat := LJsonObjetoItemPedido.GetValue<Float64>('discount',0);
                LQueryPedido.ParamByName('troco').AsFloat               := LJsonObjetoItemPedido.GetValue<Float64>('troco',0);
                LQueryPedido.ParamByName('subtotal').AsFloat            := LJsonObjetoItemPedido.GetValue<Float64>('subtotal',0);
                LQueryPedido.ParamByName('total').AsFloat               := LJsonObjetoItemPedido.GetValue<Float64>('total',0);
                LQueryPedido.ParamByName('created_at').AsString         := TModelUtils.ISO8601StringToDateTimeString(LJsonObjetoItemPedido.GetValue<string>('createdAt',''));
                LQueryPedido.ParamByName('updated_at').AsString         := TModelUtils.ISO8601StringToDateTimeString(LJsonObjetoItemPedido.GetValue<string>('updatedAt',''));
                LQueryPedido.ParamByName('status').AsString             := 'FECHADO';
                if LJsonObjetoItemPedido.GetValue<string>('status','').ToUpper.Equals('ABERTO') then
                  LQueryPedido.ParamByName('status').AsString           := 'ABERTO';
                LQueryPedido.ParamByName('sync').AsInteger              := 1;
                LQueryPedido.ParamByName('mesa').AsInteger              := LJsonObjetoItemPedido.GetValue<integer>('mesa',0);
                LQueryPedido.ParamByName('comanda').AsInteger           := LJsonObjetoItemPedido.GetValue<integer>('comanda',0);

                LQueryPedido.ExecSQL;


                // PEDIDOS ITENS


                var LQueryPedidoItens        := TFDQuery.Create(nil);
                LQueryPedidoItens.Connection := ModelConnection.Connection;
                try
                  for var LIndexPedidoItem := 0 to Pred(LJsonArrayPedidosItens.Count) do
                  begin
                    var LJsonObjetoItemPedidoItem := LJsonArrayPedidosItens.Items[LIndexPedidoItem] as TJSONObject;
                    if LJsonObjetoItemPedidoItem.GetValue<string>('orderId').Equals(LIdOrderApi) then
                    begin
                      var LIdPedidoItensApi := LJsonObjetoItemPedidoItem.GetValue<string>('id','');

                      LQueryPedidoItens.Close;
                      LQueryPedidoItens.SQL.Clear;
                      LQueryPedidoItens.SQL.Add('select * from order_itens');
                      LQueryPedidoItens.SQL.Add('where id_order_item_api = :id_order_item_api');
                      LQueryPedidoItens.ParamByName('id_order_item_api').AsString := LIdPedidoItensApi;
                      LQueryPedidoItens.Open();

                      var LIdPedidoItens:Integer;
                      if LQueryPedidoItens.RecordCount <= 0 then
                      begin
                        LQuerySelectMax.Close;
                        LQuerySelectMax.SQL.Clear;
                        LQuerySelectMax.SQL.Add('select COALESCE(max(id),0) +1 as ID from "order_itens"');
                        LQuerySelectMax.Open();
                        LIdPedidoItens := LQuerySelectMax.FieldByName('id').AsInteger;

                        LQueryPedidoItens.Close;
                        LQueryPedidoItens.SQL.Clear;
                        LQueryPedidoItens.SQL.Add('INSERT INTO order_itens');
                        LQueryPedidoItens.SQL.Add('(id, number_item, order_id, product_id,');
                        LQueryPedidoItens.SQL.Add('amount, discount_value,');
                        LQueryPedidoItens.SQL.Add('discount_percentage, cfop, origin,');
                        LQueryPedidoItens.SQL.Add('csosn_cst, cst_pis, ppis, vpis, cst_cofins,');
                        LQueryPedidoItens.SQL.Add('pcofins, vcofins, valor_unitario, subtotal, total,');
                        LQueryPedidoItens.SQL.Add('created_at, updated_at, observation,');
                        LQueryPedidoItens.SQL.Add('id_order_item_api, user_id, sync)');
                        LQueryPedidoItens.SQL.Add('VALUES(:id, :number_item, :order_id,');
                        LQueryPedidoItens.SQL.Add(':product_id, :amount, :discount_value,');
                        LQueryPedidoItens.SQL.Add(':discount_percentage, :cfop, :origin,');
                        LQueryPedidoItens.SQL.Add(':csosn_cst, :cst_pis, :ppis, :vpis,');
                        LQueryPedidoItens.SQL.Add(':cst_cofins, :pcofins, :vcofins,');
                        LQueryPedidoItens.SQL.Add(':valor_unitario, :subtotal, :total,');
                        LQueryPedidoItens.SQL.Add(':created_at, :updated_at, :observation,');
                        LQueryPedidoItens.SQL.Add(':id_order_item_api, :user_id, :sync);');
                        LQueryPedidoItens.ParamByName('created_at').AsString := TModelUtils.ISO8601StringToDateTimeString(LJsonObjetoItemPedidoItem.GetValue<string>('createdAt',''));
                      end
                      else
                      begin
                        LIdPedidoItens := LQueryPedidoItens.FieldByName('id').AsInteger;
                        LQueryPedidoItens.Close;
                        LQueryPedidoItens.SQL.Clear;
                        LQueryPedidoItens.SQL.Add('update order_itens set ');
                        LQueryPedidoItens.SQL.Add('id = :id, number_item = :number_item, order_id = :order_id, product_id = :product_id,');
                        LQueryPedidoItens.SQL.Add('amount = :amount, discount_value = :discount_value,');
                        LQueryPedidoItens.SQL.Add('discount_percentage = :discount_percentage, cfop = :cfop, origin = :origin,');
                        LQueryPedidoItens.SQL.Add('csosn_cst = :csosn_cst, cst_pis = :cst_pis, ppis = :ppis, vpis = :vpis, cst_cofins = :cst_cofins,');
                        LQueryPedidoItens.SQL.Add('pcofins = :pcofins, vcofins = :vcofins, valor_unitario = :valor_unitario, subtotal = :subtotal, total = :total,');
                        LQueryPedidoItens.SQL.Add('updated_at = :updated_at, observation = :observation,');
                        LQueryPedidoItens.SQL.Add('id_order_item_api = :id_order_item_api, user_id = :user_id, sync = :sync');
                        LQueryPedidoItens.SQL.Add('where id = :id');
                      end;

                      LQueryPedidoItens.ParamByName('id').AsInteger                := LIdPedidoItens;
                      LQueryPedidoItens.ParamByName('number_item').AsInteger       := 0;
                      LQueryPedidoItens.ParamByName('order_id').AsInteger          := LIdPedido;
                      LQueryPedidoItens.ParamByName('product_id').AsString         := LJsonObjetoItemPedidoItem.GetValue<string>('productId','');
                      LQueryPedidoItens.ParamByName('amount').AsFloat              := LJsonObjetoItemPedidoItem.GetValue<Integer>('Quantidade',0);
                      LQueryPedidoItens.ParamByName('discount_value').AsFloat      := LJsonObjetoItemPedidoItem.GetValue<Currency>('discountValue',0);
                      LQueryPedidoItens.ParamByName('discount_percentage').AsFloat := LJsonObjetoItemPedidoItem.GetValue<Currency>('discountPercentage',0);
                      LQueryPedidoItens.ParamByName('cfop').AsString               := LJsonObjetoItemPedidoItem.GetValue<string>('cfop','');
                      LQueryPedidoItens.ParamByName('observation').AsString        := LJsonObjetoItemPedidoItem.GetValue<string>('observation','');
                      LQueryPedidoItens.ParamByName('origin').AsString             := LJsonObjetoItemPedidoItem.GetValue<string>('origin','');
                      LQueryPedidoItens.ParamByName('csosn_cst').AsString          := LJsonObjetoItemPedidoItem.GetValue<string>('csosnCst','');
                      LQueryPedidoItens.ParamByName('cst_pis').AsString            := LJsonObjetoItemPedidoItem.GetValue<string>('cstPis','');
                      LQueryPedidoItens.ParamByName('ppis').AsFloat                := LJsonObjetoItemPedidoItem.GetValue<Currency>('ppis',0);
                      LQueryPedidoItens.ParamByName('vpis').AsFloat                := LJsonObjetoItemPedidoItem.GetValue<Currency>('vpis',0);
                      LQueryPedidoItens.ParamByName('cst_cofins').AsString         := LJsonObjetoItemPedidoItem.GetValue<string>('cstCofins','');
                      LQueryPedidoItens.ParamByName('pcofins').AsFloat             := LJsonObjetoItemPedidoItem.GetValue<Currency>('pcofins',0);
                      LQueryPedidoItens.ParamByName('vcofins').AsFloat             := LJsonObjetoItemPedidoItem.GetValue<Currency>('vcofins',0);
                      LQueryPedidoItens.ParamByName('valor_unitario').AsFloat      := LJsonObjetoItemPedidoItem.GetValue<Currency>('valorUnitario',0);
                      LQueryPedidoItens.ParamByName('subtotal').AsFloat            := LJsonObjetoItemPedidoItem.GetValue<Currency>('subtotal',0);
                      LQueryPedidoItens.ParamByName('total').AsFloat               := LJsonObjetoItemPedidoItem.GetValue<Currency>('total',0);
                      LQueryPedidoItens.ParamByName('updated_at').AsString         := TModelUtils.ISO8601StringToDateTimeString(LJsonObjetoItemPedidoItem.GetValue<string>('updatedAt',''));
                      LQueryPedidoItens.ParamByName('id_order_item_api').AsString  := LIdPedidoItensApi;
                      LQueryPedidoItens.ParamByName('user_id').AsString            := LJsonObjetoItemPedidoItem.GetValue<string>('UserId','');
                      LQueryPedidoItens.ParamByName('sync').AsInteger              := 1;
                      LQueryPedidoItens.ExecSQL;

                    end;
                  end;
                finally
                  FreeAndNil(LQueryPedidoItens);
                end;


                // PEDIDO PAGAMENTOS


                var LQueryPedidoPagamentos        := TFDQuery.Create(nil);
                LQueryPedidoPagamentos.Connection := ModelConnection.Connection;
                try
                  for var LIndexPedidoPagamento := 0 to Pred(LJsonArrayPedidosPagamentos.Count) do
                  begin
                    var LJsonObjetoItemPedidoPagamento := LJsonArrayPedidosItens.Items[LIndexPedidoPagamento] as TJSONObject;
                    if LJsonObjetoItemPedidoPagamento.GetValue<string>('orderId').Equals(LIdOrderApi) then
                    begin
                      var LIdPedidoPagamentoApi := LJsonObjetoItemPedidoPagamento.GetValue<string>('id','');

                      LQueryPedidoPagamentos.Close;
                      LQueryPedidoPagamentos.SQL.Clear;
                      LQueryPedidoPagamentos.SQL.Add('select * from order_payment');
                      LQueryPedidoPagamentos.SQL.Add('where id_order_payment_Api = :id_order_payment_Api');
                      LQueryPedidoPagamentos.ParamByName('id_order_payment_Api').AsString := LIdPedidoPagamentoApi;
                      LQueryPedidoPagamentos.Open();

                      var LIdPedidoPagamento:Integer;
                      if LQueryPedidoPagamentos.RecordCount <= 0 then
                      begin
                        LQuerySelectMax.Close;
                        LQuerySelectMax.SQL.Clear;
                        LQuerySelectMax.SQL.Add('select COALESCE(max(id),0) +1 as ID from "order_payment"');
                        LQuerySelectMax.Open();
                        LIdPedidoPagamento := LQuerySelectMax.FieldByName('id').AsInteger;

                        LQueryPedidoPagamentos.Close;
                        LQueryPedidoPagamentos.SQL.Clear;
                        LQueryPedidoPagamentos.SQL.Add('INSERT INTO order_payment');
                        LQueryPedidoPagamentos.SQL.Add('(id, order_id, payment_id, nsu,');
                        LQueryPedidoPagamentos.SQL.Add('autorization_code, date_time_autorization,');
                        LQueryPedidoPagamentos.SQL.Add('flag, amount_paid, created_at,updated_at)');
                        LQueryPedidoPagamentos.SQL.Add('VALUES(:id, :order_id, :payment_id, :nsu,');
                        LQueryPedidoPagamentos.SQL.Add(':autorization_code, :date_time_autorization,');
                        LQueryPedidoPagamentos.SQL.Add(':flag, :amount_paid, :created_at,:updated_at)');
                        LQueryPedidoPagamentos.ParamByName('created_at').AsString  := TModelUtils.ISO8601StringToDateTimeString(LJsonObjetoItemPedidoPagamento.GetValue<string>('createdAt',''));
                      end
                      else
                      begin
                        LIdPedidoPagamento := LQueryPedidoPagamentos.FieldByName('id').AsInteger;
                        LQueryPedidoPagamentos.Close;
                        LQueryPedidoPagamentos.SQL.Clear;
                        LQueryPedidoPagamentos.SQL.Add('update set order_payment');
                        LQueryPedidoPagamentos.SQL.Add('order_id = :order_id, payment_id = :payment_id, nsu = :nsu,');
                        LQueryPedidoPagamentos.SQL.Add('autorization_code = :autorization_code, date_time_autorization = :date_time_autorization,');
                        LQueryPedidoPagamentos.SQL.Add('flag = :flag, amount_paid = :amount_paid, updated_at = :updated_at');
                        LQueryPedidoPagamentos.SQL.Add('where id = : id');
                      end;

                      LQueryPedidoPagamentos.Close;
                      LQueryPedidoPagamentos.ParamByName('id').AsInteger                    := LidPedidoPAgamento;
                      LQueryPedidoPagamentos.ParamByName('order_id').AsInteger              := LIdPedido;
                      LQueryPedidoPagamentos.ParamByName('payment_id').AsString             := LJsonObjetoItemPedidoPagamento.GetValue<string>('paymentId','');
                      LQueryPedidoPagamentos.ParamByName('nsu').AsString                    := LJsonObjetoItemPedidoPagamento.GetValue<string>('nsu','');
                      LQueryPedidoPagamentos.ParamByName('autorization_code').AsString      := LJsonObjetoItemPedidoPagamento.GetValue<string>('autorizationCode','');
                      LQueryPedidoPagamentos.ParamByName('date_time_autorization').AsString := LJsonObjetoItemPedidoPagamento.GetValue<string>('dateTimeAutorization','');
                      LQueryPedidoPagamentos.ParamByName('flag').AsString                   := LJsonObjetoItemPedidoPagamento.GetValue<string>('flag','');
                      LQueryPedidoPagamentos.ParamByName('amount_paid').AsFloat             := LJsonObjetoItemPedidoPagamento.GetValue<Currency>('amountPaid',0);
                      LQueryPedidoPagamentos.ParamByName('updated_at').AsString             := TModelUtils.ISO8601StringToDateTimeString(LJsonObjetoItemPedidoPagamento.GetValue<string>('updatedAt',''));
                      LQueryPedidoPagamentos.ExecSQL;

                    end;
                  end;
                finally
                  FreeAndNil(LQueryPedidoItens);
                end;


              end;
            except on E: Exception do
              begin
                ModelConnection.Connection.Rollback;
                raise Exception.Create(e.Message);
              end;
            end;
            ModelConnection.Connection.Commit;
          finally
            FreeAndNil(LQuerySelectMax);
            FreeAndNil(LQueryPedido);
          end;

        end;

      end;

      Result := LPrimeiraDataEncontrada;

    finally
      LJsonResponse.Free;
    end;

  except on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;
end;

constructor TModelSincronizacaoPedido.Create;
begin

end;

destructor TModelSincronizacaoPedido.Destroy;
begin

  inherited;
end;

function TModelSincronizacaoPedido.EnviarParaServidor:Integer;
begin
  // No momento que eu estiver enviando para o servidor essas informações tenho
  // Que bloquear a leitura e gravação no banco de dados local
  // Para que não tenha algum tipo de erro

  // Seria interessante se o usuário estiver na tela de pagamento eu travar a
  // TThread de sincronização do pedido
  Result                  := 0;
  var LQueryPedido        := TFDQuery.Create(nil);
  LQueryPedido.Connection := ModelConnection.Connection;

  var LQueryPedidoItens        := TFDQuery.Create(nil);
  LQueryPedidoItens.Connection := ModelConnection.Connection;

  try
    LQueryPedido.Close;
    LQueryPedido.SQL.Clear;
    LQueryPedido.SQL.Add('select * from "order" o');
    LQueryPedido.SQL.Add('where o.sync = :sync and mesa <= :mesa');
    LQueryPedido.SQL.Add('and comanda <= :comanda');
    LQueryPedido.ParamByName('sync').AsInteger    := 0;
    LQueryPedido.ParamByName('mesa').AsInteger    := 0;
    LQueryPedido.ParamByName('comanda').AsInteger := 0;
    LQueryPedido.Open();

    if LQueryPedido.RecordCount <= 0 then
      Exit;

    LQueryPedidoItens.Close;
    LQueryPedidoItens.SQL.Clear;
    LQueryPedidoItens.SQL.Add('select * from order_itens oi');
    LQueryPedidoItens.SQL.Add('where oi.order_id = :id_order');

    var LJsonArrayPedido := TJSONArray.Create;
    try
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






        LQueryPedidoItens.Close;
        LQueryPedidoItens.ParamByName('id_order').AsInteger := LQueryPedido.FieldByName('id').AsInteger;
        LQueryPedidoItens.Open();

        var LJsonArrayPedidoItens := TJSONArray.Create;
        LQueryPedidoItens.First;
        while not LQueryPedidoItens.Eof do
        begin
          var LJsonObjetoPedidoItem := TJSONObject.Create;

          LJsonObjetoPedidoItem.AddPair('productId',LQueryPedidoItens.FieldByName('product_id').AsString);
          LJsonObjetoPedidoItem.AddPair('amount',LQueryPedidoItens.FieldByName('amount').AsString);
          LJsonObjetoPedidoItem.AddPair('discountValue',LQueryPedidoItens.FieldByName('discount_value').AsString);
          LJsonObjetoPedidoItem.AddPair('discountPercentage',LQueryPedidoItens.FieldByName('discount_percentage').AsFloat);
          LJsonObjetoPedidoItem.AddPair('observation',LQueryPedidoItens.FieldByName('observation').AsString);
          LJsonObjetoPedidoItem.AddPair('cfop',LQueryPedidoItens.FieldByName('cfop').AsString);
          LJsonObjetoPedidoItem.AddPair('origin',LQueryPedidoItens.FieldByName('origin').AsString);
          LJsonObjetoPedidoItem.AddPair('csosnCst',LQueryPedidoItens.FieldByName('csosn_cst').AsString);
          LJsonObjetoPedidoItem.AddPair('cstPis',LQueryPedidoItens.FieldByName('cst_pis').AsString);
          LJsonObjetoPedidoItem.AddPair('ppis',LQueryPedidoItens.FieldByName('ppis').AsFloat);
          LJsonObjetoPedidoItem.AddPair('vpis',LQueryPedidoItens.FieldByName('vpis').AsFloat);
          LJsonObjetoPedidoItem.AddPair('cstCofins',LQueryPedidoItens.FieldByName('cst_cofins').AsString);
          LJsonObjetoPedidoItem.AddPair('pcofins',LQueryPedidoItens.FieldByName('pcofins').AsFloat);
          LJsonObjetoPedidoItem.AddPair('vcofins',LQueryPedidoItens.FieldByName('vcofins').AsFloat);
          LJsonObjetoPedidoItem.AddPair('subtotal',LQueryPedidoItens.FieldByName('subtotal').AsFloat);
          LJsonObjetoPedidoItem.AddPair('total',LQueryPedidoItens.FieldByName('total').AsFloat);

          LJsonArrayPedidoItens.Add(LJsonObjetoPedidoItem);
          LQueryPedidoItens.Next;
        end;

        LJsonObjetoPedido.AddPair('order_items',LJsonArrayPedidoItens);

        // Pagamentos

        var LQueryPedidoPagamento        := TFDQuery.Create(nil);
        LQueryPedidoPagamento.Connection := ModelConnection.Connection;
        try

          LQueryPedidoPagamento.Close;
          LQueryPedidoPagamento.SQL.Clear;
          LQueryPedidoPagamento.SQL.Add('Select * from order_payment');
          LQueryPedidoPagamento.SQL.Add('where order_id = :order_id');
          LQueryPedidoPagamento.ParamByName('order_id').AsInteger := LQueryPedido.FieldByName('id').AsInteger;
          LQueryPedidoPagamento.Open();


          var LJsonArrayPedidoPagamento := TJSONArray.Create;
          LQueryPedidoPagamento.First;
          while not LQueryPedidoPagamento.Eof do
          begin
            var LJsonObjetoPedidoPagamento := TJSONObject.Create;

            LJsonObjetoPedidoPagamento.AddPair('orderId',LQueryPedidoPagamento.FieldByName('order_id').AsString);
            LJsonObjetoPedidoPagamento.AddPair('paymentId',LQueryPedidoPagamento.FieldByName('payment_id').AsString);
            LJsonObjetoPedidoPagamento.AddPair('nsu',LQueryPedidoPagamento.FieldByName('nsu').AsString);
            LJsonObjetoPedidoPagamento.AddPair('autorizationCode',LQueryPedidoPagamento.FieldByName('autorization_code').AsString);
            //LJsonObjetoPedidoPagamento.AddPair('dateTimeAutorization',LQueryPedidoPagamento.FieldByName('date_time_autorization').AsString);
            LJsonObjetoPedidoPagamento.AddPair('flag',LQueryPedidoPagamento.FieldByName('flag').AsString);
            LJsonObjetoPedidoPagamento.AddPair('amountPaid',LQueryPedidoPagamento.FieldByName('amount_paid').AsFloat);
            LJsonObjetoPedidoPagamento.AddPair('createdAt',LQueryPedidoPagamento.FieldByName('created_at').AsString);
            LJsonObjetoPedidoPagamento.AddPair('updatedAt',LQueryPedidoPagamento.FieldByName('updated_at').AsString);


            LJsonArrayPedidoPagamento.Add(LJsonObjetoPedidoPagamento);
            LQueryPedidoPagamento.Next;
          end;

          LJsonObjetoPedido.AddPair('orderPayments',LJsonArrayPedidoPagamento);

        finally
          FreeAndNil(LQueryPedidoPagamento);
        end;


        LJsonArrayPedido.Add(LJsonObjetoPedido);
        LQueryPedido.Next;
      end;


      var LResponsePedido: IResponse;
      var LRequestPedido:IRequest;
      try
        LRequestPedido := TRequest.New
          .BaseURL(TModelStaticCredencial.GetInstance.BASEURL)
          .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
          .Resource('order/large-volume')
          .AddBody(LJsonArrayPedido)
          .Accept('application/json');
          LResponsePedido := LRequestPedido.Post;

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
          else if LResponsePedido.StatusCode <> 201  then
          begin
            // Tratando o erro
            raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
          end;

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

      finally
        FreeAndNil(LQueryUpdate);
      end;

    finally

    end;
    Result := LQueryPedido.RecordCount;
  finally
    FreeAndNil(LQueryPedido);
  end;
end;
procedure TModelSincronizacaoPedido.InsertUpdatePedidoItens(
  const AJsonObject: TJSONObject);
begin

end;

//            LDaoPedido.Dados.EmpresaId          := LJsonObjetoItemPedido.GetValue<string>('companyId','');
//            LDaoPedido.Dados.UsuarioId          := LJsonObjetoItemPedido.GetValue<string>('userId','');
//            LDaoPedido.Dados.ClienteId          := LJsonObjetoItemPedido.GetValue<string>('customerId','');
//            LDaoPedido.Dados.TypeOrder          := LJsonObjetoItemPedido.GetValue<Integer>('typeOrder',0);
//            LDaoPedido.Dados.CpfCnpj            := LJsonObjetoItemPedido.GetValue<string>('cpfCnpj','');
//            LDaoPedido.Dados.DescontoValor      := LJsonObjetoItemPedido.GetValue<Currency>('discount',0);
//            LDaoPedido.Dados.DescontoPorcentage := LJsonObjetoItemPedido.GetValue<Currency>('discount',0);
//            LDaoPedido.Dados.Troco              := LJsonObjetoItemPedido.GetValue<Currency>('troco',0);
//            LDaoPedido.Dados.Subtotal           := LJsonObjetoItemPedido.GetValue<Currency>('subtotal',0);
//            LDaoPedido.Dados.Total              := LJsonObjetoItemPedido.GetValue<Currency>('total',0);
//            LDaoPedido.Dados.Comanda            := LJsonObjetoItemPedido.GetValue<Integer>('comanda',0);
//            LDaoPedido.Dados.Mesa               := LJsonObjetoItemPedido.GetValue<Integer>('mesa',0);
//            if LJsonObjetoItemPedido.GetValue<string>('status','').ToUpper.Equals('ABERTO') then
//              LDaoPedido.Dados.Status           := stAberto;
//
//
//            LDaoPedido.Gravar;

end.
