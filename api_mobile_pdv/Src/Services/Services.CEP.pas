unit Services.CEP;

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
  System.JSON, Entities.CEP, Constantes;

type
  TServicesCEP = class(TServicesBase<TEntitiesCEP>)
  private
  public
    function SelectByCEP(const ACEP: string): TJSONObject;
  end;

implementation

{ TServicesCEP }


function TServicesCEP.SelectByCEP(const ACEP: string): TJSONObject;
var
  LResponse: IResponse;
begin

  // Toda vez que consultar a API para validar um CNPJ eu tenho que criar a
  // Cidade e o estado


  if ACEP.Trim.Length <> 8 then
    raise Exception.Create('CEP inválido o tamnho dele é diferente de 8 caracteres!');


  LResponse := TRequest.New.BaseURL('https://viacep.com.br/ws/'+ACEP.Trim+'/json/')
    .Accept('application/json')
    .Get;
  var LJsonResponse := TJSONObject.Create;
  var LJsonViaCepResponse := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONObject;
  try

    if LResponse.StatusCode <> 200 then
    begin
      var LMesege:string := LJsonViaCepResponse.GetValue<string>('message','');

      raise EHorseException.New.Status(THTTPStatus(LResponse.StatusCode)).Detail(Self.ClassName).Error(LMesege);
    end;

    LJsonResponse.AddPair('cep',LJsonViaCepResponse.GetValue<string>('cep',''));
    LJsonResponse.AddPair('logradouro',LJsonViaCepResponse.GetValue<string>('logradouro',''));
    LJsonResponse.AddPair('complemento',LJsonViaCepResponse.GetValue<string>('bairro',''));
    LJsonResponse.AddPair('bairro',LJsonViaCepResponse.GetValue<string>('bairro',''));
    LJsonResponse.AddPair('localidade',LJsonViaCepResponse.GetValue<string>('localidade',''));
    LJsonResponse.AddPair('uf',LJsonViaCepResponse.GetValue<string>('uf',''));
    LJsonResponse.AddPair('ibge',LJsonViaCepResponse.GetValue<string>('ibge',''));
    LJsonResponse.AddPair('gia',LJsonViaCepResponse.GetValue<string>('gia',''));
    LJsonResponse.AddPair('ddd',LJsonViaCepResponse.GetValue<string>('ddd',''));
    LJsonResponse.AddPair('siafi',LJsonViaCepResponse.GetValue<string>('siafi',''));

    var LCodigoIbgeMunicipio := LJsonViaCepResponse.GetValue<string>('ibge','');
    var LNewCity:Boolean     := False;
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
    LJsonViaCepResponse.Free;
  end;

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(0);
  FServicesResponsePagination.SetData(LJsonResponse);
  Result := FServicesResponsePagination.Content;
end;


end.
