unit Model.Records.Regra.Fiscal;

interface
  uses System.SysUtils;
  type
  TModelRegraFiscal = record
    Id:string;
    Origin:string;
    CsosnCst:string;
    CstPis:string;
    PPis:string;
    CstCofins:string;
    PCofins:string;
    CfopInterno:string;
    CfopExterno:string;
    procedure Clear;
  end;
implementation

{ TModelRegraFiscal }

procedure TModelRegraFiscal.Clear;
begin
  Id := EmptyStr;
  Origin := EmptyStr;
  CsosnCst := EmptyStr;
  CstPis := EmptyStr;
  PPis := EmptyStr;
  CstCofins := EmptyStr;
  PCofins := EmptyStr;
  CfopInterno := EmptyStr;
  CfopExterno := EmptyStr;
end;

end.
