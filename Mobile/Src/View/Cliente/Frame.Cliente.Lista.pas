unit Frame.Cliente.Lista;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects;

type
  TFrameClienteLista = class(TFrame)
    recBase: TRectangle;
    lblDescricao: TLabel;
    procedure FrameClick(Sender: TObject);
    procedure FrameTap(Sender: TObject; const Point: TPointF);
  private
    FOnClickItem: TProc<TObject>;
    FId: String;
    FNome: string;
    procedure SetNome(const Value: string);
  public
    property OnClickItem:TProc<TObject> read FOnClickItem write FOnClickItem;
    property Id:String read FId write FId;
    property Nome:string read FNome write SetNome;
  end;

implementation

{$R *.fmx}

{ TFrameClienteLista }


procedure TFrameClienteLista.FrameClick(Sender: TObject);
begin
  {$IFNDEF ANDROID}
  if Assigned(FOnClickItem) then
    FOnClickItem(Self);
  {$ENDIF}
end;

procedure TFrameClienteLista.FrameTap(Sender: TObject; const Point: TPointF);
begin
  if Assigned(FOnClickItem) then
    FOnClickItem(Self);
end;

procedure TFrameClienteLista.SetNome(const Value: string);
begin
  FNome := Value;
  lblDescricao.Text := FNome;
end;

end.
