unit Frame.Resumo.Opcoes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Effects;

type
  TFrameResumoOpcoes = class(TFrame)
    recBase: TRectangle;
    recPrincipal: TRectangle;
    lblDesconto: TLabel;
    lblQuantidade: TLabel;
    lblObservacao: TLabel;
    lblDeletarItem: TLabel;
    ShadowEffect1: TShadowEffect;
    lblComanda: TLabel;
    procedure recBaseClick(Sender: TObject);
    procedure lblDescontoClick(Sender: TObject);
    procedure lblQuantidadeClick(Sender: TObject);
    procedure lblDeletarItemClick(Sender: TObject);
    procedure lblObservacaoClick(Sender: TObject);
    procedure lblComandaClick(Sender: TObject);
  private
    FOnClickDesconto: TProc<TObject>;
    FOnClickQuantidade: TProc<TObject>;
    FOnClickDeletarItem: TProc<TObject>;
    FObjetoClicado:TObject;
    FOnClickObservacao: TProc<TObject>;
    FOnClickComanda: TProc<TObject>;
    procedure CloseOpcoes;
    procedure SetOnClickComanda(const Value: TProc<TObject>);
  public
    procedure OpenOpcoes(Y:Single);
    procedure OnResizeComponente(X:Single);
    procedure SetObjetoSelecionado(Sender:TObject);
    property ObjetoSelecionado:TObject read FObjetoClicado;
    property OnClickDesconto:TProc<TObject> read FOnClickDesconto write FOnClickDesconto;
    property OnClickObservacao:TProc<TObject> read FOnClickObservacao write FOnClickObservacao;
    property OnClickQuantidade:TProc<TObject> read FOnClickQuantidade write FOnClickQuantidade;
    property OnClickDeletarItem:TProc<TObject> read FOnClickDeletarItem write FOnClickDeletarItem;
    property OnClickComanda:TProc<TObject> read FOnClickComanda write SetOnClickComanda;
  end;

implementation

{$R *.fmx}

{ TFrameResumoOpcoes }

procedure TFrameResumoOpcoes.CloseOpcoes;
begin
  Self.Visible := False;
end;

procedure TFrameResumoOpcoes.lblComandaClick(Sender: TObject);
begin
  CloseOpcoes;
  if Assigned(FOnClickComanda) then
    FOnClickComanda(Self);
end;

procedure TFrameResumoOpcoes.lblDeletarItemClick(Sender: TObject);
begin
  CloseOpcoes;
  if Assigned(FOnClickDeletarItem) then
    FOnClickDeletarItem(Self);
end;

procedure TFrameResumoOpcoes.lblDescontoClick(Sender: TObject);
begin
  CloseOpcoes;
  if Assigned(FOnClickDesconto) then
    FOnClickDesconto(Self);
end;

procedure TFrameResumoOpcoes.lblObservacaoClick(Sender: TObject);
begin
  CloseOpcoes;
  if Assigned(FOnClickObservacao) then
    FOnClickObservacao(Self);
end;

procedure TFrameResumoOpcoes.lblQuantidadeClick(Sender: TObject);
begin
  CloseOpcoes;
  if Assigned(OnClickQuantidade) then
    FOnClickQuantidade(Self)
end;

procedure TFrameResumoOpcoes.OnResizeComponente(X: Single);
begin
  if X > (Self.Width - recPrincipal.Width) then
    X :=  (Self.Width - recPrincipal.Width) - 10;
  recPrincipal.Position.X := X;
end;

procedure TFrameResumoOpcoes.OpenOpcoes(Y: Single);
begin
  Self.Visible            := True;
  FObjetoClicado          := nil;
  if Y > (Self.Height - (recPrincipal.Height + 80)) then
    Y := (Self.Height - recPrincipal.Height) - 80;
  recPrincipal.Position.Y := Y;
end;

procedure TFrameResumoOpcoes.recBaseClick(Sender: TObject);
begin
  CloseOpcoes;
end;

procedure TFrameResumoOpcoes.SetObjetoSelecionado(Sender: TObject);
begin
  FObjetoClicado := Sender;
end;
procedure TFrameResumoOpcoes.SetOnClickComanda(const Value: TProc<TObject>);
begin
  FOnClickComanda := Value;
end;

end.
