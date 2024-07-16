unit Reposotories.Base;

interface
  uses
  Connection.Database, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PGDef, FireDAC.Phys.PG,
  FireDAC.Comp.UI,
  FireDAC.DApt,
  Firedac.Stan.Param, System.SysUtils,System.Generics.Collections;
type
  TRepositoriesBase<T:Class> = class
  private
    FQueryRecordCount: TFDQuery;
    FQuery: TFDQuery;
    FConnection:TConnectionDatabase;
    FLimit: Integer;
    FSkip: Integer;
  public
    constructor Create();
    destructor Destroy;override;
    // Pagination
    property Skip:Integer read FSkip write FSkip;
    property Limit:Integer read FLimit write FLimit;
    // Connection
    property QueryRecordCount: TFDQuery read FQueryRecordCount;
    property Query: TFDQuery read FQuery;
    function Connection: TFDConnection;
    procedure GetRecordCount;
    // Crud
    procedure Insert(AEntity:T);virtual;abstract;
    procedure Update(AEntity:T);virtual;abstract;
    procedure Delete(AEntity:T);virtual;abstract;
    procedure SelectAll(AParams:TDictionary<string,string>);virtual;abstract;
    procedure SelectById(const AId:string);virtual;abstract;
  end;

implementation

{ TRepositoriesBase }

function TRepositoriesBase<T>.Connection: TFDConnection;
begin

end;

constructor TRepositoriesBase<T>.Create;
begin
  FConnection                  := TConnectionDatabase.Create(nil);
  FQuery                       := TFDQuery.Create(nil);
  FQuery.Connection            := Connection;
  FQueryRecordCount            := TFDQuery.Create(nil);
  FQueryRecordCount.Connection := Connection;
end;

destructor TRepositoriesBase<T>.Destroy;
begin
  FreeAndNil(FQuery);
  FreeAndNil(FQueryRecordCount);
  FreeAndNil(FConnection);
  inherited;
end;

procedure TRepositoriesBase<T>.GetRecordCount;
begin

end;

end.
