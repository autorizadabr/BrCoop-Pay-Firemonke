unit Services.Response.Pagination;

interface

uses
  Math,
  System.JSON;

type
  TServicesResponsePagination = class
  private
    FData: TJSONValue;
    FRecords: Integer;
    Flimit: Integer;
    FPage: Integer;
    function CountPages:Integer;
  public
    constructor Create;
    procedure SetPage(APage: Integer);
    procedure SetLimit(ALimit: Integer);
    procedure SetData(AData: TJSONValue);
    procedure SetRecords(const ARecord: Integer);
    function Content: TJSONObject;
  end;

implementation

{ TServicesResponsePagination }

function TServicesResponsePagination.Content: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('data', FData);
  Result.AddPair('current_page', FPage);
  Result.AddPair('count_page', CountPages);
  var LRecordOfpage:Integer := Flimit;
  if FPage >= CountPages then
  begin
    var LRecordsVisible := (FPage - 1) * Flimit;
    LRecordOfpage := (FRecords -  LRecordsVisible);
    if LRecordOfpage < 0 then
    begin
      LRecordOfpage := 0;
    end;
  end;
  Result.AddPair('record_of_page', LRecordOfpage);
  Result.AddPair('count_record', FRecords);
end;

function TServicesResponsePagination.CountPages: Integer;
begin
  Result := 1;
  if (FRecords > 0) and (Flimit > 0) then
  begin
    Result :=  Ceil(FRecords / Flimit);
  end;
end;

constructor TServicesResponsePagination.Create;
begin
  FRecords := 0;
  Flimit   := 0;
  FPage    := 0;
end;

procedure TServicesResponsePagination.SetData(AData: TJSONValue);
begin
  FData := AData;
end;

procedure TServicesResponsePagination.SetLimit(ALimit: Integer);
begin
  Flimit := ALimit;
end;

procedure TServicesResponsePagination.SetRecords(const ARecord: Integer);
begin
  FRecords := ARecord;
end;

procedure TServicesResponsePagination.SetPage(APage: Integer);
begin
  FPage := APage;
end;

end.
