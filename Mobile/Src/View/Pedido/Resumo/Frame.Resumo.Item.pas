unit Frame.Resumo.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, FMX.Memo.Types,
  FMX.ScrollBox, Model.Pedido.Dados.Item, FMX.Memo, Constantes.Color,
  Model.Static.Usuario, System.JSON, System.Generics.Collections;

type
  TFrameResumoItem = class(TFrame)
    lblNomeProduto: TLabel;
    lblValor: TLabel;
    layContent: TLayout;
    lblValorUnitario: TLabel;
    lblDesconto: TLabel;
    layObservacao: TLayout;
    Layout1: TLayout;
    Circle: TCircle;
    layVendedor: TLayout;
    lblNomeVendedor: TLabel;
    imgIconeVendedor: TImage;
    layComanda: TLayout;
    lblComada: TLabel;
    Image1: TImage;
    Line1: TLine;
    procedure FrameClick(Sender: TObject);
    procedure FrameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    FValorUnitatio: Currency;
    FQuantidade: Integer;
    FNomeProduto: string;
    FOnClickItem: TProc<TObject>;
    FOnResizeComponente: TProc<Single>;
    FIdProduto: String;
    FIdSequencial: Integer;
    FValorDesconto:Currency;
    FPercentualDesconto:Currency;
    FDadosProdutoItem:TDadosProdutoItem;
    FObservacao:TArray<String>;
    FItemJaEstaNaApi: Boolean;
    FUserId: string;
    FDescricao: string;
    FComanda: Integer;
    procedure SetNomeProduto(const Value: string);
    procedure SetQuantidade(const Value: Integer);
    procedure SetValorUnitatio(const Value: Currency);
    procedure SetOnClickItem(const Value: TProc<TObject>);
    procedure SetOnResizeComponente(const Value: TProc<Single>);
    procedure SetItemJaEstaNaApi(const Avalue: Boolean);
    procedure SetUserId(const Value: string);
    procedure SetComanda(const Value: Integer);
    procedure SetDescricao(const Value: string);
  public
    // Criar e Destruir
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    // Criar e Destruir
    property IdSequencial:Integer read FIdSequencial write FIdSequencial;
    property IdProduto:string read FIdProduto write FIdProduto;
    property Quantidade:Integer read FQuantidade write SetQuantidade;
    property NomeProduto:string read FNomeProduto write SetNomeProduto;
    property ValorUnitatio:Currency read FValorUnitatio write SetValorUnitatio;
    property ItemJaEstaNaApi:Boolean read FItemJaEstaNaApi write SetItemJaEstaNaApi;
    property UserId:string read FUserId write SetUserId;
    property Comanda:Integer read FComanda write SetComanda;
    property Descricao:string read FDescricao write SetDescricao;
    // Eventos
    property OnClickItem:TProc<TObject> read FOnClickItem write SetOnClickItem;
    property OnResizeComponente:TProc<Single> read FOnResizeComponente write SetOnResizeComponente;
    // Eventos
    procedure SetValorDesconto(const Avalue:Currency);
    procedure SetPercentualDesconto(const Avalue:Currency);
    procedure SetObservacao(AObservacao:TArray<String>);
    procedure MontarFrame;
    function Observacao:TArray<string>;
    function ValorDesconto:Currency;
    function PercentualDesconto:Currency;
    function DadosProdutoItem:TDadosProdutoItem;
  end;

implementation

{$R *.fmx}

{ TFrameResumoItem }

procedure TFrameResumoItem.AfterConstruction;
begin
  inherited;
  Circle.Fill.Color   := MESA_COMANDA_OCUPADA;
  FPercentualDesconto := 0;
  FValorDesconto      := 0;
  FValorUnitatio      := 0;
  SetLength(FObservacao,0);
end;


procedure TFrameResumoItem.BeforeDestruction;
begin
  inherited;
end;

function TFrameResumoItem.DadosProdutoItem: TDadosProdutoItem;
begin
  Result := FDadosProdutoItem;
end;

procedure TFrameResumoItem.FrameClick(Sender: TObject);
begin
  if Assigned(FOnClickItem) then
    FOnClickItem(Self);
end;

procedure TFrameResumoItem.FrameMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  if Assigned(FOnResizeComponente) then
    FOnResizeComponente(X);
end;

procedure TFrameResumoItem.MontarFrame;
begin
  lblValorUnitario.Text := FQuantidade.ToString + ' UN '+FValorUnitatio.ToString;
  lblValor.Text         := Currency((FValorUnitatio * Quantidade)- FValorDesconto).ToString;
  lblDesconto.Text      := 'Desc.('+FormatFloat('#,##0.00',FPercentualDesconto)+'%)';
  lblDesconto.Visible   := FPercentualDesconto <> 0;
  Self.Height           := 42;
  if  Length(FObservacao) > 0 then
  begin
    for var I := Pred(layObservacao.ControlsCount) downto 0 do
    begin
      if layObservacao.Controls[i] is TText then
      begin
        TText(layObservacao.Controls[i]).Free;
      end;
    end;

    for var X := Low(FObservacao) to High(FObservacao) do
    begin
      var LText                    := TText.Create(layObservacao);
      LText.Parent                 := layObservacao;
      LText.Name                   := 'ItemObs'+X.ToString;
      LText.Align                  := TAlignLayout.Top;
      LText.Margins.Left           := 28;
      LText.Height                 := 17;
      LText.HitTest                := False;
      LText.TextSettings.HorzAlign := TTextAlign.Leading;
      LText.TextSettings.FontColor := $FF686868;
      if X = 0 then
        LText.Text                   :='*'+FObservacao[X]
      else
        LText.Text                   := FObservacao[X]
    end;
    Self.Height        := Self.Height + (18 * Length(FObservacao));

  end;
  layVendedor.Height := 0;
  if not FUserId.IsEmpty then
  begin
    layVendedor.Height := 17;
    Self.Height :=  Self.Height + layVendedor.Height;

    var LJsonArrayUsuario := TModelStaticUsuario.JSONArrayUsuarios;
    for var I := 0 to Pred(LJsonArrayUsuario.Count) do
    begin
      var LJsonObjetoItem := LJsonArrayUsuario.Items[I] as TJSONObject;
      if LJsonObjetoItem.GetValue<string>('id','').Equals(FUserId) then
      begin
        lblNomeVendedor.Text := LJsonObjetoItem.GetValue<string>('name','');
        Break;
      end;
    end;
  end;
  layComanda.Height := 0;
  if FComanda > 0 then
  begin
    layComanda.Height := 17;
    Self.Height :=  Self.Height + layComanda.Height;
    if FDescricao.IsEmpty then
      lblComada.Text := Format('Comanda: %s',[FComanda.ToString])
    else
      lblComada.Text := Format('Comanda: %s | %s',[FComanda.ToString,FDescricao])
  end;
end;

function TFrameResumoItem.Observacao: TArray<string>;
begin
  Result := FObservacao;
end;

function TFrameResumoItem.PercentualDesconto: Currency;
begin
  Result := FPercentualDesconto;
end;

procedure TFrameResumoItem.SetComanda(const Value: Integer);
begin
  FComanda := Value;
end;

procedure TFrameResumoItem.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TFrameResumoItem.SetItemJaEstaNaApi(const Avalue: Boolean);
begin
  FItemJaEstaNaApi := Avalue;
  if FItemJaEstaNaApi then
    Circle.Fill.Color := MESA_COMANDA_LIVRE;
end;

procedure TFrameResumoItem.SetNomeProduto(const Value: string);
begin
  FNomeProduto        := Value;
  lblNomeProduto.Text := FNomeProduto;
end;

procedure TFrameResumoItem.SetObservacao(AObservacao:TArray<String>);
begin
  FObservacao := AObservacao;
end;

procedure TFrameResumoItem.SetOnClickItem(const Value: TProc<TObject>);
begin
  FOnClickItem := Value;
end;

procedure TFrameResumoItem.SetOnResizeComponente(const Value: TProc<Single>);
begin
  FOnResizeComponente := Value;
end;

procedure TFrameResumoItem.SetPercentualDesconto(const Avalue: Currency);
begin
  FPercentualDesconto := Avalue;
end;

procedure TFrameResumoItem.SetQuantidade(const Value: Integer);
begin
  FQuantidade := Value;

end;

procedure TFrameResumoItem.SetUserId(const Value: string);
begin
  FUserId := Value;
end;

procedure TFrameResumoItem.SetValorDesconto(const Avalue: Currency);
begin
  FValorDesconto := Avalue;
end;

procedure TFrameResumoItem.SetValorUnitatio(const Value: Currency);
begin
  FValorUnitatio := Value;
end;

function TFrameResumoItem.ValorDesconto: Currency;
begin
  Result := FValorDesconto;
end;

end.
