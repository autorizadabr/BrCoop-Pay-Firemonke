unit Service.Pedido.Pagamento;

interface

uses Service.Base, RESTRequest4D, System.Classes, System.JSON, System.SysUtils;

type
  TServicePedidoPagamento = class(TServiceBase)
  private
  public
    procedure DeleteItem(const AId: string);
  end;

implementation

{ TServicePedidoPagamento }

procedure TServicePedidoPagamento.DeleteItem(const AId: string);
begin
  try
    var LResponse: IResponse;
    LResponse := TRequest.New.BaseURL(BaseURL)
      .AddHeader('Authorization','Bearer '+Token,[poDoNotEncode])
      .Resource('order-payment/'+AId)
      .Accept('application/json')
      .Delete;
    var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
    try
      // Verificando o status code

      if LResponse.StatusCode = 401 then
      begin
        raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));

      end
      else if LResponse.StatusCode <> 200 then
      begin
        // Tratando o erro
        raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
        Exit; // Se der erro ele sai fora e não abre a próxima tela
      end;

    finally
      LJsonResponse.Free;
    end;
  except on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;
end;

end.
