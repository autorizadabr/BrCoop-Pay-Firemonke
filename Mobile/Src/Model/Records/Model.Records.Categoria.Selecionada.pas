unit Model.Records.Categoria.Selecionada;

interface
  uses System.SysUtils;
type
  TCategoriaSelecionada = record
    Id:String;
    Name:String;
    Imagem:string;
    procedure Clear;
  end;
implementation

{ TCategoriaSelecionada }

procedure TCategoriaSelecionada.Clear;
begin
  Id     := EmptyStr;
  Name   := EmptyStr;
  Imagem := EmptyStr;
end;

end.
