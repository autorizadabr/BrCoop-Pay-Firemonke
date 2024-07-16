unit Frame.Pedido.Comanda;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, FMX.Edit, View.Edit.Base;

type
  TFramePedidoComanda = class(TFrame)
    recBase: TRectangle;
    recPrincipal: TRectangle;
    layButtons: TLayout;
    lblCancelar: TLabel;
    lblConfirmar: TLabel;
    lblCaption: TLabel;
    edtNome: TViewEditBase;
    edtNumero: TViewEditBase;
    Label14: TLabel;
    Label1: TLabel;
    procedure lblConfirmarClick(Sender: TObject);
    procedure lblCancelarClick(Sender: TObject);
  private
    FOnClickConfirmar: TProc<TObject>;
    FNumeroComanda: Integer;
    FDescricao: string;
    procedure SetDescricao(const Value: string);
    procedure SetNumeroComanda(const Value: Integer);
    function GetDescricao: string;
    function GetNumeroComanda: Integer;
  public
    procedure OpenComanda;
    procedure CloseComanda;
    property OnClickConfirmar:TProc<TObject> read FOnClickConfirmar write FOnClickConfirmar;
    property Descricao:string read GetDescricao write SetDescricao;
    property NumeroComanda:Integer read GetNumeroComanda write SetNumeroComanda;
  end;

implementation

{$R *.fmx}

{ TFramePedidoComanda }

procedure TFramePedidoComanda.CloseComanda;
begin
  Self.Visible := False;
end;

function TFramePedidoComanda.GetDescricao: string;
begin
  Result := edtNome.Edit.Text;
end;

function TFramePedidoComanda.GetNumeroComanda: Integer;
begin
  Result := StrToIntDef(edtNumero.Edit.Text,0);
end;

procedure TFramePedidoComanda.lblCancelarClick(Sender: TObject);
begin
  CloseComanda;
end;

procedure TFramePedidoComanda.lblConfirmarClick(Sender: TObject);
begin
  CloseComanda;
  if Assigned(FOnClickConfirmar) then
    FOnClickConfirmar(Self);
end;

procedure TFramePedidoComanda.OpenComanda;
begin
  Self.Visible := True;
  edtNome.Edit.SetFocus;
end;

procedure TFramePedidoComanda.SetDescricao(const Value: string);
begin
  FDescricao := Value;
  edtNome.Edit.Text := FDescricao;
end;

procedure TFramePedidoComanda.SetNumeroComanda(const Value: Integer);
begin
  FNumeroComanda := Value;
  edtNome.Edit.Text := IntToStr(FNumeroComanda);
end;

end.
