unit View.Base.Crud;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, View.Componentes.Load, View.Componentes.Mensagem,
  FMX.Controls.Presentation, FMX.Effects, FMX.Filter.Effects, FMX.Objects,
  System.JSON,
  View.List.Base, View.List.Vertical, View.Edit.Pesquisa, FMX.Layouts ;

type
  TViewBaseCrud = class(TViewBase)
    edtPesquisa: TViewEditPesquisa;
    ViewListVertical: TViewListVertical;
    procedure edtPesquisaimgPesquisaTap(Sender: TObject; const Point: TPointF);
    procedure edtPesquisaimgPesquisaClick(Sender: TObject);
    procedure edtPesquisaimgClearTap(Sender: TObject; const Point: TPointF);
    procedure edtPesquisaimgClearClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  protected
    procedure Load;overload;virtual;
    procedure Load(AJSONArray:TJSONArray);overload;virtual;
  public

  end;

var
  ViewBaseCrud: TViewBaseCrud;

implementation

{$R *.fmx}

{ TViewBase1 }

procedure TViewBaseCrud.Load(AJSONArray: TJSONArray);
begin

end;

procedure TViewBaseCrud.edtPesquisaimgClearClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  edtPesquisaimgClearTap(Sender,TPointF.Create(0,0));
  {$ENDIF}
end;

procedure TViewBaseCrud.edtPesquisaimgClearTap(Sender: TObject;
  const Point: TPointF);
begin
  edtPesquisa.Edit.Text := EmptyStr;
  Load;
end;

procedure TViewBaseCrud.edtPesquisaimgPesquisaClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  edtPesquisaimgPesquisaTap(Sender,TPointF.Create(0,0));
  {$ENDIF}
end;

procedure TViewBaseCrud.edtPesquisaimgPesquisaTap(Sender: TObject;
  const Point: TPointF);
begin
  inherited;
  Load;
end;

procedure TViewBaseCrud.FormShow(Sender: TObject);
begin
  inherited;
  Load;
end;

procedure TViewBaseCrud.Load;
begin

end;

end.
