unit Frame.Pagamento.Recebimento.Formas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, Model.Records.Tipo.Pagamento,
  FMX.Layouts;
type
  TFramePagamentoRecebimentoFormas = class(TFrame)
    imgRemover: TImage;
    lblValorPago: TLabel;
    lblTipoPagamento: TLabel;
    layImagem: TLayout;
    procedure imgRemoverClick(Sender: TObject);
    procedure imgRemoverTap(Sender: TObject; const Point: TPointF);
  private
    FTipoPagamento: TTipoPagamento;
    FValorPago: Currency;
    FOnClicRemoverFormaPagamento: TProc<TObject>;
    FSequencial: Integer;
    procedure SetTipoPagamento(const Value: TTipoPagamento);
    procedure SetValorPago(const Value: Currency);
  public
    property Sequencial:Integer read FSequencial write FSequencial;
    property TipoPagamento:TTipoPagamento read FTipoPagamento write SetTipoPagamento;
    property ValorPago:Currency read FValorPago write SetValorPago;
    property OnClicRemoverFormaPagamento:TProc<TObject> read FOnClicRemoverFormaPagamento write FOnClicRemoverFormaPagamento;
  end;

implementation

{$R *.fmx}

{ FramePagamentoRecebimentoFormas }

procedure TFramePagamentoRecebimentoFormas.imgRemoverClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if Assigned(FOnClicRemoverFormaPagamento) then
    FOnClicRemoverFormaPagamento(Self);
  {$ENDIF}
end;

procedure TFramePagamentoRecebimentoFormas.imgRemoverTap(Sender: TObject;
  const Point: TPointF);
begin
  if Assigned(FOnClicRemoverFormaPagamento) then
    FOnClicRemoverFormaPagamento(Self);
end;

procedure TFramePagamentoRecebimentoFormas.SetTipoPagamento(const Value: TTipoPagamento);
begin
  FTipoPagamento := Value;
  lblTipoPagamento.Text := FTipoPagamento.Nome;
end;

procedure TFramePagamentoRecebimentoFormas.SetValorPago(const Value: Currency);
begin
  FValorPago := Value;
  lblValorPago.Text := 'R$ '+FormatFloat('#,##0.00',FValorPago);
end;

end.
