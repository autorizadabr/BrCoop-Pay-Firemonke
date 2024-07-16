unit View.Nova.Senha;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, View.Componentes.Load, FMX.Layouts, View.Componentes.Mensagem,
  FMX.Controls.Presentation, FMX.Effects, FMX.Filter.Effects, FMX.Objects,
  FMX.Edit, System.JSON, View.Button.Base,
  View.Edit.Base,FMX.Ani, View.Componentes.Censura;

type
  TViewNovaSenha = class(TViewBase)
    edtNovaSenha: TViewEditBase;
    Label1: TLabel;
    Layout1: TLayout;
    btnProsseguir: TViewButtonBase;
    edtConfirmarSenha: TViewEditBase;
    ViewCensuraNovaSenha: TViewComponentesCensura;
    ViewCensuraConfirmarSenha: TViewComponentesCensura;
    Label14: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnProsseguirClick(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    FEmail: string;
    FCodigo: string;
    procedure SetEmail(const Value: string);
    procedure SetCodigo(const Value: string);
  public
    procedure ExecuteOnShow; override;
    property Email:string read FEmail write SetEmail;
    property Codigo:string read FCodigo write SetCodigo;

  end;


implementation
  uses RESTRequest4D;
{$R *.fmx}

procedure TViewNovaSenha.btnProsseguirClick(Sender: TObject);
begin
  inherited;
  CloseKeyboard;
  try
    if edtNovaSenha.Edit.Text <> edtConfirmarSenha.Edit.Text then
      raise Exception.Create('O campo senha não pode ser diferente do campo confirmar senha! ');
    if edtNovaSenha.Edit.Text.IsEmpty then
      raise Exception.Create('O campo senha não pode ser vazio! ');
    if edtNovaSenha.Edit.Text.Length < 3 then
      raise Exception.Create('O campo senha deve contr pelo menos 3 caracteres! ');
  except on E: Exception do
    begin
      ShowErro(e.Message);
      Exit
    end;
  end;

  TThread.CreateAnonymousThread(
  procedure
  var
    LResponse: IResponse;
  begin
    var LJsonBody := TJSONObject.Create;
    try

      try
        LJsonBody.AddPair('email',Email);
        LJsonBody.AddPair('password',edtNovaSenha.Edit.Text);

        LResponse := TRequest.New.BaseURL(BaseURL)
          .Resource('authentication/update-password')
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

procedure TViewNovaSenha.ExecuteOnShow;
begin
  inherited;

end;

procedure TViewNovaSenha.FormCreate(Sender: TObject);
begin
  inherited;
  ViewCensuraNovaSenha.Edit := edtNovaSenha.Edit;
  ViewCensuraConfirmarSenha.Edit := edtConfirmarSenha.Edit;
end;

procedure TViewNovaSenha.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  //TAnimator.AnimateFloat(recPrincipal,'Margins.Top',75,0.2);
end;

procedure TViewNovaSenha.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  //TAnimator.AnimateFloat(recPrincipal,'Margins.Top',10,0.2);
end;

procedure TViewNovaSenha.SetCodigo(const Value: string);
begin
  FCodigo := Value;
end;

procedure TViewNovaSenha.SetEmail(const Value: string);
begin
  FEmail := Value;
end;

end.
