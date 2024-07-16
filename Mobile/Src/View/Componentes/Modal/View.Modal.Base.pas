unit View.Modal.Base;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects,
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
  FMX.Platform,FMX.VirtualKeyboard,FMX.Layouts;

type
  TViewModalBase = class(TFrame)
    recBase: TRectangle;
    recPrincipal: TRectangle;
    Layout1: TLayout;
    imgCloseModal: TImage;
    Layout2: TLayout;
    lblDescricao: TLabel;
    procedure recBaseClick(Sender: TObject);
    procedure recBaseTap(Sender: TObject; const Point: TPointF);
  private
    FMensaege: string;
    FTitle: string;
    FOnCloseModal: TProc;
    procedure SetMensaege(const Value: string);
    procedure SetTitle(const Value: string);
    procedure SetOnCloseModal(const Value: TProc);
   protected
     procedure Loaded; override;
  public
    property Title:string read FTitle write SetTitle;
    property Mensaege:string read FMensaege write SetMensaege;
    function IsOpen:Boolean;
    procedure OpenModal();virtual;
    procedure CloseModal(AProc:TProc);overload;
    procedure CloseModal;overload;
    property OnCloseModal:TProc read FOnCloseModal write SetOnCloseModal;
  end;

implementation

{$R *.fmx}

{ TViewModalBase }

procedure TViewModalBase.CloseModal(AProc: TProc);
begin
  CloseModal;
  if Assigned(AProc) then
    AProc;
end;

procedure TViewModalBase.CloseModal;
begin
  Visible := False;
  if Assigned(FOnCloseModal) then
    FOnCloseModal();
end;

function TViewModalBase.IsOpen: Boolean;
begin
  Result := Visible;
end;

procedure TViewModalBase.Loaded;
begin
  inherited;
  CloseModal;
end;

procedure TViewModalBase.OpenModal;
begin
  {$IFDEF ANDROID}
  var Keyboard: IFMXVirtualKeyboardService;
  if TPlatformServices.Current.SupportsPlatformService
  (IFMXVirtualKeyboardService, IInterface(Keyboard)) then
  begin
    Keyboard.HideVirtualKeyboard;
  end;
  {$ENDIF}
  Visible := True;
end;

procedure TViewModalBase.recBaseClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  CloseModal;
  {$ENDIF}
end;

procedure TViewModalBase.recBaseTap(Sender: TObject; const Point: TPointF);
begin
  CloseModal;
end;

procedure TViewModalBase.SetMensaege(const Value: string);
begin
  FMensaege := Value;
end;

procedure TViewModalBase.SetOnCloseModal(const Value: TProc);
begin
  FOnCloseModal := Value;
end;

procedure TViewModalBase.SetTitle(const Value: string);
begin
  FTitle := Value;
  lblDescricao.Text := FTitle;
end;

end.
