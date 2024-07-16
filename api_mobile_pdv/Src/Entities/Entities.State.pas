unit Entities.State;

interface
uses
  System.SysUtils,
  Entities.Base,
  Pkg.Json.DTO,
  REST.Json.Types;

type
  TEntitiesState = class(TEntitiesBase)
  private
    FName: string;
    FUf: string;
    procedure SetName(const Value: string);
    procedure SetUf(const Value: string);
  public
    property Name:string read FName write SetName;
    property Uf:string read FUf write SetUf;
    procedure GenerateId; override;
  end;
implementation

{ TEntitiesState }

procedure TEntitiesState.GenerateId;
begin

end;

procedure TEntitiesState.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TEntitiesState.SetUf(const Value: string);
begin
  FUf := Value;
end;

end.
