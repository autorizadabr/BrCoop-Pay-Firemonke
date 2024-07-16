unit View.Pedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, System.JSON,
  RESTRequest4D, Model.Static.Credencial,Frame.Item.Produto.Pedido,
  View.Selecionar.Produto.Pedido, FMX.Effects, FMX.Filter.Effects,FMX.Ani,
  Frame.Item.Categoria, FMX.TabControl,System.Generics.Collections,
  Model.Pedido.Lista, Frame.Resumo.Item, Model.Utils,View.Pagamento,
  View.Componentes.Teclado.Quantidade, View.Componentes.Teclado.ValorUnitario,
  Frame.Resumo.Opcoes, View.Componentes.Teclado.Desconto,Model.Sincronizacao,
  Frame.Resumo.Observacao, Frame.Resumo.Deletar.Item, Model.Carrinho,
  Model.Connection, Model.Carrinho.Item, Model.Pedido.Dados.Item,
  Constantes.Color, DAO.Pedido, Model.Records.Pedido.Mesa,
  Model.Records.Item.Pedido, DAO.Pedido.Item, Frame.Pagamento.Vendedor,
  Frame.Pagamento.Salvar.Dados, Frame.Pedido.Comanda, Model.Enums;
type
  TViewPedido = class(TViewBase)
    ScrollBox: TVertScrollBox;
    recToolbar: TRectangle;
    lblCaption: TLabel;
    imgVoltar: TImage;
    FillRGBEffect1: TFillRGBEffect;
    HorzScrollBox: THorzScrollBox;
    TabControl: TTabControl;
    tabProdutos: TTabItem;
    tabResumo: TTabItem;
    recProdutosResumo: TRectangle;
    layProdutoResumo: TLayout;
    laySublinhado: TLayout;
    recPesquisaCamera: TRectangle;
    Image1: TImage;
    Image2: TImage;
    recSublinhado: TRectangle;
    lblProdutos: TLabel;
    lblResumo: TLabel;
    recQuanidadeAdicionar: TRectangle;
    RoundRect1: TRoundRect;
    RoundRect2: TRoundRect;
    lblQuantidadeAdicionar: TLabel;
    Image3: TImage;
    Image4: TImage;
    recQuantidadeResumo: TRoundRect;
    lblQuantidadeResumo: TLabel;
    recContentScrollResumo: TRectangle;
    Layout2: TLayout;
    Label1: TLabel;
    lblDescontoVendaResumo: TLabel;
    Layout3: TLayout;
    Label4: TLabel;
    lblSubTotal: TLabel;
    Layout4: TLayout;
    Label6: TLabel;
    lblTotalResumo: TLabel;
    ScrollBoxResumo: TScrollBox;
    ShadowEffect1: TShadowEffect;
    btnPagamento: TRectangle;
    Label5: TLabel;
    FrameComponentesTecladoValorUnitario1: TFrameComponentesTecladoValorUnitario;
    FrameComponentesTecladoDesconto1: TFrameComponentesTecladoDesconto;
    FrameResumoOpcoes1: TFrameResumoOpcoes;
    FrameComponentesTecladoQuantidade1: TFrameComponentesTecladoQuantidade;
    FrameResumoObservacao1: TFrameResumoObservacao;
    FrameResumoDeletarItem1: TFrameResumoDeletarItem;
    recBaseProduto: TRectangle;
    recMesaComanda: TRoundRect;
    lblMesaComanda: TLabel;
    layButoes: TLayout;
    btnSalvar: TRectangle;
    Label2: TLabel;
    FramePagamentoVendedor1: TFramePagamentoVendedor;
    FramePagamentosSalvarDados1: TFramePagamentosSalvarDados;
    FramePedidoComanda1: TFramePedidoComanda;
    recContentResumo: TRectangle;
    Line2: TLine;
    procedure imgVoltarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lblProdutosClick(Sender: TObject);
    procedure lblResumoClick(Sender: TObject);
    procedure btnPagamentoClick(Sender: TObject);
    procedure recQuanidadeAdicionarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    const LIMIT = 200;
    var
    FPedidoNegociacao: TPedidoNegociacao;
    FAtualizarMesas: TProc;
    FViewPagamento:TViewPagamento;
    FListaFrameProdutos:TObjectList<TFrameItemProdutoPedido>;
    FModelPedidoLista:TModelPedidoLista;
    FSubtotal:Currency;
    FTotal:Currency;
    FDesconto:Currency;
    FPedidoMesa:TPedidoMesa;
    FDAOPedido:TDAOPedido;
    FPrimeiroItemSemSalvarProduto:Boolean;
    FQuantidadeProdutoNaoSalvo:Integer;
    procedure AdicionarProdutoPedido(
    const AFrame: TFrameItemProdutoPedido; const ADadosPedidoItem:TDadosProdutoItem; const AAdicionarProdutoManul:Boolean = True);
    procedure AdicionarProdutoComValorZerado(Sender,AFrameProdutoClicado:TObject);
    procedure OnClickItemOpcoesResumo(Sender:TObject);
    procedure OnClickItemProduto(Sender:TObject);
    procedure EventoOnClickItemCategoria(Sender:TObject);
    // Eventos de Opções do Resumo
    procedure ConfigurarEventoDeClickOpcoesResumo;
    //  Resumo Quantidade Item
    procedure OnClickResumoOpcoesQuantidade(Sender:TObject);
    procedure OnClickConfirmarQuantidadeDoResumo(Sender:TObject);
    //  Resumo Desconto Item
    procedure OnClickResumoOpcoesDesconto(Sender:TObject);
    procedure OnClickConfirmarDescontoDoResumo(Sender:TObject);
    //  Resumo Observacao Item
    procedure OnClickResumoOpcoesObservacao(Sender:TObject);
    procedure OnClickConfirmarObservacaoDoResumo(Sender:TObject);
    //  Resumo Deletar Item
    procedure OnClickResumoOpcoesDeletarItem(Sender:TObject);
    procedure OnClickConfirmarDeletarItemResumo(Sender:TObject);
    // Comanda
    procedure OnClickResumoOpcoesComandaItem(Sender:TObject);
    procedure OnClickConfirmarComandaItemResumo(Sender:TObject);

    // Eventos de Opções do Resumo
    procedure RecalcularProdutosSelecionados;
    procedure CarregarDadosDoBancoDeDados; // Acessando banco de dados
    procedure CarregarDadosDoBancoDeDadosMesa(const AOrderId:Integer);
    procedure AtualizarCarrinhoBancoDados; // Acessando banco de dados PEDIDO
    procedure AlterarValoresProdutosSelecionadosResumo(
  const ASubtotal,ADesconto: Currency); // Altera os label da parte de resumo
    procedure AlterarQuantidadeProdutosSelecionadosResumo(const AQuantidade:Integer); // Altera o circulo de quantidade de itens no resumo
    procedure LimparCategoriaSelecionada;
    procedure AtualizarCaptionMesa(const ANumero:Integer; const AMesaLivre:Boolean);
    procedure CarregarDadosListaCategoria(const AJsonArray:TJSONArray);
    procedure BuscarCategorias;
    procedure EventoAtualizarValorQuantidade(Sender:TObject);
    procedure EventoFinalizarPagamento(Sender:TObject);
    procedure EventoDepoisDeAdicionarProduto(AItemPedido:TModelItemPedido);
    procedure EventoDepoisDeAlterarQuantidadeProduto(AItemPedido:TModelItemPedido);
    procedure EventoDepoisDeAlterarDescontoProduto(AItemPedido:TModelItemPedido);
    procedure EventoDepoisDeAlterarObservacaoProduto(AItemPedido:TModelItemPedido);
    procedure AtualizarAPI(AValue:Boolean);
    procedure Salvar;
    procedure LimparListaResumo;
  public
    property PedidoNegociacao:TPedidoNegociacao read FPedidoNegociacao write FPedidoNegociacao;
    property AtualizarMesas:TProc read FAtualizarMesas write FAtualizarMesas;
    procedure ExecuteOnShow; override;
    procedure Mesa(const ANumero:Integer);
  end;

implementation

{$R *.fmx}

{ TViewPedido }

procedure TViewPedido.AdicionarProdutoComValorZerado(Sender,
  AFrameProdutoClicado: TObject);
begin
  if (Sender is TFrameComponentesTecladoValorUnitario) then
  begin
     if (AFrameProdutoClicado is TFrameItemProdutoPedido) then
     begin
       var LFrame       := TFrameItemProdutoPedido(AFrameProdutoClicado);
       var LQuantidade  := TFrameComponentesTecladoValorUnitario(Sender).Quantidade;
       var LValorUnitarioAntigo := LFrame.ValorUnitario;
       LFrame.SetValorUnitario(TFrameComponentesTecladoValorUnitario(Sender).ValorUnitario);

       var LDadosAdicionaisItem:TDadosProdutoItem;
       LDadosAdicionaisItem.Clear;
       LDadosAdicionaisItem.Quantidade := LQuantidade;
       AdicionarProdutoPedido(LFrame,LDadosAdicionaisItem);
       LFrame.SetValorUnitario(LValorUnitarioAntigo);
     end;
  end;
end;

procedure TViewPedido.AdicionarProdutoPedido(
    const AFrame: TFrameItemProdutoPedido; const ADadosPedidoItem:TDadosProdutoItem; const AAdicionarProdutoManul:Boolean = True);
begin
  if AAdicionarProdutoManul then
    Inc(FQuantidadeProdutoNaoSalvo);
  btnSalvar.Enabled := True;
  // Adicionando a quantidade que foi informada no frame, dessa forma
  // ele incrementa com as qauntidades que já existia
  TFrameItemProdutoPedido(AFrame)
            .AdicionarQuantidade(ADadosPedidoItem.Quantidade);

  FModelPedidoLista.EventoDepoisDeAdicionarUmProduto := nil;
  if AAdicionarProdutoManul and (FPedidoMesa.Numero > 0) then
    FModelPedidoLista.EventoDepoisDeAdicionarUmProduto := EventoDepoisDeAdicionarProduto;



  // Salvando os dados do pedido em memoria
  FModelPedidoLista.IniciarLista
                   .SetComanda(ADadosPedidoItem.Comanda)
                   .SetDescricao(ADadosPedidoItem.Descricao)
                   .SetUserId(ADadosPedidoItem.IdUser)
                   .SetItemJaEstaNaApi(ADadosPedidoItem.ItemJaEstaNaApi)
                   .SetIdBancoDados(ADadosPedidoItem.IdBancoDados)
                   .SetIdProduto(AFrame.Id)
                   .SetNomeProduto(AFrame.Descricao)
                   .SetQuantidade(ADadosPedidoItem.Quantidade)
                   .SetValorUnitatio(AFrame.ValorUnitario)
                   .SetPercentualDesconto(ADadosPedidoItem.PercentualDesconto)
                   .SetValorDesconto(ADadosPedidoItem.ValorDesconto)
                   .SetObservacao(ADadosPedidoItem.Observacao)
                   .SetRegraFiscal(AFrame.RegraFiscal)
                   .Adicionar;

  // Limpando a lista do resumo para poder ficar na order correta
  LimparListaResumo;
  // Criando a Lista de frame do resumo
  var LItemResumoRemoverLinha:TFrameResumoItem := nil;
  var LTop:Single := 0;
  for var I := 0 to  Pred(FModelPedidoLista.Lista.Count) do
  begin
    var LFrameResumo                := TFrameResumoItem.Create(nil);
    LFrameResumo.Parent             := ScrollBoxResumo;
    LFrameResumo.Align              := TAlignLayout.None;
    LFrameResumo.Position.X         := 0;
    LFrameResumo.Position.Y         := LTop;
    LFrameResumo.Width              := ScrollBoxResumo.Width;
    LFrameResumo.OnClickItem        := OnClickItemOpcoesResumo;
    LFrameResumo.OnResizeComponente := FrameResumoOpcoes1.OnResizeComponente;
    LFrameResumo.IdSequencial       := FModelPedidoLista.Lista[I].IdSequencia;
    LFrameResumo.IdProduto          := FModelPedidoLista.Lista[I].IdProduto;
    LFrameResumo.NomeProduto        := FModelPedidoLista.Lista[I].NomeProduto;
    LFrameResumo.Quantidade         := FModelPedidoLista.Lista[I].Quantidade;
    LFrameResumo.ValorUnitatio      := FModelPedidoLista.Lista[I].ValorUnitatio;
    LFrameResumo.ItemJaEstaNaApi    := FModelPedidoLista.Lista[I].ItemJaEstaNaApi;
    LFrameResumo.UserId             := FModelPedidoLista.Lista[I].UserId;
    LFrameResumo.Comanda            := FModelPedidoLista.Lista[I].Comanda;
    LFrameResumo.Descricao          := FModelPedidoLista.Lista[I].Descricao;
    LFrameResumo.SetValorDesconto(FModelPedidoLista.Lista[I].Desconto.Valor);
    LFrameResumo.SetPercentualDesconto(FModelPedidoLista.Lista[I].Desconto.Percentual);
    LFrameResumo.SetObservacao(FModelPedidoLista.Lista[I].Observacao);
    LFrameResumo.MontarFrame;
    LTop                            := LTop + LFrameResumo.Height;
    LItemResumoRemoverLinha         := LFrameResumo;
  end;

  if Assigned(LItemResumoRemoverLinha) then
    LItemResumoRemoverLinha.Line1.Visible := False;

  // Voltando a quantida para 1, que é o valor padrão, é por essa quantidade
  // Que os itens são lançados no resumo
  lblQuantidadeAdicionar.Text := '1X';

  // Recalcula valores do Resumo com total, subtotal e habilita o botão
  // de pagamento
  RecalcularProdutosSelecionados;

  // Faz o controle para saber se o produto está sendo adicionado de forma manual
  // Pela interação do usuário ou se vem do banco de dados
  if FPedidoMesa.Numero <= 0 then
    if AAdicionarProdutoManul then
      AtualizarCarrinhoBancoDados;
end;

procedure TViewPedido.AlterarQuantidadeProdutosSelecionadosResumo(
  const AQuantidade: Integer);
begin
  recQuantidadeResumo.Visible := AQuantidade > 0;
  lblQuantidadeResumo.Text    := AQuantidade.ToString;
end;

procedure TViewPedido.AlterarValoresProdutosSelecionadosResumo(
  const ASubtotal,ADesconto: Currency);
begin
  FDesconto                   := ADesconto;
  FSubtotal                   := ASubtotal;
  FTotal                      := ASubtotal - ADesconto;
  lblSubTotal.Text            := ASubtotal.ToString();
  lblDescontoVendaResumo.Text := ADesconto.ToString();
  lblTotalResumo.Text         := Currency(ASubtotal - ADesconto).ToString();
end;

procedure TViewPedido.AtualizarAPI(AValue: Boolean);
begin
  if not btnSalvar.Enabled then
    btnSalvar.Enabled := AValue;
end;

procedure TViewPedido.AtualizarCaptionMesa(const ANumero: Integer; const AMesaLivre:Boolean);
begin
  if ANumero <= 0 then
    Exit;
  FPedidoMesa.Numero := ANumero;
  lblCaption.Text        := 'Mesa '+ANumero.ToString;
  recMesaComanda.Visible := True;
  recMesaComanda.Position.X := lblCaption.Position.X + lblCaption.Width + 10;
  if AMesaLivre then
  begin
    FPedidoMesa.Situacao := stLivre;
    lblMesaComanda.Text := 'Livre';
    recMesaComanda.Fill.Color := MESA_COMANDA_LIVRE
  end
  else
  begin
    FPedidoMesa.Situacao := stOcupada;
    lblMesaComanda.Text := 'Ocupada';
    recMesaComanda.Fill.Color := MESA_COMANDA_OCUPADA
  end;
end;

procedure TViewPedido.AtualizarCarrinhoBancoDados;
begin
  // Gravar dados do pedido no carrihno
  if FPedidoMesa.Numero <= 0 then
  begin
    TThread.CreateAnonymousThread(
    procedure
    begin
      TThread.Synchronize(nil,
      procedure
      begin
        var LModelCarrinho := TModelCarrinho.Create(ModelConnection.Connection);
        LModelCarrinho.Limpar;
        try
          for var I := 0 to Pred(FModelPedidoLista.Lista.Count) do
          begin
            var LModelCarrinhoItem := TModelCarrinhoItem.Create;
            LModelCarrinhoItem
              .NumberId(FModelPedidoLista.Lista[i].IdSequencia)
              .Sequencial(FModelPedidoLista.Lista[i].IdSequencia)
              .Produto(FModelPedidoLista.Lista[i].IdProduto)
              .Quantidade(FModelPedidoLista.Lista[i].Quantidade)
              .Observacao(FModelPedidoLista.Lista[i].Observacao)
              .DescontoValor(FModelPedidoLista.Lista[i].Desconto.Valor)
              .DescontoPorcentagem(FModelPedidoLista.Lista[i].Desconto.Percentual)
              .RegraFiscal(FModelPedidoLista.Lista[i].RegraFiscal)
              .ValorUnitario(FModelPedidoLista.Lista[i].ValorUnitatio)
              .Subtoal(FModelPedidoLista.Lista[i].ValorUnitatio * FModelPedidoLista.Lista[i].Quantidade)
              .Total((FModelPedidoLista.Lista[i].ValorUnitatio * FModelPedidoLista.Lista[i].Quantidade)-FModelPedidoLista.Lista[i].Desconto.Valor);
            LModelCarrinho.AddItem(LModelCarrinhoItem);
          end;
          LModelCarrinho.Gravar;
        finally
          LModelCarrinho.Free;
        end;
      end);
    end).Start;
  end;
end;

procedure TViewPedido.EventoAtualizarValorQuantidade(Sender: TObject);
begin
  // Esse evento é vinculado a uma TProc para atualizar a quantidade
  // do proximo produto que vai ser lançado
  if Sender is TFrameComponentesTecladoQuantidade then
  begin
    var LQuantidade := TFrameComponentesTecladoQuantidade(Sender).Quantidade.ToString;
    lblQuantidadeAdicionar.Text := FormatFloat('#,##',StrToCurrDef(LQuantidade,1))+'X';
  end;
end;

procedure TViewPedido.EventoDepoisDeAdicionarProduto(
  AItemPedido: TModelItemPedido);
begin
  ModelConnection.Connection.StartTransaction;
  try
    FDAOPedido.Dados.EmpresaId          := TModelStaticCredencial.GetInstance.Company;
    FDAOPedido.Dados.UsuarioId          := TModelStaticCredencial.GetInstance.User;
    FDAOPedido.Dados.ClienteId          := TModelStaticCredencial.GetInstance.CustomerDefault;
    FDAOPedido.Dados.TypeOrder          := 1;
    FDAOPedido.Dados.CpfCnpj            := '';
    FDAOPedido.Dados.DescontoValor      := FDesconto;
    FDAOPedido.Dados.DescontoPorcentage := 0;
    FDAOPedido.Dados.Troco              := 0;
    FDAOPedido.Dados.Mesa               := FPedidoMesa.Numero;
    FDAOPedido.Dados.Comanda            := 0;
    FDAOPedido.Dados.Status             := TStatusPedido.stAberto;

    if FDAOPedido.Dados.Id <= 0 then
    begin
      FPrimeiroItemSemSalvarProduto := True;
      FDAOPedido.Gravar;
    end
    else
      FDAOPedido.Alterar;

    AtualizarCaptionMesa(FPedidoMesa.Numero,FDAOPedido.Dados.Id <= 0);

    var LDAOItemPedido := TDAOPedidoItem.Create(ModelConnection.Connection);
    try
      LDAOItemPedido.Item.PedidoId            := FDAOPedido.Dados.Id;
      LDAOItemPedido.Item.ProductId           := AItemPedido.IdProduto;
      LDAOItemPedido.Item.Quantidade          := AItemPedido.Quantidade;
      LDAOItemPedido.Item.DescontoValor       := AItemPedido.Desconto.Valor;
      LDAOItemPedido.Item.DescontoPorcentagem := AItemPedido.Desconto.Percentual;
      LDAOItemPedido.Item.Cfop                := AItemPedido.RegraFiscal.CfopInterno;
      LDAOItemPedido.Item.Observation         := AItemPedido.Observacao;
      LDAOItemPedido.Item.Origin              := AItemPedido.RegraFiscal.Origin;
      LDAOItemPedido.Item.CsosnCst            := AItemPedido.RegraFiscal.CsosnCst;
      LDAOItemPedido.Item.Ppis                := 0;
      LDAOItemPedido.Item.Vpis                := 0;
      LDAOItemPedido.Item.CstCofins           := AItemPedido.RegraFiscal.CstCofins;
      LDAOItemPedido.Item.Pcofins             := 0;
      LDAOItemPedido.Item.Vcofins             := 0;
      LDAOItemPedido.Item.ValorUnitario       := AItemPedido.ValorUnitatio;
      LDAOItemPedido.Item.Subtotal            := (AItemPedido.ValorUnitatio * AItemPedido.Quantidade);
      LDAOItemPedido.Item.Total               := (AItemPedido.ValorUnitatio * AItemPedido.Quantidade) - AItemPedido.Desconto.Valor;

      if FPrimeiroItemSemSalvarProduto then
        LDAOItemPedido.Gravar(-1)
      else
        LDAOItemPedido.Gravar;
      for var X := 0 to Pred(FModelPedidoLista.Lista.Count) do
      begin
        if FModelPedidoLista.Lista[X].IdSequencia = AItemPedido.IdSequencia then
        begin
          FModelPedidoLista.AlterarIdBancoDados(X,LDAOItemPedido.Item.Id);
          Break;
        end;
      end;

    finally
      FreeAndNil(LDAOItemPedido);
    end;
  except on E: Exception do
    begin
      ModelConnection.Connection.Rollback;
      ShowErro(e.Message);
      Exit
    end;
  end;
  ModelConnection.Connection.Commit;
end;

procedure TViewPedido.EventoDepoisDeAlterarQuantidadeProduto(
  AItemPedido: TModelItemPedido);
begin
  if FPedidoMesa.Numero > 0 then
  begin
    btnSalvar.Enabled := True;
    var LDAOPedidoItem := TDAOPedidoItem.Create(ModelConnection.Connection);
    try
      LDAOPedidoItem.CarregarItemPedido(AItemPedido.IdBancoDados);
      LDAOPedidoItem.Item.DescontoValor := AItemPedido.Desconto.Valor;
      LDAOPedidoItem.Item.ValorUnitario := AItemPedido.ValorUnitatio;
      LDAOPedidoItem.Item.Subtotal      := (AItemPedido.ValorUnitatio * AItemPedido.Quantidade);
      LDAOPedidoItem.Item.Total         := (LDAOPedidoItem.Item.Subtotal - LDAOPedidoItem.Item.DescontoValor);
      LDAOPedidoItem.Item.Quantidade    := AItemPedido.Quantidade;
      LDAOPedidoItem.Atualizar;
    finally
      FreeAndNil(LDAOPedidoItem);
    end;
  end;
end;

procedure TViewPedido.EventoDepoisDeAlterarDescontoProduto(
  AItemPedido: TModelItemPedido);
begin
  if FPedidoMesa.Numero > 0 then
  begin
    btnSalvar.Enabled := True;
    var LDAOPedidoItem := TDAOPedidoItem.Create(ModelConnection.Connection);
    try
      LDAOPedidoItem.CarregarItemPedido(AItemPedido.IdBancoDados);
      LDAOPedidoItem.Item.DescontoValor       := AItemPedido.Desconto.Valor;
      LDAOPedidoItem.Item.DescontoPorcentagem := AItemPedido.Desconto.Percentual;
      LDAOPedidoItem.Item.ValorUnitario       := AItemPedido.ValorUnitatio;
      LDAOPedidoItem.Item.Subtotal            := (AItemPedido.ValorUnitatio * AItemPedido.Quantidade);
      LDAOPedidoItem.Item.Total               := (LDAOPedidoItem.Item.Subtotal - LDAOPedidoItem.Item.DescontoValor);
      LDAOPedidoItem.Item.Quantidade          := AItemPedido.Quantidade;
      LDAOPedidoItem.Atualizar;
    finally
      FreeAndNil(LDAOPedidoItem);
    end;
  end;
end;

procedure TViewPedido.EventoDepoisDeAlterarObservacaoProduto(
  AItemPedido: TModelItemPedido);
begin
  if FPedidoMesa.Numero > 0 then
  begin
    btnSalvar.Enabled := True;
    var LDAOPedidoItem := TDAOPedidoItem.Create(ModelConnection.Connection);
    try
      LDAOPedidoItem.CarregarItemPedido(AItemPedido.IdBancoDados);
      LDAOPedidoItem.Item.Observation := AItemPedido.Observacao;
      LDAOPedidoItem.Atualizar;
    finally
      FreeAndNil(LDAOPedidoItem);
    end;
  end;
end;

procedure TViewPedido.EventoFinalizarPagamento(Sender:TObject);
begin
  if FPedidoMesa.Numero > 0 then
  begin
    //OpenLoad;
//    TThread.CreateAnonymousThread(
//    procedure
//    begin
      TMonitor.Enter(ModelConnection.Connection);
      try
        var LDAOPedidoItens := TDAOPedidoItem.Create(ModelConnection.Connection);
        try
          LDAOPedidoItens.AlterarUsuario(FDAOPedido.Dados.Id,TModelStaticCredencial.GetInstance.User);
        finally
          LDAOPedidoItens.Free;
        end;

        FDAOPedido.Dados.DescontoPorcentage := 0;
        FDAOPedido.Dados.DescontoValor      := TViewPagamento(Sender).Desconto;
        FDAOPedido.Dados.Total              := TViewPagamento(Sender).Total;
        FDAOPedido.Dados.Troco              := TViewPagamento(Sender).Troco;
        FDAOPedido.Dados.Subtotal           := TViewPagamento(Sender).Subtotal;
        FDAOPedido.Dados.Status             := stFechado;
        FDAOPedido.Alterar;
      finally
        TMonitor.Exit(ModelConnection.Connection);
      end;
      TThread.Synchronize(nil,
      procedure
      begin
        //CloseLoad;
        TModelSincronizacao.GetInstance.NovoPedido();
        btnSalvar.Enabled := False;
        Self.Close;
      end);
//    end).Start;
  end
  else
  begin
    TModelSincronizacao.GetInstance.NovoPedido();

    for var I := 0 to Pred(HorzScrollBox.Content.ControlsCount) do
    begin
      if HorzScrollBox.Content.Controls[I] is TFrameItemCategoria then
      begin
        var LFrame := TFrameItemCategoria(HorzScrollBox.Content.Controls[I]);
        LFrame.OnClickItem(LFrame);
        Break
      end;
    end;

    //Posicionando o scroll para o começo
    HorzScrollBox.ViewportPosition := TPointF.Create(0,0);


    for var X := 0 to Pred(FListaFrameProdutos.Count) do
    begin
      FListaFrameProdutos.Items[X].ZerarQuantidade;
    end;

    if Assigned(FModelPedidoLista) then
      FreeAndNil(FModelPedidoLista);
    FModelPedidoLista := TModelPedidoLista.Create;

    LimparListaResumo;

    TabControl.GotoVisibleTab(0);

    lblQuantidadeAdicionar.Text := '1X';

    CarregarDadosDoBancoDeDados;
    RecalcularProdutosSelecionados;
    ViewMensagem.OnAfterClose := nil;
    ShowSucesso('Pedido realizado com sucesso!');
  end;
end;

procedure TViewPedido.btnPagamentoClick(Sender: TObject);
begin
  inherited;

  //  if FPedidoMesa.Numero > 0 then
//  begin
//    var LExisteItemQueNaoFoiSalvo:Boolean := False;
//    var LDaoPedidoItem := TDAOPedidoItem.Create(ModelConnection.Connection);
//    try
//      var LListaPedidoItem := LDaoPedidoItem.ListarPedidoItem(FDAOPedido.Dados.Id);
//      try
//        for var I := 0 to Pred(LListaPedidoItem.Count) do
//        begin
//          if LListaPedidoItem[I].IdOrderItemApi.Trim.Equals('') then
//          begin
//            LExisteItemQueNaoFoiSalvo := True;
//            Break;
//          end;
//        end;
//      finally
//        FreeAndNil(LListaPedidoItem)
//      end;
//    finally
//      FreeAndNil(LDaoPedidoItem);
//    end;
//
//    if LExisteItemQueNaoFoiSalvo then
//    begin
//      btnSalvarClick(btnSalvar);
//      exit;
//    end;
//  end;


  if Assigned(FViewPagamento) then
    FreeAndNil(FViewPagamento);
  FViewPagamento := TViewPagamento.Create(Self);
  FViewPagamento.SetDesconto(FDesconto);
  FViewPagamento.SetTotal(FTotal);
  FViewPagamento.SetSubtotal(FSubtotal);
  FViewPagamento.EventoFinalizarPedido := EventoFinalizarPagamento;
  FViewPagamento.PedidoId              := FDAOPedido.Dados.Id;
  FViewPagamento.AtualizarApi          := AtualizarAPI;
  FViewPagamento.TipoRecebimento       := tpPedido;



  if FPedidoMesa.Numero > 0 then
    FViewPagamento.TipoRecebimento := tpMesa;
  FViewPagamento.Show;
end;

procedure TViewPedido.BuscarCategorias;
begin
  OpenLoad;
  TThread.CreateAnonymousThread(
  procedure
  var
    LResponse: IResponse;
  begin
    try
      LResponse := TRequest.New.BaseURL(BaseURL)
        .Resource('product/category')
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

          var LData := LJsonResponse.GetValue<TJSONArray>('data');

          CarregarDadosListaCategoria(LData);
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


procedure TViewPedido.CarregarDadosDoBancoDeDados;
begin
  if FPedidoMesa.Numero > 0 then
  begin
    Exit;
  end;

  var LModelCarinho := TModelCarrinho.Create(ModelConnection.Connection);
  try
    var LListaCarrinhoItem := LModelCarinho.ListaItens;
    try
      for var I := 0 to Pred(LListaCarrinhoItem.Count) do
      begin
        for var X := 0 to Pred(FListaFrameProdutos.Count) do
        begin
          if FListaFrameProdutos.Items[X].Id.Equals(LListaCarrinhoItem[I].Produto) then
          begin
            var LFrame        := FListaFrameProdutos.Items[X];
            var LDadosPedidoItem:TDadosProdutoItem;
            LDadosPedidoItem.Clear;
            LDadosPedidoItem.Quantidade         := LListaCarrinhoItem[I].Quantidade;
            LDadosPedidoItem.ValorDesconto      := LListaCarrinhoItem[I].DescontoValor;
            LDadosPedidoItem.PercentualDesconto := LListaCarrinhoItem[I].DescontoPorcentagem;
            LDadosPedidoItem.Observacao         := LListaCarrinhoItem[I].Observacao;

            if LFrame.PrecoLivre then
            begin
              var LValorOriginal := LFrame.ValorUnitario;
              LFrame.SetValorUnitario(LListaCarrinhoItem[I].ValorUnitario);
              AdicionarProdutoPedido(LFrame,LDadosPedidoItem,False);
              LFrame.SetValorUnitario(LValorOriginal);
            end
            else
            begin
              AdicionarProdutoPedido(LFrame,LDadosPedidoItem,False);
            end;
            Break;
          end;
        end;
      end;
    finally
      FreeAndNil(LListaCarrinhoItem)
    end;
  finally
    FreeAndNil(LModelCarinho);
  end;
end;

procedure TViewPedido.CarregarDadosDoBancoDeDadosMesa(const AOrderId:Integer);
begin
  var LQuantidadeItensNaoAtualizados:Integer := 0;
  var LDaoPedidoItem := TDAOPedidoItem.Create(ModelConnection.Connection);
  try
    var LListaPedidoItem := LDaoPedidoItem.ListarPedidoItem(AOrderId);
    try
      for var I := 0 to Pred(LListaPedidoItem.Count) do
      begin
        for var X := 0 to Pred(FListaFrameProdutos.Count) do
        begin
          if FListaFrameProdutos.Items[X].Id.Equals(LListaPedidoItem[I].ProductId) then
          begin
            var LFrame        := FListaFrameProdutos.Items[X];
            var LDadosPedidoItem:TDadosProdutoItem;
            LDadosPedidoItem.Clear;
            LDadosPedidoItem.IdBancoDados       := LListaPedidoItem[I].Id;
            LDadosPedidoItem.Quantidade         := LListaPedidoItem[I].Quantidade;
            LDadosPedidoItem.ValorDesconto      := LListaPedidoItem[I].DescontoValor;
            LDadosPedidoItem.PercentualDesconto := LListaPedidoItem[I].DescontoPorcentagem;
            LDadosPedidoItem.Observacao         := LListaPedidoItem[I].Observation;
            LDadosPedidoItem.ItemJaEstaNaApi    := LListaPedidoItem[I].IdOrderItemApi.Trim <> '';
            LDadosPedidoItem.IdUser             := LListaPedidoItem[I].UserId;
            LDadosPedidoItem.Comanda            := LListaPedidoItem[I].Comanda;
            LDadosPedidoItem.Descricao          := LListaPedidoItem[I].Descricao;
            if not LDadosPedidoItem.ItemJaEstaNaApi then
              Inc(LQuantidadeItensNaoAtualizados);

            if LFrame.ValorUnitario <= 0 then
            begin
              LFrame.SetValorUnitario(LListaPedidoItem[I].ValorUnitario);
              AdicionarProdutoPedido(LFrame,LDadosPedidoItem,False);
              LFrame.SetValorUnitario(0);
            end
            else
            begin
              AdicionarProdutoPedido(LFrame,LDadosPedidoItem,False);
            end;
            Break;
          end;
        end;
      end;
    finally
      FreeAndNil(LListaPedidoItem)
    end;
  finally
    FreeAndNil(LDaoPedidoItem);
  end;
  btnSalvar.Enabled := LQuantidadeItensNaoAtualizados > 0;
end;

procedure TViewPedido.CarregarDadosListaCategoria(const AJsonArray: TJSONArray);
begin
  // Limpar lista de frame dos produtos
  if Assigned(FListaFrameProdutos) then
    FreeAndNil(FListaFrameProdutos);
  // Criar lista de frame dos produtos
  FListaFrameProdutos := TObjectList<TFrameItemProdutoPedido>.Create;

  var LFramePrimeiraCategoria:TFrameItemCategoria := nil;
  for var i := 0 to Pred(AJsonArray.Count) do
  begin

    // Carrosel de categoria
    var LItemArray                  := AJsonArray.Items[i] as TJSONObject;
    var LFrameItemCategoria         := TFrameItemCategoria.Create(nil);
    LFrameItemCategoria.Parent      := HorzScrollBox;
    LFrameItemCategoria.Align       := TAlignLayout.Left;
    LFrameItemCategoria.Width       := 180;
    LFrameItemCategoria.OnClickItem := EventoOnClickItemCategoria;
    LFrameItemCategoria.Id          := LItemArray.GetValue<string>('id','');
    LFrameItemCategoria.Descricao   := LItemArray.GetValue<string>('name','');
    LFrameItemCategoria.ImagemUrl   := LItemArray.GetValue<string>('image','');

    if I = 0 then
      LFramePrimeiraCategoria := LFrameItemCategoria;

    // Popular produtos na lista de frame
    var LJsonArrayProdutos := LItemArray.GetValue<TJSONArray>('products');
    if Assigned(LJsonArrayProdutos) then
    begin
      for var X := 0 to Pred(LJsonArrayProdutos.Count) do
      begin
        var LItemJson := LJsonArrayProdutos.Items[x] as TJSONObject;
        var LFrame := TFrameItemProdutoPedido.Create(nil);
        LFrame.OnClickItem := OnClickItemProduto;
        LFrame.Categoria   := LItemArray.GetValue<string>('id','');
        LFrame.LoadJSONObject(LItemJson);
        LFrame.SetJSONObjectString(LItemJson.ToJSON());
        FListaFrameProdutos.Add(LFrame);
      end;
    end;
  end;

  // Mostrar os produtos da primeira categoria do carrosel
  if Assigned(LFramePrimeiraCategoria) then
    LFramePrimeiraCategoria.OnClickItem(LFramePrimeiraCategoria);

  if FPedidoMesa.Numero > 0 then
  begin
    CarregarDadosDoBancoDeDadosMesa(FDAOPedido.Dados.Id);
    btnSalvar.Width    := (layButoes.Width / 2) - 16;
    btnPagamento.Width := btnSalvar.Width;
  end
  else
  begin
    btnSalvar.Align    := TAlignLayout.Left;
    btnSalvar.Width    := 0;
    btnPagamento.Align := TAlignLayout.Client;
  end;
  layButoes.Visible := True;
  CarregarDadosDoBancoDeDados;

end;

procedure TViewPedido.ConfigurarEventoDeClickOpcoesResumo;
begin
  // Quando Clicar em alguma opção do resumo os eventos acionados estão aqui
  FrameResumoOpcoes1.OnClickQuantidade  := OnClickResumoOpcoesQuantidade;
  FrameResumoOpcoes1.OnClickDesconto    := OnClickResumoOpcoesDesconto;
  FrameResumoOpcoes1.OnClickObservacao  := OnClickResumoOpcoesObservacao;
  FrameResumoOpcoes1.OnClickDeletarItem := OnClickResumoOpcoesDeletarItem;
  FrameResumoOpcoes1.OnClickComanda     := OnClickResumoOpcoesComandaItem;
end;

procedure TViewPedido.ExecuteOnShow;
begin
  inherited;
  BuscarCategorias;
end;

procedure TViewPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if (FPedidoMesa.Numero > 0) and  (btnSalvar.Enabled = True) and (FramePagamentosSalvarDados1.PodeFecharATela = False) then
  begin
    FramePagamentosSalvarDados1.OpenSalvarDados;

    FramePagamentosSalvarDados1.OnClickConfirmar := procedure(Sender:TObject)
    begin
      btnSalvarClick(btnSalvar);
    end;

    FramePagamentosSalvarDados1.OnClickCancelar := procedure(Sender:TObject)
    begin
      if FPrimeiroItemSemSalvarProduto then
      begin
        FDAOPedido.ApagarDadosPeloId(FDAOPedido.Dados.Id);
      end
      else
      begin
        FDAOPedido.ApagarDadosNaoSincronizados(FDAOPedido.Dados.Id);
      end;
      Close;
    end;


    Abort;
  end;
  if Assigned(FAtualizarMesas) then
    FAtualizarMesas();
end;

procedure TViewPedido.FormCreate(Sender: TObject);
begin
  inherited;
  TabControl.Margins.Top := - 50;
  TabControl.SendToBack;
  recToolbar.BringToFront;
  recQuantidadeResumo.Visible := False;
  TabControl.ActiveTab        := tabProdutos;
  FListaFrameProdutos         := TObjectList<TFrameItemProdutoPedido>.Create;
  FDAOPedido                  := TDAOPedido.Create(ModelConnection.Connection);
  FModelPedidoLista           := TModelPedidoLista.Create;
  btnPagamento.Enabled        := False;
  btnSalvar.Enabled           := False;
  recMesaComanda.Visible      := False;
  layButoes.Visible           := False;
  FQuantidadeProdutoNaoSalvo  := 0;
  FramePagamentoVendedor1.BuscarVendedores;
  FPedidoMesa.Clear;
  ConfigurarEventoDeClickOpcoesResumo;
  FModelPedidoLista.EventoDeposDeAlterarQuantidade   := EventoDepoisDeAlterarQuantidadeProduto;
  FModelPedidoLista.EventoDepoisDeAdicionarUmProduto := EventoDepoisDeAdicionarProduto;
  FModelPedidoLista.EventoDepoisDeAlterarDesconto    := EventoDepoisDeAlterarDescontoProduto;
  FModelPedidoLista.EventoDeposDeAlterarObservacao   := EventoDepoisDeAlterarObservacaoProduto;
end;

procedure TViewPedido.FormDestroy(Sender: TObject);
begin
  inherited;
  FListaFrameProdutos.Free;
  FreeAndNil(FDAOPedido);
  FreeAndNil(FModelPedidoLista);
end;

procedure TViewPedido.imgVoltarClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TViewPedido.lblProdutosClick(Sender: TObject);
begin
  inherited;
  TabControl.GotoVisibleTab(0);
end;

procedure TViewPedido.lblResumoClick(Sender: TObject);
begin
  inherited;
  TabControl.GotoVisibleTab(1);
end;

procedure TViewPedido.LimparCategoriaSelecionada;
begin
  // Altera o circulo de quantidade de itens no resumo
  for var I := 0 to Pred(HorzScrollBox.Content.ControlsCount) do
  begin
    if HorzScrollBox.Content.Controls[I] is TFrameItemCategoria then
    begin
      TFrameItemCategoria(HorzScrollBox.Content.Controls[I]).LimparSelecaoItem;
    end;
  end;
end;

procedure TViewPedido.LimparListaResumo;
begin
  for var X := Pred(ScrollBoxResumo.Content.ControlsCount) downto 0 do
  begin
    ScrollBoxResumo.Content.Controls[X].Free
  end;
end;

procedure TViewPedido.Mesa(const ANumero: Integer);
begin
  FDAOPedido.CarregarDadosPeloNumeroMesa(ANumero);

  var LStatus := True;
  if FDAOPedido.Dados.Id > 0 then
    LStatus := False;
  AtualizarCaptionMesa(ANumero,LStatus);
end;

procedure TViewPedido.EventoOnClickItemCategoria(Sender: TObject);
begin
  // Click da categoria, Esse evento vai ocorrer quando a categoria for clicada

  // Limpando a lista de produtos
  for var I := Pred(ScrollBox.Content.ControlsCount) downto 0 do
  begin
    ScrollBox.RemoveObject(ScrollBox.Content.Controls[i]);
  end;

  // Limpando a categoria selecionada
  LimparCategoriaSelecionada;

  // Validando se o Sender é um TFrameItemCategoria
  if Sender is TFrameItemCategoria  then
  begin

    //Selecionando a categoria
    TFrameItemCategoria(Sender).SelecionarItem;

    var LId         := TFrameItemCategoria(Sender).Id;
    var LTop:Single := 0;
    for var X := 0 to Pred(FListaFrameProdutos.Count) do
    begin
      // Validadndo se o ID da categoria do produto, é igual o
      // id da categoria que foi clicado
      if FListaFrameProdutos.Items[X].Categoria.Equals(LId) then
      begin
        var LFrame        := FListaFrameProdutos.Items[X];
        LFrame.Parent     := ScrollBox;
        LFrame.Align      := TAlignLayout.None;
        LFrame.Position.Y := LTop;
        LFrame.Position.X := 0;
        LFrame.Width      := ScrollBox.Width;
        LTop              := LTop + LFrame.Height;
        ScrollBox.AddObject(LFrame);
      end;
    end;
  end;
end;

procedure TViewPedido.OnClickConfirmarQuantidadeDoResumo(Sender: TObject);
begin
  // Esse evento vai ser acionado quando o usuário clicar
  // Item do Resumo -> Depois no card de opções clicar em -> Quantidade
  // E Por fim -> Confirmar
  // Esse evento vai alterar a quantidade de um Item do Resumo
  if Sender is TFrameComponentesTecladoQuantidade then
  begin
    var LFrameTecladoQuantidade     := TFrameComponentesTecladoQuantidade(Sender);
    var LQuantidadeAlterada:Integer := LFrameTecladoQuantidade.Quantidade;
    // Verificando se o Objeto selecionado que está guardado no frame de
    // Opções do resumo é do tipo TFrameResumoItem
    if FrameResumoOpcoes1.ObjetoSelecionado is TFrameResumoItem then
    begin

      // Atualizando a lista de frame do resumo
      var LFrameResumoItem             := TFrameResumoItem(FrameResumoOpcoes1.ObjetoSelecionado);
      var LIdProdutoProdutoSelecionado := LFrameResumoItem.IdProduto;
      var LQuantidadeAnteriorAEdicao   := LFrameResumoItem.Quantidade;
      LFrameResumoItem.Quantidade      := LQuantidadeAlterada;
      LFrameResumoItem.SetValorDesconto(LFrameTecladoQuantidade.ValoresDesconto.DescontoReais);
      LFrameResumoItem.SetPercentualDesconto(LFrameTecladoQuantidade.ValoresDesconto.DescontoPorcentagem);
      LFrameResumoItem.MontarFrame;

      // Atualizando a lista de frame dos produtos que está em memoria
      for var I := 0 to  Pred(FListaFrameProdutos.Count) do
      begin
        if FListaFrameProdutos[i].Id.Equals(LIdProdutoProdutoSelecionado) then
        begin

          // Pego a nova quantidade que foi alterada, subtraio pela
          // quantidade que existia antes
          // Se der valor negativo Ex. 10(Nova quantidade) - 14(Quantidade anterior)
          // Eu tenho um valor negativo de -4, que vou adicionar ao meu frame de
          // produto que tem o valor de 20, com isso automaticamento eu tenho
          // o total desse produto no resumo de 16

          var LQuantidade := LQuantidadeAlterada - LQuantidadeAnteriorAEdicao;
          FListaFrameProdutos[i].AdicionarQuantidade(LQuantidade);
          Break;
        end;
      end;

      // Atualizar a lista de pedidos
      var LIdSequencialSelecionado := LFrameResumoItem.IdSequencial;
      for var X := 0 to Pred(FModelPedidoLista.Lista.Count) do
      begin
        if FModelPedidoLista.Lista.Items[X].IdSequencia = LIdSequencialSelecionado then
        begin
          // Alterar a quantidade pelo index do item do resumo
          FModelPedidoLista.AlterarQuantidade(X,LQuantidadeAlterada);
          // Alterar o desconto pelo index tbm, pois o calculo é feito em cima da porcentagem
          FModelPedidoLista.AlterarDesconto(X,
                                            LFrameTecladoQuantidade.ValoresDesconto.DescontoPorcentagem,
                                            LFrameTecladoQuantidade.ValoresDesconto.DescontoReais);
          Break;
        end;
      end;
      RecalcularProdutosSelecionados;
      AtualizarCarrinhoBancoDados;
    end;
  end;
end;

procedure TViewPedido.OnClickConfirmarComandaItemResumo(Sender: TObject);
begin
  if Sender is TFramePedidoComanda then
  begin
    if FrameResumoOpcoes1.ObjetoSelecionado is TFrameResumoItem then
    begin
      var LFrameResumoItem := TFrameResumoItem(FrameResumoOpcoes1.ObjetoSelecionado);

      var LNumeroComanda := TFramePedidoComanda(Sender).NumeroComanda;
      var LDescricao     := TFramePedidoComanda(Sender).Descricao;

      var LIdSequencialSelecionado := LFrameResumoItem.IdSequencial;
      for var X := 0 to Pred(FModelPedidoLista.Lista.Count) do
      begin
        if FModelPedidoLista.Lista.Items[X].IdSequencia = LIdSequencialSelecionado then
        begin
          try
            ModelConnection.Connection.StartTransaction;
            var LDAOPedidoItem := TDAOPedidoItem.Create(ModelConnection.Connection);
            try
              var LIdBanco := FModelPedidoLista.Lista.Items[X].IdBancoDados;
              LDAOPedidoItem.AlterarComanda(LIdBanco,LNumeroComanda,LDescricao);
              TFrameResumoItem(FrameResumoOpcoes1.ObjetoSelecionado).Comanda   := LNumeroComanda;
              TFrameResumoItem(FrameResumoOpcoes1.ObjetoSelecionado).Descricao := LDescricao;
            finally
              LDAOPedidoItem.Free;
            end;

          except on E: Exception do
            begin
              ModelConnection.Connection.Rollback;
              ShowErro(e.Message);
              Exit;
            end;
          end;
          ModelConnection.Connection.Commit;
          FModelPedidoLista.AlterarComanda(X,LNumeroComanda,LDescricao);
          Break;
        end;
      end;

      var LTop:Single := 0;
      for var I := 0 to Pred(ScrollBoxResumo.Content.ControlsCount) do
      begin
        if ScrollBoxResumo.Content.Controls[i] is TFrameResumoItem then
        begin
          var LFrame := TFrameResumoItem(ScrollBoxResumo.Content.Controls[i]);
          LFrame.Position.Y := LTop;
          LFrame.MontarFrame;
          LTop              := LTop + LFrame.Height;
        end;
      end;
    end;
  end;
end;

procedure TViewPedido.OnClickConfirmarDeletarItemResumo(Sender: TObject);
begin
  if Sender is TFrameResumoDeletarItem then
  begin
    if FrameResumoOpcoes1.ObjetoSelecionado is TFrameResumoItem then
    begin
      var LFrameResumoItem := TFrameResumoItem(FrameResumoOpcoes1.ObjetoSelecionado);

      var LIdSequencialSelecionado := LFrameResumoItem.IdSequencial;
      for var X := 0 to Pred(FModelPedidoLista.Lista.Count) do
      begin
        if FModelPedidoLista.Lista.Items[X].IdSequencia = LIdSequencialSelecionado then
        begin
          try
            ModelConnection.Connection.StartTransaction;
            var LDAOPedidoItem := TDAOPedidoItem.Create(ModelConnection.Connection);
            try
              LDAOPedidoItem.RemoverItemPorId(FModelPedidoLista.Lista.Items[X].IdBancoDados);
            finally
              LDAOPedidoItem.Free;
            end;
          except on E: Exception do
            begin
              ModelConnection.Connection.Rollback;
              ShowErro(e.Message);
              Exit;
            end;
          end;
          ModelConnection.Connection.Commit;
          FModelPedidoLista.Lista.Delete(X);
          Break;
        end;
      end;

      var LIdProdutoProdutoSelecionado := LFrameResumoItem.IdProduto;
      for var I := 0 to  Pred(FListaFrameProdutos.Count) do
      begin
        if FListaFrameProdutos[i].Id.Equals(LIdProdutoProdutoSelecionado) then
        begin
          var LQuantidade := LFrameResumoItem.Quantidade;
          FListaFrameProdutos[i].AdicionarQuantidade(-LQuantidade);
          Break;
        end;
      end;

      FreeAndNil(LFrameResumoItem);

      var LTop:Single := 0;
      for var I := 0 to Pred(ScrollBoxResumo.Content.ControlsCount) do
      begin
        if ScrollBoxResumo.Content.Controls[i] is TFrameResumoItem then
        begin
          var LFrame := TFrameResumoItem(ScrollBoxResumo.Content.Controls[i]);
          LFrame.Position.Y := LTop;
          LTop              := LTop + LFrame.Height;
        end;
      end;
      Dec(FQuantidadeProdutoNaoSalvo);
      RecalcularProdutosSelecionados;
      AtualizarCarrinhoBancoDados;
    end;
  end;
end;

procedure TViewPedido.OnClickConfirmarDescontoDoResumo(Sender: TObject);
begin
  if Sender is TFrameComponentesTecladoDesconto then
  begin
    var LFrameDesconto := TFrameComponentesTecladoDesconto(Sender);
    if FrameResumoOpcoes1.ObjetoSelecionado is TFrameResumoItem then
    begin
      var LFrameResumoItem := TFrameResumoItem(FrameResumoOpcoes1.ObjetoSelecionado);
      LFrameResumoItem.SetPercentualDesconto(LFrameDesconto.DescontoPercentual);
      LFrameResumoItem.SetValorDesconto(LFrameDesconto.DescontoReais);
      LFrameResumoItem.MontarFrame;
      // Atualizar a lista de pedidos
      var LIdSequencialSelecionado := LFrameResumoItem.IdSequencial;
      for var X := 0 to Pred(FModelPedidoLista.Lista.Count) do
      begin
        if FModelPedidoLista.Lista.Items[X].IdSequencia = LIdSequencialSelecionado then
        begin
          // Alterar a quantidade pelo index do item do resumo
          FModelPedidoLista.AlterarDesconto(X,
                                            LFrameDesconto.DescontoPercentual,
                                            LFrameDesconto.DescontoReais);
          Break;
        end;
      end;
      RecalcularProdutosSelecionados;
      AtualizarCarrinhoBancoDados;
    end;
  end;
end;

procedure TViewPedido.OnClickConfirmarObservacaoDoResumo(Sender: TObject);
begin
  if Sender is TFrameResumoObservacao then
  begin
    var LFrameResumoObservacao := TFrameResumoObservacao(Sender);
    if FrameResumoOpcoes1.ObjetoSelecionado is TFrameResumoItem then
    begin
      var LFrameResumoItem := TFrameResumoItem(FrameResumoOpcoes1.ObjetoSelecionado);
      LFrameResumoItem.SetObservacao(LFrameResumoObservacao.Observacao);
      LFrameResumoItem.MontarFrame;

      // Atualizar a lista de pedidos
      var LIdSequencialSelecionado := LFrameResumoItem.IdSequencial;
      for var X := 0 to Pred(FModelPedidoLista.Lista.Count) do
      begin
        if FModelPedidoLista.Lista.Items[X].IdSequencia = LIdSequencialSelecionado then
        begin
          // Alterar a quantidade pelo index do item do resumo
          FModelPedidoLista.AlterarObservacao(X,
                                            LFrameResumoObservacao.Observacao);
          Break;
        end;
      end;

      var LTop:Single := 0;
      for var I := 0 to Pred(ScrollBoxResumo.Content.ControlsCount) do
      begin
        if ScrollBoxResumo.Content.Controls[i] is TFrameResumoItem then
        begin
          var LFrame := TFrameResumoItem(ScrollBoxResumo.Content.Controls[i]);
          LFrame.Position.Y := LTop;
          LTop              := LTop + LFrame.Height;
        end;
      end;

      AtualizarCarrinhoBancoDados;
    end;
  end;
end;

procedure TViewPedido.OnClickItemOpcoesResumo(Sender: TObject);
begin
  // Se o item já está salvo na API não abre a opção
  if TFrameResumoItem(Sender).ItemJaEstaNaApi then
  begin
    Exit;
  end;
  // Fazendo o calculo para posicionar o card de opções do resumo
  var LHeight    := recToolbar.Height + recProdutosResumo.Height +
                    recContentScrollResumo.Padding.Top + recContentScrollResumo.Margins.Top;
  var LPositionY := LHeight + TFrameResumoItem(Sender).Position.Y;
  FrameResumoOpcoes1.lblDeletarItem.Enabled := not TFrameResumoItem(Sender).ItemJaEstaNaApi;
  FrameResumoOpcoes1.OpenOpcoes(LPositionY);
  // Passando o objeto que foi clicado para que em seguida o sistema
  // possa identificar o mesmo e fazer as alterações necessarias
  FrameResumoOpcoes1.SetObjetoSelecionado(Sender);
end;

procedure TViewPedido.OnClickItemProduto(Sender: TObject);
begin
  if Sender is TFrameItemProdutoPedido then
  begin
    // Esse é o valor da quantidade selecionada
    var LQauntidadeSelecionada := StrToIntDef(TModelUtils.ExtractNumber(lblQuantidadeAdicionar.Text),0);
    var LFrame                 := TFrameItemProdutoPedido(Sender);

    if LFrame.PrecoLivre then
    begin
      FrameComponentesTecladoValorUnitario1.SetObjetoSelecionado(LFrame);
      FrameComponentesTecladoValorUnitario1.SetNomeProduto(LFrame.Descricao);
      FrameComponentesTecladoValorUnitario1.SetQuantidade(LQauntidadeSelecionada);
      FrameComponentesTecladoValorUnitario1.OnClickConfirmar := AdicionarProdutoComValorZerado;
      FrameComponentesTecladoValorUnitario1.OpenValorUnitario;
      lblQuantidadeAdicionar.Text := '1X';
      Exit;
    end;

    var LDadosPedidoItem:TDadosProdutoItem;
    LDadosPedidoItem.Clear;
    LDadosPedidoItem.Quantidade := LQauntidadeSelecionada;
    AdicionarProdutoPedido(LFrame,LDadosPedidoItem);
  end;
end;

procedure TViewPedido.OnClickResumoOpcoesComandaItem(Sender: TObject);
begin
  if Sender is TFrameResumoOpcoes then
  begin
    var LObjetoSelecionado := TFrameResumoOpcoes(Sender).ObjetoSelecionado;
    if LObjetoSelecionado is TFrameResumoItem then
    begin
      FramePedidoComanda1.OpenComanda;
      FramePedidoComanda1.OnClickConfirmar := OnClickConfirmarComandaItemResumo;
    end;
  end;
end;

procedure TViewPedido.OnClickResumoOpcoesDeletarItem(Sender: TObject);
begin
  if Sender is TFrameResumoOpcoes then
  begin
    var LObjetoSelecionado := TFrameResumoOpcoes(Sender).ObjetoSelecionado;
    if LObjetoSelecionado is TFrameResumoItem then
    begin
      FrameResumoDeletarItem1.OpenDeletarItemResumo;
      FrameResumoDeletarItem1.OnClickConfirmar := OnClickConfirmarDeletarItemResumo;
    end;
  end;
end;

procedure TViewPedido.OnClickResumoOpcoesDesconto(Sender: TObject);
begin
  // Esse Evento vai Ocorrer quando o usuário clicar em
  // -> Item do Resumo -> Desconto
  // Ele vai abrir modal de desconto
  if Sender is TFrameResumoOpcoes then
  begin
    var LObjetoSelecionado := TFrameResumoOpcoes(Sender).ObjetoSelecionado;
    if LObjetoSelecionado is TFrameResumoItem then
    begin
      var LFrameResumoItem := TFrameResumoItem(LObjetoSelecionado);
      var LSubTotal        := LFrameResumoItem.ValorUnitatio * LFrameResumoItem.Quantidade;
      var LValorDesconto   := LFrameResumoItem.ValorDesconto;
      FrameComponentesTecladoDesconto1.OpenDesconto(LSubTotal,LValorDesconto);
      FrameComponentesTecladoDesconto1.OnClickConfirmar := OnClickConfirmarDescontoDoResumo;
    end;
  end;
end;

procedure TViewPedido.OnClickResumoOpcoesObservacao(Sender: TObject);
begin
  if Sender is TFrameResumoOpcoes then
  begin
    var LObjetoSelecionado := TFrameResumoOpcoes(Sender).ObjetoSelecionado;
    if LObjetoSelecionado is TFrameResumoItem then
    begin
      var LFrameResumoItem := TFrameResumoItem(LObjetoSelecionado);
      FrameResumoObservacao1.SetObservacao(LFrameResumoItem.Observacao);
      FrameResumoObservacao1.OpenObservacao;
      FrameResumoObservacao1.OnClickConfirmar := OnClickConfirmarObservacaoDoResumo;
    end;
  end;
end;

procedure TViewPedido.OnClickResumoOpcoesQuantidade(Sender: TObject);
begin
  // Esse Evento vai Ocorrer quando o usuário clicar em
  // -> Item do Resumo -> Quantidade
  // Ele vai abrir modal de quantidade
  if Sender is TFrameResumoOpcoes then
  begin
    var LFrameResumoOpcpes := TFrameResumoOpcoes(Sender);
    if LFrameResumoOpcpes.ObjetoSelecionado is TFrameResumoItem then
    begin
      var LFrameResumoItem := TFrameResumoItem(LFrameResumoOpcpes.ObjetoSelecionado);
      FrameComponentesTecladoQuantidade1.OpenQuantidade;
      FrameComponentesTecladoQuantidade1.SetNome(LFrameResumoItem.NomeProduto);
      FrameComponentesTecladoQuantidade1.SetQuantidade(LFrameResumoItem.Quantidade);
      FrameComponentesTecladoQuantidade1.SetValorUnitario(LFrameResumoItem.ValorUnitatio);
      FrameComponentesTecladoQuantidade1.SetPercentualDesconto(LFrameResumoItem.PercentualDesconto);
      FrameComponentesTecladoQuantidade1.SetValorDesconto(LFrameResumoItem.ValorDesconto);
      FrameComponentesTecladoQuantidade1.MostrarProduto;
      FrameComponentesTecladoQuantidade1.OnClickConfirmar := OnClickConfirmarQuantidadeDoResumo;
    end;
  end;
end;

procedure TViewPedido.RecalcularProdutosSelecionados;
begin
  var LValorSubTotalProdutoSelecionado:Currency := 0;
  var LValorDescontoProdutoSelecionado:Currency := 0;
  for var I := 0 to Pred(FModelPedidoLista.Lista.Count) do
  begin
    LValorSubTotalProdutoSelecionado := LValorSubTotalProdutoSelecionado +
                                        (FModelPedidoLista.Lista[I].Quantidade *
                                        FModelPedidoLista.Lista[I].ValorUnitatio);

    LValorDescontoProdutoSelecionado := LValorDescontoProdutoSelecionado +
                                        FModelPedidoLista.Lista[I].Desconto.Valor;
  end;
  AlterarValoresProdutosSelecionadosResumo(LValorSubTotalProdutoSelecionado,LValorDescontoProdutoSelecionado);
  // Alterando a quantidade, o icone acima da descrição do resumo
  AlterarQuantidadeProdutosSelecionadosResumo(FModelPedidoLista.Lista.Count);
  btnPagamento.Enabled := FModelPedidoLista.Lista.Count > 0;
end;

procedure TViewPedido.recQuanidadeAdicionarClick(Sender: TObject);
begin
  inherited;
  FrameComponentesTecladoQuantidade1.OpenQuantidade;
  FrameComponentesTecladoQuantidade1.SetQuantidade(StrToIntDef(TModelUtils.ExtractNumber(lblQuantidadeAdicionar.Text),1));
  FrameComponentesTecladoQuantidade1.OnClickConfirmar := EventoAtualizarValorQuantidade;
end;

procedure TViewPedido.Salvar;
begin

end;

procedure TViewPedido.btnSalvarClick(Sender: TObject);
begin
  inherited;
  if FQuantidadeProdutoNaoSalvo > 0 then
  begin
    FramePagamentoVendedor1.OpenVendedor;
    // Esse evento abaixo vai ocorrer assim que selecionar o vendedor
    FramePagamentoVendedor1.EventoDepoisDeSelecionarVendedor :=
    procedure(AIdUser:string)
    begin
      OpenLoad;
      TThread.CreateAnonymousThread(
      procedure
      begin
        var LDAOPedidoItem := TDAOPedidoItem.Create(ModelConnection.Connection);
        try
          LDAOPedidoItem.AlterarUsuario(FDAOPedido.Dados.Id,AIdUser)
        finally
          FreeAndNil(LDAOPedidoItem);
        end;

        if FPrimeiroItemSemSalvarProduto then
        begin
          FDAOPedido.UpdateSync(FDAOPedido.Dados.Id,0);
        end;

        TThread.Synchronize(nil,
        procedure
        begin
          FPrimeiroItemSemSalvarProduto := False;
          TModelSincronizacao.GetInstance.NovoPedido;
          btnSalvar.Enabled := False;
          Close;
          CloseLoad;
        end);
      end).Start;
    end;
  end
  else
  begin
    if FPrimeiroItemSemSalvarProduto then
    begin
      FDAOPedido.UpdateSync(FDAOPedido.Dados.Id,0);
    end;

    FPrimeiroItemSemSalvarProduto := False;
    TModelSincronizacao.GetInstance.NovoPedido;
    btnSalvar.Enabled := False;
    Close;
  end;
end;


procedure TViewPedido.TabControlChange(Sender: TObject);
begin
  inherited;
  if TabControl.ActiveTab.Equals(tabProdutos) then
  begin
    TAnimator.AnimateFloat(recSublinhado,'Position.X',laySublinhado.Padding.Left - 10,0.2);
  end
  else if TabControl.ActiveTab.Equals(tabResumo) then
  begin
    TAnimator.AnimateFloat(recSublinhado,'Position.X',(laySublinhado.Width - recSublinhado.Width)-(laySublinhado.Padding.Right-10),0.2);
  end;
end;

end.
