unit Model.Carrinho.Item;

interface

uses
  System.Classes,
  System.SysUtils, Model.Records.Regra.Fiscal;

type
  TModelCarrinhoItem = class
  private
    FNumberId: Integer;
    FSequencial: Integer;
    FProduto: string;
    FValorUnitario: Currency;
    FQuantidade: Integer;
    FDescontoPorcentagem: Currency;
    FDescontoValor: Currency;
    FSubtoal: Currency;
    FTotal: Currency;
    FObservacao: TArray<String>;
    FStringList: TStringList;
    FModelRegraFiscal:TModelRegraFiscal;
  public
    constructor Create;
    destructor Destroy; override;
    function NumberId(AValue: Integer): TModelCarrinhoItem; overload;
    function Sequencial(AValue: Integer): TModelCarrinhoItem; overload;
    function Produto(AValue: String): TModelCarrinhoItem; overload;
    function ValorUnitario(AValue: Currency): TModelCarrinhoItem; overload;
    function Quantidade(AValue: Integer): TModelCarrinhoItem; overload;
    function DescontoPorcentagem(AValue: Currency): TModelCarrinhoItem;overload;
    function DescontoValor(AValue: Currency): TModelCarrinhoItem; overload;
    function Subtoal(AValue: Currency): TModelCarrinhoItem; overload;
    function Total(AValue: Currency): TModelCarrinhoItem; overload;
    function Observacao(const AValue: TArray<String>): TModelCarrinhoItem; overload;
    function RegraFiscal(const AValue: TModelRegraFiscal): TModelCarrinhoItem; overload;
    function NumberId: Integer; overload;
    function Sequencial: Integer; overload;
    function Produto: String; overload;
    function ValorUnitario: Currency; overload;
    function Quantidade: Integer; overload;
    function DescontoPorcentagem: Currency; overload;
    function DescontoValor: Currency; overload;
    function Subtoal: Currency; overload;
    function Total: Currency; overload;
    function Observacao: TArray<String>; overload;
    function ObservacaoList: TStringList;
    function CarregarObservacaoPorText(const AText: string): TModelCarrinhoItem;
    function RegraFiscal: TModelRegraFiscal; overload;
  end;

implementation

{ TModelCarrinhoItem }

function TModelCarrinhoItem.NumberId: Integer;
begin
  Result := FNumberId;
end;

function TModelCarrinhoItem.Observacao: TArray<String>;
begin
  Result := FObservacao;
end;

function TModelCarrinhoItem.ObservacaoList: TStringList;
begin
  FStringList.Clear;
  for var I := Low(FObservacao) to High(FObservacao) do
  begin
    FStringList.Add(FObservacao[I]);
  end;
  Result := FStringList;
end;

function TModelCarrinhoItem.Observacao(const AValue: TArray<String>)
  : TModelCarrinhoItem;
begin
  Result := Self;
  FObservacao := AValue;
end;

function TModelCarrinhoItem.Produto: String;
begin
  Result := FProduto;
end;

function TModelCarrinhoItem.Quantidade: Integer;
begin
  Result := FQuantidade;
end;

function TModelCarrinhoItem.RegraFiscal: TModelRegraFiscal;
begin
  Result := FModelRegraFiscal;
end;

function TModelCarrinhoItem.RegraFiscal(const AValue: TModelRegraFiscal)
  : TModelCarrinhoItem;
begin
  Result := Self;
  FModelRegraFiscal := AValue;
end;

function TModelCarrinhoItem.Quantidade(AValue: Integer): TModelCarrinhoItem;
begin
  Result := Self;
  FQuantidade := AValue;
end;

function TModelCarrinhoItem.Sequencial: Integer;
begin
  Result := FSequencial;
end;

function TModelCarrinhoItem.NumberId(AValue: Integer): TModelCarrinhoItem;
begin
  Result := Self;
  FNumberId := AValue;
end;

function TModelCarrinhoItem.Produto(AValue: String): TModelCarrinhoItem;
begin
  Result := Self;
  FProduto := AValue;
end;

function TModelCarrinhoItem.Sequencial(AValue: Integer): TModelCarrinhoItem;
begin
  Result := Self;
  FSequencial := AValue;
end;

function TModelCarrinhoItem.Subtoal(AValue: Currency): TModelCarrinhoItem;
begin
  Result := Self;
  FSubtoal := AValue;
end;

function TModelCarrinhoItem.Total(AValue: Currency): TModelCarrinhoItem;
begin
  Result := Self;
  FTotal := AValue;
end;

function TModelCarrinhoItem.DescontoPorcentagem(AValue: Currency)
  : TModelCarrinhoItem;
begin
  Result := Self;
  FDescontoPorcentagem := AValue;
end;

function TModelCarrinhoItem.Subtoal: Currency;
begin
  Result := FSubtoal;
end;

function TModelCarrinhoItem.Total: Currency;
begin
  Result := FTotal;
end;

function TModelCarrinhoItem.ValorUnitario: Currency;
begin
  Result := FValorUnitario;
end;

function TModelCarrinhoItem.ValorUnitario(AValue: Currency): TModelCarrinhoItem;
begin
  Result := Self;
  FValorUnitario := AValue;
end;

function TModelCarrinhoItem.CarregarObservacaoPorText(const AText: string)
  : TModelCarrinhoItem;
begin
  Result := Self;
  FStringList.Text := AText;
  SetLength(FObservacao, FStringList.Count);
  for var I := 0 to Pred(FStringList.Count) do
  begin
    FObservacao[I] := FStringList[I];
  end;
  FStringList.Clear;
end;

constructor TModelCarrinhoItem.Create;
begin
  FStringList := TStringList.Create;
end;

function TModelCarrinhoItem.DescontoPorcentagem: Currency;
begin
  Result := FDescontoPorcentagem;
end;

function TModelCarrinhoItem.DescontoValor: Currency;
begin
  Result := FDescontoValor;
end;

destructor TModelCarrinhoItem.Destroy;
begin
  FreeAndNil(FStringList);
  inherited;
end;

function TModelCarrinhoItem.DescontoValor(AValue: Currency): TModelCarrinhoItem;
begin
  Result := Self;
  FDescontoValor := AValue;
end;

end.
