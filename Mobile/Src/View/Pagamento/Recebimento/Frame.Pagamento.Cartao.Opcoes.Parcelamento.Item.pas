unit Frame.Pagamento.Cartao.Opcoes.Parcelamento.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts;

type
  TFramePagamentoCartaoOpcoesparcelamentoItem = class(TFrame)
    Layout1: TLayout;
    Image1: TImage;
    Label1: TLabel;
  private
    FDescricao: string;
    procedure SetDescricao(const Value: string);
    { Private declarations }
  public
    property Descricao:string read FDescricao write SetDescricao;
  end;

implementation

{$R *.fmx}

{ TFramePagamentoCartaoOpcoesparcelamentoItem }

procedure TFramePagamentoCartaoOpcoesparcelamentoItem.SetDescricao(
  const Value: string);
begin
  FDescricao := Value;
  Label1.Text := FDescricao;
end;

end.
