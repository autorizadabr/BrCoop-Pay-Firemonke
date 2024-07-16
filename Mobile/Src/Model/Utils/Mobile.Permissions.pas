unit Mobile.Permissions;

interface

uses
  {$IFDEF ANDROID}Androidapi.Helpers, Androidapi.JNI.JavaTypes, Androidapi.JNI.Os, {$ENDIF}
  System.Types, System.Permissions, FMX.DialogService,System.SysUtils,
  FMX.MediaLibrary.Actions;

type
  TMobilePermissions = class
  private
    Camera: string;
    ReadStorage: string;
    WriteStorage: string;
    AllPermited: Boolean;
    procedure PermissionRequestResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
    class var FInstance: TMobilePermissions;
  public
    class function GetInstance: TMobilePermissions;
    procedure GetPermissions;
  end;

implementation

class function TMobilePermissions.GetInstance: TMobilePermissions;
begin
  if not(Assigned(FInstance)) then
  begin
    FInstance := TMobilePermissions.Create;
    {$IFDEF ANDROID}
      FInstance.Camera := JStringToString(TJManifest_permission.JavaClass.Camera);
      FInstance.ReadStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
      FInstance.WriteStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
      FInstance.AllPermited := False;
    {$ENDIF}
  end;
  Result := FInstance;
end;

procedure TMobilePermissions.PermissionRequestResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
begin
  if (Length(AGrantResults) = 3) and (AGrantResults[0] = TPermissionStatus.Granted) and (AGrantResults[1] = TPermissionStatus.Granted) and (AGrantResults[2] = TPermissionStatus.Granted) then
    AllPermited := True;
end;

procedure TMobilePermissions.GetPermissions;
begin
  PermissionsService.RequestPermissions([Camera, ReadStorage, WriteStorage], PermissionRequestResult);
end;
initialization
finalization
  if Assigned(TMobilePermissions.FInstance) then
    FreeAndNil(TMobilePermissions.FInstance);
end.
