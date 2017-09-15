unit uuibits;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, iuibits, Controls, trl_idifactory, forms, trl_itree,
  StdCtrls, trl_iprops, trl_uprops, trl_iinjector, Graphics, trl_ilog, fgl,
  rea_iuilayout, rea_iredux;

type

  { TUIBit }

  TUIBit = class(TInterfacedObject, IUIBit, INode, IUIPlacement, IUIPlace)
  protected
    // INode
    procedure AddChild(const ANode: INode);
    procedure RemoveChild(const ANode: INode);
    procedure Insert(const AIndex: integer; const ANode: INode);
    procedure Delete(const AIndex: integer);
    function Count: integer;
    function GetChild(const AIndex: integer): INode;
    function GetNodeEnumerator: INodeEnumerator;
    function INode.GetEnumerator = GetNodeEnumerator;
  protected
    // IUIBit
    procedure Render;
    function Surface: TWinControl; virtual;
    procedure RenderPaint(const ACanvas: TCanvas);
  protected
    fColor: TColor;
    function AsControl: TControl;
    procedure SetControl(AValue: TControl);
    procedure SetParentElement(AValue: IUnknown);
  protected
    procedure DoRender; virtual;
    procedure DoRenderPaint(const ACanvas: TCanvas); virtual;
  public
    destructor Destroy; override;
  protected
    fLayout: integer;
    fPlace: integer;
    fMMWidth: integer;
    fMMHeight: integer;
    function GetLayout: integer;
    function GetPlace: integer;
    function GetMMWidth: integer;
    function GetMMHeight: integer;
    procedure SetLayout(AValue: integer);
    procedure SetPlace(AValue: integer);
    procedure SetMMWidth(AValue: integer);
    procedure SetMMHeight(AValue: integer);
  protected
    // IUIPlace
    fLeft: integer;
    fTop: integer;
    fWidth: integer;
    fHeight: integer;
    function GetLeft: integer;
    function GetTop: integer;
    function GetWidth: integer;
    function GetHeight: integer;
    procedure SetLeft(AValue: integer);
    procedure SetTop(AValue: integer);
    procedure SetWidth(AValue: integer);
    procedure SetHeight(AValue: integer);
  protected
    fLog: ILog;
    fNode: INode;
    fFactory: IDIFactory;
    fControl: TControl;
    fParentElement: IUnknown;
  published
    property Log: ILog read fLog write fLog;
    property Node: INode read fNode write fNode;
    property Factory: IDIFactory read fFactory write fFactory;
    property Control: TControl read fControl write SetControl;
    property ParentElement: IUnknown read fParentElement write SetParentElement;
    property Layout: integer read GetLayout write SetLayout;
    property Place: integer read GetPlace write SetPlace;
    property MMWidth: integer read GetMMWidth write SetMMWidth;
    property MMHeight: integer read GetMMHeight write SetMMHeight;
    property Left: integer read GetLeft write SetLeft;
    property Top: integer read GetTop write SetTop;
    property Width: integer read GetWidth write SetWidth;
    property Height: integer read GetHeight write SetHeight;
    property Color: TColor read fColor write fColor;
  end;


  { TUIFormBit }

  TUIFormBit = class(TUIBit, IUIFormBit)
  protected
    function _AddRef : longint;{$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
    function _Release : longint;{$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
  protected
    function AsForm: TCustomForm;
    procedure ResetScroll;
    procedure OnResize(Sender: TObject);
    procedure ResizeNotifierData(const AProps: IProps);
    procedure OnPaint(Sender: TObject);
  protected
    procedure DoRender; override;
    function Surface: TWinControl; override;
  public
    destructor Destroy; override;
  protected
    fTiler: IUITiler;
    fTitle: string;
    fResizeNotifier: IAppNotifier;
  published
    property Tiler: IUITiler read fTiler write fTiler;
    property Title: string read fTitle write fTitle;
    //property ResizeNotifier: IUINotifier read fResizeNotifier write fResizeNotifier;
    property ResizeNotifier: IAppNotifier read fResizeNotifier write fResizeNotifier;
  end;

  { TUIStripBit }

  TUIStripBit = class(TUIBit, IUIStripBit)
  protected
    procedure DoRender; override;
    procedure DoRenderPaint(const ACanvas: TCanvas); override;
  protected
    fTiler: IUITiler;
    fTransparent: Boolean;
    fTitle: string;
    fFontColor: TColor;
    fBorder: integer;
    fBorderColor: TColor;
  public
    procedure AfterConstruction; override;
  published
    property Tiler: IUITiler read fTiler write fTiler;
    property Transparent: Boolean read fTransparent write fTransparent default True;
    property Title: string read fTitle write fTitle;
    property FontColor: TColor read fFontColor write fFontColor;
    property Border: integer read fBorder write fBorder;
    property BorderColor: TColor read fBorderColor write fBorderColor;
  end;

  { TUIEditBit }

  TUIEditBit = class(TUIBit, IUIEditBit)
  protected
    function AsEdit: TCustomEdit;
  protected
    procedure DoRender; override;
  protected
    fText: string;
  published
    property Text: string read fText write fText;
  end;

  { TUITextBit }

  TUITextBit = class(TUIBit, IUITextBit)
  protected
    function AsText: TCustomLabel;
  protected
    procedure DoRender; override;
  protected
    fText: string;
  published
    property Text: string read fText write fText;
  end;

  { TUIButtonBit }

  TUIButtonBit = class(TUIBit, IUIButtonBit)
  protected
    function AsButton: TCustomButton;
    procedure OnClick(Sender: TObject);
  protected
    procedure DoRender; override;
  protected
    fCaption: string;
    fClickNotifier: IAppNotifier;
  published
    property Caption: string read fCaption write fCaption;
    property ClickNotifier: IAppNotifier read fClickNotifier write fClickNotifier;
  end;

implementation

{ TUIStripBit }

procedure TUIStripBit.DoRender;
var
  mChild: INode;
  mPlace: IUIPlace;
begin
  // need to shift children relatively to surface this strip is on(because strip
  // has no control to render ... intentionaly)
  Tiler.ReplaceChildren(Self);
  for mChild in (Self as INode) do begin
    mPlace := mChild as IUIPlace;
    mPlace.Left := Left + mPlace.Left;
    mPlace.Top := Top + mPlace.Top;
  end;
end;

procedure TUIStripBit.DoRenderPaint(const ACanvas: TCanvas);
var
  i: integer;
begin
  inherited DoRenderPaint(ACanvas);
  if not Transparent then begin
    ACanvas.Brush.Color := Color;
    ACanvas.FillRect(Left, Top, Left + Width, Top + Height - i);
  end;
  if Border > 0 then begin
    ACanvas.Pen.Color := BorderColor;
    for i := 0 to Border - 1 do
      ACanvas.Rectangle(Left + i, Top + i, Left + Width - i, Top + Height - i);
  end;
  if Title <> '' then begin
    ACanvas.Font.Color := FontColor;
    ACanvas.TextOut(Left + Border + 1, Top + Border + 1, Title);
  end;
end;

procedure TUIStripBit.AfterConstruction;
begin
  inherited AfterConstruction;
  fTransparent := True;
end;

{ TUIButtonBit }

function TUIButtonBit.AsButton: TCustomButton;
begin
  Result := AsControl as TCustomButton;
end;

procedure TUIButtonBit.OnClick(Sender: TObject);
begin
  if ClickNotifier <> nil then
    ClickNotifier.Notify;
end;

procedure TUIButtonBit.DoRender;
begin
  inherited DoRender;
  if ParentElement <> nil then
    AsButton.Parent := (ParentElement as IUIBit).Surface;
  AsButton.Caption := Caption;
  AsButton.OnClick := @OnClick;
  if ClickNotifier <> nil then
    ClickNotifier.Enabled := True;
  AsButton.Show;
end;

{ TUITextBit }

function TUITextBit.AsText: TCustomLabel;
begin
  Result := AsControl as TCustomLabel;
end;

procedure TUITextBit.DoRender;
begin
  inherited;
  if ParentElement <> nil then
    AsText.Parent := (ParentElement as IUIBit).Surface;
  AsText.Caption := Text;
  AsText.Show;
end;

{ TUIEditBit }

function TUIEditBit.AsEdit: TCustomEdit;
begin
  Result := AsControl as TCustomEdit;
end;

procedure TUIEditBit.DoRender;
begin
  inherited;
  if ParentElement <> nil then
    AsEdit.Parent := (ParentElement as IUIBit).Surface;
  AsEdit.Text := Text;
  AsEdit.Show;
end;

{ TUIFormBit }

function TUIFormBit._AddRef: longint; cdecl;
begin
  Result := inherited _AddRef;
  Log.DebugLnEnter('ADDREF');
end;

function TUIFormBit._Release: longint; cdecl;
begin
  if Log <> nil then
  Log.DebugLnExit('RELEASEREF');
  Result := inherited _Release;
end;

function TUIFormBit.AsForm: TCustomForm;
begin
  Result := AsControl as TCustomForm;
end;

procedure TUIFormBit.ResetScroll;
var
  mLastChild: INode;
  mOpposite: integer;
begin
  if Node.Count > 0 then
    mLastChild := Node[Node.Count - 1];
  if mLastChild <> nil then
  begin
    mOpposite := (mLastChild as IUIPlace).Left + (mLastChild as IUIPlace).Width - 1;
    if mOpposite > Width then
       AsForm.HorzScrollBar.Range := mOpposite
     else
       AsForm.HorzScrollBar.Range := 0;
    mOpposite := (mLastChild as IUIPlace).Top + (mLastChild as IUIPlace).Height - 1;
    if mOpposite > Height then
       AsForm.VertScrollBar.Range := mOpposite
     else
       AsForm.VertScrollBar.Range := 0;
  end;
end;

procedure TUIFormBit.OnResize(Sender: TObject);
begin
  if ResizeNotifier <> nil then
{
  ResizeNotifier.Notify(
    TProps.New
    .SetInt('Left', AsControl.Left)
    .SetInt('Top', AsControl.Top)
    .SetInt('Width', AsControl.Width)
    .SetInt('Height', AsControl.Height)
    );
    }
    ResizeNotifier.Notify;
end;

procedure TUIFormBit.ResizeNotifierData(const AProps: IProps);
begin
  AProps
  .SetInt('Left', AsControl.Left)
  .SetInt('Top', AsControl.Top)
  .SetInt('Width', AsControl.Width)
  .SetInt('Height', AsControl.Height);
end;

procedure TUIFormBit.OnPaint(Sender: TObject);
var
  mChild: INode;
begin
  for mChild in Node do
    (mChild as IUIBit).RenderPaint(AsForm.Canvas);
end;

procedure TUIFormBit.DoRender;
begin
  // discard during render should be samewhat general(callbacks could result in
  // another render call .... anyway, do not want to allow whatsever call back during
  // render - because of kiss - so need to cement it somewhere - maybe notifief active
  // property and set it for all notifiers before and after render)
  //AsForm.OnResize := nil;
  if ResizeNotifier <> nil then
    ResizeNotifier.Enabled := False;
  inherited;
  //Layouter.ReplaceChildren(Self);
  Tiler.ReplaceChildren(Self);
  ResetScroll;
  //AsForm.HorzScrollBar.Range:=;
  //AsForm.VertScrollBar.Range:=;

  AsForm.OnPaint := @OnPaint;
  AsForm.Caption := Title;
  AsForm.Show;
  AsForm.OnResize := @OnResize;

  if ResizeNotifier <> nil then begin
    ResizeNotifier.Add(@ResizeNotifierData);
    ResizeNotifier.Enabled := True;
  end;
end;

function TUIFormBit.Surface: TWinControl;
begin
  Result := AsForm;
end;

destructor TUIFormBit.Destroy;
begin
  inherited Destroy;
end;

{ TUIBit }

procedure TUIBit.SetControl(AValue: TControl);
begin
  if fControl = AValue then
    Exit;
  fControl := AValue;
  Color := Control.Color;
end;

procedure TUIBit.SetParentElement(AValue: IUnknown);
begin
  fParentElement := AValue;
  // parent must be weak reference ... otherwise interface lock
  if fParentElement <> nil then
    fParentElement._Release;
end;

procedure TUIBit.AddChild(const ANode: INode);
begin
  Node.AddChild(ANode);
end;

procedure TUIBit.RemoveChild(const ANode: INode);
begin
  Node.RemoveChild(ANode);
end;

procedure TUIBit.Insert(const AIndex: integer; const ANode: INode);
begin
  Node.Insert(AIndex, ANode);
end;

procedure TUIBit.Delete(const AIndex: integer);
begin
 Node.Delete(AIndex);
end;

function TUIBit.Count: integer;
begin
  Result := Node.Count;
end;

function TUIBit.GetChild(const AIndex: integer): INode;
begin
  Result := Node[AIndex];
end;

function TUIBit.GetNodeEnumerator: INodeEnumerator;
begin
  Result := Node.GetEnumerator;
end;

procedure TUIBit.Render;
var
  mChild: INode;
begin
  //AsControl.Hide;
  DoRender;
  if AsControl <> nil then
    Log.DebugLn('RENDERED ' + ClassName
      + ' L:' + IntToStr(AsControl.Left)
      + ' T:' + IntToStr(AsControl.Top)
      + ' W:' + IntToStr(AsControl.Width)
      + ' H:' + IntToStr(AsControl.Height)
      + ' VIS:' + BoolToStr(AsControl.Visible)
      )
  else
    Log.DebugLn('RENDERED NO CONTROL');

  Log.DebugLn('BIT SIZE ' + ClassName
    + ' L:' + IntToStr(Left)
    + ' T:' + IntToStr(Top)
    + ' W:' + IntToStr(Width)
    + ' H:' + IntToStr(Height)
    );

  for mChild in Node do
    (mChild as IUIBit).Render;
  //AsControl.Show;
end;

function TUIBit.Surface: TWinControl;
begin
  if ParentElement <> nil then
    Result := (ParentElement as IUIBit).Surface
  else
    Result := nil;
end;

procedure TUIBit.RenderPaint(const ACanvas: TCanvas);
begin
  DoRenderPaint(ACanvas);
end;

function TUIBit.GetLayout: integer;
begin
  Result := fLayout;
end;

function TUIBit.GetPlace: integer;
begin
  Result := fPlace;
end;

function TUIBit.GetMMWidth: integer;
begin
  Result := fMMWidth;
end;

function TUIBit.GetMMHeight: integer;
begin
  Result := fMMHeight;
end;

function TUIBit.GetLeft: integer;
begin
  Result := fLeft;
end;

function TUIBit.GetTop: integer;
begin
  Result := fTop;
end;

function TUIBit.GetWidth: integer;
begin
  Result := fWidth;
end;

function TUIBit.GetHeight: integer;
begin
  Result := fHeight;
end;

procedure TUIBit.SetLayout(AValue: integer);
begin
  fLayout := AValue;
end;

procedure TUIBit.SetPlace(AValue: integer);
begin
  fPlace := AValue;
end;

procedure TUIBit.SetMMWidth(AValue: integer);
begin
  fMMWidth := AValue;
end;

procedure TUIBit.SetMMHeight(AValue: integer);
begin
  fMMHeight := AValue;
end;

procedure TUIBit.SetLeft(AValue: integer);
var
  m:string;
begin
  m:=classname;
  fLeft := AValue;
end;

procedure TUIBit.SetTop(AValue: integer);
begin
  fTop := AValue;
end;

procedure TUIBit.SetWidth(AValue: integer);
begin
  fWidth := AValue;
end;

procedure TUIBit.SetHeight(AValue: integer);
begin
  fHeight := AValue;
end;

function TUIBit.AsControl: TControl;
begin
  Result := fControl;
end;

procedure TUIBit.DoRender;
begin
  AsControl.AutoSize := False;
  AsControl.Left := Left;
  AsControl.Top := Top;
  AsControl.Width := Width;
  AsControl.Height := Height;
  AsControl.Color := Color;
end;

procedure TUIBit.DoRenderPaint(const ACanvas: TCanvas);
begin
end;

destructor TUIBit.Destroy;
begin
  FreeAndNil(fControl);
  inherited Destroy;
end;

end.

