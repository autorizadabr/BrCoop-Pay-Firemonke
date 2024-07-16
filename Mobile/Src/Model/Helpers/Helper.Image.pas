unit Helper.Image;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Net.HttpClientComponent,
  System.NetEncoding,
  FMX.Objects;
type
  TImageHelper = class helper for TImage
    procedure LoadBase64(const ABase64:string);
    procedure LoadFromURLAsync(const AURL:String);
    procedure LoadFromURL(const AURL:String);
function ToBase64:string;
  end;
implementation

{ TImageHelper }

procedure TImageHelper.LoadBase64(const ABase64: string);
var
  lInput, lOutput : TStringStream;
begin
  try
    if ABase64.IsEmpty then
      Exit;
    var LBase64 := ABase64.Replace('data:image/jpeg;base64,','',[rfReplaceAll]);
    lInput  := TStringStream.Create(LBase64);
    lOutput := TStringStream.Create;
    try
      lInput.Position := 0;
      TNetEncoding.Base64String.Decode(lInput, lOutput);
      lOutput.Position := 0;
      if Assigned(lOutput) then
        Self.Bitmap.LoadFromStream(lOutput);

    finally
      lInput.Free;
      lOutput.Free;
    end;
  except on E: Exception do
    begin
      Self.Bitmap := nil;
    end;
  end;
end;


procedure TImageHelper.LoadFromURL(const AURL: String);
var
  LHttp:TNetHTTpClient;
  LRequest: TNetHTTPRequest;
  LStringStream:TStringStream;
begin
  if AURL = EmptyStr then Exit;

  LHttp := TNetHTTpClient.Create(nil);
  LRequest := TNetHTTPRequest.Create(nil);
  try
    try
      LRequest.Client := LHttp;
      LRequest.Asynchronous := False;
      LRequest.MethodString := 'GET';
      LRequest.URL := AURL;
      LRequest.CustomHeaders['Pragma'] := 'no-cache';
      LStringStream := TStringStream.Create();
      try
        LStringStream.LoadFromStream(LRequest.Execute().ContentStream);
        LStringStream.Position := 0;
        Self.Bitmap.LoadFromStream(LStringStream);
      finally
        FreeAndNil(LStringStream);
      end;
    except on E: Exception do
      Self.Bitmap := nil;
    end;
  finally
    FreeAndNil(LHttp);
    FreeAndNil(LRequest);
  end;
end;

procedure TImageHelper.LoadFromURLAsync(const AURL: String);
var
  LHttp:TNetHTTpClient;
  LRequest: TNetHTTPRequest;
  LStringStream:TStringStream;
begin
  if AURL = EmptyStr then Exit;

  Self.Bitmap   := nil;
  TThread.CreateAnonymousThread(
  procedure
  begin
    LHttp := TNetHTTpClient.Create(nil);
    LRequest := TNetHTTPRequest.Create(nil);
    try
      try
        LRequest.Client := LHttp;
        LRequest.Asynchronous := False;
        LRequest.MethodString := 'GET';
        LRequest.URL := AURL;
        LRequest.CustomHeaders['Pragma'] := 'no-cache';
        LStringStream := TStringStream.Create();
        LStringStream.LoadFromStream(LRequest.Execute().ContentStream);
        try
          TThread.Synchronize(nil,
          procedure
          begin
            LStringStream.Position := 0;
            Self.Bitmap.LoadFromStream(LStringStream);
          end);
        finally
          FreeAndNil(LStringStream);
        end;
      except on E: Exception do
        begin
          Self.Bitmap   := nil;
        end;
      end;
    finally
      FreeAndNil(LHttp);
      FreeAndNil(LRequest);
    end;
  end).Start;
end;

function TImageHelper.ToBase64: string;
var
  lInput, lOutput : TStringStream;
begin
  lInput  := TStringStream.Create;
  lOutput := TStringStream.Create;
  try
    Self.Bitmap.SaveToStream(lInput);
    lInput.Position := 0;
    TNetEncoding.Base64.Encode(lInput, lOutput);
    lOutput.Position := 0;
    Result := lOutput.DataString;
  finally
    lInput.Free;
    lOutput.Free;
  end;
end;

end.

