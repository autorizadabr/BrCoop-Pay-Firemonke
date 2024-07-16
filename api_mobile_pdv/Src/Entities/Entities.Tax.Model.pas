unit Entities.Tax.Model;

interface

uses Entities.Base;

type
  TEntitiesTaxModel = class(TEntitiesBase)
  private
    FExternalCfop: string;
    FInternalCfop: string;
    FPpis: string;
    FPCofins: string;
    FOrigin: string;
    FCstPis: string;
    FCstCofins: string;
    FDescription: string;
    FCsosnCst: string;
    FActive: Boolean;
  public
    property Description: string read FDescription write FDescription;
    property Origin: string read FOrigin write FOrigin;
    property CsosnCst: string read FCsosnCst write FCsosnCst;
    property CstPis: string read FCstPis write FCstPis;
    property Ppis: string read FPpis write FPpis;
    property CstCofins: string read FCstCofins write FCstCofins;
    property PCofins: string read FPCofins write FPCofins;
    property InternalCfop: string read FInternalCfop write FInternalCfop;
    property ExternalCfop: string read FExternalCfop write FExternalCfop;
    property Active: Boolean read FActive write FActive;
  end;

implementation

{ TEntitiesTaxModel }

end.
