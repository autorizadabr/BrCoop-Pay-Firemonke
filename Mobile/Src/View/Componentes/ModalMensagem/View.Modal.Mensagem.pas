unit View.Modal.Mensagem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Check, View.Edit.Base, View.Button.Base, FMX.Controls.Presentation,
  FMX.Objects, FMX.Layouts,
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
  FMX.Platform,FMX.VirtualKeyboard,
  Model.Enums;

type
  TViewModalMensagem = class(TFrame)
    recBase: TRectangle;
    recPrincipal: TRectangle;
    Layout1: TLayout;
    imgCloseModal: TImage;
    Layout2: TLayout;
    lblDescricao: TLabel;
    layButtons: TLayout;
    Layout4: TLayout;
    imgSucesso: TImage;
    imgErro: TImage;
    lblMensagem: TLabel;
    procedure imgCloseModalClick(Sender: TObject);
    procedure imgCloseModalTap(Sender: TObject; const Point: TPointF);
  private
    FOnCloseModal: TProc;
    FState:TStateModalMensagem;
    FMensaege: string;
    FTitle: string;
    procedure SetOnCloseModal(const Value: TProc);
    procedure SetMensaege(const Value: string);
    procedure SetTitle(const Value: string);
    { Private declarations }
  public
    property State:TStateModalMensagem read FState;
    property Title:string read FTitle write SetTitle;
    property Mensaege:string read FMensaege write SetMensaege;
    procedure OpenModal(AState:TStateModalMensagem);
    procedure CloseModal(AProc:TProc);
    property OnCloseModal:TProc read FOnCloseModal write SetOnCloseModal;
    function IsOpen:Boolean;
  end;

implementation

{$R *.fmx}

{ TViewModalMensagem }

procedure TViewModalMensagem.CloseModal(AProc:TProc);
begin
  Visible := False;
  if Assigned(AProc) then
    AProc;
  if Assigned(FOnCloseModal) then
    FOnCloseModal;
end;

procedure TViewModalMensagem.imgCloseModalClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  imgCloseModalTap(Sender,TPointF.Create(0,0));
  {$ENDIF}
end;

procedure TViewModalMensagem.imgCloseModalTap(Sender: TObject; const Point: TPointF);
begin
  CloseModal(nil);
end;

function TViewModalMensagem.IsOpen: Boolean;
begin
  Result := Visible;
end;

procedure TViewModalMensagem.OpenModal(AState:TStateModalMensagem);
begin
  {$IFDEF ANDROID}
  var Keyboard: IFMXVirtualKeyboardService;
  if TPlatformServices.Current.SupportsPlatformService
  (IFMXVirtualKeyboardService, IInterface(Keyboard)) then
  begin
    Keyboard.HideVirtualKeyboard;
  end;
  {$ENDIF}
  FState := AState;
  imgSucesso.Visible := False;
  imgErro.Visible := False;
  if FState = stSucesso then
    imgSucesso.Visible := True
  else
    imgErro.Visible := True;
  Visible := True;
end;

procedure TViewModalMensagem.SetMensaege(const Value: string);
begin
  FMensaege := Value;
  lblMensagem.Text := FMensaege;
end;

procedure TViewModalMensagem.SetOnCloseModal(const Value: TProc);
begin
  FOnCloseModal := Value;
end;

procedure TViewModalMensagem.SetTitle(const Value: string);
begin
  FTitle := Value;
  lblDescricao.Text := FTitle;
end;

end.
