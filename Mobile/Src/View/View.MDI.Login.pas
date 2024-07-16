unit View.MDI.Login;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,FMX.Edit, View.Nova.Conta,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  View.Base, View.Login.Entrar, View.Login, View.Recuperar.Senha,
  View.Codigo.Verificacao, View.Nova.Senha,
  View.Verificar.Conta;

type
  TViewMDILogin = class(TForm)
    layView: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FObject: TFmxObject;
    FViewLogin: TViewLogin;
    FViewEntrar: TViewLoginEntrar;
    FViewRecuperarSenha: TViewRecuperarSenha;
    FViewCodigoVerificacao:TViewCodigoVerificacao;
    FViewNovaSenha:TViewNovaSenha;
    FViewNewAccount:TViewNovaConta;
    FViewVerificarConta:TViewVerificarConta;

    {$Region'Declaração de eventos NextForm e PriorForm'}
    // View Login
    procedure OnNextFormViewLogin(Sender: TObject);
    procedure OnPriorFormViewLogin(Sender: TObject);

    // View Entrar
    procedure OnNextFormViewEntrar(Sender: TObject);
    procedure OnPriorFormViewEntrar(Sender: TObject);

    // View Recuperar senha
    procedure OnNextFormViewRecuperarSenha(Sender: TObject);
    procedure OnPriorFormViewRecuperarSenha(Sender: TObject);

    // View Verificar código
    procedure OnNextFormViewVerificacaoCodigo(Sender: TObject);
    procedure OnPriorFormViewVerificacaoCodigo(Sender: TObject);

    // View Nova senha
    procedure OnNextFormViewNovaSenha(Sender: TObject);
    procedure OnPriorFormViewNovaSenha(Sender: TObject);

    // View Criar Nova Conta
    procedure OnNextFormViewNewAccount(Sender: TObject);
    procedure OnPriorFormViewNewAccount(Sender: TObject);

    // View Verificar conta
    procedure OnNextFormVerificarConta(Sender: TObject);
    procedure OnPriorFormVerificarConta(Sender: TObject);
    {$EndRegion}

  public
    procedure ShowLayout(AForm: TViewBase);
  end;

var
  ViewMDILogin: TViewMDILogin;

implementation

{$R *.fmx}
{ TViewMDILogin }

procedure TViewMDILogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TViewMDILogin.FormCreate(Sender: TObject);
begin

{$Region'Criação de views e atribuição de eventos'}

  //Aqui está sendo criada a instancia das views que vai ser chamada dentro desse
  //form, e os eventos resposaveis por mudar a pagina como de entrar para login


  // View login
  FViewLogin                    := TViewLogin.Create(Self);
  FViewLogin.NextForm           := Self.OnNextFormViewLogin;
  FViewLogin.PriorForm          := Self.OnPriorFormViewLogin;

  // View Entrar
  FViewEntrar                   := TViewLoginEntrar.Create(Self);
  FViewEntrar.NextForm          := Self.OnNextFormViewEntrar;
  FViewEntrar.PriorForm         := Self.OnPriorFormViewEntrar;
  // View Recuperar Senha
  FViewRecuperarSenha           := TViewRecuperarSenha.Create(Self);
  FViewRecuperarSenha.NextForm  := Self.OnNextFormViewRecuperarSenha;
  FViewRecuperarSenha.PriorForm := Self.OnPriorFormViewRecuperarSenha;

  // View verificação de código
  FViewCodigoVerificacao           := TViewCodigoVerificacao.Create(Self);
  FViewCodigoVerificacao.NextForm  := Self.OnNextFormViewVerificacaoCodigo;
  FViewCodigoVerificacao.PriorForm := Self.OnPriorFormViewVerificacaoCodigo;

  // View Nova senha
  FViewNovaSenha           := TViewNovaSenha.Create(Self);
  FViewNovaSenha.NextForm  := Self.OnNextFormViewNovaSenha;
  FViewNovaSenha.PriorForm := Self.OnPriorFormViewNovaSenha;

  // View Nova Conta
  FViewNewAccount           := TViewNovaConta.Create(Self);
  FViewNewAccount.NextForm  := Self.OnNextFormViewNewAccount;
  FViewNewAccount.PriorForm := Self.OnPriorFormViewNewAccount;

  // View Verificar conta
  FViewVerificarConta           := TViewVerificarConta.Create(Self);
  FViewVerificarConta.NextForm  := Self.OnNextFormVerificarConta;
  FViewVerificarConta.PriorForm := Self.OnPriorFormVerificarConta;
  {$EndRegion}

  FObject := nil;
end;

procedure TViewMDILogin.FormShow(Sender: TObject);
begin
  ShowLayout(FViewEntrar);
end;


procedure TViewMDILogin.OnNextFormViewEntrar(Sender: TObject);
begin
  if FViewEntrar.NexView = Login then
  begin
    ShowLayout(FViewLogin);
  end
  else if FViewEntrar.NexView = Registrar then
  begin
    ShowLayout(FViewNewAccount);
  end;
end;

{$Region'Eventos NextForm PriorForm Login'}

procedure TViewMDILogin.OnNextFormViewLogin(Sender: TObject);
begin
  if (Sender as TViewLogin).NextView = TNextView.EsqueciMinhaSenha then
  begin
    ShowLayout(FViewRecuperarSenha);
  end
  else if (Sender as TViewLogin).NextView = TNextView.AtivarEmpresa then
  begin

    FViewVerificarConta.Email             := FViewLogin.edtEmail.Edit.Text;
    FViewVerificarConta.Senha             := FViewLogin.edtSenha.Edit.Text;
    FViewVerificarConta.CodigoVerificacao := FViewLogin.CodigoVerify;
    FViewVerificarConta.CompanyId         := FViewLogin.CompanyId;
    ShowLayout(FViewVerificarConta);
  end
  else if ((Sender as TViewLogin).NextView =  TNextView.NovaConta) then
  begin
    ShowLayout(FViewNewAccount);
  end;
end;

procedure TViewMDILogin.OnPriorFormViewLogin(Sender: TObject);
begin
  ShowLayout(FViewEntrar);
end;

{$EndRegion}

{$Region'Eventos NextForm PriorForm Nova Conta'}
procedure TViewMDILogin.OnNextFormViewNewAccount(Sender: TObject);
begin
  FViewVerificarConta.CodigoVerificacao := FViewNewAccount.CodigoVerificacao;
  FViewVerificarConta.CompanyId         := FViewNewAccount.CompanyId;
  FViewVerificarConta.Email             := FViewNewAccount.edtEmailUsuario.Text;
  FViewVerificarConta.Senha             := FViewNewAccount.edtPassword.Text;
  ShowLayout(FViewVerificarConta);
end;

procedure TViewMDILogin.OnPriorFormViewNewAccount(Sender: TObject);
begin
  ShowLayout(FViewEntrar);
end;
{$EndRegion}

procedure TViewMDILogin.OnNextFormViewNovaSenha(Sender: TObject);
begin
  FViewLogin.edtEmail.Edit.Text := EmptyStr;
  FViewLogin.edtSenha.Edit.Text := EmptyStr;
  ShowLayout(FViewLogin);
end;


{$Region'Verificar código reset password'}

procedure TViewMDILogin.OnNextFormViewVerificacaoCodigo(Sender: TObject);
begin
  FViewNovaSenha.Email  := FViewCodigoVerificacao.Email;
  FViewNovaSenha.Codigo := FViewCodigoVerificacao.CodigoVerificacao;
  ShowLayout(FViewNovaSenha);
end;

procedure TViewMDILogin.OnPriorFormViewVerificacaoCodigo(Sender: TObject);
begin
  ShowLayout(FViewRecuperarSenha);
end;
{$endRegion}

{$Region'Eventos NextForm PriorForm Verificar/Ativar Nova Conta '}
procedure TViewMDILogin.OnNextFormVerificarConta(Sender: TObject);
begin
  ShowLayout(FViewLogin);
  FViewLogin.edtEmail.Edit.Text := FViewVerificarConta.Email;
  FViewLogin.edtSenha.Edit.Text := FViewVerificarConta.Senha;
  if not (FViewVerificarConta.Email.IsEmpty) and not(FViewVerificarConta.Senha.IsEmpty) then
  begin
    {$IFDEF MSWINDOWS}
    FViewLogin.btnEntrarClick(FViewLogin.btnEntrar);
    {$ELSE}
    FViewLogin.btnEntrarTap(FViewLogin.btnEntrar,TPointF.Create(0,0));
    {$ENDIF}
  end;
end;

procedure TViewMDILogin.OnPriorFormVerificarConta(Sender: TObject);
begin
  ShowLayout(FViewLogin);
end;
{$EndRegion}

procedure TViewMDILogin.OnPriorFormViewEntrar(Sender: TObject);
begin
  Self.Close;
end;

procedure TViewMDILogin.OnPriorFormViewNovaSenha(Sender: TObject);
begin
  FViewLogin.edtEmail.Edit.Text := EmptyStr;
  FViewLogin.edtSenha.Edit.Text := EmptyStr;
  ShowLayout(FViewLogin);
end;

{$Region'Recuperar Senha'}
procedure TViewMDILogin.OnNextFormViewRecuperarSenha(Sender: TObject);
begin
  FViewCodigoVerificacao.Email             := FViewRecuperarSenha.edtEmail.Edit.Text;
  FViewCodigoVerificacao.CodigoVerificacao := FViewRecuperarSenha.CodigoRessetPassword.ToString;
  FViewCodigoVerificacao.CodigoVerificacao := FViewRecuperarSenha.CodigoRessetPassword.ToString;
  ShowLayout(FViewCodigoVerificacao)
end;

procedure TViewMDILogin.OnPriorFormViewRecuperarSenha(Sender: TObject);
begin
  ShowLayout(FViewLogin);
end;
{$EndRegion}

procedure TViewMDILogin.ShowLayout(AForm: TViewBase);
begin
  if FObject <> nil then
  begin
    layView.RemoveObject(AForm.layView);
    FObject := nil;
  end;
  FObject := AForm;

  Self.OnClose                 := AForm.OnClose;
  Self.OnKeyUp                 := AForm.OnKeyUp;
  Self.OnVirtualKeyboardHidden := AForm.OnVirtualKeyboardHidden;
  Self.OnVirtualKeyboardShown  := AForm.OnVirtualKeyboardShown;
  layView.AddObject(AForm.layView);
  AForm.ExecuteOnShow;
end;

end.
