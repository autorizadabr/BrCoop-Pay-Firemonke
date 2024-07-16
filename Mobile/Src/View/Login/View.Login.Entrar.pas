unit View.Login.Entrar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs,
  FMX.StdCtrls,System.Messaging,FMX.Platform,
  View.Base, View.Componentes.Load, FMX.Layouts, View.Componentes.Mensagem,
  FMX.Controls.Presentation, FMX.Effects, FMX.Filter.Effects, FMX.Objects,
  View.Button.Base, View.Button.Icon, View.Login,
  Model.Enums, View.Nova.Conta,
  FMX.VirtualKeyboard, View.Edit.Base, View.Edit.Date,
{$IFDEF Android}
  AndroidApi.Jni.JavaTypes,
  AndroidApi.Jni.App,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers,
  Androidapi.JNI.Os,
  Androidapi.JNI.Net,
  Androidapi.JNIBridge,
  FMX.Helpers.Android,
{$ENDIF}

  View.Modal.Base;
type
  TNextView = (Login,Registrar);
  TViewLoginEntrar = class(TViewBase)
    Layout1: TLayout;
    btnLogin: TViewButtonIcon;
    btnRegister: TViewButtonIcon;
    Layout2: TLayout;
    Layout3: TLayout;
    Image1: TImage;
    Label5: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    procedure FormResize(Sender: TObject);
    procedure Layout2Resize(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnLoginClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
  private
    FViewLogin:TViewLogin;
    FViewNovaConta:TViewNovaConta;
    FNexView: TNextView;
  public
    property NexView:TNextView read FNexView write FNexView;
    procedure ExecuteOnShow; override;
  end;

var
  ViewLoginEntrar:TViewLoginEntrar;
implementation

{$R *.fmx}

uses Mobile.Permissions;

procedure TViewLoginEntrar.btnLoginClick(Sender: TObject);
begin
  inherited;
  if Assigned(FViewLogin) then
    FreeAndNil(FViewLogin);
  FViewLogin := TViewLogin.Create(Self);
  FViewLogin.Show;
end;

procedure TViewLoginEntrar.btnRegisterClick(Sender: TObject);
begin
  inherited;
  if Assigned(FViewNovaConta) then
    FreeAndNil(FViewNovaConta);
  FViewNovaConta := TViewNovaConta.Create(Self);
  FViewNovaConta.Show;
end;

procedure TViewLoginEntrar.ExecuteOnShow;
begin
  inherited;
  TMobilePermissions.GetInstance.GetPermissions;
end;

procedure TViewLoginEntrar.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
{$IFDEF ANDROID}
  var FService: IFMXVirtualKeyboardService;
  if (Key = vkHardwareBack) then
  begin
    TPlatformServices.Current.SupportsPlatformService
      (IFMXVirtualKeyboardService, IInterface(FService));
    if not((FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState)) then
    begin
      Key := 0;
      PriorForm(Self);
    end
  end;
{$ENDIF}
end;

procedure TViewLoginEntrar.FormResize(Sender: TObject);
begin
  inherited;
  Layout2.Width := Self.Width - 40;
end;

procedure TViewLoginEntrar.Layout2Resize(Sender: TObject);
begin
  btnRegister.Width := (TLayout(Sender).Width/2)-5;
  btnLogin.Width := btnRegister.Width;
end;

end.



