unit Model.Records.Item.Desconto;

interface
  type
  TModelItemDesconto = record
    Percentual:Currency;
    Valor:Currency;
    procedure Clear;
  end;
implementation

{ TModelItemDesconto }

procedure TModelItemDesconto.Clear;
begin
  Percentual := 0;
  Valor      := 0;
end;

end.
