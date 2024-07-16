unit DAO.Pedido;

interface
 uses
{$REGION 'Firedac'}
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
{$ENDREGION}
 DAO.Base, System.Generics.Collections, System.SysUtils,Model.Connection,
  Model.Static.Credencial;

type
  TStatusPedido = (stAberto, stFechado);

type
  TPedido = class
  private
    FTypeOrder: Integer;
    FEmpresaId: string;
    FTroco: Currency;
    FDescontoValor: Currency;
    FSubtotal: Currency;
    FUsuarioId: string;
    FTotal: Currency;
    FCpfCnpj: string;
    FId: Integer;
    FDescontoPorcentage: Currency;
    FClienteId: string;
    FStatus: TStatusPedido;
    FMesa: Integer;
    FComanda: Integer;
    FCreateAt: TDateTime;
    procedure SetStatus(const Value: TStatusPedido);
    function StatusString: string;
    procedure Limpar;
  public
    property Id: Integer read FId write FId;
    property EmpresaId: string read FEmpresaId write FEmpresaId;
    property UsuarioId: string read FUsuarioId write FUsuarioId;
    property ClienteId: string read FClienteId write FClienteId;
    property TypeOrder: Integer read FTypeOrder write FTypeOrder;
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property DescontoValor: Currency read FDescontoValor write FDescontoValor;
    property DescontoPorcentage: Currency read FDescontoPorcentage
      write FDescontoPorcentage;
    property Troco: Currency read FTroco write FTroco;
    property Subtotal: Currency read FSubtotal write FSubtotal;
    property Total: Currency read FTotal write FTotal;
    property Mesa: Integer read FMesa write FMesa default 0;
    property Comanda: Integer read FComanda write FComanda default 0;
    property Status: TStatusPedido read FStatus write SetStatus;
    property CreateAt:TDateTime read FCreateAt write FCreateAt;
  end;

  TDAOPedido = class(TDAOBase)
  private
    FPedido: TPedido;
    FConexao: TFDConnection;
  public
    constructor Create(const AConexao: TFDConnection);
    destructor Destroy; override;
    property Dados: TPedido read FPedido;
    procedure Gravar;
    procedure Alterar;
    procedure CarregarDadosPeloIdLocal(const AId: Integer);
    procedure CarregarDadosPeloIdAPI(const AId: string);
    function ListaMesasAbertas: TList<TPedido>;
    procedure CarregarDadosPeloNumeroMesa(const AMesa: Integer);
    procedure UpdateIdOrderApi(const AIdOrderApi: string);
    procedure UpdateSync(const AIdOrder,ASync:Integer);
    procedure ApagarDadosPeloId(const AOrderId:Integer);
    procedure ApagarDadosNaoSincronizados(const AOrderId:Integer);
  end;

implementation

{ TDAOPedido }

procedure TDAOPedido.Alterar;
begin
  var LQueryPedido        := TFDQuery.Create(nil);
  LQueryPedido.Connection := ModelConnection.Connection;
  try
    LQueryPedido.Close;
    LQueryPedido.SQL.Clear;
    LQueryPedido.SQL.Add('update "order" set');
    LQueryPedido.SQL.Add('user_id = :user_id,');
    LQueryPedido.SQL.Add('customer_id = :customer_id, type_order = :type_order,');
    LQueryPedido.SQL.Add('cpf_cnpj = :cpf_cnpj, discount_value = :discount_value');
    LQueryPedido.SQL.Add(',discount_percentage  = :discount_percentage, troco = :troco,');
    LQueryPedido.SQL.Add('subtotal = :subtotal, total = :total, sync = :sync,');
    LQueryPedido.SQL.Add('updated_at = :updated_at, status = :status, mesa = :mesa, comanda = :comanda');
    LQueryPedido.SQL.Add('where id = :id and company_id = :company_id');
    LQueryPedido.ParamByName('id').AsInteger                := Dados.Id;
    LQueryPedido.ParamByName('company_id').AsString         := Dados.EmpresaId;
    LQueryPedido.ParamByName('user_id').AsString            := Dados.UsuarioId;
    LQueryPedido.ParamByName('customer_id').AsString        := Dados.ClienteId;
    LQueryPedido.ParamByName('type_order').AsInteger        := Dados.TypeOrder;
    LQueryPedido.ParamByName('cpf_cnpj').AsString           := Dados.CpfCnpj;
    LQueryPedido.ParamByName('discount_value').AsFloat      := Dados.DescontoValor;
    LQueryPedido.ParamByName('discount_percentage').AsFloat := Dados.DescontoPorcentage;
    LQueryPedido.ParamByName('troco').AsFloat               := Dados.Troco;
    LQueryPedido.ParamByName('subtotal').AsFloat            := Dados.Subtotal;
    LQueryPedido.ParamByName('total').AsFloat               := Dados.Total;
    LQueryPedido.ParamByName('updated_at').AsString         := DateTimeToStr(Now);
    LQueryPedido.ParamByName('status').AsString             := Dados.StatusString;
    LQueryPedido.ParamByName('mesa').AsInteger              := Dados.Mesa;
    LQueryPedido.ParamByName('comanda').AsInteger           := Dados.Comanda;
    LQueryPedido.ParamByName('sync').AsInteger              := 0;
    LQueryPedido.ExecSQL;
  finally
     FreeAndNil(LQueryPedido);
  end;
end;

procedure TDAOPedido.ApagarDadosNaoSincronizados(const AOrderId: Integer);
begin
  FPedido.Limpar;
  var LQueryPedido        := TFDQuery.Create(nil);
  LQueryPedido.Connection := FConexao;
  try
    LQueryPedido.Close;
    LQueryPedido.SQL.Clear;
    LQueryPedido.SQL.Add('delete from order_itens');
    LQueryPedido.SQL.Add('where order_id = :order_id and (user_id = '''' or user_id = null)');
    LQueryPedido.ParamByName('order_id').AsInteger := AOrderId;
    LQueryPedido.ExecSQL();

    LQueryPedido.Close;
    LQueryPedido.SQL.Clear;
    LQueryPedido.SQL.Add('delete from order_payment');
    LQueryPedido.SQL.Add('where order_id = :order_id and sync = 0');
    LQueryPedido.ParamByName('order_id').AsInteger := AOrderId;
    LQueryPedido.ExecSQL();

  finally
    LQueryPedido.Free;
  end;
end;

procedure TDAOPedido.ApagarDadosPeloId(const AOrderId: Integer);
begin
  FPedido.Limpar;
  var LQueryPedido        := TFDQuery.Create(nil);
  LQueryPedido.Connection := FConexao;
  try
    LQueryPedido.Close;
    LQueryPedido.SQL.Clear;
    LQueryPedido.SQL.Add('delete from "order"');
    LQueryPedido.SQL.Add('where id = :id');
    LQueryPedido.ParamByName('id').AsInteger := AOrderId;
    LQueryPedido.ExecSQL();

    LQueryPedido.Close;
    LQueryPedido.SQL.Clear;
    LQueryPedido.SQL.Add('delete from order_itens');
    LQueryPedido.SQL.Add('where order_id = :order_id');
    LQueryPedido.ParamByName('order_id').AsInteger := AOrderId;
    LQueryPedido.ExecSQL();

    LQueryPedido.Close;
    LQueryPedido.SQL.Clear;
    LQueryPedido.SQL.Add('delete from order_payment');
    LQueryPedido.SQL.Add('where order_id = :order_id');
    LQueryPedido.ParamByName('order_id').AsInteger := AOrderId;
    LQueryPedido.ExecSQL();

  finally
    LQueryPedido.Free;
  end;
end;

procedure TDAOPedido.CarregarDadosPeloIdAPI(const AId: string);
begin
  FPedido.Limpar;
  var LQueryPedido        := TFDQuery.Create(nil);
  LQueryPedido.Connection := FConexao;
  try
    LQueryPedido.Close;
    LQueryPedido.SQL.Clear;
    LQueryPedido.SQL.Add('select * from "order"');
    LQueryPedido.SQL.Add('where id_order_item_api = :id_order_item_api');
    LQueryPedido.ParamByName('id_order_item_api').AsString := AId;
    LQueryPedido.Open();

    if LQueryPedido.RecordCount > 0 then
    begin
      Dados.Id                 := LQueryPedido.FieldByName('id').AsInteger;
      Dados.EmpresaId          := LQueryPedido.FieldByName('company_id').AsString;
      Dados.UsuarioId          := LQueryPedido.FieldByName('user_id').AsString;
      Dados.ClienteId          := LQueryPedido.FieldByName('customer_id').AsString;
      Dados.TypeOrder          := LQueryPedido.FieldByName('type_order').AsInteger;
      Dados.CpfCnpj            := LQueryPedido.FieldByName('cpf_cnpj').AsString;
      Dados.DescontoValor      := LQueryPedido.FieldByName('discount_value').AsFloat;
      Dados.DescontoPorcentage := LQueryPedido.FieldByName('discount_percentage').AsFloat;
      Dados.Troco              := LQueryPedido.FieldByName('troco').AsFloat;
      Dados.Subtotal           := LQueryPedido.FieldByName('subtotal').AsFloat;
      Dados.Total              := LQueryPedido.FieldByName('total').AsFloat;
      Dados.Mesa               := LQueryPedido.FieldByName('mesa').AsInteger;
      Dados.Comanda            := LQueryPedido.FieldByName('comanda').AsInteger;
      if LQueryPedido.FieldByName('status').AsString.ToUpper.Equals('ABERTO') then
        Dados.Status := TStatusPedido.stAberto
      else if LQueryPedido.FieldByName('status').AsString.ToUpper.Equals('FECHADO') then
        Dados.Status := TStatusPedido.stFechado;

    end;
  finally
    FreeAndNil(LQueryPedido);
  end;
end;

procedure TDAOPedido.CarregarDadosPeloIdLocal(const AId: Integer);
begin
  FPedido.Limpar;
  var LQueryPedido        := TFDQuery.Create(nil);
  LQueryPedido.Connection := FConexao;
  try
    LQueryPedido.Close;
    LQueryPedido.SQL.Clear;
    LQueryPedido.SQL.Add('select * from "order"');
    LQueryPedido.SQL.Add('where id = :id');
    LQueryPedido.ParamByName('id').AsInteger := AId;
    LQueryPedido.Open();

    if LQueryPedido.RecordCount > 0 then
    begin
      Dados.Id                 := LQueryPedido.FieldByName('id').AsInteger;
      Dados.EmpresaId          := LQueryPedido.FieldByName('company_id').AsString;
      Dados.UsuarioId          := LQueryPedido.FieldByName('user_id').AsString;
      Dados.ClienteId          := LQueryPedido.FieldByName('customer_id').AsString;
      Dados.TypeOrder          := LQueryPedido.FieldByName('type_order').AsInteger;
      Dados.CpfCnpj            := LQueryPedido.FieldByName('cpf_cnpj').AsString;
      Dados.DescontoValor      := LQueryPedido.FieldByName('discount_value').AsFloat;
      Dados.DescontoPorcentage := LQueryPedido.FieldByName('discount_percentage').AsFloat;
      Dados.Troco              := LQueryPedido.FieldByName('troco').AsFloat;
      Dados.Subtotal           := LQueryPedido.FieldByName('subtotal').AsFloat;
      Dados.Total              := LQueryPedido.FieldByName('total').AsFloat;
      Dados.Mesa               := LQueryPedido.FieldByName('mesa').AsInteger;
      Dados.Comanda            := LQueryPedido.FieldByName('comanda').AsInteger;

      if LQueryPedido.FieldByName('status').AsString.ToUpper.Equals('ABERTO') then
        Dados.Status := TStatusPedido.stAberto
      else if LQueryPedido.FieldByName('status').AsString.ToUpper.Equals('FECHADO') then
        Dados.Status := TStatusPedido.stFechado;

    end;
  finally
    FreeAndNil(LQueryPedido);
  end;
end;

procedure TDAOPedido.CarregarDadosPeloNumeroMesa(const AMesa: Integer);
begin
  FPedido.Limpar;
  var LQueryPedido        := TFDQuery.Create(nil);
  LQueryPedido.Connection := FConexao;
  try
    LQueryPedido.Close;
    LQueryPedido.SQL.Clear;
    LQueryPedido.SQL.Add('select * from "order"');
    LQueryPedido.SQL.Add('where mesa = :mesa and Upper(status) = Upper(:status)');
    LQueryPedido.SQL.Add('order by created_at desc');
    LQueryPedido.SQL.Add('limit 1');
    LQueryPedido.ParamByName('mesa').AsInteger := AMesa;
    LQueryPedido.ParamByName('status').AsString := 'ABERTO';
    LQueryPedido.Open();
    if LQueryPedido.RecordCount > 0 then
    begin
      Dados.Id                 := LQueryPedido.FieldByName('id').AsInteger;
      Dados.EmpresaId          := LQueryPedido.FieldByName('company_id').AsString;
      Dados.UsuarioId          := LQueryPedido.FieldByName('user_id').AsString;
      Dados.ClienteId          := LQueryPedido.FieldByName('customer_id').AsString;
      Dados.TypeOrder          := LQueryPedido.FieldByName('type_order').AsInteger;
      Dados.CpfCnpj            := LQueryPedido.FieldByName('cpf_cnpj').AsString;
      Dados.DescontoValor      := LQueryPedido.FieldByName('discount_value').AsFloat;
      Dados.DescontoPorcentage := LQueryPedido.FieldByName('discount_percentage').AsFloat;
      Dados.Troco              := LQueryPedido.FieldByName('troco').AsFloat;
      Dados.Subtotal           := LQueryPedido.FieldByName('subtotal').AsFloat;
      Dados.Total              := LQueryPedido.FieldByName('total').AsFloat;
      Dados.Mesa               := LQueryPedido.FieldByName('mesa').AsInteger;
      Dados.Comanda            := LQueryPedido.FieldByName('comanda').AsInteger;

      if LQueryPedido.FieldByName('status').AsString.ToUpper.Equals('ABERTO') then
        Dados.Status := TStatusPedido.stAberto
      else if LQueryPedido.FieldByName('status').AsString.ToUpper.Equals('FECHADO') then
        Dados.Status := TStatusPedido.stFechado;
    end;

  finally
    FreeAndNil(LQueryPedido);
  end;
end;

constructor TDAOPedido.Create(const AConexao:TFDConnection);
begin
  FConexao        := AConexao;
  FPedido         := TPedido.Create;
  FPedido.Status  := TStatusPedido.stAberto;
end;

destructor TDAOPedido.Destroy;
begin
  FreeAndNil(FPedido);
  inherited;
end;

procedure TDAOPedido.Gravar;
begin
  var LQuerySelectMax        := TFDQuery.Create(nil);
  LQuerySelectMax.Connection := ModelConnection.Connection;
  try
    LQuerySelectMax.Close;
    LQuerySelectMax.SQL.Clear;
    LQuerySelectMax.SQL.Add('select COALESCE(max(id),0) +1 as ID from "order"');
    LQuerySelectMax.Open();
    Dados.Id := LQuerySelectMax.FieldByName('id').AsInteger;
  finally
    FreeAndNil(LQuerySelectMax);
  end;

  var LQueryPedido        := TFDQuery.Create(nil);
  LQueryPedido.Connection := ModelConnection.Connection;
  try
    LQueryPedido.Close;
    LQueryPedido.SQL.Clear;
    LQueryPedido.SQL.Add('INSERT INTO "order"');
    LQueryPedido.SQL.Add('(id, company_id, user_id, customer_id, type_order,');
    LQueryPedido.SQL.Add('cpf_cnpj, discount_value, discount_percentage, troco, subtotal,');
    LQueryPedido.SQL.Add('total, created_at, updated_at, status,mesa, comanda,sync)');
    LQueryPedido.SQL.Add('VALUES(:id, :company_id, :user_id, :customer_id,');
    LQueryPedido.SQL.Add(':type_order, :cpf_cnpj, :discount_value, :discount_percentage,');
    LQueryPedido.SQL.Add(':troco, :subtotal, :total, :created_at, :updated_at, :status,');
    LQueryPedido.SQL.Add(':mesa,:comanda, :sync);');
    LQueryPedido.ParamByName('id').AsInteger                := Dados.Id;
    LQueryPedido.ParamByName('company_id').AsString         := Dados.EmpresaId;
    LQueryPedido.ParamByName('user_id').AsString            := Dados.UsuarioId;
    LQueryPedido.ParamByName('customer_id').AsString        := Dados.ClienteId;
    LQueryPedido.ParamByName('type_order').AsInteger        := Dados.TypeOrder;
    LQueryPedido.ParamByName('cpf_cnpj').AsString           := Dados.CpfCnpj;
    LQueryPedido.ParamByName('discount_value').AsFloat      := Dados.DescontoValor;
    LQueryPedido.ParamByName('discount_percentage').AsFloat := Dados.DescontoPorcentage;
    LQueryPedido.ParamByName('troco').AsFloat               := Dados.Troco;
    LQueryPedido.ParamByName('subtotal').AsFloat            := Dados.Subtotal;
    LQueryPedido.ParamByName('total').AsFloat               := Dados.Total;
    LQueryPedido.ParamByName('created_at').AsString         := DateTimeToStr(Now);
    LQueryPedido.ParamByName('updated_at').AsString         := DateTimeToStr(Now);
    LQueryPedido.ParamByName('status').AsString             := Dados.StatusString;
    LQueryPedido.ParamByName('mesa').AsInteger              := Dados.Mesa;
    LQueryPedido.ParamByName('comanda').AsInteger           := Dados.Comanda;
    LQueryPedido.ParamByName('sync').AsInteger              := -1;
    LQueryPedido.ExecSQL;
  finally
     FreeAndNil(LQueryPedido);
  end;
end;


procedure TPedido.Limpar;
begin
  FId                 := 0;
  FEmpresaId          := EmptyStr;
  FUsuarioId          := EmptyStr;
  FClienteId          := EmptyStr;
  FTypeOrder          := 0;
  FCpfCnpj            := EmptyStr;
  FDescontoValor      := 0;
  FDescontoPorcentage := 0;
  FTroco              := 0;
  FSubtotal           := 0;
  FTotal              := 0;
  FMesa               := 0;
  FComanda            := 0;
  FStatus             := TStatusPedido.stAberto;
end;

function TDAOPedido.ListaMesasAbertas: TList<TPedido>;
begin
  Result := TList<TPedido>.Create;
  FPedido.Limpar;
  var LQueryPedido        := TFDQuery.Create(nil);
  LQueryPedido.Connection := FConexao;
  try
    LQueryPedido.Close;
    LQueryPedido.SQL.Clear;
    LQueryPedido.SQL.Add('select * from "order"');
    LQueryPedido.SQL.Add('where mesa > :mesa and Upper(status) = Upper(:status)');
    LQueryPedido.SQL.Add('and company_id = :company_id');
    LQueryPedido.SQL.Add('order by created_at desc');
    LQueryPedido.ParamByName('mesa').AsInteger      := 0;
    LQueryPedido.ParamByName('status').AsString     := 'ABERTO';
    LQueryPedido.ParamByName('company_id').AsString := TModelStaticCredencial.GetInstance.Company;
    LQueryPedido.Open();
    LQueryPedido.First;
    while not (LQueryPedido.Eof) do
    begin
      var LPedido                := TPedido.Create;
      LPedido.Id                 := LQueryPedido.FieldByName('id').AsInteger;
      LPedido.EmpresaId          := LQueryPedido.FieldByName('company_id').AsString;
      LPedido.UsuarioId          := LQueryPedido.FieldByName('user_id').AsString;
      LPedido.ClienteId          := LQueryPedido.FieldByName('customer_id').AsString;
      LPedido.TypeOrder          := LQueryPedido.FieldByName('type_order').AsInteger;
      LPedido.CpfCnpj            := LQueryPedido.FieldByName('cpf_cnpj').AsString;
      LPedido.DescontoValor      := LQueryPedido.FieldByName('discount_value').AsFloat;
      LPedido.DescontoPorcentage := LQueryPedido.FieldByName('discount_percentage').AsFloat;
      LPedido.Troco              := LQueryPedido.FieldByName('troco').AsFloat;
      LPedido.Subtotal           := LQueryPedido.FieldByName('subtotal').AsFloat;
      LPedido.Total              := LQueryPedido.FieldByName('total').AsFloat;
      LPedido.Mesa               := LQueryPedido.FieldByName('mesa').AsInteger;
      LPedido.Comanda            := LQueryPedido.FieldByName('comanda').AsInteger;
      LPedido.CreateAt           := StrToDateTime(LQueryPedido.FieldByName('created_at').AsString);

      if LQueryPedido.FieldByName('status').AsString.ToUpper.Equals('ABERTO') then
        LPedido.Status := TStatusPedido.stAberto
      else if LQueryPedido.FieldByName('status').AsString.ToUpper.Equals('FECHADO') then
        LPedido.Status := TStatusPedido.stFechado;
      Result.Add(LPedido);
      LQueryPedido.Next;
    end;
  finally
    FreeAndNil(LQueryPedido);
  end;
end;


procedure Tpedido.SetStatus(const Value: TStatusPedido);
begin
  FStatus := Value;
end;

function TPedido.StatusString: string;
begin
  case FStatus of
    stAberto: Result := 'ABERTO';
    stFechado: Result := 'FECHADO';
  end;
end;

procedure TDAOPedido.UpdateIdOrderApi(const AIdOrderApi: string);
begin
  var LQueryPedido        := TFDQuery.Create(nil);
  LQueryPedido.Connection := ModelConnection.Connection;
  try
    ModelConnection.Connection.StartTransaction;
    try
      LQueryPedido.Close;
      LQueryPedido.SQL.Clear;
      LQueryPedido.SQL.Add('UPDATE INTO "order"');
      LQueryPedido.SQL.Add('set id_order_api = :id_order_api ');
      LQueryPedido.SQL.Add('where id = :id');
      LQueryPedido.ParamByName('id').AsInteger          := Dados.Id;
      LQueryPedido.ParamByName('id_order_api').AsString := AIdOrderApi;
      LQueryPedido.ExecSQL;
    except on E: Exception do
      begin
        ModelConnection.Connection.Rollback;
        raise Exception.Create(e.Message);
      end;
    end;
  finally
     FreeAndNil(LQueryPedido);
  end;
end;

procedure TDAOPedido.UpdateSync(const AIdOrder, ASync: Integer);
begin
  var LQueryPedido        := TFDQuery.Create(nil);
  LQueryPedido.Connection := ModelConnection.Connection;
  try
    LQueryPedido.Close;
    LQueryPedido.SQL.Clear;
    LQueryPedido.SQL.Add('update "order" set');
    LQueryPedido.SQL.Add('sync = :sync');
    LQueryPedido.SQL.Add('where id = :id and company_id = :company_id');
    LQueryPedido.ParamByName('id').AsInteger                := Dados.Id;
    LQueryPedido.ParamByName('company_id').AsString         := Dados.EmpresaId;
    LQueryPedido.ParamByName('sync').AsInteger              := ASync;
    LQueryPedido.ExecSQL;
  finally
     FreeAndNil(LQueryPedido);
  end;
end;

end.
