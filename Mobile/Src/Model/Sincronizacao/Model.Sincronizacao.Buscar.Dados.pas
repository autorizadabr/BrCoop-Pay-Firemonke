unit Model.Sincronizacao.Buscar.Dados;

interface
uses System.Classes, System.SysUtils, System.Types,System.SyncObjs,
  Model.Sincronizacao.Pedido, Model.Sincronizacao.Mesa,System.DateUtils;

type
  TModuloSincronizacaoBuscarDados = (mdPedido,mdMesa);
  TModelSincronizacaoBuscarDados = class(TThread)
  private
  class var Finstance:TModelSincronizacaoBuscarDados;
  const DATA_INICIAL = '01/01/2000 00:00:00';
  var
    FFimDeSincronizacao: TProc;
    FEnvent:TEvent;
    FIntervaloTempo:Cardinal;
    FModelSincronizacaoPedido:TModelSincronizacaoPedido;
    FModelSincronizacaoMesa:TModelSincronizacaoMesa;
    FModulo:TModuloSincronizacaoBuscarDados;
    FUltimaRequisicaoServidor:TDateTime;
  protected
    procedure Execute; override;
  public
    class function GetInstance:TModelSincronizacaoBuscarDados;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property IntervaloTempo:Cardinal write FIntervaloTempo;
    property Modulo:TModuloSincronizacaoBuscarDados read FModulo write FModulo;
    procedure BuscarRegistros();
    property FimDeSincronizacao:TProc read FFimDeSincronizacao write FFimDeSincronizacao;
  end;

implementation

{ TModelSincronizacaoBuscarDados }

procedure TModelSincronizacaoBuscarDados.AfterConstruction;
begin
  inherited;
  FUltimaRequisicaoServidor := StrToDateTime(DATA_INICIAL); // Umda data inicial, Nula;
  FEnvent                   := TEvent.Create;
  FIntervaloTempo           := 1000;
  FModelSincronizacaoPedido := TModelSincronizacaoPedido.Create;
  FModelSincronizacaoMesa   := TModelSincronizacaoMesa.Create;
end;

procedure TModelSincronizacaoBuscarDados.BeforeDestruction;
begin
  FreeAndNil(FEnvent);
  FreeAndNil(FModelSincronizacaoPedido);
  FreeAndNil(FModelSincronizacaoMesa);
  inherited;
end;

procedure TModelSincronizacaoBuscarDados.Execute;
var
  LWaitResult:TWaitResult;
begin
  inherited;
  while not Self.Terminated do
  begin
    LWaitResult := FEnvent.WaitFor(FIntervaloTempo);
    case LWaitResult of
      wrSignaled:FIntervaloTempo := INFINITE ;
      wrTimeout: FIntervaloTempo := INFINITE;
      else Break;
    end;

    try
      // buscar data para começar a sincronização
      if FUltimaRequisicaoServidor <= StrToDateTime(DATA_INICIAL) then
      begin
        FUltimaRequisicaoServidor := StrToDateTime('04/07/2024 00:00:00');
      end;

      FUltimaRequisicaoServidor := FModelSincronizacaoPedido.BuscarDadosServidor(FUltimaRequisicaoServidor);

      FIntervaloTempo := 2000;
    except on E: Exception do
      begin
        FIntervaloTempo := 2000;
      end;
    end;
    FEnvent.ResetEvent;
  end;
end;

class function TModelSincronizacaoBuscarDados.GetInstance: TModelSincronizacaoBuscarDados;
begin
  if not Assigned(Finstance) then
    Finstance := TModelSincronizacaoBuscarDados.Create;
  Result := Finstance;
end;

procedure TModelSincronizacaoBuscarDados.BuscarRegistros;
begin
  FEnvent.SetEvent;
end;

initialization

finalization
end.
