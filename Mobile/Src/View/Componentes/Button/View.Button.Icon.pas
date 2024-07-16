unit View.Button.Icon;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Button.Base, FMX.Controls.Presentation, FMX.Objects, FMX.Effects;

type
  TViewButtonIcon = class(TViewButtonBase)
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewButtonIcon: TViewButtonIcon;

implementation

{$R *.fmx}

end.
