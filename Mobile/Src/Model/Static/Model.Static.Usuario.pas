unit Model.Static.Usuario;

interface
  uses
  System.JSON,
  System.SysUtils,
  System.Classes,
  RESTRequest4D,
  Model.Static.Credencial;
type
  TModelStaticUsuario = class
  private
    class var FInstance: TModelStaticUsuario;
    class var FJsonArrayusuario:TJSONArray;
    class function GetInstance: TModelStaticUsuario; static;
  public
    class Procedure BuscarUsuariosPertencentesAEmpresa;
    class function JSONArrayUsuarios:TJSONArray;
  end;

implementation

{ TModelStaticUsuario }


class procedure TModelStaticUsuario.BuscarUsuariosPertencentesAEmpresa;
begin
  TThread.CreateAnonymousThread(
  procedure
  begin
    var LResponse: IResponse;
    var LRequest:IRequest;
    try
      LRequest := TRequest.New
        .BaseURL(TModelStaticCredencial.GetInstance.BASEURL)
        .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
        .Resource('user/company')
        .Accept('application/json');
        LResponse := LRequest.Get;

      var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
      try
        // Verificando o status code

        if LResponse.StatusCode = 401 then
        begin
          // Quando cair aqui ele vai mostrar uma tela de erro
          // E quando fechar essa tela de erro o sistema vai executar
          // o código na procedure "AposFecharATelaDeErro"
          Exit;
        end;

        if Assigned(FJsonArrayusuario) then
          FreeAndNil(FJsonArrayusuario);
        var LJsonArrayUsuario := LJsonResponse.GetValue<TJSONArray>('data',nil);
        if Assigned(LJsonArrayUsuario) then
        begin
          FJsonArrayusuario := TJSONObject.ParseJSONValue(LJsonArrayUsuario.ToJSON()) as TJSONArray;
        end;

      finally
        LJsonResponse.Free;
      end;

    except on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  end).Start;
end;

class function TModelStaticUsuario.GetInstance: TModelStaticUsuario;
begin
  Result := FInstance;
end;

class function TModelStaticUsuario.JSONArrayUsuarios: TJSONArray;
begin
  Result := FJsonArrayusuario;
end;

initialization

TModelStaticUsuario.FInstance := TModelStaticUsuario.Create;

finalization

TModelStaticUsuario.FInstance.Free;

end.
