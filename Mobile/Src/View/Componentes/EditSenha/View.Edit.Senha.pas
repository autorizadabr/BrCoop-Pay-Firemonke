unit View.Edit.Senha;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Edit.Codigo, FMX.Layouts, FMX.Controls.Presentation, FMX.Edit,
  Model.Utils,FMX.Platform,FMX.VirtualKeyboard;

type
  TViewEditSenha = class(TFrame)
    layEditCodico: TLayout;
    EdtCodigo1: TViewEditCodigo;
    EdtCodigo5: TViewEditCodigo;
    EdtCodigo3: TViewEditCodigo;
    EdtCodigo2: TViewEditCodigo;
    EdtCodigo6: TViewEditCodigo;
    EdtCodigo4: TViewEditCodigo;
    Edit1: TEdit;
    procedure FrameResize(Sender: TObject);
    procedure Edit1ChangeTracking(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure EdtCodigo1Click(Sender: TObject);
  private
    FPosicaoAtual:Integer;
    FOnCloseKeyBoard: TProc;
    procedure SetFocusEdit(Sender: TObject);
    procedure SetEventCodigo();
    procedure SetOnCloseKeyBoard(const Value: TProc);
  protected
    procedure Loaded; override;
  public
    procedure AfterConstruction; override;
    function CodigoVerificacao: string;
    procedure SetFocus;
    procedure Clear;
    property OnCloseKeyBoard: TProc read FOnCloseKeyBoard
      write SetOnCloseKeyBoard;
  end;

implementation

{$R *.fmx}

procedure TViewEditSenha.AfterConstruction;
begin
  inherited;
  Edit1.Visible := True;
  SetEventCodigo;
end;

procedure TViewEditSenha.Clear;
begin
  EdtCodigo1.Clear;
  EdtCodigo2.Clear;
  EdtCodigo3.Clear;
  EdtCodigo4.Clear;
  EdtCodigo5.Clear;
  EdtCodigo6.Clear;
end;

function TViewEditSenha.CodigoVerificacao: string;
begin
  Result := Edit1.Text;
end;

procedure TViewEditSenha.Edit1ChangeTracking(Sender: TObject);
begin
  Edit1.Text := TModelUtils.ExtractNumber(Copy(Edit1.Text,1,6));
  EdtCodigo1.Codigo := StrToIntDef(Copy(Edit1.Text,1,1),-1);
  EdtCodigo2.Codigo := StrToIntDef(Copy(Edit1.Text,2,1),-1);
  EdtCodigo3.Codigo := StrToIntDef(Copy(Edit1.Text,3,1),-1);
  EdtCodigo4.Codigo := StrToIntDef(Copy(Edit1.Text,4,1),-1);
  EdtCodigo5.Codigo := StrToIntDef(Copy(Edit1.Text,5,1),-1);
  EdtCodigo6.Codigo := StrToIntDef(Copy(Edit1.Text,6,1),-1);
  if Length(Edit1.Text) = 6 then
    if Assigned(FOnCloseKeyBoard) then
      FOnCloseKeyBoard();
end;

procedure TViewEditSenha.Edit1KeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkBack then
  begin

    Key := 0;
  end
  else
  begin
    Edit1.Text := TModelUtils.ExtractNumber(Edit1.Text);
    Edit1.SelStart := Length(Edit1.Text);
  end;
end;

procedure TViewEditSenha.EdtCodigo1Click(Sender: TObject);
begin
  FPosicaoAtual := TFrame(Sender).Tag;
end;

procedure TViewEditSenha.FrameResize(Sender: TObject);
begin
  var LWidth := layEditCodico.Width - 25;
  LWidth := (LWidth/6);
  for var i := 0 to Pred(layEditCodico.ControlsCount) do
  begin
    if layEditCodico.Controls[i] is TViewEditCodigo then
    begin
      TViewEditCodigo(layEditCodico.Controls[i]).Width := LWidth;
    end;
  end;
  Edit1.Position.X := Self.Width+1000;
end;


procedure TViewEditSenha.Loaded;
begin
  inherited;
  Self.Resize;
end;

procedure TViewEditSenha.SetEventCodigo;
begin
  for var i := 0 to Pred(layEditCodico.ControlsCount) do
  begin
    if layEditCodico.Controls[i] is TFrame then
    begin
      TFrame(layEditCodico.Controls[i]).OnClick := Self.SetFocusEdit;
    end;
  end;
end;

procedure TViewEditSenha.SetFocus;
begin
  TThread.Synchronize(nil,
  procedure
  begin
    Edit1.SetFocus;
    Edit1.CaretPosition := Length(Edit1.Text);
    {$IFNDEF MSWINDOWS}
    if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService) then
    begin
      (TPlatformServices.Current.GetPlatformService(IFMXVirtualKeyboardService) as IFMXVirtualKeyboardService).ShowVirtualKeyboard(Edit1);
    end;
    {$ENDIF}
  end);
end;

procedure TViewEditSenha.SetFocusEdit(Sender: TObject);
begin
  SetFocus;
end;
procedure TViewEditSenha.SetOnCloseKeyBoard(const Value: TProc);
begin
  FOnCloseKeyBoard := Value;
end;

end.

