unit View.Produto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Edit,
  FMX.TabControl, View.Edit.Base, View.Edit.ComboBox, FMX.Effects,RESTRequest4D,
  FMX.Filter.Effects, View.Button.Base, FMX.ListBox,System.JSON,
  System.Generics.Collections,
  Model.Static.Credencial,Frame.Produto.Lista, View.ComboBox.Base, Helper.Edit,
  Model.Utils, FMX.MediaLibrary.Actions, FMX.StdActns, System.Actions,
  FMX.ActnList, u99Permissions;

type
  TProdutoSelecionado = record
    Id:string;
    procedure Clear;
  end;
  TViewProduto = class(TViewBase)
    recContentImage: TRectangle;
    imgProduto: TImage;
    layContainerCamera: TLayout;
    layButtonCamera: TLayout;
    recAdicionarFoto: TRectangle;
    Circle1: TCircle;
    Label3: TLabel;
    recSelecionarCamera: TRectangle;
    lblCamera: TLabel;
    lblGaleriaImagem: TLabel;
    TabControlCadastro: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    recDescricao: TRectangle;
    edtDescricao: TEdit;
    Label8: TLabel;
    Label1: TLabel;
    edtComboBoxUnidadeMedida: TViewEditComboBox;
    Label2: TLabel;
    edtComboBoxModeloFiscal: TViewEditComboBox;
    Label4: TLabel;
    edtComboBoxCategoria: TViewEditComboBox;
    Label5: TLabel;
    TabItem3: TTabItem;
    layNumeroBairro: TLayout;
    Layout3: TLayout;
    Label9: TLabel;
    recPrecoCusto: TRectangle;
    edtPrecoCusto: TEdit;
    Layout4: TLayout;
    Label7: TLabel;
    Layout1: TLayout;
    Layout2: TLayout;
    Label6: TLabel;
    recMargemLucro: TRectangle;
    edtMargemLucro: TEdit;
    Layout5: TLayout;
    layEstoque: TLayout;
    layQuantidadeEstoque: TLayout;
    Label11: TLabel;
    recQuantidadeEstoque: TRectangle;
    edtQuantidadeEstoque: TEdit;
    layEstoqueMinimo: TLayout;
    Label12: TLabel;
    recEstoqueMinimo: TRectangle;
    edtEstoqueMinimo: TEdit;
    TabItem4: TTabItem;
    Layout9: TLayout;
    Layout10: TLayout;
    Label10: TLabel;
    recCest: TRectangle;
    edtCest: TEdit;
    Layout11: TLayout;
    Label13: TLabel;
    recNcm: TRectangle;
    edtNcm: TEdit;
    Layout12: TLayout;
    Label16: TLabel;
    Label17: TLabel;
    recPrecoVenda: TRectangle;
    edtPrecoVenda: TEdit;
    Label18: TLabel;
    edtComboBoxAtivo: TViewEditComboBox;
    recToolbar: TRectangle;
    Label19: TLabel;
    imgSalvar: TImage;
    FillRGBEffect2: TFillRGBEffect;
    imgDelete: TImage;
    imgVoltar: TImage;
    FillRGBEffect1: TFillRGBEffect;
    layButtonsEnderecoEmpresa: TLayout;
    btnProximoEnderecoEmpresa: TViewButtonBase;
    layButtonsTab2: TLayout;
    btnVoltarEnderecoEmpresa: TViewButtonBase;
    ViewButtonBase1: TViewButtonBase;
    layButtonsTab3: TLayout;
    ViewButtonBase2: TViewButtonBase;
    ViewButtonBase3: TViewButtonBase;
    Layout8: TLayout;
    ViewButtonBase4: TViewButtonBase;
    TabControlProduto: TTabControl;
    tabLista: TTabItem;
    tabCadastro: TTabItem;
    ListBox: TListBox;
    imgSemRegistro: TImage;
    Label20: TLabel;
    recButtonAdicionar: TRectangle;
    Label21: TLabel;
    ShadowEffect1: TShadowEffect;
    layTab4: TLayout;
    layTab3: TLayout;
    layTab2: TLayout;
    layTab1: TLayout;
    ActionList: TActionList;
    ActPerfil: TChangeTabAction;
    ActBol: TChangeTabAction;
    ActMenu: TChangeTabAction;
    ActListaReverva: TChangeTabAction;
    actCamera: TTakePhotoFromCameraAction;
    actLibary: TTakePhotoFromLibraryAction;
    Layout13: TLayout;
    Label14: TLabel;
    recCodigoBarra: TRectangle;
    edtBarcode: TEdit;
    edtComboBoxDeclaraPisCofins: TViewEditComboBox;
    edtComboBoxAlteraPreco: TViewEditComboBox;
    imgFotoPadao: TImage;
    procedure recAdicionarFotoClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnProximoEnderecoEmpresaClick(Sender: TObject);
    procedure ViewButtonBase1Click(Sender: TObject);
    procedure btnVoltarEnderecoEmpresaClick(Sender: TObject);
    procedure ViewButtonBase3Click(Sender: TObject);
    procedure ViewButtonBase2Click(Sender: TObject);
    procedure ViewButtonBase4Click(Sender: TObject);
    procedure recButtonAdicionarClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure ListBoxItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormDestroy(Sender: TObject);
    procedure lblCameraClick(Sender: TObject);
    procedure lblGaleriaImagemClick(Sender: TObject);
    procedure edtPrecoCustoTyping(Sender: TObject);
    procedure edtPrecoCustoKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtPreco2KeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtPreco2Typing(Sender: TObject);
    procedure edtPrecoVendaKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtPrecoVendaTyping(Sender: TObject);
    procedure edtMargemLucroKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtMargemLucroTyping(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
    procedure edtCestKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtNcmKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtBarcodeKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtGtinKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtGtinTyping(Sender: TObject);
    procedure edtBarcodeTyping(Sender: TObject);
    procedure edtCestTyping(Sender: TObject);
    procedure edtNcmTyping(Sender: TObject);
    procedure edtQuantidadeEstoqueTyping(Sender: TObject);
    procedure edtEstoqueMinimoTyping(Sender: TObject);
    procedure edtEstoqueMinimoKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtQuantidadeEstoqueKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure imgDeleteClick(Sender: TObject);
    procedure lblCameraTap(Sender: TObject; const Point: TPointF);
    procedure lblGaleriaImagemTap(Sender: TObject; const Point: TPointF);
    procedure actCameraDidFinishTaking(Image: TBitmap);
    procedure actLibaryDidFinishTaking(Image: TBitmap);
  private
    const LIMIT = 15;
    procedure DeletarRegistro;
    var
    FProdutoSelecionado:TProdutoSelecionado;
    FVisualizarOpcaoBuscaImagem: Boolean;
    FListUnidadeMedidaCodigoIndex:TDictionary<Integer,string>;
    FListCategoriaCodigoIndex:TDictionary<Integer,string>;
    FListModeloFiscalCodigoIndex:TDictionary<Integer,string>;
    FPaginacao:TPaginacao;
    FViewComboBoxCategoria:TViewComboBoxBase;
    FViewComboBoxUnidadeMedida:TViewComboBoxBase;
    FViewComboBoxModeloFiscal:TViewComboBoxBase;
    FViewComboBoxAtivo:TViewComboBoxBase;
    FViewComboBoxDeclaraPisCofins:TViewComboBoxBase;
    FViewComboBoxAlteraPreco:TViewComboBoxBase;
    FPermissao:T99Permissions;
    procedure ErroCamera(Sender:TObject);
    procedure SetVisualizarOpcaoBuscaImagem(const Value: Boolean);
    procedure GetComboBoxUnidadeMedida;
    procedure GetComboBoxCategoria;
    procedure GetComboBoxModeloFiscal;
    procedure CriarViewComboBox;
    procedure CarregarComboBox;
    procedure CarregarLista(const AJson:TJSONArray);
    procedure CarregarDadosCadastro(const AJsonObject:TJSONObject);
    procedure OnResizeLayout;
    procedure CentralizarLayout(ALayout:TLayout);
    procedure Voltar;
    procedure ValidarPrimeiraEtapa;
    procedure ValidarSegundaEtapa;
    procedure ValidarTerceiraEtapa;
    procedure ValidarQuartaEtapa;
    procedure Adicionar;
    procedure SalvarProduto;
    procedure PrimeiroCarregamento;
    procedure OnClickItemProduto(Sender:TObject);
    procedure LimparTodosCampos;
    property VisualizarOpcaoBuscaImagem:Boolean read FVisualizarOpcaoBuscaImagem write SetVisualizarOpcaoBuscaImagem;
  protected
    procedure OnClickDeletarRegistro; override;
  public
    procedure ExecuteOnShow; override;
  end;

implementation

{$R *.fmx}

{ TViewProduto }

procedure TViewProduto.actCameraDidFinishTaking(Image: TBitmap);
begin
  try
    if Assigned(Image) then
    begin
      imgProduto.Bitmap := Image;
    end;

  except on E: Exception do
    begin
      imgProduto.Bitmap := imgFotoPadao.Bitmap;
      ShowErro(e.Message);
      Exit;
    end;
  end;
end;

procedure TViewProduto.actLibaryDidFinishTaking(Image: TBitmap);
begin
  try
    if Assigned(Image) then
    begin
      imgProduto.Bitmap := Image;
    end;

  except on E: Exception do
    begin
      imgProduto.Bitmap := imgFotoPadao.Bitmap;
      ShowErro(e.Message);
      Exit;
    end;
  end;
end;

procedure TViewProduto.Adicionar;
begin
  LimparTodosCampos;
  recButtonAdicionar.Visible := False;
  TabControlCadastro.GotoVisibleTab(0);
  TabControlProduto.GotoVisibleTab(1);
  edtDescricao.SetFocus;
  FViewComboBoxDeclaraPisCofins.SetItemByCodigo(2);
  FViewComboBoxAtivo.SetItemByCodigo(1);
  FViewComboBoxAlteraPreco.SetItemByCodigo(2);
  edtComboBoxAtivo.Enabled  := False;
  imgSalvar.Visible         := True;
  edtPrecoCusto.Text        := '0,00';
  edtPrecoVenda.Text        := '0,00';
  edtMargemLucro.Text       := '% 0,00';
  edtQuantidadeEstoque.Text := '0';
  edtEstoqueMinimo.Text     := '0';
end;

procedure TViewProduto.btnProximoEnderecoEmpresaClick(Sender: TObject);
begin
  inherited;
  try
    ValidarPrimeiraEtapa;
    TabControlCadastro.GotoVisibleTab(1);
  except on E: Exception do
    begin
      ShowErro(e.Message);
    end;
  end;
end;

procedure TViewProduto.btnVoltarEnderecoEmpresaClick(Sender: TObject);
begin
  inherited;
  TabControlCadastro.GotoVisibleTab(0);
end;

procedure TViewProduto.CarregarComboBox;
begin
  TThread.CreateAnonymousThread(
  procedure
  begin
    try
      GetComboBoxUnidadeMedida;
      GetComboBoxCategoria;
      GetComboBoxModeloFiscal;
    except on E: Exception do
      begin
        ShowErro(E.Message);
      end;
    end;
  end).Start;
end;

procedure TViewProduto.CarregarDadosCadastro(const AJsonObject: TJSONObject);
begin

  FProdutoSelecionado.Id := AJsonObject.GetValue<string>('id','');

  var LIdUnidadeMendida := AJsonObject.GetValue<String>('unityId','');
  for var LKey in FListUnidadeMedidaCodigoIndex.Keys do
  begin
    var LValue := FListUnidadeMedidaCodigoIndex.Items[Lkey];
    if LValue.Equals(LIdUnidadeMendida) then
    begin
      FViewComboBoxUnidadeMedida.SetItemByCodigo(LKey);
      Break
    end;
  end;
  FViewComboBoxCategoria.SetItemByCodigo(0);
  var LIdCategoria := AJsonObject.GetValue<String>('categoryId','');
  for var LKey in FListCategoriaCodigoIndex.Keys do
  begin
    var LValue := FListCategoriaCodigoIndex.Items[Lkey];
    if LValue.Equals(LIdCategoria) then
    begin
      FViewComboBoxCategoria.SetItemByCodigo(LKey);
      Break
    end;
  end;

  var LIdModeloFiscal := AJsonObject.GetValue<String>('taxId','');
  for var LKey in FListModeloFiscalCodigoIndex.Keys do
  begin
    var LValue := FListModeloFiscalCodigoIndex.Items[Lkey];
    if LValue.Equals(LIdModeloFiscal) then
    begin
      FViewComboBoxModeloFiscal.SetItemByCodigo(LKey);
      Break
    end;
  end;

  case AJsonObject.GetValue<Boolean>('declarePisCofins',False) of
    True:FViewComboBoxDeclaraPisCofins.SetItemByCodigo(1);
    False:FViewComboBoxDeclaraPisCofins.SetItemByCodigo(2);
  end;

  case AJsonObject.GetValue<Boolean>('changePrice',False) of
    True:FViewComboBoxAlteraPreco.SetItemByCodigo(1);
    False:FViewComboBoxAlteraPreco.SetItemByCodigo(2);
  end;  

  case AJsonObject.GetValue<Boolean>('active',False) of
    True:FViewComboBoxAtivo.SetItemByCodigo(1);
    False:FViewComboBoxAtivo.SetItemByCodigo(2);
  end;
  
  edtDescricao.Text         := AJsonObject.GetValue<String>('description','');
  edtBarcode.Text           := TModelUtils.ExtractNumber(AJsonObject.GetValue<String>('barcode','0'));
  edtPrecoCusto.Text        := FormatFloat('#,##0.00',AJsonObject.GetValue<Currency>('priceCost',0));
  edtPrecoVenda.Text        := FormatFloat('#,##0.00',AJsonObject.GetValue<Currency>('salePrice',0));
  edtMargemLucro.Text       := FormatFloat('#,##0.00',AJsonObject.GetValue<Currency>('profitMargin',0));
  edtQuantidadeEstoque.Text := TModelUtils.ExtractNumber(AJsonObject.GetValue<string>('stockQuantity','0'));
  edtEstoqueMinimo.Text     := TModelUtils.ExtractNumber(AJsonObject.GetValue<string>('minimumStock','0'));
  edtNcm.Text               := TModelUtils.ExtractNumber(AJsonObject.GetValue<String>('ncm','0'));
  edtCest.Text              := TModelUtils.ExtractNumber(AJsonObject.GetValue<String>('cest','0'));

  edtPrecoCusto.FormatMoney;
  edtPrecoVenda.FormatMoney;
  edtMargemLucro.FormatPercentage;
end;

procedure TViewProduto.CarregarLista(const AJson: TJSONArray);
begin
  ListBox.BeginUpdate;
  for var I := 0 to Pred(AJson.Count) do
  begin
    var LItem               := AJson.Items[i] as TJSONObject;
    var LItemListBox        := TListBoxItem.Create(ListBox);
    LItemListBox.Selectable := False;
    var LFrame              := TFrameProdutoLista.Create(LItemListBox);
    LFrame.Name             := 'Produto'+I.ToString;
    LFrame.Id               := LItem.GetValue<string>('id','');
    LFrame.Descricao        := LItem.GetValue<string>('description','');
    LFrame.LoadImage(LItem.GetValue<string>('image',''));
    LFrame.OnClickItem      := OnClickItemProduto;
    LFrame.Height           := 60;
    LItemListBox.Height     := LFrame.Height;
    LItemListBox.AddObject(LFrame);
    ListBox.AddObject(LItemListBox);
    LFrame.Align            := TAlignLayout.Client;
  end;
  ListBox.EndUpdate;
end;

procedure TViewProduto.CentralizarLayout(ALayout: TLayout);
begin
  var LWidth := (ALayout.Width/2);
  if ALayout.Controls[0] is TLayout then
  begin
    TLayout(ALayout.Controls[0]).Align := TAlignLayout.Left;
    TLayout(ALayout.Controls[0]).Width := LWidth;
  end;
  if ALayout.Controls[1] is TLayout then
  begin
    TLayout(ALayout.Controls[1]).Align := TAlignLayout.Left;
    TLayout(ALayout.Controls[1]).Width := LWidth;
  end;
end;

procedure TViewProduto.CriarViewComboBox;
begin
  FViewComboBoxCategoria              := TViewComboBoxBase.Create(layView);
  FViewComboBoxCategoria.Name         := 'ViewComboBoxCategoria';
  FViewComboBoxCategoria.Parent       := layView;
  FViewComboBoxCategoria.Align        := TAlignLayout.Contents;
  FViewComboBoxCategoria.Visible      := False;
  FViewComboBoxCategoria.EditComboBox := edtComboBoxCategoria;
  FViewComboBoxCategoria.Title        := 'Categoria';

  FViewComboBoxUnidadeMedida              := TViewComboBoxBase.Create(layView);
  FViewComboBoxUnidadeMedida.Name         := 'ViewComboBoxUnidadeMedida';
  FViewComboBoxUnidadeMedida.Parent       := layView;
  FViewComboBoxUnidadeMedida.Align        := TAlignLayout.Contents;
  FViewComboBoxUnidadeMedida.Visible      := False;
  FViewComboBoxUnidadeMedida.EditComboBox := edtComboBoxUnidadeMedida;
  FViewComboBoxUnidadeMedida.Title        := 'Unidade Medida';

  FViewComboBoxModeloFiscal              := TViewComboBoxBase.Create(layView);
  FViewComboBoxModeloFiscal.Name         := 'ViewComboBoxModelFiscal';
  FViewComboBoxModeloFiscal.Parent       := layView;
  FViewComboBoxModeloFiscal.Align        := TAlignLayout.Contents;
  FViewComboBoxModeloFiscal.Visible      := False;
  FViewComboBoxModeloFiscal.EditComboBox := edtComboBoxModeloFiscal;
  FViewComboBoxModeloFiscal.Title        := 'Modelo Fiscal';

  FViewComboBoxAtivo              := TViewComboBoxBase.Create(layView);
  FViewComboBoxAtivo.Name         := 'ViewComboBoxAtivo';
  FViewComboBoxAtivo.Parent       := layView;
  FViewComboBoxAtivo.Align        := TAlignLayout.Contents;
  FViewComboBoxAtivo.Visible      := False;
  FViewComboBoxAtivo.EditComboBox := edtComboBoxAtivo;
  FViewComboBoxAtivo.Title        := 'Ativo';

  FViewComboBoxDeclaraPisCofins              := TViewComboBoxBase.Create(layView);
  FViewComboBoxDeclaraPisCofins.Name         := 'ViewComboBoxPisCofins';
  FViewComboBoxDeclaraPisCofins.Parent       := layView;
  FViewComboBoxDeclaraPisCofins.Align        := TAlignLayout.Contents;
  FViewComboBoxDeclaraPisCofins.Visible      := False;
  FViewComboBoxDeclaraPisCofins.EditComboBox := edtComboBoxDeclaraPisCofins;
  FViewComboBoxDeclaraPisCofins.Title        := 'Declara Pis / Cofins';  

  FViewComboBoxAlteraPreco              := TViewComboBoxBase.Create(layView);
  FViewComboBoxAlteraPreco.Name         := 'ViewComboBoxAlteraPreco';
  FViewComboBoxAlteraPreco.Parent       := layView;
  FViewComboBoxAlteraPreco.Align        := TAlignLayout.Contents;
  FViewComboBoxAlteraPreco.Visible      := False;
  FViewComboBoxAlteraPreco.EditComboBox := edtComboBoxAlteraPreco;
  FViewComboBoxAlteraPreco.Title        := 'Altera preço';  
  
end;

procedure TViewProduto.edtBarcodeKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  TEdit(Sender).SelStart := TEdit(Sender).Text.Length;
end;

procedure TViewProduto.edtBarcodeTyping(Sender: TObject);
begin
  inherited;
  TEdit(Sender).Text := TEdit(Sender).OnlyNumer;
end;

procedure TViewProduto.edtCestKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  TEdit(Sender).SelStart := TEdit(Sender).Text.Length;
end;

procedure TViewProduto.edtCestTyping(Sender: TObject);
begin
  inherited;
  TEdit(Sender).Text := TEdit(Sender).OnlyNumer;
end;

procedure TViewProduto.edtEstoqueMinimoKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  TEdit(Sender).SelStart := TEdit(Sender).Text.Length;
end;

procedure TViewProduto.edtEstoqueMinimoTyping(Sender: TObject);
begin
  inherited;
  TEdit(Sender).Text := TEdit(Sender).OnlyNumer;
  if TEdit(Sender).Text.StartsWith('0') then
    TEdit(Sender).Text := Copy(TEdit(Sender).Text,2);
end;

procedure TViewProduto.edtGtinKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  TEdit(Sender).SelStart := TEdit(Sender).Text.Length;
end;

procedure TViewProduto.edtGtinTyping(Sender: TObject);
begin
  inherited;
  TEdit(Sender).Text := TEdit(Sender).OnlyNumer;
end;

procedure TViewProduto.edtMargemLucroKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  TEdit(Sender).SelStart := TEdit(Sender).Text.Length;
end;

procedure TViewProduto.edtMargemLucroTyping(Sender: TObject);
begin
  inherited;
  TEdit(Sender).FormatPercentage;
  if edtPrecoCusto.ToCurrency > 0 then
  begin
    var LPrecoVenda:Currency;
    var LPorcentagem:Currency;
    LPorcentagem       := (edtMargemLucro.ToCurrency / 100);
    LPrecoVenda        := edtPrecoCusto.ToCurrency * LPorcentagem;
    edtPrecoVenda.Text := FormatFloat('#,##0.00',(edtPrecoCusto.ToCurrency + LPrecoVenda));
  end; 
end;

procedure TViewProduto.edtNcmKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  TEdit(Sender).SelStart := TEdit(Sender).Text.Length;
end;

procedure TViewProduto.edtNcmTyping(Sender: TObject);
begin
  inherited;
  TEdit(Sender).Text := TEdit(Sender).OnlyNumer;
end;

procedure TViewProduto.edtPrecoCustoKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  TEdit(Sender).SelStart := TEdit(Sender).Text.Length;
end;

procedure TViewProduto.edtPrecoCustoTyping(Sender: TObject);
begin
  inherited;
  TEdit(Sender).FormatMoney;
  if edtPrecoCusto.ToCurrency > 0 then
  begin
    var LLucroLiquido:Currency;
    var LPorcentagem:Currency;
    LLucroLiquido := edtPrecoVenda.ToCurrency - edtPrecoCusto.ToCurrency;
    LPorcentagem := (LLucroLiquido / edtPrecoCusto.ToCurrency) * 100;
    edtMargemLucro.Text := '% '+FormatFloat('#,##0.00',LPorcentagem);
  end;   
end;

procedure TViewProduto.edtPrecoVendaKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  TEdit(Sender).SelStart := TEdit(Sender).Text.Length;
end;

procedure TViewProduto.edtPrecoVendaTyping(Sender: TObject);
begin
  inherited;
  TEdit(Sender).FormatMoney;
  {TODO -oGabriel -cBug : Dividindo valor por zero }
  if (edtPrecoCusto.ToCurrency <= 0) then
  begin
    edtMargemLucro.Text := '% '+FormatFloat('#,##0.00',0);
  end
  else if (edtPrecoVenda.ToCurrency > 0)  then
  begin
    var LLucroLiquido:Currency;
    var LPorcentagem:Currency  := 0;
    LLucroLiquido := edtPrecoVenda.ToCurrency - edtPrecoCusto.ToCurrency;
    if LLucroLiquido > 0 then
      LPorcentagem := (LLucroLiquido / edtPrecoCusto.ToCurrency) * 100;
    edtMargemLucro.Text := '% '+FormatFloat('#,##0.00',LPorcentagem);
  end;
end;

procedure TViewProduto.edtQuantidadeEstoqueKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  TEdit(Sender).SelStart := TEdit(Sender).Text.Length;
end;

procedure TViewProduto.edtQuantidadeEstoqueTyping(Sender: TObject);
begin
  inherited;
  TEdit(Sender).Text := TEdit(Sender).OnlyNumer;
  if TEdit(Sender).Text.StartsWith('0') then
    TEdit(Sender).Text := Copy(TEdit(Sender).Text,2);
  //TEdit(Sender).Text := FormatFloat('#,##',StrToCurrDef(TEdit(Sender).Text,0));    
end;

procedure TViewProduto.edtPreco2KeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  TEdit(Sender).SelStart := TEdit(Sender).Text.Length;
end;

procedure TViewProduto.edtPreco2Typing(Sender: TObject);
begin
  inherited;
  TEdit(Sender).FormatMoney;
end;

procedure TViewProduto.ErroCamera(Sender: TObject);
begin
  ShowErro('Erro ao tentar acessar a câmera');
end;

procedure TViewProduto.ExecuteOnShow;
begin
  inherited;
  CarregarComboBox;
  imgSalvar.Visible           := False;
  imgDelete.Visible           := False;
  recButtonAdicionar.Visible  := True;
  recSelecionarCamera.Visible := False;
  OnResizeLayout;
  TabControlCadastro.GotoVisibleTab(0);
  TabControlProduto.GotoVisibleTab(0);
  PrimeiroCarregamento;
  LimparTodosCampos;
  edtComboBoxAtivo.Enabled := True;
end;

procedure TViewProduto.FormCreate(Sender: TObject);
begin
  inherited;
  FPermissao := T99Permissions.Create;
  TabControlCadastro.Margins.Top := - 50;
  TabControlProduto.Margins.Top  := - 50;
  FListUnidadeMedidaCodigoIndex  := TDictionary<Integer,string>.Create;
  FListCategoriaCodigoIndex      := TDictionary<Integer,string>.Create;
  FListModeloFiscalCodigoIndex   := TDictionary<Integer,string>.Create;
  CriarViewComboBox;

  FViewComboBoxAtivo.AddItem(1,'Sim');
  FViewComboBoxAtivo.AddItem(2,'Não');

  FViewComboBoxDeclaraPisCofins.AddItem(1,'Sim');
  FViewComboBoxDeclaraPisCofins.AddItem(2,'Não');
  
  FViewComboBoxAlteraPreco.AddItem(1,'Sim');
  FViewComboBoxAlteraPreco.AddItem(2,'Não');
  
  TabControlCadastro.ActiveTab := TabItem1;
  TabControlProduto.ActiveTab  := tabLista;
  imgSemRegistro.Visible       := False;
  ListBox.Visible              := False;
end;

procedure TViewProduto.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPermissao);
  FreeAndNil(FListUnidadeMedidaCodigoIndex);
  FreeAndNil(FListCategoriaCodigoIndex);
  FreeAndNil(FListModeloFiscalCodigoIndex);
  inherited;
end;

procedure TViewProduto.FormResize(Sender: TObject);
begin
  inherited;
  OnResizeLayout;
end;

procedure TViewProduto.GetComboBoxCategoria;
begin
  FViewComboBoxCategoria.ViewListVertical.ClearList;
  FListCategoriaCodigoIndex.Clear;
  var LResponse: IResponse;
  LResponse := TRequest.New.BaseURL(BaseURL)
    .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
    .AddParam('limit','1000')
    .Resource('category')
    .Accept('application/json')
    .Get;

  var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
  try
    // Verificando o status code
    if LResponse.StatusCode <> 200 then
    begin
      if LResponse.StatusCode = 401 then
      begin
        raise Exception.Create('Usuário sem permissão para acessar esse recurso!');
      end;
      raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
    end;

    var LData := LJsonResponse.GetValue<TJSONArray>('data');
    var LJsonArrayCategoria := TJSONArray.ParseJSONValue(LData.ToJSON()) as TJSONArray;

    var LCodigoIndex:Integer := 1;
    FViewComboBoxCategoria.AddItem(0,'Sem categoria');
    for var I := 0 to Pred(LJsonArrayCategoria.Count) do
    begin
      var LJsonItem := LJsonArrayCategoria.Items[I] as TJSONObject;
      FListCategoriaCodigoIndex.Add(LCodigoIndex,LJsonItem.GetValue<string>('id',''));
      FViewComboBoxCategoria.AddItem(LCodigoIndex,LJsonItem.GetValue<string>('name',''));
      Inc(LCodigoIndex);
    end;

  finally
    FreeAndNil(LJsonResponse);
  end;
end;

procedure TViewProduto.GetComboBoxModeloFiscal;
begin
  FViewComboBoxModeloFiscal.ViewListVertical.ClearList;
  FListModeloFiscalCodigoIndex.Clear;
  var LResponse: IResponse;
  LResponse := TRequest.New.BaseURL(BaseURL)
    .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
    .AddParam('limit','1000')
    .Resource('tax-model')
    .Accept('application/json')
    .Get;

  var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
  try
    // Verificando o status code
    if LResponse.StatusCode <> 200 then
    begin
      if LResponse.StatusCode = 401 then
      begin
        raise Exception.Create('Usuário sem permissão para acessar esse recurso!');
      end;
      raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
    end;

    var LData := LJsonResponse.GetValue<TJSONArray>('data');
    var LJsonArrayModeloFiscal := TJSONArray.ParseJSONValue(LData.ToJSON()) as TJSONArray;

    var LCodigoIndex:Integer := 1;
    for var I := 0 to Pred(LJsonArrayModeloFiscal.Count) do
    begin
      var LJsonItem := LJsonArrayModeloFiscal.Items[I] as TJSONObject;
      FListModeloFiscalCodigoIndex.Add(LCodigoIndex,LJsonItem.GetValue<string>('id',''));
      FViewComboBoxModeloFiscal.AddItem(LCodigoIndex,LJsonItem.GetValue<string>('description',''));
      Inc(LCodigoIndex);
    end;

  finally
    FreeAndNil(LJsonResponse);
  end;
end;

procedure TViewProduto.GetComboBoxUnidadeMedida;
begin
  FViewComboBoxUnidadeMedida.ViewListVertical.ClearList;
  FListUnidadeMedidaCodigoIndex.Clear;
  var LResponse: IResponse;
  LResponse := TRequest.New.BaseURL(BaseURL)
    .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
    .AddParam('limit','1000')
    .Resource('unit')
    .Accept('application/json')
    .Get;

  var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
  try
    // Verificando o status code
    if LResponse.StatusCode <> 200 then
    begin
      if LResponse.StatusCode = 401 then
      begin
        raise Exception.Create('Usuário sem permissão para acessar esse recurso!');
      end;
      raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
    end;

    var LData := LJsonResponse.GetValue<TJSONArray>('data');
    var LJsonArrayUnidadeMedida := TJSONArray.ParseJSONValue(LData.ToJSON()) as TJSONArray;

    var LCodigoIndex:Integer := 1;
    for var I := 0 to Pred(LJsonArrayUnidadeMedida.Count) do
    begin
      var LJsonItem := LJsonArrayUnidadeMedida.Items[I] as TJSONObject;
      FListUnidadeMedidaCodigoIndex.Add(LCodigoIndex,LJsonItem.GetValue<string>('id',''));
      FViewComboBoxUnidadeMedida.AddItem(LCodigoIndex,LJsonItem.GetValue<string>('description',''));
      Inc(LCodigoIndex);
    end;

  finally
    FreeAndNil(LJsonResponse);
  end;
end;

procedure TViewProduto.imgDeleteClick(Sender: TObject);
begin
  OpenDelete;
end;

procedure TViewProduto.imgSalvarClick(Sender: TObject);
begin
  inherited;
  SalvarProduto;
end;

procedure TViewProduto.imgVoltarClick(Sender: TObject);
begin
  Voltar;
end;

procedure TViewProduto.lblCameraClick(Sender: TObject);
begin
  inherited;
  VisualizarOpcaoBuscaImagem := False;
  {$IFDEF MSWINDOWS}
  try
    Fpermissao.Camera(actCamera,ErroCamera);
  except on E: Exception do
    begin
      ShowErro(e.Message);
    end;
  end;
 {$ENDIF}
end;

procedure TViewProduto.lblCameraTap(Sender: TObject; const Point: TPointF);
begin
  inherited;
  VisualizarOpcaoBuscaImagem := False;
  try
    Fpermissao.Camera(actCamera,ErroCamera);
  except on E: Exception do
    begin
      ShowErro(e.Message);
    end;
  end;
end;

procedure TViewProduto.lblGaleriaImagemClick(Sender: TObject);
begin
  inherited;
  VisualizarOpcaoBuscaImagem := False;
  {$IFDEF MSWINDOWS}
  actLibary.Execute;
  {$ENDIF}
end;

procedure TViewProduto.lblGaleriaImagemTap(Sender: TObject;
  const Point: TPointF);
begin
  inherited;
  VisualizarOpcaoBuscaImagem := False;
  actLibary.Execute;
end;

procedure TViewProduto.LimparTodosCampos;
begin
  FViewComboBoxCategoria.UnMarkerList;
  FViewComboBoxUnidadeMedida.UnMarkerList;
  FViewComboBoxModeloFiscal.UnMarkerList;
  FViewComboBoxAtivo.UnMarkerList;
  imgProduto.Bitmap := imgFotoPadao.Bitmap;
  edtDescricao.Clear;
  edtComboBoxUnidadeMedida.Clear;
  edtComboBoxModeloFiscal.Clear;
  edtComboBoxCategoria.Clear;
  edtPrecoCusto.Clear;
  edtPrecoVenda.Clear;
  edtMargemLucro.Clear;
  edtQuantidadeEstoque.Clear;
  edtEstoqueMinimo.Clear;
  edtCest.Clear;
  edtNcm.Clear;
  edtBarcode.Clear;
  edtComboBoxDeclaraPisCofins.Clear;
  //edtPreco.Clear;
  edtComboBoxAtivo.Clear;
end;

procedure TViewProduto.ListBoxItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  inherited;
  for var I := 0 to Pred(Item.ControlsCount) do
  begin
    if Item.Controls[i] is TFrameProdutoLista then
    begin
      if Assigned(TFrameProdutoLista(Item.Controls[i]).OnClickItem) then
        TFrameProdutoLista(Item.Controls[i]).OnClickItem(TFrameProdutoLista(Item.Controls[i]));
      Break;
    end;
  end;
end;

procedure TViewProduto.OnClickDeletarRegistro;
begin
  inherited;
  DeletarRegistro;
end;

procedure TViewProduto.OnClickItemProduto(Sender: TObject);
begin
  OpenLoad;
  if not (Sender is TFrameProdutoLista) then
    raise Exception.Create('Erro ao selecionar item da lista!');

  var LId := TFrameProdutoLista(Sender).Id;
  TThread.CreateAnonymousThread(
  procedure
  var LResponse: IResponse;
  begin
    try
      if LId.IsEmpty then
        raise Exception.Create('Codigo do produto não informado!');


      LResponse := TRequest.New.BaseURL(BaseURL)
        .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
        .Resource('product/'+LId)
        .Accept('application/json')
        .Get;

      var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
      try
        // Verificando o status code
        if LResponse.StatusCode <> 200 then
        begin
          if LResponse.StatusCode = 401 then
          begin
            raise Exception.Create('Usuário sem permissão para acessar esse recurso!');
          end;
          raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
        end;

        var LData := LJsonResponse.GetValue<TJSONObject>('data');

        TThread.Synchronize(nil,
        procedure
        begin
          CarregarDadosCadastro(LData);
          FPaginacao.PaginaAtual        := 1;
          FPaginacao.TotalDeRegistros   := LJsonResponse.GetValue<Integer>('count_record',0);
          FPaginacao.FRegistroJaListado := LJsonResponse.GetValue<Integer>('record_of_page',0);
          FPaginacao.CarregandoPagina   := False;

          if (TFrameProdutoLista(Sender).Circle.Fill.Bitmap.Bitmap <> nil) then
            imgProduto.Bitmap := TFrameProdutoLista(Sender).Circle.Fill.Bitmap.Bitmap;

          recButtonAdicionar.Visible   := False;
          imgDelete.Visible            := True;
          imgSalvar.Visible            := True;
          OnResizeLayout;
          TabControlCadastro.GotoVisibleTab(0);
          TabControlProduto.GotoVisibleTab(1);
          CloseLoad;
        end);
      finally
        LJsonResponse.Free;
      end;
    except on E: Exception do
      begin
        FPaginacao.CarregandoPagina := False;
        ShowErro(E.Message);
      end;
    end;
  end).Start;

end;

procedure TViewProduto.OnResizeLayout;
begin
  CentralizarLayout(layEstoque);
  CentralizarLayout(Layout4);
  CentralizarLayout(Layout1);
  CentralizarLayout(Layout9);
  CentralizarLayout(layNumeroBairro);
end;

procedure TViewProduto.PrimeiroCarregamento;
begin
  OpenLoad;
  ListBox.Items.Clear;
  TThread.CreateAnonymousThread(
  procedure
  var LResponse: IResponse;
  begin
    FPaginacao.CarregandoPagina := True;
    try
      LResponse := TRequest.New.BaseURL(BaseURL)
        .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
        .AddParam('limit',LIMIT.ToString)
        .Resource('product')
        .Accept('application/json')
        .Get;

      var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
      try
        // Verificando o status code
        if LResponse.StatusCode <> 200 then
        begin
          if LResponse.StatusCode = 401 then
          begin
            raise Exception.Create('Usuário sem permissão para acessar esse recurso!');
          end;
          raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
        end;

        var LData := LJsonResponse.GetValue<TJSONArray>('data');
        var LJsonArrayClientes := TJSONArray.ParseJSONValue(LData.ToJSON()) as TJSONArray;

        TThread.Synchronize(nil,
        procedure
        begin
          CarregarLista(LJsonArrayClientes);
          FPaginacao.PaginaAtual        := 1;
          FPaginacao.TotalDeRegistros   := LJsonResponse.GetValue<Integer>('count_record',0);
          FPaginacao.FRegistroJaListado := LJsonResponse.GetValue<Integer>('record_of_page',0);
          FPaginacao.CarregandoPagina   := False;
          imgSemRegistro.Visible        := (FPaginacao.TotalDeRegistros <= 0);
          ListBox.Visible               := not imgSemRegistro.Visible;
          CloseLoad;
        end);
      finally
        LJsonResponse.Free;
      end;
    except on E: Exception do
      begin
        FPaginacao.CarregandoPagina := False;
        ShowErro(E.Message);
      end;
    end;
  end).Start;
end;

procedure TViewProduto.recAdicionarFotoClick(Sender: TObject);
begin
  inherited;
  CloseKeyboard;
  VisualizarOpcaoBuscaImagem := not VisualizarOpcaoBuscaImagem;
end;

procedure TViewProduto.recButtonAdicionarClick(Sender: TObject);
begin
  inherited;
  Adicionar;
end;

procedure TViewProduto.SalvarProduto;
begin
  try
    ValidarPrimeiraEtapa;
    ValidarSegundaEtapa;
    ValidarTerceiraEtapa;
    ValidarQuartaEtapa;

  except on E: Exception do
    begin
      ShowErro(e.Message);
      Exit;
    end;
  end;

  OpenLoad;
  TThread.CreateAnonymousThread(
  procedure
  var LResponse: IResponse;
  var LRequest:IRequest;
  begin

    try
      var LMensagemSucesso:String := EmptyStr;
      var LStream := TMemoryStream.Create;
      var LIdCategoria:string := EmptyStr;

      if edtComboBoxCategoria.Codigo > 0 then
      begin
        LIdCategoria := FListCategoriaCodigoIndex.Items[edtComboBoxCategoria.Codigo];
      end;


      try
        imgProduto.Bitmap.SaveToStream(LStream);
        if FProdutoSelecionado.Id.IsEmpty then
        begin
          LMensagemSucesso := 'Dados do produto cadastrado com sucesso!';
          LRequest := TRequest.New.BaseURL(BaseURL)
            .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
            .Resource('product')
            .AddField('unityId',FListUnidadeMedidaCodigoIndex.Items[edtComboBoxUnidadeMedida.Codigo]);
            if not LIdCategoria.IsEmpty then
            begin
              LRequest.AddField('categoryId',FListCategoriaCodigoIndex.Items[edtComboBoxCategoria.Codigo])
            end;
            LRequest.AddField('taxId',FListModeloFiscalCodigoIndex.Items[edtComboBoxModeloFiscal.Codigo]);
            if (edtComboBoxDeclaraPisCofins.Codigo = 1) then
              LRequest.AddField('declarePisCofins','True')
            else
              LRequest.AddField('declarePisCofins','False');

            LRequest.AddField('description',edtDescricao.Text)
            .AddField('barcode',edtBarcode.OnlyNumer)
            .AddField('priceCost',CurrToStr(edtPrecoCusto.ToCurrency))
            .AddField('salePrice',CurrToStr(edtPrecoVenda.ToCurrency))
            .AddField('profitMargin',CurrToStr(edtMargemLucro.ToCurrency))
            .AddField('stockQuantity',CurrToStr(edtQuantidadeEstoque.ToCurrency))
            .AddField('minimumStock',CurrToStr(edtEstoqueMinimo.ToCurrency))
            .AddField('ncm',edtNcm.OnlyNumer)
            .AddField('cest',edtCest.OnlyNumer);

            if (edtComboBoxAtivo.Codigo = 1) then
              LRequest.AddField('active','True')
            else
              LRequest.AddField('active','False');

            if (edtComboBoxAlteraPreco.Codigo = 1) then
              LRequest.AddField('changePrice','True')
            else
              LRequest.AddField('changePrice','False');


            LRequest.AddField('companyId',TModelStaticCredencial.GetInstance.Company)
            .AddFile('image',LStream)
            .Accept('application/json');
            LResponse := LRequest.Post;
        end
        else
        begin
          LMensagemSucesso := 'Dados do produto alterado com sucesso!';
          LRequest := TRequest.New.BaseURL(BaseURL)
            .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
            .Resource('product/'+FProdutoSelecionado.Id)
            .AddField('unityId',FListUnidadeMedidaCodigoIndex.Items[edtComboBoxUnidadeMedida.Codigo]);
            if not LIdCategoria.IsEmpty then
            begin
              LRequest.AddField('categoryId',FListCategoriaCodigoIndex.Items[edtComboBoxCategoria.Codigo])
            end;
            LRequest.AddField('taxId',FListModeloFiscalCodigoIndex.Items[edtComboBoxModeloFiscal.Codigo]);

            if (edtComboBoxDeclaraPisCofins.Codigo = 1) then
              LRequest.AddField('declarePisCofins','true')
            else
              LRequest.AddField('declarePisCofins','false');

            LRequest.AddField('description',edtDescricao.Text)
            .AddField('barcode',edtBarcode.OnlyNumer)
            .AddField('priceCost',CurrToStr(edtPrecoCusto.ToCurrency))
            .AddField('salePrice',CurrToStr(edtPrecoVenda.ToCurrency))
            .AddField('profitMargin',CurrToStr(edtMargemLucro.ToCurrency))
            .AddField('stockQuantity',CurrToStr(edtQuantidadeEstoque.ToCurrency))
            .AddField('minimumStock',CurrToStr(edtEstoqueMinimo.ToCurrency))
            .AddField('ncm',edtNcm.OnlyNumer)
            .AddField('cest',edtCest.OnlyNumer);

            if (edtComboBoxAtivo.Codigo = 1) then
              LRequest.AddField('active','true')
            else
              LRequest.AddField('active','false');

            if (edtComboBoxAlteraPreco.Codigo = 1) then
              LRequest.AddField('changePrice','true')
            else
              LRequest.AddField('changePrice','false');

            LRequest.AddField('companyId',TModelStaticCredencial.GetInstance.Company)
            .AddFile('image',LStream)
            .Accept('application/json');
            LResponse := LRequest.Put;
        end;
      finally
        FreeAndNil(LStream);
      end;

      TThread.Synchronize(nil,
      procedure
      begin
        CloseLoad;
        var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
        try
          // Verificando o status code
          if LResponse.StatusCode >= 400 then
          begin
            // Tratando o erro
            ShowErro(LJsonResponse.GetValue<string>('error','Erro não identificado! - '+LResponse.Content));
            Exit; // Se der erro ele sai fora e não abre a próxima tela
          end;


        finally
          LJsonResponse.Free;
        end;

        ShowSucesso(LMensagemSucesso);
        Voltar;
        PrimeiroCarregamento;
        ViewMensagem.OnAfterClose := Procedure
                                     begin
                                       ViewMensagem.OnAfterClose := nil;


                                     end;

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

procedure TViewProduto.SetVisualizarOpcaoBuscaImagem(const Value: Boolean);
begin
  FVisualizarOpcaoBuscaImagem := Value;
  recSelecionarCamera.Visible := FVisualizarOpcaoBuscaImagem;
  if FVisualizarOpcaoBuscaImagem then
  begin
    layContainerCamera.Height := 155;
    layTab1.Height            := layTab1.Height + 80;
  end
  else
  begin
    CloseKeyboard;
    layTab1.Height            := 380;
    layContainerCamera.Height := layButtonCamera.Height;
  end;
end;

procedure TViewProduto.ValidarPrimeiraEtapa;
begin
  try
    if edtDescricao.Text.IsEmpty then
      raise Exception.Create('Campo descrição não informado!');

  except on E: Exception do
    begin
      TabControlCadastro.GotoVisibleTab(0);
      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure TViewProduto.ValidarQuartaEtapa;
begin
  try
    
  except on E: Exception do
    begin
      TabControlCadastro.GotoVisibleTab(3);
      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure TViewProduto.ValidarSegundaEtapa;
begin
  try
    if edtComboBoxUnidadeMedida.Codigo <= 0 then
      raise Exception.Create('O campo unidade de medida não pode ser vazio!');

    if edtComboBoxModeloFiscal.Codigo <= 0 then
      raise Exception.Create('O campo modelo fiscal não pode ser vazio!');
 
  except on E: Exception do
    begin
      TabControlCadastro.GotoVisibleTab(1);
      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure TViewProduto.ValidarTerceiraEtapa;
begin
  try
    if edtComboBoxAlteraPreco.Codigo <> 1  then
    begin
      if edtPrecoCusto.ToCurrency <= 0 then
        raise Exception.Create('O campo preço de custo não pode ser menor ou igual a zero!');

      if edtPrecoVenda.ToCurrency <= 0 then
        raise Exception.Create('O campo preço de venda não pode ser menor ou igual a zero!');
    end;

  except on E: Exception do
    begin
      TabControlCadastro.GotoVisibleTab(2);
      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure TViewProduto.ViewButtonBase1Click(Sender: TObject);
begin
  inherited;
  try
    ValidarSegundaEtapa;
    TabControlCadastro.GotoVisibleTab(2);
  except on E: Exception do
    begin
      ShowErro(e.Message);
    end;
  end;
end;

procedure TViewProduto.ViewButtonBase2Click(Sender: TObject);
begin
  inherited;
   TabControlCadastro.GotoVisibleTab(1);
end;

procedure TViewProduto.ViewButtonBase3Click(Sender: TObject);
begin
  inherited;
  try
    ValidarTerceiraEtapa;
    TabControlCadastro.GotoVisibleTab(3);
    imgSalvar.Visible := True;
  except on E: Exception do
    begin
      ShowErro(e.Message);
    end;
  end;
end;

procedure TViewProduto.ViewButtonBase4Click(Sender: TObject);
begin
  inherited;
  TabControlCadastro.GotoVisibleTab(2);
end;

procedure TViewProduto.Voltar;
begin
  if TabControlProduto.ActiveTab.Equals(tabLista) then
  begin
    PriorForm(Self);
  end
  else
  begin
    recButtonAdicionar.Visible  := True;
    imgSalvar.Visible           := False;
    imgDelete.Visible           := False;
    recSelecionarCamera.Visible := False;
    edtComboBoxAtivo.Enabled    := True;
    FProdutoSelecionado.Clear;
    OnResizeLayout;
    TabControlProduto.GotoVisibleTab(0);
    TabControlCadastro.GotoVisibleTab(0);
  end;
end;

procedure TViewProduto.DeletarRegistro;
begin
  CloseDelete;
  OpenLoad;
  TThread.CreateAnonymousThread(
  procedure
  var LResponse: IResponse;
  begin
    try
      if FProdutoSelecionado.id.IsEmpty then
        raise Exception.Create('Código do produto não informado!');

      LResponse := TRequest.New.BaseURL(BaseURL)
        .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
        .Resource('product/'+FProdutoSelecionado.Id)
        .Accept('application/json')
        .Delete;

      var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
      try
        // Verificando o status code
        if LResponse.StatusCode <> 200 then
        begin
          if LResponse.StatusCode = 401 then
          begin
            raise Exception.Create('Usuário sem permissão para acessar esse recurso!');
          end;
          raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
        end;

        TThread.Synchronize(nil,
        procedure
        begin
          PrimeiroCarregamento;
          ShowSucesso('Produto deletado com sucesso!');
          ViewMensagem.OnAfterClose := procedure
                                       begin
                                         ViewMensagem.OnAfterClose := nil;
                                         Voltar;
                                       end
        end);
      finally
        LJsonResponse.Free;
      end;
    except on E: Exception do
      begin
        FPaginacao.CarregandoPagina := False;
        ShowErro(E.Message);
      end;
    end;
  end).Start;
end;

{ TProdutoSelecionado }

procedure TProdutoSelecionado.Clear;
begin
  Id := EmptyStr;
end;

end.
