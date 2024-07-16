unit View.Edit.Time;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.DateTimeCtrls, FMX.Objects, FMX.Controls.Presentation, FMX.Effects,
  FMX.Filter.Effects;

type
  TViewEditTime = class(TFrame)
    recBase: TRectangle;
    TimeEdit: TTimeEdit;
    StyleBook1: TStyleBook;
    lblTime: TLabel;
    ImgClock: TImage;
    FillRGBEffect1: TFillRGBEffect;
    procedure TimeEditClosePicker(Sender: TObject);
    procedure TimeEditChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure AfterConstruction; override;
    procedure ShowTime;
    procedure HideTime;
  end;

implementation

{$R *.fmx}

procedure TViewEditTime.AfterConstruction;
begin
  inherited;
  TimeEdit.Time := StrToTime('00:00');
  TimeEdit.Visible := True;
  {$IFNDEF MSWINDOWS}
  TimeEdit.StyleLookup := 'TimeEdit1StyleClean';
  TimeEdit.StyleName := 'TimeEdit1StyleClean';
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  lblTime.Visible := False;
  {$ENDIF}
end;

procedure TViewEditTime.HideTime;
begin
  TimeEdit.Visible := False;
end;

procedure TViewEditTime.ShowTime;
begin
  TimeEdit.Visible := True;
end;

procedure TViewEditTime.TimeEditChange(Sender: TObject);
begin
  lblTime.Text := Copy(TimeToStr(TimeEdit.Time),1,5);
end;

procedure TViewEditTime.TimeEditClosePicker(Sender: TObject);
begin
  lblTime.Text := Copy(TimeToStr(TimeEdit.Time),1,5);
end;

end.
