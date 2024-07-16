unit Services.Base;

interface
uses Connection.Database, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PGDef, FireDAC.Phys.PG,
  FireDAC.Comp.UI,
  FireDAC.DApt,
  Firedac.Stan.Param,
  Horse.Core.Param,
  Horse.Exception,
  Horse.Commons,
  System.Generics.Collections,
  System.SysUtils,
  JOSE.Core.JWT,
  JOSE.Core.JWK,
  JOSE.Core.Builder,
  JOSE.Types.Bytes,
  JOSE.Context,
  JOSE.Consumer,
  System.JSON, Services.Response.Pagination, Entities.Base;
type
  TMethodPermission = (methodGET,methodPOST,methodPUT,methodDELETE);
  TServicesBase<T: class> = class
  private
    FQuery: TFDQuery;
    FQueryRecordCount:TFDQuery;
    FDataBase:string;
    FConnection:TConnectionDatabase;
    FCurrentCompany:string;
    function GetMethodString(AMethod:TMethodPermission):string;
  protected
    FListParams:TDictionary<string,string>;
    FPage:Integer;
    FLimit:Integer;
    FServicesResponsePagination:TServicesResponsePagination;
    FToken:string;
    FRoute:string;
    property Route:string read FRoute write FRoute;
    property DataBase:string read FDataBase write FDataBase;
    property QueryRecordCount: TFDQuery read FQueryRecordCount;
    property Query: TFDQuery read FQuery;
    function Connection: TFDConnection;
    function Skip:Integer;
    procedure SetPage(const APage:string);
    procedure SetLimit(const ALimit:string);
    procedure ValidatePermission(AMethod:TMethodPermission);
    procedure GetRecordCount;
    function CurrentCompany:string;
  public
    constructor Create(const AToken:string);overload;virtual;
    destructor Destroy; override;
    procedure ExtractParams(AParams:THorseCoreParam);
    function Insert(AEntity:T):TJSONObject;virtual;
    procedure Update(AEntity:T);virtual;
    procedure Delete(AEntity:T);virtual;
    function SelectById(const AId:string):TJSONObject;virtual;
    function SelectAll:TJSONObject;virtual;
  end;
implementation

{ TServicesBase }

function TServicesBase<T>.Connection: TFDConnection;
begin
  Result := FConnection.FDConnection;
end;

constructor TServicesBase<T>.Create(const AToken:string);
begin
  FCurrentCompany              := EmptyStr;
  FConnection                  := TConnectionDatabase.Create(nil);
  FToken                       := AToken.Replace('Bearer ','').Trim;
  FPage                        := 0;
  FLimit                       := 20;
  FServicesResponsePagination  := TServicesResponsePagination.Create;
  FQuery                       := TFDQuery.Create(nil);
  FQuery.Connection            := Connection;
  FQueryRecordCount            := TFDQuery.Create(nil);
  FQueryRecordCount.Connection := Connection;
end;

function TServicesBase<T>.CurrentCompany: string;
begin
  Result := FCurrentCompany;
end;

destructor TServicesBase<T>.Destroy;
begin
  FServicesResponsePagination.Free;
  FQueryRecordCount.Free;
  FQuery.Free;
  FConnection.Free;
  inherited;
end;

function TServicesBase<T>.Insert(AEntity: T):TJSONObject;
begin
  Result := nil;
  if AEntity is TEntitiesBase then
  begin
    TEntitiesBase(AEntity).GenerateId;
  end;
  ValidatePermission(TMethodPermission.methodPOST);
end;

 function TServicesBase<T>.SelectAll: TJSONObject;
begin
  ValidatePermission(TMethodPermission.methodGET);
  GetRecordCount;
end;

function TServicesBase<T>.SelectById(const AId: string): TJSONObject;
begin
  Result := nil;
  ValidatePermission(TMethodPermission.methodGET);
  GetRecordCount;
end;

procedure TServicesBase<T>.SetLimit(const ALimit: string);
begin
  FLimit := StrToIntDef(ALimit,10);
  FServicesResponsePagination.SetLimit(FLimit);
end;

procedure TServicesBase<T>.SetPage(const APage: String);
begin
  FPage := StrToIntDef(APage,1);
  FServicesResponsePagination.SetPage(FPage);
end;

function TServicesBase<T>.Skip: Integer;
begin
  Result := 0;
  if FPage > 1 then
    Result := (FPage - 1) * FLimit;
end;

procedure TServicesBase<T>.Delete(AEntity: T);
begin
  ValidatePermission(TMethodPermission.methodDELETE);
end;

procedure TServicesBase<T>.ExtractParams(AParams: THorseCoreParam);
begin
  SetPage(AParams.Items['Page']);
  SetLimit(AParams.Items['limit']);
  FListParams := AParams.Dictionary;
end;

function TServicesBase<T>.GetMethodString(AMethod: TMethodPermission): string;
begin
  case AMethod of
    methodGET:    Result := 'GET';
    methodPOST:   Result := 'POST';
    methodPUT:    Result := 'PUT';
    methodDELETE: Result := 'DELETE';
  end;
end;

procedure TServicesBase<T>.GetRecordCount;
begin
  if not DataBase.IsEmpty then
  begin
    FQueryRecordCount.Close;
    FQueryRecordCount.SQL.Clear;
    FQueryRecordCount.SQL.Add('select count(id) from '+DataBase);
    FQueryRecordCount.Open();
    FServicesResponsePagination.SetRecords(FQueryRecordCount.FieldByName('count').AsInteger);
  end;
end;

procedure TServicesBase<T>.Update(AEntity: T);
begin
  ValidatePermission(TMethodPermission.methodPUT);
end;

procedure TServicesBase<T>.ValidatePermission(AMethod:TMethodPermission);
var
  LToken:TJWT;
  LKey:TJWK;
  LCompactToken:TJOSEBytes;
  LConsumer: IJOSEConsumer;
begin
  FCurrentCompany := EmptyStr;
  var LIdUser:string;
  var LIdCompany:string;
  try
    LCompactToken  := FToken;
    LKey           := TJWK.Create('cooppay');
    try
      LToken       := TJOSE.Verify(LKey, LCompactToken);
      try
        LIdUser    := LToken.Claims.JSON.GetValue<string>('id_user','');
        LIdCompany := LToken.Claims.JSON.GetValue<string>('id_company','');

      finally
        LToken.Free;
      end;
    finally
      LKey.Free;
    end;
  except on E: Exception do
    raise Exception.Create('Token informado é inválido!');
  end;


  if FRoute.IsEmpty then
  begin
    raise Exception.Create('Route não foi informado na server!');
  end;


  var LMethod                 := GetMethodString(AMethod);
  var LPermission             := (FRoute + '.' + LMethod).ToLower;
  var LQueryPermission        := TFDQuery.Create(nil);
  LQueryPermission.Connection := Connection;
  try
    LQueryPermission.Close;
    LQueryPermission.SQL.Clear;
    LQueryPermission.SQL.Add('select p.*,c."name"  from company_user_role cur');
    LQueryPermission.SQL.Add('left join companies c on c.id = :company_id');
    LQueryPermission.SQL.Add('left join roles r on r.id = cur.role_id');
    LQueryPermission.SQL.Add('left join permission_role pr ON pr.role_id = cur.role_id');
    LQueryPermission.SQL.Add('left join permissions p ON p.id = permission_id');
    LQueryPermission.SQL.Add('where cur.user_id = :user_id and cur.company_id  = :company_id');
    LQueryPermission.SQL.Add('and lower(p."name") = lower(:permission)');
    LQueryPermission.ParamByName('company_id').AsString := LIdCompany;
    LQueryPermission.ParamByName('user_id').AsString    := LIdUser;
    LQueryPermission.ParamByName('permission').AsString := LPermission;
    LQueryPermission.Open();

    if LQueryPermission.RecordCount <= 0 then
    begin
      raise EHorseException.New.Status(THTTPStatus.Forbidden).Error('Usuário sem permissão para acessar esse recurso do sistema!');
    end;
    FCurrentCompany := LIdCompany;
  finally
    FreeAndNil(LQueryPermission);
  end;
end;

end.
