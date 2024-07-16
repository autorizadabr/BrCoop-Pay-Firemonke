unit View.Categoria;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Base, FMX.Objects, FMX.Layouts, FMX.TabControl,System.JSON,
  Frame.Categoria.Lista, Model.Static.Credencial, FMX.Edit,
  Model.Records.Categoria.Selecionada,System.Generics.Collections,
  FMX.Controls.Presentation, View.Button.Base, Helper.Scroll, FMX.Effects,
  FMX.Filter.Effects,FMX.VirtualKeyboard,FMX.Platform, FMX.ListBox, Helper.Image,
  FMX.MediaLibrary.Actions, FMX.StdActns, System.Actions, FMX.ActnList,
  u99Permissions;

type

  TViewCategoria = class(TViewBase)
    TabControl: TTabControl;
    recToolbar: TRectangle;
    tabLista: TTabItem;
    tabCadastro: TTabItem;
    layTabCadastro: TLayout;
    Label6: TLabel;
    recCep: TRectangle;
    edtNome: TEdit;
    Rectangle1: TRectangle;
    Label1: TLabel;
    imgCategoria: TImage;
    Label2: TLabel;
    imgSalvar: TImage;
    imgVoltar: TImage;
    Image4: TImage;
    FillRGBEffect1: TFillRGBEffect;
    FillRGBEffect2: TFillRGBEffect;
    ListBox: TListBox;
    layButtonCamera: TLayout;
    recAdicionarFoto: TRectangle;
    Circle1: TCircle;
    Label3: TLabel;
    imgFotoPadao: TImage;
    imgDelete: TImage;
    recButtonAdicionar: TRectangle;
    Label4: TLabel;
    ShadowEffect1: TShadowEffect;
    ActionList: TActionList;
    ActPerfil: TChangeTabAction;
    ActBol: TChangeTabAction;
    ActMenu: TChangeTabAction;
    ActListaReverva: TChangeTabAction;
    actCamera: TTakePhotoFromCameraAction;
    actLibary: TTakePhotoFromLibraryAction;
    recSelecionarCamera: TRectangle;
    lblCamera: TLabel;
    lblGaleriaImagem: TLabel;
    layContainerCamera: TLayout;
    procedure imgSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure ListBoxViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
    procedure ListBoxItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure imgDeleteClick(Sender: TObject);
    procedure recButtonAdicionarClick(Sender: TObject);
    procedure recButtonAdicionarTap(Sender: TObject; const Point: TPointF);
    procedure actLibaryDidFinishTaking(Image: TBitmap);
    procedure lblGaleriaImagemTap(Sender: TObject; const Point: TPointF);
    procedure lblGaleriaImagemClick(Sender: TObject);
    procedure recAdicionarFotoClick(Sender: TObject);
    procedure lblCameraTap(Sender: TObject; const Point: TPointF);
    procedure lblCameraClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actCameraDidFinishTaking(Image: TBitmap);
  private
    const LIMIT = 15;
    var
    FPaginacao:TPaginacao;
    FPermissao:T99Permissions;
    FCategoriaSelecionada:TCategoriaSelecionada;
    procedure CarregarLista(const AJson:TJSONArray);
    procedure OnClickItemCategoria(Sender:TObject);
    procedure PrimeiroCarregamento;
    procedure NovaCargaDeDados;
    procedure OnClickSave;
    procedure Voltar;
    procedure Adicionar;
    procedure DeletarRegistro;
    procedure ErroCamera(Sender:TObject);
  protected
    procedure OnClickDeletarRegistro;override;
  public
    procedure ExecuteOnShow; override;
  end;

var
  ViewCategoria: TViewCategoria;

implementation
  uses RESTRequest4D;
{$R *.fmx}

{ TViewCategoria }

procedure TViewCategoria.actCameraDidFinishTaking(Image: TBitmap);
begin
  inherited;
  try
    if Assigned(Image) then
    begin
      imgCategoria.Bitmap := Image;
    end;

  except on E: Exception do
    begin
      ShowErro(e.Message);
      Exit;
    end;
  end;
end;

procedure TViewCategoria.actLibaryDidFinishTaking(Image: TBitmap);
begin
  inherited;
  try
    if Assigned(Image) then
    begin
      imgCategoria.Bitmap := Image;
    end;

  except on E: Exception do
    begin
      ShowErro(e.Message);
      Exit;
    end;
  end;
end;

procedure TViewCategoria.Adicionar;
begin
  recButtonAdicionar.Visible := False;
  edtNome.Text := EmptyStr;
  imgCategoria.Bitmap := imgFotoPadao.Bitmap;
  FCategoriaSelecionada.Clear;
  imgSalvar.Visible := True;
  imgDelete.Visible := False;
  TabControl.GotoVisibleTab(1);
end;

procedure TViewCategoria.CarregarLista(const AJson: TJSONArray);
begin
  ListBox.BeginUpdate;
  for var I := 0 to Pred(AJson.Count) do
  begin
    var LItem               := AJson.Items[i] as TJSONObject;
    var LItemListBox        := TListBoxItem.Create(ListBox);
    LItemListBox.Selectable := False;
    var LFrame              := TFrameCategoriaLista.Create(LItemListBox);
    LFrame.Name             := 'Categoria'+I.ToString;
    LFrame.Id               := LItem.GetValue<string>('id','');
    LFrame.Descricao        := LItem.GetValue<string>('name','');
    LFrame.LoadImge(LItem.GetValue<string>('image',''));
    LFrame.OnClickItem      := OnClickItemCategoria;
    LFrame.Height           := 60;
    LItemListBox.Height     := LFrame.Height;
    LItemListBox.AddObject(LFrame);
    ListBox.AddObject(LItemListBox);
    LFrame.Align            := TAlignLayout.Client;
  end;
  ListBox.EndUpdate;
end;

procedure TViewCategoria.DeletarRegistro;
begin
  CloseDelete;
  OpenLoad;
  TThread.CreateAnonymousThread(
  procedure
  var LResponse: IResponse;
  begin
    try
      if FCategoriaSelecionada.id.IsEmpty then
        raise Exception.Create('Código do usuário não informado!');

      LResponse := TRequest.New.BaseURL(BaseURL)
        .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
        .Resource('category/'+FCategoriaSelecionada.Id)
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
          ShowSucesso('Categoria deletada com sucesso!');
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

procedure TViewCategoria.ErroCamera(Sender: TObject);
begin
  ShowMessage('Erro');
end;

procedure TViewCategoria.ExecuteOnShow;
begin
  inherited;
  recSelecionarCamera.Visible := False;
  imgDelete.Visible           := False;
  imgSalvar.Visible           := False;
  imgFotoPadao.Visible        := False;
  PrimeiroCarregamento;
  TabControl.GotoVisibleTab(0);
end;

procedure TViewCategoria.FormCreate(Sender: TObject);
begin
  inherited;
  Fpermissao := T99Permissions.Create;
  TabControl.Margins.Top := - 50;
end;

procedure TViewCategoria.FormDestroy(Sender: TObject);
begin
  Fpermissao.Free;
  inherited;
end;

procedure TViewCategoria.FormKeyUp(Sender: TObject; var Key: Word;
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

procedure TViewCategoria.imgDeleteClick(Sender: TObject);
begin
  inherited;
  OpenDelete;
end;

procedure TViewCategoria.imgSalvarClick(Sender: TObject);
begin
  inherited;
  OnClickSave;
end;

procedure TViewCategoria.imgVoltarClick(Sender: TObject);
begin
  inherited;
  Voltar;
end;

procedure TViewCategoria.lblCameraClick(Sender: TObject);
begin
  inherited;
  {$IFDEF MSWINDOWS}
  try
    recSelecionarCamera.Visible := False;
    Fpermissao.Camera(actCamera,ErroCamera);
  except on E: Exception do
    begin
      ShowErro(e.Message);
    end;
  end;
 {$ENDIF}
end;

procedure TViewCategoria.lblCameraTap(Sender: TObject; const Point: TPointF);
begin
  inherited;
  try
    recSelecionarCamera.Visible := False;
    actCamera.Execute;
  except on E: Exception do
    begin
      ShowErro(e.Message);
    end;
  end;
end;

procedure TViewCategoria.lblGaleriaImagemClick(Sender: TObject);
begin
  inherited;
  {$IFDEF MSWINDOWS}
  recSelecionarCamera.Visible := False;
  actLibary.Execute;
  {$ENDIF}
end;

procedure TViewCategoria.lblGaleriaImagemTap(Sender: TObject; const Point: TPointF);
begin
  inherited;
  recSelecionarCamera.Visible := False;
  actLibary.Execute;
end;

procedure TViewCategoria.ListBoxItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  inherited;
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

procedure TViewCategoria.ListBoxViewportPositionChange(Sender: TObject;
  const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
const
  LoadThreshold = 500; // Threshold em pixels antes do final para carregar mais itens
begin
  if (NewViewportPosition.Y + ListBox.Height) >= (ListBox.ContentBounds.Height - LoadThreshold) then
  begin
    // O usuário está perto do final da lista, carregar mais itens
    if not (FPaginacao.CarregandoPagina) and (FPaginacao.FRegistroJaListado < FPaginacao.TotalDeRegistros) then
      NovaCargaDeDados;
  end;
end;

procedure TViewCategoria.NovaCargaDeDados;
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
        .Resource('category')
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
        var LJsonArrayCategorias := TJSONArray.ParseJSONValue(LData.ToJSON()) as TJSONArray;

        TThread.Synchronize(nil,
        procedure
        begin
          CarregarLista(LJsonArrayCategorias);
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

procedure TViewCategoria.OnClickDeletarRegistro;
begin
  inherited;
  DeletarRegistro;
end;

procedure TViewCategoria.OnClickItemCategoria(Sender: TObject);
begin
  if Sender is TFrameCategoriaLista then
  begin
    FCategoriaSelecionada.Id     := TFrameCategoriaLista(Sender).Id;
    FCategoriaSelecionada.Name   := TFrameCategoriaLista(Sender).Descricao;
    FCategoriaSelecionada.Imagem := TFrameCategoriaLista(Sender).Image;


    edtNome.Text := FCategoriaSelecionada.Name;
    if (TFrameCategoriaLista(Sender).Circle.Fill.Bitmap.Bitmap <> nil) then
      imgCategoria.Bitmap := TFrameCategoriaLista(Sender).Circle.Fill.Bitmap.Bitmap;

    recButtonAdicionar.Visible   := False;
    imgDelete.Visible            := True;
    imgSalvar.Visible            := True;
    TabControl.GotoVisibleTab(1);
  end;
end;

procedure TViewCategoria.OnClickSave;
begin
  try
    if edtNome.Text.IsEmpty then
    begin
      raise Exception.Create('Nome da categoria não informado!');
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
      var LStream := TMemoryStream.Create;
      try
        if FCategoriaSelecionada.Id.IsEmpty then
        begin
          imgCategoria.Bitmap.SaveToStream(LStream);
          LResponse := TRequest.New.BaseURL(BaseURL)
            .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
            .AddField('name',edtNome.Text)
            .AddFile('image',LStream)
            .Resource('category')
            .Accept('application/json')
            .Post;
          LMensagemSeSucesso := 'Categoria criada com sucesso!';
        end
        else
        begin
          imgCategoria.Bitmap.SaveToStream(LStream);
          LResponse := TRequest.New.BaseURL(BaseURL)
            .AddHeader('Authorization','Bearer '+TModelStaticCredencial.GetInstance.Token,[poDoNotEncode])
            .AddField('name',edtNome.Text)
            .AddFile('image',LStream)
            .Resource('category/'+FCategoriaSelecionada.Id)
            .Accept('application/json')
            .Put;
          LMensagemSeSucesso := 'Categoria alterada com sucesso!';
        end;
      finally
        FreeAndNil(LStream);
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
          FCategoriaSelecionada.Clear;
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

procedure TViewCategoria.PrimeiroCarregamento;
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
        .Resource('category')
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
        var LJsonArrayClientes := TJSONArray.ParseJSONValue(LData.ToJSON()) as TJSONArray;

        TThread.Synchronize(nil,
        procedure
        begin
          CarregarLista(LJsonArrayClientes);

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

procedure TViewCategoria.recAdicionarFotoClick(Sender: TObject);
begin
  inherited;
  recSelecionarCamera.Visible := not (recSelecionarCamera.Visible);
end;

procedure TViewCategoria.recButtonAdicionarClick(Sender: TObject);
begin
  inherited;
  {$IFDEF MSWINDOWS}
  Adicionar;
  {$ENDIF}
end;

procedure TViewCategoria.recButtonAdicionarTap(Sender: TObject;
  const Point: TPointF);
begin
  inherited;
  Adicionar;
end;

procedure TViewCategoria.Voltar;
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
    FCategoriaSelecionada.Clear;
    TabControl.GotoVisibleTab(0);
  end;
end;


end.
