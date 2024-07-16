unit Entities.Order.Payment;

interface

uses Entities.Base;

type
  TEntitiesOrderPayment = class(TEntitiesBase)
  private
    FAmountPaid: Double;
    FFlag: string;
    FAutorizationCode: string;
    FDateTimeAutorization: TDateTime;
    FPaymentId: String;
    FNsu: string;
    FOrderId: String;
  public
    property OrderId: String read FOrderId write FOrderId;
    property PaymentId: String read FPaymentId write FPaymentId;
    property Nsu: string read FNsu write FNsu;
    property AutorizationCode: string read FAutorizationCode  write FAutorizationCode;
    property DateTimeAutorization: TDateTime read FDateTimeAutorization write FDateTimeAutorization;
    property Flag: string read FFlag write FFlag;
    property AmountPaid: Double read FAmountPaid write FAmountPaid;
  end;

implementation

{ TEntitiesOrderPayment }

end.
