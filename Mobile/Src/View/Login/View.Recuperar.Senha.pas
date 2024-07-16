unit View.Recuperar.Senha;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, View.Componentes.Load, FMX.Layouts, View.Componentes.Mensagem,
  FMX.Controls.Presentation, FMX.Effects, FMX.Filter.Effects, FMX.Objects,
  FMX.Edit, System.JSON,FMX.Ani, View.Edit.Base, View.Button.Base,
  View.Codigo.Verificacao;

type
  TViewRecuperarSenha = class(TViewBase)
    Label1: TLabel;
    Layout1: TLayout;
    btnProsseguir: TViewButtonBase;
    Label14: TLabel;
    edtEmail: TViewEditBase;
    procedure btnProsseguirClick(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormCreate(Sender: TObject);
  private
  public
    var CodigoRessetPassword:Integer;
    CodigoUsuario:string;
    procedure ExecuteOnShow; override;
  end;


implementation

uses
  RESTRequest4D;

{$R *.fmx}

procedure TViewRecuperarSenha.ExecuteOnShow;
begin
  inherited;
  {$IFDEF RELEASE}
  edtEmail.Edit.Text := EmptyStr;
  {$ENDIF}
end;

procedure TViewRecuperarSenha.FormCreate(Sender: TObject);
begin
  inherited;
  CodigoRessetPassword := 0;
end;

procedure TViewRecuperarSenha.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  //TAnimator.AnimateFloat(recPrincipal,'Margins.Top',75,0.2);
end;

procedure TViewRecuperarSenha.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  //TAnimator.AnimateFloat(recPrincipal,'Margins.Top',10,0.2);
end;

procedure TViewRecuperarSenha.btnProsseguirClick(Sender: TObject);
begin
  inherited;
  edtEmail.Edit.ResetFocus;
  CloseLoad;
  if edtEmail.Edit.Text.IsEmpty then
    raise Exception.Create('Favor preencher o e-mail cadastrado');

  OpenLoad;

  TThread.CreateAnonymousThread(
  procedure
  var
    LResponse: IResponse;
  begin
    var LJsonBody := TJSONObject.Create;
    try

      try
        LJsonBody.AddPair('email',edtEmail.Edit.Text);

        LResponse := TRequest.New.BaseURL(BaseURL)
          .Resource('authentication/reset-password')
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
            if LResponse.StatusCode <> 200 then
            begin
              // Tratando o erro
              ShowErro(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
              Exit; // Se der erro ele sai fora e não abre a próxima tela
            end;

            CodigoRessetPassword := LJsonResponse.GetValue<Integer>('code',-1);
          finally
            LJsonResponse.Free;
          end;

          // Vai abrir a próxima tela
          NextForm(Self);
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
      FreeAndNil(LJsonBody);
    end;

  end).Start;
end;

end.
