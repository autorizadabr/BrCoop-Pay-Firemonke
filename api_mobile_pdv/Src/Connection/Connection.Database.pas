unit Connection.Database;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PGDef, FireDAC.Phys.PG,
  FireDAC.Comp.UI, FireDAC.Phys.MSAcc, FireDAC.Phys.MSAccDef;

type
  TConnectionDatabase = class(TDataModule)
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDConnection: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TConnectionDatabase.DataModuleCreate(Sender: TObject);
begin
  FDPhysPgDriverLink.VendorHome  := ExtractFilePath(ParamStr(0));
  FDConnection.ConnectionDefName := 'coop_pay';
  FDConnection.Connected := True;
end;
end.
