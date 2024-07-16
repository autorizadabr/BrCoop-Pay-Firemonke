unit View.Componentes.Mensagem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects,
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
  FMX.Platform,FMX.VirtualKeyboard,  FMX.Ani, FMX.Effects;

type
  TColorBase = (clrVerde,clrAzul,clrVermelho);
  TViewComponentesMensagem = class(TFrame)
    recBase: TRectangle;
    recPrincipal: TRectangle;
    Layout1: TLayout;
    Image1: TImage;
    Layout2: TLayout;
    lblDescricao: TLabel;
    layButtons: TLayout;
    lblMensagem: TLabel;
    Layout4: TLayout;
    imgSucesso: TImage;
    imgErro: TImage;
    procedure FrameTap(Sender: TObject; const Point: TPointF);
    procedure Label2Click(Sender: TObject);
    procedure Label2Tap(Sender: TObject; const Point: TPointF);
    procedure Image1Click(Sender: TObject);
    procedure Image1Tap(Sender: TObject; const Point: TPointF);
  private
    FBaseColor: TColorBase;
    FOnAfterClose:TProc;
    procedure SetBaseColor(const Value: TColorBase);
    { Private declarations }
    procedure ShowMensagem(AMensagem:string);
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure Erro(AMensagem:string);
    procedure Sucesso(AMensagem:string);
    procedure CloseMensagem();
    property BaseColor:TColorBase read FBaseColor write SetBaseColor;
    property OnAfterClose:TProc read FOnAfterClose write FOnAfterClose;

  end;

implementation

{$R *.fmx}

{ TViewComponentesMensagem }

procedure TViewComponentesMensagem.AfterConstruction;
begin
  inherited;
//  Self.Position.Y := 0;
//  Self.Position.X := 0;
//  Self.BaseColor := TColorBase.clrAzul;
  imgSucesso.Visible := False;
  imgErro.Visible    := False;
  Self.Visible       := False;
  Self.Align         := TAlignLayout.Contents;
end;

procedure TViewComponentesMensagem.BeforeDestruction;
begin
  inherited;

end;

procedure TViewComponentesMensagem.CloseMensagem;
begin
  Visible := False;
  imgSucesso.Visible := False;
  imgErro.Visible := False;
  if Assigned(FOnAfterClose) then
    FOnAfterClose();
end;

procedure TViewComponentesMensagem.Erro(AMensagem: string);
begin
  lblDescricao.Text := 'Erro';
  imgErro.Visible := True;
  ShowMensagem(AMensagem);
end;

procedure TViewComponentesMensagem.FrameTap(Sender: TObject;
  const Point: TPointF);
begin
  CloseMensagem;
end;

procedure TViewComponentesMensagem.Image1Click(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  CloseMensagem;
  {$ENDIF}
end;

procedure TViewComponentesMensagem.Image1Tap(Sender: TObject;
  const Point: TPointF);
begin
  CloseMensagem;
end;

procedure TViewComponentesMensagem.Label2Click(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  Visible := False;
  {$ENDIF}
end;

procedure TViewComponentesMensagem.Label2Tap(Sender: TObject;
  const Point: TPointF);
begin
  Visible := False;
end;

procedure TViewComponentesMensagem.SetBaseColor(const Value: TColorBase);
begin
  FBaseColor := Value;
  case Value of
    clrVerde:recBase.Fill.Color := $FF3FB89C;
    clrAzul: recBase.Fill.Color := $FF7AB8E6;
    clrVermelho: recBase.Fill.Color := $FFE25D5D;
  end;
end;

procedure TViewComponentesMensagem.ShowMensagem(AMensagem:string);
begin
  {$IFDEF ANDROID}
  var Keyboard: IFMXVirtualKeyboardService;
  if TPlatformServices.Current.SupportsPlatformService
  (IFMXVirtualKeyboardService, IInterface(Keyboard)) then
  begin
    Keyboard.HideVirtualKeyboard;
  end;
  {$ENDIF}
  lblMensagem.Text := AMensagem;
  Self.BringToFront;
  Self.Visible := True;
end;

procedure TViewComponentesMensagem.Sucesso(AMensagem: string);
begin
  //BaseColor := clrVerde;
  lblDescricao.Text := 'Sucesso';
  imgSucesso.Visible := True;
  ShowMensagem(AMensagem);
end;

end.
