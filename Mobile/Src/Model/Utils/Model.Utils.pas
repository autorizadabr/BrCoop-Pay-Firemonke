unit Model.Utils;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.DateUtils,
  System.JSON,
  System.RegularExpressions;
type
  TResultHours = record
    Hours:Double;
    Minute:Double;
    Total:Double;
  end;
  TModelUtils = class
  private
    class function GetHours(const AHours: Double): Integer; static;
    class function GetMinute(const AHours: Double): Integer;
  public
    class function FormatCEP(aValue: string): string;
    class function FormatCNPJ(aValue: string): string;
    class function FormatCurrencyValue(aValue: string): string;
    class function ResultParamsGet(AParams: TDictionary<string, string>): string;
    class function ExtractNumber(const AValue:string):string;
    class function FormatCelular(aValue: string): string; static;
    class function FormatTelefone(aValue: string): string; static;
    class function FormatCPFCNPJ(AValue: string): string;
    class function FormatCPF(aValue: string): string;
    class function DateToDateApi(const AValue: TDateTime): string;
    class function ISO8601StringToDate(const AValue:string):TDateTime;
    class function ISO8601StringToDateTimeString(const AValue:string):string;
    class function ISO8601StringToDateString(const AValue:string):string;
    class function ISO8601StringToDateTime(const AValue:string):TDateTime;
    class function ISO8601StringToTime(const AValue: string): TTime;
    class function CalcHoursDateTime(const ALastDate,AFirstDate: TDateTime):Double;
    Class function AddHours(const ATotal,AHours:Double):TResultHours;
    class function FirstDayOfMonth:TDate;
    class function LastDayOfMonth:TDate;
    class function RemoveItemDeleted(const AJson:TJSONArray;const AField:string = ''):TJSONArray;
    class function RemoveAcento(aText : string) : string;
    class function FormatNumeroConta(AValue: string) : string;
  end;

implementation

{ TModelUtils }

class function TModelUtils.GetMinute(const AHours: Double): Integer;
begin
  Result := 0;
  var LDoubleStr := FloatToStr(AHours);
  if LDoubleStr.Contains(',') then
    Result := StrToIntDef(Copy(LDoubleStr,Pos(',',LDoubleStr)+1),0)
end;

class function TModelUtils.GetHours(const AHours: Double): Integer;
begin
  var LDoubleStr := FloatToStr(AHours);
  if LDoubleStr.Contains(',') then
    Result := StrToIntDef(Copy(LDoubleStr,1,Pos(',',LDoubleStr)-1),0)
  else
    Result := StrToIntDef(AHours.ToString,0);
end;

class function TModelUtils.AddHours(const ATotal,AHours:Double): TResultHours;
begin
  var LCountHours:Double;
  var LCountMinute:Double;
  var LCountHoursString := ATotal.ToString;
  LCountHours := GetHours(ATotal); // Pegando somente as horas antigas
  LCountMinute := GetMinute(ATotal); // Pegando somente os minutos antigos

  LCountHours := LCountHours + GetHours(AHours); // Somandos as horas antigas com as novas
  LCountMinute := LCountMinute + GetMinute(AHours); // Somandos os minutos antigos com os novos
  if (LCountMinute ) > 60  then
  begin
    var LMultiplicate := Trunc(LCountMinute/60);
    var LSubtract := 60*LMultiplicate;
    LCountMinute := LCountMinute - LSubtract;
    LCountHours := LCountHours + LMultiplicate;
  end
  else if LCountMinute = 60 then
  begin
    LCountHours := LCountHours + 1.0;
    LCountMinute := 0;
  end;

  Result.Hours := LCountHours;
  Result.Minute := LCountMinute;
  Result.Total := LCountHours+(LCountMinute/100);
end;

class function TModelUtils.CalcHoursDateTime(const ALastDate,
  AFirstDate: TDateTime): Double;
begin
  var LResultTime := MinutesBetween(ALastDate,AFirstDate);
  var LHours:string := Trunc(LResultTime/60).ToString;
  var LMinute:string :=  (LResultTime - (StrToInt(LHours)*60)).ToString;
  var LDoubleStr:string := LHours+','+LMinute;
  Result := StrToFloatDef(LDoubleStr,0);
end;

class function TModelUtils.DateToDateApi(const AValue: TDateTime): string;
begin
  var LDia := DayOf(AValue);
  var LMes := MonthOf(AValue);
  var LAno := YearOf(AValue);
  var LTime := FormatDateTime('hh:mm:ss',AValue)+'.000';
  Result := Format('%s-%s-%s:%s',[LAno.ToString,LMes.ToString,LDia.ToString,LTime]);
end;

class function TModelUtils.ExtractNumber(const AValue: string): string;
var
  regex: TRegEx;
begin
  regex := TRegEx.Create('\d+');
  Result := '';
  for var match in regex.Matches(AValue) do
    Result := Result + match.Value;
end;

class function TModelUtils.RemoveItemDeleted(const AJson: TJSONArray;
  const AField: string): TJSONArray;
begin
  Result := nil;
  if not Assigned(AJson) then
    Exit;
  var LField := 'deletedat';
  if not AField.IsEmpty then
    LField := AField;
  for var I := Pred(AJson.Count) downto 0  do
  begin
    var LItem := AJson.Items[i] as TJSONObject;
    var LValueField := LItem.GetValue<string>(LField,'');
    if ((not LValueField.Equals('1899-12-30T00:00:00.000Z')) and (not LValueField.Equals('1899-12-31T00:00:00.000Z')) and (not LValueField.IsEmpty)) then
      AJson.Remove(i);
  end;
  Result := AJson;
end;

class function TModelUtils.ResultParamsGet
  (AParams: TDictionary<string, string>): string;
begin
  var LCount := 0;
  Result := EmptyStr;
  for var Item in AParams do
  begin
    if LCount > 0 then
      Result := Result + Format('&%s=%s', [Item.Key,Item.Value])
    else
      Result := Format('?%s=%s', [Item.Key,Item.Value]);
    Inc(LCount);
  end;
end;

class function TModelUtils.FirstDayOfMonth: TDate;
begin
  var LMonth := MonthOf(Now);
  var LYear := YearOf(Now);
  Result := StrToDate(Format('%s/%s/%s',['01',LMonth.ToString,LYear.ToString]));
end;

class function TModelUtils.FormatCelular(aValue: string): string;
var
  LValorTelefone: string;
  LQuantidadeCaracteres: integer;
begin
  LValorTelefone :=  ExtractNumber(aValue);
  LQuantidadeCaracteres := Length(LValorTelefone);

  if (LQuantidadeCaracteres > 7) then
    LValorTelefone := '(' + Copy(LValorTelefone, 1, 2) + ')' +
      Copy(LValorTelefone, 3, 1) + '.' + Copy(LValorTelefone, 4, 4) + '-' +
      Copy(LValorTelefone, 8, 4)
  else if (LQuantidadeCaracteres = 7) then
    LValorTelefone := '(' + Copy(LValorTelefone, 1, 2) + ')' +
      Copy(LValorTelefone, 3, 1) + '.' + Copy(LValorTelefone, 4, 4)
  else if (LQuantidadeCaracteres <= 6) and (LQuantidadeCaracteres > 3) then
    LValorTelefone := '(' + Copy(LValorTelefone, 1, 2) + ')' +
      Copy(LValorTelefone, 3, 1) + '.' + Copy(LValorTelefone, 4, 4)
  else if (LQuantidadeCaracteres = 3) then
    LValorTelefone := '(' + Copy(LValorTelefone, 1, 2) + ')' +
      Copy(LValorTelefone, 3, 1)
  else if (LQuantidadeCaracteres = 2) then
    LValorTelefone := '(' + Copy(LValorTelefone, 1, 2)
  else if (LQuantidadeCaracteres <= 1) then
    LValorTelefone := Copy(LValorTelefone, 1, 1);
  Result := LValorTelefone;
end;

class function TModelUtils.FormatCEP(aValue: string): string;
begin
  var LValorCEP := Copy(ExtractNumber(aValue),1,8);
  Result := LValorCEP;
  if (Length(LValorCEP) > 5 ) then
    LValorCEP := Copy(LValorCEP,1,5)+'-'+Copy(LValorCEP,6);

  Result := LValorCEP;
end;

class function TModelUtils.FormatCurrencyValue(aValue: string): string;
var
  LValue, LValueFormat: string;
  I, LLengtnValue: integer;
begin
  if (aValue.Trim.IsEmpty) or (aValue.Trim = '0,00') then
  begin
    Result := '0,00';
    Exit;
  end;

  if Copy(aValue,Pos(',',aValue)+1).Length = 1 then
    aValue := Copy(aValue,1,Pos(',',aValue)-2)+','+ExtractNumber(Copy(aValue,aValue.Length-2));
  aValue := ExtractNumber(aValue);

  if StrToCurrDef(aValue,0) <= 0 then
  begin
    Result := '0,00';
    Exit;
  end;

//  if StrToCurrDef(aValue,0) > LValuePadrao then
//  begin
//    Result := '0,00';
//    Exit;
//  end;

  for I := 1 to Length(aValue) do
  begin
    if aValue[I] <> '0' then
    begin
      LValue := Copy(aValue, I);
      Break;
    end;
  end;
  LLengtnValue := Length(LValue);
  if LLengtnValue <= 3 then
  begin
    if LLengtnValue = 1 then
      LValue := '0,0' + LValue
    else if LLengtnValue = 2 then
      LValue := '0,' + LValue
    else if LLengtnValue = 3 then
      LValue := Copy(LValue, 1, 1) + ',' + Copy(LValue, 2);
  end
  else
  begin
    LValueFormat := LValue;
    LValueFormat := ',' + Copy(LValue, LValue.Length - 1);
    LValue := Copy(LValue, 1, LValue.Length - 2);
    if Length(LValue) <= 3 then
      LValue := LValue + LValueFormat
    else
    begin
      while Length(LValue) > 3 do
      begin
        LValueFormat := '.' + Copy(LValue, LValue.Length - 2) + LValueFormat;
        LValue := Copy(LValue, 1, Length(LValue) - 3);
      end;
      LValue := LValue + LValueFormat;
    end;
  end;

  Result := LValue;

end;

class function TModelUtils.FormatNumeroConta(AValue: string): string;
begin

end;

class function TModelUtils.FormatTelefone(aValue: string): string;
var
  LValorTelefone: string;
  LQuantidadeCaracteres: integer;
begin
  LValorTelefone :=  ExtractNumber(aValue);
  LQuantidadeCaracteres := Length(LValorTelefone);

  if (LQuantidadeCaracteres >= 7) then
    LValorTelefone := '(' + Copy(LValorTelefone, 1, 2) + ')' +
       Copy(LValorTelefone, 3, 4) + '-' +Copy(LValorTelefone, 7, 4)
  else if (LQuantidadeCaracteres = 6) then
    LValorTelefone := '(' + Copy(LValorTelefone, 1, 2) + ')' +
    Copy(LValorTelefone, 3, 4)
  else if (LQuantidadeCaracteres <= 6) and (LQuantidadeCaracteres > 3) then
    LValorTelefone := '(' + Copy(LValorTelefone, 1, 2) + ')' +
    Copy(LValorTelefone, 3, 4)
  else if (LQuantidadeCaracteres = 3) then
    LValorTelefone := '(' + Copy(LValorTelefone, 1, 2) + ')' +
      Copy(LValorTelefone, 3, 1)
  else if (LQuantidadeCaracteres = 2) then
    LValorTelefone := '(' + Copy(LValorTelefone, 1, 2)
  else if (LQuantidadeCaracteres <= 1) then
    LValorTelefone := Copy(LValorTelefone, 1, 1);
  Result := LValorTelefone;
end;


class function TModelUtils.ISO8601StringToDate(const AValue: string): TDateTime;
begin
//  Result := StrToDateTime(AValue);
//  Exit;
  var LAno := Copy(AValue,1,4);
  var LMes := Copy(AValue,6,2);
  var LDia := Copy(AValue,9,2);
  var LDate:TDateTime := StrToDate(Format('%s/%s/%s',[LDia,LMes,LAno]));
  var LTimeStr := Copy(AValue,12,8);
  if LTimeStr.IsEmpty then
  begin
    Result := LDate;
  end
  else
  begin
    var LTime:TTIme := StrToTime(LTimeStr);
    Result := LDate + LTime;
  end;

end;

class function TModelUtils.ISO8601StringToDateString(
  const AValue: string): string;
begin
  Result := DateToStr(ISO8601StringToDate(AValue));
end;

class function TModelUtils.ISO8601StringToDateTimeString(
  const AValue: string): string;
begin
  Result := DateTimeToStr(ISO8601StringToDateTime(AValue));
end;

class function TModelUtils.ISO8601StringToDateTime(
  const AValue: string): TDateTime;
begin
//  Result := StrToDateTime(AValue);
//  Exit;
  var LAno := Copy(AValue,1,4);
  var LMes := Copy(AValue,6,2);
  var LDia := Copy(AValue,9,2);
  var LDate:TDateTime := StrToDate(Format('%s/%s/%s',[LDia,LMes,LAno]));
  var LTimeStr := Copy(AValue,12,8);
  var LTime:TTIme := StrToTime(LTimeStr);
  Result := LDate + LTime;
end;

class function TModelUtils.ISO8601StringToTime(const AValue: string): TTime;
begin
  Result := StrToTime(Copy(AValue,12,8));
end;

class function TModelUtils.LastDayOfMonth: TDate;
begin
  var LLastDay := DaysInMonth(Now);
  var LMonth := MonthOf(Now);
  var LYear := YearOf(Now);
  Result := StrToDate(Format('%s/%s/%s',[LLastDay.ToString,LMonth.ToString,LYear.ToString]))+StrToTIme('23:59:59');
end;

class function TModelUtils.FormatCNPJ(aValue: string): string;
var
  LValorCNPJ: string;
begin
  LValorCNPJ := ExtractNumber(aValue);

  if (Length(LValorCNPJ) <= 14) and (Length(LValorCNPJ) > 12) then
    LValorCNPJ := Copy(LValorCNPJ, 1, 2) + '.' + Copy(LValorCNPJ, 3, 3) + '.' +
      Copy(LValorCNPJ, 6, 3) + '/' + Copy(LValorCNPJ, 9, 4) + '-' +
      Copy(LValorCNPJ, 13, 2)
  else if (Length(LValorCNPJ) <= 12) and (Length(LValorCNPJ) > 8) then
    LValorCNPJ := Copy(LValorCNPJ, 1, 2) + '.' + Copy(LValorCNPJ, 3, 3) + '.' +
      Copy(LValorCNPJ, 6, 3) + '/' + Copy(LValorCNPJ, 9, 4)
  else if (Length(LValorCNPJ) <= 8) and (Length(LValorCNPJ) > 5) then
    LValorCNPJ := Copy(LValorCNPJ, 1, 2) + '.' + Copy(LValorCNPJ, 3, 3) + '.' +
      Copy(LValorCNPJ, 6, 3)
  else if (Length(LValorCNPJ) <= 5) and (Length(LValorCNPJ) > 2) then
    LValorCNPJ := Copy(LValorCNPJ, 1, 2) + '.' + Copy(LValorCNPJ, 3, 3);

  if LValorCNPJ.Length > 18 then
    LValorCNPJ := Copy(LValorCNPJ,1,18);
  Result := LValorCNPJ;
end;

class function TModelUtils.FormatCPF(aValue: string): string;
var
  LValorCPF: string;
begin
  LValorCPF := ExtractNumber(aValue);
  if LValorCPF.Length > 11 then
    LValorCPF := Copy(LValorCPF,1,11);
  if (Length(LValorCPF) <= 11) and (Length(LValorCPF) > 9) then
    LValorCPF := Copy(LValorCPF, 1, 3) + '.' + Copy(LValorCPF, 4, 3) + '.' +
      Copy(LValorCPF, 7, 3) + '-' + Copy(LValorCPF, 10, 2)
  else if (Length(LValorCPF) <= 9) and (Length(LValorCPF) > 6) then
    LValorCPF := Copy(LValorCPF, 1, 3) + '.' + Copy(LValorCPF, 4, 3) + '.' +
      Copy(LValorCPF, 7, 3)
  else if (Length(LValorCPF) <= 6) and (Length(LValorCPF) > 3) then
    LValorCPF := Copy(LValorCPF, 1, 3) + '.' + Copy(LValorCPF, 4, 3);
  Result := LValorCPF;
end;
class function TModelUtils.FormatCPFCNPJ(AValue: string): string;
begin
  if Length(AValue) > 14 then
    Result := FormatCNPJ(AValue)
  else
    Result := FormatCPF(AValue);
end;

class function TModelUtils.RemoveAcento(aText : string) : string;
const
  ComAcento = '‡‚ÍÙ˚„ı·ÈÌÛ˙Á¸Ò˝¿¬ ‘€√’¡…Õ”⁄«‹—›';
  SemAcento = 'aaeouaoaeioucunyAAEOUAOAEIOUCUNY';
var
  x: Cardinal;
begin;
  for x := 1 to Length(aText) do
  try
    if (Pos(aText[x], ComAcento) <> 0) then
      aText[x] := SemAcento[ Pos(aText[x], ComAcento) ];
  except on E: Exception do
    raise Exception.Create('Erro no processo.');
  end;

  Result := aText;
end;

end.
