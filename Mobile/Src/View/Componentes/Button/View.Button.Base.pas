unit View.Button.Base;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Effects;

type
  TViewButtonBase = class(TFrame)
    Rectangle1: TRectangle;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
  private
    { Private declarations }
  public
    procedure Block;
    procedure Unlock;
  end;

implementation

{$R *.fmx}

procedure TViewButtonBase.Block;
begin
  //Self.Enabled := False;
end;

procedure TViewButtonBase.Unlock;
begin
  //Self.Enabled := True;
end;

end.
