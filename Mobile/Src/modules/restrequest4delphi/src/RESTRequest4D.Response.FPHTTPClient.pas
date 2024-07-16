unit RESTRequest4D.Response.FPHTTPClient;

{$IFDEF FPC}
  {$mode delphi}
{$ENDIF}

interface

uses Classes, SysUtils, RESTRequest4D.Response.Contract, FPHTTPClient, openssl, fpjson, jsonparser, ZStream;

type
  TResponseFPHTTPClient = class(TInterfacedObject, IResponse)
  private
    FJSONValue: TJSONData;
    FFPHTTPClient: TFPHTTPClient;
    FStreamResult: TStringStream;
    FContent: TStringStream;
    function Content: string;
    function ContentLength: Cardinal;
    function ContentType: string;
    function ContentEncoding: string;
    function ContentStream: TStream;
    function StatusCode: Integer;
    function StatusText: string;
    function RawBytes: TBytes;
    function JSONValue: TJSONData;
    function Headers: TStrings;
    function GetCookie(const ACookieName: string): string;
    function OnDeflate(const AStream: TStream): string;
  public
    constructor Create(const AFPHTTPClient: TFPHTTPClient);
    destructor Destroy; override;
  end;

implementation

function TResponseFPHTTPClient.Content: string;
begin
  if FFPHTTPClient.ResponseHeaders.Values['Content-Encoding'].ToLower.Contains('deflate') then
    Exit(OnDeflate(FStreamResult));
  Result := FStreamResult.DataString;
end;

function TResponseFPHTTPClient.ContentLength: Cardinal;
begin
  Result := StrToInt64Def(FFPHTTPClient.GetHeader(Headers, 'Content-Length'), 0);
end;

function TResponseFPHTTPClient.ContentType: string;
begin
  Result := FFPHTTPClient.GetHeader(Headers, 'Content-Type');
end;

function TResponseFPHTTPClient.ContentEncoding: string;
begin
  Result := FFPHTTPClient.GetHeader(Headers, 'Content-Encoding');
end;

function TResponseFPHTTPClient.ContentStream: TStream;
var
  LStream: TStringStream;
begin
  FStreamResult.Position := 0;
  if FFPHTTPClient.ResponseHeaders.Values['Content-Encoding'].ToLower.Contains('deflate') then
  begin
    LStream := TStringStream.Create(OnDeflate(FStreamResult));
    try
      FStreamResult.Clear;
      FStreamResult.CopyFrom(LStream, LStream.Size);
      FStreamResult.Position := 0;
    finally
      LStream.Free;
    end;
  end;
  Result := FStreamResult;
end;

function TResponseFPHTTPClient.StatusCode: Integer;
begin
  Result := FFPHTTPClient.ResponseStatusCode;
end;

function TResponseFPHTTPClient.StatusText: string;
begin
  Result := FFPHTTPClient.ResponseStatusText;
end;

function TResponseFPHTTPClient.RawBytes: TBytes;
begin
  Result := FStreamResult.Bytes;
end;

function TResponseFPHTTPClient.JSONValue: TJSONData;
var
  LContent: string;
  LJSONParser: TJSONParser;
begin
  if not(Assigned(FJSONValue)) then
  begin
    LContent := Content.Trim;
    LJSONParser := TJSONParser.Create(LContent, False);
    try
      if LContent.StartsWith('{') then
        FJSONValue := LJSONParser.Parse as TJSONObject
      else if LContent.StartsWith('[') then
        FJSONValue := LJSONParser.Parse as TJSONArray
      else
        raise Exception.Create('The return content is not a valid JSON value.');
    finally
      LJSONParser.Free;
    end;
  end;
  Result := FJSONValue;
end;

function TResponseFPHTTPClient.OnDeflate(const AStream: TStream): string;
var
  LStream: TStringStream;
  LDecompressor: TDecompressionStream;
begin
  AStream.Position := 0;
  LDecompressor := TDecompressionStream.Create(AStream);
  try
    LStream := TStringStream.Create();
    try
      LStream.CopyFrom(LDecompressor, AStream.Size);
      Result := LStream.DataString;
    finally
      LStream.Free;
    end;
  finally
    LDecompressor.Free;
  end;
end;

function TResponseFPHTTPClient.Headers: TStrings;
begin
  Result := FFPHTTPClient.ResponseHeaders;
end;

constructor TResponseFPHTTPClient.Create(const AFPHTTPClient: TFPHTTPClient);
begin
  FFPHTTPClient := AFPHTTPClient;
  FStreamResult := TStringStream.Create;
end;

destructor TResponseFPHTTPClient.Destroy;
begin
  FreeAndNil(FStreamResult);
  if Assigned(FJSONValue) then
    FJSONValue.Free;
  inherited Destroy;
end;

function TResponseFPHTTPClient.GetCookie(const ACookieName: string): string;
begin
  Result := FFPHTTPClient.Cookies.Values[ACookieName];
end;

end.
