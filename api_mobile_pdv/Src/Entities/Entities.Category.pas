unit Entities.Category;

interface

uses
  Entities.Base, System.Classes;

type
  TEntitiesCategory = class(TEntitiesBase)
  private
    FName: string;
    FImage: TStream;
  public
    property Name: string read FName write FName;
    property Image: TStream read FImage write FImage;
  end;

implementation

{ TEntitiesCategory }

end.
