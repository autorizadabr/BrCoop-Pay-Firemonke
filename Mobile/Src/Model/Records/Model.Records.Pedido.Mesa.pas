unit Model.Records.Pedido.Mesa;

interface

type
  TStituacao = (stLivre, stOcupada);

  TPedidoMesa = record
    Numero: Integer;
    Situacao: TStituacao;
    procedure Clear;
  end;

implementation

{ TPedidoMesa }

procedure TPedidoMesa.Clear;
begin
  Numero := 0;
end;

end.
