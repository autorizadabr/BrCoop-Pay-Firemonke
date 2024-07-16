unit Services.Pos.Payment;

interface
uses
{$Region 'Firedac'}
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PGDef, FireDAC.Phys.PG,
  FireDAC.Comp.UI, FireDAC.DApt,
{$EndRegion}
  Services.Base,
  System.SysUtils,
  System.Classes,
  DataSet.Serialize,
  System.JSON,
  Entities.Pos.Payment;

type
  TServicesPosPayment = class(TServicesBase<TEntitiesPosPayment>)
  private
  public
    function SelectAll: TJSONObject; override;
    function SelectById(const AId: string): TJSONObject; override;
    function Insert(AEntity: TEntitiesPosPayment):TJSONObject; override;
    procedure Update(AEntity: TEntitiesPosPayment); override;
    procedure Delete(AEntity: TEntitiesPosPayment); override;
    procedure AfterConstruction; override;

  end;

implementation

{ TServicesPosPayment }


procedure TServicesPosPayment.AfterConstruction;
begin
  inherited;
  Route := 'pos-payment';
end;

procedure TServicesPosPayment.Delete(AEntity: TEntitiesPosPayment);
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.pos_payments');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Pos Pagamento não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('delete from pos_payments');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.ExecSQL();
end;

function TServicesPosPayment.Insert(AEntity: TEntitiesPosPayment):TJSONObject;
begin
  inherited;
  AEntity.GenerateId;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO public.pos_payments');
  Query.SQL.Add('(id, payment_id, description_pos, description, name_pos)');
  Query.SQL.Add('VALUES(:id, :payment_id, :description_pos, :description, :name_pos)');
  Query.ParamByName('id').AsString              := AEntity.Id;
  Query.ParamByName('payment_id').AsString      := AEntity.PaymentId;
  Query.ParamByName('description_pos').AsString := AEntity.DescriptionPos;
  Query.ParamByName('description').AsString     := AEntity.Description;
  Query.ParamByName('name_pos').AsString        := AEntity.NamePos;
  Query.ExecSQL();
end;

function TServicesPosPayment.SelectAll: TJSONObject;
begin
  DataBase := 'pos_payments';
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from pos_payments');
  Query.SQL.Add('offset '+Skip.ToString+' limit '+FLimit.ToString);
  Query.Open();

  FServicesResponsePagination.SetData(Query.ToJSONArray());
  Result := FServicesResponsePagination.Content;
end;

function TServicesPosPayment.SelectById(const AId: string): TJSONObject;
begin
  inherited;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from pos_payments');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AId;
  Query.Open();

  FServicesResponsePagination.SetPage(0);
  FServicesResponsePagination.SetLimit(0);
  FServicesResponsePagination.SetRecords(Query.RecordCount);
  FServicesResponsePagination.SetData(Query.ToJSONObject());
  Result := FServicesResponsePagination.Content;
end;

procedure TServicesPosPayment.Update(AEntity: TEntitiesPosPayment);
begin
  inherited;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select id from public.pos_payments');
  Query.SQL.Add('where id = :id');
  Query.ParamByName('id').AsString := AEntity.Id;
  Query.Open();

  if Query.RecordCount <= 0 then
  begin
    raise Exception.Create('Pos Pagamento não encontrada!');
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE public.pos_payments');
  Query.SQL.Add('SET payment_id = :payment_id, description_pos = :description_pos,');
  Query.SQL.Add('description = :description, name_pos = :name_pos');
  Query.SQL.Add('WHERE id = :id;');
  Query.ParamByName('id').AsString              := AEntity.Id;
  Query.ParamByName('payment_id').AsString      := AEntity.PaymentId;
  Query.ParamByName('description_pos').AsString := AEntity.DescriptionPos;
  Query.ParamByName('description').AsString     := AEntity.Description;
  Query.ParamByName('name_pos').AsString        := AEntity.NamePos;
  Query.ExecSQL();
end;

end.
