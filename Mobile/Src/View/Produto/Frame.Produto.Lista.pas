unit Frame.Produto.Lista;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, Helper.Circle;

type
  TFrameProdutoLista = class(TFrame)
    recBase: TRectangle;
    Circle: TCircle;
    lblDescricao: TLabel;
  private
    FOnClickItem: TProc<TObject>;
    FDescricao: String;
    FId: String;
    procedure SetDescricao(const Value: String);
  public
    property OnClickItem:TProc<TObject> read FOnClickItem write FOnClickItem;
    property Id:String read FId write FId;
    property Descricao:String read FDescricao write SetDescricao;
    procedure LoadImage(const AURL:string);
  end;

implementation

{$R *.fmx}


{ TFrameProdutoLista }

procedure TFrameProdutoLista.LoadImage(const AURL: string);
begin
  Circle.LoadFromURLAsync(AURL);
end;

procedure TFrameProdutoLista.SetDescricao(const Value: String);
begin
  FDescricao        := Value;
  lblDescricao.Text := FDescricao;
end;

end.
