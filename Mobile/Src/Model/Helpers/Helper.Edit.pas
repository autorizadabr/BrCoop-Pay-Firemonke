unit Helper.Edit;

interface

uses System.SysUtils, FMX.Edit, Model.Utils;

type
  TEditFormat = class helper for TEdit
    function ToCurrency: Currency;
    function ToMoney:string;
    procedure FormatMoney;
    procedure FormatPercentage;
    function OnlyNumer:string;
    procedure Clear;
  end;

implementation

{ TEditFormat }

procedure TEditFormat.Clear;
begin
  Self.Text := EmptyStr;
end;

procedure TEditFormat.FormatMoney;
begin
  Self.Text     := TModelUtils.FormatCurrencyValue(Self.Text);
  Self.SelStart := Self.Text.Length;
end;

procedure TEditFormat.FormatPercentage;
begin
  Self.Text     := '% '+TModelUtils.FormatCurrencyValue(Self.Text);
  Self.SelStart := Self.Text.Length;
end;

function TEditFormat.OnlyNumer: string;
begin
  Result := TModelUtils.ExtractNumber(Self.Text);
end;

function TEditFormat.ToCurrency: Currency;
begin
  var
  LValueFormat := TModelUtils.FormatCurrencyValue(Self.Text);
  var
  LValueResult := LValueFormat.Replace('.', '', [rfReplaceAll]);
  //LValueResult := LValueResult.Replace(',', '.', [rfReplaceAll]);
  Result := StrToCurrDef(LValueResult, 0);
end;

function TEditFormat.ToMoney: string;
begin
  Result := TModelUtils.FormatCurrencyValue(Self.Text)
end;

end.
