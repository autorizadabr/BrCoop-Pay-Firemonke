unit Entities.Company;

interface

uses
  System.SysUtils,
  Entities.Base,
  Pkg.Json.DTO,
  REST.Json.Types;

type
  TEntitiesCompany = class(TEntitiesBase)
  private
    FName: string;
    FIm: string;
    FFantasy: string;
    FPublicPlace: string;
    FCpfCnpj: string;
    FComplement: string;
    FNumber: string;
    FNeighborhood: string;
    FIeSt: string;
    FIe: String;
    FPhone: string;
    FCrt: string;
    FCityId: Integer;
    FZipCode: string;
    FEmail: string;
    FDuoDate: TDate;
    FIsBlock: Boolean;
    FIsActive: Boolean;
    procedure SetComplement(const Value: string);
    procedure SetCpfCnpj(const Value: string);
    procedure SetFantasy(const Value: string);
    procedure SetIm(const Value: string);
    procedure SetName(const Value: string);
    procedure SetNeighborhood(const Value: string);
    procedure SetNumber(const Value: string);
    procedure SetPublicPlace(const Value: string);
    procedure SetIe(const Value: String);
    procedure SetIeSt(const Value: string);
    procedure SetCrt(const Value: string);
    procedure SetPhone(const Value: string);
    procedure SetCityId(const Value: Integer);
    procedure SetZipCode(const Value: string);
    procedure SetEmail(const Value: string);
    procedure SetDuoDate(const Value: TDate);
    procedure SetIsActive(const Value: Boolean);
    procedure SetIsBlock(const Value: Boolean);
    function GetCpfCnpj: string;
    function GetPhone: string;
  public
    procedure AfterConstruction; override;
    property CpfCnpj: string read GetCpfCnpj write SetCpfCnpj;
    property Ie: String read FIe write SetIe;
    property IeSt: string read FIeSt write SetIeSt;
    property Im: string read FIm write SetIm;
    property Name: string read FName write SetName;
    property Fantasy: string read FFantasy write SetFantasy;
    property PublicPlace: string read FPublicPlace write SetPublicPlace;
    property Number: string read FNumber write SetNumber;
    property Complement: string read FComplement write SetComplement;
    property Neighborhood: string read FNeighborhood write SetNeighborhood;
    property CityId: Integer read FCityId write SetCityId;
    property ZipCode: string read FZipCode write SetZipCode;
    property Phone: string read GetPhone write SetPhone;
    property Crt: string read FCrt write SetCrt;
    property Email: string read FEmail write SetEmail;
    property DuoDate: TDate read FDuoDate write SetDuoDate;
    property IsActive: Boolean read FIsActive write SetIsActive;
    property IsBlock: Boolean read FIsBlock write SetIsBlock;
    procedure Validatede; override;
  end;

implementation

{ TEntitiesCompany }

procedure TEntitiesCompany.AfterConstruction;
begin
  inherited;
  FIsBlock  := False;
  FIsActive := True;
end;

function TEntitiesCompany.GetCpfCnpj: string;
begin
  Result := OnlyNumeber(FCpfCnpj);
end;

function TEntitiesCompany.GetPhone: string;
begin
  Result := OnlyNumeber(FPhone);
end;

procedure TEntitiesCompany.SetCityId(const Value: Integer);
begin
  FCityId := Value;
end;

procedure TEntitiesCompany.SetComplement(const Value: string);
begin
  FComplement := Copy(Value,1,60);
end;

procedure TEntitiesCompany.SetCpfCnpj(const Value: string);
begin
  FCpfCnpj := Value;
end;

procedure TEntitiesCompany.SetCrt(const Value: string);
begin
  FCrt := Value;
end;

procedure TEntitiesCompany.SetDuoDate(const Value: TDate);
begin
  FDuoDate := Value;
end;

procedure TEntitiesCompany.SetEmail(const Value: string);
begin
  FEmail := Value;
end;

procedure TEntitiesCompany.SetFantasy(const Value: string);
begin
  FFantasy := Copy(Value,1,60);
end;

procedure TEntitiesCompany.SetIe(const Value: String);
begin
  FIe := Value;
end;

procedure TEntitiesCompany.SetIeSt(const Value: string);
begin
  FIeSt := Value;
end;

procedure TEntitiesCompany.SetIm(const Value: string);
begin
  FIm := Value;
end;

procedure TEntitiesCompany.SetIsActive(const Value: Boolean);
begin
  FIsActive := Value;
end;

procedure TEntitiesCompany.SetIsBlock(const Value: Boolean);
begin
  FIsBlock := Value;
end;

procedure TEntitiesCompany.SetName(const Value: string);
begin
  FName := Copy(Value,1,60);
end;

procedure TEntitiesCompany.SetNeighborhood(const Value: string);
begin
  FNeighborhood := Copy(Value,1,60);
end;

procedure TEntitiesCompany.SetNumber(const Value: string);
begin
  FNumber := Copy(Value,1,60);
end;

procedure TEntitiesCompany.SetPhone(const Value: string);
begin
  FPhone := Copy(Value,1,14);
end;

procedure TEntitiesCompany.SetPublicPlace(const Value: string);
begin
  FPublicPlace := Copy(Value,1,60);
end;

procedure TEntitiesCompany.SetZipCode(const Value: string);
begin
  FZipCode := Value;
end;

procedure TEntitiesCompany.Validatede;
begin
  inherited;
  if FCpfCnpj.Length <> 18 then
    raise Exception.Create('CNPJ deve conter até 18 caracteres!');

  if FCpfCnpj.Length <> 18 then
    raise Exception.Create('CNPJ deve conter até 18 caracteres!');

end;

end.
