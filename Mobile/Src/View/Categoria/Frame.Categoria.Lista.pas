unit Frame.Categoria.Lista;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,System.NetEncoding,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, Helper.Circle;

type
  TFrameCategoriaLista = class(TFrame)
    recBase: TRectangle;
    Circle: TCircle;
    lblDescricao: TLabel;
    procedure FrameClick(Sender: TObject);
    procedure FrameTap(Sender: TObject; const Point: TPointF);
  private
    FDescricao: string;
    FOnClickItem: TProc<TObject>;
    FId: string;
    FImage: string;
    FSigra: string;
    FAtivo: Boolean;
    procedure SetDescricao(const Value: string);
    procedure SetOnClickItem(const Value: TProc<TObject>);
    procedure SetId(const Value: string);
  public
    procedure AfterConstruction; override;
    property Id:string read FId write SetId;
    property Descricao: string read FDescricao write SetDescricao;
    property Sigra:string read FSigra write FSigra;
    property Ativo:Boolean read FAtivo write FAtivo;
    property Image:string read FImage write FImage;
    property OnClickItem: TProc<TObject> read FOnClickItem write SetOnClickItem;
    procedure LoadImge(const ABase64:string);
  end;

implementation

{$R *.fmx}
{ TFrameCategoriaLista }

procedure TFrameCategoriaLista.AfterConstruction;
begin
  inherited;
  Circle.Fill.Bitmap.Bitmap := nil;
end;

procedure TFrameCategoriaLista.FrameClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if Assigned(FOnClickItem) then
    FOnClickItem(Self);
  {$ENDIF}
end;

procedure TFrameCategoriaLista.FrameTap(Sender: TObject; const Point: TPointF);
begin
  if Assigned(FOnClickItem) then
    FOnClickItem(Self);
end;

procedure TFrameCategoriaLista.LoadImge(const ABase64: string);
begin
  Circle.Fill.Bitmap.Bitmap := nil;
  Circle.LoadFromURLAsync(ABase64);
end;

procedure TFrameCategoriaLista.SetDescricao(const Value: string);
begin
  FDescricao := Value;
  lblDescricao.Text := FDescricao;
end;

procedure TFrameCategoriaLista.SetId(const Value: string);
begin
  FId := Value;
end;

procedure TFrameCategoriaLista.SetOnClickItem(const Value: TProc<TObject>);
begin
  FOnClickItem := Value;
end;

end.
