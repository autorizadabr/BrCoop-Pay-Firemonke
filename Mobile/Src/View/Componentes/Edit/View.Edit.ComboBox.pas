unit View.Edit.ComboBox;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Edit.Base, FMX.Controls.Presentation, FMX.Edit, FMX.Objects;

type
  TViewEditComboBox = class(TViewEditBase)
    imgOpenClose: TImage;
    procedure imgOpenCloseTap(Sender: TObject; const Point: TPointF);
    procedure imgOpenCloseClick(Sender: TObject);
    procedure FrameClick(Sender: TObject);
    procedure FrameTap(Sender: TObject; const Point: TPointF);
  private
    FCodigo:Integer;
    FOpenCloseModal: TProc;
    FBeforeOpenModal: TProc;
    procedure SetOpenCloseModal(const Value: TProc);
    procedure SetBeforeOpenModal(const Value: TProc);
  public

  procedure SetCodigo(ACodigo:Integer);
  procedure SetDescription(ADescription:string);
  function Codigo:Integer;
  function Description:string;
  procedure Clear;
  procedure AfterConstruction; override;
  property BeforeOpenModal:TProc read FBeforeOpenModal write SetBeforeOpenModal;
  property OpenCloseModal:TProc read FOpenCloseModal write SetOpenCloseModal;
  procedure ReadOnlyComboBox(ABool:Boolean);
  end;

var
  ViewEditComboBox: TViewEditComboBox;

implementation

{$R *.fmx}

{ TViewEditComboBox }

procedure TViewEditComboBox.AfterConstruction;
begin
  Self.HitTest := True;
  Edit.HitTest := False;
  inherited;
  {$IFDEF IOS}
  Edit.StyleLookup := 'transparentedit';
  {$ENDIF}
end;

procedure TViewEditComboBox.Clear;
begin
  FCodigo := 0;
  Edit.Text := EmptyStr;
end;

function TViewEditComboBox.Codigo: Integer;
begin
  Result := FCodigo;
end;

function TViewEditComboBox.Description: string;
begin
  Result := Edit.Text;
end;

procedure TViewEditComboBox.FrameClick(Sender: TObject);
begin
  inherited;
  imgOpenCloseClick(Sender);
end;

procedure TViewEditComboBox.FrameTap(Sender: TObject; const Point: TPointF);
begin
  inherited;
  imgOpenCloseTap(Sender,Point);
end;

procedure TViewEditComboBox.imgOpenCloseClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  imgOpenCloseTap(Sender,TPointF.Create(0,0));
  {$ENDIF}
end;

procedure TViewEditComboBox.imgOpenCloseTap(Sender: TObject;
  const Point: TPointF);
begin
  if Assigned(FBeforeOpenModal) then
    FBeforeOpenModal();
  if Assigned(FOpenCloseModal) then
    FOpenCloseModal
end;

procedure TViewEditComboBox.ReadOnlyComboBox(ABool: Boolean);
begin
  Self.Enabled := ABool;
  Self.imgOpenClose.Enabled := ABool;
end;

procedure TViewEditComboBox.SetBeforeOpenModal(const Value: TProc);
begin
  FBeforeOpenModal := Value;
end;

procedure TViewEditComboBox.SetCodigo(ACodigo: Integer);
begin
  FCodigo := ACodigo;
end;

procedure TViewEditComboBox.SetDescription(ADescription: string);
begin
  Edit.Text := ADescription;
end;

procedure TViewEditComboBox.SetOpenCloseModal(const Value: TProc);
begin
  FOpenCloseModal := Value;
end;

end.

