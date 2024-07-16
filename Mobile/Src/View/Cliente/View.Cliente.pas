unit View.Cliente;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,
  View.Componentes.Censura, View.Edit.Base, View.Edit.ComboBox,
  View.Button.Base, FMX.Edit, FMX.TabControl,System.JSON,RESTRequest4D,
  View.Step, View.ComboBox.Base, Model.Utils, FMX.Effects, FMX.Filter.Effects,
  FMX.ListBox, Frame.Cliente.Lista, Model.Static.Credencial,System.Generics.Collections,
  FMX.VirtualKeyboard,FMX.Platform;

type
  TClienteSelecionado = record
    Id:string;
    procedure Clear;
  end;

  TViewCliente = class(TViewBase)
    TabControlCadastro: TTabControl;
    tabDadosCliente: TTabItem;
    layTab1: TLayout;
    recRazaoSocial: TRectangle;
    edtNomeCliente: TEdit;
    recInscricaoEstadual: TRectangle;
    edtInscricaoEstadual: TEdit;
    recNomeFantasia: TRectangle;
    edtNomeFantasia: TEdit;
    Label2: TLabel;
    lblCaptionRGeIE: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    layButtonsDadosEmpresa: TLayout;
    btnProximoDadosCliente: TViewButtonBase;
    layDadosCNPJ: TLayout;
    layCNPJ: TLayout;
    recCnpj: TRectangle;
    edtCNPJ: TEdit;
    StyleBook1: TStyleBook;
    lblCPFCNPJCaption: TLabel;
    imgPesquisa: TImage;
    edtComboBoxContribuinte: TViewEditComboBox;
    tabEnderecoCliente: TTabItem;
    layTab2: TLayout;
    recCep: TRectangle;
    edtCep: TEdit;
    recEndereco: TRectangle;
    edtLogradouro: TEdit;
    recComplemento: TRectangle;
    edtComplemento: TEdit;
    Label6: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    layNumeroBairro: TLayout;
    Layout3: TLayout;
    Label9: TLabel;
    recNumero: TRectangle;
    edtNumero: TEdit;
    Layout4: TLayout;
    Label7: TLabel;
    recBairro: TRectangle;
    edtBairro: TEdit;
    Label11: TLabel;
    layButtonsEnderecoEmpresa: TLayout;
    btnVoltarEnderecoCliente: TViewButtonBase;
    btnProximoEnderecoCliente: TViewButtonBase;
    edtComboBoxCidade: TViewEditComboBox;
    tabDadosAcesso: TTabItem;
    layTab3: TLayout;
    recTelefone: TRectangle;
    edtTelefone: TEdit;
    recEmail: TRectangle;
    edtEmailUsuario: TEdit;
    Label12: TLabel;
    Label14: TLabel;
    layButtonsDadosAcesso: TLayout;
    btnVoltarDadosAcesso: TViewButtonBase;
    TabControlCliente: TTabControl;
    tabLista: TTabItem;
    tabCadastro: TTabItem;
    recButtonAdicionar: TRectangle;
    Label13: TLabel;
    ShadowEffect1: TShadowEffect;
    recToolbar: TRectangle;
    Label16: TLabel;
    imgSalvar: TImage;
    FillRGBEffect2: TFillRGBEffect;
    imgDelete: TImage;
    imgVoltar: TImage;
    FillRGBEffect1: TFillRGBEffect;
    ListBox: TListBox;
    imgPesquisaCep: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btnProximoDadosClienteClick(Sender: TObject);
    procedure btnVoltarEnderecoClienteClick(Sender: TObject);
    procedure btnProximoEnderecoClienteClick(Sender: TObject);
    procedure btnVoltarDadosAcessoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure recButtonAdicionarClick(Sender: TObject);
    procedure ListBoxItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure ListBoxViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
    procedure edtCNPJKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtInscricaoEstadualKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtInscricaoEstadualTyping(Sender: TObject);
    procedure edtCNPJTyping(Sender: TObject);
    procedure imgPesquisaClick(Sender: TObject);
    procedure edtTelefoneKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtTelefoneTyping(Sender: TObject);
    procedure imgPesquisaCepClick(Sender: TObject);
    procedure edtCepKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtCepTyping(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    const LIMIT = 15;
    var
    FClienteSelecionado:TClienteSelecionado;
    FViewComboBoxTipoContribuinte:TViewComboBoxBase;
    FViewComboBoxCidade:TViewComboBoxBase;
    FPaginacao:TPaginacao;
    procedure GetCNPJ(const ACNPJ:string);
    procedure GetCep(const ACep:string);
    function BuscarCidades:TJSONArray;
    procedure PreencherCidades(const AIdCity:Integer = 0);
    procedure CarregarDadosCadastro(const AJsonObject:TJSONObject);
    procedure CarregarLista(const AJson:TJSONArray);
    procedure OnClickItemCliente(Sender:TObject);
    procedure PrimeiroCarregamento;
    procedure SalvarCliente;
    procedure Adicionar;
    procedure LimparTodosCampos;
    procedure Voltar;
    procedure NovaCargaDeDados;
    procedure IrParaCadastro;
    procedure ValidarPrimeiraEtapa;
    procedure ValidarSegundaEtapa;
    procedure ValidarTerceiraEtapa;
  public
    procedure ExecuteOnShow; override;

  end;

implementation

{$R *.fmx}

procedure TViewCliente.Adicionar;
begin
  LimparTodosCampos;
  IrParaCadastro;
  imgSalvar.Visible := True;
end;

procedure TViewCliente.btnProximoDadosClienteClick(Sender: TObject);
begin
  try
    ValidarPrimeiraEtapa;

    TabControlCadastro.GotoVisibleTab(1);
  except on E: Exception do
    begin
      ShowErro(e.Message);
    end;
  end;
end;

procedure TViewCliente.btnProximoEnderecoClienteClick(Sender: TObject);
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

procedure TViewCliente.btnVoltarDadosAcessoClick(Sender: TObject);
begin
  TabControlCadastro.GotoVisibleTab(1);
end;

procedure TViewCliente.btnVoltarEnderecoClienteClick(Sender: TObject);
begin
  TabControlCadastro.GotoVisibleTab(0);
end;

function TViewCliente.BuscarCidades:TJSONArray;
begin
  var LResponse: IResponse;
  try
    LResponse := TRequest.New.BaseURL(BaseURL)
      .Resource('city')
      .Accept('application/json')
      .Get;

    var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
    try
      // Verificando o status code
      if LResponse.StatusCode <> 200 then
      begin
        raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
      end;

      var LData := LJsonResponse.GetValue<TJSONArray>('data');
      Result := TJSONArray.ParseJSONValue(LData.ToJSON()) as TJSONArray;

    finally
      LJsonResponse.Free;
    end;
  except on E: Exception do
    begin
      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure TViewCliente.CarregarDadosCadastro(const AJsonObject: TJSONObject);
begin
  edtCNPJ.Text              := TModelUtils.FormatCPFCNPJ(AJsonObject.GetValue<string>('cpfCnpj',''));
  edtInscricaoEstadual.Text := AJsonObject.GetValue<string>('ie','');
  FViewComboBoxTipoContribuinte.SetItemByCodigo(AJsonObject.GetValue<Integer>('typeOfTaxpayer',-1));
  edtNomeCliente.Text       := AJsonObject.GetValue<string>('name','');
  edtNomeFantasia.Text      := AJsonObject.GetValue<string>('fantasy','');
  edtLogradouro.Text        := AJsonObject.GetValue<string>('publicPlace','');
  edtNumero.Text            := AJsonObject.GetValue<string>('number','');
  edtComplemento.Text       := AJsonObject.GetValue<string>('complement','');
  edtBairro.Text            := AJsonObject.GetValue<string>('neighborhood','');
  FViewComboBoxCidade.SetItemByCodigo(AJsonObject.GetValue<Integer>('cityId',-1));
  edtTelefone.Text          := TModelUtils.FormatCelular(AJsonObject.GetValue<string>('phone',''));
  edtEmailUsuario.Text      := AJsonObject.GetValue<string>('email','');
  edtCep.Text               := AJsonObject.GetValue<string>('zipCode','');
end;

procedure TViewCliente.CarregarLista(const AJson: TJSONArray);
begin
  if Assigned(AJson) then
  begin
    ListBox.BeginUpdate;
    for var I := 0 to Pred(AJson.Count) do
    begin
      var LItem               := AJson.Items[i] as TJSONObject;
      var LItemListBox        := TListBoxItem.Create(ListBox);
      LItemListBox.Selectable := False;
      var LFrame              := TFrameClienteLista.Create(LItemListBox);
      LFrame.Name             := 'Cliente'+I.ToString;
      LFrame.Id               := LItem.GetValue<string>('id','');
      LFrame.Nome             := LItem.GetValue<string>('name','')+' - '+TModelUtils.FormatCPFCNPJ(LItem.GetValue<string>('cpfCnpj',''));
      LFrame.Height           := 60;
      LFrame.OnClickItem      := OnClickItemCliente;
      LItemListBox.Height     := LFrame.Height;
      LItemListBox.AddObject(LFrame);
      ListBox.AddObject(LItemListBox);
      LFrame.Align            := TAlignLayout.Client;
    end;
    ListBox.EndUpdate;
  end;

end;

procedure TViewCliente.edtCepKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  edtCep.SelStart := edtCep.Text.Length;
end;

procedure TViewCliente.edtCepTyping(Sender: TObject);
begin
  inherited;
  edtCep.Text := edtCep.Text;
  edtCep.Text := TModelUtils.FormatCEP(edtCep.Text);
  edtCep.Text := edtCep.Text;
  edtCep.SetFocus;
end;

procedure TViewCliente.edtCNPJKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  edtCNPJ.SelStart := edtCNPJ.Text.Length;
end;

procedure TViewCliente.edtCNPJTyping(Sender: TObject);
begin
  inherited;
  edtCNPJ.Text := edtCNPJ.Text;
  edtCNPJ.Text := TModelUtils.FormatCPFCNPJ(edtCNPJ.Text);
  edtCNPJ.Text := edtCNPJ.Text;
  edtCNPJ.SetFocus;
  if edtCNPJ.Text.Length < 14 then
  begin
    imgPesquisa.Visible    := False;
    lblCaptionRGeIE.Text   := 'RG / Inscrição estadual';
    lblCPFCNPJCaption.Text := 'CPF / CNPJ';
  end
  else if edtCNPJ.Text.Length = 14 then
  begin
    imgPesquisa.Visible    := False;
    lblCaptionRGeIE.Text   := 'RG';
    lblCPFCNPJCaption.Text := 'CPF';
  end
  else
  begin
    imgPesquisa.Visible    := True;
    lblCaptionRGeIE.Text   := 'Inscrição estadual';
    lblCPFCNPJCaption.Text := 'CNPJ';
  end;
end;

procedure TViewCliente.edtInscricaoEstadualKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  edtInscricaoEstadual.SelStart := edtInscricaoEstadual.Text.Length;
end;

procedure TViewCliente.edtInscricaoEstadualTyping(Sender: TObject);
begin
  inherited;
  edtInscricaoEstadual.Text := edtInscricaoEstadual.Text;
  edtInscricaoEstadual.Text := TModelUtils.ExtractNumber(edtInscricaoEstadual.Text);
  edtInscricaoEstadual.Text := edtInscricaoEstadual.Text;
  edtInscricaoEstadual.SetFocus;
end;

procedure TViewCliente.edtTelefoneKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  edtTelefone.SelStart := edtTelefone.Text.Length;
end;

procedure TViewCliente.edtTelefoneTyping(Sender: TObject);
begin
  inherited;
  edtTelefone.Text := edtTelefone.Text;
  if edtTelefone.Text.Length <= 13 then
    edtTelefone.Text := TModelUtils.FormatTelefone(edtTelefone.Text)
  else
    edtTelefone.Text := TModelUtils.FormatCelular(edtTelefone.Text);
  edtTelefone.Text := edtTelefone.Text;
  edtTelefone.SetFocus;
end;

procedure TViewCliente.ExecuteOnShow;
begin
  inherited;
  recButtonAdicionar.Visible   := True;
  imgPesquisa.Visible          := False;
  lblCaptionRGeIE.Text         := 'RG / Inscrição estadual';
  lblCPFCNPJCaption.Text       := 'CPF / CNPJ';
  TabControlCadastro.ActiveTab := tabDadosCliente;
  TabControlCliente.ActiveTab  := tabLista;
  imgDelete.Visible            := False;
  imgSalvar.Visible            := False;
  LimparTodosCampos;
  PrimeiroCarregamento;
  PreencherCidades;
end;

procedure TViewCliente.FormCreate(Sender: TObject);
begin
  inherited;
  TabControlCadastro.ActiveTab := tabDadosCliente;

  FViewComboBoxTipoContribuinte              := TViewComboBoxBase.Create(layView);
  FViewComboBoxTipoContribuinte.Name         := 'ViewComboBoxContribuinte';
  FViewComboBoxTipoContribuinte.Parent       := layView;
  FViewComboBoxTipoContribuinte.Align        := TAlignLayout.Contents;
  FViewComboBoxTipoContribuinte.Visible      := False;
  FViewComboBoxTipoContribuinte.EditComboBox := edtComboBoxContribuinte;
  FViewComboBoxTipoContribuinte.Title        := 'Tipo do Contribuinte';

  FViewComboBoxTipoContribuinte.AddItem(1,'Contribuinte ICMS');
  FViewComboBoxTipoContribuinte.AddItem(2,'Contribuinte Isento');
  FViewComboBoxTipoContribuinte.AddItem(9,'Não Contribuinte');

  FViewComboBoxCidade              := TViewComboBoxBase.Create(layView);
  FViewComboBoxCidade.Name         := 'ViewComboBoxCidade';
  FViewComboBoxCidade.Parent       := layView;
  FViewComboBoxCidade.Align        := TAlignLayout.Contents;
  FViewComboBoxCidade.Visible      := False;
  FViewComboBoxCidade.EditComboBox := edtComboBoxCidade;
  FViewComboBoxCidade.Title        := 'Cidade';

  TabControlCliente.Margins.Top  := - 49;
  TabControlCadastro.Margins.Top := - 49;
end;

procedure TViewCliente.FormDestroy(Sender: TObject);
begin
  inherited;
  FViewComboBoxTipoContribuinte.Free;
end;

procedure TViewCliente.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if TabControlCliente.ActiveTab.Equals(tabLista) then
  begin
    inherited;
  end
  else if TabControlCliente.ActiveTab.Equals(tabCadastro) then
  begin
    var FService: IFMXVirtualKeyboardService;
    if (Key = vkHardwareBack) then
    begin
      TPlatformServices.Current.SupportsPlatformService
        (IFMXVirtualKeyboardService, IInterface(FService));
      if not((FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState)) then
      begin
        Key := 0;
        Voltar;
      end
    end;
  end

end;

procedure TViewCliente.GetCep(const ACep: string);
begin
  if TModelUtils.ExtractNumber(ACep).Length <> 8 then
  begin
    ShowErro('CEP com tamanho inválido!');
    Exit;
  end;

  OpenLoad;
  TThread.CreateAnonymousThread(
  procedure
  var
    LResponse: IResponse;
  begin
    try
      LResponse := TRequest.New.BaseURL(BaseURL)
        .Resource('cep/'+TModelUtils.ExtractNumber(ACep))
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

          var LData           := LJsonResponse.GetValue<TJSONObject>('data');
          edtLogradouro.Text  := LData.GetValue<string>('logradouro','');
          edtComplemento.Text := LData.GetValue<string>('complemento','');
          edtBairro.Text      := LData.GetValue<string>('bairro','');

          var LCityId          := LData.GetValue<string>('ibge','');
          var LNewCity         := LData.GetValue<Boolean>('newCity',False);
          if LNewCity then
          begin
            PreencherCidades(StrToIntDef(LCityId,0));
          end
          else
          begin
            FViewComboBoxCidade.SetItemByCodigo(StrToIntDef(LCityId,0));
          end;

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

procedure TViewCliente.GetCNPJ(const ACNPJ: string);
begin
  if TModelUtils.ExtractNumber(ACNPJ).Length <> 14 then
  begin
    ShowErro('CNPJ com tamanho inválido!');
    Exit;
  end;

  OpenLoad;
  TThread.CreateAnonymousThread(
  procedure
  var
    LResponse: IResponse;
  begin
    try
      LResponse := TRequest.New.BaseURL(BaseURL)
        .Resource('cnpj/'+TModelUtils.ExtractNumber(ACNPJ))
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
            ShowErro(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
            Exit; // Se der erro ele sai fora e não abre a próxima tela
          end;

          var LData            := LJsonResponse.GetValue<TJSONObject>('data');
          edtNomeCliente.Text  := LData.GetValue<string>('name','');
          edtNomeFantasia.Text := LData.GetValue<string>('name','');
          edtLogradouro.Text   := LData.GetValue<string>('street','');
          edtNumero.Text       := LData.GetValue<string>('number','');
          edtBairro.Text       := LData.GetValue<string>('district','');
          edtCep.Text          := LData.GetValue<string>('zip','');
          edtEmailUsuario.Text := LData.GetValue<string>('email','');

          var LCityId          := LData.GetValue<string>('cityId','');
          var LNewCity         := LData.GetValue<Boolean>('newCity',False);
          if LNewCity then
          begin
            PreencherCidades(StrToIntDef(LCityId,0));
          end
          else
          begin
            FViewComboBoxCidade.SetItemByCodigo(StrToIntDef(LCityId,0));
          end;

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

procedure TViewCliente.imgPesquisaCepClick(Sender: TObject);
begin
  inherited;
  GetCep(edtCep.Text);
end;

procedure TViewCliente.imgPesquisaClick(Sender: TObject);
begin
  inherited;
  GetCNPJ(edtCNPJ.Text);
end;

procedure TViewCliente.imgSalvarClick(Sender: TObject);
begin
  inherited;
  try
    ValidarPrimeiraEtapa;
    ValidarSegundaEtapa;
    ValidarTerceiraEtapa;
    SalvarCliente;

  except on E: Exception do
    begin
      ShowErro(e.Message);
    end;
  end;
end;

procedure TViewCliente.imgVoltarClick(Sender: TObject);
begin
  inherited;
  Voltar;
end;

procedure TViewCliente.IrParaCadastro;
begin
  recButtonAdicionar.Visible := False;
  TabControlCliente.GotoVisibleTab(1);
  TabControlCadastro.GotoVisibleTab(0);
end;

procedure TViewCliente.LimparTodosCampos;
begin
  edtComboBoxCidade.Clear;
  edtComboBoxContribuinte.Clear;
  FViewComboBoxTipoContribuinte.UnMarkerList;
  edtCNPJ.Text              := EmptyStr;
  edtNomeCliente.Text       := EmptyStr;
  edtInscricaoEstadual.Text := EmptyStr;
  edtNomeFantasia.Text      := EmptyStr;
  edtCep.Text               := EmptyStr;
  edtNumero.Text            := EmptyStr;
  edtLogradouro.Text        := EmptyStr;
  edtComplemento.Text       := EmptyStr;
  edtBairro.Text            := EmptyStr;
  edtTelefone.Text          := EmptyStr;
  edtEmailUsuario.Text      := EmptyStr;
end;

procedure TViewCliente.ListBoxItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  for var I := 0 to Pred(Item.ControlsCount) do
  begin
    if Item.Controls[i] is TFrameClienteLista then
    begin
      if Assigned(TFrameClienteLista(Item.Controls[i]).OnClickItem) then
        TFrameClienteLista(Item.Controls[i]).OnClickItem(TFrameClienteLista(Item.Controls[i]));
      Break;
    end;
  end;
end;

procedure TViewCliente.ListBoxViewportPositionChange(Sender: TObject;
  const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
const
  LoadThreshold = 500; // Threshold em pixels antes do final para carregar mais itens
begin
  if (NewViewportPosition.Y + ListBox.Height) >= (ListBox.ContentBounds.Height - LoadThreshold) then
  begin
    // O usuário está perto do final da lista, carregar mais itens
    if not (FPaginacao.CarregandoPagina) and (FPaginacao.FRegistroJaListado < FPaginacao.TotalDeRegistros) then
      NovaCargaDeDados;
  end;

end;

procedure TViewCliente.NovaCargaDeDados;
begin
  TThread.CreateAnonymousThread(
  procedure
  var LResponse: IResponse;
  begin
    try
      FPaginacao.CarregandoPagina := True;
      FPaginacao.PaginaAtual      := FPaginacao.PaginaAtual + 1;
      LResponse := TRequest.New.BaseURL(BaseURL)
        .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
        .AddParam('limit',LIMIT.ToString)
        .AddParam('page',FPaginacao.PaginaAtual.ToString)
        .Resource('customer')
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
          FPaginacao.FRegistroJaListado := FPaginacao.FRegistroJaListado + LJsonResponse.GetValue<Integer>('record_of_page',0);
          FPaginacao.CarregandoPagina   := False;
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

procedure TViewCliente.OnClickItemCliente(Sender: TObject);
begin
  OpenLoad;
  if not (Sender is TFrameClienteLista) then
    raise Exception.Create('Erro ao selecionar item da lista!');

  var LId := TFrameClienteLista(Sender).Id;
  TThread.CreateAnonymousThread(
  procedure
  var LResponse: IResponse;
  begin
    try
      if LId.IsEmpty then
        raise Exception.Create('Codigo do Cliente não informado!');


      LResponse := TRequest.New.BaseURL(BaseURL)
        .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
        .AddParam('limit',LIMIT.ToString)
        .Resource('customer/'+LId)
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
          FClienteSelecionado.Id := LData.GetValue<string>('id','');
          CarregarDadosCadastro(LData);
          FPaginacao.PaginaAtual        := 1;
          FPaginacao.TotalDeRegistros   := LJsonResponse.GetValue<Integer>('count_record',0);
          FPaginacao.FRegistroJaListado := LJsonResponse.GetValue<Integer>('record_of_page',0);
          FPaginacao.CarregandoPagina   := False;
          IrParaCadastro;
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

procedure TViewCliente.PreencherCidades(const AIdCity: Integer);
begin
  FViewComboBoxCidade.ViewListVertical.ClearList;
  TThread.CreateAnonymousThread(
  procedure
  begin
    var LJsonArrayCidades := BuscarCidades;
    try
      TThread.Synchronize(nil,
      procedure
      begin
        if Assigned(LJsonArrayCidades) then
        begin
          for var I := 0 to Pred(LJsonArrayCidades.Count) do
          begin
            var LjsonItem := LJsonArrayCidades.Items[i] as TJSONObject;
            FViewComboBoxCidade.AddItem(LjsonItem.GetValue<Integer>('id',0),LjsonItem.GetValue<string>('name',''));
          end;
        end;
        if AIdCity > 0  then
        begin
          FViewComboBoxCidade.SetItemByCodigo(AIdCity);
        end;
      end);
    finally
      if Assigned(LJsonArrayCidades) then
        FreeAndNil(LJsonArrayCidades);
    end;
  end).Start;
end;

procedure TViewCliente.PrimeiroCarregamento;
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
        .Resource('customer')
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

procedure TViewCliente.recButtonAdicionarClick(Sender: TObject);
begin
  inherited;
  Adicionar;
end;

procedure TViewCliente.SalvarCliente;
begin
  OpenLoad;
  TThread.CreateAnonymousThread(
  procedure
  var
    LResponse: IResponse;
  begin
    var LJsonBody := TJSONObject.Create;
    try
      LJsonBody.AddPair('cpfCnpj',TModelUtils.ExtractNumber(edtCNPJ.Text));
      LJsonBody.AddPair('ie',TModelUtils.ExtractNumber(edtInscricaoEstadual.Text));
      LJsonBody.AddPair('typeOfTaxpayer',edtComboBoxContribuinte.Codigo);
      LJsonBody.AddPair('name',edtNomeCliente.Text);
      LJsonBody.AddPair('fantasy',edtNomeFantasia.Text);
      LJsonBody.AddPair('publicPlace',edtLogradouro.Text);
      LJsonBody.AddPair('number',edtNumero.Text);
      LJsonBody.AddPair('complement',edtComplemento.Text);
      LJsonBody.AddPair('neighborhood',edtBairro.Text);
      LJsonBody.AddPair('cityId',edtComboBoxCidade.Codigo);
      LJsonBody.AddPair('zipCode',TModelUtils.ExtractNumber(edtCep.Text));
      LJsonBody.AddPair('phone',TModelUtils.ExtractNumber(edtTelefone.Text));
      LJsonBody.AddPair('email',edtEmailUsuario.Text);
      LJsonBody.AddPair('isActive',True);
      LJsonBody.AddPair('companyId',TModelStaticCredencial.GetInstance.Company);

      var LMensagemSucesso:String := EmptyStr;
      if FClienteSelecionado.Id.IsEmpty then
      begin
        LMensagemSucesso := 'Dados do cliente cadastrado com sucesso!';
        LResponse := TRequest.New.BaseURL(BaseURL)
          .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
          .Resource('customer')
          .AddBody(LJsonBody)
          .Accept('application/json')
          .Post;
      end
      else
      begin
        LMensagemSucesso := 'Dados do cliente alterado com sucesso!';
        LResponse := TRequest.New.BaseURL(BaseURL)
          .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
          .Resource('customer/'+FClienteSelecionado.Id)
          .AddBody(LJsonBody)
          .Accept('application/json')
          .Put;
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

procedure TViewCliente.ValidarPrimeiraEtapa;
begin
  try
    if edtCNPJ.Text.IsEmpty then
      raise Exception.Create('O campo CPF/CNPJ não pode ser vazio!');

    if (TModelUtils.ExtractNumber(edtCNPJ.Text).Length <> 14)  and (TModelUtils.ExtractNumber(edtCNPJ.Text).Length <> 11) then
      raise Exception.Create('CPF/CNPJ inválido!');

    if edtInscricaoEstadual.Text.IsEmpty then
      raise Exception.Create('O campo RG/inscrição estadual não pode ser vazio!');

    if edtComboBoxContribuinte.Codigo <= 0 then
      raise Exception.Create('Selecione um contribuinte!');

    if edtNomeCliente.Text.IsEmpty then
      raise Exception.Create('O campo nome não pode ser vazio!');

    if edtNomeFantasia.Text.IsEmpty then
      raise Exception.Create('O campo nome fantasia não pode ser vazio!');
  except on E: Exception do
    begin
      TabControlCadastro.GotoVisibleTab(0);
      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure TViewCliente.ValidarSegundaEtapa;
begin
  try
    if edtCep.Text.IsEmpty then
      raise Exception.Create('O campo CEP não pode ser vazio!');

    if TModelUtils.ExtractNumber(edtCep.Text).Length <> 8 then
      raise Exception.Create('CEP inválido!');

    if edtLogradouro.Text.IsEmpty then
      raise Exception.Create('O campo endereço não pode ser vazio!');

    if edtNumero.Text.IsEmpty then
      raise Exception.Create('O número da empresa não pode ser vazio!');

    if edtBairro.Text.IsEmpty then
      raise Exception.Create('O campo bairro não pode ser vazio!');

    if edtComboBoxCidade.Codigo <= 0 then
      raise Exception.Create('O campo cidade não pode ser vazia!');

  except on E: Exception do
    begin
      TabControlCadastro.GotoVisibleTab(1);
      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure TViewCliente.ValidarTerceiraEtapa;
begin
  try
    if edtTelefone.Text.IsEmpty then
      raise Exception.Create('O campo telefone não pode ser vazio!');

    if (edtTelefone.Text.Length <> 13) and (edtTelefone.Text.Length <> 15) then
      raise Exception.Create('Telefone inválido!');

    if edtEmailUsuario.Text.IsEmpty then
      raise Exception.Create('O campo e-mail não pode ser vazio!');

  except on E: Exception do
    begin
      TabControlCadastro.GotoVisibleTab(2);
      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure TViewCliente.Voltar;
begin
  CloseKeyboard;
  if TabControlCliente.ActiveTab.Equals(tabLista) then
  begin
    PriorForm(Self);
  end
  else
  begin
    recButtonAdicionar.Visible := True;
    imgDelete.Visible          := False;
    imgSalvar.Visible          := False;
    TabControlCliente.GotoVisibleTab(0);
    TabControlCadastro.GotoVisibleTab(0);
  end;

end;

{ TClienteSelecionado }

procedure TClienteSelecionado.Clear;
begin
  Id := EmptyStr;
end;

end.

