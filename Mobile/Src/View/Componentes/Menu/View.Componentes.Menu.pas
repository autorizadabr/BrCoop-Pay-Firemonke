unit View.Componentes.Menu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.Ani,
   IdURI,
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

  View.Alterar.Senha;

type
  TViewMenu = class(TFrame)
    recBase: TRectangle;
    Layout2: TLayout;
    recBaseItems: TRectangle;
    layHeader: TLayout;
    Circle1: TCircle;
    Layout1: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Layout7: TLayout;
    lblBoasVindas: TLabel;
    lblNomeEmpresa: TLabel;
    recLocalTrabalho: TRectangle;
    Label1: TLabel;
    Image1: TImage;
    recNotaFiscal: TRectangle;
    Image2: TImage;
    Label2: TLabel;
    recHorasTrabalhadas: TRectangle;
    Label14: TLabel;
    Image4: TImage;
    recImpostoRenda: TRectangle;
    Image5: TImage;
    Label15: TLabel;
    recTrocarSenha: TRectangle;
    Label3: TLabel;
    Image6: TImage;
    recUsuario: TRectangle;
    Image7: TImage;
    Label4: TLabel;
    recFinanceiro: TRectangle;
    Label5: TLabel;
    Image8: TImage;
    recEmpresa: TRectangle;
    Image9: TImage;
    Label6: TLabel;
    Circle3: TCircle;
    imgClose: TImage;
    recAssinatura: TRectangle;
    Label8: TLabel;
    Image3: TImage;
    recConfigNFSE: TRectangle;
    Label9: TLabel;
    Image10: TImage;
    recEncerrar: TRectangle;
    Label10: TLabel;
    ScrollBox: TVertScrollBox;
    Layout3: TLayout;
    recContato: TRectangle;
    Image11: TImage;
    Label11: TLabel;
    Image12: TImage;
    Layout6: TLayout;
    ImgUser: TImage;
    ImgCircle: TImage;
    Layout8: TLayout;
    lblCrm: TLabel;
    lblCrmCaption: TLabel;
    Line1: TLine;
    Layout9: TLayout;
    lblCnpj: TLabel;
    lblCnpjCaption: TLabel;
    procedure FrameResize(Sender: TObject);
    procedure imgCloseClick(Sender: TObject);
    procedure imgCloseTap(Sender: TObject; const Point: TPointF);
    procedure recEncerrarTap(Sender: TObject; const Point: TPointF);
    procedure recEncerrarClick(Sender: TObject);
    procedure recContatoTap(Sender: TObject; const Point: TPointF);
  private
    FOnAfterOpen: TProc;
    FOnAfterClose: TProc;
    FCNPJ: string;
    FCRM: string;
    FNomeEmpresa: string;
    FBoasVindas: string;
    FOpenConfigNfse:TProc;
    FEncerrar: TProc;

    procedure SetOnAfterClose(const Value: TProc);
    procedure SetOnAfterOpen(const Value: TProc);
    procedure SetCNPJ(const Value: string);
    procedure SetCRM(const Value: string);
    procedure SetNomeEmpresa(const Value: string);
    procedure SetBoasVindas(const Value: string);
    procedure SetEncerrar(const Value: TProc);
    procedure FreeForms;
  public
    procedure OpenMenu;
    procedure CloseMenu;
    procedure BeforeDestruction; override;
    property Encerrar:TProc read FEncerrar write SetEncerrar;
    property OnAfterClose:TProc read FOnAfterClose write SetOnAfterClose;
    property OnAfterOpen:TProc read FOnAfterOpen write SetOnAfterOpen;
    property OpenConfigNfse:TProc read FOpenConfigNfse write FOpenConfigNfse;
    property NomeEmpresa:string read FNomeEmpresa write SetNomeEmpresa;
    property CNPJ:string read FCNPJ write SetCNPJ;
    property CRM:string read FCRM write SetCRM;
    property BoasVindas:string read FBoasVindas write SetBoasVindas;
  end;

implementation

{$R *.fmx}

{ TViewMenu }

procedure TViewMenu.BeforeDestruction;
begin
  FreeForms;
  inherited;
end;

procedure TViewMenu.CloseMenu;
begin
  FreeForms;
  Self.Align := TAlignLayout.Scale;
  TAnimator.AnimateFloat(Self,'Position.X',-Width,0.2);
  if Assigned(FOnAfterClose) then
    FOnAfterClose();
end;

procedure TViewMenu.FrameResize(Sender: TObject);
begin
  Self.Align := TAlignLayout.Scale;
  if Parent is TControl then
  begin
    Height := TControl(Parent).Height;
    Width := TControl(Parent).Width;
  end;
end;

procedure TViewMenu.FreeForms;
begin
end;

procedure TViewMenu.imgCloseClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  imgCloseTap(Sender,TPointF.Create(0,0))
  {$ENDIF}
end;

procedure TViewMenu.imgCloseTap(Sender: TObject; const Point: TPointF);
begin
  CloseMenu;
end;


procedure TViewMenu.OpenMenu;
begin
  Position.Y := 0;
  TAnimator.AnimateFloat(Self,'Position.X',0,0.2);
  if Assigned(FOnAfterOpen) then
    FOnAfterOpen();
end;


procedure TViewMenu.recContatoTap(Sender: TObject; const Point: TPointF);
begin
  {$IFDEF ANDROID}
  var LIntent:JIntent;
  LIntent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
  LIntent.setData(TJnet_Uri.JavaClass.parse(StringToJString('https://api.whatsapp.com/send?phone=5516999910170&text=Esse contato veio através do Aplicativo Consim')));
  SharedActivity.startActivity(LIntent);
  {$ENDIF}
end;

procedure TViewMenu.recEncerrarClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  recEncerrarTap(Sender,TPointF.Create(0,0));
  {$ENDIF}
end;

procedure TViewMenu.recEncerrarTap(Sender: TObject; const Point: TPointF);
begin
  if Assigned(FEncerrar) then
    FEncerrar;
end;

procedure TViewMenu.SetBoasVindas(const Value: string);
begin
  FBoasVindas := Value;
  lblBoasVindas.Text := FBoasVindas;
end;

procedure TViewMenu.SetCNPJ(const Value: string);
begin
  FCNPJ := Value;
  lblCnpj .Text := FCNPJ;
end;

procedure TViewMenu.SetCRM(const Value: string);
begin
  FCRM := Value;
  lblCrm.Text := FCRM;
end;

procedure TViewMenu.SetEncerrar(const Value: TProc);
begin
  FEncerrar := Value;
end;

procedure TViewMenu.SetNomeEmpresa(const Value: string);
begin
  FNomeEmpresa := Value;
  lblNomeEmpresa.Text := FNomeEmpresa;
end;

procedure TViewMenu.SetOnAfterClose(const Value: TProc);
begin
  FOnAfterClose := Value;
end;

procedure TViewMenu.SetOnAfterOpen(const Value: TProc);
begin
  FOnAfterOpen := Value;
end;

end.
