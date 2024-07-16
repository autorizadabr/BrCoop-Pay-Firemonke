unit Model.Pedido.Dados.Item;

interface
  type
  TDadosProdutoItem = record
    Comanda:Integer;
    Descricao:string;
    IdUser:string;
    ItemJaEstaNaApi:Boolean;
    IdBancoDados:Integer;
    PercentualDesconto:Currency;
    ValorDesconto:Currency;
    Quantidade:Integer;
    Observacao:TArray<String>;
    procedure Clear;
  end;
implementation

{ TDadosProdutoItem }

procedure TDadosProdutoItem.Clear;
begin
  Comanda            := 0;
  Descricao          := '';
  ItemJaEstaNaApi    := False;
  PercentualDesconto := 0;
  ValorDesconto      := 0;
  Quantidade         := 0;
  IdBancoDados       := 0;
  SetLength(Observacao,0);
end;

end.
