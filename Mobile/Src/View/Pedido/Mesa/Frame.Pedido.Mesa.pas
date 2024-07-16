unit Frame.Pedido.Mesa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, Constantes.Color, DateUtils;
type TStatusMesa = (stLivre,stOcupado);
type
  TFramePedidoMesa = class(TFrame)
    recPrincipal: TRectangle;
    Circle: TCircle;
    recFaixa: TRectangle;
    lblTitulo: TLabel;
    lblNumeroMesa: TLabel;
    CircleFaixa: TCircle;
    procedure recPrincipalResize(Sender: TObject);
    procedure recPrincipalClick(Sender: TObject);
    procedure recPrincipalTap(Sender: TObject; const Point: TPointF);
  private
    FNumeroMesa: Integer;
    FStatus: TStatusMesa;
    FOnClickMesa: TProc<TObject>;
    FHoraQueMesaFoiAberta: TDateTime;
    FHorarioQueMesaEstaAberta:string;
    procedure SetNumeroMesa(const Value: Integer);
    procedure SetStatus(const Value: TStatusMesa);
    procedure SetStatusLivre;
    procedure setStatusOcupada;
    procedure SetHoraQueMesaFoiAberta(const Value: TDateTime);
  public
    property Status:TStatusMesa read FStatus write SetStatus;
    property HoraQueMesaFoiAberta:TDateTime read FHoraQueMesaFoiAberta write SetHoraQueMesaFoiAberta;
    property NumeroMesa:Integer read FNumeroMesa write SetNumeroMesa;
    property OnClickMesa:TProc<TObject> read FOnClickMesa write FOnClickMesa;
  end;

implementation

{$R *.fmx}

{ TFramePedidoMesa }

procedure TFramePedidoMesa.recPrincipalClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if Assigned(FOnClickMesa) then
    FOnClickMesa(Self);
  {$ENDIF}
end;

procedure TFramePedidoMesa.recPrincipalResize(Sender: TObject);
begin
  Circle.Position.Y := 8;
  Circle.Position.X := 8;
  CircleFaixa.Position.X := 2.5;
  CircleFaixa.Position.Y := 2.5;
  CircleFaixa.SendToBack;
  CircleFaixa.BringToFront;
  recFaixa.Position.X := 1;
  recFaixa.Position.Y := -60;
end;

procedure TFramePedidoMesa.recPrincipalTap(Sender: TObject;
  const Point: TPointF);
begin
  if Assigned(FOnClickMesa) then
    FOnClickMesa(Self);
end;

procedure TFramePedidoMesa.SetHoraQueMesaFoiAberta(const Value: TDateTime);
begin
  FHoraQueMesaFoiAberta := Value;
  var LHoraAberturaPedido:TTime := TimeOf(FHoraQueMesaFoiAberta);
  var LHoraAtual:TTime := TimeOf(Now);
  FHorarioQueMesaEstaAberta := Copy(TimeToStr(LHoraAtual - LHoraAberturaPedido),1,5);
end;

procedure TFramePedidoMesa.SetNumeroMesa(const Value: Integer);
begin
  FNumeroMesa := Value;
  lblNumeroMesa.Text := FNumeroMesa.ToString
end;

procedure TFramePedidoMesa.SetStatus(const Value: TStatusMesa);
begin
  FStatus := Value;
  case FStatus of
    stLivre: SetStatusLivre;
    stOcupado: setStatusOcupada;
  end;
end;

procedure TFramePedidoMesa.SetStatusLivre;
begin
  lblTitulo.Text := 'Livre';
  recFaixa.Fill.Color := MESA_COMANDA_LIVRE;
  recPrincipal.Stroke.Color := recFaixa.Fill.Color;
  CircleFaixa.Fill.Color := recFaixa.Fill.Color;
end;

procedure TFramePedidoMesa.setStatusOcupada;
begin
  lblTitulo.Text := 'Ocupada';
  if not FHorarioQueMesaEstaAberta.IsEmpty then
    lblTitulo.Text := FHorarioQueMesaEstaAberta;
  recFaixa.Fill.Color := MESA_COMANDA_OCUPADA;
  recPrincipal.Stroke.Color := recFaixa.Fill.Color;
  CircleFaixa.Fill.Color := recFaixa.Fill.Color;
end;

end.
