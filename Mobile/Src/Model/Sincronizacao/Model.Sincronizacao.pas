unit Model.Sincronizacao;

interface

uses System.Classes, System.SysUtils, System.Types,System.SyncObjs,
  Model.Sincronizacao.Pedido, Model.Sincronizacao.Mesa;

type
  TModuloSincronizacao = (mdPedido,mdMesa);
  TModelSincronizacao = class(TThread)
  private
  class var Finstance:TModelSincronizacao;
  var
    FFimDeSincronizacao: TProc;
    FEnvent:TEvent;
    FIntervaloTempo:Cardinal;
    FModelSincronizacaoPedido:TModelSincronizacaoPedido;
    FModelSincronizacaoMesa:TModelSincronizacaoMesa;
    FModulo:TModuloSincronizacao;
  protected
    procedure Execute; override;
  public
    class function GetInstance:TModelSincronizacao;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property IntervaloTempo:Cardinal write FIntervaloTempo;
    property Modulo:TModuloSincronizacao read FModulo write FModulo;
    procedure NovoPedido();
    property FimDeSincronizacao:TProc read FFimDeSincronizacao write FFimDeSincronizacao;
  end;

implementation

{ TModelSincronizacao }

procedure TModelSincronizacao.AfterConstruction;
begin
  inherited;
  FEnvent                   := TEvent.Create;
  FIntervaloTempo           := 1000;
  FModelSincronizacaoPedido := TModelSincronizacaoPedido.Create;
  FModelSincronizacaoMesa   := TModelSincronizacaoMesa.Create;
end;

procedure TModelSincronizacao.BeforeDestruction;
begin
  FreeAndNil(FEnvent);
  FreeAndNil(FModelSincronizacaoPedido);
  FreeAndNil(FModelSincronizacaoMesa);
  inherited;
end;

procedure TModelSincronizacao.Execute;
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
      if FModulo = mdMesa then
      begin
        FModelSincronizacaoMesa.EnviarParaServidor;
        TThread.Synchronize(nil,
        procedure
        begin
          if Assigned(FFimDeSincronizacao) then
            FFimDeSincronizacao;
        end);
      end
      else if FModulo = mdPedido then
      begin
        FModelSincronizacaoPedido.EnviarParaServidor;
      end;
    except on E: Exception do
      begin
        FIntervaloTempo := 2000;
      end;
    end;
    FEnvent.ResetEvent;
  end;
end;

class function TModelSincronizacao.GetInstance: TModelSincronizacao;
begin
  if not Assigned(Finstance) then
    Finstance := TModelSincronizacao.Create;
  Result := Finstance;
end;

procedure TModelSincronizacao.NovoPedido;
begin
  FEnvent.SetEvent;
end;

initialization
  //TModelSincronizacao.Finstance := TModelSincronizacao.Create;
finalization

end.
