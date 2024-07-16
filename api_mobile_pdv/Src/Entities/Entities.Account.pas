unit Entities.Account;

interface
uses Entities.User, Entities.Base, Entities.Company;

type
  TEntitiesAccount = class(TEntitiesBase)
  private
    FCompany: TEntitiesCompany;
    FUser: TEntitiesUser;
    procedure SetCompany(const Value: TEntitiesCompany);
    procedure SetUser(const Value: TEntitiesUser);
  public
    property User: TEntitiesUser read FUser write SetUser;
    property Company: TEntitiesCompany read FCompany write SetCompany;
  end;

implementation

{ TEntitiesAccount }

procedure TEntitiesAccount.SetCompany(const Value: TEntitiesCompany);
begin
  FCompany := Value;
end;

procedure TEntitiesAccount.SetUser(const Value: TEntitiesUser);
begin
  FUser := Value;
end;
end.
