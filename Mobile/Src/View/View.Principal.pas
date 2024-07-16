unit View.Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, View.Pedido,
  Model.Sincronizacao, View.Pedido.Mesa, Model.Sincronizacao.Buscar.Dados,
  Model.Static.Usuario, Model.Enums;
type
  TNextView = (Categoria,UndMedida,Cliente,Produto,None);
  TViewPrincipal = class(TViewBase)
    VertScrollBox: TVertScrollBox;
    Rectangle1: TRectangle;
    Image1: TImage;
    Label1: TLabel;
    GridLayout: TGridLayout;
    recCategoria: TRectangle;
    recUnidadeMedida: TRectangle;
    recCliente: TRectangle;
    recProduto: TRectangle;
    Layout1: TLayout;
    Label2: TLabel;
    lblUnidadeMedida: TLabel;
    lblCliente: TLabel;
    lblProduto: TLabel;
    recPedido: TRectangle;
    lblPedido: TLabel;
    recMesa: TRectangle;
    Label7: TLabel;
    Image2: TImage;
    imgUnidadeMedida: TImage;
    imgProduto: TImage;
    imgCliente: TImage;
    imgPedido: TImage;
    Image7: TImage;
    procedure FormResize(Sender: TObject);
    procedure recCategoriaClick(Sender: TObject);
    procedure recUnidadeMedidaClick(Sender: TObject);
    procedure recClienteClick(Sender: TObject);
    procedure recProdutoClick(Sender: TObject);
    procedure recPedidoClick(Sender: TObject);
    procedure recMesaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FNextView: TNextView;
    FViewPedido:TViewPedido;
    FViewMesa:TViewPedidoMesa;
    { Private declarations }
  public
    property NextView:TNextView read FNextView write FNextView;
    procedure ExecuteOnShow; override;
  end;


implementation

{$R *.fmx}

{ TViewPrincipal }

procedure TViewPrincipal.ExecuteOnShow;
begin
  inherited;
  TThread.CreateAnonymousThread(
  procedure
  begin
    TThread.Sleep(150);
    TThread.Synchronize(nil,
    procedure
    begin
      Self.OnResize(Self);
    end);
  end).Start;
  //TModelSincronizacaoBuscarDados.GetInstance;
end;

procedure TViewPrincipal.FormCreate(Sender: TObject);
begin
  inherited;
  TModelStaticUsuario.BuscarUsuariosPertencentesAEmpresa;
end;

procedure TViewPrincipal.FormResize(Sender: TObject);
begin
  inherited;
  GridLayout.ItemWidth := (GridLayout.Width / 2);
end;

procedure TViewPrincipal.recCategoriaClick(Sender: TObject);
begin
  inherited;
  NextView := Categoria;
  NextForm(Self);
end;


procedure TViewPrincipal.recPedidoClick(Sender: TObject);
begin
  inherited;
  if Assigned(FViewPedido) then
    FreeAndNil(FViewPedido);
  FViewPedido                            := TViewPedido.Create(Self);
  FViewPedido.PedidoNegociacao           := tpPedido;
  TModelSincronizacao.GetInstance.Modulo := TModuloSincronizacao.mdPedido;
  FViewPedido.Show;
end;

procedure TViewPrincipal.recUnidadeMedidaClick(Sender: TObject);
begin
  inherited;
  NextView := UndMedida;
  NextForm(Self);
end;

procedure TViewPrincipal.recClienteClick(Sender: TObject);
begin
  inherited;
  NextView := Cliente;
  NextForm(Self);
end;

procedure TViewPrincipal.recProdutoClick(Sender: TObject);
begin
  inherited;
  NextView := Produto;
  NextForm(Self);
end;

procedure TViewPrincipal.recMesaClick(Sender: TObject);
begin
  inherited;
  if Assigned(FViewMesa) then
    FreeAndNil(FViewMesa);
  FViewMesa := TViewPedidoMesa.Create(Self);
  TModelSincronizacao.GetInstance.Modulo := TModuloSincronizacao.mdMesa;
  FViewMesa.Show;
end;

end.
