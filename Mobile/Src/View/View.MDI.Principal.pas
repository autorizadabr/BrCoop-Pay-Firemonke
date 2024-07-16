unit View.MDI.Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  View.Base, View.Principal, View.Categoria, View.Unidade.Medida, View.Cliente,
  View.Produto;

type
  TViewMDIPrincipal = class(TForm)
    layView: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FObject: TFmxObject;
    FViewPrincipal:TViewPrincipal;
    FViewCategoria:TViewCategoria;
    FViewUnidadeMedida:TViewUnidadeMedida;
    FViewCliente:TViewCliente;
    FViewProduto:TViewProduto;
    procedure ShowLayout(AForm: TViewBase);
    procedure OnNextFormPrincipal(Sender: TObject);
    procedure OnPriorFormPrincipal(Sender: TObject);

    procedure OnNextFormCategoria(Sender: TObject);
    procedure OnPriorFormCategoria(Sender: TObject);

    procedure OnNextFormUnidadeMedida(Sender: TObject);
    procedure OnPriorFormUnidadeMedida(Sender: TObject);

    procedure OnNextFormCliente(Sender: TObject);
    procedure OnPriorFormCliente(Sender: TObject);

    procedure OnNextFormProduto(Sender: TObject);
    procedure OnPriorFormProduto(Sender: TObject);


  public
    { Public declarations }
  end;


implementation

{$R *.fmx}

procedure TViewMDIPrincipal.FormShow(Sender: TObject);
begin
  ShowLayout(FViewPrincipal);
end;

procedure TViewMDIPrincipal.OnNextFormCategoria(Sender: TObject);
begin

end;

procedure TViewMDIPrincipal.OnNextFormPrincipal(Sender: TObject);
begin
  if FViewPrincipal.NextView = Categoria then
    ShowLayout(FViewCategoria)
  else if FViewPrincipal.NextView = UndMedida then
    ShowLayout(FViewUnidadeMedida)
  else if FViewPrincipal.NextView = Cliente then
    ShowLayout(FViewCliente)
  else if FViewPrincipal.NextView = Produto then
    ShowLayout(FViewProduto)
end;

procedure TViewMDIPrincipal.OnNextFormProduto(Sender: TObject);
begin

end;

procedure TViewMDIPrincipal.OnNextFormUnidadeMedida(Sender: TObject);
begin

end;

procedure TViewMDIPrincipal.OnPriorFormCategoria(Sender: TObject);
begin
  ShowLayout(FViewPrincipal);
end;

procedure TViewMDIPrincipal.OnNextFormCliente(Sender: TObject);
begin

end;

procedure TViewMDIPrincipal.OnPriorFormCliente(Sender: TObject);
begin
  ShowLayout(FViewPrincipal);
end;

procedure TViewMDIPrincipal.OnPriorFormPrincipal(Sender: TObject);
begin
  Close;
end;

procedure TViewMDIPrincipal.OnPriorFormProduto(Sender: TObject);
begin
  ShowLayout(FViewPrincipal);
end;

procedure TViewMDIPrincipal.OnPriorFormUnidadeMedida(Sender: TObject);
begin
  ShowLayout(FViewPrincipal);
end;

procedure TViewMDIPrincipal.ShowLayout(AForm: TViewBase);
begin
  if FObject <> nil then
  begin
    layView.RemoveObject(AForm.layView);
    FObject := nil;
  end;
  FObject := AForm;

  Self.OnClose                 := AForm.OnClose;
  Self.OnKeyUp                 := AForm.OnKeyUp;
  Self.OnVirtualKeyboardHidden := AForm.OnVirtualKeyboardHidden;
  Self.OnVirtualKeyboardShown  := AForm.OnVirtualKeyboardShown;
  Self.OnResize                := AForm.OnResize;
  layView.AddObject(AForm.layView);
  AForm.ExecuteOnShow;
end;

procedure TViewMDIPrincipal.FormCreate(Sender: TObject);
begin
  FObject := nil;
  FViewPrincipal     := TViewPrincipal.Create(Self);
  FViewCategoria     := TViewCategoria.Create(Self);
  FViewUnidadeMedida := TViewUnidadeMedida.Create(Self);
  FViewCliente       := TViewCliente.Create(Self);
  FViewProduto       := TViewProduto.Create(Self);
  FViewPrincipal.NextForm  := Self.OnNextFormPrincipal;
  FViewPrincipal.PriorForm := Self.OnPriorFormPrincipal;

  FViewCategoria.NextForm  := Self.OnNextFormCategoria;
  FViewCategoria.PriorForm := Self.OnPriorFormCategoria;

  FViewUnidadeMedida.NextForm  := Self.OnNextFormUnidadeMedida;
  FViewUnidadeMedida.PriorForm := Self.OnPriorFormUnidadeMedida;

  FViewCliente.NextForm  := Self.OnNextFormUnidadeMedida;
  FViewCliente.PriorForm := Self.OnPriorFormUnidadeMedida;

  FViewProduto.NextForm  := Self.OnNextFormProduto;
  FViewProduto.PriorForm := Self.OnPriorFormProduto;
end;

end.
