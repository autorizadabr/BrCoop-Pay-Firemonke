  unit View.Codigo.Verificacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, View.Componentes.Load, FMX.Layouts, View.Componentes.Mensagem,
  FMX.Controls.Presentation, FMX.Effects, FMX.Filter.Effects, FMX.Objects,
  FMX.Edit, View.Nova.Senha, View.Edit.Base, View.Button.Base, View.Edit.Codigo,
  View.Edit.Senha,FMX.Platform,FMX.VirtualKeyboard,FMX.Ani;


type
  TViewCodigoVerificacao = class(TViewBase)
    lblRecuperarSenha: TLabel;
    Layout1: TLayout;
    btnProsseguir: TViewButtonBase;
    Label6: TLabel;
    Label7: TLabel;
    lblEmail: TLabel;
    layEditCodico: TLayout;
    ViewEditSenha: TViewEditSenha;
    procedure btnProsseguirClick(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    FCodigoVerificacao: string;
    FEmail: string;
    FUserId:string;
    FViewNovaSenha:TViewNovaSenha;
    procedure SetCodigoVerificacao(const Value: string);
    procedure SetEmail(const Value: string);
  public
    procedure ExecuteOnShow; override;
    property CodigoVerificacao:string read FCodigoVerificacao write SetCodigoVerificacao;
    property UserId:string read FUserId write FUserId;
    property Email:string read FEmail write SetEmail;

  end;

implementation

{$R *.fmx}

{ TViewCodigoVerificacao }

procedure TViewCodigoVerificacao.btnProsseguirClick(Sender: TObject);
begin
  inherited;
  if not FCodigoVerificacao.ToLower.Equals(ViewEditSenha.CodigoVerificacao.ToLower) then
  begin
    ShowErro('Código de verificação inválido');
    Exit;
  end;
  if Assigned(FViewNovaSenha) then
    FreeAndNil(FViewNovaSenha);
  FViewNovaSenha.Email  := Email;
  FViewNovaSenha.Codigo := CodigoVerificacao;
  FViewNovaSenha.Show;
  //NextForm(Self);
end;



procedure TViewCodigoVerificacao.ExecuteOnShow;
begin
  inherited;
  ViewEditSenha.SetFocus;
  ViewEditSenha.Clear;
  ViewEditSenha.OnCloseKeyBoard :=  CloseKeyBoard;
end;

procedure TViewCodigoVerificacao.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  //TAnimator.AnimateFloat(recPrincipal,'Margins.Top',75,0.2);
end;

procedure TViewCodigoVerificacao.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  //TAnimator.AnimateFloat(recPrincipal,'Margins.Top',-150,0.2);
end;

procedure TViewCodigoVerificacao.SetCodigoVerificacao(const Value: string);
begin
  FCodigoVerificacao := Value;
end;

procedure TViewCodigoVerificacao.SetEmail(const Value: string);
begin
  FEmail := Value;
  lblEmail.Text := FEmail;
end;

end.


