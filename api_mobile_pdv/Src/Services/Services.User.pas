unit Services.User;

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
  BCrypt,
  DataSet.Serialize,
  System.JSON, Entities.User, Generator.Password;

type
  TServicesUser = class(TServicesBase<TEntitiesUser>)
  private
  public
    function GetEmailUserExist(AUser: TEntitiesUser): Boolean;
    function SelectAll: TJSONObject; override;
    function SelectByCompany: TJSONObject;
    function SelectById(const AId: string): TJSONObject; override;
    function Insert(AEntity: TEntitiesUser):TJSONObject; override;
    procedure Update(AEntity: TEntitiesUser); override;
    procedure Delete(AEntity: TEntitiesUser); override;
    procedure AfterConstruction; override;

  end;

implementation

{ TServicesUser }


procedure TServicesUser.AfterConstruction;
begin
  inherited;
  Route := 'user';
end;

procedure TServicesUser.Delete(AEntity: TEntitiesUser);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.users');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.id;
  Query.Open();

  if Query.RecordCount <= 0 then
    raise Exception.Create('Usuário não encontrado!');

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from users');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicesUser.GetEmailUserExist(AUser: TEntitiesUser): Boolean;
begin
  Query.Close;
  Query.SQL.Clear;                        // Garantindo que vai pegar o email correto
  Query.SQL.Add('select * from users where lower(email) = Lower(:email) ');
  Query.ParamByName('email').AsString    := AUser.Email.ToLower;
  Query.Open();
  Result := Query.RecordCount > 0;
end;

function TServicesUser.Insert(AEntity: TEntitiesUser):TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select email from public.users');
  Query.SQL.Add('where lower(email) = lower(:email)');
  Query.ParamByName('email').AsString     := AEntity.Email.ToLower;
  Query.Open();

  if Query.RecordCount >= 1 then
    raise Exception.Create('e-mail já cadastrado!');

  // Por padrão sempre que criar um novo usuário estamos gerando um código
  AEntity.Password := GeneratorPassword;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.users');
  Query.SQL.Add('      ( id,"name", email, "password",  active,  type_user)');
  Query.SQL.Add('VALUES(:id, :name, :email, :password, :active, :type_user)');
  Query.ParamByName('id').AsString        := AEntity.Id;
  Query.ParamByName('name').AsString      := AEntity.Name;
  Query.ParamByName('email').AsString     := AEntity.Email;
  Query.ParamByName('password').AsString  := TBCrypt.GenerateHash(AEntity.Password);
  Query.ParamByName('active').AsBoolean   := AEntity.Active;
  Query.ParamByName('type_user').AsString := AEntity.TypeUser;
  Query.ExecSQL();
end;

function TServicesUser.SelectAll: TJSONObject;
begin
  DataBase := '';
  inherited;

  QueryRecordCount.Close;
  QueryRecordCount.SQL.Clear;
  QueryRecordCount.SQL.Add('select count(id) from users');
  QueryRecordCount.SQL.Add('where 1=1');
  if FListParams.ContainsKey('name') then
  begin
    QueryRecordCount.SQL.Add('and lower(name) like lower(:name)');
    QueryRecordCount.ParamByName('name').AsString := '%'+FListParams.Items['name']+'%';
  end;

  if FListParams.ContainsKey('email') then
  begin
    QueryRecordCount.SQL.Add('and lower(email) like lower(:email)');
    QueryRecordCount.ParamByName('email').AsString := '%'+FListParams.Items['email']+'%';
  end;
  QueryRecordCount.Open();
  FServicesResponsePagination.SetRecords(QueryRecordCount.FieldByName('count').AsInteger);

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id,"name", email,  active, type_user from users');
  Query.SQL.Add('where 1=1');
  if FListParams.ContainsKey('name') then
  begin
    Query.SQL.Add('and lower(name) like lower(:name)');
    Query.ParamByName('name').AsString := '%'+FListParams.Items['name']+'%';
  end;

  if FListParams.ContainsKey('email') then
  begin
    Query.SQL.Add('and lower(email) like lower(:email)');
    Query.ParamByName('email').AsString := '%'+FListParams.Items['email']+'%';
  end;


  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesUser.SelectByCompany: TJSONObject;
begin
  DataBase := 'users';
  ValidatePermission(TMethodPermission.methodGET);

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select u.id, u.name, u.email from users u');
  Query.SQL.Add('left join company_user_role cur ON cur.user_id = u.id');
  Query.SQL.Add('left join companies c on c.id = cur.company_id');
  Query.SQL.Add('where c.id = :company_id');
  Query.ParamByName('company_id').AsString := CurrentCompany;
  Query.Open();

  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesUser.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id,"name", email,  active, type_user from users');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AId;
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesUser.Update(AEntity: TEntitiesUser);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select email from public.users');
  Query.SQL.Add('where lower(email) = lower(:email) and id <> :id');
  Query.ParamByName('email').AsString := AEntity.Email.ToLower;
  Query.ParamByName('id').AsString    := AEntity.id;
  Query.Open();

  if Query.RecordCount >= 1 then
    raise Exception.Create('e-mail já cadastrado!');

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select password from public.users');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.id;
  Query.Open();


  var LPassword:string := Query.FieldByName('password').AsString;
  if not AEntity.Password.IsEmpty then
    LPassword := TBCrypt.GenerateHash(AEntity.Password);


  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.users');
  Query.SQL.Add('SET "name" = :name, email= :email,');
  Query.SQL.Add('"password" = :"password", active = :active, type_user = :type_user');
  Query.SQL.Add('WHERE id=:id');
  Query.ParamByName('id').AsString        := AEntity.Id;
  Query.ParamByName('name').AsString      := AEntity.Name;
  Query.ParamByName('email').AsString     := AEntity.Email;
  Query.ParamByName('password').AsString  := LPassword;
  Query.ParamByName('active').AsBoolean   := AEntity.Active;
  Query.ParamByName('type_user').AsString := AEntity.TypeUser;
  Query.ExecSQL();
end;

end.
