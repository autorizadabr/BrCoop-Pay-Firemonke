unit Frame.Pagamento.Cartao.Opcoes.Parcelamento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, System.JSON,
  Helper.Scroll, System.Generics.Collections;

type
  TFramePagamentoCartaoOpcoesParcelamento = class(TFrame)
    recBase: TRectangle;
    recPrincipal: TRectangle;
    layButtons: TLayout;
    lblCancelar: TLabel;
    layContentTecladoQuantidade: TLayout;
    layCaption: TLayout;
    lblCaption: TLabel;
    ScrollBox: TVertScrollBox;
    layClone: TLayout;
    imgCartao: TImage;
    lblDescricao: TLabel;
    procedure layCloneClick(Sender: TObject);
    procedure lblCancelarClick(Sender: TObject);
  private
    FOnClickItemOpcao: TProc<string>;
  public
    procedure CarregarOpcoes(AJsonArray:TJSONArray);
    procedure OpenCartaoOpcao;
    procedure CloseOpcaoCartao;
    property OnClickItemOpcao:TProc<string> read FOnClickItemOpcao write FOnClickItemOpcao;
  end;

implementation

{$R *.fmx}


procedure TFramePagamentoCartaoOpcoesParcelamento.CarregarOpcoes(AJsonArray: TJSONArray);
begin
  ScrollBox.ClearItems;
  if Assigned(AJsonArray) then
  begin
    var LTop:Single := 0;
    for var I := 0 to Pred(AJsonArray.Count) do
    begin
      var LObjetoItem := TJSONObject(AJsonArray[i]) as TJSONObject;
      lblDescricao.Text     := LObjetoItem.GetValue<string>('description','');
      var LLayCartao        := TLayout(layClone.Clone(ScrollBox));
      LLayCartao.Parent     := ScrollBox;
      LLayCartao.Name       := 'ItemPos'+I.ToString;
      LLayCartao.Align      := TAlignLayout.None;
      LLayCartao.Position.X := 0;
      LLayCartao.Position.Y := LTop;
      LLayCartao.TagString  := LObjetoItem.GetValue<string>('descriptionPos');
      LLayCartao.OnClick    := layCloneClick;
      LLayCartao.Visible    := True;
      LTop                  := LTop + LLayCartao.Height;
    end;
  end;
  layClone.Visible := False;end;

procedure TFramePagamentoCartaoOpcoesParcelamento.CloseOpcaoCartao;
begin
  Self.Visible := False;
end;

procedure TFramePagamentoCartaoOpcoesParcelamento.layCloneClick(
  Sender: TObject);
begin
  CloseOpcaoCartao;
  //FIdCartaoSelecionado := TLayout(Sender).TagString;
  if Assigned(FOnClickItemOpcao) then
    FOnClickItemOpcao(TLayout(Sender).TagString)
end;

procedure TFramePagamentoCartaoOpcoesParcelamento.lblCancelarClick(
  Sender: TObject);
begin
  CloseOpcaoCartao;
end;

procedure TFramePagamentoCartaoOpcoesParcelamento.OpenCartaoOpcao;
begin
  Self.Visible := True;
end;

end.
