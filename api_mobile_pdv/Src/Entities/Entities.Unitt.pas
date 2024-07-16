unit Entities.Unitt;

interface

uses Entities.Base;

type
  TEntititesUnitt = class(TEntitiesBase)
  private
    FSigra: string;
    FDescription: string;
    FActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetDescription(const Value: string);
    procedure SetSigra(const Value: string);
  public
    property Description: string read FDescription write SetDescription;
    property Sigra: string read FSigra write SetSigra;
    property Active: Boolean read FActive write SetActive;

  end;

implementation

{ TEntititesUnitt }

procedure TEntititesUnitt.SetActive(const Value: Boolean);
begin
  FActive := Value;
end;

procedure TEntititesUnitt.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TEntititesUnitt.SetSigra(const Value: string);
begin
  FSigra := Value;
end;

end.
