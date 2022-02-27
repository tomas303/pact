unit uappgui;

{$mode delphi}{$H+}
{$modeswitch typehelpers}
{$modeswitch multihelpers}

interface

uses
  uappdata, uappfunc, sysutils, dialogs,
  rea_udesigncomponent, rea_idesigncomponent, trl_iprops, trl_imetaelement,
  rea_iflux, rea_ibits, rea_ilayout, trl_itree, trl_idifactory, rea_udesigncomponentfunc,
  rea_udesigncomponentdata, trl_isequence, Graphics, trl_udifactory, rea_irenderer,
  rea_idataconnector;

type

  { TGUI }

  TGUI = class(TDesignComponent, IDesignComponentApp)
  private
    fActionIDSequence: ISequence;
  private
    fMainFormData: TFormData;
    fPagerData: TPagerData;
    fPersonGridData: TGridData;
    fNameData: TEditData;
    fSureNameData: TEditData;
    fTestEditData: TEditData;
    fProvider: IGridDataProvider;
    fMoveNotifier: IFluxNotifier;
    fRenderNotifier: IFluxNotifier;
    procedure NewData;
    procedure ConnectData;
    function NewNotifier(const AActionID: integer): IFluxNotifier;
  private
    fMainForm: IDesignComponent;
    fPersonGrid: IDesignComponent;
    fPager: IDesignComponent;
    fHelloButton: IDesignComponent;
    fTestEdit: IDesignComponent;
    fPersonEdit: IDesignComponent;
    function NewLabEdit(const AEdge: integer; const ACaption: String; AMMWidth, AMMHeight: Integer;
      AColor: TColor; ACapWidth, ACapHeight: Integer): IDesignComponent;
    function NewMainForm: IDesignComponent;
    function NewPersonEdit: IDesignComponent;
    function NewPersonGrid: IDesignComponent;
    function NewPerson: IDesignComponent;
    function NewHelloButton: IDesignComponent;
    function NewTestEdit: IDesignComponent;
    function NewPager: IDesignComponent;
    function NewPageDemo: IDesignComponent;
    function NewPageGrid: IDesignComponent;
    function NewPageGridEdit: IDesignComponent;
    function NewMovePrevButton: IDesignComponent;
    function NewMoveNextButton: IDesignComponent;
    function NewLabelEdit(const ACaption: String; AData: TEditData): IDesignComponent;
  protected
    procedure InitValues; override;
    function DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement; override;
  protected
    fDataConnector: IDataConnector;
  published
    property DataConnector: IDataConnector read fDataConnector write fDataConnector;
  end;

implementation

{ TGUI }

function TGUI.NewLabEdit(const AEdge: integer; const ACaption: String;
  AMMWidth, AMMHeight: Integer; AColor: TColor; ACapWidth, ACapHeight: Integer): IDesignComponent;
var
  mF: IDesignComponentLabelEditFactory;
  mProps: IProps;
begin
  mF := Factory2.Locate<IDesignComponentLabelEditFactory>;
  mProps := NewProps
    .SetBool(cProps.Flat, True)
    .SetStr(cProps.Caption, ACaption)
    .SetInt(cProps.CaptionEdge, AEdge)
    .SetInt(cProps.Color, AColor)
    .SetInt(cProps.TextColor, clWhite)
    .SetBool(cProps.Transparent, False)
    .SetInt(cProps.MMWidth, AMMWidth)
    .SetInt(cProps.MMHeight, AMMHeight)
    .SetInt(cProps.CaptionWidth, ACapWidth)
    .SetInt(cProps.CaptionHeight, ACapHeight)
    .SetInt(cProps.CaptionEditBorder, 1)
    .SetInt(cProps.CaptionEditBorderColor, clLime)
    ;
  Result := mF.New(mProps);
end;

function TGUI.NewMainForm: IDesignComponent;
var
  mF: IDesignComponentFormFactory;
begin
  mF := Factory2.Locate<IDesignComponentFormFactory>;
  Result := mF.New(NewProps.SetObject('Data', fMainFormData));
end;

function TGUI.NewPersonEdit: IDesignComponent;
var
  mF: IDesignComponentStripFactory;
begin
  mF := Factory2.Locate<IDesignComponentStripFactory>;
  Result := mF.New(NewProps
    .SetInt(cProps.MMWidth, 200)
    .SetInt(cProps.Place, cPlace.FixBack)
    .SetInt(cProps.Layout, cLayout.Vertical)
    .SetInt(cProps.Color, clBlack)
    //.SetInt(cProps.Border, 5)
    //.SetInt(cProps.BorderColor, clBlack)
  );
  //(Result as INode).AddChild( NewLabEdit(cEdge.Top, 'Name', 0, 70, clBlack, 0, 30) as INode);
  //(Result as INode).AddChild( NewLabEdit(cEdge.Top, 'Surename', 0, 70, clBlack, 0, 30) as INode);
  (Result as INode).AddChild( NewLabelEdit('Name', fNameData) as INode);
  (Result as INode).AddChild( NewLabelEdit('Surename', fSureNameData) as INode);
end;

function TGUI.NewPersonGrid: IDesignComponent;
var
  mF: IDesignComponentGridFactory;
begin
  mF := Factory2.Locate<IDesignComponentGridFactory>;
  Result := mF.New(NewProps
    .SetObject('Data', fPersonGridData)
    .SetInt('MMHeight', 1000)
    .SetInt('MMWidth', 1000)
    .SetInt(cProps.RowMMHeight, 25)
    .SetInt(cProps.ColMMWidth, 25)
    //.SetInt(cProps.ColOddColor, clLime)
    //.SetInt(cProps.ColEvenColor, clAqua)
    .SetInt(cProps.RowOddColor, clBlack)
    .SetInt(cProps.RowEvenColor, clBlack)
    .SetInt(cProps.Color, clBlack)
    .SetInt(cProps.TextColor, clWhite)
    .SetInt('LaticeColColor', clLime)
    .SetInt('LaticeColSize', 1)
    .SetInt('LaticeRowColor', clLime)
    .SetInt('LaticeRowSize', 1)
    .SetIntf('DataToGUI', fMoveNotifier)
  );
end;

function TGUI.NewPerson: IDesignComponent;
begin
  Result := Factory2.Locate<IDesignComponentHBox>(NewProps
    .SetInt(cProps.Place, cPlace.Elastic)
    .SetInt(cProps.Color, clBlack)
    .SetInt(cProps.BoxLaticeSize, 10)
  );
  (Result as INode).AddChild(fPersonGrid as INode);
  (Result as INode).AddChild(fPersonEdit as INode);
end;

function TGUI.NewHelloButton: IDesignComponent;
var
  mF: IDesignComponentButtonFactory;
  mBClickFunc: IFluxFunc;
begin
  mF := Factory2.Locate<IDesignComponentButtonFactory>;
  mBClickFunc := THelloButtonClickFunc.Create(fActionIDSequence.Next);
  Result := mF.New(NewProps
    .SetIntf(cProps.ClickFunc, mBClickFunc)
    .SetStr(cProps.Text, 'Hello')
  );
end;

function TGUI.NewTestEdit: IDesignComponent;
var
  mF: IDesignComponentEditFactory;
  mEKeyDownFunc, mEKeyTextChangedFunc: IFluxFunc;
begin
  mF := Factory2.Locate<IDesignComponentEditFactory>;
  mEKeyDownFunc := TTestKeyDownFunc.Create(fActionIDSequence.Next);
  mEKeyTextChangedFunc := TTestTextChangedFunc.Create(fActionIDSequence.Next);
  Result := mF.New(NewProps
    .SetObject('Data', fTestEditData)
    .SetIntf(cProps.KeyDownFunc, mEKeyDownFunc)
    .SetIntf(cProps.TextChangedFunc, mEKeyTextChangedFunc)
    .SetStr(cProps.Text, 'Test')
  );
end;

function TGUI.NewPager: IDesignComponent;
var
  mF: IDesignComponentPagerFactory;
begin
  mF := Factory2.Locate<IDesignComponentPagerFactory>;
  Result := mF.New(NewProps
    .SetObject('Data', fPagerData)
    .SetInt(cProps.SwitchEdge, cEdge.Right)
    .SetInt(cProps.SwitchSize, 40)
  );
end;

function TGUI.NewPageDemo: IDesignComponent;
var
  mF: IDesignComponentStripFactory;
  mStrip: IDesignComponent;
  mP: IProps;
begin
  mF := Factory2.Locate<IDesignComponentStripFactory>;
  Result := mF.New(NewProps
    .SetInt(cProps.Layout, cLayout.Vertical)
    .SetStr(cProps.Caption, 'Demo')
    .SetInt(cProps.Color, clRed)
    .SetBool(cProps.Transparent, False));
  {
  mStrip := mF.New(NewProps
    .SetInt(cProps.MMWidth, 400)
    .SetInt(cProps.MMHeight, 200)
    .SetInt(cProps.Place, cPlace.FixMiddle)
    .SetInt(cProps.Layout, cLayout.Vertical)
    );
  (mStrip as INode).AddChild(fHelloButton as INode);
  (mStrip as INode).AddChild(fTestEdit as INode);
  (Result as INode).AddChild(mStrip as INode);
  }

  mP := NewProps
  .SetInt(cProps.Place, cPlace.FixFront)
  .SetInt(cProps.MMHeight, 120)
  .SetInt(cProps.Color, clMoneyGreen);
  (Result as INode).AddChild((Factory2.Locate<IDesignComponentButton>(mP)) as INode);
  (Result as INode).AddChild((Factory2.Locate<IDesignComponentButton>(mP)) as INode);
  (Result as INode).AddChild((Factory2.Locate<IDesignComponentButton>(mP)) as INode);
  (Result as INode).AddChild((Factory2.Locate<IDesignComponentButton>(mP)) as INode);
  (Result as INode).AddChild((Factory2.Locate<IDesignComponentButton>(mP)) as INode);
end;

function TGUI.NewPageGrid: IDesignComponent;
var
  mHBox: IDesignComponent;
begin
  Result := Factory2.Locate<IDesignComponentVBox>(NewProps
    .SetStr(cProps.Caption, 'Grid')
    .SetInt(cProps.Color, clBlack)
    .SetBool(cProps.Transparent, False)
    .SetInt(cProps.BoxLaticeSize, 20)
    );
  mHBox := Factory2.Locate<IDesignComponentHBox>(NewProps
    .SetInt(cProps.Color, clBlack)
    .SetBool(cProps.Transparent, False)
    .SetInt(cProps.BoxLaticeSize, 50)
    );
  (mHBox as INode).AddChild(fPersonGrid as INode);
  (Result as INode).AddChild(mHBox as INode);
  mHBox := Factory2.Locate<IDesignComponentHBox>(NewProps
    .SetInt(cProps.BoxLaticeSize, 10)
    );
  (mHBox as INode).AddChild(NewMovePrevButton as INode);
  (mHBox as INode).AddChild(NewMoveNextButton as INode);
  (Result as INode).AddChild(mHBox as INode);
end;

function TGUI.NewPageGridEdit: IDesignComponent;
var
  mHBox: IDesignComponent;
begin
  Result := Factory2.Locate<IDesignComponentVBox>(NewProps
    .SetStr(cProps.Caption, 'Grid edit')
    .SetInt(cProps.Color, clBlack)
    .SetBool(cProps.Transparent, False)
    .SetInt(cProps.BoxLaticeSize, 10)
  );
  (Result as INode).AddChild(NewPerson as INode);

  mHBox := Factory2.Locate<IDesignComponentHBox>(NewProps
      .SetInt(cProps.BoxLaticeSize, 10)
      );
  (mHBox as INode).AddChild(NewMovePrevButton as INode);
  (mHBox as INode).AddChild(NewMoveNextButton as INode);
  (Result as INode).AddChild(mHBox as INode);
end;

function TGUI.NewMovePrevButton: IDesignComponent;
var
  mF: IDesignComponentButtonFactory;
  mFunc: IFluxFunc;
begin
  mF := Factory2.Locate<IDesignComponentButtonFactory>;
  mFunc := TMovePrevFunc.Create(fActionIDSequence.Next, fProvider);
  Result := mF.New(NewProps
    .SetIntf(cProps.ClickFunc, mFunc)
    .SetStr(cProps.Text, 'Prev')
  );
end;

function TGUI.NewMoveNextButton: IDesignComponent;
var
  mF: IDesignComponentButtonFactory;
  mFunc: IFluxFunc;
begin
  mF := Factory2.Locate<IDesignComponentButtonFactory>;
  mFunc := TMoveNextFunc.Create(fActionIDSequence.Next, fProvider);
  Result := mF.New(NewProps
    .SetIntf(cProps.ClickFunc, mFunc)
    .SetStr(cProps.Text, 'Next')
  );
end;

function TGUI.NewLabelEdit(const ACaption: String; AData: TEditData): IDesignComponent;
var
  mF: IDesignComponentLabelEditFactory;
  mProps: IProps;
begin
  mF := Factory2.Locate<IDesignComponentLabelEditFactory>;
  mProps := NewProps
    .SetObject('Data', AData)
    .SetBool(cProps.Flat, True)
    .SetInt(cProps.CaptionEditBorder, 1)
    .SetStr(cProps.Caption, ACaption)
    .SetInt(cProps.CaptionEdge, cEdge.Top)
    .SetInt(cProps.CaptionHeight, 30)
    .SetInt(cProps.MMHeight, 70);
  Result := mF.New(mProps);
end;

procedure TGUI.NewData;
begin
  fPersonGridData := TGridData.Create;
  fPersonGridData.RowCount := 10;
  fPersonGridData.ColCount := 2;
  //
  fMainFormData := TFormData.Create;
  fMainFormData.Left := 0;
  fMainFormData.Top := 0;
  fMainFormData.Width := 800;
  fMainFormData.Height := 400;
  //
  fTestEditData := TEditData.Create;
  fPagerData := TPagerData.Create;
  //
  fNameData := TEditData.Create;
  fSureNameData := TEditData.Create;
end;

procedure TGUI.ConnectData;
begin
  DataConnector.Connect(fProvider, fPersonGridData, [0,1]);
  DataConnector.Connect(fProvider, fNameData, 0);
  DataConnector.Connect(fProvider, fSureNameData, 1);
end;

function TGUI.NewNotifier(const AActionID: integer): IFluxNotifier;
begin
  Result := Factory2.Locate<IFluxNotifier>(NewProps.SetInt(cAction.ActionID, AActionID));
end;

procedure TGUI.InitValues;
begin
  inherited InitValues;
  fActionIDSequence := Factory2.Locate<ISequence>('ActionID');
  fMoveNotifier := NewNotifier(fActionIDSequence.Next);
  fRenderNotifier := NewNotifier(cNotifyRender);
  fProvider := Factory2.Locate<IGridDataProvider>(NewProps
    .SetIntf('MoveNotifier', fMoveNotifier)
    .SetIntf('RenderNotifier', fRenderNotifier)
    );
  NewData;
  ConnectData;
  fMoveNotifier.Notify;
  fMainForm := NewMainForm;
  fPersonEdit := NewPersonEdit;
  fPersonGrid := NewPersonGrid;
  fHelloButton := NewHelloButton;
  fTestEdit := NewTestEdit;
  fPager := NewPager;
  (fPager as INode).AddChild(NewPageGrid as INode);
  (fPager as INode).AddChild(NewPageGridEdit as INode);
  (fPager as INode).AddChild(NewPageDemo as INode);
end;

function TGUI.DoCompose(const AProps: IProps;
  const AChildren: TMetaElementArray): IMetaElement;
var
  mPager: IMetaElement;
begin
  mPager := fPager.Compose(AProps, nil);
  Result := fMainForm.Compose(AProps, [mPager as IMetaElement]);
end;

end.

