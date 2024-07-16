unit View.Selecionar.Produto.Pedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,System.JSON,
  RESTRequest4D, Model.Static.Credencial, Frame.Item.Produto.Pedido,
  FMX.Effects, FMX.Filter.Effects, View.Pagamento, System.Generics.Collections;

type
  TViewSelecionarProdutoPedido = class(TViewBase)
    ScrollBox: TVertScrollBox;
    recToolbar: TRectangle;
    Label2: TLabel;
    imgVoltar: TImage;
    FillRGBEffect1: TFillRGBEffect;
    lblCategoria: TLabel;
    imgCarrinho: TImage;
    procedure imgVoltarClick(Sender: TObject);
    procedure imgCarrinhoClick(Sender: TObject);
  private
    var
    FNomeCategoriaSelecionada: string;
    FCategoriaSelecionada:string;
    FViewPagamento:TViewPagamento;
    procedure SetNomeCategoriaSelecionada(const Value: string);
    procedure OnClickItemProduto(Sender:TObject);
    procedure CarregarDadosLista(const AJsonArray:TJSONArray);
    procedure BuscarProdutos;
  public
    procedure ExecuteOnShow; override;
    property CategoriaSelecionada:string read FCategoriaSelecionada write FCategoriaSelecionada;
    property NomeCategoriaSelecionada:string read FNomeCategoriaSelecionada write SetNomeCategoriaSelecionada;
  end;

implementation
const
  LIMIT = 200;

{$R *.fmx}

{ TViewSelecionarProdutoPedido }

procedure TViewSelecionarProdutoPedido.BuscarProdutos;
begin
  OpenLoad;
  TThread.CreateAnonymousThread(
  procedure
  var
    LResponse: IResponse;
  begin
    try
      if FCategoriaSelecionada.IsEmpty then
        raise Exception.Create('Categoria não informada!');

      LResponse := TRequest.New.BaseURL(BaseURL)
        .Resource('product/category/'+FCategoriaSelecionada)
        .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
        .AddParam('limit',LIMIT.ToString)
        .Accept('application/json')
        .Get;

      TThread.Synchronize(nil,
      procedure
      begin
        CloseLoad;
        var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
        try
          // Verificando o status code
          if LResponse.StatusCode <> 200 then
          begin
            // Tratando o erro
            ShowErro(LJsonResponse.GetValue<string>('error','Erro não identificado! '+LResponse.Content));
            Exit; // Se der erro ele sai fora e não abre a próxima tela
          end;

          var LData := LJsonResponse.GetValue<TJSONArray>('data');

          CarregarDadosLista(LData);
        finally
          LJsonResponse.Free;
        end;
        CloseLoad;
      end);

    except on E: Exception do
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          ShowErro(E.Message);
        end);
      end;
    end;

  end).Start;
end;

procedure TViewSelecionarProdutoPedido.CarregarDadosLista(
  const AJsonArray: TJSONArray);
var
  Litem:TFrameItemProdutoPedido;
  I: Integer;
  LTop:Single;
  LWidth:Single;
  LLayout:TLayout;
begin
  var FCountItem := 1;
  LTop           := 0;
  LWidth         := ScrollBox.Width/3;
  for I := 0 to Pred(AJsonArray.Count) do
  begin
    Litem               := TFrameItemProdutoPedido.Create(ScrollBox);
    Litem.Parent        := ScrollBox;
    Litem.Name          := 'Produto'+I.ToString;
    Litem.Width         := LWidth;
    Litem.Height        := LWidth + 100;
    Litem.Position.Y    := LTop;
    Litem.Position.X    := 0;
    if FCountItem = 1 then
    begin

    end
    else if FCountItem = 2 then
    begin
      Litem.Position.X := LWidth;
    end
    else if FCountItem = 3 then
    begin
      LTop             := LTop + Litem.Height + 12;
      Litem.Position.X := LWidth*+2;
      FCountItem       := 0;
    end;
    Inc(FCountItem);
  end;
  LLayout            := TLayout.Create(ScrollBox);
  LLayout.Parent     := ScrollBox;
  LLayout.Width      := ScrollBox.Width;
  LLayout.Height     := 40;
  LLayout.Position.X := 0;
  LLayout.Position.Y := LTop;
end;

procedure TViewSelecionarProdutoPedido.ExecuteOnShow;
begin
  inherited;
  BuscarProdutos;
end;

procedure TViewSelecionarProdutoPedido.imgCarrinhoClick(Sender: TObject);
begin
  inherited;
  if Assigned(FViewPagamento) then
    FreeAndNil(FViewPagamento);
  FViewPagamento := TViewPagamento.Create(Self);
  FViewPagamento.Show;
end;

procedure TViewSelecionarProdutoPedido.imgVoltarClick(Sender: TObject);
begin
  inherited;
  CLose;
end;

procedure TViewSelecionarProdutoPedido.OnClickItemProduto(Sender: TObject);
begin

end;

procedure TViewSelecionarProdutoPedido.SetNomeCategoriaSelecionada(
  const Value: string);
begin
  FNomeCategoriaSelecionada := Value;
  lblCategoria.Text := FNomeCategoriaSelecionada;
end;



end.
