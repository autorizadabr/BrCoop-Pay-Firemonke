unit View.Componentes.Teclado.ValorUnitario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Componentes.Teclado, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects,
  Model.Utils;

type
  TFrameComponentesTecladoValorUnitario = class(TFrame)
    recBase: TRectangle;
    recPrincipal: TRectangle;
    Layout1: TLayout;
    Label4: TLabel;
    Layout2: TLayout;
    lblValorUnitarioProduto: TLabel;
    Layout3: TLayout;
    Label5: TLabel;
    Label6: TLabel;
    FrameComponentesTeclado1: TFrameComponentesTeclado;
    lblNomeProduto: TLabel;
    lblValor: TLabel;
    lblValorUnitario: TLabel;
    procedure FrameResize(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
  private
    FQuantidade:Integer;
    FOnClickConfirmar: TProc<TObject,TObject>;
    FObjectSelecionado:TObject;
    procedure SetOnClickConfirmar(const Value: TProc<TObject,TObject>);
    procedure AtualizarValorUnitario(AValue:string);
  public
    procedure SetObjetoSelecionado(AValue:TObject);
    procedure SetQuantidade(AValue:Integer);
    procedure SetNomeProduto(AValue:string);
    procedure OpenValorUnitario;
    procedure CloseValorUnitario;
    procedure AfterConstruction; override;
    function Quantidade:Integer;
    function ValorUnitario:Currency;
    property OnClickConfirmar:TProc<TObject,TObject> read FOnClickConfirmar write SetOnClickConfirmar;

  end;

implementation

{$R *.fmx}

{ TFrame1 }

procedure TFrameComponentesTecladoValorUnitario.AfterConstruction;
begin
  inherited;
  FrameComponentesTeclado1.AtualizarValorDigitado := AtualizarValorUnitario;
  CloseValorUnitario;
end;

procedure TFrameComponentesTecladoValorUnitario.AtualizarValorUnitario(AValue:string);
begin
  var LValue := AValue;
  if StrToCurrDef(LValue,0) < 0 then
    LValue := '0';

  var LValueFormat := TModelUtils.FormatCurrencyValue(LValue);
  var LValueResult := LValueFormat.Replace('.', '', [rfReplaceAll]);

  var LValorUnitario           := StrToCurrDef(LValueResult, 0.1);
  lblValorUnitarioProduto.Text := TModelUtils.FormatCurrencyValue(LValue); //FormatFloat('#,##0.00',LValorUnitario);

  var LValorTotal:Currency     := (LValorUnitario * FQuantidade);
  lblValor.Text                := FormatFloat('#,##0.00',LValorTotal);
  lblValorUnitario.Text        := FQuantidade.ToString + ' UN X '+lblValorUnitarioProduto.Text;
  FrameComponentesTeclado1.SetValorDigitado(LValue);
end;

procedure TFrameComponentesTecladoValorUnitario.CloseValorUnitario;
begin
  Self.Visible       := False;
  FQuantidade        := 1;
  FObjectSelecionado := nil;

end;

procedure TFrameComponentesTecladoValorUnitario.FrameResize(Sender: TObject);
begin
  FrameComponentesTeclado1.OnResize(Self);
end;

procedure TFrameComponentesTecladoValorUnitario.Label5Click(Sender: TObject);
begin
  CloseValorUnitario;
end;

procedure TFrameComponentesTecladoValorUnitario.Label6Click(Sender: TObject);
begin
  if ValorUnitario <= 0  then
    raise Exception.Create('Valor unitário deve ser maior ou igual a um centavo.');
  if Assigned(FOnClickConfirmar) then
    FOnClickConfirmar(Self,FObjectSelecionado);
  CloseValorUnitario;
end;

procedure TFrameComponentesTecladoValorUnitario.OpenValorUnitario;
begin
  Self.Visible       := True;
  AtualizarValorUnitario('0');
end;

function TFrameComponentesTecladoValorUnitario.Quantidade: Integer;
begin
  Result := FQuantidade;
end;

procedure TFrameComponentesTecladoValorUnitario.SetNomeProduto(AValue: string);
begin
  lblNomeProduto.Text := AValue;
end;

procedure TFrameComponentesTecladoValorUnitario.SetObjetoSelecionado(
  AValue: TObject);
begin
  FObjectSelecionado := AValue;
end;

procedure TFrameComponentesTecladoValorUnitario.SetOnClickConfirmar(const Value: TProc<TObject,TObject>);
begin
  FOnClickConfirmar := Value;
end;

procedure TFrameComponentesTecladoValorUnitario.SetQuantidade(AValue: Integer);
begin
  FQuantidade := AValue;
  lblValorUnitario.Text := Avalue.ToString + ' UN X '+lblValorUnitarioProduto.Text;
end;

function TFrameComponentesTecladoValorUnitario.ValorUnitario: Currency;
begin
  var LValueResult := lblValorUnitarioProduto.Text.Replace('.', '', [rfReplaceAll]);
  Result := StrToCurrDef(LValueResult, 0);
end;

end.
