unit Entities.Product;

interface

uses
  System.Classes,Entities.Base;

type
  TEntitiesProduct = class(TEntitiesBase)
  private
    FUnityId: string;
    FCategoryId: string;
    FTaxId: string;
    FChangePrice: Boolean;
    FPriceCost: Double;
    FCest: string;
    FBarcode: string;
    FNcm: string;
    FDescription: string;
    FStockQuantity: Double;
    FProfitMargin: Double;
    FMinimumStock: Double;
    FActive: Boolean;
    FSalePrice: Double;
    FDeclarePisCofins: Boolean;
    FImage:TStream;
    FCompanyId:string;
  public
    property UnityId: string read FUnityId write FUnityId;
    property CategoryId: string read FCategoryId write FCategoryId;
    property TaxId: string read FTaxId write FTaxId;
    property DeclarePisCofins: Boolean read FDeclarePisCofins
      write FDeclarePisCofins;
    property Description: string read FDescription write FDescription;
    property Barcode: string read FBarcode write FBarcode;
    property PriceCost: Double read FPriceCost write FPriceCost;
    property SalePrice: Double read FSalePrice write FSalePrice;
    property ProfitMargin: Double read FProfitMargin write FProfitMargin;
    property StockQuantity: Double read FStockQuantity write FStockQuantity;
    property MinimumStock: Double read FMinimumStock write FMinimumStock;
    property Ncm: string read FNcm write FNcm;
    property Cest: string read FCest write FCest;
    property ChangePrice: Boolean read FChangePrice write FChangePrice;
    property Active: Boolean read FActive write FActive;
    property Image:TStream read FImage write FImage;
    property CompanyId:string read FCompanyId write FCompanyId;
  end;

implementation

{ TEntitiesProduct }

end.
