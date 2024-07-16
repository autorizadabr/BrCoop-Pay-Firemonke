unit Services.Authentication;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PGDef, FireDAC.Phys.PG,
  FireDAC.Comp.UI,
  FireDAC.DApt,
  Horse.HandleException,
  Services.Base,
  System.Generics.Collections,
  FireDAC.Stan.Param,
  DataSet.Serialize,
  System.JSON,
  Entities.User,
  Services.User,
  Send.Email.CoopPay,
  Horse, Horse.JWT,
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  System.DateUtils,
  BCrypt,
  System.SysUtils;
  type
  TServicesAuthentication = class(TServicesBase<TServicesAuthentication>)
  private
    procedure ValidateRefresh(const AIdUser,AIdCompany:string);
    function GerarToekn(AUser: TEntitiesUser): string; overload;
    function GerarToekn(const AIdUser,AIdCompany:string): string; overload;
    function GetCompanyRole(const AIdUser:string):TJSONArray;
  public
    function GetLoginUser(AUser: TEntitiesUser): TJSONObject;
    function RefreshToken(const AIdUser,AIdCompany:string): TJSONObject;
    procedure RegisterUser(AUser: TEntitiesUser);
    function ResetPassword(AUser: TEntitiesUser; const AIP: string): string;
    procedure UpdatePassword(AUser: TEntitiesUser);
  end;

implementation

{ TServicesAuthentication }

function TServicesAuthentication.GerarToekn(AUser: TEntitiesUser): string;
var
  LJWT: TJWT;
  LToken: String;
begin
  LJWT := TJWT.Create();
  try
    LJWT.Claims.IssuedAt := Now;
    LJWT.Claims.Expiration := IncHour(Now, 1);
    LJWT.Claims.Subject := 'autorizada-br';
    LJWT.Claims.SetClaim('id_user',AUser.Id);
    LToken := TJOSE.SHA256CompactToken('cooppay', LJWT);
  finally
    FreeAndNil(LJWT);
  end;
  Result := LToken;
end;

function TServicesAuthentication.GerarToekn(const AIdUser,
  AIdCompany: string): string;
var
  LJWT: TJWT;
  LToken: String;
begin
  LJWT := TJWT.Create();
  try
    LJWT.Claims.IssuedAt := Now;
    LJWT.Claims.Expiration := IncHour(Now, 1);
    LJWT.Claims.Subject := 'autorizada-br';
    LJWT.Claims.SetClaim('id_user',AIdUser);
    LJWT.Claims.SetClaim('id_company',AIdCompany);
    LToken := TJOSE.SHA256CompactToken('cooppay', LJWT);
  finally
    FreeAndNil(LJWT);
  end;
  Result := LToken;
end;

function TServicesAuthentication.GetCompanyRole(const AIdUser: string): TJSONArray;
begin
  var LQueryCompanyUserRole        := TFDQuery.Create(nil);
  var LQueryUserRole               := TFDQuery.Create(nil);
  var LQueryCustomerDefault        := TFDQuery.Create(nil);

  LQueryCompanyUserRole.Connection := Connection;
  LQueryUserRole.Connection        := Connection;
  LQueryCustomerDefault.Connection :=  Connection;
  try
    LQueryCompanyUserRole.Close;
    LQueryCompanyUserRole.SQL.Clear;
    LQueryCompanyUserRole.SQL.Add('select c.id,c."name",c.fantasy ,c.cpf_cnpj,');
    LQueryCompanyUserRole.SQL.Add('c.ie, cur.role_id, c.quantity_table');
    LQueryCompanyUserRole.SQL.Add('from companies c');
    LQueryCompanyUserRole.SQL.Add('inner join company_user_role cur ON cur.company_id = c.id');
    LQueryCompanyUserRole.SQL.Add('where cur.user_id  = :id');
    LQueryCompanyUserRole.ParamByName('id').AsString := AIdUser;
    LQueryCompanyUserRole.Open();

    Result := LQueryCompanyUserRole.ToJSONArray();

    for var I := 0 to Pred(Result.Count)do
    begin
      LQueryUserRole.Close;
      LQueryUserRole.SQL.Clear;
      LQueryUserRole.SQL.Add('select pr.id ,pr.permission_id,p."name",pr.role_id');
      LQueryUserRole.SQL.Add('from permission_role pr');
      LQueryUserRole.SQL.Add('inner join permissions p on p.id = pr.permission_id');
      LQueryUserRole.SQL.Add('where pr.role_id = :role_id');
      LQueryUserRole.ParamByName('role_id').AsString := (Result.Items[I] as TJSONObject).GetValue<string>('roleId','');
      LQueryUserRole.Open();

      LQueryCustomerDefault.Close;
      LQueryCustomerDefault.SQL.Clear;
      LQueryCustomerDefault.SQL.Add('select id,name from customers');
      LQueryCustomerDefault.SQL.Add('where company_id = :company_id');
      LQueryCustomerDefault.SQL.Add('order by created_at');
      LQueryCustomerDefault.SQL.Add('limit 1');
      LQueryCustomerDefault.ParamByName('company_id').AsString := (Result.Items[I] as TJSONObject).GetValue<string>('id','');
      LQueryCustomerDefault.Open();

      (Result.Items[I] as TJSONObject).AddPair('customerDefault',LQueryCustomerDefault.ToJSONObject());

      (Result.Items[I] as TJSONObject).AddPair('role',LQueryUserRole.ToJSONArray());
    end;
  finally
    LQueryCompanyUserRole.Free;
    LQueryCustomerDefault.Free;
    LQueryUserRole.Free;
  end;
end;

function TServicesAuthentication.GetLoginUser(AUser:TEntitiesUser): TJSONObject;
begin
  Result := TJSONObject.Create;

  Query.Close;
  Query.SQL.Clear;                        // Garantindo que vai pegar o email correto
  Query.SQL.Add('select * from users where lower(email) = Lower(:email) ');
  Query.ParamByName('email').AsString    := AUser.Email.ToLower;
  Query.Open();
  if (Query.RecordCount <= 0) then
  begin
    raise EHorseException.New.Detail(Self.ClassName).Error('Usuário/Senha inválida!');
  end;

  if not TBCrypt.CompareHash(AUser.Password,Query.FieldByName('password').AsString)then
  begin
    raise EHorseException.New.Detail(Self.ClassName).Error('Usuário/Senha inválida!');
  end;

  var LQueryVerify        := TFDQuery.Create(nil);
  LQueryVerify.Connection := Connection;
  try
    LQueryVerify.Close;
    LQueryVerify.SQL.Clear;
    LQueryVerify.SQL.Add('select c.is_verify,c.id from users u');
    LQueryVerify.SQL.Add('left join company_user_role cur ON cur.user_id = u.id');
    LQueryVerify.SQL.Add('left join companies c on c.id = cur.company_id');
    LQueryVerify.SQL.Add('where lower(u.email) = lower(:email)');
    LQueryVerify.ParamByName('email').AsString  := AUser.Email.ToLower;
    LQueryVerify.Open();

    if not LQueryVerify.FieldByName('is_verify').AsBoolean then
    begin
      raise EHorseException.New.Status(THTTPStatus.Unauthorized).Hint(LQueryVerify.FieldByName('id').AsString).Error('Empresa não foi ativada!');
    end;
  finally
    LQueryVerify.Free;
  end;

  Result.AddPair('token',GerarToekn(AUser));
  var LUser := Query.ToJSONObject();
  LUser.RemovePair('password').Free;
  Result.AddPair('user',LUser);
  Result.AddPair('companies',GetCompanyRole(Query.FieldByName('id').AsString));
end;

function TServicesAuthentication.RefreshToken(const AIdUser,AIdCompany:string): TJSONObject;
begin
  Result := TJSONObject.Create;
  try
    ValidateRefresh(AIdUser,AIdCompany);
    var LServiceUser := TServicesAuthentication.Create(FToken);
    try
      Result.AddPair('token',LServiceUser.GerarToekn(AIdUser,AIdCompany));
    finally
      LServiceUser.Free;
    end;
  except on E: Exception do
    begin
      Result.Free;
      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure TServicesAuthentication.RegisterUser(AUser: TEntitiesUser);
begin
  var LServiceUser := TServicesUser.Create();
  var LSendEmail := TSendEmailCoopPay.Create;
  try
    try
      LServiceUser.Insert(AUser);

      LSendEmail.Destinatario := AUser.Email;
      LSendEmail.Name         := AUser.Name;
      LSendEmail.Password     := AUser.Password;
      LSendEmail.TypeEmail    := pNewAccount;
      LSendEmail.Send;

    except on E: Exception do
      raise EHorseException.New.Detail(Self.ClassName).Error(e.Message);
    end;

  finally
    LSendEmail.Free;
    LServiceUser.Free;
  end;
end;

function TServicesAuthentication.ResetPassword(AUser: TEntitiesUser;const AIP:string):string;
begin

  if not Assigned(AUser) then
  begin
    raise EHorseException.New.Detail(Self.ClassName).Error('E-mail não informado');
  end;

  if (AUser.Email.IsEmpty) then
  begin
    raise EHorseException.New.Detail(Self.ClassName).Error('E-mail não informado');
  end;


  // O e-mail está protegido com Unique no banco de dados
  Query.Close;
  Query.SQL.Clear;                        // Garantindo que vai pegar o email correto
  Query.SQL.Add('select * from users where lower(email) = Lower(:email) ');
  Query.ParamByName('email').AsString    := AUser.Email.ToLower;
  Query.Open();
  if (Query.RecordCount <= 0) then
  begin
    raise EHorseException.New.Detail(Self.ClassName).Error('Usuário não encontrado, verifique se o e-mail está correto!');
  end;

    var LRandom := Copy (Random(200).ToString +
                 Random(100).ToString +
                 Random(5000).ToString +
                 Random(58900).ToString +
                 Random(58900).ToString +
                 Random(1008).ToString +
                 Random(58900).ToString +
                 Random(6000).ToString,1,6);

  var LSendEmail := TSendEmailCoopPay.Create;
  try
    try
      LSendEmail.Destinatario  := Query.FieldByName('email').AsString;
      LSendEmail.Name          := Query.FieldByName('name').AsString;
      LSendEmail.Password      := Query.FieldByName('password').AsString;
      LSendEmail.CodeVerificat := LRandom;
      LSendEmail.IP            := AIP;
      LSendEmail.TypeEmail     := pResetPassword;
      LSendEmail.Send;

    except on E: Exception do
      raise EHorseException.New.Detail(Self.ClassName).Error(e.Message);
    end;

  finally
    LSendEmail.Free;
  end;

  Query.Close;
  Query.SQL.Clear;                        // Garantindo que vai pegar o email correto
  Query.SQL.Add('select id from users where lower(email) = Lower(:email) ');
  Query.ParamByName('email').AsString    := AUser.Email.ToLower;
  Query.Open();

  Result := LRandom;
end;

procedure TServicesAuthentication.UpdatePassword(AUser: TEntitiesUser);
begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from users where lower(email) = Lower(:email) ');
  Query.ParamByName('email').AsString    := AUser.Email.ToLower;
  Query.Open();

  if (Query.RecordCount <= 0) then
  begin
    raise EHorseException.New.Detail(Self.ClassName).Error('Usuário não encontrado!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('update users set "password" = :password where lower(email) = Lower(:email)');
  Query.ParamByName('email').AsString    := AUser.Email.ToLower;
  Query.ParamByName('password').AsString := AUser.PasswordCrypt;
  Query.ExecSQL();

end;

procedure TServicesAuthentication.ValidateRefresh(const AIdUser,AIdCompany:string);
begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from users');
  Query.SQL.Add('where id  = :id');
  Query.ParamByName('id').AsString := AIdUser;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Usuário não encontrado!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from companies');
  Query.SQL.Add('where id  = :id');
  Query.ParamByName('id').AsString := AIdCompany;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Empresa não encontrada não encontrada!');
  end;
end;

end.
