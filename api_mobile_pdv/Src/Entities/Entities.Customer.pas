unit Entities.Customer;

interface

uses Entities.Base;

type
  TEntitiesCustomer = class(TEntitiesBase)
  private
    FName: string;
    FEmail: string;
    FCityId: Integer;
    FFantasy: string;
    FPublicPlace: string;
    FPhone: string;
    FCpfCnpj: string;
    FIe: String;
    FZipCode: string;
    FComplement: string;
    FNumber: string;
    FIsActive: Boolean;
    FtypeOfTaxpayer: Integer;
    FNeighborhood: string;
    FCompanyId:string;
  public
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property Ie: String read FIe write FIe;
    property TypeOfTaxpayer: Integer read FtypeOfTaxpayer write FtypeOfTaxpayer;
    property Name: string read FName write FName;
    property Fantasy: string read FFantasy write FFantasy;
    property PublicPlace: string read FPublicPlace write FPublicPlace;
    property Number: string read FNumber write FNumber;
    property Complement: string read FComplement write FComplement;
    property Neighborhood: string read FNeighborhood write FNeighborhood;
    property CityId: Integer read FCityId write FCityId;
    property Phone: string read FPhone write FPhone;
    property Email: string read FEmail write FEmail;
    property IsActive: Boolean read FIsActive write FIsActive;
    property ZipCode: string read FZipCode write FZipCode;
    property CompanyId:string read FCompanyId write FCompanyId;
  end;

implementation

{ TEntitiesCustomer }

end.
