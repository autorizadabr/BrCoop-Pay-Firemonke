unit Services.CNPJ;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PGDef, FireDAC.Phys.PG,
  FireDAC.Comp.UI,
  FireDAC.DApt,
  Services.Base,
  System.SysUtils,
  Horse.HandleException,
  Horse,
  Horse.Commons,
  RESTRequest4D,
  System.Generics.Collections,
  DataSet.Serialize,
  System.JSON, Entities.CNPJ, Constantes;

type
  TServicesCNPJ = class(TServicesBase<TEntitiesCNPJ>)
  private
  public
    function SelectByCNPJ(const ACNPJ: string): TJSONObject;
  end;

implementation

{ TServicesCNPJ }


function TServicesCNPJ.SelectByCNPJ(const ACNPJ: string): TJSONObject;
var
  LResponse: IResponse;
begin

  // Toda vez que consultar a API para validar um CNPJ eu tenho que criar a
  // Cidade e o estado


  if ACNPJ.Trim.Length <> 14 then
    raise Exception.Create('CNPJ inválido o tamnho dele é diferente de 14 caracteres!');


  LResponse := TRequest.New.BaseURL('https://api.cnpja.com/office/'+ACNPJ.Trim)
    .AddHeader('Authorization', KEY_API_CNPJ)
    .Accept('application/json')
    .Get;
  var LJsonResponse := TJSONObject.Create;
  var LJsonCNPJaResponse := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONObject;
  try

    if LResponse.StatusCode <> 200 then
    begin
      var LMesege:string := LJsonCNPJaResponse.GetValue<string>('message','');

      if LMesege.Equals('request validation failed') then
      begin
        LMesege := 'CNPJ inválido, verifique os dados informados!';
      end;
      raise EHorseException.New.Status(THTTPStatus(LResponse.StatusCode)).Detail(Self.ClassName).Error(LMesege);
    end;

    var LCodigoIbgeMunicipio := LJsonCNPJaResponse.GetValue<TJSONObject>('address',TJsonObject.Create).GetValue<string>('municipality','');
    LJsonResponse.AddPair('name',LJsonCNPJaResponse.GetValue<TJSONObject>('company',TJsonObject.Create).GetValue<string>('name',''));
    LJsonResponse.AddPair('street',LJsonCNPJaResponse.GetValue<TJSONObject>('address',TJsonObject.Create).GetValue<string>('street',''));
    LJsonResponse.AddPair('number',LJsonCNPJaResponse.GetValue<TJSONObject>('address',TJsonObject.Create).GetValue<string>('number',''));
    LJsonResponse.AddPair('district',LJsonCNPJaResponse.GetValue<TJSONObject>('address',TJsonObject.Create).GetValue<string>('district',''));
    LJsonResponse.AddPair('city',LJsonCNPJaResponse.GetValue<TJSONObject>('address',TJsonObject.Create).GetValue<string>('city',''));
    LJsonResponse.AddPair('state',LJsonCNPJaResponse.GetValue<TJSONObject>('address',TJsonObject.Create).GetValue<string>('state',''));
    LJsonResponse.AddPair('zip',LJsonCNPJaResponse.GetValue<TJSONObject>('address',TJsonObject.Create).GetValue<string>('zip',''));
    LJsonResponse.AddPair('cityId',LCodigoIbgeMunicipio);
    var LEmail:string     := EmptyStr;
    var LArrayJsonAddress := LJsonCNPJaResponse.GetValue<TJSONArray>('emails',nil);
    if Assigned(LArrayJsonAddress) then
    begin
      if LArrayJsonAddress.Count > 0 then
      begin
        LEmail := LArrayJsonAddress.Items[0].GetValue<string>('address','');
      end;
    end;
    LJsonResponse.AddPair('email',LEmail);
    var LNewCity:Boolean := False;

    // Verificar se tem essa cidade e gravar cidade e estado


    //https://servicodados.ibge.gov.br/api/v1/localidades/municipios/4105508


    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select id from cities');
    Query.SQL.Add('where id = :id');
    Query.ParamByName('id').AsInteger := StrToIntDef(LCodigoIbgeMunicipio,0);
    Query.Open();

    if Query.RecordCount <= 0 then
    begin

      LResponse := TRequest.New.BaseURL('https://servicodados.ibge.gov.br/api/v1/')
        .Resource('localidades/municipios/'+LCodigoIbgeMunicipio.Trim)
        .Accept('application/json')
        .Get;

      if LResponse.StatusCode <> 200 then
      begin
        raise EHorseException.New
                             .Status(THTTPStatus(LResponse.StatusCode))
                             .Detail(Self.ClassName)
                             .Error('Erro no momento de buscar informações do múnicipio!');
      end;

      var LJsonResponseMunicipio := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONObject;
      try
        var LNameCity := LJsonResponseMunicipio.GetValue<string>('nome','');
        var LRegiao   := LJsonResponseMunicipio.GetValue<TJSONObject>('microrregiao');
        if Assigned(LRegiao) then
        begin
          var LRegiaoMeso := LRegiao.GetValue<TJSONObject>('mesorregiao');
          if Assigned(LRegiaoMeso) then
          begin
            var LUF := LRegiaoMeso.GetValue<TJSONObject>('UF');
            var LIdUF := LUF.GetValue<Integer>('id',0);

            Query.Close;
            Query.SQL.Clear;
            Query.SQL.Add('select id from states');
            Query.SQL.Add('where id = :id');
            Query.ParamByName('id').AsInteger := LIdUF;
            Query.Open();

            Connection.StartTransaction;
            try
              if Query.RecordCount <= 0 then
              begin
                Query.Close;
                Query.SQL.Clear;
                Query.SQL.Add('INSERT INTO public.states');
                Query.SQL.Add('      ( id,"name", uf)');
                Query.SQL.Add('VALUES(:id, :name, :uf )');
                Query.ParamByName('id').AsInteger  := LIdUF;
                Query.ParamByName('name').AsString := LUF.GetValue<string>('nome','');
                Query.ParamByName('uf').AsString   := LUF.GetValue<string>('sigla','');;
                Query.ExecSQL();
              end;

              Query.Close;
              Query.SQL.Clear;
              Query.SQL.Add('INSERT INTO public.cities');
              Query.SQL.Add('      ( id,"name", state_id)');
              Query.SQL.Add('VALUES(:id, :name, :state_id )');
              Query.ParamByName('id').AsInteger       := StrToIntDef(LCodigoIbgeMunicipio,0);
              Query.ParamByName('name').AsString      := LNameCity;
              Query.ParamByName('state_id').AsInteger := LIdUF;
              Query.ExecSQL();
            except on E: Exception do
              begin
                Connection.Rollback;
                raise EHorseException.New
                                     .Status(THTTPStatus.InternalServerError)
                                     .Detail(Self.ClassName)
                                     .Error('Erro no momento de gravar uma nova cidade!');
              end;
            end;
            Connection.Commit;
            LNewCity := True;
          end;
        end;

      finally
        FreeAndNil(LJsonResponseMunicipio);
      end;

    end;

    LJsonResponse.AddPair('newCity',LNewCity);

  finally
    LJsonCNPJaResponse.Free;
  end;

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(0);
  FServicesResponsePagination.SetData(LJsonResponse);
  Result := FServicesResponsePagination.Content;
end;


end.
