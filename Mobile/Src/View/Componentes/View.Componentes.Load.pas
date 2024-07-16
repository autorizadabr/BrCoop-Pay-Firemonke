unit View.Componentes.Load;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation;

type
  TViewComponentesLoad = class(TFrame)
    Rectangle1: TRectangle;
    AniIndicator: TAniIndicator;
    Label1: TLabel;
    layCenter: TLayout;
  private
    { Private declarations }
  public
    procedure OpenFrame();
    procedure CloseFrame();
  end;

implementation

{$R *.fmx}

{ TViewComponentesLoad }

procedure TViewComponentesLoad.CloseFrame;
begin
  TThread.Synchronize(nil,
  procedure
  begin
    Self.SendToBack;
    Self.Visible := False;
    AniIndicator.Visible := False;
    AniIndicator.Enabled := False;
    layCenter.Visible := False;
  end);
end;

procedure TViewComponentesLoad.OpenFrame;
begin
  TThread.Synchronize(nil,
  procedure
  begin
    Self.BringToFront;

    Self.Visible := True;
    AniIndicator.BringToFront;
    layCenter.Visible := True;
    AniIndicator.Enabled := True;
    AniIndicator.Visible := True;
  end);
end;

end.
