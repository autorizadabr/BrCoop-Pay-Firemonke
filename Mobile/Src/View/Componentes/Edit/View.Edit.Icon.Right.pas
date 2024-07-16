unit View.Edit.Icon.Right;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Edit.Base, FMX.Controls.Presentation, FMX.Edit, FMX.Objects;

type
  TViewEditIconRight = class(TViewEditBase)
    imgPesquisa: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewEditIconRight: TViewEditIconRight;

implementation

{$R *.fmx}

end.
