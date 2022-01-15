unit uappgui;

{$mode objfpc}{$H+}
{$modeswitch typehelpers}
{$modeswitch multihelpers}

interface

uses
  uappdata, sysutils,
  rea_udesigncomponent, rea_idesigncomponent, trl_iprops, trl_imetaelement,
  flu_iflux, rea_ibits, rea_ilayout, trl_itree, trl_idifactory, rea_udesigncomponentfunc,
  rea_udesigncomponentdata, trl_isequence;

type

  { TGUI }

  TGUI = class(TDesignComponent, IDesignComponentApp)
  private
    fMainForm: IDesignComponentForm;
    fNamesGrid: IDesignComponentGrid;
    fPager: IDesignComponentPager;
  protected
    function DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement; override;
  public
    constructor Create(const AMainForm: IDesignComponentForm; const ANamesGrid: IDesignComponentGrid;
      const APager: IDesignComponentPager);
  end;

  { TDesignComponentFactory }

  TDesignComponentFactory = class(TInterfacedObject, IDesignComponentFactory)
  protected
    function New(const AProps: IProps): IDesignComponent;
    function DoNew(const AProps: IProps): IDesignComponent; virtual; abstract;
    function NewNotifier(const AActionID: integer): IFluxNotifier;
    function NewProps: IProps;
  protected
    fFactory: IDIFactory;
    fFluxDispatcher: IFluxDispatcher;
    fActionIDSequence: ISequence;
  published
    property Factory: IDIFactory read fFactory write fFactory;
    property FluxDispatcher: IFluxDispatcher read fFluxDispatcher write fFluxDispatcher;
    property ActionIDSequence: ISequence read fActionIDSequence write fActionIDSequence;
  end;

  { TDesignComponentPagerSwitchFactory }

  TDesignComponentPagerSwitchFactory = class(TDesignComponentFactory, IDesignComponentFactory)
  protected
    function DoNew(const AProps: IProps): IDesignComponent; override;
  end;

  { TDesignComponentPagerPageFactory }

  TDesignComponentPagerPageFactory = class(TDesignComponentFactory, IDesignComponentFactory)
  protected
    function DoNew(const AProps: IProps): IDesignComponent; override;
  end;

implementation

{ TDesignComponentPagerPageFactory }

function TDesignComponentPagerPageFactory.DoNew(const AProps: IProps): IDesignComponent;
begin
  //Result := IDesignComponentHeader(Factory.Locate(IDesignComponentHeader, '',
  //  NewProps.SetInt('PageIndex', PageIndex)));
end;

{ TDesignComponentFactory }

function TDesignComponentFactory.New(const AProps: IProps): IDesignComponent;
begin
  Result := DoNew(AProps);
end;

function TDesignComponentFactory.NewNotifier(const AActionID: integer
  ): IFluxNotifier;
begin
  Result := IFluxNotifier(Factory.Locate(IFluxNotifier, '',
    NewProps
    .SetInt('ActionID', AActionID)
    .SetIntf('Dispatcher', FluxDispatcher)
  ));
end;

function TDesignComponentFactory.NewProps: IProps;
begin
  Result := IProps(Factory.Locate(IProps));
end;

{ TDesignComponentPagerSwitchFactory }

function TDesignComponentPagerSwitchFactory.DoNew(const AProps: IProps): IDesignComponent;
var
  i: integer;
  mProps: IProps;
  mCaptions: TStringArray;
  mTab: IDesignComponentButton;
  mActionID: Integer;
begin
  {
  Result := IDesignComponentHeader(Factory.Locate(IDesignComponentHeader));
  mCaptions := AProps.AsStr('Captions').Split(',');
  for i := Low(mCaptions) to High(mCaptions) do begin
    mActionID := ActionIDSequence.Next;
    mProps := AProps.Clone
      .SetStr(cProps.Text, mCaptions[i])
      .SetInt(cProps.Place, cPlace.Elastic)
      .SetIntf(cProps.ClickNotifier, NewNotifier(mActionID));
    mTab := IDesignComponentButton(Factory.Locate(IDesignComponentButton, '', mProps));
    (Result as INode).AddChild(mTab as INode);
    FluxFuncReg.RegisterFunc(TTabChangedFunc.Create(mActionID, PagerData, NewNotifier(-400), i));
  end;
  }

  mActionID := ActionIDSequence.Next;
  mProps := AProps.Clone
    .SetInt(cProps.Place, cPlace.Elastic)
    .SetIntf(cProps.ClickNotifier, NewNotifier(mActionID));
  Result := IDesignComponentButton(Factory.Locate(IDesignComponentButton, '', mProps));
  FluxDispatcher.RegisterFunc(
    TTabChangedFunc.Create(
      mActionID,
      mProps.AsObject('PagerData') as TPagerData,
      NewNotifier(-400),
      mProps.AsInt('PageIndex')));
end;

{ TGUI }

function TGUI.DoCompose(const AProps: IProps;
  const AChildren: TMetaElementArray): IMetaElement;
var
  mGrid: IMetaElement;
  mPager: IMetaElement;
begin
  Result := fMainForm.Compose(AProps, AChildren);
  //mGrid := fNamesGrid.Compose(AProps, nil);
  //(Result as INode).AddChild(mGrid as INode);
  mPager := fPager.Compose(AProps, nil);
  (Result as INode).AddChild(mPager as INode);
end;

constructor TGUI.Create(const AMainForm: IDesignComponentForm; const ANamesGrid: IDesignComponentGrid;
  const APager: IDesignComponentPager);
begin
  inherited Create;
  fMainForm := AMainForm;
  fNamesGrid := ANamesGrid;
  fPager := APager;
end;

end.

