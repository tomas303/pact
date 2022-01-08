unit uapp;

{$mode objfpc}{$H+}

interface

uses
  iapp, uappfunc, uappdata, uappgui,
  tal_uapp, flu_iflux,
  rea_idesigncomponent, rea_udesigncomponent,
  trl_ilog, trl_idifactory, trl_iExecutor, trl_dicontainer, trl_ilauncher,
  trl_iprops, trl_imetaelement, rea_irenderer,
  Forms;

type

  { TApp }

  TApp = class(TALApp)
  private
    fExecutor: IExecutor;
    fFluxFuncReg: IFluxFuncReg;
    fRenderer: IRenderer;
  private
    fMainFormData: TFormData;
    fGUI: IDesignComponentApp;
  private
    function NewProps: IProps;
    function NewAction(AActionID: integer): IFluxAction;
    function NewNotifier(const AActionID: integer): IFluxNotifier;
    function NewMainForm: IDesignComponentForm;
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
    .SetIntf('Dispatcher', fFluxFuncReg as IFluxDispatcher)
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

  fFluxFuncReg.RegisterFunc(uappfunc.TCloseQueryFunc.Create(-303));
  fFluxFuncReg.RegisterFunc(uappfunc.TSizeFunc.Create(-101, fMainFormData, NewNotifier(-400)));
  fFluxFuncReg.RegisterFunc(uappfunc.TMoveFunc.Create(-102, fMainFormData));
end;

procedure TApp.RegisterAppServices;
var
  mReg: TDIReg;
begin
  inherited;
  RegApps.RegisterWindowLog;
  RegReact.RegisterCommon;
  RegFlux.RegisterCommon(IFluxStore);
  RegRedux.RegisterCommon(
    //[TRdxResizeFunc.ClassName]
  );
  RegApps.RegisterReactLauncher;
  //RegReact.RegisterDesignComponent(TDesignComponentApp, IDesignComponentApp);

  RegReact.RegisterDesignComponent(TDesignComponentForm2, IDesignComponentForm);
end;

procedure TApp.BeforeLaunch;
var
  mDisp: IFluxDispatcher;
begin
  inherited BeforeLaunch;
  fExecutor := IExecutor(DIC.Locate(IExecutor));
  mDisp := IFluxDispatcher(DIC.Locate(IFluxDispatcher, '',
    NewProps
    .SetIntf('Executor', fExecutor)));
  fFluxFuncReg := mDisp as fFluxFuncReg;
  fRenderer := IRenderer(DIC.Locate(IRenderer));

  fMainFormData := TFormData.Create;

  fGUI := TGUI.Create(NewMainForm);

  fFluxFuncReg.RegisterFunc(uappfunc.TRenderGUIFunc.Create(-400, fGUI, fRenderer));
  NewNotifier(-400).Notify;

  fFluxFuncReg.RegisterFunc(uappfunc.TProcessMessagesFunc.Create(-401, NewNotifier(-401)));
  NewNotifier(-401).Notify;

end;

end.


