unit View.Edit.Text;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Edit.Base, FMX.Controls.Presentation, FMX.Edit, FMX.Objects;

type
  TViewEditText = class(TViewEditBase)
    recContentLabel: TRectangle;
    lblText: TLabel;
    procedure EditChangeTracking(Sender: TObject);
  private
    { Private declarations }
  public

  end;

var
  ViewEditText: TViewEditText;

implementation

{$R *.fmx}

procedure TViewEditText.EditChangeTracking(Sender: TObject);
begin
  inherited;
  lblText.Text := Edit.TextPrompt;
  recContentLabel.Visible := not(Edit.Text.IsEmpty);
end;

end.
