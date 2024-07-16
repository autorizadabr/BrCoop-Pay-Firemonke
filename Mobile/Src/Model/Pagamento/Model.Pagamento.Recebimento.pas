unit Model.Pagamento.Recebimento;

interface

uses
  Model.Records.Tipo.Pagamento,
  System.SysUtils,
  System.Generics.Collections;

  type
  TItemPagamento = record
    SalvoNaApi:Boolean;
    IdBancoDados:Integer;
    Sequencial:Integer;
    TipoPagamento:TTipoPagamento;
    Valor:Currency;
    procedure Clear;
  end;
  TModelPagamentoRecebimento = class
    private
      FListaPagamento:TList<TItemPagamento>;
      FItemPagamento:TItemPagamento;
    FEventoAposAdicionarItem: TProc<TItemPagamento>;
    FEventoAntesDeRemoverItemPorSequencial: TProc<TItemPagamento>;
    public
    constructor Create;
    destructor Destroy;override;
    function SetSalvoNaApi(const AValue:Boolean):TModelPagamentoRecebimento;
    function SetIdBancoDados(const AValue:Integer):TModelPagamentoRecebimento;
    function SetTipoPagamento(AValue:TTipoPagamento):TModelPagamentoRecebimento;
    function SetValorPago(const AValue:Currency):TModelPagamentoRecebimento;
    procedure RemoverItemPorSequencial(const ASequecial:Integer);
    procedure AlterarIdBancoPorSequencial(const ASequecial,AIdBancoDados:Integer);
    procedure AdicionarLista;
    function Lista:TList<TItemPagamento>;
    property EventoAposAdicionarItem:TProc<TItemPagamento> read FEventoAposAdicionarItem write FEventoAposAdicionarItem;
    property EventoAntesDeRemoverItemPorSequencial:TProc<TItemPagamento> read FEventoAntesDeRemoverItemPorSequencial write FEventoAntesDeRemoverItemPorSequencial;
  end;
implementation

{ TModelPagamentoRecebimento }

procedure TModelPagamentoRecebimento.AdicionarLista;
begin
  FListaPagamento.Add(FItemPagamento);
  if Assigned(FEventoAposAdicionarItem) then
    FEventoAposAdicionarItem(FItemPagamento);  
  FItemPagamento.Sequencial := FItemPagamento.Sequencial + 1;
end;

procedure TModelPagamentoRecebimento.AlterarIdBancoPorSequencial(const ASequecial,AIdBancoDados:Integer);
begin
  for Var I := 0 to Pred(FListaPagamento.Count) do
  begin
    if FListaPagamento[I].Sequencial = ASequecial then
    begin
      var LItem := FListaPagamento[I];
      LItem.IdBancoDados := AIdBancoDados;
      FListaPagamento[I] := LItem;
      Break;
    end;
  end;
end;

constructor TModelPagamentoRecebimento.Create;
begin
  FListaPagamento := TList<TItemPagamento>.Create;
  FItemPagamento.Sequencial := 1;
end;

destructor TModelPagamentoRecebimento.Destroy;
begin
  FreeAndNil(FListaPagamento);
  inherited;
end;

function TModelPagamentoRecebimento.Lista: TList<TItemPagamento>;
begin
  Result := FListaPagamento;
end;

procedure TModelPagamentoRecebimento.RemoverItemPorSequencial(
  const ASequecial: Integer);
begin
  for Var I := 0 to Pred(FListaPagamento.Count) do
  begin
    if FListaPagamento[I].Sequencial = ASequecial then
    begin
      if FListaPagamento[I].SalvoNaApi then
        raise Exception.Create('Pagamento não pode ser removido!');
      if Assigned(FEventoAntesDeRemoverItemPorSequencial) then
        FEventoAntesDeRemoverItemPorSequencial(FListaPagamento[I]);
      FListaPagamento.Delete(i);
      Break;
    end;
  end;
end;

function TModelPagamentoRecebimento.SetIdBancoDados(
  const AValue: Integer): TModelPagamentoRecebimento;
begin
  Result := Self;
  FItemPagamento.IdBancoDados := AValue;
end;

function TModelPagamentoRecebimento.SetSalvoNaApi(
  const AValue: Boolean): TModelPagamentoRecebimento;
begin
  Result := Self;
  FItemPagamento.SalvoNaApi := AValue;
end;

function TModelPagamentoRecebimento.SetTipoPagamento(
  AValue: TTipoPagamento): TModelPagamentoRecebimento;
begin
  Result := Self;
  FItemPagamento.TipoPagamento := AValue;
end;

function TModelPagamentoRecebimento.SetValorPago(
  const AValue: Currency): TModelPagamentoRecebimento;
begin
  Result := Self;
  FItemPagamento.Valor := AValue;
end;

{ TItemPagamento }

procedure TItemPagamento.Clear;
begin
  SalvoNaApi := False;
  TipoPagamento.Clear;
  Valor := 0;
end;

end.
