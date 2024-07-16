unit View.Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, View.Componentes.Load, FMX.Layouts, View.Componentes.Mensagem,
  FMX.Controls.Presentation, FMX.Effects, FMX.Filter.Effects, FMX.Objects,
  FMX.Edit,   View.Recuperar.Senha,FMX.VirtualKeyboard,System.JSON,
  View.Edit.Base, View.Button.Base, FMX.Ani,FMX.Platform,
  System.Generics.Collections,
  Model.Static.Credencial, View.Componentes.Censura, View.MDI.Principal;



type
  TNextView = (EsqueciMinhaSenha,NovaConta,Entrar,AtivarEmpresa,NoneView);
  TViewLogin = class(TViewBase)
    lblEsqueciMinhaSenha: TLabel;
    edtEmail: TViewEditBase;
    edtSenha: TViewEditBase;
    Layout1: TLayout;
    btnEntrar: TViewButtonBase;
    imgVisible: TImage;
    imgVisibleOff: TImage;
    imgSenha: TImage;
    layDescription: TLayout;
    Label3: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Layout2: TLayout;
    lblEmailInvalido: TLabel;
    ViewCensura: TViewComponentesCensura;
    Label14: TLabel;
    Label2: TLabel;
    procedure lblEsqueciMinhaSenhaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEntrarClick(Sender: TObject);
    procedure btnEntrarTap(Sender: TObject; const Point: TPointF);
    procedure imgSenhaTap(Sender: TObject; const Point: TPointF);
    procedure imgSenhaClick(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure Label1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FViewMDIPrincipal:TViewMDIPrincipal;
    FNextView:TNextView;
    FCodigoVerify: string;
    FCompanyId: string;
    procedure AposFecharATelaDeErro;
  public
    property CompanyId:string read FCompanyId write FCompanyId;
    property CodigoVerify:string read FCodigoVerify write FCodigoVerify;
    procedure ExecuteOnShow; override;
    property NextView:TNextView read FNextView write FNextView default NoneView;

  end;

implementation

{$R *.fmx}

uses RESTRequest4D,Model.Connection;

procedure TViewLogin.btnEntrarTap(Sender: TObject; const Point: TPointF);
begin
  try
    CloseKeyboard;
    edtEmail.Edit.ResetFocus;
    edtSenha.Edit.ResetFocus;
    if edtEmail.Edit.Text.IsEmpty then
      raise Exception.Create('O campo e-mail não pode ser vazio!');
    if edtSenha.Edit.Text.IsEmpty then
      raise Exception.Create('O campo senha não pode ser vazio!');
    OpenLoad;

    edtEmail.Edit.ResetFocus;
    edtSenha.Edit.ResetFocus;

    TThread.CreateAnonymousThread(
    procedure
    var
      LResponse: IResponse;
    begin
      var LJsonBody := TJSONObject.Create;
      try

        try
          LJsonBody.AddPair('email',edtEmail.Edit.Text);
          LJsonBody.AddPair('password',edtSenha.Edit.Text);

          LResponse := TRequest.New.BaseURL(BaseURL)
            .Resource('authentication/login')
            .AddBody(LJsonBody)
            .Accept('application/json')
            .Post;

          var LUserId:string;
          var LCompanyId:string;


          TThread.Synchronize(nil,
          procedure
          begin
            CloseLoad;
            var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
            try
              // Verificando o status code

              if LResponse.StatusCode = 401 then
              begin
                // Quando cair aqui ele vai mostrar uma tela de erro
                // E quando fechar essa tela de erro o sistema vai executar
                // o código na procedure "AposFecharATelaDeErro"
                ViewMensagem.OnAfterClose := AposFecharATelaDeErro;
                ShowErro(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
                Exit;
              end
              else if LResponse.StatusCode <> 200 then
              begin
                // Tratando o erro
                ShowErro(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
                Exit; // Se der erro ele sai fora e não abre a próxima tela
              end;

              TModelStaticCredencial.GetInstance.SetToken(LJsonResponse.GetValue<string>('token',''));

              LUserId    := LJsonResponse.GetValue<TJSONObject>('user').GetValue<string>('id','');
              var LCompany := LJsonResponse.GetValue<TJSONArray>('companies')[0] as TJSONObject;
              LCompanyId := LCompany.GetValue<string>('id','');

              var LCustomerDefault := LCompany.GetValue<TJSONObject>('customerDefault',nil);
              if Assigned(LCustomerDefault) then
              begin
                TModelStaticCredencial.GetInstance.SetCustomer(LCustomerDefault.GetValue<string>('id',''));
              end;

              TModelStaticCredencial.GetInstance.SetQuantidadeMesa(LCompany.GetValue<Integer>('quantityTable',20));
              TModelStaticCredencial.GetInstance.SetCompany(LCompanyId);
            finally
              LJsonResponse.Free;
            end;

            TModelStaticCredencial.GetInstance.SetUser(LUserId);

            // Vai abrir a próxima tela
            //NextForm(Self);

          end);


          // Para que eu possa fazer o refresh Token
          // Esse trecho do código vai ser usado futuramente para multi empresas
          if LResponse.StatusCode = 200  then
          begin
            var LBodyToken := TJSONObject.Create;
            LBodyToken.AddPair('idUser',LUserId);
            LBodyToken.AddPair('idCompany',LCompanyId);

            var LResponseToken := TRequest.New.BaseURL(BaseURL)
              .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
              .Resource('authentication/refresh-token')
              .AddBody(LBodyToken)
              .Accept('application/json')
              .Post;

            var LJsonResponse := TJSONObject.ParseJSONValue(LResponseToken.Content);
            try
              if LResponseToken.StatusCode <> 200 then
              begin
                // Tratando o erro
                ShowErro(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
                Exit; // Se der erro ele sai fora e não abre a próxima tela
              end;

              TModelStaticCredencial.GetInstance.SetToken(LJsonResponse.GetValue<string>('token',''));

              TThread.Synchronize(nil,
              procedure
              begin
                if not Assigned(FViewMDIPrincipal) then
                  FViewMDIPrincipal := TViewMDIPrincipal.Create(Application);
                FViewMDIPrincipal.Show;
              end);


            finally
             LJsonResponse.Free;
            end;
          end;

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
      end;

    end).Start;
  except on E: Exception do
    begin
      ShowErro(E.Message);
    end;
  end;
end;

procedure TViewLogin.ExecuteOnShow;
begin
  inherited;
  imgVisible.Visible := False;
  imgVisibleOff.Visible := False;
  {$IFDEF RELEASE}
  edtEmail.Edit.Text := EmptyStr;
  edtSenha.Edit.Text := EmptyStr;
  {$ENDIF}
end;

procedure TViewLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := TCloseAction.caHide;
end;

procedure TViewLogin.FormCreate(Sender: TObject);
begin
  inherited;
  ViewCensura.Edit := edtSenha.Edit;
end;

procedure TViewLogin.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  //TAnimator.AnimateFloat(layDescription,'Height',layDescription.Height + 70,0.2);
end;

procedure TViewLogin.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  //TAnimator.AnimateFloat(layDescription,'Height',layDescription.Height - 70,0.2);
end;

procedure TViewLogin.imgSenhaClick(Sender: TObject);
begin
  inherited;
  {$IFNDEF ANDROID}
  imgSenhaTap(Sender,TPointF.Create(0,0));
  {$ENDIF}
end;

procedure TViewLogin.imgSenhaTap(Sender: TObject; const Point: TPointF);
begin
  inherited;
  edtSenha.Edit.Password := not(edtSenha.Edit.Password);
  if edtSenha.Edit.Password then
  begin
    imgSenha.Bitmap := imgVisible.Bitmap;
  end
  else
  begin
    imgSenha.Bitmap := imgVisibleOff.Bitmap;
  end;
end;

procedure TViewLogin.Label1Click(Sender: TObject);
begin
  inherited;
  NextView := NovaConta;
  NextForm(Self);
end;

procedure TViewLogin.lblEsqueciMinhaSenhaClick(Sender: TObject);
begin
  inherited;
  NextView := EsqueciMinhaSenha;
  NextForm(Self);
end;

procedure TViewLogin.AposFecharATelaDeErro;
begin
  ViewMensagem.OnAfterClose := nil;
  OpenLoad;
  TThread.CreateAnonymousThread(
  procedure
  var
    LResponse: IResponse;
  begin
    try
      var LJsonBodyVerify := TJSONObject.Create;

      LJsonBodyVerify.AddPair('userEmail', edtEmail.Edit.Text);

      LResponse := TRequest.New.BaseURL(BaseURL)
        .Resource('account/verify')
        .AddBody(LJsonBodyVerify)
        .Accept('application/json')
        .Post;

      var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
      try
        // Verificando o status code

        if LResponse.StatusCode <> 200 then
        begin
          // Tratando o erro
          ShowErro(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
          Exit; // Se der erro ele sai fora e não abre a próxima tela
        end;

        // Se esse campo for true quer dizer que a empresa já está verificada
        if LJsonResponse.GetValue<Boolean>('isVerify',True) then
          Exit;

        FCodigoVerify := LJsonResponse.GetValue<string>('codeVerify','');
        FCompanyId    := LJsonResponse.GetValue<string>('companyId','');

      finally
        LJsonResponse.Free;
      end;

      TThread.Synchronize(nil,
      procedure
      begin
        NextView := AtivarEmpresa;
        NextForm(Self);
        CloseLoad;
      end);
    except on E: Exception do
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          ShowErro(e.Message);
        end);
      end;
    end;
  end).Start;
end;

procedure TViewLogin.btnEntrarClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  btnEntrarTap(Sender,TPointF.Create(0,0));
  {$ENDIF}
end;

end.
