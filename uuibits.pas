unit uuibits;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, iuibits, Controls, trl_idifactory, forms, trl_itree,
  StdCtrls, trl_iprops, trl_uprops, trl_injector, Graphics, trl_ilog, fgl,
  rea_iuilayout;

type

  { TUIBit }

  TUIBit = class(TInterfacedObject, IUIBit, INode, IUIPlacement, IUIPlace)
  protected
    // INode
    procedure AddChild(const ANode: INode);
    procedure RemoveChild(const ANode: INode);
    function Count: integer;
    function GetChild(const AIndex: integer): INode;
    function GetNodeEnumerator: INodeEnumerator;
    function INode.GetEnumerator = GetNodeEnumerator;
  protected
    // IUIBit
    procedure Render;
    function Surface: TWinControl; virtual;
  protected
    fColor: TColor;
    function AsControl: TControl;
    procedure SetControl(AValue: TControl);
    procedure SetParentElement(AValue: IUnknown);
  protected
    procedure DoRender; virtual;
  public
    destructor Destroy; override;
  protected
    fLog: ILog;
    fNode: INode;
    fFactory: IDIFactory;
    fControl: TControl;
    fParentElement: IUnknown;
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
    function AsForm: TCustomForm;
    procedure ResetScroll;
  protected
    procedure DoRender; override;
    function Surface: TWinControl; override;
  protected
    fTiler: IUITiler;
    fTitle: string;
  published
    property Tiler: IUITiler read fTiler write fTiler;
    property Title: string read fTitle write fTitle;
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

implementation

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

procedure TUIFormBit.DoRender;
begin
  inherited;
  //Layouter.ReplaceChildren(Self);
  Tiler.ReplaceChildren(Self);
  ResetScroll;
  //AsForm.HorzScrollBar.Range:=;
  //AsForm.VertScrollBar.Range:=;

  AsForm.Caption := Title;
  AsForm.Show;
end;

function TUIFormBit.Surface: TWinControl;
begin
  Result := AsForm;
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
  DoRender;
  for mChild in Node do
    (mChild as IUIBit).Render;
end;

function TUIBit.Surface: TWinControl;
begin
  if ParentElement <> nil then
    Result := (ParentElement as IUIBit).Surface
  else
    Result := nil;
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
begin
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

destructor TUIBit.Destroy;
begin
  FreeAndNil(fControl);
  inherited Destroy;
end;

end.

