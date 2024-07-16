unit Entities.Pos.Payment;

interface

uses Entities.Base;

type
  TEntitiesPosPayment = class(TEntitiesBase)
  private
    FDescriptionPos: string;
    FDescription: string;
    FNamePos: string;
    FPaymentId: string;
  public
    property PaymentId:string read FPaymentId write FPaymentId;
    property DescriptionPos:string read FDescriptionPos write FDescriptionPos;
    property Description:string read FDescription write FDescription;
    property NamePos:string read FNamePos write FNamePos;
  end;

implementation

{ TEntitiesPosPayment }

end.
