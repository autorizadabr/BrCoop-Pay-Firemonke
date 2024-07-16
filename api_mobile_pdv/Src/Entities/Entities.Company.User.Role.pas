unit Entities.Company.User.Role;

interface

uses
  System.SysUtils,
  Entities.Base,
  Pkg.Json.DTO,
  REST.Json.Types;

type
  TEntitiesCompanyUserRole = class(TEntitiesBase)
  private
    FUserId: string;
    FCompanyId: string;
    FRoleId: string;
    procedure SetCompanyId(const Value: string);
    procedure SetRoleId(const Value: string);
    procedure SetUserId(const Value: string);
  public
    property CompanyId: string read FCompanyId write SetCompanyId;
    property UserId: string read FUserId write SetUserId;
    property RoleId: string read FRoleId write SetRoleId;
  end;

implementation

{ TEntitiesCompanyUserRole }

procedure TEntitiesCompanyUserRole.SetCompanyId(const Value: string);
begin
  FCompanyId := Value;
end;

procedure TEntitiesCompanyUserRole.SetRoleId(const Value: string);
begin
  FRoleId := Value;
end;

procedure TEntitiesCompanyUserRole.SetUserId(const Value: string);
begin
  FUserId := Value;
end;

end.
