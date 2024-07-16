unit Entities.Role;

interface
uses
  System.SysUtils,
  Entities.Base,
  Pkg.Json.DTO,
  REST.Json.Types;
type
  TEntitiesRole = class(TEntitiesBase)
    private
    FName: string;
    procedure SetName(const Value: string);
    public
    property Name:string read FName write SetName;
  end;
implementation

{ TEntitiesRole }


procedure TEntitiesRole.SetName(const Value: string);
begin
  FName := Value;
end;

end.
