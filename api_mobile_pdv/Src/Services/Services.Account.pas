unit Services.Account;

interface
uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PGDef, FireDAC.Phys.PG,
  FireDAC.Comp.UI,
  FireDAC.DApt,
  Services.Base,
  System.SysUtils,
  System.DateUtils,
  DataSet.Serialize,
  System.Generics.Collections,
  System.JSON, Entities.Account, Generator.Password, Send.Email.CoopPay,
  Generator.Id, Constantes;

type
  TServicesAccount = class(TServicesBase<TEntitiesAccount>)
  private
  public
    function New(AEntity: TEntitiesAccount): TJSONObject;
    procedure ReleaseCompany(const ACompanyId:string);
    function Verify(const AEmail:string):TJSONObject;
    function VeriryCNPJAndIE(const ACnpj,AIe:string):TJSONObject;
  end;

implementation

{ TServicesAccount }


function TServicesAccount.New(AEntity: TEntitiesAccount):TJSONObject;
begin
  Connection.StartTransaction;
  try
    Result := TJSONObject.Create;
    try
      AEntity.Company.GenerateId;

      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('select id from public.cities');
      Query.SQL.Add('where id = :id');
      Query.ParamByName('id').AsInteger := AEntity.Company.CityId;
      Query.Open();

      if Query.RecordCount <= 0 then
      begin
        raise Exception.Create('Cidade não encontrada!');
      end;

      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('select id from public.companies');
      Query.SQL.Add('where cpf_cnpj = :cpf_cnpj');
      Query.ParamByName('cpf_cnpj').AsString := AEntity.Company.CpfCnpj;
      Query.Open();

      if Query.RecordCount >= 1 then
      begin
        raise Exception.Create('CPF/CNPJ já cadastrado, não é possivél criar uma nova conta!');
      end;


      AEntity.Company.GenerateId;
      AEntity.User.GenerateId;

      AEntity.Company.Validatede;
      AEntity.User.Validatede;

      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('INSERT INTO public.companies');
      Query.SQL.Add('(id, cpf_cnpj, ie, ie_st, im, "name", fantasy,');
      Query.SQL.Add('public_place, "number", complement, neighborhood,');
      Query.SQL.Add('city_id, zip_code, phone, crt, email, duo_date, is_active,');
      Query.SQL.Add('is_block, is_verify)');
      Query.SQL.Add('VALUES(:id, :cpf_cnpj, :ie, :ie_st, :im, :"name", :fantasy,');
      Query.SQL.Add(':public_place, :"number", :complement, :neighborhood,');
      Query.SQL.Add(':city_id, :zip_code, :phone, :crt, :email, :duo_date, ');
      Query.SQL.Add(':is_active, :is_block, :is_verify);');
      Query.ParamByName('id').AsString            := AEntity.Company.Id;
      Query.ParamByName('cpf_cnpj').AsString      := AEntity.Company.CpfCnpj;
      Query.ParamByName('ie').AsString            := AEntity.Company.Ie;
      Query.ParamByName('ie_st').AsString         := AEntity.Company.IeSt;
      Query.ParamByName('im').AsString            := AEntity.Company.Im;
      Query.ParamByName('name').AsString          := AEntity.Company.Name;
      Query.ParamByName('fantasy').AsString       := AEntity.Company.Fantasy;
      Query.ParamByName('public_place').AsString  := AEntity.Company.PublicPlace;
      Query.ParamByName('number').AsString        := AEntity.Company.Number;
      Query.ParamByName('complement').AsString    := AEntity.Company.Complement;
      Query.ParamByName('neighborhood').AsString  := AEntity.Company.Neighborhood;
      Query.ParamByName('city_id').AsInteger      := AEntity.Company.CityId;
      Query.ParamByName('zip_code').AsString      := AEntity.Company.ZipCode;
      Query.ParamByName('phone').AsString         := AEntity.Company.Phone;
      Query.ParamByName('crt').AsString           := AEntity.Company.Crt;
      Query.ParamByName('email').AsString         := AEntity.Company.Email;
      Query.ParamByName('duo_date').AsDate        := IncDay(Now,15);
      Query.ParamByName('is_active').AsBoolean    := False;
      Query.ParamByName('is_block').AsBoolean     := False;
      Query.ParamByName('is_verify').AsBoolean    := False;
      Query.ExecSQL();


      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('select email from public.users');
      Query.SQL.Add('where lower(email) = lower(:email)');
      Query.ParamByName('email').AsString     := AEntity.User.Email.ToLower;
      Query.Open();

      if Query.RecordCount >= 1 then
        raise Exception.Create('e-mail do usuário já está sendo usado em outro cadastrado!');

      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('INSERT INTO public.users');
      Query.SQL.Add('      ( id,"name", email, "password",  active,  type_user)');
      Query.SQL.Add('VALUES(:id, :name, :email, :password, :active, :type_user)');
      Query.ParamByName('id').AsString        := AEntity.User.Id;
      Query.ParamByName('name').AsString      := AEntity.User.Name;
      Query.ParamByName('email').AsString     := AEntity.User.Email;
      Query.ParamByName('password').AsString  := AEntity.User.PasswordCrypt;
      Query.ParamByName('active').AsBoolean   := AEntity.User.Active;
      Query.ParamByName('type_user').AsString := AEntity.User.TypeUser;
      Query.ExecSQL();

      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('INSERT INTO public.company_user_role');
      Query.SQL.Add('      ( id, user_id, company_id, role_id)');
      Query.SQL.Add('VALUES(:id, :user_id, :company_id, :role_id)');
      Query.ParamByName('id').AsString         := TGeneratorId.GeneratorId;
      Query.ParamByName('user_id').AsString    := AEntity.User.Id;
      Query.ParamByName('company_id').AsString := AEntity.Company.Id;
      {TODO -oGabriel -cRefatorar : Mudar esse valor e colocar que ele venha da classe constantes}
      Query.ParamByName('role_id').AsString    := '39A9844111CB4775BD6CCEC8966A53KO';
      Query.ExecSQL();



      {TODO -oGabriel -cRefatorar : Está criando um cliente em mais de um lugar}
      // Criação de Cliente padrão
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('INSERT INTO public.customers');
      Query.SQL.Add('(id, cpf_cnpj, ie, type_of_taxpayer, "name", fantasy,');
      Query.SQL.Add('public_place, "number", complement, neighborhood, city_id,');
      Query.SQL.Add('phone, email, is_active, zip_code, company_id)');
      Query.SQL.Add('VALUES(:id, :cpf_cnpj, :ie, :type_of_taxpayer, :"name",');
      Query.SQL.Add(':fantasy, :public_place, :number, :complement, :neighborhood,');
      Query.SQL.Add(':city_id, :phone, :email, :is_active, :zip_code, :company_id)');
      Query.ParamByName('id').AsString                := TGeneratorId.GeneratorId;
      Query.ParamByName('cpf_cnpj').AsString          := '00000000000';
      Query.ParamByName('ie').AsString                := '00000';
      Query.ParamByName('type_of_taxpayer').AsInteger := 1;
      Query.ParamByName('name').AsString              := 'CONSUMIDOR';
      Query.ParamByName('fantasy').AsString           := 'CONSUMIDOR';
      Query.ParamByName('public_place').AsString      := 'PADRÃO';
      Query.ParamByName('number').AsString            := 'SN';
      Query.ParamByName('complement').AsString        := '';
      Query.ParamByName('neighborhood').AsString      := 'PADRÃO';
      Query.ParamByName('city_id').AsInteger          := AEntity.Company.CityId;
      Query.ParamByName('phone').AsString             := '';
      Query.ParamByName('email').AsString             := '';
      Query.ParamByName('is_active').AsBoolean        := True;
      Query.ParamByName('zip_code').AsString          := AEntity.Company.ZipCode;
      Query.ParamByName('company_id').AsString        := AEntity.Company.Id;
      Query.ExecSQL();


      {TODO -oGabriel -cRefatorar : Está criando um tipo de pagamento em mais de um lugar}
      // Criação de tipos de pagamentos padrão
      var LDicTypePayments := TDictionary<Integer,String>.Create;
      try
        LDicTypePayments.Add(1,'Dinheiro');
        LDicTypePayments.Add(3,'Cartão de Crédito');
        LDicTypePayments.Add(4,'Cartão de Débito');
        LDicTypePayments.Add(17,'Pagamento Instantâneo (PIX) - Dinâmico');
        LDicTypePayments.Add(20,'Pagamento Instantâneo (PIX) - Estático');

        for var Lkey in LDicTypePayments.Keys do
        begin
          Query.Close;
          Query.SQL.Clear;
          Query.SQL.Add('INSERT INTO public.types_of_payments');
          Query.SQL.Add('(id, description, code, active, company_id)');
          Query.SQL.Add('VALUES(:id, :description, :code, :active, :company_id);');
          Query.ParamByName('id').AsString          := TGeneratorId.GeneratorId;
          Query.ParamByName('description').AsString := LDicTypePayments.Items[Lkey];
          Query.ParamByName('code').AsInteger       := LKey;
          Query.ParamByName('active').AsBoolean     := True;
          Query.ParamByName('company_id').AsString  := AEntity.Company.Id;
          Query.ExecSQL();
        end;
      finally
        FreeAndNil(LDicTypePayments);
      end;


      // Envio de email
      var LCodigoVeficacao := Copy(GeneratorPassword,1,6);

      var LSendEmail := TSendEmailCoopPay.Create;
      try
        try
          LSendEmail.Destinatario := AEntity.User.Email;
          LSendEmail.Name         := AEntity.User.Name;
          LSendEmail.Password     := LCodigoVeficacao;
          LSendEmail.TypeEmail    := pNewAccount;
          LSendEmail.Send;

        except on E: Exception do
          raise Exception.Create(e.Message);
        end;

      finally
        LSendEmail.Free;
      end;

      Result.AddPair('codeVerify',LCodigoVeficacao);
      Result.AddPair('companyId',AEntity.Company.Id);

    except on E: Exception do
      begin
        if Assigned(Result) then
          FreeAndNil(Result);
        Connection.Rollback;
        raise Exception.Create(e.Message);
        Exit;
      end;
    end;
    Connection.Commit;
  finally
    Connection.StartTransaction;
  end;
end;

procedure TServicesAccount.ReleaseCompany(const ACompanyId: string);
begin

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.companies');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := ACompanyId;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Empresa não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.companies set is_verify = :is_verify,');
  Query.SQL.Add('is_active = :is_active');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString            := ACompanyId;
  Query.ParamByName('is_active').AsBoolean    := True;
  Query.ParamByName('is_verify').AsBoolean    := True;
  Query.ExecSQL();
end;

function TServicesAccount.Verify(const AEmail: string):TJSONObject;
begin
  Result := TJSONObject.Create();
  try
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select c.is_verify,c.id,u.email,u.name from users u');
    Query.SQL.Add('left join company_user_role cur ON cur.user_id = u.id');
    Query.SQL.Add('left join companies c on c.id = cur.company_id');
    Query.SQL.Add('where lower(u.email) = lower(:email)');
    Query.ParamByName('email').AsString :=AEmail.ToLower;
    Query.Open();

    if Query.RecordCount <= 0 then
      raise Exception.Create('E-mail não encontrado!');

    Result.AddPair('isVerify',Query.FieldByName('is_verify').AsBoolean);
    // Caso a empresa já esteje verificada ele não vai mandar o e-mail
    if Query.FieldByName('is_verify').AsBoolean then
    begin
      Result.AddPair('codeVerify',-1);
      Result.AddPair('companyId',Query.FieldByName('id').AsString);
      Exit;
    end;

    var LCodigoVeficacao := Copy(GeneratorPassword,1,6);

    var LSendEmail := TSendEmailCoopPay.Create;
    try
      try
        LSendEmail.Destinatario := AEmail;
        LSendEmail.Name         := Query.FieldByName('name').AsString;
        LSendEmail.Password     := LCodigoVeficacao;
        LSendEmail.TypeEmail    := pNewAccount;
        LSendEmail.Send;

      except on E: Exception do
        raise Exception.Create(e.Message);
      end;

    finally
      LSendEmail.Free;
    end;

    Result.AddPair('codeVerify',LCodigoVeficacao);
    Result.AddPair('companyId',Query.FieldByName('id').AsString);

  except on E: Exception do
    begin
      if Assigned(Result) then
        FreeAndNil(Result);
      Connection.Rollback;
      raise Exception.Create(e.Message);
      Exit;
    end;
  end;
end;

function TServicesAccount.VeriryCNPJAndIE(const ACnpj,
  AIe: string): TJSONObject;
begin
  Result := TJSONObject.Create();
  try
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select id from companies c');
    Query.SQL.Add('where c.cpf_cnpj = :cpf_cnpj and ie = :ie');
    Query.ParamByName('cpf_cnpj').AsString := ACnpj;
    Query.ParamByName('ie').AsString       := AIe;
    Query.Open();

    // A conta só pode ser valida se o sistema não encontra o CNPJ e IE
    Result.AddPair('isValidateAccount',Query.RecordCount <= 0);

  except on E: Exception do
    begin
      if Assigned(Result) then
        FreeAndNil(Result);
      raise Exception.Create(e.Message);
      Exit;
    end;
  end;
end;

end.
