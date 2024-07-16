unit Services.Order.Payment;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PGDef, FireDAC.Phys.PG,
  FireDAC.Comp.UI,
  FireDAC.DApt,
  REST.Json,
  Services.Base,
  System.SysUtils,
  DataSet.Serialize,
  System.JSON, Entities.Order.Payment;

type
  TServicesOrderPayment = class(TServicesBase<TEntitiesOrderPayment>)
  private
  public
    procedure AfterConstruction; override;
    function SelectAll: TJSONObject; override;
    function SelectById(const AId: string): TJSONObject; override;
    function Insert(AEntity: TEntitiesOrderPayment):TJSONObject; override;
    procedure Update(AEntity: TEntitiesOrderPayment); override;
    procedure Delete(AEntity: TEntitiesOrderPayment); override;
  end;

implementation

{ TServicesOrderPayment }


procedure TServicesOrderPayment.AfterConstruction;
begin
  inherited;
  Route := 'order-payment';
end;

procedure TServicesOrderPayment.Delete(AEntity: TEntitiesOrderPayment);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.order_payment');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.id;
  Query.Open();

  if Query.RecordCount <= 0 then
    raise Exception.Create('Pagamento do pedido não encontrada!');

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from order_payment');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicesOrderPayment.Insert(AEntity: TEntitiesOrderPayment):TJSONObject;
begin
  inherited;
  AEntity.GenerateId;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.order_payment');
  Query.SQL.Add('(id, order_id, payment_id, nsu, autorization_code,');
  Query.SQL.Add('date_time_autorization, flag, amount_paid, created_at)');
  Query.SQL.Add('VALUES(:id, :order_id, :payment_id, :nsu, :autorization_code,');
  Query.SQL.Add(':date_time_autorization, :flag, :amount_paid, :created_at);');
  Query.ParamByName('id').AsString                       := AEntity.Id;
  Query.ParamByName('order_id').AsString                 := AEntity.OrderId;
  Query.ParamByName('payment_id').AsString               := AEntity.PaymentId;
  Query.ParamByName('nsu').AsString                      := AEntity.Nsu;
  Query.ParamByName('autorization_code').AsString        := AEntity.AutorizationCode;
  Query.ParamByName('date_time_autorization').AsDateTime := AEntity.DateTimeAutorization;
  Query.ParamByName('flag').AsString                     := AEntity.Flag;
  Query.ParamByName('amount_paid').AsFloat               := AEntity.AmountPaid;
  Query.ParamByName('created_at').AsDateTime             := Now();
  Query.ExecSQL();

  Result := TJson.ObjectToJsonObject(AEntity);
end;

function TServicesOrderPayment.SelectAll: TJSONObject;
begin
  DataBase := 'order_payment';
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from order_payment');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesOrderPayment.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from order_payment');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AId;
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesOrderPayment.Update(AEntity: TEntitiesOrderPayment);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.order_payment');
  Query.ParamByName('id').AsString := AEntity.id;
  Query.Open();

  if Query.RecordCount <= 0 then
    raise Exception.Create('Pagamento do pedido não encontrada!');

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.order_payment');
  Query.SQL.Add('SET id = :id, order_id = :order_id, payment_id = :payment_id,');
  Query.SQL.Add('nsu = :nsu, autorization_code = :autorization_code,');
  Query.SQL.Add('date_time_autorization = :date_time_autorization, flag = :flag,');
  Query.SQL.Add('amount_paid = :amount_paid,  updated_at = :updated_at;');
  Query.SQL.Add('WHERE id=:id');
  Query.ParamByName('id').AsString                       := AEntity.Id;
  Query.ParamByName('order_id').AsString                 := AEntity.OrderId;
  Query.ParamByName('payment_id').AsString               := AEntity.PaymentId;
  Query.ParamByName('nsu').AsString                      := AEntity.Nsu;
  Query.ParamByName('autorization_code').AsString        := AEntity.AutorizationCode;
  Query.ParamByName('date_time_autorization').AsDateTime := AEntity.DateTimeAutorization;
  Query.ParamByName('flag').AsString                     := AEntity.Flag;
  Query.ParamByName('amount_paid').AsFloat               := AEntity.AmountPaid;
  Query.ParamByName('updated_at').AsDateTime             := Now();
  Query.ExecSQL();
end;

end.
