unit Frame.Pagamento.Vendedor;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, System.JSON,
  Helper.Scroll, System.Generics.Collections,
  Frame.Pagamento.Vendedor.Item, Model.Static.Usuario;

type
  TFramePagamentoVendedor = class(TFrame)
    recBase: TRectangle;
    recPrincipal: TRectangle;
    layButtons: TLayout;
    lblCancelar: TLabel;
    layValorFaltaReceber: TLayout;
    lblCaption: TLabel;
    VertScrollBox: TVertScrollBox;
    procedure lblCancelarClick(Sender: TObject);
  private
    FEventoDepoisDeSelecionarVendedor: TProc<string>;
    procedure OnClickVendedor(Sender:TObject);
  public
    procedure BuscarVendedores;
    procedure CloseVendedor;
    procedure OpenVendedor;
    property EventoDepoisDeSelecionarVendedor:TProc<string> read FEventoDepoisDeSelecionarVendedor write FEventoDepoisDeSelecionarVendedor;
  end;

implementation

{$R *.fmx}

{ TFramePagamentoVendedor }

procedure TFramePagamentoVendedor.BuscarVendedores;
begin

  VertScrollBox.ClearItems;
  var LJsonArrayUsuario := TModelStaticUsuario.JSONArrayUsuarios;
  if Assigned(LJsonArrayUsuario) then
  begin
    var LTop:Single := 0;
    for var I := 0 to Pred(LJsonArrayUsuario.Count) do
    begin
      var LJSONObjetoItem    := LJsonArrayUsuario.Items[I] as TJSONObject;
      var LFrameItem         := TFramePagamentoVendedorItem.Create(nil);
      LFrameItem.Parent      := VertScrollBox;
      LFrameItem.Position.X  := 0;
      LFrameItem.Position.Y  := LTop;
      LFrameItem.Id          := LJSONObjetoItem.GetValue<string>('id','');
      LFrameItem.Nome        := LJSONObjetoItem.GetValue<string>('name','');
      LFrameItem.OnClickItem := OnClickVendedor;
      LTop                   := LTop + LFrameItem.Height;
    end;
  end;
end;

procedure TFramePagamentoVendedor.CloseVendedor;
begin
  Self.Visible := False;
end;

procedure TFramePagamentoVendedor.lblCancelarClick(Sender: TObject);
begin
  CloseVendedor;
end;

procedure TFramePagamentoVendedor.OnClickVendedor(Sender: TObject);
begin
  if Sender is TFramePagamentoVendedorItem then
  begin
    CloseVendedor;
    if Assigned(FEventoDepoisDeSelecionarVendedor) then
      FEventoDepoisDeSelecionarVendedor(TFramePagamentoVendedorItem(Sender).Id);
  end;
end;

procedure TFramePagamentoVendedor.OpenVendedor;
begin
  Self.Visible := True;
end;

end.
