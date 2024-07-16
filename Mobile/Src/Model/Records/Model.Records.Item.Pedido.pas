unit Model.Records.Item.Pedido;

interface
  uses
   System.SysUtils,
   Model.Records.Regra.Fiscal,
   Model.Records.Item.Desconto;
type
  TModelItemPedido = record
    UserId:string;
    ItemJaEstaNaApi:Boolean;
    Comanda:Integer;
    Descricao:string;
    IdBancoDados:Integer;
    IdSequencia:Integer;
    IdProduto: string;
    NomeProduto:string;
    Quantidade: Integer;
    ValorUnitatio: Currency;
    Desconto:TModelItemDesconto;
    Observacao:TArray<String>;
    RegraFiscal:TModelRegraFiscal;
    procedure Clear;
    function Copy:TModelItemPedido;
  end;

implementation

{ TModelItemPedido }

procedure TModelItemPedido.Clear;
begin
  IdBancoDados  := 0;
  IdProduto     := EmptyStr;
  NomeProduto   := EmptyStr;
  Quantidade    := 0;
  ValorUnitatio := 0;
  Comanda       := 0;
  Descricao     := EmptyStr;
  SetLength(Observacao,0);
  Desconto.Clear;
  RegraFiscal.Clear;
end;

function TModelItemPedido.Copy: TModelItemPedido;
begin
  // Faço a copia mantendo os dados antigos, não consigo acessar
  // Um item de um record pela lista
  Result := Self;
end;

end.
