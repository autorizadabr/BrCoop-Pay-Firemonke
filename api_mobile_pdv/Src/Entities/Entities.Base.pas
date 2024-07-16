unit Entities.Base;

interface

uses
  System.SysUtils,
  Pkg.Json.DTO,
  System.RegularExpressions,
  System.Json,
  REST.Json,
  System.Generics.Collections,
  REST.Json.Types, Generator.Id;

type
  TEntitiesBase = class(TJsonDTO)
  private
    [JSONName('id')]
    FId: string;
  protected
    function OnlyNumeber(const AValue:string):string;
  public
    constructor Create; virtual;
    property Id: string read FId write FId;
    procedure Validatede; virtual;
    procedure GenerateId;virtual;
  end;

implementation

{ TEntitiesBase }

constructor TEntitiesBase.Create;
begin

end;

procedure TEntitiesBase.GenerateId;
begin
  FId := TGeneratorId.GeneratorId;
end;

function TEntitiesBase.OnlyNumeber(const AValue: string): string;
var
  regex: TRegEx;
begin
  regex := TRegEx.Create('\d+');
  Result := '';
  for var match in regex.Matches(AValue) do
    Result := Result + match.Value;

end;

procedure TEntitiesBase.Validatede;
begin
  if FId.IsEmpty then
    raise Exception.Create('ID da classe ' + Self.ClassName +
      ' não informado!');
end;

end.
