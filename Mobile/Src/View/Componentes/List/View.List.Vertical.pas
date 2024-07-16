unit View.List.Vertical;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.List.Base, FMX.Layouts, Helper.Scroll;

type
  TViewListVertical = class(TViewListBase)
    ScrollBox: TVertScrollBox;
  private
    FTop:Single;
  public
    procedure ClearList;
    procedure AddItem(const AItem:TFrame);
    procedure AfterConstruction; override;

  end;

var
  ViewListVertical: TViewListVertical;

implementation

{$R *.fmx}

{ TViewListVertical }

procedure TViewListVertical.AddItem(const AItem: TFrame);
begin
  AItem.Align := TAlignLayout.None;
  AItem.Parent := ScrollBox;
  AItem.Position.Y := FTop;
  AItem.Width := ScrollBox.Width;
  FTop := FTop + AItem.Height;
end;

procedure TViewListVertical.AfterConstruction;
begin
  inherited;
  FTop := 0;
end;

procedure TViewListVertical.ClearList;
begin
  FTop := 0;
  ScrollBox.ClearItems;
end;

end.
