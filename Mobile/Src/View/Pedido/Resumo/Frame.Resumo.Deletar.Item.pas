unit Frame.Resumo.Deletar.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects;

type
  TFrameResumoDeletarItem = class(TFrame)
    recBase: TRectangle;
    recPrincipal: TRectangle;
    layButtons: TLayout;
    lblCancelar: TLabel;
    lblConfirmar: TLabel;
    lblNomeProduto: TLabel;
    procedure lblConfirmarClick(Sender: TObject);
    procedure lblCancelarClick(Sender: TObject);
  private
    FOnClickConfirmar: TProc<TObject>;
    procedure SetOnClickConfirmar(const Value: TProc<TObject>);
    { Private declarations }
  public
    procedure OpenDeletarItemResumo;
    procedure CloseDeletarItemResumo;
    property OnClickConfirmar:TProc<TObject> read FOnClickConfirmar write SetOnClickConfirmar;
  end;

implementation

{$R *.fmx}

{ TFrameResumoDeletarItem }

procedure TFrameResumoDeletarItem.CloseDeletarItemResumo;
begin
  Self.Visible := False;
end;

procedure TFrameResumoDeletarItem.lblCancelarClick(Sender: TObject);
begin
  CloseDeletarItemResumo;
end;

procedure TFrameResumoDeletarItem.lblConfirmarClick(Sender: TObject);
begin
  CloseDeletarItemResumo;
  if Assigned(FOnClickConfirmar) then
    FOnClickConfirmar(Self);
end;

procedure TFrameResumoDeletarItem.OpenDeletarItemResumo;
begin
  Self.Visible := True;
end;

procedure TFrameResumoDeletarItem.SetOnClickConfirmar(
  const Value: TProc<TObject>);
begin
  FOnClickConfirmar := Value;
end;

end.
