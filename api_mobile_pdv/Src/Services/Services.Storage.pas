unit Services.Storage;

interface
  uses
  System.JSON,
  System.Classes,
  System.SysUtils,
  IdHTTP,
  IdMultipartFormData,
  IdSSLOpenSSL,
  SYstem.Generics.Collections,
  Generator.Id;

type
  TServicesStorage = class
  private
  public
    function SaveImage(const AStrem: TMemoryStream): string;
  end;

implementation

{ TServicesStorage }

function TServicesStorage.SaveImage(const AStrem: TMemoryStream): string;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  FormData: TIdMultiPartFormDataStream;
  Response: string;
begin
  Result   := '';
  if not Assigned(AStrem) then
    Exit;

  if AStrem.Size <= 0 then
    Exit;

  var LDirectory := ExtractFilePath(ParamStr(0))+'Upload\Temp\';
  var LFileName:string;
  if not DirectoryExists(LDirectory) then
    ForceDirectories(LDirectory);

  HTTP     := TIdHTTP.Create(nil);
  SSL      := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FormData := TIdMultiPartFormDataStream.Create;
  try
    HTTP.IOHandler        := SSL;
    SSL.SSLOptions.Method := sslvTLSv1_2;

    LFileName := LDirectory+TGeneratorId.GeneratorId+'.png';

    AStrem.SaveToFile(LFileName);
    FormData.AddFile('images[]', LFileName, 'image/png',);
    HTTP.Request.ContentType := 'multipart/form-data';
    Response                 := HTTP.Post('https://s3.autorizadabr.com.br/api/s3/image/upload', FormData);

    var LJsonResponse := TJSONObject.ParseJSONValue(Response) as TJSONObject;
    try
      if Assigned(LJsonResponse) then
      begin
        var LJsonArray := LJsonResponse.GetValue<TJSONArray>('urls',TJSONArray.Create);
        if LJsonArray.Count > 0 then
        begin
          Result := LJsonArray.Items[0].Value;
        end;
      end;
    finally
      if Assigned(LJsonResponse) then
        FreeAndNil(LJsonResponse);
    end;
  finally
    FormData.Free;
    SSL.Free;
    HTTP.Free;
    if not LFileName.IsEmpty then
      DeleteFile(LFileName);
  end;
end;

end.
