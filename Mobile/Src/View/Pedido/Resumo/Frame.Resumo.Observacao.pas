unit Frame.Resumo.Observacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Componentes.Teclado, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TFrameResumoObservacao = class(TFrame)
    recBase: TRectangle;
    recPrincipal: TRectangle;
    layButtons: TLayout;
    lblCancelar: TLabel;
    lblConfirmar: TLabel;
    lblNomeProduto: TLabel;
    MemoObservacao: TMemo;
    RecContentObs: TRectangle;
    procedure lblCancelarClick(Sender: TObject);
    procedure lblConfirmarClick(Sender: TObject);
  private
    FObservacao: string;
    FOnClickConfirmar: TProc<TObject>;
    procedure SetOnClickConfirmar(const Value: TProc<TObject>);
  public
    procedure AfterConstruction; override;
    procedure SetObservacao(AObservacao:TArray<string>);
    function Observacao:TArray<String>;
    property OnClickConfirmar:TProc<TObject> read FOnClickConfirmar write SetOnClickConfirmar;
    procedure OpenObservacao;
    procedure CloseObservacao;
  end;

implementation

{$R *.fmx}

{ TFrameResumoObservacao }

procedure TFrameResumoObservacao.AfterConstruction;
begin
  inherited;
  SetLength(FObservacao,0);
end;

procedure TFrameResumoObservacao.CloseObservacao;
begin
  Self.Visible := False;
end;

procedure TFrameResumoObservacao.lblCancelarClick(Sender: TObject);
begin
  CloseObservacao;
end;

procedure TFrameResumoObservacao.lblConfirmarClick(Sender: TObject);
begin
  CloseObservacao;
  if Assigned(FOnClickConfirmar) then
    FOnClickConfirmar(Self);
end;

function TFrameResumoObservacao.Observacao: TArray<String>;
begin
  SetLength(Result, MemoObservacao.Lines.Count);
  for var I := 0 to Pred(MemoObservacao.Lines.Count) do
  begin
    Result[I] := MemoObservacao.Lines[I];
  end;
end;

procedure TFrameResumoObservacao.OpenObservacao;
begin
  Self.Visible := True;
  MemoObservacao.SetFocus;
end;

procedure TFrameResumoObservacao.SetObservacao(AObservacao:TArray<string>);
begin
  MemoObservacao.Lines.Clear;
  for var I := Low(AObservacao) to High(AObservacao) do
  begin
    MemoObservacao.Lines.Add(AObservacao[I]);
  end;
end;

procedure TFrameResumoObservacao.SetOnClickConfirmar(
  const Value: TProc<TObject>);
begin
  FOnClickConfirmar := Value;
end;

end.
