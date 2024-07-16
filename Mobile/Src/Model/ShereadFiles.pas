unit ShereadFiles;

interface
  uses
{$IFDEF Android}
  AndroidApi.Jni.JavaTypes,
  AndroidApi.Jni.App,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers,
  Androidapi.JNI.Os,
  Androidapi.JNI.Net,
  Androidapi.JNIBridge,
  FMX.Helpers.Android,
{$ENDIF}
{$IFDEF IOS}
  iOSapi.UIKit,
  iOSapi.Foundation,
  FMX.Platform.iOS,
  FMX.Platform,
  FMX.Helpers.iOS,
{$ENDIF}
  System.Classes,
  System.Messaging,
  System.SysUtils;
  Type
  TShereadFiles = class
  private
    FOnShead:TProc<TMemoryStream,String,String>;
    {$IFDEF Android}
    function GetFileExtensionFromIntent(intent: JIntent): string;
    var FMessageSubscriptionID: Integer;
    procedure HandleActivityMessage(const Sender: TObject; const M: TMessage);
    function OnActivityResult(RequestCode, ResultCode: Integer; Data: JIntent): Boolean;
    {$ENDIF}
  published
  property OnShead:TProc<TMemoryStream,String,String> read FOnShead write FOnShead;
  {$IFNDEF MSWINDOWS}
  procedure SheadFiles;
  {$ENDIF}
  public
  end;
implementation

{ TShereadFiles }
{$IFDEF Android}
procedure TShereadFiles.HandleActivityMessage(const Sender: TObject;
  const M: TMessage);
begin
 if M is TMessageResultNotification then
    OnActivityResult(TMessageResultNotification(M).RequestCode, TMessageResultNotification(M).ResultCode,
      TMessageResultNotification(M).Value)
end;
{$ENDIF}
{$IFDEF Android}
function TShereadFiles.OnActivityResult(RequestCode, ResultCode: Integer;
  Data: JIntent): Boolean;
begin
  TMessageManager.DefaultManager.Unsubscribe(TMessageResultNotification, FMessageSubscriptionID);
  FMessageSubscriptionID := 0;

  if Assigned(Data) then
  begin
//  var Intent: JIntent;
//  var Uri: Jnet_Uri;
//
//    Intent := TJIntent.Create;
//    Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
//
//    // Cria um Uri para o arquivo
//    Uri := TJnet_Uri.JavaClass.parse(StringToJString('content://com.adobe.reader.fileprovider/downloads/01-20234996002330.pdf'));
//    Intent.setDataAndType(Uri, StringToJString('application/*'));
//
//    // Inicia a Intent
//    SharedActivity.startActivity(Intent);


    var LExtension := GetFileExtensionFromIntent(Data);
    var LNome := JStringToString(Data.getDataString);
    var resolver := SharedActivity.getContentResolver;
    var inputStream:JInputStream := resolver.openInputStream(data.getData);
    if Assigned(inputStream) then
    begin
      var buffer := TJavaArray<Byte>.Create(inputStream.available);
      try
        inputStream.read(buffer);
        var LStream := TMemoryStream.Create;
        try
          LStream.WriteBuffer(buffer.Data^, buffer.Length);
          LStream.Position := 0;
          if Assigned(LStream) then
            if Assigned(FOnShead) then
              FOnShead(LStream,LExtension,LNome);
        except
          LStream.Free;
          raise;
        end;
      finally
        buffer.Free;
      end;
    end;
  end;
end;
{$ENDIF}
{$IFDEF IOS}
procedure TShereadFiles.SheadFiles;
begin

end;

{$ENDIF}
{$IFDEF Android}
procedure TShereadFiles.SheadFiles;
var
  Intent: JIntent;
begin
 FMessageSubscriptionID := TMessageManager.DefaultManager.SubscribeToMessage(TMessageResultNotification,
    HandleActivityMessage);
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_GET_CONTENT);
  Intent.setType(StringToJString ('*/*'));
  Intent.addCategory(TJIntent.JavaClass.CATEGORY_OPENABLE);
  SharedActivity.startActivityForResult((TJIntent.JavaClass.createChooser(Intent,StrToJCharSequence(''))),0);
end;
{$ENDIF}
{$IFDEF Android}
function TShereadFiles.GetFileExtensionFromIntent(intent: JIntent): string;
var
  mimeType: JString;
  extension: string;
begin
  Result := '';

  var uri := intent.getData;

  if Assigned(uri) then
  begin
    mimeType := SharedActivity.getContentResolver.getType(uri);

    if Assigned(mimeType) then
    begin
      extension := JStringToString(mimeType);
//      if Pos('/', extension) > 0 then
//        extension := Copy(extension, Pos('/', extension) + 1, Length(extension));
//
//      Result := '.' + extension;
      Result := extension;
    end;
  end;
end;
{$ENDIF}
end.
