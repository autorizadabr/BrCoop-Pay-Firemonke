unit Model.Pedido.Lista;

interface

  uses System.Generics.Collections,
  System.SysUtils,
  Model.Records.Item.Pedido,
  Model.Records.Regra.Fiscal;

type
  TModelPedidoLista = class
  private
    FListaItensPedido: TList<TModelItemPedido>;
    FItensPedido:TModelItemPedido;
    FEventoDepoisDeAdicionarUmProduto: TProc<TModelItemPedido>;
    FEventoDepoisDeAlterarDesconto: TProc<TModelItemPedido>;
    FEventoDeposDeAlterarQuantidade: TProc<TModelItemPedido>;
    FEventoDeposDeAlterarObservacao: TProc<TModelItemPedido>;
  public
    constructor Create;
    destructor Destroy; override;
    function IniciarLista:TModelPedidoLista;
    function SetComanda(const AValue: Integer): TModelPedidoLista;
    function SetDescricao(const AValue: string): TModelPedidoLista;
    function SetUserId(const AValue: string): TModelPedidoLista;
    function SetItemJaEstaNaApi(const AValue: Boolean): TModelPedidoLista;
    function SetIdBancoDados(const AValue: Integer): TModelPedidoLista;
    function SetIdProduto(const AValue: string): TModelPedidoLista;
    function SetNomeProduto(const AValue: string): TModelPedidoLista;
    function SetQuantidade(const AValue: Integer): TModelPedidoLista;
    function SetValorUnitatio(const AValue: Currency): TModelPedidoLista;
    function SetPercentualDesconto(const AValue: Currency): TModelPedidoLista;
    function SetValorDesconto(const AValue: Currency): TModelPedidoLista;
    function SetObservacao(const AValue:TArray<string>):TModelPedidoLista;
    function SetRegraFiscal(const AValue:TModelRegraFiscal):TModelPedidoLista;
    procedure AlterarComanda(const AIndex:Integer; ANumeroComanda:Integer;const ADescricao:string);
    procedure AlterarQuantidade(AIndexLista,AQuantidade:Integer);
    procedure AlterarDesconto(AIndexLista:Integer;APercentualDesconto,AValorDesconto:Currency);
    procedure AlterarObservacao(AIndex: Integer; AObservacao: TArray<String>);
    procedure AlterarIdBancoDados(AIndex: Integer; AIdBancoDados:Integer);
    procedure Adicionar;
    property EventoDepoisDeAdicionarUmProduto:TProc<TModelItemPedido> read FEventoDepoisDeAdicionarUmProduto write FEventoDepoisDeAdicionarUmProduto;
    property EventoDepoisDeAlterarDesconto:TProc<TModelItemPedido> read FEventoDepoisDeAlterarDesconto write FEventoDepoisDeAlterarDesconto;
    property EventoDeposDeAlterarQuantidade:TProc<TModelItemPedido> read FEventoDeposDeAlterarQuantidade write FEventoDeposDeAlterarQuantidade;
    property EventoDeposDeAlterarObservacao:TProc<TModelItemPedido> read FEventoDeposDeAlterarObservacao write FEventoDeposDeAlterarObservacao;
    function Lista:TList<TModelItemPedido>;

  end;

implementation

{ TModelPedidoLista }

procedure TModelPedidoLista.Adicionar;
begin
  FListaItensPedido.Add(FItensPedido);
  var LItemPedido := FItensPedido.Copy;

  if Assigned(FEventoDepoisDeAdicionarUmProduto) then
    FEventoDepoisDeAdicionarUmProduto(LItemPedido);

  Inc(FItensPedido.IdSequencia);
  FItensPedido.Clear;
end;

procedure TModelPedidoLista.AlterarComanda(const AIndex:Integer; ANumeroComanda:Integer;const ADescricao:string);
begin
  var LItem:TModelItemPedido;
  LItem                     := FListaItensPedido[AIndex].Copy;
  LItem.Comanda             := ANumeroComanda;
  LItem.Descricao           := ADescricao;
  FListaItensPedido[AIndex] := LItem;
end;

procedure TModelPedidoLista.AlterarDesconto(AIndexLista: Integer;
  APercentualDesconto, AValorDesconto: Currency);
begin
  var LItem:TModelItemPedido;
  LItem                          := FListaItensPedido[AIndexLista].Copy;
  LItem.Desconto.Percentual      := APercentualDesconto;
  LItem.Desconto.Valor           := AValorDesconto;
  FListaItensPedido[AIndexLista] := LItem;
  if Assigned(FEventoDepoisDeAlterarDesconto) then
    FEventoDepoisDeAlterarDesconto(LItem);
end;

procedure TModelPedidoLista.AlterarIdBancoDados(AIndex, AIdBancoDados: Integer);
begin
  var LItem:TModelItemPedido;
  LItem                     := FListaItensPedido[AIndex].Copy;
  LItem.IdBancoDados        := AIdBancoDados;
  FListaItensPedido[AIndex] := LItem;
end;

procedure TModelPedidoLista.AlterarObservacao(AIndex: Integer;
  AObservacao: TArray<String>);
begin
  var LItem:TModelItemPedido;
  LItem                     := FListaItensPedido[AIndex].Copy;
  LItem.Observacao          := AObservacao;
  FListaItensPedido[AIndex] := LItem;
  if Assigned(FEventoDeposDeAlterarObservacao) then
    FEventoDeposDeAlterarObservacao(LItem);
end;

procedure TModelPedidoLista.AlterarQuantidade(AIndexLista,
  AQuantidade: Integer);
begin
  var LItem:TModelItemPedido;
  LItem                          := FListaItensPedido[AIndexLista].Copy;
  LItem.Quantidade               := AQuantidade;
  FListaItensPedido[AIndexLista] := LItem;
  if Assigned(FEventoDeposDeAlterarQuantidade) then
    FEventoDeposDeAlterarQuantidade(LItem);
end;

constructor TModelPedidoLista.Create;
begin
  FListaItensPedido        := TList<TModelItemPedido>.Create;
  FItensPedido.IdSequencia := 1;
end;

destructor TModelPedidoLista.Destroy;
begin
  FListaItensPedido.Free;
  inherited;
end;

function TModelPedidoLista.IniciarLista: TModelPedidoLista;
begin
  Result := Self;
  FItensPedido.Clear;
end;

function TModelPedidoLista.Lista: TList<TModelItemPedido>;
begin
  Result := FListaItensPedido;
end;

function TModelPedidoLista.SetComanda(const AValue: Integer): TModelPedidoLista;
begin
  Result := Self;
  FItensPedido.Comanda := AValue;
end;

function TModelPedidoLista.SetDescricao(
  const AValue: string): TModelPedidoLista;
begin
  Result := Self;
  FItensPedido.Descricao := AValue;
end;

function TModelPedidoLista.SetIdBancoDados(
  const AValue: Integer): TModelPedidoLista;
begin
  Result := Self;
  FItensPedido.IdBancoDados := AValue;
end;

function TModelPedidoLista.SetIdProduto(
  const AValue: string): TModelPedidoLista;
begin
  Result := Self;
  FItensPedido.IdProduto := AValue;
end;

function TModelPedidoLista.SetItemJaEstaNaApi(
  const AValue: Boolean): TModelPedidoLista;
begin
  Result := Self;
  FItensPedido.ItemJaEstaNaApi := AValue;
end;

function TModelPedidoLista.SetNomeProduto(
  const AValue: string): TModelPedidoLista;
begin
  Result := Self;
  FItensPedido.NomeProduto := AValue;
end;

function TModelPedidoLista.SetObservacao(const AValue:TArray<string>): TModelPedidoLista;
begin
  Result := Self;
  FItensPedido.Observacao := AValue;
end;

function TModelPedidoLista.SetPercentualDesconto(
  const AValue: Currency): TModelPedidoLista;
begin
  Result := Self;
  FItensPedido.Desconto.Percentual := AValue;
end;

function TModelPedidoLista.SetQuantidade(
  const AValue: Integer): TModelPedidoLista;
begin
  Result := Self;
  FItensPedido.Quantidade := AValue;
end;

function TModelPedidoLista.SetRegraFiscal(
  const AValue: TModelRegraFiscal): TModelPedidoLista;
begin
  Result := Self;
  FItensPedido.RegraFiscal := AValue;
end;

function TModelPedidoLista.SetUserId(const AValue: string): TModelPedidoLista;
begin
  Result := Self;
  FItensPedido.UserId := AValue;
end;

function TModelPedidoLista.SetValorDesconto(
  const AValue: Currency): TModelPedidoLista;
begin
  Result := Self;
  FItensPedido.Desconto.Valor := AValue;
end;

function TModelPedidoLista.SetValorUnitatio(
  const AValue: Currency): TModelPedidoLista;
begin
  Result := Self;
  FItensPedido.ValorUnitatio := AValue;
end;

end.
