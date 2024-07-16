unit View.Unidade.Medida;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, FMX.Objects, FMX.Layouts, FMX.Edit, FMX.TabControl, FMX.Effects,
  FMX.Filter.Effects, FMX.Controls.Presentation, Frame.Categoria.Lista,
  Model.Static.Credencial, System.JSON, Helper.Scroll, View.Edit.Base,
  View.Edit.ComboBox, FMX.ListBox, View.ComboBox.Base,System.Generics.Collections,
  FMX.VirtualKeyboard,FMX.Platform;
type
  TUnidadeSelecionada = record
    Id:string;
    Description:string;
    Sigra:string;
    Active:Boolean;
    procedure Clear;
  end;
  TViewUnidadeMedida = class(TViewBase)
    recToolbar: TRectangle;
    Label2: TLabel;
    TabControl: TTabControl;
    tabLista: TTabItem;
    layTabLista: TLayout;
    tabCadastro: TTabItem;
    layTabCadastro: TLayout;
    Label6: TLabel;
    recCep: TRectangle;
    edtDescription: TEdit;
    Label1: TLabel;
    Rectangle1: TRectangle;
    edtSigra: TEdit;
    Label3: TLabel;
    edtComboBoxAtivo: TViewEditComboBox;
    imgVoltar: TImage;
    FillRGBEffect1: TFillRGBEffect;
    imgDelete: TImage;
    imgSalvar: TImage;
    FillRGBEffect2: TFillRGBEffect;
    ListBox: TListBox;
    recButtonAdicionar: TRectangle;
    Label4: TLabel;
    ShadowEffect1: TShadowEffect;
    procedure FormCreate(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
    procedure imgDeleteClick(Sender: TObject);
    procedure ListBoxItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure ListBoxViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
    procedure recButtonAdicionarClick(Sender: TObject);
    procedure recButtonAdicionarTap(Sender: TObject; const Point: TPointF);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    const LIMIT = 15;
    var
    FPaginacao:TPaginacao;
    FUnidadeSelecionada:TUnidadeSelecionada;
    FViewComboBoxAtivo:TViewComboBoxBase;
    procedure OnClickItemUnidadeMedida(Sender:TObject);
    procedure CarregarLista(const AJsonArrayCategorias:TJSONArray);
    procedure PrimeiroCarregamento;
    procedure NovaCargaDeDados;
    procedure OnClickSave;
    procedure Voltar;
    procedure Adicionar;
    procedure DeletarRegistro;
  protected
    procedure OnClickDeletarRegistro;override;
  public
    procedure ExecuteOnShow; override;
  end;


implementation

uses RESTRequest4D;
{$R *.fmx}

{ TUnidadeSelecionada }

procedure TUnidadeSelecionada.Clear;
begin
  Id          := EmptyStr;
  Description := EmptyStr;
  Sigra       := EmptyStr;
  Active      := False;
end;

{ TViewUnidadeMedida }

procedure TViewUnidadeMedida.Adicionar;
begin
  // Ativo = False
  recButtonAdicionar.Visible := False;
  edtDescription.Text := EmptyStr;
  edtSigra.Text       := EmptyStr;
  FUnidadeSelecionada.Clear;
  imgSalvar.Visible := True;
  imgDelete.Visible := False;
  TabControl.GotoVisibleTab(1);
  FViewComboBoxAtivo.SetItemByCodigo(1);
end;

procedure TViewUnidadeMedida.CarregarLista(
  const AJsonArrayCategorias: TJSONArray);
begin
  ListBox.BeginUpdate;
  if Assigned(AJsonArrayCategorias) then
  begin
    for var I := 0 to Pred(AJsonArrayCategorias.Count) do
    begin
      var LItem               := AJsonArrayCategorias.Items[i] as TJSONObject;
      var LItemListBox        := TListBoxItem.Create(ListBox);
      LItemListBox.Selectable := False;
      var LFrame              := TFrameCategoriaLista.Create(LItemListBox);
      LFrame.Name             := 'Uni'+I.ToString;
      LFrame.Id               := LItem.GetValue<string>('id','');
      LFrame.Descricao        := LItem.GetValue<string>('description','');
      LFrame.Sigra            := LItem.GetValue<string>('sigra','');
      LFrame.Ativo            := LItem.GetValue<Boolean>('active',False);
      LFrame.Circle.Visible   := False;
      LFrame.OnClickItem      := OnClickItemUnidadeMedida;
      LFrame.Width            := ListBox.Width;
      LFrame.Height           := 60;
      LItemListBox.Height     := LFrame.Height;
      LItemListBox.AddObject(LFrame);
      ListBox.AddObject(LItemListBox);
      LFrame.Align            := TAlignLayout.Client;
    end;
  end;
  ListBox.EndUpdate;
end;

procedure TViewUnidadeMedida.DeletarRegistro;
begin
  CloseDelete;
  OpenLoad;
  TThread.CreateAnonymousThread(
  procedure
  var LResponse: IResponse;
  begin
    try
      if FUnidadeSelecionada.id.IsEmpty then
        raise Exception.Create('Código do usuário não informado!');

      LResponse := TRequest.New.BaseURL(BaseURL)
        .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
        .Resource('unit/'+FUnidadeSelecionada.Id)
        .Accept('application/json')
        .Delete;

      var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
      try
        // Verificando o status code
        if LResponse.StatusCode <> 200 then
        begin
          if LResponse.StatusCode = 401 then
          begin
            raise Exception.Create('Usuário sem permissão para acessar esse recurso!');
          end;
          raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
        end;

        TThread.Synchronize(nil,
        procedure
        begin
          PrimeiroCarregamento;
          ShowSucesso('Unidade de medida deletada com sucesso!');
          ViewMensagem.OnAfterClose := procedure
                                       begin
                                         ViewMensagem.OnAfterClose := nil;
                                         Voltar;
                                       end
        end);
      finally
        LJsonResponse.Free;
      end;
    except on E: Exception do
      begin
        FPaginacao.CarregandoPagina := False;
        ShowErro(E.Message);
      end;
    end;
  end).Start;
end;

procedure TViewUnidadeMedida.ExecuteOnShow;
begin
  inherited;
  imgDelete.Visible := False;
  imgSalvar.Visible := False;
  PrimeiroCarregamento;
  TabControl.GotoVisibleTab(0);
end;

procedure TViewUnidadeMedida.FormCreate(Sender: TObject);
begin
  inherited;
  TabControl.SendToBack;
  recToolbar.BringToFront;
  TabControl.Margins.Top          := -50;
  FViewComboBoxAtivo              := TViewComboBoxBase.Create(Self);
  FViewComboBoxAtivo.Parent       := layView;
  FViewComboBoxAtivo.Align        := TAlignLayout.Contents;
  FViewComboBoxAtivo.Visible      := False;
  FViewComboBoxAtivo.EditComboBox := edtComboBoxAtivo;
  FViewComboBoxAtivo.Title        := 'Ativo';

  FViewComboBoxAtivo.AddItem(1,'Sim');
  FViewComboBoxAtivo.AddItem(2,'Não');
end;

procedure TViewUnidadeMedida.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FViewComboBoxAtivo);
  inherited;
end;

procedure TViewUnidadeMedida.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if TabControl.ActiveTab.Equals(tabCadastro) then
  begin
    var FService: IFMXVirtualKeyboardService;
    if (Key = vkHardwareBack) then
    begin
      TPlatformServices.Current.SupportsPlatformService
        (IFMXVirtualKeyboardService, IInterface(FService));
      if not((FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState)) then
      begin
        Key := 0;
        Voltar;
      end
    end;
  end
  else
  begin
    inherited;
  end;
end;

procedure TViewUnidadeMedida.imgDeleteClick(Sender: TObject);
begin
  inherited;
  OpenDelete;
end;

procedure TViewUnidadeMedida.imgSalvarClick(Sender: TObject);
begin
  inherited;
  OnClickSave;
end;

procedure TViewUnidadeMedida.imgVoltarClick(Sender: TObject);
begin
  inherited;
  Voltar;
end;

procedure TViewUnidadeMedida.ListBoxItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  for var I := 0 to Pred(Item.ControlsCount) do
  begin
    if Item.Controls[i] is TFrameCategoriaLista then
    begin
      if Assigned(TFrameCategoriaLista(Item.Controls[i]).OnClickItem) then
        TFrameCategoriaLista(Item.Controls[i]).OnClickItem(TFrameCategoriaLista(Item.Controls[i]));
      Break;
    end;
  end;
end;

procedure TViewUnidadeMedida.ListBoxViewportPositionChange(Sender: TObject;
  const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
const
  LoadThreshold = 150; // Threshold em pixels antes do final para carregar mais itens
begin
  if (NewViewportPosition.Y + ListBox.Height) >= (ListBox.ContentBounds.Height - LoadThreshold) then
  begin
    // O usuário está perto do final da lista, carregar mais itens
    if not (FPaginacao.CarregandoPagina) and (FPaginacao.FRegistroJaListado < FPaginacao.TotalDeRegistros) then
      NovaCargaDeDados;
  end;
end;

procedure TViewUnidadeMedida.NovaCargaDeDados;
begin
  TThread.CreateAnonymousThread(
  procedure
  var LResponse: IResponse;
  begin
    try
      FPaginacao.CarregandoPagina := True;
      FPaginacao.PaginaAtual      := FPaginacao.PaginaAtual + 1;
      LResponse := TRequest.New.BaseURL(BaseURL)
        .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
        .AddParam('limit',LIMIT.ToString)
        .AddParam('page',FPaginacao.PaginaAtual.ToString)
        .Resource('unit')
        .Accept('application/json')
        .Get;

      var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
      try
        // Verificando o status code
        if LResponse.StatusCode <> 200 then
        begin
          if LResponse.StatusCode = 401 then
          begin
            raise Exception.Create('Usuário sem permissão para acessar esse recurso!');
          end;
          raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
        end;

        var LData := LJsonResponse.GetValue<TJSONArray>('data');
        var LJsonArrayUnidades := TJSONArray.ParseJSONValue(LData.ToJSON()) as TJSONArray;

        TThread.Synchronize(nil,
        procedure
        begin
          CarregarLista(LJsonArrayUnidades);
          FPaginacao.FRegistroJaListado := FPaginacao.FRegistroJaListado + LJsonResponse.GetValue<Integer>('record_of_page',0);
          FPaginacao.CarregandoPagina   := False;
        end);
      finally
        LJsonResponse.Free;
      end;
    except on E: Exception do
      begin
        FPaginacao.CarregandoPagina := False;
        ShowErro(E.Message);
      end;
    end;
  end).Start;
end;

procedure TViewUnidadeMedida.OnClickDeletarRegistro;
begin
  inherited;
  DeletarRegistro;
end;

procedure TViewUnidadeMedida.OnClickItemUnidadeMedida(Sender: TObject);
begin
  if Sender is TFrameCategoriaLista then
  begin
    FUnidadeSelecionada.Clear;

    FUnidadeSelecionada.Id          := TFrameCategoriaLista(Sender).Id;
    FUnidadeSelecionada.Description := TFrameCategoriaLista(Sender).Descricao;
    FUnidadeSelecionada.Sigra       := TFrameCategoriaLista(Sender).Sigra;
    FUnidadeSelecionada.Active      := TFrameCategoriaLista(Sender).Ativo;

    edtDescription.Text := FUnidadeSelecionada.Description;
    edtSigra.Text       := FUnidadeSelecionada.Sigra;

    case FUnidadeSelecionada.Active of
      True:FViewComboBoxAtivo.SetItemByCodigo(1);
      False:FViewComboBoxAtivo.SetItemByCodigo(2);
    end;

    recButtonAdicionar.Visible := False;
    imgDelete.Visible          := True;
    imgSalvar.Visible          := True;
    TabControl.GotoVisibleTab(1);
    CloseLoad;
  end;
end;
procedure TViewUnidadeMedida.OnClickSave;
begin
  try
    if edtDescription.Text.IsEmpty then
    begin
      raise Exception.Create('Descrição da unidade de medida não informada!');
    end;
  except on E: Exception do
    begin
      ShowErro(e.Message);
      Exit;
    end;
  end;

  CloseKeyboard;
  OpenLoad;
  TThread.CreateAnonymousThread(
  procedure
  var LResponse: IResponse;
  begin
    try
      var LMensagemSeSucesso:string;
      var LJSonBody := TJSONObject.Create;

      LJSonBody.AddPair('description',edtDescription.Text);
      LJSonBody.AddPair('sigra',edtSigra.Text);
      LJSonBody.AddPair('active',edtComboBoxAtivo.Codigo = 1);
      if FUnidadeSelecionada.Id.IsEmpty then
      begin
        LResponse := TRequest.New.BaseURL(BaseURL)
          .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
          .AddBody(LJSonBody)
          .Resource('unit')
          .Accept('application/json')
          .Post;
        LMensagemSeSucesso := 'Unidade de medida criada com sucesso!';
      end
      else
      begin
        LResponse := TRequest.New.BaseURL(BaseURL)
          .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
          .AddBody(LJSonBody)
          .Resource('unit/'+FUnidadeSelecionada.Id)
          .Accept('application/json')
          .Put;
        LMensagemSeSucesso := 'Unidade de medida alterada com sucesso!';
      end;


      var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
      try
        // Verificando o status code
        if (LResponse.StatusCode <> 200) and (LResponse.StatusCode <> 201) then
        begin
          if LResponse.StatusCode = 401 then
          begin
            raise Exception.Create('Usuário sem permissão para acessar esse recurso!');
          end;
          raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
        end;

        TThread.Synchronize(nil,
        procedure
        begin
          FUnidadeSelecionada.Clear;
          PrimeiroCarregamento;
          ShowSucesso(LMensagemSeSucesso);
          ViewMensagem.OnAfterClose := procedure
                                      begin
                                        ViewMensagem.OnAfterClose := nil;
                                        Voltar;
                                      end;
        end);
      finally
        if Assigned(LJsonResponse) then
          FreeAndNil(LJsonResponse);
      end;
    except on E: Exception do
      begin
        ShowErro(e.Message);
      end;
    end;
  end).Start;
end;

procedure TViewUnidadeMedida.PrimeiroCarregamento;
begin
  OpenLoad;
  ListBox.Items.Clear;
  TThread.CreateAnonymousThread(
  procedure
  var LResponse: IResponse;
  begin
    FPaginacao.CarregandoPagina := True;
    try
      LResponse := TRequest.New.BaseURL(BaseURL)
        .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
        .AddParam('limit',LIMIT.ToString)
        .Resource('unit')
        .Accept('application/json')
        .Get;

      var LJsonResponse := TJSONObject.ParseJSONValue(LResponse.Content);
      try
        // Verificando o status code
        if LResponse.StatusCode <> 200 then
        begin
          if LResponse.StatusCode = 401 then
          begin
            raise Exception.Create('Usuário sem permissão para acessar esse recurso!');
          end;
          raise Exception.Create(LJsonResponse.GetValue<string>('error','Erro não identificado!'));
        end;

        var LData := LJsonResponse.GetValue<TJSONArray>('data');
        var LJsonArrayUnidades := TJSONArray.ParseJSONValue(LData.ToJSON()) as TJSONArray;

        TThread.Synchronize(nil,
        procedure
        begin
          CarregarLista(LJsonArrayUnidades);
          FPaginacao.PaginaAtual        := 1;
          FPaginacao.TotalDeRegistros   := LJsonResponse.GetValue<Integer>('count_record',0);
          FPaginacao.FRegistroJaListado := LJsonResponse.GetValue<Integer>('record_of_page',0);
          FPaginacao.CarregandoPagina   := False;
          CloseLoad;
        end);
      finally
        LJsonResponse.Free;
      end;
    except on E: Exception do
      begin
        FPaginacao.CarregandoPagina := False;
        ShowErro(E.Message);
      end;
    end;
  end).Start;
end;

procedure TViewUnidadeMedida.recButtonAdicionarClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  Adicionar;
  {$ENDIF}
end;

procedure TViewUnidadeMedida.recButtonAdicionarTap(Sender: TObject;
  const Point: TPointF);
begin
  inherited;
  Adicionar;
end;

procedure TViewUnidadeMedida.Voltar;
begin
  CloseKeyboard;
  if TabControl.ActiveTab.Equals(tabLista) then
  begin
    PriorForm(Self);
  end
  else
  begin
    recButtonAdicionar.Visible := True;
    imgDelete.Visible          := False;
    imgSalvar.Visible          := False;
    FUnidadeSelecionada.Clear;
    edtDescription.Text        := EmptyStr;
    edtSigra.Text              := EmptyStr;
    FViewComboBoxAtivo.SetItemByCodigo(1);
    TabControl.GotoVisibleTab(0);
  end;
end;

end.
