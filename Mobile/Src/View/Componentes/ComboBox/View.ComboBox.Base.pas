unit View.ComboBox.Base;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Modal.Base, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,
  View.List.Base, View.List.Vertical, System.Generics.Collections,
  View.ComboBox.Base.Item, Generics.Defaults, System.Math, View.Edit.ComboBox;

type
  TViewComboBoxBase = class(TViewModalBase)
    ViewListVertical: TViewListVertical;
  private
    FEditComboBox: TViewEditComboBox;
    FOnChange: TProc<Integer, String>;
    procedure SetEditComboBox(const Value: TViewEditComboBox);
    procedure SetOnChange(const Value: TProc<Integer, String>);
  protected
      procedure OnChangeItem(Sender:TObject);
  public
    procedure BeforeDestruction; override;
    procedure UnMarkerList;virtual;
    procedure LoadItemsClear(ADictionaryItems:TDictionary<Integer,string>);
    procedure LoadItems(ADictionaryItems:TDictionary<Integer,string>);
    procedure AddItem(const ACodigo:Integer;const ADescription:string);
    procedure SetItemByValue(const AValue:string);
    procedure SetItemByCodigo(const ACodigo:Integer);
    property EditComboBox:TViewEditComboBox read FEditComboBox write SetEditComboBox;
    property OnChange:TProc<Integer,String> read FOnChange write SetOnChange;
  end;
var
  ViewComboBoxBase: TViewComboBoxBase;

implementation

{$R *.fmx}

{ TViewComboBoxBase }

procedure TViewComboBoxBase.AddItem(const ACodigo: Integer;
  const ADescription: string);
begin
  var LFrame := TViewComboBoxBaseItem.Create(nil);
  LFrame.Codigo := ACodigo;
  LFrame.Description := ADescription;
  LFrame.OnChangeItem := OnChangeItem;
  ViewListVertical.AddItem(LFrame);
end;

procedure TViewComboBoxBase.BeforeDestruction;
begin
  ViewListVertical.ClearList;
  inherited;
end;

procedure TViewComboBoxBase.LoadItems(
  ADictionaryItems: TDictionary<Integer, string>);
begin
  ViewListVertical.ClearList;
  for var LKey in ADictionaryItems.Keys do
  begin
    var LFrame := TViewComboBoxBaseItem.Create(nil);
    LFrame.Codigo := Lkey;
    LFrame.Description := ADictionaryItems.Items[LKey];
    LFrame.OnChangeItem := OnChangeItem;
    ViewListVertical.AddItem(LFrame);
  end;
end;

procedure TViewComboBoxBase.LoadItemsClear(
  ADictionaryItems: TDictionary<Integer, string>);
  var LFrame:TViewComboBoxBaseItem;
begin
  ViewListVertical.ClearList;
  LFrame := TViewComboBoxBaseItem.Create(nil);
  LFrame.Codigo := 0;
  LFrame.Description := 'Nenhum';
  LFrame.OnChangeItem := OnChangeItem;
  ViewListVertical.AddItem(LFrame);

  for var LKey in ADictionaryItems.Keys do
  //for var I := 0 to  Pred(ADictionaryItems.Count) do
  begin
    LFrame := TViewComboBoxBaseItem.Create(nil);
    LFrame.Codigo := Lkey;
    LFrame.Description := ADictionaryItems.Items[LKey];
    LFrame.OnChangeItem := OnChangeItem;
    ViewListVertical.AddItem(LFrame);
  end;
end;

procedure TViewComboBoxBase.OnChangeItem(Sender: TObject);
begin
  if Sender is TViewComboBoxBaseItem then
  begin
    UnMarkerList;
    TViewComboBoxBaseItem(Sender).Marker;
    CloseModal;
    if Assigned(FEditComboBox) then
    begin
      FEditComboBox.SetCodigo(TViewComboBoxBaseItem(Sender).Codigo);
      FEditComboBox.SetDescription(TViewComboBoxBaseItem(Sender).Description);
    end;
    if Assigned(FOnChange) then
      FOnChange(TViewComboBoxBaseItem(Sender).Codigo,
                TViewComboBoxBaseItem(Sender).Description);
  end;
end;

procedure TViewComboBoxBase.SetEditComboBox(const Value: TViewEditComboBox);
begin
  FEditComboBox := Value;
  if Assigned(FEditComboBox) then
    FEditComboBox.OpenCloseModal := Self.OpenModal;
end;

procedure TViewComboBoxBase.SetItemByCodigo(const ACodigo: Integer);
begin
  UnMarkerList;
  for var I := 0 to Pred(ViewListVertical.ScrollBox.Content.ControlsCount) do
  begin
    if ViewListVertical.ScrollBox.Content.Controls[i] is  TViewComboBoxBaseItem then
    begin
      if TViewComboBoxBaseItem(ViewListVertical.ScrollBox.Content.Controls[i]).Codigo = ACodigo then
      begin
        TViewComboBoxBaseItem(ViewListVertical.ScrollBox.Content.Controls[i]).Marker;
        if Assigned(FEditComboBox) then
        begin
          FEditComboBox.SetCodigo(TViewComboBoxBaseItem(ViewListVertical.ScrollBox.Content.Controls[i]).Codigo);
          FEditComboBox.SetDescription(TViewComboBoxBaseItem(ViewListVertical.ScrollBox.Content.Controls[i]).Description);
        end;
        Break;
      end;
    end;
  end;
end;

procedure TViewComboBoxBase.SetItemByValue(const AValue: string);
begin
  UnMarkerList;
  for var I := 0 to Pred(ViewListVertical.ScrollBox.Content.ControlsCount) do
  begin
    if ViewListVertical.ScrollBox.Content.Controls[i] is  TViewComboBoxBaseItem then
    begin
      if TViewComboBoxBaseItem(ViewListVertical.ScrollBox.Content.Controls[i]).Description.ToUpper.Equals(AValue.ToUpper) then
      begin
        TViewComboBoxBaseItem(ViewListVertical.ScrollBox.Content.Controls[i]).Marker;
        if Assigned(FEditComboBox) then
        begin
          FEditComboBox.SetCodigo(TViewComboBoxBaseItem(ViewListVertical.ScrollBox.Content.Controls[i]).Codigo);
          FEditComboBox.SetDescription(TViewComboBoxBaseItem(ViewListVertical.ScrollBox.Content.Controls[i]).Description);
        end;
        Break;
      end;
    end;
  end;
end;

procedure TViewComboBoxBase.SetOnChange(const Value: TProc<Integer, String>);
begin
  FOnChange := Value;
end;

procedure TViewComboBoxBase.UnMarkerList;
begin
  if Assigned(FEditComboBox) then
    FEditComboBox.Clear;
  for var i := 0 to Pred(ViewListVertical.ScrollBox.Content.ControlsCount) do
  begin
    if ViewListVertical.ScrollBox.Content.Controls[i] is  TViewComboBoxBaseItem then
      TViewComboBoxBaseItem(ViewListVertical.ScrollBox.Content.Controls[i]).UnMarke;
  end;
end;

end.
