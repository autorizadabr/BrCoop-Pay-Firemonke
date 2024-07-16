unit Model.Connection.Net;
interface
uses
  System.net.HttpClient,
  System.Classes,
  System.Net.HttpClientComponent,
  System.SysUtils;
  type
  TModelConnectionNet = class
  private
  class var
    FHttp: TNetHTTpClient;
    FRequest:TNetHTTPRequest;
    class function GetWindows:Boolean;
  public
    class function CheckInternet:Boolean;
  end;
implementation
  {$IFDEF ANDROID}
  uses
  Network;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  uses
  Winapi.Windows,
  WinInet;
  {$ENDIF}

{ TModelConnectionNet }
class function TModelConnectionNet.CheckInternet: Boolean;
begin
  {$IFDEF ANDROID}
    Result := IsConnected;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
    Result := GetWindows;
  {$ELSE}
    Result := True;
  {$ENDIF}

end;

class function TModelConnectionNet.GetWindows: Boolean;
begin
{$IFDEF MSWINDOWS}
  var Internet : DWORD;
//  try
//    FRequest.Client := FHttp;
//    FRequest.Asynchronous := False;
//    FRequest.MethodString := 'GET';
//    FRequest.URL := 'https://www.google.com.br';
//    FRequest.CustomHeaders['Pragma'] := 'no-cache';
//
//    Result := FRequest.Execute().StatusCode = 200;
//  except on E: Exception do
//    Result := False;
//  end;
  Result :=  InternetGetConnectedState(@Internet,0);
{$ELSE}
  Result := True;
{$ENDIF}
end;

initialization
  TModelConnectionNet.FHttp := TNetHTTpClient.Create(nil);
  TModelConnectionNet.FRequest := TNetHTTPRequest.Create(nil);
finalization
  FreeAndNil(TModelConnectionNet.FHttp);
  FreeAndNil(TModelConnectionNet.FRequest);
end.

