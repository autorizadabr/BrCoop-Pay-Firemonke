unit Model.Static.Credencial;

interface
type
  TModelStaticCredencial = class
  private
    class var FInstance: TModelStaticCredencial;
    class var FToken: string;
    class var FCompany:string;
    class var FUser:string;
    class var FCustomer:string;
    class var FQuantidadeMesa:Integer;
  public
    class procedure SetCompany(const ACompany:string);
    class procedure SetUser(const AUser:string);
    class procedure SetCustomer(const ACustomer:string);
    class procedure SetQuantidadeMesa(const AMesa:Integer);
    class function GetInstance: TModelStaticCredencial;
    class procedure SetToken(AToken: string);
    class function Token: string;
    class function Company:string;
    class function User:string;
    class function CustomerDefault:string;
    class function BASEURL:string;
    class function QuantidadeMesa:Integer;

  end;

implementation

{ TModelStaticCredencial }

class function TModelStaticCredencial.BASEURL: string;
begin
  Result := 'http://127.0.0.1:9000/';
end;

class function TModelStaticCredencial.Company: string;
begin
  Result := FCompany;
end;

class function TModelStaticCredencial.CustomerDefault: string;
begin
  Result := FCustomer;
end;

class function TModelStaticCredencial.GetInstance: TModelStaticCredencial;
begin
  Result := FInstance;
end;

class function TModelStaticCredencial.QuantidadeMesa: Integer;
begin
  Result :=  FQuantidadeMesa;
end;

class procedure TModelStaticCredencial.SetCompany(const ACompany: string);
begin
  FCompany := ACompany;
end;

class procedure TModelStaticCredencial.SetCustomer(const ACustomer: string);
begin
  FCustomer := ACustomer;
end;

class procedure TModelStaticCredencial.SetQuantidadeMesa(const AMesa: Integer);
begin
  FQuantidadeMesa := AMesa;
end;

class procedure TModelStaticCredencial.SetToken(AToken: string);
begin
  FToken := AToken;
end;

class procedure TModelStaticCredencial.SetUser(const AUser: string);
begin
  FUser := AUser;
end;

class function TModelStaticCredencial.Token: string;
begin
  Result := FToken;
end;

class function TModelStaticCredencial.User: string;
begin
  Result := FUser;
end;

initialization

TModelStaticCredencial.FInstance := TModelStaticCredencial.Create;

finalization

TModelStaticCredencial.FInstance.Free;

end.
