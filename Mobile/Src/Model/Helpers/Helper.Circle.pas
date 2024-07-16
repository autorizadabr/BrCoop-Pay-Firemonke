unit Helper.Circle;

interface
uses
  System.SysUtils,
  System.Classes,
  FMX.Graphics,
  System.Net.HttpClientComponent,
  System.NetEncoding,
  FMX.Objects;
type
  TCircleHelper = class helper for TCircle
  public
    procedure LoadBase64(const ABase64: string;ABitmap:TBitmap);
    procedure LoadFromURLAsync(const AURL:String);
    procedure LoadFromURL(const AURL:String);
    function ToBase64:string;
  end;
implementation

{ TCircleHelper }

procedure TCircleHelper.LoadBase64(const ABase64: string; ABitmap:TBitmap);
var
  lInput, lOutput : TStringStream;
begin
  try
    Self.Fill.Kind := TBrushKind.Bitmap;
    Self.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
    if ABase64.IsEmpty then
    begin
      Self.Fill.Bitmap.Bitmap := ABitmap;
      Exit;
    end;
    var LBase64 := ABase64.Replace('data:image/jpeg;base64,','',[rfReplaceAll]);
    lInput  := TStringStream.Create(LBase64);
    lOutput := TStringStream.Create;
    try
      lInput.Position := 0;
      TNetEncoding.Base64String.Decode(lInput, lOutput);
      lOutput.Position := 0;
      if Assigned(lOutput) then
        Self.Fill.Bitmap.Bitmap.LoadFromStream(lOutput)
      else
        Self.Fill.Bitmap.Bitmap := ABitmap;
    finally
      lInput.Free;
      lOutput.Free;
    end;
  except on E: Exception do
    begin
      Self.Fill.Bitmap.Bitmap := ABitmap;
    end;
  end;
end;

procedure TCircleHelper.LoadFromURL(const AURL: String);
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
        Self.Fill.Bitmap.Bitmap.LoadFromStream(LStringStream);
      finally
        FreeAndNil(LStringStream);
      end;
    except on E: Exception do
      Self.Fill.Bitmap.Bitmap := nil;
    end;
  finally
    FreeAndNil(LHttp);
    FreeAndNil(LRequest);
  end;
end;

procedure TCircleHelper.LoadFromURLAsync(const AURL: String);
var
  LHttp:TNetHTTpClient;
  LRequest: TNetHTTPRequest;
  LStringStream:TStringStream;
begin
  Self.Fill.Kind            := TBrushKind.Solid;
  if AURL = EmptyStr then
    Exit;
  if not AURL.ToLower.Contains('http') then
    Exit;

  Self.Fill.Kind            := TBrushKind.Bitmap;
  Self.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
  Self.Fill.Bitmap.Bitmap   := nil;
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
            Self.Fill.Bitmap.Bitmap.LoadFromStream(LStringStream);
          end);
        finally
          FreeAndNil(LStringStream);
        end;
      except on E: Exception do
        begin
          Self.Fill.Kind            := TBrushKind.Solid;
          Self.Fill.Bitmap.Bitmap   := nil;
        end;
      end;
    finally
      FreeAndNil(LHttp);
      FreeAndNil(LRequest);
    end;
  end).Start;
end;

function TCircleHelper.ToBase64: string;
begin
  var lInput  := TStringStream.Create;
  var lOutput := TStringStream.Create;
  try
    Self.Fill.Bitmap.Bitmap.SaveToStream(lInput);
    lInput.Position := 0;
    lInput.Position := 0;
    TBase64Encoding.Base64.Encode(lInput, lOutput);
    lInput.Position := 0;
    lOutput.Position := 0;
    Result := lOutput.DataString;
  finally
    lInput.Free;
    lOutput.Free;
  end;
end;

end.

