unit uapp;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils,
  StdCtrls,

  iapp, uappfunc, uappstate, uapplogic,

  forms,
  tal_uapp, tal_uguilauncher, tal_ilauncher,
  trl_ipersist,  trl_upersist, trl_upersiststore,
  trl_dicontainer,
  trl_irttibroker, trl_urttibroker,
  trl_upersistxml,

  trl_ilog, trl_ulazlog,
  tal_uwindowlog,

  tvl_udatabinder, tvl_udatabinders, tvl_utallybinders,
  tvl_ibindings, tal_iedit, tvl_ubehavebinder,
  iuibits, uuibits,
  trl_idifactory, trl_udifactory,
  rea_ireact, rea_ureact,
  trl_itree, trl_utree,
  rea_iuilayout, rea_uuilayout,
  trl_iprops, trl_uprops,
  trl_iinjector, trl_uinjector,
  rea_iredux, rea_uredux,
  rea_uapplauncher;

type

  { TApp }

  TApp = class(TALApp)
  protected
    function CreateMainFormInstance: TObject;
  protected
    procedure RegisterCore;
    procedure RegisterLauncher;
    procedure RegisterTools;
    procedure RegisterGUI;
    procedure RegisterRedux;
    procedure RegisterReact;
    procedure RegisterAppServices; override;
  end;

implementation

{ TApp }

function TApp.CreateMainFormInstance: TObject;
begin
  Application.CreateForm(TForm, Result);
end;

procedure TApp.RegisterCore;
var
  mReg: TDIReg;
begin
  mReg := DIC.Add(TDIOwner, '', ckSingle);
  //
  mReg := DIC.Add(TProps, IProps);
  // injector of properties
  mReg := DIC.Add(TInjector, IInjector);
  // tree structure support
  mReg := DIC.Add(TParentNode, INode, 'parent');
  mReg := DIC.Add(TLeafNode, INode, 'leaf');
  // low level factory(can locate all dic classes)
  mReg := DIC.Add(TDIFactory, IDIFactory);
  mReg.InjectProp('Container', TDIContainer, '', DIC);
  //
end;

procedure TApp.RegisterLauncher;
var
  mReg: TDIReg;
begin
  //
//  mReg := DIC.Add(TGUILauncher, ILauncher);
//  mReg.InjectProp('MainForm', IMainForm);
  mReg := DIC.Add(TReactLauncher, ILauncher);
  mReg.InjectProp('AppLogic', IAppLogic);
  //
end;

procedure TApp.RegisterTools;
var
  mReg: TDIReg;
begin
  mReg := DIC.Add(TWindowLog, ILog, '', ckSingle);
end;

procedure TApp.RegisterGUI;
var
  mReg: TDIReg;
  mDIO: TDIOwner;
begin

  // for recount size to pixel(for now nothing)
  mReg := DIC.Add(TUIScale, IUIScale, 'horizontal');
  mReg.InjectProp('Multiplicator', 1);
  mReg.InjectProp('Divider', 1);
  mReg := DIC.Add(TUIScale, IUIScale, 'vertical');
  mReg.InjectProp('Multiplicator', 1);
  mReg.InjectProp('Divider', 1);
  // layout
  mReg := DIC.Add(TUIDesktopLayout, IUITiler, 'desktop');
  mReg.InjectProp('HScale', IUIScale, 'horizontal');
  mReg.InjectProp('VScale', IUIScale, 'vertical');


  // real controls and their bits
  // ui bit for handle real control

  mReg := DIC.Add(TForm, TDIOwner(DIC.Locate(TDIOwner)), 'uiform');
  //mReg := DIC.Add(CreateMainFormInstance, 'uiform');

  mReg := DIC.Add(TUIFormBit, IUIFormBit);
  mReg.InjectProp('Log', ILog);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('Control', TForm, 'uiform');
  mReg.InjectProp('Node', INode, 'parent');
  mReg.InjectProp('Tiler', IUITiler, 'desktop');
  //
  mReg := DIC.Add(TUIStripBit, IUIStripBit);
  mReg.InjectProp('Log', ILog);
  mReg.InjectProp('Node', INode, 'parent');
  mReg.InjectProp('Tiler', IUITiler, 'desktop');
  //
  mReg := DIC.Add(TEdit, nil, 'uiedit');
  mReg := DIC.Add(TUIEditBit, IUIEditBit);
  mReg.InjectProp('Log', ILog);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('Control', TEdit, 'uiedit');
  mReg.InjectProp('Node', INode, 'leaf');
  //
  mReg := DIC.Add(TLabel, nil, 'uitext');
  mReg := DIC.Add(TUITextBit, IUITextBit);
  mReg.InjectProp('Log', ILog);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('Control', TLabel, 'uitext');
  mReg.InjectProp('Node', INode, 'leaf');
  //
  mReg := DIC.Add(TButton, nil, 'uibutton');
  mReg := DIC.Add(TUIButtonBit, IUIButtonBit);
  mReg.InjectProp('Log', ILog);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('Control', TButton, 'uibutton');
  mReg.InjectProp('Node', INode, 'leaf');
end;

procedure TApp.RegisterRedux;
var
  mReg: TDIReg;
begin
  //redux part
  mReg := DIC.Add(TAppStore, IAppStore, '', ckSingle);
  mReg.InjectProp('AppState', IAppState);
  mReg.InjectProp('AppFunc', IAppFunc);
  //
  mReg := DIC.Add(TAppAction, IAppAction);
  mReg.InjectProp('Props', IProps);
  //
  mReg := DIC.Add(TAppNotifier, IAppNotifier);
  // asi az pri reactu mozna    mReg.InjectProp('ActionID', cResizeFunc);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('Dispatcher', IAppStore);
  //
  mReg := DIC.Add(TMapStateToProps, IMapStateToProps);
  mReg.InjectProp('AppState', IAppState);
  //redux pact part
  mReg := DIC.Add(TAppState, IAppState, '', ckSingle);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('Data', IProps);
  //
  mReg := DIC.Add(TAppFunc, IAppFunc);
  mReg.InjectProp('Injector', IInjector);
  mReg.InjectProp('Factory', IDIFactory);
  //
  mReg := DIC.Add(TAppLogic, IAppLogic, '', ckSingle);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('React', IReact);
  mReg.InjectProp('AppStore', IAppStore);
  mReg.InjectProp('ElFactory', IMetaElementFactory);
end;

procedure TApp.RegisterReact;
var
  mReg: TDIReg;
begin
  // react part
  mReg := DIC.Add(TMetaElement, IMetaElement);
  mReg.InjectProp('Node', INode, 'parent');
  //
  mReg := DIC.Add(TMetaElementFactory, IMetaElementFactory);
  mReg.InjectProp('Container', TDIContainer, '', DIC);
  mReg.InjectProp('Log', ILog);
  //
  mReg := DIC.Add(TReactComponent, IReactComponent);
  mReg.InjectProp('Log', ILog);
  mReg.InjectProp('Node', INode, 'parent');
  //mReg.InjectProp('Composites', IComposites);
  mReg.InjectProp('Reconciliator', IReconciliator);
  mReg.InjectProp('ReactFactory', IReactFactory);
  //
  mReg := DIC.Add(TReactFactory, IReactFactory);
  mReg.InjectProp('Container', TDIContainer, '', DIC);
  mReg.InjectProp('Log', ILog);
  //
  mReg := DIC.Add(TReconciliator, IReconciliator);
  mReg.InjectProp('Log', ILog);
  //mReg.InjectProp('ElementFactory', IMetaElementFactory);
  mReg.InjectProp('ReactFactory', IReactFactory);
  mReg.InjectProp('Injector', IInjector);
  //
  mReg := DIC.Add(TComposite, IComposite);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('ElementFactory', IMetaElementFactory);
  mReg.InjectProp('Log', ILog);
  //
  mReg := DIC.Add(TMapStateToProps, IMapStateToProps, 'appcomposite');
  mReg.InjectProp('AppState', IAppState);
  mReg.InjectProp('AddKey', cAppState.Perspective);
  mReg := DIC.Add(TAppComposite, IAppComposite);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('ElementFactory', IMetaElementFactory);
  mReg.InjectProp('MapStateToProps', IMapStateToProps, 'appcomposite');
  mReg.InjectProp('Log', ILog);
  //
  mReg := DIC.Add(TFormComposite, IFormComposite);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('ElementFactory', IMetaElementFactory);
  mReg.InjectProp('Log', ILog);
  //
  mReg := DIC.Add(TMapStateToProps, IMapStateToProps, 'mainform');
  mReg.InjectProp('AppState', IAppState);
  mReg.InjectProp('AddKey', cAppState.MainFormWidth);
  mReg.InjectProp('AddKey', cAppState.MainFormHeight);
  mReg := DIC.Add(TFormComposite, IFormComposite, 'mainform');
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('ElementFactory', IMetaElementFactory);
  mReg.InjectProp('MapStateToProps', IMapStateToProps, 'mainform');
  mReg.InjectProp('Log', ILog);
  mReg.InjectProp('ActionResize', cActions.ResizeFunc);

  //
  mReg := DIC.Add(TEditComposite, IEditComposite);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('ElementFactory', IMetaElementFactory);
  mReg.InjectProp('Log', ILog);
  //
  mReg := DIC.Add(TEditsComposite, IEditsComposite);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('ElementFactory', IMetaElementFactory);
  mReg.InjectProp('Log', ILog);
  //
  mReg := DIC.Add(TButtonComposite, IButtonComposite);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('ElementFactory', IMetaElementFactory);
  mReg.InjectProp('Log', ILog);
  //
  mReg := DIC.Add(TButtonsComposite, IButtonsComposite);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('ElementFactory', IMetaElementFactory);
  mReg.InjectProp('Log', ILog);
  //
  mReg := DIC.Add(THeaderComposite, IHeaderComposite);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('ElementFactory', IMetaElementFactory);
  mReg.InjectProp('Log', ILog);
  //
  mReg := DIC.Add(TReact, IReact);
  mReg.InjectProp('Log', ILog);
  mReg.InjectProp('ReactFactory', IReactFactory);
  mReg.InjectProp('Injector', IInjector);
  mReg.InjectProp('Injector', IInjector);
  mReg.InjectProp('Reconciliator', IReconciliator);
  mReg.InjectProp('RootComponent', IReactComponent);
  //
  mReg := DIC.Add(CreateMainFormInstance, IMainForm);
  mReg.InjectProp('React', IReact);
end;

procedure TApp.RegisterAppServices;
begin
  inherited;
  RegisterCore;
  RegisterTools;
  RegisterGUI;
  RegisterLauncher;
  RegisterRedux;
  RegisterReact;
end;

end.


