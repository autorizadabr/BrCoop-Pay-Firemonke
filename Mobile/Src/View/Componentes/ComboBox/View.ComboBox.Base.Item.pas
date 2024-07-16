unit View.ComboBox.Base.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects;

type
  TViewComboBoxBaseItem = class(TFrame)
    recBase: TRectangle;
    CircleSelecao: TCircle;
    lblDescription: TLabel;
    procedure FrameClick(Sender: TObject);
    procedure FrameTap(Sender: TObject; const Point: TPointF);
  private
    const COLOR_MARKER = $FF1F41BB;
    const COLOR_UNMARKER = $FFE0E0E0;
  private
    var
    FCodigo:Integer;
    FDescription: string;
    FOnChangeItem: TProc<TObject>;
    procedure SetDescription(const Value: string);
  public
    property Codigo:Integer read FCodigo write FCodigo;
    property Description:string read FDescription write SetDescription;
    procedure Marker;
    procedure UnMarke;virtual;
    function IsMarker:Boolean;
    property OnChangeItem:TProc<TObject> read FOnChangeItem write FOnChangeItem;
  end;

implementation

{$R *.fmx}

{ TViewComboBoxBaseItem }

procedure TViewComboBoxBaseItem.FrameClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  FrameTap(Sender,TPoint.Create(0,0));
  {$ENDIF}
end;

procedure TViewComboBoxBaseItem.FrameTap(Sender: TObject; const Point: TPointF);
begin
  if not IsMarker then
    if Assigned(FOnChangeItem) then
      FOnChangeItem(Self);
end;

function TViewComboBoxBaseItem.IsMarker: Boolean;
begin
  Result := CircleSelecao.Fill.Color = COLOR_MARKER;
end;

procedure TViewComboBoxBaseItem.Marker;
begin
  CircleSelecao.Fill.Color := COLOR_MARKER;
end;

procedure TViewComboBoxBaseItem.SetDescription(const Value: string);
begin
  FDescription := Value;
  lblDescription.Text := FDescription;
end;

procedure TViewComboBoxBaseItem.UnMarke;
begin
  CircleSelecao.Fill.Color := COLOR_UNMARKER;
end;

end.

