unit View.Step;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation;

type
  TViewStep = class(TFrame)
    recBase: TRectangle;
    layDadosEmpresa: TLayout;
    layEnderecoEmpresa: TLayout;
    layDadosAcesso: TLayout;
    circleDadosEmpresa: TCircle;
    layDescricaoDadosEmpresa: TLayout;
    lblDadosEmpresa: TLabel;
    recProgressDadosEmpresa: TRectangle;
    imgCircleDadosEmpresa: TImage;
    CircleEnderecoEmpresa: TCircle;
    imgEnderecoEmpresa: TImage;
    layDescricaoEnderecoEmpresa: TLayout;
    lblEnderecoEmpresa: TLabel;
    recProgressEnderecoEmpresa: TRectangle;
    CircleDadosAcesso: TCircle;
    imgDadosAcesso: TImage;
    layDescricaoDadosAcesso: TLayout;
    lblDadosAcesso: TLabel;
    recProgressDadosAcesso: TRectangle;
    layFinal: TLayout;
    CircleFinal: TCircle;
    Image1: TImage;
    layCircleDadosAcesso: TLayout;
    layCircleDadosEmpresa: TLayout;
    layCircleDescricaoEnderecoEmpresa: TLayout;
    Label1: TLabel;
    Layout1: TLayout;
    procedure FrameResize(Sender: TObject);
  private
    const
    COR_NAO_ATIVA = $FFF0F0F0;
    COR_ATIVA = $FF1F41BB;
    procedure StepActive(ALayout:TLayout; ABool:Boolean);
  public
    procedure ProgressDadosDaEmpresa;
    procedure ProgressEnderecoDaEmpresa;
    procedure ProgressDadosDeAcesso;
    procedure ProgressFinal;
  end;

implementation

{$R *.fmx}

procedure TViewStep.FrameResize(Sender: TObject);
begin
  var LWidth := (recBase.Width - 50);
  LWidth := (LWidth/3);
  layDadosEmpresa.Width    := LWidth;
  layEnderecoEmpresa.Width := LWidth;
  layDadosAcesso.Width     := LWidth;

  recProgressDadosEmpresa.Align := TAlignLayout.Center;
  recProgressEnderecoEmpresa.Align := TAlignLayout.Center;
  recProgressDadosAcesso.Align := TAlignLayout.Center;


  recProgressDadosEmpresa.Align := TAlignLayout.Scale;
  recProgressEnderecoEmpresa.Align := TAlignLayout.Scale;
  recProgressDadosAcesso.Align := TAlignLayout.Scale;

  recProgressDadosEmpresa.Position.X    := -10;
  recProgressEnderecoEmpresa.Position.X := -10;
  recProgressDadosAcesso.Position.X     := -10;

//  recProgressDadosEmpresa.Position.Y    := recProgressDadosEmpresa.Position.Y - 5;
//  recProgressEnderecoEmpresa.Position.Y := recProgressEnderecoEmpresa.Position.Y - 5;
//  recProgressDadosAcesso.Position.y     := recProgressDadosAcesso.Position.y - 5;

  recProgressDadosEmpresa.Width    := layDescricaoDadosEmpresa.Width +18;
  recProgressEnderecoEmpresa.Width := layDescricaoEnderecoEmpresa.Width +18;
  recProgressDadosAcesso.Width     := layDescricaoDadosAcesso.Width +18;

end;

procedure TViewStep.ProgressDadosDaEmpresa;
begin
  StepActive(layDadosEmpresa,True);
  StepActive(layEnderecoEmpresa,False);
  StepActive(layDadosAcesso,False);
  StepActive(layFinal,False);
end;

procedure TViewStep.ProgressDadosDeAcesso;
begin
  StepActive(layDadosEmpresa,True);
  StepActive(layEnderecoEmpresa,True);
  StepActive(layDadosAcesso,True);
  StepActive(layFinal,False);
end;

procedure TViewStep.ProgressEnderecoDaEmpresa;
begin
  StepActive(layDadosEmpresa,True);
  StepActive(layEnderecoEmpresa,True);
  StepActive(layDadosAcesso,False);
  StepActive(layFinal,False);
end;

procedure TViewStep.ProgressFinal;
begin
  StepActive(layDadosEmpresa,True);
  StepActive(layEnderecoEmpresa,True);
  StepActive(layDadosAcesso,True);
  StepActive(layFinal,True);
end;

procedure TViewStep.StepActive(ALayout: TLayout; ABool: Boolean);
begin
  var LColor := COR_NAO_ATIVA;
  if ABool then
  begin
    LColor := COR_ATIVA;
  end;

  if ALayout.Equals(layDadosEmpresa) then
  begin
    circleDadosEmpresa.Fill.Color := LColor;
    recProgressDadosEmpresa.Fill.Color := LColor;
  end
  else if ALayout.Equals(layEnderecoEmpresa) then
  begin
    CircleEnderecoEmpresa.Fill.Color := LColor;
    recProgressEnderecoEmpresa.Fill.Color := LColor;
  end
  else if ALayout.Equals(layDadosAcesso) then
  begin
    CircleDadosAcesso.Fill.Color := LColor;
    recProgressDadosAcesso.Fill.Color := LColor;
  end
  else if ALayout.Equals(layFinal) then
  begin
    CircleFinal.Fill.Color := LColor;
  end;

end;

end.
