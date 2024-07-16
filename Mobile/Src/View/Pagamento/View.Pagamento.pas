unit View.Pagamento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Ani,
  FMX.Effects, FMX.Filter.Effects, Model.Utils,RESTRequest4D, System.JSON,
  View.Pagamento.Teclado.Dinheiro, Model.Pagamento.Recebimento,
  Model.Records.Tipo.Pagamento, Helper.Scroll, Frame.Pagamento.Recebimento.Formas,
  Model.Pedido.Gerar.Pedido, Model.Pagamento.Pedido, View.Pagamento.Teclado.Pix,
  Model.Static.Credencial, Model.Records.Pagamento.Pedido,
  Frame.Pagamento.Cartao.Opcoes.Parcelamento, Frame.Pagamento.Cartao,
  Model.Connection, DAO.Pedido.Pagamento, DAO.Carrinho.Pagamento,
  System.Generics.Collections, Frame.Pagamento.Salvar.Dados, Model.Enums;

type
  TViewPagamento = class(TViewBase)
    recToolbar: TRectangle;
    Label4: TLabel;
    imgVoltar: TImage;
    FillRGBEffect1: TFillRGBEffect;
    layFormasPagamento: TLayout;
    Rectangle3: TRectangle;
    Layout2: TLayout;
    Label1: TLabel;
    lblDescontoVenda: TLabel;
    Layout3: TLayout;
    Label2: TLabel;
    lblSubTotal: TLabel;
    Layout4: TLayout;
    Label6: TLabel;
    lblTotalResumo: TLabel;
    ScrollBoxPagamento: TScrollBox;
    Line1: TLine;
    layTotalPago: TLayout;
    Label5: TLabel;
    lblTotalPago: TLabel;
    layFaltaPagar: TLayout;
    Label8: TLabel;
    lblFaltaPagar: TLabel;
    layTroco: TLayout;
    Label10: TLabel;
    lblTroco: TLabel;
    recDinheiro: TRectangle;
    Layout8: TLayout;
    Label12: TLabel;
    Image1: TImage;
    FramePagamentoTecladoDinheiro1: TFramePagamentoTecladoDinheiro;
    btnFinalizar: TRectangle;
    Label3: TLabel;
    ShadowEffect1: TShadowEffect;
    recPix: TRectangle;
    Layout5: TLayout;
    Label7: TLabel;
    Image2: TImage;
    recCartao: TRectangle;
    Layout6: TLayout;
    Label9: TLabel;
    Image3: TImage;
    recCrediario: TRectangle;
    Layout7: TLayout;
    Label11: TLabel;
    Image4: TImage;
    FramePagamentoTecladoPix1: TFramePagamentoTecladoPix;
    layDinehiroCartao: TLayout;
    layCrediarioPix: TLayout;
    FramePagamentoCartao1: TFramePagamentoCartao;
    FramePagamentoCartaoOpcoesParcelamento1: TFramePagamentoCartaoOpcoesParcelamento;
    Line2: TLine;
    procedure imgVoltarClick(Sender: TObject);
    procedure recDinheiroClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
    procedure recPixClick(Sender: TObject);
    procedure recCartaoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
  private
    FSubtotal:Currency;
    FTotal:Currency;
    FDesconto:Currency;
    FTroco:Currency;
    FFaltaPagar:Currency;
    FTotalPago:Currency;
    FListaRecebimento:TModelPagamentoRecebimento;
    FEventoFinalizarPedido: TProc<TObject>;
    FModelPagamentoPedido:TModelPagamentoPedido;
    FIdCartaoSelecionado:String;
    FJsonArrayTiposPagamento:TJSONArray;
    FPedidoId:Integer;
    FDAOPedidoPagamento:TDAOPedidoPagamento;
    FDAOCarrinhoPagamento:TDAOCarrinhoPagamento;
    FTipoRecebimento:TPedidoNegociacao;
    FSalvarServido:Boolean;
    FAtualizarApi: TProc<Boolean>;
    procedure AtualizarPagamentoPedidoMesa;
    procedure AtualizarPagamentoPedido;
    procedure RecalcularValores;
    procedure SetTotalPago(const AValue:Currency);
    procedure SetFaltaPagar(const AValue:Currency);
    procedure SetTroco(const AValue:Currency);
    procedure OnClickConfirmarPagamentoDinheiro(Sender:TObject);
    procedure OnClicConfirmarPagamentoCartao(Sender:TObject);
    procedure OnClickConfirmarPagamentoPix(Sender:TObject);
    procedure OnClickConfirmarCartao(Sender:TObject);
    procedure OnClickConfirmarOpcoesParcelamento(AValue:string);
    procedure EventoParaRemoverItemDaListaDeRecebimento(Sender:TObject);
    procedure SetPedidoId(const Value: Integer);
    procedure EventoAposAdicionarPagamentoPedido(AItemPagamento:TItemPagamento);
    procedure EventosAntesDeRemoverItemPagamento(AItemPagamento:TItemPagamento);
  public
    property TipoRecebimento:TPedidoNegociacao read FTipoRecebimento write FTipoRecebimento;
    property PedidoId:Integer read FPedidoId write SetPedidoId;
    procedure BuscarTiposPagamento;
    procedure ExecuteOnShow; override;
    procedure SetSubtotal(const Avalue:Currency);overload;
    procedure SetTotal(const AValue:Currency);
    procedure SetDesconto(const Avalue:Currency);
    property EventoFinalizarPedido:TProc<TObject> read FEventoFinalizarPedido write FEventoFinalizarPedido;
    property Subtotal:Currency read FSubtotal;
    property Total:Currency read FTotal;
    property Desconto:Currency read FDesconto;
    property Troco:Currency read FTroco;
    property FaltaPagar:Currency read FFaltaPagar;
    property TotalPagdo:Currency read  FTotalPago;
    property AtualizarApi:TProc<Boolean> read FAtualizarApi write FAtualizarApi;
  end;


implementation

{$R *.fmx}

{ TViewPagamento }

procedure TViewPagamento.AtualizarPagamentoPedido;
begin
  FListaRecebimento.EventoAposAdicionarItem := nil;
  var LListaCarrinhoPagamento := FDAOCarrinhoPagamento.ListaPagamento;
  try
    for var I := 0 to Pred(LListaCarrinhoPagamento.Count) do
    begin
      FListaRecebimento
       .SetValorPago(LListaCarrinhoPagamento[i].QuantiaPaga);

      var LTitpoPagamento:TTipoPagamento;
      if Assigned(FJsonArrayTiposPagamento) then
      begin
        for var X := 0 to Pred(FJsonArrayTiposPagamento.Count) do
        begin
          var LJsonObject := TJSONObject(FJsonArrayTiposPagamento.Items[X]);
          if LJsonObject.GetValue<string>('id','') =  LListaCarrinhoPagamento[i].PagamentoId then
          begin
            LTitpoPagamento.Id   := LJsonObject.GetValue<string>('id','');
            LTitpoPagamento.Nome := LJsonObject.GetValue<string>('description','');
            var LJsonArrayPosPayment := LJsonObject.GetValue<TJSONArray>('posPayment',nil);
            if Assigned(LJsonArrayPosPayment) then
            begin
              LTitpoPagamento.JsonArrayString := LJsonArrayPosPayment.ToJSON();
            end;
            Break
          end;
        end;
      end;

       FListaRecebimento.SetTipoPagamento(LTitpoPagamento)
       .AdicionarLista;
    end;
  finally
    LListaCarrinhoPagamento.Clear;
    FreeAndNil(LListaCarrinhoPagamento);
  end;
  FListaRecebimento.EventoAposAdicionarItem := Self.EventoAposAdicionarPagamentoPedido;
  RecalcularValores;
end;

procedure TViewPagamento.AtualizarPagamentoPedidoMesa;
begin
  if FPedidoId > 0 then
  begin
    FListaRecebimento.EventoAposAdicionarItem := nil;
    // Busca do banco de dados local tabela de ORDER_PAYMENT
    // Buscando dados do pagamento pelo id do pedido
    var LListaPedidoPagamento := FDAOPedidoPagamento.ListaPagamentoPorPedido(FPedidoId);
    try
      // Está incrementando em um lista que é usada em memoria para as duas tabelas
      // cart_payment e order_payment
      for var I := 0 to Pred(LListaPedidoPagamento.Count) do
      begin

        FListaRecebimento
         .SetSalvoNaApi(LListaPedidoPagamento[i].SalvoNoBanco)
         .SetValorPago(LListaPedidoPagamento[i].QuantiaPaga)
         .SetIdBancoDados(LListaPedidoPagamento[i].Id);

        var LTitpoPagamento:TTipoPagamento;
        if Assigned(FJsonArrayTiposPagamento) then
        begin
          for var X := 0 to Pred(FJsonArrayTiposPagamento.Count) do
          begin
            var LJsonObject := TJSONObject(FJsonArrayTiposPagamento.Items[X]);
            if LJsonObject.GetValue<string>('id','') =  LListaPedidoPagamento[i].PagamentoId then
            begin
              LTitpoPagamento.Id   := LJsonObject.GetValue<string>('id','');
              LTitpoPagamento.Nome := LJsonObject.GetValue<string>('description','');
              LTitpoPagamento.JsonArrayString := LJsonObject.GetValue<string>('posPayment','');
              Break
            end;
          end;
        end;

         FListaRecebimento.SetTipoPagamento(LTitpoPagamento)
         .AdicionarLista;
      end;
    finally
      LListaPedidoPagamento.Clear;
      FreeAndNil(LListaPedidoPagamento);
    end;
  end;
  FListaRecebimento.EventoAposAdicionarItem := Self.EventoAposAdicionarPagamentoPedido;
  FListaRecebimento.EventoAntesDeRemoverItemPorSequencial := EventosAntesDeRemoverItemPagamento;
  RecalcularValores;
end;

procedure TViewPagamento.btnFinalizarClick(Sender: TObject);
begin
  inherited;
  ModelConnection.Connection.StartTransaction;
  try
    var LModelPedido := TModelPedidoGerarPedido.Create(ModelConnection.Connection);
    try
      LModelPedido.GerarPedido;
      ModelConnection.Connection.Commit;
      TThread.Synchronize(nil,
      procedure
      begin
        CloseLoad;
        if Assigned(FEventoFinalizarPedido) then
          FEventoFinalizarPedido(Self);
        Close;
      end)
    finally
      FreeAndNil(LModelPedido);
    end;
  except on E: Exception do
    begin
      ModelConnection.Connection.Rollback;
      ShowErro(e.Message);
      Exit;
    end;
  end;
end;

procedure TViewPagamento.BuscarTiposPagamento;
begin
  OpenLoad;
  TThread.CreateAnonymousThread(
  procedure
  var
    LResponse: IResponse;
  begin
    try
      LResponse := TRequest.New.BaseURL(BaseURL)
        .Resource('type-of-payment/pos-payment')
        .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
        .Accept('application/json')
        .Get;

      TThread.Synchronize(nil,
      procedure
      begin
        CloseLoad;
        var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
        try
          // Verificando o status code
          if LResponse.StatusCode <> 200 then
          begin
            // Tratando o erro
            ShowErro(LJsonResponse.GetValue<string>('error','Erro não identificado! '+LResponse.Content));
            Exit; // Se der erro ele sai fora e não abre a próxima tela
          end;

          if Assigned(FJsonArrayTiposPagamento) then
            FreeAndNil(FJsonArrayTiposPagamento);

          FJsonArrayTiposPagamento := TJSONObject.ParseJSONValue(LJsonResponse.GetValue<TJSONArray>('data').ToJSON) as TJSONArray;

          if FPedidoId > 0 then
            AtualizarPagamentoPedidoMesa
          else
            AtualizarPagamentoPedido;
        finally
          LJsonResponse.Free;
        end;
        CloseLoad;
      end);

    except on E: Exception do
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          ShowErro(E.Message);
        end);
      end;
    end;

  end).Start;
end;


procedure TViewPagamento.SetDesconto(const Avalue: Currency);
begin
  FDesconto := Avalue;
  lblDescontoVenda.Text := '- R$ '+FormatFloat('#,##0.00',FDesconto);
end;

procedure TViewPagamento.EventoAposAdicionarPagamentoPedido(AItemPagamento: TItemPagamento);
begin
  if TipoRecebimento = tpMesa then
  begin
    FSalvarServido := True;
    FDAOPedidoPagamento.Dados.PedidoId    := FPedidoId;
    FDAOPedidoPagamento.Dados.QuantiaPaga := AItemPagamento.Valor;
    FDAOPedidoPagamento.Dados.PagamentoId := AItemPagamento.TipoPagamento.Id;
    FDAOPedidoPagamento.Gravar;
    FListaRecebimento.AlterarIdBancoPorSequencial(AItemPagamento.Sequencial,FDAOPedidoPagamento.Dados.Id);
  end
  else
  begin
    FDAOCarrinhoPagamento.Dados.PedidoId    := 0;
    FDAOCarrinhoPagamento.Dados.QuantiaPaga := AItemPagamento.Valor;
    FDAOCarrinhoPagamento.Dados.PagamentoId := AItemPagamento.TipoPagamento.Id;
    FDAOCarrinhoPagamento.Gravar;
  end;
end;

procedure TViewPagamento.EventoParaRemoverItemDaListaDeRecebimento(
  Sender: TObject);
begin
  if Sender is TFramePagamentoRecebimentoFormas then
  begin
    try
      var LFrame := TFramePagamentoRecebimentoFormas(Sender);
      // Esse metodo abaixo vai chamar EventosAntesDeRemoverItemPagamento
      FListaRecebimento.RemoverItemPorSequencial(LFrame.Sequencial);
      RecalcularValores;
    except on E: Exception do
      begin
        ShowErro(e.Message)
      end;
    end;
  end;
end;

procedure TViewPagamento.EventosAntesDeRemoverItemPagamento(
  AItemPagamento: TItemPagamento);
begin
  if FPedidoId > 0 then
  begin
    FDAOPedidoPagamento.RemoverPorId(AItemPagamento.IdBancoDados);
  end;
end;

procedure TViewPagamento.ExecuteOnShow;
begin
  inherited;
  BuscarTiposPagamento;
  FSalvarServido := False;
end;

procedure TViewPagamento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Assigned(FAtualizarApi) then
    FAtualizarApi(FSalvarServido);
  FModelPagamentoPedido.Gravar;
end;

procedure TViewPagamento.FormCreate(Sender: TObject);
begin
  inherited;
  FDAOPedidoPagamento   := TDAOPedidoPagamento.Create(ModelConnection.Connection);
  FDAOCarrinhoPagamento := TDAOCarrinhoPagamento.Create(ModelConnection.Connection);
  FListaRecebimento     := TModelPagamentoRecebimento.Create;
  FModelPagamentoPedido := TModelPagamentoPedido.Create;
  FTotalPago  := 0;
  FSubtotal   := 0;
  FDesconto   := 0;
  FTotal      := 0;
  FFaltaPagar := 0;
  FTotalPago  := 0;
end;

procedure TViewPagamento.FormDestroy(Sender: TObject);
begin
  if Assigned(FJsonArrayTiposPagamento) then
    FreeAndNil(FJsonArrayTiposPagamento);
  FreeAndNil(FDAOCarrinhoPagamento);
  FreeAndNil(FModelPagamentoPedido);
  FreeAndNil(FListaRecebimento);
  FreeAndNil(FDAOPedidoPagamento);
  inherited;
end;

procedure TViewPagamento.FormResize(Sender: TObject);
begin
  inherited;
  recDinheiro.Width  := (layDinehiroCartao.Width - 40) / 2;
  recCartao.Width    := recDinheiro.Width;
  recPix.Width       := recDinheiro.Width;
  recCrediario.Width := recDinheiro.Width;
end;

procedure TViewPagamento.imgVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TViewPagamento.OnClickConfirmarOpcoesParcelamento(AValue: string);
begin
  ShowSucesso('Chamada da maquina de cartão de crédito: '+AValue);
  Exit;
  FramePagamentoTecladoPix1.OnClickConfirmar := OnClicConfirmarPagamentoCartao;
  FramePagamentoTecladoPix1.FaltaPagar(FFaltaPagar);
  FramePagamentoTecladoPix1.OpenPix;
end;

procedure TViewPagamento.OnClicConfirmarPagamentoCartao(Sender: TObject);
begin
  if Sender is TFramePagamentoTecladoPix then
  begin
    var LValorDinheiro := TFramePagamentoTecladoPix(Sender).Valor;
    FTotalPago := FTotalPago + LValorDinheiro;
    SetTotalPago(FTotalPago);

    var LTitpoPagamento:TTipoPagamento;
    LTitpoPagamento.Clear;
    for var I := 0 to Pred(FJsonArrayTiposPagamento.Count) do
    begin
      var LJsonObject := TJSONObject(FJsonArrayTiposPagamento.Items[I]);
      if LJsonObject.GetValue<string>('id','').Equals(FIdCartaoSelecionado) then
      begin
        LTitpoPagamento.Id   := LJsonObject.GetValue<string>('id','');
        LTitpoPagamento.Nome := LJsonObject.GetValue<string>('description','');
        var LArrayPosPayment := LJsonObject.GetValue<TJSONArray>('posPayment',nil);
        if Assigned(LArrayPosPayment) then
        begin
          LTitpoPagamento.JsonArrayString := LArrayPosPayment.ToJSON;
        end;
        Break
      end;
    end;

    FListaRecebimento
      .SetSalvoNaApi(False)
      .SetValorPago(LValorDinheiro)
      .SetTipoPagamento(LTitpoPagamento)
      .AdicionarLista;
    RecalcularValores;
  end;
end;

procedure TViewPagamento.OnClickConfirmarCartao(Sender:TObject);
begin
  if Sender is TFramePagamentoCartao then
  begin
    FIdCartaoSelecionado := TFramePagamentoCartao(Sender).IdCartaoSelecionado;
    {$IFDEF MOBILE}
    FramePagamentoTecladoPix1.OnClickConfirmar := OnClicConfirmarPagamentoCartao;
    FramePagamentoTecladoPix1.FaltaPagar(FFaltaPagar);
    FramePagamentoTecladoPix1.OpenPix;
    {$ELSE}
    // Aqui a validação das maquininhas
    // para saber se o item tem uma tela antes de chamar o teclado
    var LObjetoFormapagamento:TJSONObject;
    for var I := 0 to Pred(FJsonArrayTiposPagamento.Count) do
    begin
      LObjetoFormapagamento := FJsonArrayTiposPagamento.Items[i] as TJSONObject;
      if LObjetoFormapagamento.GetValue<string>('id','').Equals(FIdCartaoSelecionado) then
      begin
        Break;
      end;
    end;

    var LJsonArrayPosPagamento := LObjetoFormapagamento.GetValue<TJSONArray>('posPayment',nil);
    if Assigned(LJsonArrayPosPagamento) and (LJsonArrayPosPagamento.Count > 0) then
    begin
      FramePagamentoCartaoOpcoesParcelamento1.OnClickItemOpcao := OnClickConfirmarOpcoesParcelamento;
      FramePagamentoCartaoOpcoesParcelamento1.CarregarOpcoes(LObjetoFormapagamento.GetValue<TJSONArray>('posPayment',nil));
      FramePagamentoCartaoOpcoesParcelamento1.OpenCartaoOpcao;
    end
    else
    begin
      FramePagamentoTecladoPix1.OnClickConfirmar := OnClicConfirmarPagamentoCartao;
      FramePagamentoTecladoPix1.FaltaPagar(FFaltaPagar);
      FramePagamentoTecladoPix1.OpenPix;
    end;

    {$ENDIF}

  end;
end;

procedure TViewPagamento.OnClickConfirmarPagamentoDinheiro(Sender: TObject);
begin
  if Sender is TFramePagamentoTecladoDinheiro then
  begin
    var LValorDinheiro := TFramePagamentoTecladoDinheiro(Sender).Valor;
    FTotalPago := FTotalPago + LValorDinheiro;
    SetTotalPago(FTotalPago);

    // Como o dinehiro é fixo vou buscar por code
    var LTitpoPagamento:TTipoPagamento;
    for var I := 0 to Pred(FJsonArrayTiposPagamento.Count) do
    begin
      var LJsonObject := TJSONObject(FJsonArrayTiposPagamento.Items[I]);
      if LJsonObject.GetValue<Integer>('code',0) =  1 then
      begin
        LTitpoPagamento.Id   := LJsonObject.GetValue<string>('id','');
        LTitpoPagamento.Nome := LJsonObject.GetValue<string>('description','');
        LTitpoPagamento.JsonArrayString := LJsonObject.GetValue<string>('posPayment','');
        Break
      end;
    end;

    FListaRecebimento
      .SetSalvoNaApi(False)
      .SetValorPago(LValorDinheiro)
      .SetTipoPagamento(LTitpoPagamento)
      .AdicionarLista;
    RecalcularValores;
  end;
end;

procedure TViewPagamento.OnClickConfirmarPagamentoPix(Sender: TObject);
begin
  if Sender is TFramePagamentoTecladoPix then
  begin
    var LValorPix := TFramePagamentoTecladoPix(Sender).Valor;
    FTotalPago    := FTotalPago + LValorPix;
    SetTotalPago(FTotalPago);

    // Como o Pix var ser fixo a busca é pelo Code
    var LTitpoPagamento:TTipoPagamento;
    for var I := 0 to Pred(FJsonArrayTiposPagamento.Count) do
    begin
      var LJsonObject := TJSONObject(FJsonArrayTiposPagamento.Items[I]);
      if LJsonObject.GetValue<Integer>('code',0) =  20 then
      begin
        LTitpoPagamento.Id   := LJsonObject.GetValue<string>('id','');
        LTitpoPagamento.Nome := LJsonObject.GetValue<string>('description','');
        LTitpoPagamento.JsonArrayString := LJsonObject.GetValue<string>('posPayment','');
        Break
      end;
    end;

    FListaRecebimento
      .SetSalvoNaApi(False)
      .SetValorPago(LValorPix)
      .SetTipoPagamento(LTitpoPagamento)
      .AdicionarLista;
    RecalcularValores;
  end;
end;

procedure TViewPagamento.RecalcularValores;
begin
  ScrollBoxPagamento.ClearItems;
  var LTop:Single         := 0;
  var LValorPago:Currency := 0;

  if TipoRecebimento = tpPedido then
  begin
    FModelPagamentoPedido.LimparLista;
  end;

  for var I := 0 to Pred(FListaRecebimento.Lista.Count) do
  begin
    var LFrame                         := TFramePagamentoRecebimentoFormas.Create(nil);
    LFrame.Parent                      := ScrollBoxPagamento;
    LFrame.Align                       := TAlignLayout.None;
    LFrame.Sequencial                  := FListaRecebimento.Lista[i].Sequencial;
    LFrame.TipoPagamento               := FListaRecebimento.Lista[i].TipoPagamento;
    LFrame.ValorPago                   := FListaRecebimento.Lista[i].Valor;
    LFrame.OnClicRemoverFormaPagamento := Self.EventoParaRemoverItemDaListaDeRecebimento;
    LFrame.Position.Y                  := LTop;
    LFrame.Position.X                  := 0;
    LFrame.Width                       := ScrollBoxPagamento.Width;
    LTop                               := LTop + LFrame.Height;
    LValorPago                         := LValorPago + FListaRecebimento.Lista[I].Valor;

    if TipoRecebimento = tpPedido then // Vai salvar dados no carrinho
    begin
      var LPagamentoPedido:TPagamentoPedido;
      LPagamentoPedido.ValorPago := FListaRecebimento.Lista[i].Valor;
      LPagamentoPedido.PaymentId := FListaRecebimento.Lista[i].TipoPagamento.Id;
      FModelPagamentoPedido.AddItem(LPagamentoPedido);
    end
    else
    begin

    end;
  end;
  SetTotalPago(LValorPago);
end;

procedure TViewPagamento.recDinheiroClick(Sender: TObject);
begin
  inherited;
  FramePagamentoTecladoDinheiro1.OpenDinheiro;
  FramePagamentoTecladoDinheiro1.OnClickConfirmar := OnClickConfirmarPagamentoDinheiro;
  FramePagamentoTecladoDinheiro1.FaltaPagar(FFaltaPagar);
end;


procedure TViewPagamento.recPixClick(Sender: TObject);
begin
  inherited;
  FramePagamentoTecladoPix1.OpenPix;
  FramePagamentoTecladoPix1.OnClickConfirmar := OnClickConfirmarPagamentoPix;
  FramePagamentoTecladoPix1.FaltaPagar(FFaltaPagar);
end;

procedure TViewPagamento.recCartaoClick(Sender: TObject);
begin
  inherited;
  FramePagamentoCartao1.CarregarDadosCartao(FJsonArrayTiposPagamento);
  FramePagamentoCartao1.OnClickConfirmar := OnClickConfirmarCartao;
  FramePagamentoCartao1.OpenSelecionarCartao;
end;

procedure TViewPagamento.SetFaltaPagar(const AValue: Currency);
begin
  FFaltaPagar := AValue;
  recDinheiro.Enabled  := not(FFaltaPagar <= 0);
  recPix.Enabled       := not(FFaltaPagar <= 0);
  recCartao.Enabled    := not(FFaltaPagar <= 0);
  recCrediario.Enabled := not(FFaltaPagar <= 0);
  lblFaltaPagar.Text   := 'R$ '+FormatFloat('#,##0.00',FFaltaPagar);
end;

procedure TViewPagamento.SetPedidoId(const Value: Integer);
begin
  FPedidoId := Value;

end;

procedure TViewPagamento.SetTotalPago(const AValue: Currency);
begin
  FTotalPago            := AValue;
  lblTotalPago.Text     := 'R$ '+FormatFloat('#,##0.00',FTotalPago);
  var LRestante         := FTotal - FTotalPago;
  layFaltaPagar.Visible := LRestante >= 0;
  layTroco.Visible      := not layFaltaPagar.Visible;

  SetFaltaPagar(LRestante);
  SetTroco(Abs(LRestante));
  btnFinalizar.Enabled := FTotalPago >= FTotal;
end;

procedure TViewPagamento.SetTroco(const AValue: Currency);
begin
  FTroco := Avalue;
  lblTroco.Text := 'R$ '+FormatFloat('#,##0.00',FTroco);
end;

procedure TViewPagamento.SetSubtotal(const Avalue: Currency);
begin
  FSubtotal := Avalue;
  lblSubTotal.Text := 'R$ '+FormatFloat('#,##0.00',FSubtotal);
end;

procedure TViewPagamento.SetTotal(const AValue: Currency);
begin
  FTotal := Avalue;
  SetFaltaPagar(AValue);
  lblTotalResumo.Text := 'R$ '+FormatFloat('#,##0.00',FTotal);
end;

end.

