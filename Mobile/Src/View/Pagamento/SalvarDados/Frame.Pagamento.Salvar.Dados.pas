unit Frame.Pagamento.Salvar.Dados;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects;

type
  TFramePagamentosSalvarDados = class(TFrame)
    recBase: TRectangle;
    recBaseModalDelete: TRectangle;
    layTitleModalDelete: TLayout;
    imgCloseModal: TImage;
    layContentTitleModalDelete: TLayout;
    lblDescricaoModalDelete: TLabel;
    layContentButtonsModalDelete: TLayout;
    lblBaseDeletar: TLabel;
    lblBaseCancelar: TLabel;
    procedure lblBaseCancelarClick(Sender: TObject);
    procedure lblBaseDeletarClick(Sender: TObject);
    procedure imgCloseModalClick(Sender: TObject);
  private
    FOnClickConfirmar: TProc<TObject>;
    FOnClickCancelar: TProc<TObject>;
    FPodeFecharATela:Boolean;
  public
    procedure OpenSalvarDados;
    procedure CloseSalvarDados;
    property OnClickConfirmar:TProc<TObject> read FOnClickConfirmar write FOnClickConfirmar;
    property OnClickCancelar:TProc<TObject> read FOnClickCancelar write FOnClickCancelar;
    function PodeFecharATela:Boolean;
  end;

implementation

{$R *.fmx}

{ TFramePagamentosSalvarDados }

procedure TFramePagamentosSalvarDados.CloseSalvarDados;
begin
  Self.Visible := False;
end;

procedure TFramePagamentosSalvarDados.imgCloseModalClick(Sender: TObject);
begin
  CloseSalvarDados;
end;

procedure TFramePagamentosSalvarDados.lblBaseCancelarClick(Sender: TObject);
begin
  CloseSalvarDados;
  if Assigned(FOnClickCancelar) then
  begin
    FPodeFecharATela := True;
    FOnClickCancelar(Self);
  end;
end;

procedure TFramePagamentosSalvarDados.lblBaseDeletarClick(Sender: TObject);
begin
  CloseSalvarDados;
  if Assigned(FOnClickConfirmar) then
    FOnClickConfirmar(Self);
end;

procedure TFramePagamentosSalvarDados.OpenSalvarDados;
begin
  FPodeFecharATela := False;
  Self.Visible := True;
end;

function TFramePagamentosSalvarDados.PodeFecharATela: Boolean;
begin
  Result := FPodeFecharATela;
end;

end.
