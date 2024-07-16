unit Frame.Pagamento.Vendedor.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

type
  TFramePagamentoVendedorItem = class(TFrame)
    CircleInicial: TCircle;
    lblNome: TLabel;
    lblInicial: TLabel;
    Line: TLine;
    procedure FrameClick(Sender: TObject);
    procedure FrameTap(Sender: TObject; const Point: TPointF);
  private
    FNome: string;
    FId: string;
    FOnClickItem: TProc<TObject>;
    procedure SetNome(const Value: string);
  public
    property Id:string read FId write FId;
    property Nome:string read FNome write SetNome;
    property OnClickItem:TProc<TObject> read FOnClickItem write FOnClickItem;
  end;

implementation

{$R *.fmx}

{ TFramePagamentoVendedorItem }


procedure TFramePagamentoVendedorItem.FrameClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if Assigned(FOnClickItem) then
    FOnClickItem(Self)
  {$ENDIF}
end;

procedure TFramePagamentoVendedorItem.FrameTap(Sender: TObject;
  const Point: TPointF);
begin
  if Assigned(FOnClickItem) then
    FOnClickItem(Self)
end;

procedure TFramePagamentoVendedorItem.SetNome(const Value: string);
begin
  FNome := Value;
  lblNome.Text := FNome;
  lblInicial.Text := Copy(FNome,1,1);
end;

end.
