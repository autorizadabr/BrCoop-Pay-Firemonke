unit Generator.Password;

interface
  uses System.SysUtils;
function GeneratorPassword: string;

implementation

function GeneratorPassword: string;
begin
  Result := Copy(Random(200).ToString + Random(100).ToString + Random(5000)
    .ToString + Random(1008).ToString + Random(58900).ToString + Random(47008)
    .ToString + Random(58900).ToString + Random(6000).ToString, 1, 8);
end;

end.
