unit Entities.City;

interface

uses
  System.SysUtils,
  Entities.Base,
  Pkg.Json.DTO,
  REST.Json.Types;

type
  TEntitiesCity = class(TEntitiesBase)
  private
    FName: string;
    FStateId: Integer;
    procedure SetName(const Value: string);
    procedure SetStateId(const Value: Integer);
  public
    procedure GenerateId; override;
    property Name: string read FName write SetName;
    property StateId: Integer read FStateId write SetStateId;

  end;

implementation

{ TEntitiesCity }

procedure TEntitiesCity.GenerateId;
begin

end;

procedure TEntitiesCity.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TEntitiesCity.SetStateId(const Value: Integer);
begin
  FStateId := Value;
end;

end.
