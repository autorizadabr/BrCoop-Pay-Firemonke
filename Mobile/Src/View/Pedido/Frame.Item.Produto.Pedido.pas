unit Frame.Item.Produto.Pedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, Helper.Image, System.JSON,
  Model.Records.Regra.Fiscal;

type
  TFrameItemProdutoPedido = class(TFrame)
    layPrincipal: TLayout;
    recBase: TRectangle;
    imgProduto: TImage;
    lblDescricao: TLabel;
    Layout1: TLayout;
    lblValor: TLabel;
    recQuantidade: TRoundRect;
    lblQuantidade: TLabel;
    procedure FrameClick(Sender: TObject);
    procedure FrameTap(Sender: TObject; const Point: TPointF);
  private
  var
    FOnClickItem: TProc<TObject>;
    FDescricao: string;
    FImagemUrl: string;
    FJSONObjectString:String;
    FCategoria:string;
    FId: string;
    FQuantidade:Integer;
    FValorUnitatio:Currency;
    FPodeReceberValorUnitario:Boolean;
    FRegraFiscal:TModelRegraFiscal;
    FPrecoLivre:Boolean;
    procedure SetOnClickItem(const Value: TProc<TObject>);
    procedure SetDescricao(const Value: string);
    procedure SetImagemUrl(const Value: string);
    procedure SetCategoria(const Value: string);
    procedure SetQuantidade(const Value: Integer);
    property Quantidade:Integer read FQuantidade write SetQuantidade;
  public
    property Id:string read FId;
    property Descricao:string read FDescricao write SetDescricao;
    property ImagemUrl:string read FImagemUrl write SetImagemUrl;
    property Categoria:string read FCategoria write SetCategoria;
    property OnClickItem:TProc<TObject> read FOnClickItem write SetOnClickItem;
    procedure AfterConstruction; override;
    procedure SetJSONObjectString(const AJsonString:string);
    procedure LoadJSONObject(const AJson:TJSONObject);
    function QuantidadeSelecionada:Integer;
    function ValorTotalSelecionado:Currency;
    function ValorUnitario:Currency;
    function PrecoLivre: Boolean;
    function RegraFiscal:TModelRegraFiscal;
    procedure AdicionarQuantidade(const AValue:Integer);
    procedure SetValorUnitario(const AValue:Currency);
    procedure ZerarQuantidade;
  end;

implementation
  const
    IMAGE_COLOR = $FFF3F5F7;

{$R *.fmx}

{ TFrameItemProdutoPedido }


procedure TFrameItemProdutoPedido.AdicionarQuantidade(const AValue:Integer);
begin
  Quantidade := Quantidade + AValue;
end;

procedure TFrameItemProdutoPedido.AfterConstruction;
begin
  inherited;
  recQuantidade.Visible     := False;
  FQuantidade               := 0;
  FValorUnitatio            := 0;
  FPodeReceberValorUnitario := False;
end;

procedure TFrameItemProdutoPedido.FrameClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  if Assigned(FOnClickItem) then
    FOnClickItem(Self);
  {$ENDIF}
end;

procedure TFrameItemProdutoPedido.FrameTap(Sender: TObject;
  const Point: TPointF);
begin
  if Assigned(FOnClickItem) then
    FOnClickItem(Self);
end;

procedure TFrameItemProdutoPedido.LoadJSONObject(const AJson: TJSONObject);
begin
  if Assigned(AJson) then
  begin
    FId       := AJson.GetValue<String>('id','');
    Descricao := AJson.GetValue<String>('description','');
    imgProduto.LoadFromURLAsync(AJson.GetValue<String>('image',''));
    FValorUnitatio := AJson.GetValue<Currency>('salePrice',0);
    lblValor.Text  := 'R$ '+FormatFloat('#,##0.00',FValorUnitatio);
    if FValorUnitatio <= 0 then
      FPodeReceberValorUnitario := True;
   FPrecoLivre := AJson.GetValue<Boolean>('changePrice',False);
   FRegraFiscal.Clear;
   var LRegraFiscal := AJson.GetValue<TJSONObject>('taxModel',nil);
   if Assigned(LRegraFiscal) then
   begin
     FRegraFiscal.Clear;
     FRegraFiscal.Id          := LRegraFiscal.GetValue<string>('id','');
     FRegraFiscal.Origin      := LRegraFiscal.GetValue<string>('origin','');
     FRegraFiscal.CsosnCst    := LRegraFiscal.GetValue<string>('csosnCst','');
     FRegraFiscal.CstPis      := LRegraFiscal.GetValue<string>('cstPis','');
     FRegraFiscal.PPis        := LRegraFiscal.GetValue<string>('ppis','');
     FRegraFiscal.CstCofins   := LRegraFiscal.GetValue<string>('cstCofins','');
     FRegraFiscal.PCofins     := LRegraFiscal.GetValue<string>('pcofins','');
     FRegraFiscal.CfopInterno := LRegraFiscal.GetValue<string>('internalCfop','');
     FRegraFiscal.CfopExterno := LRegraFiscal.GetValue<string>('externalCfop','');
   end;

  end;
end;


function TFrameItemProdutoPedido.PrecoLivre: Boolean;
begin
  Result := FPrecoLivre;
end;

function TFrameItemProdutoPedido.QuantidadeSelecionada: Integer;
begin
  Result := FQuantidade;
end;

function TFrameItemProdutoPedido.RegraFiscal: TModelRegraFiscal;
begin
  Result := FRegraFiscal;
end;

procedure TFrameItemProdutoPedido.SetCategoria(const Value: string);
begin
  FCategoria := Value;
end;

procedure TFrameItemProdutoPedido.SetDescricao(const Value: string);
begin
  FDescricao := Value;
  lblDescricao.Text := FDescricao;
end;


procedure TFrameItemProdutoPedido.SetImagemUrl(const Value: string);
begin
  FImagemUrl := Value;
  imgProduto.LoadFromURLAsync(FImagemUrl);
end;

procedure TFrameItemProdutoPedido.SetJSONObjectString(
  const AJsonString: string);
begin
  FJSONObjectString := AJsonString;
end;

procedure TFrameItemProdutoPedido.SetOnClickItem(const Value: TProc<TObject>);
begin
  FOnClickItem := Value;
end;

procedure TFrameItemProdutoPedido.SetQuantidade(const Value: Integer);
begin
  FQuantidade           := Value;
  lblQuantidade.Text    := FQuantidade.ToString;
  recQuantidade.Visible := FQuantidade > 0;
end;

procedure TFrameItemProdutoPedido.SetValorUnitario(const AValue: Currency);
begin
  // Sempre o valor Original, somente quando alterar quando o produto for preço livre
  if FPrecoLivre then
  begin
    FValorUnitatio := AValue;
  end;
end;

function TFrameItemProdutoPedido.ValorTotalSelecionado: Currency;
begin
  Result := FValorUnitatio * FQuantidade;
end;

function TFrameItemProdutoPedido.ValorUnitario: Currency;
begin
  Result := FValorUnitatio;
end;

procedure TFrameItemProdutoPedido.ZerarQuantidade;
begin
  Quantidade := 0;
end;

end.
