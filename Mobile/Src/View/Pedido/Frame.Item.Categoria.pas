unit Frame.Item.Categoria;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, Helper.Circle;

type
  TFrameItemCategoria = class(TFrame)
    Layout1: TLayout;
    recBase: TRectangle;
    CircleImagem: TCircle;
    lblDescricao: TLabel;
    procedure FrameClick(Sender: TObject);
    procedure FrameTap(Sender: TObject; const Point: TPointF);
  private
    FDescricao: String;
    FImagemUrl: string;
    FOnClickItem: TProc<TObject>;
    FId: string;
    procedure SetDescricao(const Value: String);
    procedure SetImagemUrl(const Value: string);
    procedure SetOnClickItem(const Value: TProc<TObject>);
    procedure SetId(const Value: string);
    { Private declarations }
  public
    property Id:string read FId write SetId;
    property Descricao:String read FDescricao write SetDescricao;
    property ImagemUrl:string read FImagemUrl write SetImagemUrl;
    property OnClickItem:TProc<TObject> read FOnClickItem write SetOnClickItem;
    procedure LimparSelecaoItem;
    procedure SelecionarItem;
  end;

implementation

{$R *.fmx}

{ TFrameItemCategoria }

procedure TFrameItemCategoria.FrameClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if Assigned(FOnClickItem) then
    FOnClickItem(Self);
  {$ENDIF}
end;

procedure TFrameItemCategoria.FrameTap(Sender: TObject; const Point: TPointF);
begin
  if Assigned(FOnClickItem) then
    FOnClickItem(Self);
end;

procedure TFrameItemCategoria.LimparSelecaoItem;
begin
  recBase.Stroke.Color := $FFBDBDBD;
end;

procedure TFrameItemCategoria.SelecionarItem;
begin
  recBase.Stroke.Color := $FF1F41BB;
end;

procedure TFrameItemCategoria.SetDescricao(const Value: String);
begin
  FDescricao := Value;
  lblDescricao.Text := FDescricao;
end;

procedure TFrameItemCategoria.SetId(const Value: string);
begin
  FId := Value;
end;

procedure TFrameItemCategoria.SetImagemUrl(const Value: string);
begin
  FImagemUrl := Value;
  CircleImagem.LoadFromURLAsync(FImagemUrl);
end;

procedure TFrameItemCategoria.SetOnClickItem(const Value: TProc<TObject>);
begin
  FOnClickItem := Value;
end;

end.
