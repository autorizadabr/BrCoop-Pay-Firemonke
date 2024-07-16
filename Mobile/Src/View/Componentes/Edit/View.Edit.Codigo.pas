unit View.Edit.Codigo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects, FMX.Ani;

type
  TViewEditCodigo = class(TFrame)
    recBase: TRectangle;
    lblNumber: TLabel;
    FloatAnimation1: TFloatAnimation;
  private
    FCodigo: Integer;
    procedure SetCodigo(const Value: Integer);
    { Private declarations }
  public
    procedure AfterConstruction; override;
    property Codigo:Integer read FCodigo write SetCodigo;
    function CodigoIsEmpty:Boolean;
    procedure Clear;
    procedure StartAnimation;
    procedure StopAnimation;
  end;

implementation

{$R *.fmx}

{ TViewEditCodigo }

procedure TViewEditCodigo.AfterConstruction;
begin
  inherited;
  Codigo := -1;
end;

procedure TViewEditCodigo.Clear;
begin
  lblNumber.Text := EmptyStr;
end;

function TViewEditCodigo.CodigoIsEmpty: Boolean;
begin
  Result := lblNumber.Text.Equals('|') or (FCodigo <= -1);
end;

procedure TViewEditCodigo.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
  if FCodigo <= -1 then
    lblNumber.Text := '|'
  else
    lblNumber.Text := Value.ToString;
end;

procedure TViewEditCodigo.StartAnimation;
begin
  lblNumber.Text := '|';
  FloatAnimation1.Start;
end;

procedure TViewEditCodigo.StopAnimation;
begin
  lblNumber.Text := '|';
  FloatAnimation1.Stop;
end;

end.
