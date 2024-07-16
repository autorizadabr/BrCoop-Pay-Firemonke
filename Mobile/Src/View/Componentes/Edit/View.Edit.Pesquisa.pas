unit View.Edit.Pesquisa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit;

type
  TViewEditPesquisa = class(TFrame)
    recBase: TRectangle;
    Edit: TEdit;
    StyleBook1: TStyleBook;
    imgPesquisa: TImage;
    imgClear: TImage;
    procedure imgClearClick(Sender: TObject);
    procedure imgClearTap(Sender: TObject; const Point: TPointF);
  private
    { Private declarations }
  public
    procedure AfterConstruction;override;
  end;

implementation

{$R *.fmx}

procedure TViewEditPesquisa.AfterConstruction;
begin
  inherited;
  {$IFDEF IOS}
  Edit.StyleLookup := 'transparentedit';
  {$ENDIF}
end;

procedure TViewEditPesquisa.imgClearClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  Edit.Text := EmptyStr;
  {$ENDIF}
end;

procedure TViewEditPesquisa.imgClearTap(Sender: TObject; const Point: TPointF);
begin
  Edit.Text := EmptyStr;
 end;

end.
