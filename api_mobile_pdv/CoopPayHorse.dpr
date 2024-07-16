program CoopPayHorse;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Horse.HandleException,
  Horse.JWT,
  Connection.Database in 'Src\Connection\Connection.Database.pas' {ConnectionDatabase: TDataModule},
  Controller.Authentication in 'Src\Controller\Controller.Authentication.pas',
  Services.Authentication in 'Src\Services\Services.Authentication.pas',
  Services.Base in 'Src\Services\Services.Base.pas',
  Entities.User in 'Src\Entities\Entities.User.pas',
  Entities.Base in 'Src\Entities\Entities.Base.pas',
  Controller.User in 'Src\Controller\Controller.User.pas',
  Services.User in 'Src\Services\Services.User.pas',
  Send.Email.CoopPay in 'Src\Utils\Send.Email.CoopPay.pas',
  Controller.Permission in 'Src\Controller\Controller.Permission.pas',
  Entities.Permission in 'Src\Entities\Entities.Permission.pas',
  Services.Permission in 'Src\Services\Services.Permission.pas',
  Controller.Company in 'Src\Controller\Controller.Company.pas',
  Entities.Company in 'Src\Entities\Entities.Company.pas',
  Services.Company in 'Src\Services\Services.Company.pas',
  Services.Response.Pagination in 'Src\Services\Services.Response.Pagination.pas',
  Controller.City in 'Src\Controller\Controller.City.pas',
  Controller.State in 'Src\Controller\Controller.State.pas',
  Entities.City in 'Src\Entities\Entities.City.pas',
  Services.City in 'Src\Services\Services.City.pas',
  Services.State in 'Src\Services\Services.State.pas',
  Entities.State in 'Src\Entities\Entities.State.pas',
  Controller.Role in 'Src\Controller\Controller.Role.pas',
  Entities.Role in 'Src\Entities\Entities.Role.pas',
  Services.Role in 'Src\Services\Services.Role.pas',
  Controller.Permission.Role in 'Src\Controller\Controller.Permission.Role.pas',
  Entities.Permission.Role in 'Src\Entities\Entities.Permission.Role.pas',
  Services.Permission.Role in 'Src\Services\Services.Permission.Role.pas',
  Entities.Company.User.Role in 'Src\Entities\Entities.Company.User.Role.pas',
  Controller.Company.User.Role in 'Src\Controller\Controller.Company.User.Role.pas',
  Services.Company.User.Role in 'Src\Services\Services.Company.User.Role.pas',
  Services.Account in 'Src\Services\Services.Account.pas',
  Controller.Account in 'Src\Controller\Controller.Account.pas',
  Entities.Account in 'Src\Entities\Entities.Account.pas',
  Generator.Password in 'Src\Utils\Generator.Password.pas',
  Generator.Id in 'Src\Utils\Generator.Id.pas',
  Constantes in 'Src\Utils\Constantes.pas',
  Reposotories.Base in 'Src\Repositories\Reposotories.Base.pas',
  Reposotories.User in 'Src\Repositories\Reposotories.User.pas',
  Controller.CNPJ in 'Src\Controller\Controller.CNPJ.pas',
  Services.CNPJ in 'Src\Services\Services.CNPJ.pas',
  Entities.CNPJ in 'Src\Entities\Entities.CNPJ.pas',
  Entities.Category in 'Src\Entities\Entities.Category.pas',
  Controller.Category in 'Src\Controller\Controller.Category.pas',
  Services.Category in 'Src\Services\Services.Category.pas',
  Controller.Unitt in 'Src\Controller\Controller.Unitt.pas',
  Entities.Unitt in 'Src\Entities\Entities.Unitt.pas',
  Services.Unitt in 'Src\Services\Services.Unitt.pas',
  Connection.Pool.Config in 'Src\Connection\Connection.Pool.Config.pas',
  Services.Storage in 'Src\Services\Services.Storage.pas',
  Entities.Customer in 'Src\Entities\Entities.Customer.pas',
  Controller.Customer in 'Src\Controller\Controller.Customer.pas',
  Services.Customer in 'Src\Services\Services.Customer.pas',
  Controller.CEP in 'Src\Controller\Controller.CEP.pas',
  Services.CEP in 'Src\Services\Services.CEP.pas',
  Entities.CEP in 'Src\Entities\Entities.CEP.pas',
  Controller.Product in 'Src\Controller\Controller.Product.pas',
  Entities.Product in 'Src\Entities\Entities.Product.pas',
  Services.Product in 'Src\Services\Services.Product.pas',
  Entities.Tax.Model in 'Src\Entities\Entities.Tax.Model.pas',
  Controller.Tax.Model in 'Src\Controller\Controller.Tax.Model.pas',
  Services.Tax.Model in 'Src\Services\Services.Tax.Model.pas',
  Controller.Types.Payment in 'Src\Controller\Controller.Types.Payment.pas',
  Entities.Types.Payment in 'Src\Entities\Entities.Types.Payment.pas',
  Services.Types.Payment in 'Src\Services\Services.Types.Payment.pas',
  Controller.Order in 'Src\Controller\Controller.Order.pas',
  Entities.Order in 'Src\Entities\Entities.Order.pas',
  Services.Order in 'Src\Services\Services.Order.pas',
  Controller.Order.Itens in 'Src\Controller\Controller.Order.Itens.pas',
  Entities.Order.Itens in 'Src\Entities\Entities.Order.Itens.pas',
  Services.Order.Itens in 'Src\Services\Services.Order.Itens.pas',
  Controller.Order.Payment in 'Src\Controller\Controller.Order.Payment.pas',
  Entities.Order.Payment in 'Src\Entities\Entities.Order.Payment.pas',
  Services.Order.Payment in 'Src\Services\Services.Order.Payment.pas',
  Controller.Pos.Payment in 'Src\Controller\Controller.Pos.Payment.pas',
  Services.Pos.Payment in 'Src\Services\Services.Pos.Payment.pas',
  Entities.Pos.Payment in 'Src\Entities\Entities.Pos.Payment.pas';

begin
  IsConsole := False;
  ReportMemoryLeaksOnShutdown := True;

  THorse.Use(HorseJWT('cooppay',
                      THorseJWTConfig.New.
                      SkipRoutes(['authentication/login',
                                  'authentication/register',
                                  'authentication/reset-password',
                                  'authentication/update-password',
                                  'user/email/:email',
                                  'city',
                                  'cep/:cep',
                                  'cnpj/:cnpj',
                                  'account/verify/cnpj/:cnpj/ie/:ie',
                                  'account/release-company',//Deve ter autenticação
                                  'account/verify',
                                  'account/new'])));

  // Uses Horse
  THorse.Use(Jhonson());
  THorse.Use(HandleException);


  // Register Controller
  Controller.Authentication.Registry;
  Controller.User.Registry;
  Controller.Permission.Registry;
  Controller.Company.Registry;
  Controller.Role.Registry;
  Controller.Permission.Role.Registry;
  Controller.Company.User.Role.Registry;
  Controller.City.Registry;
  Controller.State.Registry;
  Controller.Account.Registry;
  Controller.CNPJ.Registry;
  Controller.CEP.Registry;
  Controller.Category.Registry;
  Controller.Unitt.Registry;
  Controller.Customer.Registry;
  Controller.Product.Registry;
  Controller.Tax.Model.Registry;
  Controller.Order.Registry;
  Controller.Order.Payment.Registry;
  Controller.Order.Itens.Registry;
  Controller.Types.Payment.Registry;
  // Port
  THorse.Listen(9000,
  procedure
  begin

    Readln;
  end);


end.
