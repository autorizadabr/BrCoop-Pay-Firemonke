unit View.Componentes.Teclado.Desconto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Componentes.Teclado, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects,
  Model.Utils, Model.Pedido.CalculoDesconto, Model.Pedido.Valores.Desconto;

type
  TLayoutAtivo = (Subtotal,DescontoEmReais,DescontoEmPercentual,Nunhuma);
  TFrameComponentesTecladoDesconto = class(TFrame)
    recBase: TRectangle;
    recPrincipal: TRectangle;
    laySubTotal: TLayout;
    lblCaptionSubtotal: TLabel;
    layButtons: TLayout;
    lblCancelar: TLabel;
    lblConfirmar: TLabel;
    FrameComponentesTeclado1: TFrameComponentesTeclado;
    Layout4: TLayout;
    Circle1: TCircle;
    lblSubTotal: TLabel;
    CircleCentral: TCircle;
    layDescontoPercentual: TLayout;
    lblCaptionDescontoPercentual: TLabel;
    lblDescontoPercentual: TLabel;
    Layout6: TLayout;
    Circle2: TCircle;
    Circle3: TCircle;
    layDescontoEmReais: TLayout;
    lblCaptionDescontoReais: TLabel;
    lblDescontoReais: TLabel;
    Layout8: TLayout;
    Circle4: TCircle;
    Circle5: TCircle;
    procedure laySubTotalClick(Sender: TObject);
    procedure layDescontoEmReaisClick(Sender: TObject);
    procedure layDescontoPercentualClick(Sender: TObject);
    procedure lblCancelarClick(Sender: TObject);
    procedure lblConfirmarClick(Sender: TObject);
  private
    FLayoutAtivo:TLayoutAtivo;
    FDescontoPercentual: Currency;
    FSubtotal: Currency;
    FDescontoReais: Currency;
    FOnClickConfirmar: TProc<TObject>;
    FModelPedidoCalculoDesconto:TModelPedidoCalculoDesconto;
    procedure AtualizarValores(AValue:string);
    procedure AtualizarValorDescontoPercentual(AValue:string);
    procedure DesativarTodosLayout;
    procedure AtivarDesativarLayout(Alayout:TLayout;Ativo:Boolean);
    procedure SetDescontoPercentual(const Value: Currency);
    procedure SetDescontoReais(const Value: Currency);
    procedure SetSubtoal(const Value: Currency);
    function GetSubtotal: Currency;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure OpenDesconto(const ASubtotal,AValorDesconto:Currency);
    procedure CloseDesconto;
    property OnClickConfirmar:TProc<TObject> read FOnClickConfirmar write FOnClickConfirmar;
    property Subtotal:Currency read GetSubtotal write SetSubtoal;
    property DescontoReais:Currency read FDescontoReais write SetDescontoReais;
    property DescontoPercentual:Currency read FDescontoPercentual write SetDescontoPercentual;
  end;

implementation

{$R *.fmx}

{ TFrameComponentesTecladoDesconto }

procedure TFrameComponentesTecladoDesconto.AfterConstruction;
begin
  inherited;
  CloseDesconto;
  FLayoutAtivo := TLayoutAtivo.Nunhuma;
  FrameComponentesTeclado1.OnResize(Self);
  FrameComponentesTeclado1.AtualizarValorDigitado := AtualizarValores;
  FModelPedidoCalculoDesconto := TModelPedidoCalculoDesconto.Create;
end;

procedure TFrameComponentesTecladoDesconto.AtivarDesativarLayout(Alayout:TLayout;Ativo:Boolean);
begin
  for var I := 0 to Pred(Alayout.ControlsCount) do
  begin
    if Alayout.Controls[I] is TLayout then
    begin
      var LLayoutCircle := TLayout(Alayout.Controls[i]);
      for var X := 0 to Pred(LLayoutCircle.ControlsCount) do
      begin
        if LLayoutCircle.Controls[X] is TCircle then
        begin

          var LCirclePrimario := TCircle(LLayoutCircle.Controls[x]);
          if Ativo then
            LCirclePrimario.Stroke.Color := $FF439AF5
          else
            LCirclePrimario.Stroke.Color := TAlphaColorRec.Black;

          for var  Y := 0 to Pred(LCirclePrimario.ControlsCount) do
          begin
            if TCircle(LLayoutCircle.Controls[x]).Controls[y] is TCircle then
            begin
              var LCircleSecundario        := TCircle(TCircle(LLayoutCircle.Controls[x]).Controls[y]);
              if Ativo then
                LCircleSecundario.Fill.Color := $FF439AF5
              else
                LCircleSecundario.Fill.Color := TAlphaColorRec.White
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TFrameComponentesTecladoDesconto.AtualizarValorDescontoPercentual(
  AValue: string);
begin
  lblDescontoPercentual.Text := TModelUtils.FormatCurrencyValue(AValue) + ' %';
end;

procedure TFrameComponentesTecladoDesconto.AtualizarValores(AValue: string);
begin
  var LFormatValue             := TModelUtils.FormatCurrencyValue(AValue);
  var LFormatValueReplacePonto := LFormatValue.Replace('.', '', [rfReplaceAll]);
  var LCurrencyValue           := StrToCurrDef(LFormatValueReplacePonto, 0);
  var LResult:TValoresDesconto;
  if FLayoutAtivo = TLayoutAtivo.Subtotal then
  begin
    FModelPedidoCalculoDesconto.ValorBrutoSubTotal := FSubtotal;
    LResult :=  FModelPedidoCalculoDesconto.CalcularPorSubTotal(LCurrencyValue);

//    lblSubTotal.Text           := 'R$ '+LFormatValue;
//    DescontoReais              := (FSubtotal - LCurrencyValue);
//    lblDescontoReais.Text      := 'R$ '+FormatFloat('#,##0.00',DescontoReais);
//    DescontoPercentual         := ((DescontoReais / FSubtotal)*100);
//    lblDescontoPercentual.Text := FormatFloat('#,##0.00',DescontoPercentual)+' %';
  end
  else if FLayoutAtivo = TLayoutAtivo.DescontoEmReais then
  begin
    FModelPedidoCalculoDesconto.ValorBrutoSubTotal := FSubtotal;
    LResult :=  FModelPedidoCalculoDesconto.CalcularPorValor(LCurrencyValue);

//    DescontoReais              := LCurrencyValue ;
//    lblDescontoReais.Text      := 'R$ '+FormatFloat('#,##0.00',DescontoReais);
//    lblSubTotal.Text           := 'R$ '+FormatFloat('#,##0.00',(FSubtotal - DescontoReais));
//    DescontoPercentual         := ((DescontoReais / FSubtotal)*100);
//    lblDescontoPercentual.Text := FormatFloat('#,##0.00',DescontoPercentual)+' %';
  end
  else if FLayoutAtivo = TLayoutAtivo.DescontoEmPercentual then
  begin
    FModelPedidoCalculoDesconto.ValorBrutoSubTotal := FSubtotal;
    LResult :=  FModelPedidoCalculoDesconto.CalcularPorPorcentagem(LCurrencyValue);

//    DescontoPercentual         := LCurrencyValue;
//    lblDescontoPercentual.Text := FormatFloat('#,##0.00',DescontoPercentual)+' %';
//    DescontoReais              := FSubtotal * (DescontoPercentual / 100);
//    lblDescontoReais.Text      := 'R$ '+FormatFloat('#,##0.00',DescontoReais);
//    lblSubTotal.Text           := 'R$ '+FormatFloat('#,##0.00',(FSubtotal - DescontoReais));
//    DescontoPercentual         := ((DescontoReais / FSubtotal)*100);
  end;

  lblSubTotal.Text           := LResult.ValorTotalFormatado;
  DescontoReais              := LResult.DescontoReais;
  lblDescontoReais.Text      := LResult.DescontoReaisFormatado;
  DescontoPercentual         := LResult.DescontoPorcentagem;
  lblDescontoPercentual.Text := LResult.DescontoPorcentagemFomatado;

end;

procedure TFrameComponentesTecladoDesconto.BeforeDestruction;
begin
  FreeAndNil(FModelPedidoCalculoDesconto);
  inherited;
end;

procedure TFrameComponentesTecladoDesconto.CloseDesconto;
begin
  Self.Visible := False;
  DesativarTodosLayout;
end;

procedure TFrameComponentesTecladoDesconto.DesativarTodosLayout;
begin
  AtivarDesativarLayout(laySubTotal,False);
  AtivarDesativarLayout(layDescontoPercentual,False);
  AtivarDesativarLayout(layDescontoEmReais,False);
end;

function TFrameComponentesTecladoDesconto.GetSubtotal: Currency;
begin
  Result := FSubtotal - DescontoReais;
end;

procedure TFrameComponentesTecladoDesconto.lblCancelarClick(Sender: TObject);
begin
  CloseDesconto;
end;

procedure TFrameComponentesTecladoDesconto.lblConfirmarClick(Sender: TObject);
begin
  CloseDesconto;
  if Assigned(FOnClickConfirmar) then
    FOnClickConfirmar(Self);
end;

procedure TFrameComponentesTecladoDesconto.layDescontoEmReaisClick(
  Sender: TObject);
begin
  DesativarTodosLayout;
  AtivarDesativarLayout(TLayout(Sender),True);
  FLayoutAtivo := TLayoutAtivo.DescontoEmReais;
  FrameComponentesTeclado1.SetValorDigitado('0');
end;

procedure TFrameComponentesTecladoDesconto.layDescontoPercentualClick(
  Sender: TObject);
begin
  DesativarTodosLayout;
  AtivarDesativarLayout(TLayout(Sender),True);
  FLayoutAtivo := TLayoutAtivo.DescontoEmPercentual;
  FrameComponentesTeclado1.SetValorDigitado('0');
end;

procedure TFrameComponentesTecladoDesconto.laySubTotalClick(Sender: TObject);
begin
  DesativarTodosLayout;
  AtivarDesativarLayout(TLayout(Sender),True);
  FLayoutAtivo := TLayoutAtivo.Subtotal;
  FrameComponentesTeclado1.SetValorDigitado('0');
end;

procedure TFrameComponentesTecladoDesconto.OpenDesconto(const ASubtotal,AValorDesconto:Currency);
begin
  DesativarTodosLayout;
  AtivarDesativarLayout(layDescontoPercentual,True);
  FrameComponentesTeclado1.OnResize(Self);
  FLayoutAtivo               := TLayoutAtivo.DescontoEmPercentual;
  Self.Visible               := True;
  FSubtotal                  := ASubtotal;
  lblSubTotal.Text           := FormatFloat('#,##0.00',ASubtotal);
  lblDescontoReais.Text      := 'R$ 0,00';
  lblDescontoPercentual.Text := '0,00 %';

  if AValorDesconto <> 0 then
  begin
    DescontoReais              := AValorDesconto;
    lblDescontoReais.Text      := 'R$ '+FormatFloat('#,##0.00',DescontoReais);
    lblSubTotal.Text           := 'R$ '+FormatFloat('#,##0.00',(FSubtotal - DescontoReais));
    DescontoPercentual         := ((DescontoReais / FSubtotal)*100);
    lblDescontoPercentual.Text := FormatFloat('#,##0.00',DescontoPercentual)+' %';
  end;
end;

procedure TFrameComponentesTecladoDesconto.SetDescontoPercentual(
  const Value: Currency);
begin
  FDescontoPercentual := Value;
end;

procedure TFrameComponentesTecladoDesconto.SetDescontoReais(
  const Value: Currency);
begin
  FDescontoReais := Value;
end;

procedure TFrameComponentesTecladoDesconto.SetSubtoal(const Value: Currency);
begin
  FSubtotal := Value;
end;

end.
