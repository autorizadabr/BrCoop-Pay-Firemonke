unit Send.Email.CoopPay;

interface

uses
  System.SysUtils,
  System.Classes,
  IdSMTP,
  IdSSLOpenSSL,
  IdMessage,
  IdText,
  IdExplicitTLSClientServerBase;

type
  TTypeEmail = (pResetPassword, pNewAccount,pNone);

  TSendEmailCoopPay = class
  private
    FPassword: string;
    FDestinatario: string;
    FName: string;
    FTypeEmail: TTypeEmail;
    FIP: string;
    FCodeVerificat:string;
  public
    constructor Create;
    property Name: string read FName write FName;
    property Destinatario: string read FDestinatario write FDestinatario;
    property Password: string read FPassword write FPassword;
    property CodeVerificat:string read FCodeVerificat write FCodeVerificat;
    property IP:string read FIP write FIP;
    property TypeEmail: TTypeEmail read FTypeEmail write FTypeEmail;
    procedure Send;
  end;

implementation

{ TEnvioEmailCoopPay }

constructor TSendEmailCoopPay.Create;
begin
  FTypeEmail := pNone;
end;

procedure TSendEmailCoopPay.Send;
var
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  IdText: TIdText;
  LStringList: TStringList;
  LStringHTMLReplace: string;
begin
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  IdSMTP := TIdSMTP.Create(nil);
  IdMessage := TIdMessage.Create(nil);
  LStringList := TStringList.Create;
  try

    if FTypeEmail = pNone then
      raise Exception.Create('Tipo do e-mail não foi informado!');



    IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
    IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;

    IdSMTP.IOHandler                 := IdSSLIOHandlerSocket;
    IdSMTP.UseTLS                    := utUseImplicitTLS;
    IdSMTP.AuthType                  := satDefault;
    IdSMTP.Port                      := 465;
    IdSMTP.Host                      := 'smtp.gmail.com';
    IdSMTP.Username                  := 'seu_Email_Gmail';
    IdSMTP.Password                  := 'Sua Senha@';
    IdMessage.From.Address           := 'Email da Conta';
    IdMessage.From.Name              := 'Email da Conta';
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.Add.Text    := FDestinatario;
    IdMessage.Subject                := 'Coop Pay';
    IdMessage.Encoding               := meMIME;
    if FTypeEmail = pNewAccount then
    begin
      LStringHTMLReplace := '<body class="body">'+
                            '<header>'+
                              '<img src="%LOGO%" alt="">'+
                            '</header class="header">'+
                            '<main class="main">'+
                              '<div class="div-main">'+
                                '<p><strong>Olá %NOME%</strong></p>'+
                                '<p>Você está prestes a ter acesso a nossa aplicação.</p>'+
                                '<p>Está senha de acesso é extremamente importante, não a compartilhe com ninguém.</p>'+
                                '<p>Insira-a no app para desbloquear</p>'+
                                '<div class="codigo">'+
                                  '<p class="text-center">%CODIGO%</p>'+
                                '</div>'+
                                '<p>Caso não tenha solicitado a redefinição da senha, ignore este e-mail. Não se preocupe, sua conta da Amazon Web Services está protegida.</p>'+
                              '</div>'+
                            '</main>'+
                            '<footer class="footer">'+
                              '<p>Enviado pelo sistema. <strong>Coop Pay</strong></p>'+
                              '<p>Rua das Caravelas . Cep 87205040</p>'+
                            '</footer>'+
                          '</body>';

      LStringHTMLReplace := LStringHTMLReplace.Replace('%LOGO%','https://app.autorizadabr.com.br/assets/images/logo_lion.png');
      LStringHTMLReplace := LStringHTMLReplace.Replace('%NOME%',FName);
      LStringHTMLReplace := LStringHTMLReplace.Replace('%CODIGO%',FPassword);

      LStringList.LoadFromFile('NewAccount.html');
      LStringList.Text := LStringList.Text.Replace('%CONTENT_BODY%', LStringHTMLReplace, []);
    end
    else if FTypeEmail = pResetPassword then
    begin
      LStringHTMLReplace := '<body class="body">'+
                            '<header>'+
                              '<img src="%LOGO%" alt="">'+
                            '</header class="header">'+
                            '<main class="main">'+
                              '<div class="div-main">'+
                                '<p><strong>Olá %NOME%</strong></p>'+
                                '<p>parece que você está tentando visualizar os código de recuperação da sua conta.</p>'+
                                '<p>Está chave de verificação expira em 30 minutos. Está chave é extremamente importante, trate-a como uma senha e '+
                                  'não a compartilhe com ninguém.</p>'+
                                '<p>Insira-a no app para desbloquear alterar sua senha</p>'+
                                '<div class="codigo">'+
                                  '<p class="text-center">%CODIGO%</p>'+
                                '</div>'+
                                '<p>Códigos de recuperação são secretos e só devem ser vistos por você para recuperar sua conta. Anote-os e os'+
                                  'mantenha em um lugar seguro.</p>'+
                                '<p>Detectamos essa solicitação através do IP '+FIP+'</p>'+
                                '<p>Se você não fez essa requisição, <strong>redefina sua senha</strong> imediatamente</p>'+
                              '</div>'+
                            '</main>'+
                            '<footer class="footer">'+
                              '<p>Enviado pelo sistema. <strong>Coop Pay</strong></p>'+
                              '<p>Rua das Caravelas . Cep 87205040</p>'+
                            '</footer>'+
                          '</body>';
      LStringHTMLReplace := LStringHTMLReplace.Replace('%LOGO%','https://app.autorizadabr.com.br/assets/images/logo_lion.png');
      LStringHTMLReplace := LStringHTMLReplace.Replace('%NOME%',FName);
      LStringHTMLReplace := LStringHTMLReplace.Replace('%CODIGO%',FCodeVerificat);
      LStringList.LoadFromFile('ResetPassword.html');
      LStringList.Text := LStringList.Text.Replace('%CONTENT_BODY%', LStringHTMLReplace, []);
    end;

    IdText := TIdText.Create(IdMessage.MessageParts);
    IdText.Body.Add(UTF8Encode(LStringList.Text));
    IdText.ContentType := 'text/html';
    IdText.CharSet     := 'utf-8';

    try
      IdSMTP.Connect;
      IdSMTP.Authenticate;
    except
      on E: Exception do
      begin
        E.Message := E.Message;
        Exit;
      end;
    end;

    try
      IdSMTP.Send(IdMessage);
    except
      On E: Exception do
      begin
        Exit;
      end;
    end;
  finally
    IdSMTP.Disconnect;
    UnLoadOpenSSLLibrary;
    FreeAndNil(IdMessage);
    FreeAndNil(IdSSLIOHandlerSocket);
    FreeAndNil(IdSMTP);
  end;
end;

end.
