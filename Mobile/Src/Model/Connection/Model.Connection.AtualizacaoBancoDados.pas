unit Model.Connection.AtualizacaoBancoDados;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf,System.Classes,
  FireDAC.DApt, FireDAC.Comp.DataSet,
  System.Generics.Collections,
  System.SysUtils;

type
  TAtualizacaoBancoDados = record
    Versao: Currency;
    Scripts: TArray<String>;
  end;

type
  TModelConnectionAtualizacaoBancoDados = class
  private
    FListaAtualizacaoBancoDados: TList<TAtualizacaoBancoDados>;
    FConexao:TFDConnection;
    FDCommand: TFDCommand;
    procedure CriarVersao_0_1;
  public
    constructor Create(AConexao:TFDConnection);
    destructor Destroy; override;
    function Lista:TList<TAtualizacaoBancoDados>;
    procedure AtualizarBancoScript;
  end;

implementation

{ TModelConnectionAtualizacaoBancoDados }

constructor TModelConnectionAtualizacaoBancoDados.Create(AConexao:TFDConnection);
begin
  FConexao             := AConexao;
  FDCommand            :=  TFDCommand.Create(nil);
  FDCommand.Connection := FConexao;

  FListaAtualizacaoBancoDados := TList<TAtualizacaoBancoDados>.Create;
  CriarVersao_0_1;
end;

procedure TModelConnectionAtualizacaoBancoDados.CriarVersao_0_1;
begin
  var LAtualizacaoBancoDados:TAtualizacaoBancoDados;
  LAtualizacaoBancoDados.Versao := 0.1;
  SetLength(LAtualizacaoBancoDados.Scripts,10);
  LAtualizacaoBancoDados.Scripts[0] :=
//'DROP table cart; '+
'DROP table cart; '+
'DROP table cart_itens; '+
'DROP table cart_payment; '+
'DROP table config_database; '+
'DROP table "order"; '+
'DROP table order_itens; '+
'DROP table order_payment; '+
'DROP table update_database; '+
'DROP table VERSION; ';
  LAtualizacaoBancoDados.Scripts[1] := 'CREATE TABLE cart ('+
'id TEXT,'+
'company_id TEXT,'+
'user_id TEXT,'+
'customer_id TEXT,'+
'type_order INTEGER,'+
'cpf_cnpj TEXT,'+
'addition REAL DEFAULT (0),'+
'discount REAL DEFAULT (0),'+
'troco REAL DEFAULT (0),'+
'subtotal REAL DEFAULT (0),'+
'total REAL DEFAULT (0),'+
'created_at TEXT,'+
'updated_at TEXT, comanda INTEGER, mesa INTEGER, nome_cliente TEXT,'+
'CONSTRAINT order_pk PRIMARY KEY (id)'+
');';

  LAtualizacaoBancoDados.Scripts[2] := 'CREATE TABLE "cart_itens" ('+
'id text NOT NULL,'+
'number_item int4 NOT NULL,'+
'order_id text NOT NULL,'+
'product_id text NOT NULL,'+
'amount real NULL DEFAULT 0,'+
'discount_value real NULL DEFAULT 0,'+
'discount_percentage real NULL DEFAULT 0,'+
'cfop text NULL,'+
'origin text NULL,'+
'csosn_cst text NULL,'+
'cst_pis text NULL,'+
'ppis real NULL DEFAULT 0,'+
'vpis real NULL DEFAULT 0,'+
'cst_cofins text NULL,'+
'pcofins real NULL DEFAULT 0,'+
'vcofins real NULL DEFAULT 0,'+
'subtotal real NULL DEFAULT 0,'+
'total real NULL DEFAULT 0,'+
'created_at text NOT NULL,'+
'updated_at text NULL,'+
'valor_unitario REAL,'+
'observation TEXT,'+
'CONSTRAINT cart_itens_pk PRIMARY KEY (id));';

  LAtualizacaoBancoDados.Scripts[3] := 'CREATE TABLE cart_payment ('+
'id INTEGER NOT NULL,'+
'order_id int4 NOT NULL,'+
'payment_id TEXT NOT NULL,'+
'nsu TEXT NOT NULL,'+
'autorization_code TEXT NULL,'+
'date_time_autorization TEXT NULL,'+
'flag TEXT NULL,'+
'amount_paid REAL NULL DEFAULT 0,'+
'created_at TEXT NOT NULL,'+
'updated_at TEXT NULL);';

  LAtualizacaoBancoDados.Scripts[4] := 'CREATE TABLE config_database ('+
'current_version TEXT);';

  LAtualizacaoBancoDados.Scripts[5] := 'CREATE TABLE "order"('+
'id INTEGER NOT NULL,'+
'company_id text NOT NULL,'+
'user_id text NOT NULL,'+
'customer_id text NOT NULL,'+
'type_order INTEGER NOT NULL,'+
'cpf_cnpj text NULL,'+
'discount_percentage real NULL DEFAULT 0,'+
'discount_value real NULL DEFAULT 0,'+
'troco real NULL DEFAULT 0,'+
'subtotal real NULL DEFAULT 0,'+
'total real NULL DEFAULT 0,'+
'created_at text NOT NULL,'+
'updated_at text NULL, '+
'sync Integer  NOT NULL DEFAULT 0, id_order_api TEXT, comanda INTEGER, mesa INTEGER, status TEXT,'+
'CONSTRAINT order_pk PRIMARY KEY (id));';

  LAtualizacaoBancoDados.Scripts[6] := 'CREATE TABLE "order_itens" ('+
'id INTEGER NOT NULL,'+
'number_item int4 NOT NULL,'+
'order_id text NOT NULL,'+
'product_id text NOT NULL,'+
'amount real NULL DEFAULT 0,'+
'discount_value real NULL DEFAULT 0,'+
'discount_percentage real NULL DEFAULT 0,'+
'cfop text NULL,'+
'origin text NULL,'+
'csosn_cst text NULL,'+
'cst_pis text NULL,'+
'ppis real NULL DEFAULT 0,'+
'vpis real NULL DEFAULT 0,'+
'cst_cofins text NULL,'+
'pcofins real NULL DEFAULT 0,'+
'vcofins real NULL DEFAULT 0,'+
'subtotal real NULL DEFAULT 0,'+
'total real NULL DEFAULT 0,'+
'valor_unitario real NULL DEFAULT 0,'+
'observation TEXT NULL,'+
'created_at text NOT NULL,'+
'updated_at text NULL,'+
'id_order_item_api text NULL,'+
'user_id TEXT,'+
'comanda INTEGER default(0),'+
'descricao TEXT,'+
'sync INTEGER DEFAULT (0),'+
'CONSTRAINT order_itens_pk PRIMARY KEY (id));';

  LAtualizacaoBancoDados.Scripts[7] := 'CREATE TABLE order_payment ('+
'id INTEGER NOT NULL,'+
'order_id TEXT NOT NULL,'+
'payment_id TEXT NOT NULL,'+
'nsu TEXT NOT NULL,'+
'autorization_code TEXT NULL,'+
'date_time_autorization TEXT NULL,'+
'flag TEXT NULL,'+
'amount_paid REAL NULL DEFAULT 0,'+
'created_at TEXT NOT NULL,'+
'updated_at TEXT NULL'+
', id_order_payment_Api TEXT, sync INTEGER DEFAULT (0));';

  LAtualizacaoBancoDados.Scripts[8] := 'CREATE TABLE update_database ('+
'version TEXT,'+
'created_at TEXT);';
  LAtualizacaoBancoDados.Scripts[9] := 'CREATE TABLE VERSION (version_number INTEGER);';

  FListaAtualizacaoBancoDados.Add(LAtualizacaoBancoDados);
end;

destructor TModelConnectionAtualizacaoBancoDados.Destroy;
begin
  FreeAndNil(FConexao);
  FreeAndNil(FListaAtualizacaoBancoDados);
  inherited;
end;

function TModelConnectionAtualizacaoBancoDados.Lista: TList<TAtualizacaoBancoDados>;
begin
  Result := FListaAtualizacaoBancoDados;
end;

procedure TModelConnectionAtualizacaoBancoDados.AtualizarBancoScript;
begin
  var LQuery := TFDQuery.Create(nil);
  LQuery.Connection := FConexao;
  try
    LQuery.Close;
    LQuery.SQL.Clear;
    LQuery.SQL.Add('select * from config_database');
    LQuery.Open();

    var LVersao:Currency := 0;
    if LQuery.RecordCount > 0 then
    begin
      LVersao := StrToCurrDef(LQuery.FieldByName('current_version').AsString.Replace('.',','),0);
    end
    else
    begin
      LQuery.Close;
      LQuery.SQL.Clear;
      LQuery.SQL.Add('insert into config_database (current_version) values(:current_version)');
      LQuery.ParamByName('current_version').AsCurrency := 0;
      LQuery.ExecSQL;
    end;

    try
      for var I := 0 to Pred(FListaAtualizacaoBancoDados.Count) do
      begin
        if LVersao < FListaAtualizacaoBancoDados[I].Versao then
        begin
          for var X := Low(FListaAtualizacaoBancoDados[I].Scripts) to high(FListaAtualizacaoBancoDados[I].Scripts) do
          begin
            FDCommand.CommandText.Clear;
            FDCommand.CommandText.Add(FListaAtualizacaoBancoDados[I].Scripts[x]);
            FDCommand.Execute();
          end;
          var LQueryUpdateVersao        := TFDQuery.Create(nil);
          LQueryUpdateVersao.Connection := FConexao;
          try
            LQueryUpdateVersao.Close;
            LQueryUpdateVersao.SQL.Clear;
            LQueryUpdateVersao.SQL.Add('update config_database set current_version = :current_version');
            LQueryUpdateVersao.ParamByName('current_version').AsCurrency := FListaAtualizacaoBancoDados[I].Versao;
            LQueryUpdateVersao.ExecSQL;
          finally
            FreeAndNil(LQueryUpdateVersao);
          end;

        end;
      end;

    except on E: Exception do
    end;

  finally
    LQuery.Free;
  end;
end;

end.
