unit CustomList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Generics.Collections, System.Threading, System.Net.URLClient,
  UI.Base, UI.Standard, UI.Frame, UI.ListView;

type
  TDataItem = record
    Title: string;
    SubTitle: string;
    Hint: string;
    ImagePath: string;
    ImageUrl: string;
    IsLarge: Boolean;
    Height: Single;
  end;

  TCustomListDataAdapter = class(TListAdapterBase)
  private
    [Weak] FList: TList<TDataItem>;
    FCancel: Boolean;
    procedure UpdateImage(const Index: Integer; ViewItem: TObject);
    procedure DoReceiveDataEvent(const Sender: TObject; AContentLength,
      AReadCount: Int64; var Abort: Boolean);
  protected
    function GetCount: Integer; override;
    function GetItem(const Index: Integer): Pointer; override;
    function IndexOf(const AItem: Pointer): Integer; override;
    function GetView(const Index: Integer; ConvertView: TViewBase;
      Parent: TViewGroup): TViewBase; override;
    function ItemDefaultHeight: Single; override;
    procedure ItemMeasureHeight(const Index: Integer; var AHeight: Single); override;
  public
    constructor Create(const AList: TList<TDataItem>);
    procedure Cancel;
  end;

  TfrmCustomList = class(TFrame)
    ListView: TListViewEx;
    procedure ListViewPullLoad(Sender: TObject);
    procedure ListViewPullRefresh(Sender: TObject);
    procedure ListViewScrollChange(Sender: TObject);
    procedure ListViewItemClick(Sender: TObject; ItemIndex: Integer;
      const ItemView: TControl);
  private
    { Private declarations }
    FAdapter: TCustomListDataAdapter;
    FList: TList<TDataItem>;
    FThreadPool: TThreadPool;
    FAdding: Boolean;
  protected
    procedure DoCreate(); override;
    procedure DoFree(); override;
    procedure DoShow(); override;
  public
    { Public declarations }
    procedure AddItems(const Count: Integer);
  end;

var
  frmCustomList: TfrmCustomList;

implementation

{$R *.fmx}

uses
  System.Net.HttpClient,
  BaseListItem, ListItem_TextImage, ListItem_Image, uFrameImageViewer,
  UI.Async;

procedure ValidateServerCertificate(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := True;
end;

{ TfrmCustomList }

////�������ͼƬչʾ
//https://api.uomg.com/api/rand.img2?sort=��Ů&format=json
////������ͼƬչʾ
//https://api.uomg.com/api/rand.img1?sort=��Ů&format=json
//https://api.uomg.com/api/image.lofter?format=json

procedure TfrmCustomList.AddItems(const Count: Integer);

  procedure DoAdd(S: string; ALarge: Boolean; AErr: string = '');
  var
    I: Integer;
    Item: TDataItem;
  begin
    I := FList.Count + 1;

    if S = '' then begin
      Item.Title := '����';
      Item.SubTitle := AErr;
      Item.Hint := '';
      Item.ImageUrl := '';
      Item.IsLarge := ALarge;
    end
    else begin
      Item.Title := '����' + IntToStr(I);
      Item.SubTitle := '������' + IntToStr(I);
      if ALarge then
        Item.Hint := '��Ԥ��'
      else
        Item.Hint := 'СԤ��';
      Item.ImageUrl := S;
      Item.IsLarge := ALarge;
    end;

    Item.Height := -1;

    FList.Add(Item);
  end;

  function GetUrl(ALarge: Boolean): string;
  begin
    if ALarge then
      Result := 'https://api.uomg.com/api/rand.img2?sort=��Ů&format=text'
    else
      Result := 'https://api.uomg.com/api/rand.img1?sort=����Ԫ&format=text';
  end;

  procedure DoHttp(ALarge: Boolean);
  var
    LStream: TMemoryStream;
    LHttp: THttpClient;
    LResponse: IHTTPResponse;
  begin
    LHttp := THttpClient.Create;
    try
      try
        LHttp.HandleRedirects := False;
        {$IFDEF MSWINDOWS}
        // ssl protocol
        // win7 32 will get error if not use TLS12
        // https://social.msdn.microsoft.com/Forums/en-US/b27a9ddd-d8f7-408c-8029-cf5f8f9ddbef/winhttp-winhttpcallbackstatusflagsecuritychannelerror-on-win7?forum=vcgeneral
        LHttp.SecureProtocols := [THTTPSecureProtocol.TLS12];
        {$ENDIF}
        // ignore ssl error
        LHttp.ValidateServerCertificateCallback := ValidateServerCertificate;
        LResponse := LHttp.Get(GetUrl(ALarge), nil);

        if not Assigned(LResponse) then
          DoAdd('', False, 'û�з���ֵ')
        else if (LResponse.StatusCode < 300) or (LResponse.StatusCode >= 400) or (LResponse.HeaderValue['location'] = '') then
          DoAdd('', False, '�ӿ����ݲ��Ϸ�')
        else
          DoAdd(LResponse.HeaderValue['location'], ALarge);
      except
        on E: Exception do begin
          DoAdd('', False, E.Message);
          //�Լ������쳣
          Exit;
        end;
      end;
    finally
      FreeAndNil(LHttp);
    end;
  end;

var
  I: Integer;
begin
  //�����ظ�����
  if FAdding then
    Exit;

  FAdding := True;
  try
    for I := 0 to Count - 1 do
      DoHttp((Flist.Count + 1) mod 2 = 0);
  finally
    FAdding := False;
  end;

  TThread.Queue(nil, procedure begin
    FAdapter.NotifyDataChanged;
  end);
end;

procedure TfrmCustomList.DoCreate;
begin
  inherited;

  FList := TList<TDataItem>.Create();
  FAdapter := TCustomListDataAdapter.Create(FList);
  ListView.Adapter := FAdapter;

  FThreadPool := TThreadPool.Create;
  FThreadPool.SetMaxWorkerThreads(2);
  FThreadPool.SetMinWorkerThreads(0);
end;

procedure TfrmCustomList.DoFree;
begin
  FAdapter.Cancel;
  FThreadPool.Free;

  ListView.Adapter := nil;
  FAdapter := nil;
  FreeAndNil(FList);

  inherited;
end;

procedure TfrmCustomList.DoShow;
begin
  inherited;

  //ListView.ColumnCount := 3;
  ShowWaitDialog('������...', False);
  TAsync.Create()
  .SetExecute(
    procedure (Async: TAsync) begin
      AddItems(10);
    end
  )
  .SetExecuteComplete(
    procedure (Async: TAsync) begin
      HideWaitDialog;
    end
  ).Start;
end;

procedure TfrmCustomList.ListViewItemClick(Sender: TObject; ItemIndex: Integer;
  const ItemView: TControl);

  function DoAssgin(BMP: TBitmap): Integer;
  begin
      with TFrameImageViewer(StartFrame(TFrameImageViewer)) do begin
        ImageViewerEx1.Image.Assign(BMP);
        ImageViewerEx1.Zoom := Trunc(Width * 100 / BMP.Width);
      end;
  end;

var
  LView: TBaseListItemFrame;
begin
  if ItemView is TBaseListItemFrame then begin
    LView := TBaseListItemFrame(ItemView);
    if Assigned(LView.Image) then
      if not LView.Image.Image.ItemDefault.Bitmap.Bitmap.IsEmpty then
        DoAssgin(LView.Image.Image.ItemDefault.Bitmap.Bitmap)
      else begin
        Hint('���¼�����');
        FAdapter.UpdateImage(LView.ItemIndex, ItemView);
      end;
  end;
end;

procedure TfrmCustomList.ListViewPullLoad(Sender: TObject);
begin
  DelayExecute(1,
    procedure (Sender: TObject)
    begin
      AddItems(20);
      if FList.Count > 50 then
        ListView.EnablePullLoad := False;
      ListView.PullLoadComplete;
    end
  );
end;

procedure TfrmCustomList.ListViewPullRefresh(Sender: TObject);
begin
  Hint('���ڼ�������');
  DelayExecute(2,
    procedure (Sender: TObject)
    begin
      FList.Clear;
      AddItems(20);
      ListView.EnablePullLoad := True;
      ListView.PullRefreshComplete;
    end
  );
end;

procedure TfrmCustomList.ListViewScrollChange(Sender: TObject);
begin
  if (ListView.ContentBounds.Height - ListView.VScrollBarValue - ListView.Height) < 100 then
    TThread.CreateAnonymousThread(procedure begin
      AddItems(4); //��Ϊ�б�Ҳ�������ȡ������̫����������������
    end).Start;
end;

{ TCustomListDataAdapter }

procedure TCustomListDataAdapter.Cancel;
begin
  FCancel := True;
  //TTask.WaitForAll();
end;

constructor TCustomListDataAdapter.Create(const AList: TList<TDataItem>);
begin
  FList := AList;
end;

procedure TCustomListDataAdapter.DoReceiveDataEvent(const Sender: TObject;
  AContentLength, AReadCount: Int64; var Abort: Boolean);
begin
  Abort := FCancel;
end;

function TCustomListDataAdapter.GetCount: Integer;
begin
  if Assigned(FList) then
    Result := FList.Count
  else
    Result := 0;
end;

function TCustomListDataAdapter.GetItem(const Index: Integer): Pointer;
begin
  Result := nil;
end;

function TCustomListDataAdapter.GetView(const Index: Integer;
  ConvertView: TViewBase; Parent: TViewGroup): TViewBase;
var
  LItem: TDataItem;

  function DoTextImage: TViewBase;
  var
    ViewItem: TfrmListItem_TextImage;
  begin
    if FCancel then begin
      Result := nil;
      Exit;
    end;

    if (ConvertView = nil) or (not (ConvertView.ClassType = TfrmListItem_TextImage)) then begin
      ViewItem := TfrmListItem_TextImage.Create(Parent);
      ViewItem.Parent := Parent;
      ViewItem.Width := Parent.Width;
      ViewItem.CanFocus := False;
      //init
      ViewItem.ItemIndex := -1;
      // Ĭ�ϴ�С���С����ƴ�С�����������趨��
      ViewItem.Height := ItemDefaultHeight;
    end else
      ViewItem := TObject(ConvertView) as TfrmListItem_TextImage;

    try
      if FCancel then
        Exit;
      // same index, skip
      if (ViewItem.ItemIndex = Index) and ViewItem.ImageView1.Enabled then
        Exit;

      ViewItem.BeginUpdate;
      try
        ViewItem.ItemIndex := Index;

        ViewItem.TextView1.Text := LItem.Hint;
        ViewItem.TextView2.Text := LItem.Title;
        ViewItem.TextView3.Text := LItem.SubTitle;

        //get image
        UpdateImage(Index, ViewItem);
      finally
        ViewItem.EndUpdate;
      end;
    finally
      Result := TViewBase(ViewItem);
    end;
  end;

  function DoImage: TViewBase;
  var
    ViewItem: TfrmListItem_Image;
  begin
    if FCancel then begin
      Result := nil;
      Exit;
    end;

    if (ConvertView = nil) or (not (ConvertView.ClassType = TfrmListItem_Image)) then begin
      ViewItem := TfrmListItem_Image.Create(Parent);
      ViewItem.Parent := Parent;
      ViewItem.Width := Parent.Width;
      ViewItem.CanFocus := False;
      //init
      ViewItem.ItemIndex := -1;
      // Ĭ�ϴ�С���С����ƴ�С�����������趨��
      ViewItem.Height := ItemDefaultHeight;
    end else
      ViewItem := TObject(ConvertView) as TfrmListItem_Image;

    try
      if FCancel then
        Exit;
      // same index, skip
      if (ViewItem.ItemIndex = Index) and ViewItem.ImageView1.Enabled then
        Exit;

      ViewItem.BeginUpdate;
      try
        ViewItem.ItemIndex := Index;

        ViewItem.TextView1.Text := LItem.Hint;

        //get image
        UpdateImage(Index, ViewItem);
      finally
        ViewItem.EndUpdate;
      end;
    finally
      Result := TViewBase(ViewItem);
    end;
  end;

begin
  if FCancel then begin
    Result := nil;
    Exit;
  end;

  LItem := FList.Items[Index];
  if LItem.IsLarge then
    Result := DoImage
  else
    Result := DoTextImage;
end;

function TCustomListDataAdapter.IndexOf(const AItem: Pointer): Integer;
begin
  Result := -1;
end;

function TCustomListDataAdapter.ItemDefaultHeight: Single;
begin
  Result := 150;
end;

procedure TCustomListDataAdapter.ItemMeasureHeight(const Index: Integer;
  var AHeight: Single);
begin
  if FList.Items[Index].Height > 0 then
    AHeight := FList.Items[Index].Height
  else if FList.Items[Index].IsLarge then
    AHeight := 300
  else
    AHeight := 150;
end;

procedure TCustomListDataAdapter.UpdateImage(const Index: Integer; ViewItem: TObject);
var
  LItem: TDataItem;
  LView: TBaseListItemFrame;
  LStream: TMemoryStream;
  LHttp: THttpClient;
  LResponse: IHTTPResponse;
begin
  if FCancel then
    Exit;
  LView := TBaseListItemFrame(ViewItem);
  if LView.ItemIndex <> Index then
    Exit;
  LItem := FList.Items[Index];
  if LItem.ImageUrl = '' then
    Exit;
  // �Ѿ����ع��Ͳ��ظ�������
  if not LView.Image.Image.ItemDefault.Bitmap.Bitmap.IsEmpty then
    Exit;

  LView.Text.Text := '������';
  //display a gray page
  LView.Image.Enabled := False;
  LView.Image.Image.ItemDefault.Bitmap.Bitmap.Assign(nil);
  //�û����ٻ�����ʱ����TThread�϶��Ῠ���������TTask�򲻻ᣬ��Ϊ�̳߳�ÿ��ִ�еĸ������ޣ��������ü���Ӧ
  //����TaskҲ��һЩbug�����Դ�ҿ�����QWorker��������ֻ����ʾ���Ͳ���QWorker��
  //Delphi 10.1 berlin TTask���ڵĶ������� - http://blog.sina.com.cn/s/blog_44fa172f0102w5o0.html
  //TThread.CreateAnonymousThread(procedure begin
  TTask.Run(procedure begin
    //delay to skip quick scroll
    Sleep(100);
    //enable for test slowly network
    //Sleep(4000);
    if LView.ItemIndex <> Index then
      Exit;
    if FCancel then
      Exit;
    {$IFDEF DEBUG}
    log.d('-----------------UpdateImage:%d-IsLarge:%d-------', [Index, Ord(LItem.IsLarge)]);
    {$ENDIF}
    LStream := TMemoryStream.Create;
    try
      LHttp := THttpClient.Create;
      try
        LHttp.OnReceiveData := DoReceiveDataEvent;
        LHttp.ValidateServerCertificateCallback := ValidateServerCertificate;
        try
          LResponse := LHttp.Get(LItem.ImageUrl, LStream);
        except
          //�Լ������쳣
          Exit;
        end;
        if FCancel then
          Exit;
        if not Assigned(LResponse) then
          Exit;
        if (LResponse.StatusCode < 200) or (LResponse.StatusCode >= 300) then
          Exit;
        if LView.ItemIndex <> Index then
          Exit;
        if FCancel then
          Exit;
        TThread.Synchronize(nil, procedure begin
          if LView.ItemIndex <> Index then
            Exit;
          if FCancel then
            Exit;

          //����ļ��ܴ����������ʵ������
          //��fmx��ͼƬ�������߳��²��ȶ������ɿ�
          //������һ�����ǰѼ��ز�֣���һ���ȼ��ص��ڴ棬Ȼ����ͬ����ui
          //��������ˣ�BMP��ʵ�ܴ�����������ͼƬ����ʵ����ʾ��С����ô��Ҫ��һ��������ͼ����
          //�ܽ�һ�£�
          //1���̼߳���ͼƬ���ڴ�
          //2���߳��ڴ�������ͼ
          //3��ͬ�����µ�UI
          try
            LView.Image.Image.ItemDefault.Bitmap.Bitmap.LoadFromStream(LStream);

            if LView.ItemIndex = 0 then begin
              LItem.Height := 200;
              FList.Items[Index] := LItem;
              LView.Text.Text := '�������-���ڸ��ĸ߶�demo';
              { TODO -oAdministrator -c : ����һ�����ڸ��ĳߴ�ĵ��÷��� 2020-09-16 11:36:17 }
              ListView.ContentViews.Height := ListView.ContentViews.Height + 1;
            end
            else
              LView.Text.Text := '�������';
          except
            LView.Text.Text := '����ʧ��';
          end;
          LView.Image.Enabled := True;
        end);
      finally
        FreeAndNil(LHttp);
      end;
    finally
      FreeAndNil(LStream);
    end;
  end).Start;
end;

end.
