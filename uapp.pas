unit uapp;

{$mode objfpc}{$H+}

interface

uses
  iapp, uappfunc, uappdata, uappgui,
  tal_uapp, flu_iflux,
  rea_idesigncomponent, rea_udesigncomponent, rea_udesigncomponentdata, rea_udesigncomponentfunc,
  trl_ilog, trl_idifactory, trl_iExecutor, trl_dicontainer, trl_ilauncher,
  trl_iprops, trl_imetaelement, rea_irenderer,
  Forms, Graphics, tal_uwinfunc, rea_urenderer, trl_itree, rea_ibits, rea_ilayout,
  trl_isequence;

type

  { TApp }

  TApp = class(TALApp)
  private
    fExecutor: IExecutor;
    fFluxDispatcher: IFluxDispatcher;
    fRenderer: IRenderer;
  private
    fMainFormData: TFormData;
    fNamesGridData: TGridData;
    fTestEditData: TEditData;
    fGUI: IDesignComponentApp;
    fPagerData: TPagerData;
  private
    function NewProps: IProps;
    function NewAction(AActionID: integer): IFluxAction;
    function NewNotifier(const AActionID: integer): IFluxNotifier;
    function NewMainForm: IDesignComponentForm;
    function NewNamesGrid:  IDesignComponentGrid;
    function NewTestEdit:  IDesignComponentEdit;
    function NewPager: IDesignComponentPager;
  protected
    procedure RegisterAppServices; override;
    procedure BeforeLaunch; override;
  end;

implementation

{ TApp }

function TApp.NewProps: IProps;
begin
  Result := IProps(DIC.Locate(IProps));
end;

function TApp.NewAction(AActionID: integer): IFluxAction;
begin
  Result := IFluxAction(DIC.Locate(IFluxAction, '',
    NewProps
    .SetInt('ID', AActionID)
  ));
end;

function TApp.NewNotifier(const AActionID: integer): IFluxNotifier;
begin
  Result := IFluxNotifier(DIC.Locate(IFluxNotifier, '',
    NewProps
    .SetInt('ActionID', AActionID)
    .SetIntf('Dispatcher', fFluxDispatcher)
  ));
end;

function TApp.NewMainForm: IDesignComponentForm;
begin
  Result :=
   IDesignComponentForm(DIC.Locate(IDesignComponentForm, '',
    NewProps
    .SetObject('Data', fMainFormData)
    .SetIntf('CloseQueryNotifier', NewNotifier(-303))
    .SetIntf('SizeNotifier', NewNotifier(-101))
    .SetIntf('MoveNotifier', NewNotifier(-102))
  ));

  fFluxDispatcher.RegisterFunc(TCloseQueryFunc.Create(-303));
  fFluxDispatcher.RegisterFunc(TSizeFunc.Create(-101, fMainFormData, NewNotifier(-400)));
  fFluxDispatcher.RegisterFunc(TMoveFunc.Create(-102, fMainFormData));
end;

function TApp.NewNamesGrid: IDesignComponentGrid;
begin
  Result :=
   IDesignComponentGrid(DIC.Locate(IDesignComponentGrid, '',
    NewProps
      .SetObject('Data', fNamesGridData)
      .SetIntf('EdTextChangedNotifier', NewNotifier(-150))
      .SetIntf('EdKeyDownNotifier', NewNotifier(-151))
      .SetInt('MMHeight', 1000)
      .SetInt('MMWidth', 1000)
      .SetInt(cProps.RowMMHeight, 25)
      .SetInt(cProps.ColMMWidth, 25)
      .SetInt(cProps.ColOddColor, clLime)
      .SetInt(cProps.ColEvenColor, clAqua)
      .SetInt(cProps.RowOddColor, clRed)
      .SetInt(cProps.RowEvenColor, clYellow)
      .SetInt(cProps.Color, clMaroon)
      .SetInt('LaticeColColor', clRed)
      .SetInt('LaticeColSize', 10)
      .SetInt('LaticeRowColor', clGreen)
      .SetInt('LaticeRowSize', 2)
  ));
  fFluxDispatcher.RegisterFunc(TGridEdTextChangedFunc.Create(-150, fNamesGridData, NewNotifier(-400)));
  fFluxDispatcher.RegisterFunc(TGridEdKeyDownFunc.Create(-151, fNamesGridData, NewNotifier(-400)));
end;

function TApp.NewTestEdit: IDesignComponentEdit;
begin
  Result :=
   IDesignComponentEdit(DIC.Locate(IDesignComponentEdit, '',
    NewProps
      .SetObject('Data', fTestEditData)
      .SetBool('Flat', True)
      .SetIntf('TextChangedNotifier', NewNotifier(-160))
   ));
  fFluxDispatcher.RegisterFunc(TextChangedFunc.Create(-160, fTestEditData));
end;

function TApp.NewPager: IDesignComponentPager;
var
  mPage: IDesignComponent;
begin
  Result :=
   IDesignComponentPager(DIC.Locate(IDesignComponentPager, '',
   NewProps
   .SetObject('Data', fPagerData)
   .SetIntf('SwitchFactory', IUnknown(DIC.Locate(IDesignComponentPagerSwitchFactory)))
   .SetInt(IDesignComponentPager.SwitchEdge, IDesignComponentPager.SwitchEdgeRight)
   .SetInt(IDesignComponentPager.SwitchSize, 40)
  ));
  mPage := IDesignComponentHeader(DIC.Locate(IDesignComponentHeader, '', NewProps.SetStr(cProps.Caption, 'red').SetInt(cProps.Color, clRed).SetBool(cProps.Transparent, False)));
  (Result as INode).AddChild(mPage as INode);
  mPage := IDesignComponentHeader(DIC.Locate(IDesignComponentHeader, '', NewProps.SetStr(cProps.Caption, 'blue').SetInt(cProps.Color, clblue).SetBool(cProps.Transparent, False)));
  (Result as INode).AddChild(mPage as INode);
  mPage := IDesignComponentHeader(DIC.Locate(IDesignComponentHeader, '', NewProps.SetStr(cProps.Caption, 'green').SetInt(cProps.Color, clgreen).SetBool(cProps.Transparent, False)));
  (Result as INode).AddChild(mPage as INode);
end;

procedure TApp.RegisterAppServices;
var
  mReg: TDIReg;
begin
  inherited;
  RegApps.RegisterWindowLog;
  RegReact.RegisterCommon;
  RegFlux.RegisterCommon;
  RegRedux.RegisterCommon(
    //[TRdxResizeFunc.ClassName]
  );
  RegApps.RegisterReactLauncher;

  RegRuntime.RegisterSequence('ActionID');


  //mReg := DIC.Add(TDesignComponentPagerPageFactory, IDesignComponentFactory);
  //mReg.InjectProp('Factory', IDIFactory);
  //mReg.InjectProp('FluxFuncReg', IFluxFuncReg);
  //mReg.InjectProp('ActionIDSequence', ISequence, 'ActionID');

  //RegReact.RegisterDesignComponent(TDesignComponentApp, IDesignComponentApp);
end;

procedure TApp.BeforeLaunch;
var
  mDisp: IFluxDispatcher;
begin
  inherited BeforeLaunch;
  fExecutor := IExecutor(DIC.Locate(IExecutor));
  fFluxDispatcher := IFluxDispatcher(DIC.Locate(IFluxDispatcher, '',
    NewProps
    .SetIntf('Executor', fExecutor)));
  fRenderer := IRenderer(DIC.Locate(IRenderer));

  fMainFormData := TFormData.Create;
  fMainFormData.Left := 0;
  fMainFormData.Top := 0;
  fMainFormData.Width := 800;
  fMainFormData.Height := 400;

  fNamesGridData := TGridData.Create(TDummyGridDataProvider.Create);
  fNamesGridData.RowCount := 10;
  fNamesGridData.ColCount := 2;
  fNamesGridData.ReadData;

  fTestEditData := TEditData.Create;
  fTestEditData.Focused := True;
  fTestEditData.Text := 'testovaci edit';

  fPagerData := TPagerData.Create;

  fGUI := TGUI.Create(NewMainForm, NewNamesGrid, NewPager);

  fFluxDispatcher.RegisterFunc(TRenderFunc.Create(-400, fGUI, fRenderer));
  NewNotifier(-400).Notify;

  fFluxDispatcher.RegisterFunc(TProcessMessagesFunc.Create(-401, NewNotifier(-401)));
  NewNotifier(-401).Notify;

end;

end.


