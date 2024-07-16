unit Reposotories.User;

interface
  uses
  System.SysUtils,
  Reposotories.Base,
  Entities.User,
  FireDAC.Stan.Param,
  System.Generics.Collections;

type
  TRepositoriesUser = class(TRepositoriesBase<TEntitiesUser>)
  private
  public
    procedure Insert(AEntity: TEntitiesUser); override;
    procedure Update(AEntity: TEntitiesUser); override;
    procedure Delete(AEntity: TEntitiesUser); override;
    procedure SelectAll(AParams: TDictionary<string, string>); override;
    procedure SelectById(const AId: string); override;
  end;

implementation

{ TRepositoriesUser }

{ TRepositoriesUser }

procedure TRepositoriesUser.Delete(AEntity: TEntitiesUser);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from users');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

procedure TRepositoriesUser.Insert(AEntity: TEntitiesUser);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.users');
  Query.SQL.Add('      ( id,"name", email, "password",  active,  type_user)');
  Query.SQL.Add('VALUES(:id, :name, :email, :password, :active, :type_user)');
  Query.ParamByName('id').AsString        := AEntity.Id;
  Query.ParamByName('name').AsString      := AEntity.Name;
  Query.ParamByName('email').AsString     := AEntity.Email;
  Query.ParamByName('password').AsString  := AEntity.PasswordCrypt;
  Query.ParamByName('active').AsBoolean   := AEntity.Active;
  Query.ParamByName('type_user').AsString := AEntity.TypeUser;
  Query.ExecSQL();
end;

procedure TRepositoriesUser.SelectAll(AParams: TDictionary<string, string>);
begin
  inherited;
  QueryRecordCount.Close;
  QueryRecordCount.SQL.Clear;
  QueryRecordCount.SQL.Add('select count(id) from users');
  QueryRecordCount.SQL.Add('where 1=1');
  if AParams.ContainsKey('name') then
  begin
    QueryRecordCount.SQL.Add('and lower(name) like lower(:name)');
    QueryRecordCount.ParamByName('name').AsString := '%'+AParams.Items['name']+'%';
  end;

  if AParams.ContainsKey('email') then
  begin
    QueryRecordCount.SQL.Add('and lower(email) like lower(:email)');
    QueryRecordCount.ParamByName('email').AsString := '%'+AParams.Items['email']+'%';
  end;
  QueryRecordCount.Open();

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id,"name", email,  active, type_user from users');
  Query.SQL.Add('where 1=1');
  if AParams.ContainsKey('name') then
  begin
    Query.SQL.Add('and lower(name) like lower(:name)');
    Query.ParamByName('name').AsString := '%'+AParams.Items['name']+'%';
  end;

  if AParams.ContainsKey('email') then
  begin
    Query.SQL.Add('and lower(email) like lower(:email)');
    Query.ParamByName('email').AsString := '%'+AParams.Items['email']+'%';
  end;


  Query.SQL.Add('offset '+Skip.ToString+' limit '+Limit.ToString);
  Query.Open();
end;

procedure TRepositoriesUser.SelectById(const AId: string);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id,"name", email,  active, type_user from users');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AId;
  Query.Open();
end;

procedure TRepositoriesUser.Update(AEntity: TEntitiesUser);
begin
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.users');
  Query.SQL.Add('SET "name" = :name, email= :email,');
  Query.SQL.Add('"password" = :"password", active = :active, type_user = :type_user');
  Query.SQL.Add('WHERE id=:id');
  Query.ParamByName('id').AsString        := AEntity.Id;
  Query.ParamByName('name').AsString      := AEntity.Name;
  Query.ParamByName('email').AsString     := AEntity.Email;
  Query.ParamByName('password').AsString  := AEntity.Password;
  Query.ParamByName('active').AsBoolean   := AEntity.Active;
  Query.ParamByName('type_user').AsString := AEntity.TypeUser;
  Query.ExecSQL();
end;

end.
