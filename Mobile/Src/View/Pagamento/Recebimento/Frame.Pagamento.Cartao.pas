unit Frame.Pagamento.Cartao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, System.JSON,
  Helper.Scroll, System.Generics.Collections;

type
  TCartaoSelecionado = (ctCredito,ctDebito,ctValeAlimentacao,ctValeRefeicao,Nenhum);
type
  TFramePagamentoCartao = class(TFrame)
    recBase: TRectangle;
    recPrincipal: TRectangle;
    layButtons: TLayout;
    lblCancelar: TLabel;
    layContentTecladoQuantidade: TLayout;
    layValoresQuantidade: TLayout;
    lblValor: TLabel;
    layClone: TLayout;
    imgCartao: TImage;
    lblDescricao: TLabel;
    ScrollBox: TScrollBox;
    procedure layCloneClick(Sender: TObject);
    procedure lblCancelarClick(Sender: TObject);
  private
    FOnClickConfirmar: TProc<TObject>;
    FIdCartaoSelecionado:String;
    FJSonTipoPagamento:TJSONArray;
  public
    property IdCartaoSelecionado:String read FIdCartaoSelecionado;
    property OnClickConfirmar:TProc<TObject> read FOnClickConfirmar write FOnClickConfirmar;
    procedure OpenSelecionarCartao;
    procedure CloseSelecionarCartao;
    procedure CarregarDadosCartao(AJson:TJSONArray);
  end;

implementation

{$R *.fmx}

{ TFrame1 }

procedure TFramePagamentoCartao.CarregarDadosCartao(AJson: TJSONArray);
begin
  ScrollBox.ClearItems;
  FJSonTipoPagamento := AJson;
  if Assigned(AJson) then
  begin
    var LTop:Single := 0;
    for var I := 0 to Pred(AJson.Count) do
    begin
      var LCode := TJSONObject(AJson[i]).GetValue<Integer>('code',0);
      if (LCode = 3) or (LCode = 4) or (LCode = 5) then // Cartão de credito, debito e cartão da loja
      begin
        lblDescricao.Text     := TJSONObject(AJson[i]).GetValue<string>('description');
        var LLayCartao        := TLayout(layClone.Clone(ScrollBox));
        LLayCartao.Parent     := ScrollBox;
        LLayCartao.Name       := 'ItemCartao'+I.ToString;
        LLayCartao.Align      := TAlignLayout.None;
        LLayCartao.Position.X := 0;
        LLayCartao.Position.Y := LTop;
        LLayCartao.TagString  := TJSONObject(AJson[i]).GetValue<string>('id'); // Gravar o Id do objeto
        LLayCartao.OnClick    := layCloneClick;
        LLayCartao.Visible    := True;
        LTop                  := LTop + LLayCartao.Height;
      end;
    end;
  end;
  layClone.Visible := False;
end;

procedure TFramePagamentoCartao.CloseSelecionarCartao;
begin
  Self.Visible := False;
end;

procedure TFramePagamentoCartao.layCloneClick(Sender: TObject);
begin
  CloseSelecionarCartao;
  FIdCartaoSelecionado := TLayout(Sender).TagString;
  if Assigned(FOnClickConfirmar) then
    FOnClickConfirmar(Self)
end;


procedure TFramePagamentoCartao.lblCancelarClick(Sender: TObject);
begin
  CloseSelecionarCartao;
end;

procedure TFramePagamentoCartao.OpenSelecionarCartao;
begin
  Self.Visible := True;
end;

end.
