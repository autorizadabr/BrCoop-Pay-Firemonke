unit View.Base;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  View.Componentes.Mensagem, FMX.Layouts, View.Componentes.Load,
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
  FMX.Platform,FMX.VirtualKeyboard, FMX.Filter.Effects,
  Model.Static.Credencial, FMX.Ani;

type
  TPaginacao = record
  public
    FRegistroJaListado:Integer;
    PaginaAtual:Integer;
    TotalDeRegistros:Integer;
    CarregandoPagina:Boolean;
    procedure AlimentarRegistroJaListado(AValue:Integer);
  end;
  TViewBase = class(TForm)
    recPrincipal:TRectangle;
    Circle4: TCircle;
    Circle5: TCircle;
    layView: TLayout;
    recDelete: TRectangle;
    recBaseModalDelete: TRectangle;
    layTitleModalDelete: TLayout;
    imgCloseModal: TImage;
    layContentTitleModalDelete: TLayout;
    lblDescricaoModalDelete: TLabel;
    layContentButtonsModalDelete: TLayout;
    lblBaseDeletar: TLabel;
    lblBaseCancelar: TLabel;
    procedure imgVoltarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgAdicionarClick(Sender: TObject);
    procedure imgAdicionarTap(Sender: TObject; const Point: TPointF);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lblBaseDeletarTap(Sender: TObject; const Point: TPointF);
    procedure lblBaseDeletarClick(Sender: TObject);
    procedure lblBaseCancelarClick(Sender: TObject);
    procedure lblBaseCancelarTap(Sender: TObject; const Point: TPointF);
  private
    FOnCloseModaMensagem:TProc;
    FNextForm:TProc<TObject>;
    FPriorForm:TProc<TObject>;
    procedure GetException(Sender: TObject; E: Exception);
    procedure SetOnCloseModaMensagem(const Value: TProc);
  protected
  procedure OnClickDeletarRegistro;virtual;
  procedure OnClickCancelarRegistro;virtual;
  public
    ViewMensagem:TViewComponentesMensagem;
    ViewComponentesLoad:TViewComponentesLoad;
    procedure ShowErro(const AMensagem:string);
    procedure ShowSucesso(const AMensagem:string);
    procedure OpenLoad;
    procedure CloseLoad;
    property OnCloseModaMensagem:TProc read FOnCloseModaMensagem write SetOnCloseModaMensagem;
    procedure ExecuteOnShow;virtual;abstract; // Essa abordagem foi criada pois o projeto precisava ficar sempre no mesmo forumario
                                              // Com isso não teria como dar um OnShow, somente copiar tudo que esta dentro do LayView
    property NextForm:TProc<TObject> read FNextForm write FNextForm;
    property PriorForm:TProc<TObject> read FPriorForm write FPriorForm;
    function BaseURL:string;
    procedure CloseKeyboard;
    procedure OpenDelete;
    procedure CloseDelete;
  end;

var
  ViewBase: TViewBase;

implementation

{$R *.fmx}

function TViewBase.BaseURL: string;
begin
  Result := TModelStaticCredencial.GetInstance.BASEURL;
end;

procedure TViewBase.CloseDelete;
begin
  recDelete.Visible := False;
//  TAnimator.AnimateFloat(recDelete,'Position.Y',Self.Height+10,0.2);
end;

procedure TViewBase.CloseKeyboard;
begin
  {$IFNDEF MSWINDOWS}
  var Keyboard: IFMXVirtualKeyboardService;
  if TPlatformServices.Current.SupportsPlatformService
  (IFMXVirtualKeyboardService, IInterface(Keyboard)) then
  begin
    Keyboard.HideVirtualKeyboard;
  end;
  {$ENDIF}
end;

procedure TViewBase.CloseLoad;
begin
  ViewComponentesLoad.CloseFrame;
end;


procedure TViewBase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caHide;
//  if Assigned(FPriorForm) then
//    PriorForm(Self);
//  Self := nil;
end;

procedure TViewBase.FormCreate(Sender: TObject);
begin
  ViewMensagem               := TViewComponentesMensagem.Create(Self);
  ViewMensagem.Parent        := layView;
  ViewComponentesLoad        := TViewComponentesLoad.Create(Self);
  ViewComponentesLoad.Parent := layView;
  Application.OnException    := GetException;
  recDelete.Visible          := False;
  recDelete.Align            := TAlignLayout.Contents;
  recBaseModalDelete.Height  := 250;
end;

procedure TViewBase.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ViewMensagem);
end;

procedure TViewBase.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  var FService: IFMXVirtualKeyboardService;
  if (Key = vkHardwareBack) then
  begin
    TPlatformServices.Current.SupportsPlatformService
      (IFMXVirtualKeyboardService, IInterface(FService));
    if not((FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState)) then
    begin
      Key := 0;
      if Assigned(FPriorForm) then
        PriorForm(Self)
      else
        Close;
    end
  end;
end;

procedure TViewBase.FormResize(Sender: TObject);
begin
//  recDelete.Align := TAlignLayout.Scale;
//  recDelete.Width := Self.Width;
//  recDelete.Height := Self.Height;
end;

procedure TViewBase.FormShow(Sender: TObject);
begin
  ExecuteOnShow;
end;

procedure TViewBase.GetException(Sender: TObject; E: Exception);
begin
  ShowErro(E.Message);
end;

procedure TViewBase.imgAdicionarClick(Sender: TObject);
begin
//
end;

procedure TViewBase.imgAdicionarTap(Sender: TObject; const Point: TPointF);
begin
//
end;

procedure TViewBase.imgVoltarClick(Sender: TObject);
begin
  close;
end;



procedure TViewBase.lblBaseCancelarClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  OnClickCancelarRegistro;
  {$ENDIF}
end;

procedure TViewBase.lblBaseCancelarTap(Sender: TObject; const Point: TPointF);
begin
  OnClickCancelarRegistro;
end;

procedure TViewBase.lblBaseDeletarClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  OnClickDeletarRegistro;
  {$ENDIF}
end;

procedure TViewBase.lblBaseDeletarTap(Sender: TObject; const Point: TPointF);
begin
  OnClickDeletarRegistro;
end;

procedure TViewBase.OnClickCancelarRegistro;
begin
  CloseDelete;
end;

procedure TViewBase.OnClickDeletarRegistro;
begin

end;

procedure TViewBase.OpenDelete;
begin
  recDelete.BringToFront;
  recDelete.Visible := True;
//  recDelete.Align  := TAlignLayout.Scale;
//  recDelete.Width  := Self.Width;
//  recDelete.Height := Self.Height;
//  recDelete.Position.X := 0;
//  TAnimator.AnimateFloat(recDelete,'Position.Y',0,0.2);
end;

procedure TViewBase.OpenLoad;
begin
  ViewComponentesLoad.OpenFrame;
end;

procedure TViewBase.SetOnCloseModaMensagem(const Value: TProc);
begin
  FOnCloseModaMensagem := Value;
  ViewMensagem.OnAfterClose := FOnCloseModaMensagem;
end;

procedure TViewBase.ShowErro(const AMensagem: string);
begin
  TThread.Synchronize(nil,
  procedure
  begin
    {$IFNDEF MSWINDOWS}
    var Keyboard: IFMXVirtualKeyboardService;
    if TPlatformServices.Current.SupportsPlatformService
    (IFMXVirtualKeyboardService, IInterface(Keyboard)) then
    begin
      Keyboard.HideVirtualKeyboard;
    end;
    {$ENDIF}

    ViewComponentesLoad.CloseFrame;
    ViewMensagem.BringToFront;
    ViewMensagem.Erro(AMensagem);
  end);
end;

procedure TViewBase.ShowSucesso(const AMensagem: string);
begin
  TThread.Synchronize(nil,
  procedure
  begin
    ViewComponentesLoad.CloseFrame;
    ViewMensagem.Sucesso(AMensagem);
  end);
end;

{ TPaginacao }

procedure TPaginacao.AlimentarRegistroJaListado(AValue: Integer);
begin

end;


end.
