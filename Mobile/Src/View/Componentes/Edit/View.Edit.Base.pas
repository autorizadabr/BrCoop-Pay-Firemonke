unit View.Edit.Base;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Edit;

type
  TViewEditBase = class(TFrame)
    recBase: TRectangle;
    Edit: TEdit;
    StyleBook1: TStyleBook;
    procedure FrameClick(Sender: TObject);
    procedure FrameTap(Sender: TObject; const Point: TPointF);
    procedure EditEnter(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar;
      Shift: TShiftState);
    procedure EditTyping(Sender: TObject);
  private
    FFormat: TProc<TEdit>;
    FClickBack:Boolean;
    FOnExit: TProc<TObject>;
    procedure SetFormat(const Value: TProc<TEdit>);
    procedure OnClickFrameEdit;
    procedure SetOnExit(const Value: TProc<TObject>);
  protected
    FItemSelected:Boolean;
    FColorPattnerStroke:TAlphaColor;
    procedure SetColorEnter;
    procedure SetColorExit;
    procedure Loaded; override;
   public
     procedure AfterConstruction; override;
     property Format:TProc<TEdit> read FFormat write SetFormat;
     property OnExit:TProc<TObject> read FOnExit write SetOnExit;
  end;

implementation

{$R *.fmx}

procedure TViewEditBase.AfterConstruction;
begin
  inherited;
  //edtUserStyle1
  {$IFDEF IOS}
  Edit.StyleLookup := 'transparentedit';
  {$ENDIF}
  Edit.MaxLength := 0;
end;

procedure TViewEditBase.EditEnter(Sender: TObject);
begin
  TThread.ForceQueue(Nil,
  procedure
  begin
    SetColorEnter;
  end);
end;

procedure TViewEditBase.EditExit(Sender: TObject);
begin
  TThread.ForceQueue(Nil,
  procedure
  begin
    SetColorExit;
    if Assigned(FFormat) then
      FFormat(Edit);
    if Assigned(FOnExit) then
      FOnExit(Self);
  end);
end;

procedure TViewEditBase.EditKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
  if Key = 8  then
  begin
    TThread.ForceQueue(Nil,
    procedure
    begin
      FClickBack := True;
    end);
  end;
end;

procedure TViewEditBase.EditTyping(Sender: TObject);
begin
  TThread.ForceQueue(Nil,
  procedure
  begin
    if not FClickBack then
      if Assigned(Format) then
        Format(Edit);
    FClickBack := False;
  end);
end;

procedure TViewEditBase.FrameClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  FrameTap(Sender,TPoint.Create(0,0));
  {$ENDIF}
end;

procedure TViewEditBase.FrameTap(Sender: TObject; const Point: TPointF);
begin
  OnClickFrameEdit;
end;

procedure TViewEditBase.Loaded;
begin
  inherited;
  FItemSelected := False;
  FColorPattnerStroke := recBase.Stroke.Color;
end;


procedure TViewEditBase.OnClickFrameEdit;
begin
  if Edit.Enabled and not FItemSelected then
  begin
    FItemSelected := True;
  end;
end;

procedure TViewEditBase.SetColorEnter;
begin
  recBase.Stroke.Color := $FF1F41BB;
end;

procedure TViewEditBase.SetColorExit;
begin
  recBase.Stroke.Color := FColorPattnerStroke;
  FItemSelected := False;
end;

procedure TViewEditBase.SetFormat(const Value: TProc<TEdit>);
begin
  FFormat := Value;
end;

procedure TViewEditBase.SetOnExit(const Value: TProc<TObject>);
begin
  FOnExit := Value;
end;

end.
