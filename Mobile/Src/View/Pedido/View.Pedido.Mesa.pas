unit View.Pedido.Mesa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Effects,
  FMX.Filter.Effects, Helper.Scroll, Frame.Pedido.Mesa, View.Pedido, DAO.Pedido,
  Model.Connection, Model.Enums, Model.Static.Credencial;

type
  TViewPedidoMesa = class(TViewBase)
    ScrollBox: TVertScrollBox;
    recToolbar: TRectangle;
    lblCaptionToolbar: TLabel;
    imgVoltar: TImage;
    FillRGBEffect1: TFillRGBEffect;
    procedure imgVoltarClick(Sender: TObject);
  private
    FViewPedido:TViewPedido;
    procedure CriarMesas;
    procedure OnClickMesa(Sender:TObject);
    procedure AtualizarMesas;
  public
    procedure ExecuteOnShow; override;
  end;

var
  ViewPedidoMesa: TViewPedidoMesa;

implementation

{$R *.fmx}

{ TViewPedidoMesa }

procedure TViewPedidoMesa.AtualizarMesas;
begin
  for var X := 0 to Pred(ScrollBox.Content.ControlsCount) do
  begin
    if ScrollBox.Content.Controls[X] is TFramePedidoMesa then
    begin
      var LFrame := TFramePedidoMesa(ScrollBox.Content.Controls[X]);
      LFrame.Status := stLivre;
    end;
  end;

  TMonitor.Enter(ModelConnection.Connection);
  try
    var LDaoPedido := TDAOPedido.Create(ModelConnection.Connection);
    try
      var LListaMesasAbertas := LDaoPedido.ListaMesasAbertas;
      try
        for var I :=  0 to Pred(LListaMesasAbertas.Count) do
        begin
          for var X := 0 to Pred(ScrollBox.Content.ControlsCount) do
          begin
            if ScrollBox.Content.Controls[X] is TFramePedidoMesa then
            begin
              var LFrame := TFramePedidoMesa(ScrollBox.Content.Controls[X]);
              if LFrame.NumeroMesa = LListaMesasAbertas[i].Mesa then
              begin
                LFrame.HoraQueMesaFoiAberta := LListaMesasAbertas[i].CreateAt;
                LFrame.Status := stOcupado;
              end
            end;
          end;
        end;
      finally
        FreeAndNil(LListaMesasAbertas);
      end;
    finally
      FreeAndNil(LDaoPedido);
    end;
  finally
    TMonitor.Exit(ModelConnection.Connection);
  end;
end;

procedure TViewPedidoMesa.CriarMesas;
begin
  ScrollBox.ClearItems;
  var LItemPorLinha:Integer := 1;
  var LWidthMesa:Single     := ScrollBox.Width / 3;
  var LHeight               := 120;
  var LTop:Single           := 0;
  var LQuantidadeMesa       := TModelStaticCredencial.GetInstance.QuantidadeMesa;
  for var I := 1 to LQuantidadeMesa do
  begin
    var LFrameMesa         := TFramePedidoMesa.Create(nil);
    LFrameMesa.Name        := 'Mesa'+I.ToString;
    LFrameMesa.Parent      := ScrollBox;
    LFrameMesa.NumeroMesa  := I;
    LFrameMesa.Status      := stLivre;
    LFrameMesa.OnClickMesa := OnClickMesa;
    case LItemPorLinha of
      1: LFrameMesa.Position.X := 0;
      2: LFrameMesa.Position.X := LWidthMesa;
      3: LFrameMesa.Position.X := LWidthMesa * 2;
    end;
    LFrameMesa.Position.Y := LTop;
    LFrameMesa.Height     := LHeight;
    LFrameMesa.Width      := LWidthMesa;
    if LItemPorLinha >= 3 then
    begin
      LItemPorLinha := 0;
      LTop          := + LTop + LHeight;
    end;
    Inc(LItemPorLinha);
  end;
  AtualizarMesas;
end;

procedure TViewPedidoMesa.ExecuteOnShow;
begin
  inherited;
  CriarMesas;
end;

procedure TViewPedidoMesa.imgVoltarClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TViewPedidoMesa.OnClickMesa(Sender: TObject);
begin
  if Sender is TFramePedidoMesa then
  begin
    if Assigned(FViewPedido) then
      FreeAndNil(FViewPedido);
    FViewPedido                  := TViewPedido.Create(Self);
    FViewPedido.Mesa(TFramePedidoMesa(Sender).NumeroMesa);
    FViewPedido.PedidoNegociacao := tpMesa;
    FViewPedido.AtualizarMesas   := AtualizarMesas;
    FViewPedido.Show;
  end;
end;

end.
