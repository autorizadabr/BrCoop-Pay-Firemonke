unit View.Nova.Conta;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, FMX.Objects, FMX.Layouts, View.Edit.Base, FMX.Controls.Presentation,
  FMX.TabControl, FMX.Edit, View.Step, View.Button.Base,System.JSON, Model.Utils,
  View.Edit.ComboBox, View.ComboBox.Base, System.Generics.Collections,
  View.Componentes.Censura,FMX.VirtualKeyboard,FMX.Platform,View.Verificar.Conta;

type
  TViewNovaConta = class(TViewBase)
    TabControl: TTabControl;
    tabDadosEmpresa: TTabItem;
    tabEnderecoEmpresa: TTabItem;
    tabDadosAcesso: TTabItem;
    layTab1: TLayout;
    recCnpj: TRectangle;
    edtCNPJ: TEdit;
    StyleBook1: TStyleBook;
    recRazaoSocial: TRectangle;
    edtNomeEmpresa: TEdit;
    recInscricaoEstadual: TRectangle;
    edtInscricaoEstadual: TEdit;
    recNomeFantasia: TRectangle;
    edtNomeFantasia: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    layTab2: TLayout;
    recCep: TRectangle;
    edtCep: TEdit;
    recNumero: TRectangle;
    edtNumero: TEdit;
    recEndereco: TRectangle;
    edtLogradouro: TEdit;
    recComplemento: TRectangle;
    edtComplemento: TEdit;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    layNumeroBairro: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Label7: TLabel;
    recBairro: TRectangle;
    edtBairro: TEdit;
    Label11: TLabel;
    layTab3: TLayout;
    recTelefone: TRectangle;
    edtTelefone: TEdit;
    recNomeUsuario: TRectangle;
    edtNomeUsuario: TEdit;
    recEmail: TRectangle;
    recSenha: TRectangle;
    edtPassword: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Rectangle15: TRectangle;
    layButtonsDadosEmpresa: TLayout;
    btnProximoDadosEmpresa: TViewButtonBase;
    layButtonsEnderecoEmpresa: TLayout;
    btnVoltarEnderecoEmpresa: TViewButtonBase;
    btnProximoEnderecoEmpresa: TViewButtonBase;
    layButtonsDadosAcesso: TLayout;
    btnVoltarDadosAcesso: TViewButtonBase;
    btnProximoDadosAcesso: TViewButtonBase;
    layCNPJ: TLayout;
    layDadosCNPJ: TLayout;
    imgPesquisa: TImage;
    edtComboBoxCRT: TViewEditComboBox;
    edtComboBoxCidade: TViewEditComboBox;
    lblEmailInvalido: TLabel;
    edtEmailUsuario: TEdit;
    ViewStep: TViewStep;
    ViewCensura: TViewComponentesCensura;
    lblCNPJInvalido: TLabel;
    lblInscricaoInvalida: TLabel;
    procedure btnProximoDadosEmpresaClick(Sender: TObject);
    procedure btnProximoEnderecoEmpresaClick(Sender: TObject);
    procedure btnVoltarEnderecoEmpresaClick(Sender: TObject);
    procedure btnVoltarDadosAcessoClick(Sender: TObject);
    procedure btnProximoDadosAcessoClick(Sender: TObject);
    procedure imgPesquisaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtTelefoneTyping(Sender: TObject);
    procedure edtEmailUsuarioExit(Sender: TObject);
    procedure edtEmailUsuarioTyping(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure edtInscricaoEstadualTyping(Sender: TObject);
    procedure edtInscricaoEstadualExit(Sender: TObject);
    procedure edtCNPJExit(Sender: TObject);
    procedure edtCNPJTyping(Sender: TObject);
    procedure edtCNPJKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtTelefoneKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FViewComboBoxCRT: TViewComboBoxBase;
    FViewComboBoxCidade: TViewComboBoxBase;
    FCodigoVerificacao: String;
    FCompanyId: string;
    FViewVerificarConta:TViewVerificarConta;
    function BuscarCidades:TJSONArray;
    procedure PreencherCidades(const AIdCity:Integer = 0);
    procedure CriarNovaConta;
    procedure GetCNPJ(const ACNPJ:string);
    procedure LimparTodosCampos;
    procedure ValidarCNPJeIE;
    procedure AbrirVerificarConta;
  public
    property CodigoVerificacao:String read FCodigoVerificacao write FCodigoVerificacao;
    property CompanyId:string read FCompanyId write FCompanyId;
    procedure ExecuteOnShow; override;
  end;


implementation
  uses RESTRequest4D;
{$R *.fmx}

{ TViewNewAccount }

procedure TViewNovaConta.LimparTodosCampos;
begin
  lblEmailInvalido.Visible := False;
  edtComboBoxCidade.Clear;
  edtComboBoxCRT.Clear;
  FViewComboBoxCidade.UnMarkerList;
  FViewComboBoxCRT.UnMarkerList;
  edtCNPJ.Text              := EmptyStr;
  edtNomeEmpresa.Text       := EmptyStr;
  edtInscricaoEstadual.Text := EmptyStr;
  edtNomeFantasia.Text      := EmptyStr;
  edtCep.Text               := EmptyStr;
  edtNumero.Text            := EmptyStr;
  edtLogradouro.Text        := EmptyStr;
  edtComplemento.Text       := EmptyStr;
  edtBairro.Text            := EmptyStr;
  edtTelefone.Text          := EmptyStr;
  edtNomeUsuario.Text       := EmptyStr;
  edtEmailUsuario.Text      := EmptyStr;
  edtPassword.Text          := EmptyStr;
end;

procedure TViewNovaConta.PreencherCidades(const AIdCity:Integer);
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

procedure TViewNovaConta.ValidarCNPJeIE;
begin
  if not (edtCNPJ.Text.IsEmpty) and not (edtInscricaoEstadual.Text.IsEmpty) then
  begin
    TThread.CreateAnonymousThread(
    procedure
    var
      LResponse: IResponse;
    begin
      try
        var LCnpj := edtCNPJ.Text.Replace('/','',[rfReplaceAll]);
        LResponse := TRequest.New.BaseURL(BaseURL)
          .Resource('account/verify/cnpj/'+LCnpj+'/ie/'+edtInscricaoEstadual.Text)
          .Accept('application/json')
          .Get;

        TThread.Synchronize(nil,
        procedure
        begin
          var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
          try
            // Verificando o status code
            if LResponse.StatusCode <> 200 then
            begin
              // Tratando o erro
              ShowErro(LJsonResponse.GetValue<string>('error','Erro não identificado')+' no momento de validar CNPJ e IE!');
              Exit; // Se der erro ele sai fora e não abre a próxima tela
            end;

            var LContaPodeProsseguir := LJsonResponse.GetValue<Boolean>('isValidateAccount');

            lblInscricaoInvalida.Visible := not LContaPodeProsseguir;
            lblCNPJInvalido.Visible      := not LContaPodeProsseguir;

          finally
            LJsonResponse.Free;
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
end;

procedure TViewNovaConta.CriarNovaConta;
begin
  OpenLoad;
  TThread.CreateAnonymousThread(
  procedure
  var
    LResponse: IResponse;
  begin
    var LJsonBody    := TJSONObject.Create;
    var LJsonUser    := TJSONObject.Create;
    var LJsonCompany := TJSONObject.Create;
    try
      try
        // Json User

        LJsonUser.AddPair('email',edtEmailUsuario.Text);
        LJsonUser.AddPair('name',edtNomeUsuario.Text);
        LJsonUser.AddPair('password',edtPassword.Text);

        // Json Company
        LJsonCompany.AddPair('cpfCnpj',edtCNPJ.Text);
        LJsonCompany.AddPair('ie',edtInscricaoEstadual.Text);
        LJsonCompany.AddPair('ieSt','');
        LJsonCompany.AddPair('im','');
        LJsonCompany.AddPair('name',edtNomeEmpresa.Text);
        LJsonCompany.AddPair('fantasy',edtNomeFantasia.Text);
        LJsonCompany.AddPair('publicPlace',edtLogradouro.Text);
        LJsonCompany.AddPair('number',edtNumero.Text);
        LJsonCompany.AddPair('complement',edtComplemento.Text);
        LJsonCompany.AddPair('neighborhood',edtBairro.Text);
        LJsonCompany.AddPair('cityId',edtComboBoxCidade.Codigo);
        LJsonCompany.AddPair('zipCode',TModelUtils.ExtractNumber(edtCep.Text));
        LJsonCompany.AddPair('phone',edtTelefone.Text);
        LJsonCompany.AddPair('crt',edtComboBoxCRT.Codigo);
        LJsonCompany.AddPair('email',edtEmailUsuario.Text);


        LJsonBody.AddPair('user',LJsonUser);
        LJsonBody.AddPair('company',LJsonCompany);
        LResponse := TRequest.New.BaseURL(BaseURL)
          .Resource('account/new')
          .AddBody(LJsonBody)
          .Accept('application/json')
          .Post;

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
              ShowErro(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
              Exit; // Se der erro ele sai fora e não abre a próxima tela
            end;

            FCodigoVerificacao := LJsonResponse.GetValue<string>('codeVerify','');
            FCompanyId         := LJsonResponse.GetValue<string>('companyId','');

          finally
            LJsonResponse.Free;
          end;

          if FCodigoVerificacao.IsEmpty then
            raise Exception.Create('Código de verificação não informado pela API!');

          ShowSucesso('Nova conta criada com sucesso!');

          ViewStep.ProgressFinal;

          // Aqui eu vou prender o usuário na tela de sucesso para que ele veja
          // que o processo de criação de conta deu certo
          ViewMensagem.OnAfterClose := Procedure
                                       begin
                                         ViewMensagem.OnAfterClose := nil;
                                         AbrirVerificarConta;
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

    finally
      //FreeAndNil(LJsonBody);
    end;

  end).Start;
end;

procedure TViewNovaConta.edtCNPJExit(Sender: TObject);
begin
  inherited;
  ValidarCNPJeIE;
end;

procedure TViewNovaConta.edtCNPJKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  edtCNPJ.SelStart := edtCNPJ.Text.Length;
end;

procedure TViewNovaConta.edtCNPJTyping(Sender: TObject);
begin
  inherited;
  edtCNPJ.Text := edtCNPJ.Text;
  edtCNPJ.Text := TModelUtils.FormatCNPJ(edtCNPJ.Text);
  edtCNPJ.Text := edtCNPJ.Text;
  edtCNPJ.SetFocus;
  lblInscricaoInvalida.Visible := False;
  lblCNPJInvalido.Visible      := False;
end;

procedure TViewNovaConta.edtEmailUsuarioExit(Sender: TObject);
begin
  inherited;
  if edtEmailUsuario.Text.IsEmpty then
  begin
    Exit;
  end;

  TThread.CreateAnonymousThread(
  procedure
  var
    LResponse: IResponse;
  begin
    try

      LResponse := TRequest.New.BaseURL(BaseURL)
        .Resource('user/email/'+edtEmailUsuario.Text)
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
          lblEmailInvalido.Visible := LJsonResponse.GetValue<Boolean>('emailExist',False);

        finally
          LJsonResponse.Free;
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

procedure TViewNovaConta.edtEmailUsuarioTyping(Sender: TObject);
begin
  inherited;
  lblEmailInvalido.Visible := False;
end;

procedure TViewNovaConta.edtInscricaoEstadualExit(Sender: TObject);
begin
  inherited;
  ValidarCNPJeIE;
end;

procedure TViewNovaConta.edtInscricaoEstadualTyping(Sender: TObject);
begin
  inherited;
  lblInscricaoInvalida.Visible := False;
  lblCNPJInvalido.Visible      := False;
end;

procedure TViewNovaConta.edtTelefoneKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  edtTelefone.SelStart := edtTelefone.Text.Length;
end;

procedure TViewNovaConta.edtTelefoneTyping(Sender: TObject);
begin
  inherited;
  if edtTelefone.Text.Length < 16 then
  begin
    edtTelefone.Text := TModelUtils.FormatTelefone(edtTelefone.Text);
  end
  else
  begin
    edtTelefone.Text := TModelUtils.FormatCelular(edtTelefone.Text);
  end;
  edtTelefone.SelStart := edtTelefone.Text.Length;
end;

procedure TViewNovaConta.ExecuteOnShow;
begin
  inherited;
  LimparTodosCampos;
  PreencherCidades;
  TabControl.GotoVisibleTab(0);
  ViewStep.OnResize(Self);
  ViewStep.ProgressDadosDaEmpresa;
end;

procedure TViewNovaConta.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  //Action := TCloseAction.caFree;
end;

procedure TViewNovaConta.FormCreate(Sender: TObject);
begin
  inherited;
  FViewComboBoxCRT              := TViewComboBoxBase.Create(layView);
  FViewComboBoxCRT.Name         := 'ViewComboBoxCRT';
  FViewComboBoxCRT.Parent       := layView;
  FViewComboBoxCRT.Align        := TAlignLayout.Contents;
  FViewComboBoxCRT.Visible      := False;
  FViewComboBoxCRT.EditComboBox :=  edtComboBoxCRT;
  FViewComboBoxCRT.Title        :=  'CRT';

  FViewComboBoxCRT.AddItem(1,'Simples Nacional');
  FViewComboBoxCRT.AddItem(2,'Simples Nacional, excesso sublimite de receita bruta');
  FViewComboBoxCRT.AddItem(3,'Regime Normal');

  FViewComboBoxCidade              := TViewComboBoxBase.Create(layView);
  FViewComboBoxCidade.Name         := 'ViewComboBoxCidade'; 
  FViewComboBoxCidade.Parent       := layView;
  FViewComboBoxCidade.Align        := TAlignLayout.Contents;
  FViewComboBoxCidade.Visible      := False;
  FViewComboBoxCidade.EditComboBox := edtComboBoxCidade;
  FViewComboBoxCidade.Title        := 'Cidade';

  ViewCensura.Edit                 := edtPassword;
  lblCNPJInvalido.Visible          := False;
  lblInscricaoInvalida.Visible     := False;
  edtComboBoxCRT.Padding.Left      := 0;
  edtComboBoxCRT.Padding.Right     := 0;
  edtComboBoxCidade.Padding.Left   := 0;
  edtComboBoxCidade.Padding.Right  := 0;
  FViewVerificarConta              := nil;
end;

procedure TViewNovaConta.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(FViewComboBoxCRT);
  FreeAndNil(FViewComboBoxCidade);
end;

procedure TViewNovaConta.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if TabControl.ActiveTab.Equals(tabDadosEmpresa) then
  begin
    inherited;
  end
  else if TabControl.ActiveTab.Equals(tabEnderecoEmpresa) then
  begin
    var FService: IFMXVirtualKeyboardService;
    if (Key = vkHardwareBack) then
    begin
      TPlatformServices.Current.SupportsPlatformService
        (IFMXVirtualKeyboardService, IInterface(FService));
      if not((FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState)) then
      begin
        Key := 0;
        btnVoltarEnderecoEmpresaClick(btnVoltarEnderecoEmpresa);
      end
    end;
  end
  else if TabControl.ActiveTab.Equals(tabDadosAcesso) then
  begin
    var FService: IFMXVirtualKeyboardService;
    if (Key = vkHardwareBack) then
    begin
      TPlatformServices.Current.SupportsPlatformService
        (IFMXVirtualKeyboardService, IInterface(FService));
      if not((FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState)) then
      begin
        Key := 0;
        btnVoltarDadosAcessoClick(btnVoltarDadosAcesso);
      end
    end;
  end;
end;

procedure TViewNovaConta.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  btnVoltarEnderecoEmpresa.Enabled := True;
  btnVoltarDadosAcesso.Enabled     := True;

  btnProximoDadosEmpresa.Enabled    := True;
  btnProximoEnderecoEmpresa.Enabled := True;
  btnProximoDadosAcesso.Enabled     := True;
end;

procedure TViewNovaConta.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  btnVoltarEnderecoEmpresa.Enabled := False;
  btnVoltarDadosAcesso.Enabled     := False;

  btnProximoDadosEmpresa.Enabled    := False;
  btnProximoEnderecoEmpresa.Enabled := False;
  btnProximoDadosAcesso.Enabled     := False;
end;

function TViewNovaConta.BuscarCidades:TJSONArray;
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

procedure TViewNovaConta.GetCNPJ(const ACNPJ:string);
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
          edtNomeEmpresa.Text  := LData.GetValue<string>('name','');
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

procedure TViewNovaConta.imgPesquisaClick(Sender: TObject);
begin
  inherited;
  edtCNPJ.ResetFocus;
  CloseKeyboard;
  GetCNPJ(edtCNPJ.Text);
end;

procedure TViewNovaConta.btnProximoDadosEmpresaClick(Sender: TObject);
begin
  inherited;
  try
    if edtCNPJ.Text.IsEmpty then
      raise Exception.Create('O campo CNPJ não pode ser vazio!');

    if TModelUtils.ExtractNumber(edtCNPJ.Text).Length <> 14 then
      raise Exception.Create('CNPJ inválido!');

    if edtInscricaoEstadual.Text.IsEmpty then
      raise Exception.Create('O campo inscrição estadual não pode ser vazio!');

    if edtNomeEmpresa.Text.IsEmpty then
      raise Exception.Create('O campo nome da empresa não pode ser vazio!');

    if edtNomeFantasia.Text.IsEmpty then
      raise Exception.Create('O campo nome fantasia não pode ser vazio!');

    if edtComboBoxCRT.Codigo <= 0 then
      raise Exception.Create('CRT não informado !');


    ViewStep.ProgressEnderecoDaEmpresa;
    TabControl.GotoVisibleTab(1);
  except on E: Exception do
    begin
      ShowErro(e.Message);
    end;
  end;
end;

procedure TViewNovaConta.btnVoltarEnderecoEmpresaClick(Sender: TObject);
begin
  inherited;
  ViewStep.ProgressDadosDaEmpresa;
  TabControl.GotoVisibleTab(0);
end;

procedure TViewNovaConta.btnProximoEnderecoEmpresaClick(Sender: TObject);
begin
  inherited;
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

    ViewStep.ProgressDadosDeAcesso;
    TabControl.GotoVisibleTab(2);
  except on E: Exception do
    begin
      ShowErro(e.Message);
    end;
  end;
end;

procedure TViewNovaConta.btnVoltarDadosAcessoClick(Sender: TObject);
begin
  inherited;
  ViewStep.ProgressEnderecoDaEmpresa;
  TabControl.GotoVisibleTab(1);
end;

procedure TViewNovaConta.AbrirVerificarConta;
begin
  TThread.Synchronize(nil,
  procedure
  begin
    if Assigned(FViewVerificarConta) then
      FreeAndNil(FViewVerificarConta);

    FViewVerificarConta                   := TViewVerificarConta.Create(Self);
    FViewVerificarConta.CodigoVerificacao := CodigoVerificacao;
    FViewVerificarConta.CompanyId         := CompanyId;
    FViewVerificarConta.Email             := edtEmailUsuario.Text;
    FViewVerificarConta.Senha             := edtPassword.Text;
    FViewVerificarConta.Show;

    ExecuteOnShow;
    Close;
  end);
end;

procedure TViewNovaConta.btnProximoDadosAcessoClick(Sender: TObject);
begin
  inherited;
  try
    if edtTelefone.Text.IsEmpty then
      raise Exception.Create('O campo telefone não pode ser vazio!');

    if edtEmailUsuario.Text.IsEmpty then
      raise Exception.Create('O campo e-mail não pode ser vazio!');

    if (not edtEmailUsuario.Text.Contains('@')) or (not edtEmailUsuario.Text.Contains('.')) then
      raise Exception.Create('E-mail inválido!');

    if lblEmailInvalido.Visible then
      raise Exception.Create('Esse e-mail já está sendo utlizado por outro usuário!');

    if edtNomeUsuario.Text.IsEmpty then
      raise Exception.Create('O campo nome do usário não pode ser vazio!');

    if edtPassword.Text.IsEmpty then
      raise Exception.Create('O campo senha não pode ser vazio!');

    if edtPassword.Text.Length < 3 then
      raise Exception.Create('O campo senha deve conter pelo menos 3 caracteres!');

    CriarNovaConta;
  except on E: Exception do
    begin
      ShowErro(e.Message);
    end;
  end;
end;

end.
