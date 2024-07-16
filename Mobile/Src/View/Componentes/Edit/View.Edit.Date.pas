unit View.Edit.Date;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects, FMX.DateTimeCtrls;


type
  TViewEditDate = class(TFrame)
    recBase: TRectangle;
    EditDate: TDateEdit;
    lblDate: TLabel;
    ImgDate: TImage;
    procedure EditDateClosePicker(Sender: TObject);
    procedure EditDateChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure AfterConstruction; override;
    procedure SetDate(const ADate:TDate);
    procedure HideDate;
    procedure ShowDate;
  end;

implementation

{$R *.fmx}

{ TViewEditDate }

procedure TViewEditDate.AfterConstruction;
begin
  inherited;
  EditDate.Visible := True;
  EditDate.Date := Now;
  lblDate.Text := DateToStr(Now);
  {$IFNDEF MSWINDOWS}
   EditDate.StyleLookup := 'EditDateStyleClean';
   EditDate.StyleName := 'EditDateStyleClean';
  {$ENDIF}
end;

procedure TViewEditDate.EditDateChange(Sender: TObject);
begin
  lblDate.Text := DateToStr(EditDate.Date);
end;

procedure TViewEditDate.EditDateClosePicker(Sender: TObject);
begin
  lblDate.Text := DateToStr(EditDate.Date);
end;

procedure TViewEditDate.HideDate;
begin
  EditDate.Visible := False;
end;

procedure TViewEditDate.SetDate(const ADate: TDate);
begin
  EditDate.Date := ADate;
  lblDate.Text := DateToStr(EditDate.Date);
end;

procedure TViewEditDate.ShowDate;
begin
  TThread.CreateAnonymousThread(
  procedure
  begin
    TThread.Sleep(300);
    TThread.Synchronize(nil,
    procedure
    begin
      EditDate.Visible := True;
      EditDate.SendToBack;
    end);
  end).Start;
end;

end.
