unit uapp;

{$mode objfpc}{$H+}

interface

uses
  iapp, uappfunc, uappboot, uappdata, uappgui,
  tal_uapp, flu_iflux,
  rea_idesigncomponent, rea_udesigncomponent,
  trl_ilog, trl_idifactory, trl_iExecutor, trl_dicontainer, trl_ilauncher,
  trl_iprops, trl_imetaelement, rea_irenderer,
  Forms;

type

  { TApp }

  TApp = class(TALApp)
  private type

    { TSizeFunc }

    TSizeFunc = class(TInterfacedObject, IFluxFunc)
    private
      fID: integer;
      fData: TFormData;
      fNotifier: IFluxNotifier;
    protected
      procedure Execute(const AAction: IFluxAction);
      function GetID: integer;
    public
      constructor Create(AID: integer; AData: TFormData; ANotifier: IFluxNotifier);
    end;

    { TMoveFunc }

    TMoveFunc = class(TInterfacedObject, IFluxFunc)
    private
      fID: integer;
      fData: TFormData;
    protected
      procedure Execute(const AAction: IFluxAction);
      function GetID: integer;
    public
      constructor Create(AID: integer; AData: TFormData);
    end;

    { TRenderGUIFunc }

    TRenderGUIFunc = class(TInterfacedObject, IFluxFunc)
    private
      fID: integer;
      fGUI: IDesignComponentApp;
      fRenderer: IRenderer;
    protected
      procedure Execute(const AAction: IFluxAction);
      function GetID: integer;
    public
      constructor Create(AID: integer; AGUI: IDesignComponentApp; ARenderer: IRenderer);
    end;

    { TProcessMessagesFunc }

    TProcessMessagesFunc = class(TInterfacedObject, IFluxFunc)
    private
      fID: integer;
      fProcessMessages: IFluxNotifier;
    protected
      procedure Execute(const AAction: IFluxAction);
      function GetID: integer;
    public
      constructor Create(AID: integer; AProcessMessages: IFluxNotifier);
    end;

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

{ TApp.TProcessMessagesFunc }

procedure TApp.TProcessMessagesFunc.Execute(const AAction: IFluxAction);
begin
  Application.ProcessMessages;
  fProcessMessages.Notify;
end;

function TApp.TProcessMessagesFunc.GetID: integer;
begin
  Result := fID;
end;

constructor TApp.TProcessMessagesFunc.Create(AID: integer; AProcessMessages: IFluxNotifier);
begin
  inherited Create;
  fID := AID;
  fProcessMessages := AProcessMessages;
end;

{ TApp.TRenderGUIFunc }

procedure TApp.TRenderGUIFunc.Execute(const AAction: IFluxAction);
var
  mEl: IMetaElement;
begin
  mEl := fGUI.Compose(nil, []);
  fRenderer.Render(mEl);
end;

function TApp.TRenderGUIFunc.GetID: integer;
begin
  Result := fID;
end;

constructor TApp.TRenderGUIFunc.Create(AID: integer; AGUI: IDesignComponentApp; ARenderer: IRenderer);
begin
  inherited Create;
  fID := AID;
  fGUI := AGUI;
  fRenderer := ARenderer;
end;

{ TApp.TMoveFunc }

procedure TApp.TMoveFunc.Execute(const AAction: IFluxAction);
begin
  fData.Left := AAction.Props.AsInt(cProps.MMLeft);
  fData.Top := AAction.Props.AsInt(cProps.MMTop);
end;

function TApp.TMoveFunc.GetID: integer;
begin
  Result := fID;
end;

constructor TApp.TMoveFunc.Create(AID: integer; AData: TFormData);
begin
  inherited Create;
  fID := AID;
  fData := AData;
end;

{ TApp.TSizeFunc }

procedure TApp.TSizeFunc.Execute(const AAction: IFluxAction);
var
  mChange: Boolean;
begin
  mChange := False;
  if fData.Width <> AAction.Props.AsInt(cProps.MMWidth) then begin
    fData.Width := AAction.Props.AsInt(cProps.MMWidth);
    mChange := True;
  end;
  if fData.Height <> AAction.Props.AsInt(cProps.MMHeight) then begin
    fData.Height := AAction.Props.AsInt(cProps.MMHeight);
    mChange := True;
  end;
  if mChange then
     fNotifier.Notify;
end;

function TApp.TSizeFunc.GetID: integer;
begin
  Result := fID;
end;

constructor TApp.TSizeFunc.Create(AID: integer; AData: TFormData; ANotifier: IFluxNotifier);
begin
  inherited Create;
  fID := AID;
  fData := AData;
  fNotifier := ANotifier;
end;

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

  fFluxFuncReg.RegisterFunc(TCloseQueryFunc.Create(-303));
  fFluxFuncReg.RegisterFunc(TSizeFunc.Create(-101, fMainFormData, NewNotifier(-400)));
  fFluxFuncReg.RegisterFunc(TMoveFunc.Create(-102, fMainFormData));
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

  fFluxFuncReg.RegisterFunc(TRenderGUIFunc.Create(-400, fGUI, fRenderer));
  NewNotifier(-400).Notify;

  fFluxFuncReg.RegisterFunc(TProcessMessagesFunc.Create(-401, NewNotifier(-401)));
  NewNotifier(-401).Notify;

end;

end.


