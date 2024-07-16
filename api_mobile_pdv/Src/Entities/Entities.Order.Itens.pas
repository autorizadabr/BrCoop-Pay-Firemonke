unit Entities.Order.Itens;

interface

uses Entities.Base;

type
  TEntitiesOrderItens = class(TEntitiesBase)
  private
    FDiscountPercentage: Double;
    FSubtotal: Double;
    FPpis: Double;
    FTotal: Double;
    FPcofins: Double;
    FVpis: Double;
    FOrigin: string;
    FVcofins: Double;
    FCstPis: string;
    FCfop: string;
    FCstCofins: string;
    FAmount: Double;
    FProductId: string;
    FCsosnCst: string;
    FOrderId: string;
    FDiscountValue: Double;
    FObservation: string;
    FUserId: string;
    FDescricao: string;
    FComanda: Integer;
  public
    property OrderId: string read FOrderId write FOrderId;
    property ProductId: string read FProductId write FProductId;
    property Amount: Double read FAmount write FAmount;
    property DiscountValue: Double read FDiscountValue write FDiscountValue;
    property DiscountPercentage: Double read FDiscountPercentage write FDiscountPercentage;
    property Observation:string read FObservation write FObservation;
    property Cfop: string read FCfop write FCfop;
    property Origin: string read FOrigin write FOrigin;
    property CsosnCst: string read FCsosnCst write FCsosnCst;
    property CstPis: string read FCstPis write FCstPis;
    property Ppis: Double read FPpis write FPpis;
    property Vpis: Double read FVpis write FVpis;
    property CstCofins: string read FCstCofins write FCstCofins;
    property Pcofins: Double read FPcofins write FPcofins;
    property Vcofins: Double read FVcofins write FVcofins;
    property Subtotal: Double read FSubtotal write FSubtotal;
    property Total: Double read FTotal write FTotal;
    property UserId:string read FUserId write FUserId;
    property Comanda:Integer read FComanda write FComanda;
    property Descricao:string read FDescricao write FDescricao;
  end;

implementation

{ TEntitiesOrderItens }

end.
