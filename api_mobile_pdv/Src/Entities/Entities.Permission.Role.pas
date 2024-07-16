unit Entities.Permission.Role;

interface

uses
  System.SysUtils,
  Entities.Base,
  Pkg.Json.DTO,
  REST.Json.Types;

type
  TEntitiesPermissionRole = class(TEntitiesBase)
  private
    FPermissionId: string;
    FRoleId: string;
    procedure SetPermissionId(const Value: string);
    procedure SetRoleId(const Value: string);
  public
    property PermissionId: string read FPermissionId write SetPermissionId;
    property RoleId: string read FRoleId write SetRoleId;
  end;

implementation

{ TEntitiesPermissionRole }

procedure TEntitiesPermissionRole.SetPermissionId(const Value: string);
begin
  FPermissionId := Value;
end;

procedure TEntitiesPermissionRole.SetRoleId(const Value: string);
begin
  FRoleId := Value;
end;

end.
