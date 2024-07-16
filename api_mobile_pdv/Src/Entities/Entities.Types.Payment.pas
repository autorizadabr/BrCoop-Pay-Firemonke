unit Entities.Types.Payment;

interface

uses Entities.Base;

type
  TEntitiesTypesPayment = class(TEntitiesBase)
  private
    FCode: string;
    FIsTef: Boolean;
    FGeneratesInstallment: Boolean;
    FDescription: string;
    FActive: Boolean;
    FCompanyId: string;
  public
    property Description: string read FDescription write FDescription;
    property Code: string read FCode write FCode;
    property Active: Boolean read FActive write FActive;
    property GeneratesInstallment: Boolean read FGeneratesInstallment
      write FGeneratesInstallment;
    property IsTef: Boolean read FIsTef write FIsTef;
    property CompanyId:string read FCompanyId write FCompanyId;
  end;

implementation

{ TEntitiesTypesPayment }

end.
