unit Model.Records.Tipo.Pagamento;

interface
  uses System.SysUtils;
  type
  TTipoPagamento = record
    Id:string;
    Nome:string;
    JsonArrayString:string;
    procedure Clear;
  end;

implementation

{ TTipoPagamento }

procedure TTipoPagamento.Clear;
begin
  Id              := EmptyStr;
  Nome            := EmptyStr;
  JsonArrayString := EmptyStr;
end;

end.
