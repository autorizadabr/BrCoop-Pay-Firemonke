unit Generator.Id;

interface
uses System.SysUtils;
  type
  TGeneratorId = class
  private
  public
    class function GeneratorId: string;
  end;
implementation

class function TGeneratorId.GeneratorId: string;
begin
  Result := TGUID.NewGuid.ToString.Replace('{', '', [rfReplaceAll])
    .Replace('}', '', [rfReplaceAll]).Replace('-', '', [rfReplaceAll]);
end;

end.
