unit Entities.Order;

interface

uses Entities.Base,
  System.Generics.Collections,
  System.SysUtils,
  Entities.Order.Itens, Entities.Order.Payment;

type
  TEntitiesOrder = class(TEntitiesBase)
  private
    FTypeOrder: Integer;
    FTroco: Double;
    FSubtotal: Double;
    FUserId: string;
    FAddition: Double;
    FTotal: Double;
    FCpfCnpj: string;
    FDiscount: Double;
    FCustomerId: string;
    FCompanyId: string;
    [JSONName('order_items')]
    [JSONMarshalledAttribute(False)]
    FList: TObjectList<TEntitiesOrderItens>;
    [JSONName('orderPayments')]
    [JSONMarshalledAttribute(False)]
    FListOrderPayment:TObjectList<TEntitiesOrderPayment>;
    FNomeCliente: string;
    FStatus: string;
    FMesa: Integer;
    FComanda: Integer;
  public
    constructor Create;
    destructor Destroy;override;
    property CompanyId: string read FCompanyId write FCompanyId;
    property UserId: string read FUserId write FUserId;
    property CustomerId: string read FCustomerId write FCustomerId;
    property TypeOrder: Integer read FTypeOrder write FTypeOrder;
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property Addition: Double read FAddition write FAddition;
    property Discount: Double read FDiscount write FDiscount;
    property Troco: Double read FTroco write FTroco;
    property Subtotal: Double read FSubtotal write FSubtotal;
    property Total: Double read FTotal write FTotal;
    property Status:string read FStatus write FStatus;
    property Comanda:Integer read FComanda write FComanda;
    property Mesa:Integer read FMesa write FMesa;
    property NomeCliente:string read FNomeCliente write FNomeCliente;
    property List: TObjectList<TEntitiesOrderItens> read FList write FList;
    property ListOrderPayment:TObjectList<TEntitiesOrderPayment> read FListOrderPayment write FListOrderPayment;
  end;

implementation


{ TEntitiesOrder }

constructor TEntitiesOrder.Create;
begin
  FList             := TObjectList<TEntitiesOrderItens>.Create;
  FListOrderPayment := TObjectList<TEntitiesOrderPayment>.Create;
end;

destructor TEntitiesOrder.Destroy;
begin
  FreeAndNil(FListOrderPayment);
  FreeAndNil(FList);
  inherited;
end;

end.
