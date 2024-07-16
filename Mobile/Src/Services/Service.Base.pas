unit Service.Base;

interface

uses Model.Static.Credencial;
  type
  TServiceBase = class
  private
  protected
  function BaseURL:string;
  function Token:string;
  public
  end;
implementation

{ TServiceBase }

function TServiceBase.BaseURL: string;
begin
  Result := TModelStaticCredencial.GetInstance.BASEURL;
end;

function TServiceBase.Token: string;
begin
  Result := TModelStaticCredencial.GetInstance.Token;
end;

end.
