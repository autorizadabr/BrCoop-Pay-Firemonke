unit Connection.Pool.Config;

interface

uses
  System.IniFiles,
  System.SysUtils,
  FireDAC.Comp.Client,
  System.Types,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Phys,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,

  FireDAC.Phys.PGDef,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.PG,
  FireDAC.Comp.UI,
  FireDAC.Phys.FB,

  Data.DB,
  FireDAC.Comp.DataSet,
  System.Classes,
  System.IOUtils;

type
  TConnectionPoolConfig = class
  private
  var
    FDManager: TFDManager;
    FParams: TStrings;
    class var FInstance: TConnectionPoolConfig;
    procedure ConfigPool;
  public
    class function GetInstance: TConnectionPoolConfig;
    destructor Destroy;override;
  end;

implementation

{ TConnectionPoolConfig }

procedure TConnectionPoolConfig.ConfigPool;
var
  IniFile: TIniFile;
  Database: string;
  Server: string;
  UserName: string;
  Password: string;
  Driver: string;
  Spath: string;
  Port: integer;
begin
  Spath := ExtractFilePath(ParamStr(0)) + 'ConfigServer.Ini';
  if not FileExists(Spath) then
    Writeln('<<FATAL ERRO>> Config file  not found in ' + Spath);

  IniFile := TIniFile.Create(Spath);
  try
    Server   := IniFile.ReadString('Config', 'Server', '');
    Driver   := IniFile.ReadString('Config', 'driver', 'PG');
    Database := IniFile.ReadString('Config', 'Database', '');
    UserName := IniFile.ReadString('Config', 'UserName', '');
    Password := IniFile.ReadString('Config', 'Password', '');
    Port     := IniFile.ReadInteger('Config', 'port', 5432);
    FParams  := TStringList.Create;
    FParams.AddPair('Server', Server);
    FParams.AddPair('Database', Database);
    FParams.AddPair('User_Name', UserName);
    FParams.AddPair('Password', Password);
    FParams.AddPair('Port', Port.ToString);
    FParams.AddPair('CharacterSet', 'utf8');
    FParams.AddPair('Pooled', 'True');
    FParams.AddPair('DriverID', 'PG');
    FInstance.FDManager := TFDManager.Create(nil);
    FInstance.FDManager.AddConnectionDef('coop_pay', 'PG', FParams);
  finally
    FInstance.FDManager.SilentMode := True;
    IniFile.Free;
  end;
end;

destructor TConnectionPoolConfig.destroy;
begin
  if Assigned(FDManager) then
    FreeAndNil(FDManager);
  if Assigned(FParams) then
    FreeAndNil(FParams);
  inherited;
end;

class function TConnectionPoolConfig.GetInstance: TConnectionPoolConfig;
begin
  if not Assigned(FInstance) then
  begin
    FInstance := TConnectionPoolConfig.Create;
    FInstance.ConfigPool;
  end;
  Result := FInstance;
end;

initialization

TConnectionPoolConfig.FInstance := TConnectionPoolConfig.GetInstance;

finalization

if Assigned(TConnectionPoolConfig.FInstance) then
  FreeAndNil(TConnectionPoolConfig.FInstance);

end.
