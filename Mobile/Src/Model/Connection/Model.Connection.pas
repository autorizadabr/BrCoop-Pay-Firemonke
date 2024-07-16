unit Model.Connection;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf,System.Generics.Collections,
  FireDAC.DApt, FireDAC.Comp.DataSet, Model.Connection.AtualizacaoBancoDados;

type
  TModelConnection = class(TDataModule)
    FConnection: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FConnectionAfterConnect(Sender: TObject);
  const VERSAO_DB = 0.1;
  private
    FBancoExist:Boolean;
    FAtualizarBancoDados:TModelConnectionAtualizacaoBancoDados;
    procedure SettingConnection(const APath:string);
  public
    function Connection:TFDConnection;
    function BancoExist:Boolean;
  end;

var
  ModelConnection: TModelConnection;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}


function TModelConnection.BancoExist: Boolean;
begin
  Result := FBancoExist;
end;

function TModelConnection.Connection: TFDConnection;
begin
  //if not Assigned(FConnection) then
  Result := FConnection;
end;


procedure TModelConnection.DataModuleCreate(Sender: TObject);
begin
  FBancoExist := False;
{$IFDEF MSWINDOWS}
  var LPath := ExpandFileName(GetCurrentDir + '\..\..\DataBase\coop_pay.db');
{$ELSE}
  var LPath := TPath.Combine(TPath.GetDocumentsPath, 'coop_pay.db');
{$ENDIF}
  FBancoExist := not LPath.IsEmpty;
  SettingConnection(LPath);
  FAtualizarBancoDados := TModelConnectionAtualizacaoBancoDados.Create(FConnection);
  FAtualizarBancoDados.AtualizarBancoScript;
end;

procedure TModelConnection.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FAtualizarBancoDados);
end;

procedure TModelConnection.FConnectionAfterConnect(Sender: TObject);
begin
  //FConnection.ExecSQL('PRAGMA journal_mode=WAL;');
end;

procedure TModelConnection.SettingConnection(const APath: string);
begin
  FBancoExist := False;
  FConnection.Connected := False;
  if not FileExists(APath) then
    Exit;
  FConnection.LoginPrompt := False;
  FConnection.Params.Values['Database'] := APath;
  FConnection.Connected := True;
  FBancoExist := True;
end;

end.
