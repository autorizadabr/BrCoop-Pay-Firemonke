unit Helper.Scroll;

interface
uses FMX.Layouts,FMX.Types;
type
  TScrollHelper = class helper for TCustomScrollBox
    procedure ClearItems();
  end;
implementation

{ TScrollHelper }

procedure TScrollHelper.ClearItems;
begin
  for var I := Pred(Self.Content.ChildrenCount) downto 0 do
    if Assigned(Self.Content.Children[i]) then
      Self.Content.Children[i].Free;
end;

end.
