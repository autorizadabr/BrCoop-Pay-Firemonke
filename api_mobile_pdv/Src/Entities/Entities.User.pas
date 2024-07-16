unit Entities.User;

interface

uses
  System.SysUtils,
  Entities.Base,
  Pkg.Json.DTO,
  REST.Json.Types;


type
  TEntitiesUser = class(TEntitiesBase)
  private
    FName: string;
    FEmail: string;
    FEmailVerifiedAt: string;
    FPassword: string;
    FActive: Boolean;
    [JSONName('type_user')]
    FTypeUser: string;
    procedure SetEmail(const Value: string);
    procedure SetEmailVerifiedAt(const Value: string);
    procedure SetName(const Value: string);
    procedure SetActive(const Value: Boolean);
    procedure SetPassword(const Value: string);
    procedure SetTypeUser(const Value: string);
  public
    constructor Create; override;
    function ToString: string; override;
    property Name: string read FName write SetName;
    property Email: string read FEmail write SetEmail;
    property EmailVerifiedAt: string read FEmailVerifiedAt write SetEmailVerifiedAt;
    property Password: string read FPassword write SetPassword;
    property Active: Boolean read FActive write SetActive;
    property TypeUser:string read FTypeUser write SetTypeUser;
    function PasswordCrypt:string;
  end;

implementation

uses
  BCrypt;

{ TEntitiesUser }

constructor TEntitiesUser.Create;
begin
  inherited;
  FActive := True;
  FTypeUser := 'U';
  FPassword := EmptyStr;
end;

function TEntitiesUser.PasswordCrypt: string;
begin
  Result := TBCrypt.GenerateHash(FPassword);
end;

procedure TEntitiesUser.SetActive(const Value: Boolean);
begin
  FActive := Value;
end;

procedure TEntitiesUser.SetEmail(const Value: string);
begin
  FEmail := Value;
end;

procedure TEntitiesUser.SetEmailVerifiedAt(const Value: string);
begin
  FEmailVerifiedAt := Value;
end;

procedure TEntitiesUser.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TEntitiesUser.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TEntitiesUser.SetTypeUser(const Value: string);
begin
  FTypeUser := Value;
end;

function TEntitiesUser.ToString: string;
begin
  Result := 'users'
end;

end.
