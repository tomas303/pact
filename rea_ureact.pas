unit rea_ureact;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, rea_ireact, fgl, trl_iprops, iuibits,
  trl_itree, trl_idifactory, trl_irttibroker, trl_urttibroker,
  trl_uprops, trl_udifactory, trl_ilog, trl_iinjector, rea_iredux, rea_iuilayout,
  graphics, iapp;

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
    procedure Insert(const AIndex: integer; const ANode: INode);
    procedure Delete(const AIndex: integer);
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

  { TComposite }

  TComposite = class(TInterfacedObject, IComposite)
  protected
    function NewNotifier(const AActionID: integer): IAppNotifier;
    function NewProps: IProps;
  protected
    function ComposeElement(const AProps: IProps; const AChildren: array of IMetaElement): IMetaElement; virtual; abstract;
  protected
    // IComposite
    function CreateElement(const ASourceElement: IMetaElement): IMetaElement;
  protected
    fFactory: IDIFactory;
    fElementFactory: IMetaElementFactory;
    fMapStateToProps: IMapStateToProps;
    fLog: ILog;
  published
    property Factory: IDIFactory read fFactory write fFactory;
    property ElementFactory: IMetaElementFactory read fElementFactory write fElementFactory;
    property MapStateToProps: IMapStateToProps read fMapStateToProps write fMapStateToProps;
    property Log: ILog read fLog write fLog;
  end;

  { TComposites }

  TComposites = class(TInterfacedObject, IComposites)
  protected type
    TItems = specialize TFPGInterfacedObjectList<IComposite>;
  protected
    fItems: TItems;
    function GetItems: TItems;
    property Items: TItems read GetItems;
  protected
    // IComposites
    function GetCount: integer;
    function GetItem(const AIndex: integer): IComposite;
    procedure Add(const AComposite: IComposite);
    property Count: integer read GetCount;
    property Item[const AIndex: integer]: IComposite read GetItem; default;
  public
    destructor Destroy; override;
  end;

  { TAppComposite }

  TAppComposite = class(TComposite, IAppComposite)
  protected
    function ComposeElement(const AProps: IProps; const AChildren: array of IMetaElement): IMetaElement; override;
  end;

  { TFormComposite }

  TFormComposite = class(TComposite, IFormComposite)
  protected
    function ComposeElement(const AProps: IProps; const AChildren: array of IMetaElement): IMetaElement; override;
  protected
    fActionResize: integer;
  published
    property ActionResize: integer read fActionResize write fActionResize;
  end;

  { TEditComposite }

  TEditComposite = class(TComposite, IEditComposite)
  protected
    function ComposeElement(const AProps: IProps; const AChildren: array of IMetaElement): IMetaElement; override;
  end;

  { TEditsComposite }

  TEditsComposite = class(TComposite, IEditsComposite)
  protected
    function ComposeElement(const AProps: IProps; const AChildren: array of IMetaElement): IMetaElement; override;
  end;

  { TButtonComposite }

  TButtonComposite = class(TComposite, IButtonComposite)
  protected
    function ComposeElement(const AProps: IProps; const AChildren: array of IMetaElement): IMetaElement; override;
  protected
    fActionClick: integer;
  published
    property ActionClick: integer read fActionClick write fActionClick;
  end;

  { TButtonsComposite }

  TButtonsComposite = class(TComposite, IButtonsComposite)
  protected
    function ComposeElement(const AProps: IProps; const AChildren: array of IMetaElement): IMetaElement; override;
  end;

  { THeaderComposite }

  THeaderComposite = class(TComposite, IHeaderComposite)
  protected
    function ComposeElement(const AProps: IProps; const AChildren: array of IMetaElement): IMetaElement; override;
  end;

  { TReactComponent }

  TReactComponent = class(TInterfacedObject, IReactComponent, INode)
  protected
    // later remove setting from interface and made it part of on demand injection
    // in place, where react component is created
    fElement: IMetaElement;
    fComposite: IComposite;
    fBit: IUIBit;
  protected
    // IReactComponent
    procedure Rerender(const AUpperComponent: IReactComponent);
    //procedure AddComposite(const AComposite: IComposite);
    procedure ResetData(const AElement: IMetaElement; const AComposite: IComposite;
      const ABit: IUIBit);
    function GetElement: IMetaElement;
    property Element: IMetaElement read GetElement;
    function GetComposite: IComposite;
    property Composite: IComposite read GetComposite;
    function GetBit: IUIBit;
    property Bit: IUIBit read GetBit;
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
    fLog: ILog;
    fNode: INode;
    //fComposites: IComposites;
    fReconciliator: IReconciliator;
    fReactFactory: IReactFactory;
  published
    property Log: ILog read fLog write fLog;
    property Node: INode read fNode write fNode;
    //property Composites: IComposites read fComposites write fComposites;
    property Reconciliator: IReconciliator read fReconciliator write fReconciliator;
    property ReactFactory: IReactFactory read fReactFactory write fReactFactory;
  end;

  { TXReactComponent }

  TXReactComponent = class(TInterfacedObject, IXReactComponent, INode)
  protected
    procedure DoRerender; virtual;
  protected
    // IXReactComponent
    procedure Rerender;
    procedure ResetData(const AElement: IMetaElement; const AObject: IUnknown);
    function GetElement: IMetaElement;
    property Element: IMetaElement read GetElement;
  protected
    fNode: INode;
    fReconciliator: IReconciliator;
    property NodeImp: INode read fNode implements INode;
  published
    property Node: INode read fNode write fNode;
    property Reconciliator: IReconciliator read fReconciliator write fReconciliator;
  end;

  { TUIBitComponent }

  TUIBitComponent = class(TXReactComponent, IUIBitComponent)
  protected
    procedure DoRerender; override;
  protected
    // IUIBitComponent
    function GetUIBit: IUIBit;
    property UIBit: IUIBit read GetUIBit;
  protected
    fUIBit: IUIBit;
  end;

  { TCompositeComponent }

  TCompositeComponent = class(TXReactComponent, ICompositeComponent)
  protected
    procedure DoRerender; override;
  protected
    // ICompositeComponent
    function GetComposite: IComposite;
    property Composite: IComposite read GetComposite;
  protected
    fComposite: IComposite;
  end;


  { TMetaElementFactory }

  TMetaElementFactory = class(TDIFactory, IMetaElementFactory)
  protected
    procedure CreateChildren(const AParentElement: INode; const AParentInstance: INode);
    procedure CopyChildren(const AParentElement: INode; const AParentInstance: INode);
    //IMetaElementFactory
    function New(const AMetaElement: IMetaElement): IUnknown;
    function CreateElement(const ATypeGuid: TGuid): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const AProps: IProps): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const AChildren: array of IMetaElement): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const AProps: IProps;
      const AChildren: array of IMetaElement): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const ATypeID: string): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const ATypeID: string; const AProps: IProps): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const ATypeID: string; const AChildren: array of IMetaElement): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const ATypeID: string; const AProps: IProps;
      const AChildren: array of IMetaElement): IMetaElement;
  protected
    fLog: ILog;
  published
    property Log: ILog read fLog write fLog;
  end;

  { TReactFactory }

  TReactFactory = class(TDIFactory, IReactFactory)
  protected
    function MakeBit(const AMetaElement: IMetaElement; const AComposites: IComposites): IUIBit;
    function MakeBit1(const AMetaElement: IMetaElement; const AComponent: IReactComponent): IUIBit;
    procedure MakeChildren(const AParentElement: INode; const AParentInstance: INode);
    procedure MakeChildren1(const AParentElement: INode; const AParentInstance: INode;
      const AComponent: IReactComponent);
    function GetChildrenAsArray(const AParentElement: INode): TMetaElementArray;
  protected
    function MakeComponent3(const AMetaElement: IMetaElement; const AParentBit: IUIBit): IXReactComponent;
  protected
    // IReactFactory
    function New(const AMetaElement: IMetaElement): IReactComponent;
    function New1(const AMetaElement: IMetaElement; const AComponent: IReactComponent): IUIBit;
    function New2(const AMetaElement: IMetaElement): IXReactComponent;
  protected
    fLog: ILog;
  published
    property Log: ILog read fLog write fLog;
  end;

  { TReconciliator }

  TReconciliator = class(TInterfacedObject, IReconciliator)
  protected
    function NewUIBit(const AParentComponent: IReactComponent; const ANewElement: IMetaElement): IUIBit;
    function Decomposite(const AObject: IUnknown): IUIBit;
  protected
    // setup diff of props between AOldElement / ANewElement to ABit
    function EqualizeProps(var ABit: IUIBit; const AOldElement, ANewElement: IMetaElement): Boolean;
    // elements exists in both old and new structure or only in old structure
    function EqualizeOriginalChildren(const AComponent: IReactComponent; var ABit: IUIBit; const AOldElement, ANewElement: IMetaElement): Boolean;
    // elements exists only in new structure
    function EqualizeNewChildren(const AComponent: IReactComponent; var ABit: IUIBit; const AOldElement, ANewElement: IMetaElement): Boolean;
    function Equalize(const AComponent: IReactComponent; var ABit: IUIBit; const AOldElement, ANewElement: IMetaElement): Boolean;
  protected
    // IReconciliator
    function Reconciliate(const AComponent: IReactComponent; var ABit: IUIBit; const AOldElement, ANewElement: IMetaElement): Boolean;
  protected
    fLog: ILog;
    //fElementFactory: IMetaElementFactory;
    fReactFactory: IReactFactory;
    fInjector: IInjector;
  published
    property Log: ILog read fLog write fLog;
    //property ElementFactory: IMetaElementFactory read fElementFactory write fElementFactory;
    property ReactFactory: IReactFactory read fReactFactory write fReactFactory;
    property Injector: IInjector read fInjector write fInjector;
  end;

  { TReact }

  TReact = class(TInterfacedObject, IReact)

  // finall solution:
  // fTopBit - tree of bits
  // fTopComposite - tree of composites
  //   this tree will be traversed when rerender - and ShouldUpdate - logiccaly
  //   arranged in same tree order, so if top is chagned, all in its subtree are
  //   also
  //   composite is only node, which can change bits - so this is why, it will
  //    save children elements (for rerender - those are input params)
  //   when composite rerender, it will create new metaelement based on which I can
  //   update part of bits tree
  //   composite tree will be created together when reconciliate .... reconciliate
  //   is agnostic because compare only elements

  // old comments
  // ???
  // ftopbit - ok - aka DOM
  // fTopElement - ok - aka vDOM
  // 1. - where will be reacomponents placed?

  // 2. - from what and how second vDOM will be rendered?


  // component ->(render)-> IMetaElement|IReaComponent
  //           IMetaElement - will add to parent
  //           IRea-Componet - repaet rekurz.
  // (react is maybe different - IMetaElement can create IReaComponent or IUIBit
  //   but I will do it)

  // how to do it? true is that IUIBit is visible part, IReactComponent is nonvisible part
  // of rendered area
  // so it make sense do it as react - I can mix it without constrints
  // (IReaComponets insidet IUIForm) - but dont forget that IReaComponent must register
  // with connect functions specific for each application


  // where to place IReaComponent - question is if is neccessary to leave it
  // (stateless probably not in anycase) but for now I will
  // ReaComponent has props and will map to redux to change props in accord of app. state

  // when props are changed, react need Rerender(probably async aswell .... could be
  // Sync ... but then is not possible to batch more changes and one must have absolute insurance,
  // that render will cause no callback)

  // so bakc to my question - only part of tree could be rendered - but is hard to find this specific part
  // so easier is to make entire vDOM new and reconciliate it with old one

  // since lifecycle of IUIBits and IRea

  protected
    fTopBit: IUIBit;
    fTopElement: IMetaElement;
    fTopComponent: IXReactComponent;
  protected
    //IReact
    procedure Render(const AElement: IMetaElement);
    procedure Rerender;
  protected
    fLog: ILog;
    fReactFactory: IReactFactory;
    fInjector: IInjector;
    fReconciliator: IReconciliator;
    fRootComponent: IReactComponent;
  published
    property Log: ILog read fLog write fLog;
    property ReactFactory: IReactFactory read fReactFactory write fReactFactory;
    property Injector: IInjector read fInjector write fInjector;
    property Reconciliator: IReconciliator read fReconciliator write fReconciliator;
    property RootComponent: IReactComponent read fRootComponent write fRootComponent;
  end;

implementation

{ TButtonsComposite }

function TButtonsComposite.ComposeElement(const AProps: IProps;
  const AChildren: array of IMetaElement): IMetaElement;
var
  i: integer;
  mButtons: IProps;
  mButton: IProps;
begin
  Result := ElementFactory.CreateElement(IUIStripBit, TProps.New.SetInt('Layout', AProps.AsInt('Layout')));
  mButtons := AProps.AsIntf('Buttons') as IProps;
  for i := 0 to mButtons.Count - 1 do
  begin
    mButton := mButtons.AsIntf(i) as IProps;
    (Result as INode).AddChild(
      ElementFactory.CreateElement(IButtonComposite,
        TProps.New
        .SetStr('Caption', mButton.AsStr('Caption'))
        .SetInt('ActionClick', mButton.AsInt('ActionClick'))
        .SetInt('Place', cPlace.FixFront)
        .SetInt('MMWidth', 100)
        .SetInt('MMHeight', 22)
        ) as INode);
  end;
end;

{ TButtonComposite }

function TButtonComposite.ComposeElement(const AProps: IProps;
  const AChildren: array of IMetaElement): IMetaElement;
begin
  if ActionClick <> 0 then
  begin
    AProps.SetIntf('ClickNotifier', NewNotifier(ActionClick));
  end;
  Result := ElementFactory.CreateElement(IUIButtonBit, AProps);
end;

{ TUIBitComponent }

procedure TUIBitComponent.DoRerender;
begin
  inherited DoRerender;
  //Reconciliator.Reconciliate(); ????
  //element bit ?
  {



   CC - El a composite .... composite.new
     if child.el <> mnew el, zrusime child a dame nove .... in this case
     only one child either composite or bit

     ReactFactory.New2(AElement);

     can have whatsever child ....

   BC - bit rerender









  }

  UIBit.Render;
end;

function TUIBitComponent.GetUIBit: IUIBit;
begin
  Result := fUIBit;
end;

{ TCompositeComponent }

procedure TCompositeComponent.DoRerender;
begin
  inherited DoRerender;
end;

function TCompositeComponent.GetComposite: IComposite;
begin
  Result := fComposite;
end;

{ TXReactComponent }

procedure TXReactComponent.DoRerender;
begin
end;

procedure TXReactComponent.Rerender;
var
  mChild: INode;
begin
  DoRerender;
  for mChild in Node do begin
    (mChild as IXReactComponent).Rerender;
  end;
end;

procedure TXReactComponent.ResetData(const AElement: IMetaElement;
  const AObject: IUnknown);
begin

end;

function TXReactComponent.GetElement: IMetaElement;
begin

end;

{ TEditsComposite }

function TEditsComposite.ComposeElement(const AProps: IProps;
  const AChildren: array of IMetaElement): IMetaElement;
var
  mTitles, mValues: TStringArray;
  mTitle: String;
  i: integer;
begin
  // maybe add support for array ... as generic? probably with new fpc sources
  mTitles := AProps.AsStr('Titles').Split('|');
  mValues := AProps.AsStr('Values').Split('|');
  Result := ElementFactory.CreateElement(IUIStripBit, AProps{.SetInt('Layout', uiLayoutVertical)});
  for i := 0 to High(mValues) do begin
    if i > High(mTitles) then
      mTitle := ''
    else
      mTitle := mTitles[i];
    (Result as INode).AddChild(
      ElementFactory.CreateElement(IEditComposite,
        TProps.New
        .SetStr('Title', mTitle)
        .SetStr('Value', mValues[i])
        .SetInt('Place', cPlace.FixFront)
        .SetInt('MMHeight', 22)
        ) as INode);
  end;
end;

{ TEditComposite }

function TEditComposite.ComposeElement(const AProps: IProps;
  const AChildren: array of IMetaElement): IMetaElement;
var
  mTitle, mValue: string;
begin
  // can make it aswell as property .... then there will be values from create time
  mTitle := AProps.AsStr('Title');
  mValue := AProps.AsStr('Value');
  {
  Result := ElementFactory.CreateElement(IUIStripBit,
    AProps.SetInt('Layout', 0),
    [ElementFactory.CreateElement(IUITextBit, TProps.New.SetStr('Text', mTitle)),
     ElementFactory.CreateElement(IUIEditBit, TProps.New.SetStr('Text', mValue)))
     ]
   );
  }
  Result := ElementFactory.CreateElement(IUIStripBit, AProps.SetInt('Layout', cLayout.Horizontal));
  if mTitle <> '' then
    (Result as INode).AddChild(ElementFactory.CreateElement(IUITextBit, TProps.New.SetStr('Text', mTitle)) as INode);
  (Result as INode).AddChild(ElementFactory.CreateElement(IUIEditBit, TProps.New.SetStr('Text', mValue)) as INode);
end;

{ TAppComposite }

function TAppComposite.ComposeElement(const AProps: IProps;
  const AChildren: array of IMetaElement): IMetaElement;
var
  mProps: IProps;
  mButtons: IProps;
  mButton: IProps;
begin
  // from original props used to create this element are properties, children
  // are not covered, but best will be make composit aswell tree aware ... so
  // composite after creation will have its own tree(props was alredy used for creation) and children given
  // as parameters are dynamic one ... from last creation
  // even though i dont know for what good they will be

  //AProps
  //  .SetStr('Title', 'Hello world')
  //  .SetInt('Layout', 0);
  //Result := ElementFactory.CreateElement(
  //  IFormComposite, AProps,
  //  [
  //    ElementFactory.CreateElement(IEditComposite,
  //      TProps.New
  //        .SetStr('Title', 'Name')
  //        .SetStr('Value', '<empty>')
  //        .SetInt('MMWidth', 100)
  //        .SetInt('MMHeight', 10)
  //    )
  //  ]);

  //AProps
  //  .SetStr('Title', 'Hello world')
  //  .SetInt('Layout', cLayout.Vertical);
  //Result := ElementFactory.CreateElement(
  //  IFormComposite, AProps,
  //  [
  //    ElementFactory.CreateElement(IHeaderComposite),
  //    ElementFactory.CreateElement(IEditsComposite,
  //      TProps.New
  //        .SetStr('Titles', 'Name|Surname|Age')
  //        .SetStr('Values', 'Bob|MacIntosh|24')
  //        .SetInt('Layout', cLayout.Vertical)
  //        //.SetInt('MMWidth', 100)
  //        //.SetInt('MMHeight', 10)
  //    )
  //  ]);

  //an idea
  //.SetInt('ChildPlace', cPlace.FixFront)

  mButtons := NewProps;
  mButton := NewProps;
  mButton.SetStr('Caption', 'One').SetInt('ActionClick', cActions.ClickOne);
  mButtons.SetIntf('1', mButton);
  mButton := NewProps;
  mButton.SetStr('Caption', 'Two').SetInt('ActionClick', cActions.ClickTwo);
  mButtons.SetIntf('2', mButton);
  mButton := NewProps;
  mButton.SetStr('Caption', 'Three').SetInt('ActionClick', cActions.ClickThree);
  mButtons.SetIntf('3', mButton);


  mProps := TProps.New;
  Result := ElementFactory.CreateElement(
    IFormComposite, 'mainform',  mProps.Clone.SetStr('Title', 'Hello world').SetInt('Layout', cLayout.Horizontal){.SetInt('Color', clYellow)},
    [

      ElementFactory.CreateElement(IButtonsComposite,
      NewProps.SetIntf('Buttons', mButtons).SetInt('Layout', cLayout.Vertical)),

      ElementFactory.CreateElement(IHeaderComposite,
      TProps.New,
      [
        ElementFactory.CreateElement(IHeaderComposite,
        mProps.Clone.SetInt('Layout', cLayout.Horizontal),
        [
          ElementFactory.CreateElement(IHeaderComposite,
          mProps.Clone.SetBool('Transparent', False)
          .SetInt('Color', clRed)
          .SetStr('Title', 'One')
          .SetInt('FontColor', clYellow)
          .SetInt('Border', 5)
          .SetInt('BorderColor', clPurple)
          ),
          ElementFactory.CreateElement(IHeaderComposite,
          mProps.Clone.SetBool('Transparent', False)
          .SetInt('Color', clBlack)
          .SetStr('Title', 'Two')
          .SetInt('FontColor', clLime)
          .SetInt('Border', 5)
          .SetInt('BorderColor', clAqua)
          )
        ])
      ])
    ]);
end;

{ THeaderComposite }

function THeaderComposite.ComposeElement(const AProps: IProps;
  const AChildren: array of IMetaElement): IMetaElement;
var
  mChild: IMetaElement;
begin
  Result := ElementFactory.CreateElement(IUIStripBit, AProps);
  for mChild in AChildren do
    (Result as INode).AddChild(mChild as INode);
end;

{ TReactComponent }

procedure TReactComponent.Rerender(const AUpperComponent: IReactComponent);
var
  mNewBit: IUIBit;
  mNewElement: IMetaElement;
  mChildNode: INode;
  mChildComponent: IReactComponent;
begin
  //if composite.shouldupdate ... and later througs all, maybe via composites
  if Composite <> nil then
  begin
    Log.DebugLn('rerendering %s', [(Composite as TObject).ClassName]);

    mNewBit := Bit;
    mNewElement := Composite.CreateElement(Element);
    if Reconciliator.Reconciliate(self, mNewBit, Element, mNewElement) then
    begin
      if Bit <> mNewBit  then begin
        fBit := mNewBit;
        fElement := mNewElement;
      end;
      Bit.Render;
    end
    else
    begin
      for mChildNode in Node do begin
        mChildComponent := mChildNode as IReactComponent;
        mChildComponent.Rerender(Self);
      end;
    end;
  end
  else
  begin
    for mChildNode in Node do begin
      mChildComponent := mChildNode as IReactComponent;
      mChildComponent.Rerender(Self);
    end;
  end;
end;

//procedure TReactComponent.AddComposite(const AComposite: IComposite);
//begin
//  Composites.Add(AComposite);
//end;

procedure TReactComponent.ResetData(const AElement: IMetaElement;
  const AComposite: IComposite; const ABit: IUIBit);
begin
  fElement := AElement;
  fComposite := AComposite;
  fBit := ABit;
end;

function TReactComponent.GetElement: IMetaElement;
begin
  Result := fElement;
end;

function TReactComponent.GetComposite: IComposite;
begin
  Result := fComposite;
end;

function TReactComponent.GetBit: IUIBit;
begin
  Result := fBit;
end;

procedure TReactComponent.AddChild(const ANode: INode);
begin
  Node.AddChild(ANode);
end;

procedure TReactComponent.RemoveChild(const ANode: INode);
begin
  Node.RemoveChild(ANode);
end;

procedure TReactComponent.Insert(const AIndex: integer; const ANode: INode);
begin
  Node.Insert(AIndex, ANode);
end;

procedure TReactComponent.Delete(const AIndex: integer);
begin
  Node.Delete(AIndex);
end;

function TReactComponent.Count: integer;
begin
  Result := Node.Count;
end;

function TReactComponent.GetChild(const AIndex: integer): INode;
begin
  Result := Node.Child[AIndex];
end;

function TReactComponent.GetNodeEnumerator: INodeEnumerator;
begin
  Result := Node.GetEnumerator;
end;

{ TComposites }

function TComposites.GetItems: TItems;
begin
  if fItems = nil then
    fItems := TItems.Create;
  Result := fItems;
end;

function TComposites.GetCount: integer;
begin
  Result := Items.Count;
end;

function TComposites.GetItem(const AIndex: integer): IComposite;
begin
  Result := Items[AIndex];
end;

procedure TComposites.Add(const AComposite: IComposite);
begin
  Items.Add(AComposite);
end;

destructor TComposites.Destroy;
begin
  FreeAndNil(fItems);
  inherited Destroy;
end;

{ TReactFactory }

function TReactFactory.MakeBit(const AMetaElement: IMetaElement;
  const AComposites: IComposites): IUIBit;
var
  mNew: IUnknown;
  mComposite: IComposite;
  mElement: IMetaElement;
  mmm: array of IMetaElement;
begin
  Log.DebugLnEnter({$I %CURRENTROUTINE%});
  mNew := IUnknown(Container.Locate(AMetaElement.Guid, AMetaElement.TypeID, AMetaElement.Props));
  if Supports(mNew, IComposite, mComposite) then begin
    AComposites.Add(mComposite);
//    mElement := mComposite.CreateElement(AMetaElement.Props, GetChildrenAsArray(AMetaElement as INode));  //getchildelements
    mElement := mComposite.CreateElement(AMetaElement);  //getchildelements
    Result := MakeBit(mElement, AComposites);
  end
  else
  if Supports(mNew, IUIBit, Result) then
  begin
    MakeChildren(AMetaElement as INode, Result as INode);
  end
  else
  begin
    raise Exception.Create('unsupported element definition');
  end;
  Log.DebugLnExit({$I %CURRENTROUTINE%});
end;

function TReactFactory.MakeBit1(const AMetaElement: IMetaElement;
  const AComponent: IReactComponent): IUIBit;
var
  mNew: IUnknown;
  mComposite: IComposite;
  mElement: IMetaElement;
  mComponent: IReactComponent;
  mc: integer;
begin
  Log.DebugLnEnter({$I %CURRENTROUTINE%});
  mc:=AMetaElement.Props.Count;
  mNew := IUnknown(Container.Locate(AMetaElement.Guid, AMetaElement.TypeID, AMetaElement.Props));
  if Supports(mNew, IComposite, mComposite) then
  begin
    mComponent := IReactComponent(Container.Locate(IReactComponent));
    (AComponent as INode).AddChild(mComponent as INode);
    mElement := mComposite.CreateElement(AMetaElement);
    Result := MakeBit1(mElement, mComponent);
    mComponent.ResetData(mElement, mComposite, Result);
  end
  else
  if Supports(mNew, IUIBit, Result) then
  begin
    MakeChildren1(AMetaElement as INode, Result as INode, AComponent);
  end
  else
  begin
    raise Exception.Create('unsupported element definition');
  end;
  Log.DebugLnExit({$I %CURRENTROUTINE%});
end;

procedure TReactFactory.MakeChildren(const AParentElement: INode;
  const AParentInstance: INode);
var
  mChild: IReactComponent;
  mChildNode: INode;
  mChildElement: IMetaElement;
begin
  Log.DebugLnEnter({$I %CURRENTROUTINE%});
  for mChildNode in AParentElement do begin
    mChildElement := mChildNode as IMetaElement;
    //mChildElement.Props.SetIntf( 'ParentElement', AParentInstance);
//    mChild := New(mChildElement);
//    AParentInstance.AddChild(mChild.UIBit as INode);
  end;
  Log.DebugLnEnter({$I %CURRENTROUTINE%});
end;

procedure TReactFactory.MakeChildren1(const AParentElement: INode;
  const AParentInstance: INode; const AComponent: IReactComponent);
var
  mChild: IUIBit;
  mChildNode: INode;
  mChildElement: IMetaElement;
begin
  Log.DebugLnEnter({$I %CURRENTROUTINE%});
  for mChildNode in AParentElement do begin
    mChildElement := mChildNode as IMetaElement;
    //mChildElement.Props.SetIntf( 'ParentElement', AParentInstance);
    mChild := New1(mChildElement, AComponent);
    AParentInstance.AddChild(mChild as INode);
  end;
  Log.DebugLnEnter({$I %CURRENTROUTINE%});
end;

function TReactFactory.GetChildrenAsArray(const AParentElement: INode): TMetaElementArray;
var
  mChildNode: INode;
  mChildElement: IMetaElement;
  i: integer;
begin
  Log.DebugLnEnter({$I %CURRENTROUTINE%});
  SetLength(Result, (AParentElement as INode).Count);
  for i := 0 to (AParentElement as INode).Count - 1 do begin
    Result[i] := (AParentElement as INode).Child[i] as IMetaElement;
  end;
  Log.DebugLnEnter({$I %CURRENTROUTINE%});
end;

function TReactFactory.MakeComponent3(const AMetaElement: IMetaElement;
  const AParentBit: IUIBit): IXReactComponent;
var
  mNew: IUnknown;
  mResult: IUnknown;

  mComposite: IComposite;
  mBit: IUIBit;
  mElement: IMetaElement;
  mComponent: IReactComponent;
  mc, i: integer;

  mChild: IXReactComponent;
  mChildNode: INode;
begin
  Log.DebugLnEnter({$I %CURRENTROUTINE%});
  mNew := IUnknown(Container.Locate(AMetaElement.Guid, AMetaElement.TypeID, AMetaElement.Props));
  if Supports(mNew, IComposite, mComposite) then
  begin
    mResult := IUnknown(Container.Locate(ICompositeComponent, '',
      TProps.New.SetIntf('Composite', mComposite).SetIntf('Element', AMetaElement)));
    mElement := mComposite.CreateElement(AMetaElement);
    mChild := MakeComponent3(mElement, AParentBit);
    (mResult as INode).AddChild(mChild as INode);
  end
  else
  if Supports(mNew, IUIBit, mBit) then
  begin
    mResult := IUnknown(Container.Locate(IUIBitComponent, '',
      TProps.New.SetIntf('UIBit', mBit).SetIntf('Element', AMetaElement)));
    if AParentBit <> nil then
      (AParentBit as INode).AddChild(mNew as INode);
    for mChildNode in (AMetaElement as INode) do begin
      mElement := mChildNode as IMetaElement;
      //mElement.Props.SetIntf( 'ParentElement', mBit);
      mChild := MakeComponent3(mElement, mBit);
      (mResult as INode).AddChild(mChild as INode);
    end;
  end
  else
  begin
    raise Exception.Create('unsupported element definition');
  end;
  Result := mResult as IXReactComponent;
  Log.DebugLnExit({$I %CURRENTROUTINE%});
end;

function TReactFactory.New(const AMetaElement: IMetaElement): IReactComponent;
begin
  Log.DebugLnEnter({$I %CURRENTROUTINE%});
  Result := IReactComponent(Container.Locate(IReactComponent));
  //Result.UIBit := MakeBit(AMetaElement, Result.Composites);
  Log.DebugLnExit({$I %CURRENTROUTINE%});
end;

function TReactFactory.New1(const AMetaElement: IMetaElement;
  const AComponent: IReactComponent): IUIBit;
begin
  Log.DebugLnEnter({$I %CURRENTROUTINE%});
  Result := MakeBit1(AMetaElement, AComponent);
  Log.DebugLnExit({$I %CURRENTROUTINE%});
end;

function TReactFactory.New2(const AMetaElement: IMetaElement): IXReactComponent;
begin
  Result := MakeComponent3(AMetaElement, nil);
end;

{ TFormComposite }

function TFormComposite.ComposeElement(const AProps: IProps;
  const AChildren: array of IMetaElement): IMetaElement;
var
  mChild: IMetaElement;
  //mw: integer;
begin
  //mw := AProps.AsInt('Width');
  //AProps.SetInt('Color', Random($FFFFFF));
  if ActionResize <> 0 then
  begin
    AProps.SetIntf('ResizeNotifier', NewNotifier(ActionResize));
  end;
  Result := ElementFactory.CreateElement(IUIFormBit, AProps);
  for mChild in AChildren do begin
    (Result as INode).AddChild(mChild as INode);
  end;
end;

{ TComposite }

function TComposite.NewNotifier(const AActionID: integer): IAppNotifier;
begin
  Result := IAppNotifier(Factory.Locate(IAppNotifier, '', TProps.New.SetInt('ActionID', AActionID)));
end;

function TComposite.NewProps: IProps;
begin
  Result := IProps(Factory.Locate(IProps));
end;

function TComposite.CreateElement(const ASourceElement: IMetaElement): IMetaElement;
var
  mProps: IProps;
  mChildren: TMetaElementArray;
  i: integer;
begin
  if MapStateToProps <> nil then
  begin
    Log.DebugLn('map props %s info %s', [ClassName, ASourceElement.Props.Info]);
    mProps := MapStateToProps.Map(ASourceElement.Props);
  end
  else
  begin
    Log.DebugLn('clone props %s info %s', [ClassName, ASourceElement.Props.Info]);
    mProps := ASourceElement.Props.Clone;
  end;
  SetLength(mChildren, (ASourceElement as INode).Count);
  for i := 0 to (ASourceElement as INode).Count - 1 do begin
    mChildren[i] := (ASourceElement as INode).Child[i] as IMetaElement;
  end;
  Result := ComposeElement(mProps, mChildren);
end;

{ TReconciliator }

function TReconciliator.Equalize(const AComponent: IReactComponent;
  var ABit: IUIBit; const AOldElement, ANewElement: IMetaElement): Boolean;
var
  mRender: Boolean;
begin
  Result := EqualizeProps(ABit, AOldElement, ANewElement);
  if EqualizeOriginalChildren(AComponent, ABit, AOldElement, ANewElement) then
    Result := True;
  if EqualizeNewChildren(AComponent, ABit, AOldElement, ANewElement) then
    Result := True;
end;

function TReconciliator.EqualizeNewChildren(const AComponent: IReactComponent; var ABit: IUIBit;
  const AOldElement, ANewElement: IMetaElement): Boolean;
var
  i: integer;
  mNewBit: IUIBit;
  mNewEl: IMetaElement;
begin
  Result := False;
  for i := (AOldElement as INode).Count to (ANewElement as INode).Count - 1 do begin
    mNewBit := nil;
    mNewEl := (ANewElement as INode).Child[i] as IMetaElement;
    //mNewEl.Props.SetIntf('ParentElement', ABit);
    Reconciliate(AComponent, mNewBit, nil, mNewEl);
    if mNewBit <> nil then begin
      (ABit as INode).AddChild(mNewBit as INode);
      Result := True;
    end;
  end;
end;

function TReconciliator.EqualizeOriginalChildren(const AComponent: IReactComponent;
  var ABit: IUIBit; const AOldElement, ANewElement: IMetaElement): Boolean;
var
  i: integer;
  mRemoved: integer;
  mBit: IUIBit;
  mNewBit: IUIBit;
  mOldEl: IMetaElement;
  mNewEl: IMetaElement;
begin
  Result := False;
  mRemoved := 0;
  for i := 0 to (AOldElement as INode).Count - 1 do begin
    mBit := (ABit as INode).Child[i - mRemoved] as IUIBit;
    mOldEl := (AOldElement as INode).Child[i] as IMetaElement;
    if i <= (ANewElement as INode).Count - 1 then begin
      mNewEl := (ANewElement as INode).Child[i] as IMetaElement;
      //mNewEl.Props.SetIntf('ParentElement', ABit);
    end
    else
      mNewEl := nil;
    mNewBit := mBit;
    Reconciliate(AComponent, mNewBit, mOldEl, mNewEl);
    if mNewBit <> mBit then begin
      (ABit as INode).Delete(i - mRemoved);
      if mNewBit <> nil then begin
        (ABit as INode).Insert(i - mRemoved, mNewBit as INode);
        dec(mRemoved);
      end;
      inc(mRemoved);
      Result := True;
    end;
  end;
end;

function TReconciliator.NewUIBit(const AParentComponent: IReactComponent;
  const ANewElement: IMetaElement): IUIBit;
var
  mNew: IUnknown;
begin
  mNew := ReactFactory.New1(ANewElement, AParentComponent);
  Result := Decomposite(mNew);
end;

function TReconciliator.Decomposite(const AObject: IUnknown): IUIBit;
var
  i: integer;
  mComposite: IComposite;
  mBit: IUIBit;
begin
  //// what am I supposed to do with children ?
  //// it could be composites or bits (or mix)
  //// when start to decomposite from leaves, it will always be bits ... good
  //// so when decompositing - and thus createelement - I need pass to it aswell
  //// all children so far .... but problem is those are real bits, not elements
  //// it is probalby as react function anyway??? but how to do it, since result
  //// is IMetaElement and it will create its own children --- better to
  //
  //// in case I will do it directly in new, I have those childre still as IMetaelements
  //// so I can pass it to component.render .... so this is really where to go
  ////
  //
  //if Supports(AObject, IComposite, mComposite) then begin
  //  Result := NewUIBit(mComposite.Render);
  //end
  //else if Supports(AObject, IUIBit, mBit) then begin
  //  Result := mBit;
  //else
  //  raise Exception.Create('unable decomposite');
  //end;
  ////for i := 0 to (ABit as INode).Count - 1 do begin
  ////    mBit := (ABit as INode).Child[i - mRemoved] as IUIBit;
  ////    mOldEl := (AOldElement as INode).Child[i] as IMetaElement;
  ////    if i <= (ANewElement as INode).Count - 1 then begin
  ////      mNewEl := (ANewElement as INode).Child[i] as IMetaElement;
  ////      mNewEl.Props.SetIntf('ParentElement', ABit);
  ////    end
  //
end;

function TReconciliator.EqualizeProps(var ABit: IUIBit; const AOldElement, ANewElement: IMetaElement): Boolean;
var
  mDiffProps: IProps;
  mRender: Boolean;
begin
  Result := False;
  mDiffProps := ANewElement.Props.Diff(AOldElement.Props);
  if mDiffProps.Count > 0 then begin
    Injector.Write(ABit as TObject, mDiffProps);
    Result := True;
  end;
end;

function TReconciliator.Reconciliate(const AComponent: IReactComponent;
  var ABit: IUIBit; const AOldElement, ANewElement: IMetaElement): Boolean;
begin
  Log.DebugLnEnter({$I %CURRENTROUTINE%});
  Result := False;
  if (AOldElement = nil) and (ANewElement = nil) then begin
    ABit := nil;
    Log.DebugLn('both nil');
  end else
  if (AOldElement <> nil) and (ANewElement = nil) then begin
    ABit := nil;
    Log.DebugLn(AOldElement.TypeGuid + '.' + AOldElement.TypeID + ' to nil');
    Result := True;
  end else
  if (AOldElement = nil) and (ANewElement <> nil) then begin
    ABit := ReactFactory.New1(ANewElement, AComponent) as IUIBit;
    Log.DebugLn('from nil to ' + ANewElement.TypeGuid + '.' + ANewElement.TypeID);
    Result := True;
  end else
  if (AOldElement.TypeGuid <> ANewElement.TypeGuid) or (AOldElement.TypeID <> ANewElement.TypeID) then begin
    ABit := ReactFactory.New1(ANewElement, AComponent) as IUIBit;
    Log.DebugLn('from ' + AOldElement.TypeGuid + '.' + AOldElement.TypeID + ' to ' + ANewElement.TypeGuid + '.' + ANewElement.TypeID);
    Result := True;
  end else begin
    Result := Equalize(AComponent, ABit, AOldElement, ANewElement);
  end;
  Log.DebugLnExit({$I %CURRENTROUTINE%});
end;

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

procedure TMetaElementFactory.CreateChildren(const AParentElement: INode; const AParentInstance: INode);
var
  mChild: IUnknown;
  mChildNode: INode;
  mChildElement: IMetaElement;
begin
  for mChildNode in AParentElement do begin
    mChildElement := mChildNode as IMetaElement;
    //mChildElement.Props.SetIntf( 'ParentElement', AParentInstance);
    mChild := New(mChildElement);
    AParentInstance.AddChild(mChild as INode);
    Log.DebugLn( 'created child ' + (mChild as TObject).ClassName);
  end;
end;

procedure TMetaElementFactory.CopyChildren(const AParentElement: INode;
  const AParentInstance: INode);
var
  mChildNode: INode;
  mChildElement: IMetaElement;
begin
  for mChildNode in AParentElement do begin
    AParentInstance.AddChild(mChildNode);
    Log.DebugLn( 'added child ');
  end;
end;

function TMetaElementFactory.New(const AMetaElement: IMetaElement): IUnknown;
begin
  Log.DebugLnEnter({$I %CURRENTROUTINE%});
  Result := IUnknown(Locate(AMetaElement.Guid, AMetaElement.TypeID, AMetaElement.Props));
  Log.DebugLn('created ' + (Result as TObject).ClassName);
  CreateChildren(AMetaElement as INode, Result as INode);
  Log.DebugLnExit({$I %CURRENTROUTINE%});
end;

function TMetaElementFactory.CreateElement(const ATypeGuid: TGuid
  ): IMetaElement;
begin
  Result := CreateElement(ATypeGuid, '', TProps.New, []);
end;

function TMetaElementFactory.CreateElement(const ATypeGuid: TGuid;
  const AProps: IProps): IMetaElement;
begin
  Result := CreateElement(ATypeGuid, '', AProps, []);
end;

function TMetaElementFactory.CreateElement(const ATypeGuid: TGuid;
  const AChildren: array of IMetaElement): IMetaElement;
begin
  Result := CreateElement(ATypeGuid, '', TProps.New, AChildren);
end;

function TMetaElementFactory.CreateElement(const ATypeGuid: TGuid;
  const AProps: IProps; const AChildren: array of IMetaElement): IMetaElement;
begin
  Result := CreateElement(ATypeGuid, '', AProps, AChildren);
end;

function TMetaElementFactory.CreateElement(const ATypeGuid: TGuid;
  const ATypeID: string): IMetaElement;
begin
  Result := CreateElement(ATypeGuid, ATypeID, TProps.New, []);
end;

function TMetaElementFactory.CreateElement(const ATypeGuid: TGuid;
  const ATypeID: string; const AProps: IProps): IMetaElement;
begin
  Result := CreateElement(ATypeGuid, ATypeID, AProps, []);
end;

function TMetaElementFactory.CreateElement(const ATypeGuid: TGuid;
  const ATypeID: string; const AChildren: array of IMetaElement): IMetaElement;
begin
  Result := CreateElement(ATypeGuid, ATypeID, TProps.New, AChildren);
end;

function TMetaElementFactory.CreateElement(const ATypeGuid: TGuid;
  const ATypeID: string; const AProps: IProps;
  const AChildren: array of IMetaElement): IMetaElement;
var
  mChild: IMetaElement;
  mRB: IRBData;
  mP: Pointer;
begin
  mP := Locate(IMetaElement, '',
    TProps.New
    .SetStr('TypeGuid', GUIDToString(ATypeGuid))
    .SetStr('TypeID', ATypeID)
    .SetIntf('Props', AProps));
  Result := IMetaElement(mP);
  for mChild in AChildren do begin
    (Result as INode).AddChild(mChild as INode);
  end;
end;

{ TReact }

procedure TReact.Render(const AElement: IMetaElement);
var
  mNewTopBit: IUIBit;
  mBit: IUIBit;
begin
  {
  mNewTopBit := fTopBit;
  Reconciliator.Reconciliate(mNewTopBit, fTopElement, AElement);
  if fTopBit <> mNewTopBit  then begin
    fTopBit := mNewTopBit;
    fTopBit.Render;
  end;
  fTopElement := AElement;
  }

  mBit := ReactFactory.New1(AElement, RootComponent);
  RootComponent.ResetData(AElement, nil, mBit);
  RootComponent.Bit.Render;
  {
  fTopComponent := ReactFactory.New2(AElement);
  fTopComponent.Rerender;
  }
end;

procedure TReact.Rerender;
begin
  RootComponent.Rerender(nil);
  {
  if fTopComponent;
  fTopComponent.Rerender;
  }
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

procedure TMetaElement.Insert(const AIndex: integer; const ANode: INode);
begin
  Node.Insert(AIndex, ANode);
end;

procedure TMetaElement.Delete(const AIndex: integer);
begin
  Node.Delete(AIndex);
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

