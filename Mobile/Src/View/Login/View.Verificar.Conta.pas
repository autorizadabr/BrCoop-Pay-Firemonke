unit View.Verificar.Conta;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, FMX.Objects, FMX.Layouts, View.Button.Base, View.Edit.Senha,
  FMX.Controls.Presentation, System.JSON, View.Login;

type
  TViewVerificarConta = class(TViewBase)
    Label6: TLabel;
    Label7: TLabel;
    layEditCodico: TLayout;
    ViewEditSenha: TViewEditSenha;
    Layout1: TLayout;
    btnProsseguir: TViewButtonBase;
    lblEmail: TLabel;
    lblRecuperarSenha: TLabel;
    procedure btnProsseguirClick(Sender: TObject);
  private
    FCodigoVerificacao: string;
    FCompanyId: string;
    FEmail: string;
    FSenha: string;
    FViewLogin:TViewLogin;
    procedure AbrirLogin;
  public
    procedure ExecuteOnShow; override;
    property CodigoVerificacao:string read FCodigoVerificacao write FCodigoVerificacao;
    property CompanyId:string read FCompanyId write FCompanyId;
    property Email:string read FEmail write FEmail;
    property Senha:string read FSenha write FSenha;
  end;

implementation
  uses RESTRequest4D;
{$R *.fmx}

{ TViewVerificarConta }

procedure TViewVerificarConta.AbrirLogin;
begin
  TThread.Synchronize(nil,
  procedure
  begin
    FViewLogin                    := TViewLogin.Create(Self);
    FViewLogin.edtEmail.Edit.Text := Email;
    FViewLogin.edtSenha.Edit.Text := Senha;
    if not (Email.IsEmpty) and not(Senha.IsEmpty) then
    begin
     {$IFDEF MSWINDOWS}
     FViewLogin.btnEntrarClick(FViewLogin.btnEntrar);
     {$ELSE}
     FViewLogin.btnEntrarTap(FViewLogin.btnEntrar,TPointF.Create(0,0));
     {$ENDIF}
    end;
    ViewEditSenha.Clear;
    Close;
  end);
end;

procedure TViewVerificarConta.btnProsseguirClick(Sender: TObject);
begin
  inherited;
  if not FCodigoVerificacao.ToLower.Equals(ViewEditSenha.CodigoVerificacao) then
  begin
    ShowErro('Código de verificação inválido');
    Exit;
  end;

  TThread.CreateAnonymousThread(
  procedure
  var
    LResponse: IResponse;
  begin
    var LJsonBody    := TJSONObject.Create;
    try
      try
        // Json body
        LJsonBody.AddPair('companyId',FCompanyId);
        LResponse := TRequest.New.BaseURL(BaseURL)
          .Resource('account/release-company')
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


          finally
            LJsonResponse.Free;
          end;

          ShowSucesso('Conta ativada com sucesso!');

          // Aqui eu vou prender o usuário na tela de sucesso para que ele veja
          // que o processo de criação de conta deu certo
          ViewMensagem.OnAfterClose := Procedure
                                       begin
                                         ViewMensagem.OnAfterClose := nil;
                                         AbrirLogin;
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

procedure TViewVerificarConta.ExecuteOnShow;
begin
  inherited;
  ViewEditSenha.SetFocus;
  ViewEditSenha.Clear;
  ViewEditSenha.OnCloseKeyBoard :=  CloseKeyBoard;
end;

end.

