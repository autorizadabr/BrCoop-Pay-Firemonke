unit Entities.Permission;

interface

uses
  System.SysUtils,
  Entities.Base,
  Pkg.Json.DTO,
  REST.Json.Types;

type
  TEntitiesPermission = class(TEntitiesBase)
  private
    FName: string;
    FDescription: string;
    procedure SetName(const Value: string);
    procedure SetDescription(const Value: string);
  public
    property Name: string read FName write SetName;
    property Description: string read FDescription write SetDescription;
    procedure Validatede; override;
    constructor Create; override;
  end;

implementation

{ TEntitisPermission }

constructor TEntitiesPermission.Create;
begin
  inherited;

end;

procedure TEntitiesPermission.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TEntitiesPermission.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TEntitiesPermission.Validatede;
begin
  inherited;
  if FName.IsEmpty then
  begin
    raise Exception.Create('Nome da permissão não informado!');
  end;

  if FDescription.IsEmpty then
  begin
    raise Exception.Create('Descrição da permissão não informado!');
  end;
end;

end.
