unit rea_ureact;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, rea_ireact, fgl, trl_iprops, iuibits,
  trl_itree, trl_idifactory, trl_irttibroker, trl_urttibroker,
  trl_uprops, trl_udifactory, trl_ilog;

type

  { TMetaElementEnumerator }

  TMetaElementEnumerator = class(TInterfacedObject, IMetaElementEnumerator)
  protected
    fNodeEnumerator: INodeEnumerator;
  protected
    // IMetaElementEnumerator
    function MoveNext: Boolean;
    function GetCurrent: IMetaElement;
    property Current: IMetaElement read GetCurrent;
  public
    constructor Create(const ANodeEnumerator: INodeEnumerator);
  end;

  { TMetaElement }

  TMetaElement = class(TInterfacedObject, IMetaElement, INode)
  protected
    // IMetaElement
    fTypeGuid: string;
    fTypeID: string;
    fProps: IProps;
    function Guid: TGuid;
    function GetTypeGuid: string;
    function GetTypeID: string;
    function GetProps: IProps;
  published
    property TypeGuid: string read GetTypeGuid write fTypeGuid;
    property TypeID: string read GetTypeID write fTypeID;
    property Props: IProps read GetProps write fProps;
  protected
    // INode
    procedure AddChild(const ANode: INode);
    procedure RemoveChild(const ANode: INode);
    function Count: integer;
    function GetChild(const AIndex: integer): INode;
    function GetNodeEnumerator: INodeEnumerator;
    function INode.GetEnumerator = GetNodeEnumerator;
  public
    destructor Destroy; override;
  protected
    fNode: INode;
  published
    property Node: INode read fNode write fNode;
  end;

  { TMetaElementFactory }

  TMetaElementFactory = class(TDIFactory, IMetaElementFactory)
  protected
    //IMetaElementFactory
    function New(const AMetaElement: IMetaElement): IUnknown;
  protected
    fLog: ILog;
  published
    property Log: ILog read fLog write fLog;
  end;

  { TReact }

  TReact = class(TInterfacedObject, IReact)
  protected
    fElementFactory: IMetaElementFactory;
    fTopBit: IUIBit;
    fFactory: IDIFactory;
  protected
    //IReact
    function CreateElement(const ATypeGuid: TGuid): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const AProps: IProps): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const AProps: IProps;
      const AChildren: array of IMetaElement): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const ATypeID: string): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const ATypeID: string; const AProps: IProps): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const ATypeID: string; const AProps: IProps;
      const AChildren: array of IMetaElement): IMetaElement;
    procedure Render(const AElement: IMetaElement);
  published
    property Factory: IDIFactory read fFactory write fFactory;
    property ElementFactory: IMetaElementFactory read fElementFactory write fElementFactory;
  end;

implementation

{ TMetaElementEnumerator }

function TMetaElementEnumerator.MoveNext: Boolean;
begin
  Result := fNodeEnumerator.MoveNext;
end;

function TMetaElementEnumerator.GetCurrent: IMetaElement;
begin
  Result := fNodeEnumerator.Current as IMetaElement;
end;

constructor TMetaElementEnumerator.Create(const ANodeEnumerator: INodeEnumerator
  );
begin
  fNodeEnumerator := ANodeEnumerator;
end;

{ TMetaElementFactory }

function TMetaElementFactory.New(const AMetaElement: IMetaElement): IUnknown;
var
  i: integer;
  mChildElement: IMetaElement;
  mChildNode: INode;
  mChild: IUnknown;
begin
  Log.DebugLnEnter({$I %CURRENTROUTINE%});
  Result := IUnknown(Container.Locate(AMetaElement.Guid, AMetaElement.TypeID, AMetaElement.Props));
  Log.DebugLn('created ' + (Result as TObject).ClassName);
  for mChildNode in (AMetaElement as INode) do begin
    mChildElement := mChildNode as IMetaElement;
    mChildElement.Props.SetIntf('ParentElement', Result);
    mChild := New(mChildElement);
    (Result as INode).AddChild(mChild as INode);
    Log.DebugLn('added child ' + (mChild as TObject).ClassName);
  end;
  Log.DebugLnExit({$I %CURRENTROUTINE%});
end;

{ TReact }

function TReact.CreateElement(const ATypeGuid: TGuid): IMetaElement;
begin
  Result := CreateElement(ATypeGuid, '', nil, []);
end;

function TReact.CreateElement(const ATypeGuid: TGuid; const AProps: IProps
  ): IMetaElement;
begin
  Result := CreateElement(ATypeGuid, '', AProps, []);
end;

function TReact.CreateElement(const ATypeGuid: TGuid; const AProps: IProps;
  const AChildren: array of IMetaElement): IMetaElement;
begin
  Result := CreateElement(ATypeGuid, '', AProps, AChildren);
end;

function TReact.CreateElement(const ATypeGuid: TGuid; const ATypeID: string
  ): IMetaElement;
begin
  Result := CreateElement(ATypeGuid, ATypeID, nil, []);
end;

function TReact.CreateElement(const ATypeGuid: TGuid; const ATypeID: string;
  const AProps: IProps): IMetaElement;
begin
  Result := CreateElement(ATypeGuid, ATypeID, AProps, []);
end;

function TReact.CreateElement(const ATypeGuid: TGuid; const ATypeID: string;
  const AProps: IProps; const AChildren: array of IMetaElement): IMetaElement;
var
  mChild: IMetaElement;
  mRB: IRBData;
  mP: Pointer;
  mo, mo2: tobject;
begin
  mp := Factory.Locate(IMetaElement, '',
    TProps.New
    .SetStr('TypeGuid', GUIDToString(ATypeGuid))
    .SetStr('TypeID', ATypeID)
    .SetIntf('Props', AProps));
  Result := IMetaElement(mP);
  for mChild in AChildren do begin
    //Result.Add(mChild);
//    mo := mChild as TObject;
//    mo2 := (mChild as INode) as TObject;
    (Result as INode).AddChild(mChild as INode);
  end;

  { later - before it is necessary to add some inject params
  directly to locate method ..... like injection on demand
  and maybe it will be better to override even static injection to use props
  with TGUID type aswell - based on client should be easily distinguish
  between IUnknown and TGUID
  better with testings
  ??? anebo
  xxx := difactory.locate(IMetaElement)
  xxx.typguid:=
  xxx.typeid:=
  xxx.props:=

  xxx.children ... as INode.add
  }

  {
  Result := TMetaElement.New(ATypeGuid, ATypeID, AProps, AChildren);
  ime := result as IMetaData;
  if ime = nil then
   raise Exception.create('');
  }

end;

procedure TReact.Render(const AElement: IMetaElement);
begin
  fTopBit := ElementFactory.New(AElement) as IUIBit;
  fTopBit.Render;
end;

{ TMetaElement }

function TMetaElement.Guid: TGuid;
begin
  Result := StringToGUID(fTypeGuid);
end;

function TMetaElement.GetTypeGuid: string;
begin
  Result := fTypeGuid;
end;

function TMetaElement.GetTypeID: string;
begin
  Result := fTypeID;
end;

function TMetaElement.GetProps: IProps;
begin
  Result := fProps;
end;

procedure TMetaElement.AddChild(const ANode: INode);
begin
  Node.AddChild(ANode);
end;

procedure TMetaElement.RemoveChild(const ANode: INode);
begin
  Node.RemoveChild(ANode);
end;

function TMetaElement.Count: integer;
begin
  Result := Node.Count;
end;

function TMetaElement.GetChild(const AIndex: integer): INode;
begin
  Result := Node[AIndex];
end;

destructor TMetaElement.Destroy;
begin
  inherited Destroy;
end;

function TMetaElement.GetNodeEnumerator: INodeEnumerator;
begin
  Result := Node.GetEnumerator;
end;

end.

