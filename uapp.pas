unit uapp;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils,
  StdCtrls,

  iapp, uappfunc, uappstate, uapplogic,

  forms, fmain, test,
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
  trl_irestatement, trl_urestatement,
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
    procedure RegisterTools;
    procedure RegisterGUI;
    procedure RegisterAppServices; override;
  end;

implementation

{ TApp }

function TApp.CreateMainFormInstance: TObject;
begin
  Application.CreateForm(TForm1, Result);
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
begin

  mReg := DIC.Add(TDIOwner, '', ckSingle);
  //
//  mReg := DIC.Add(TGUILauncher, ILauncher);
//  mReg.InjectProp('MainForm', IMainForm);
  mReg := DIC.Add(TReactLauncher, ILauncher);
  mReg.InjectProp('AppLogic', IAppLogic);
  //

  mReg := DIC.Add(TProps, IProps);

  // tree structure support
  mReg := DIC.Add(TParentNode, INode, 'parent');
  mReg := DIC.Add(TLeafNode, INode, 'leaf');

  // low level factory(can locate all dic classes)
  mReg := DIC.Add(TDIFactory, IDIFactory);
  mReg.InjectProp('Container', TDIContainer, '', DIC);

  // injector of properties
  mReg := DIC.Add(TInjector, IInjector);


  // for recount size to pixel(for now nothing)
  mReg := DIC.Add(TRestatement, IRestatement, 'horizontal');
  mReg.InjectProp('Multi', 1);
  mReg.InjectProp('Divid', 1);
  mReg := DIC.Add(TRestatement, IRestatement, 'vertical');
  mReg.InjectProp('Multi', 1);
  mReg.InjectProp('Divid', 1);

  mReg := DIC.Add(TUIDesktopLayout, IUITiler, 'desktop');
  mReg.InjectProp('HR', IRestatement, 'horizontal');
  mReg.InjectProp('VR', IRestatement, 'vertical');


  // real control
  mReg := DIC.Add(TForm, nil, 'uiform');
  // ui bit for handle real control
  mReg := DIC.Add(TUIFormBit, IUIFormBit);
  mReg.InjectProp('Log', ILog);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('Control', TForm, 'uiform');
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

  //redux pact part
  mReg := DIC.Add(TAppState, IAppState);
  mReg.InjectProp('MainForm', IProps);
  //
  mReg := DIC.Add(TAppFunc, IAppFunc);
  mReg.InjectProp('Injector', IInjector);
  mReg.InjectProp('Factory', IDIFactory);
  //
  mReg := DIC.Add(TAppLogic, IAppLogic, '', ckSingle);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('React', IReact);
  mReg.InjectProp('AppStore', IAppStore);




  // react part
  mReg := DIC.Add(TMetaElement, IMetaElement);
  mReg.InjectProp('Node', INode, 'parent');
  //
  mReg := DIC.Add(TMetaElementFactory, IMetaElementFactory);
  mReg.InjectProp('Container', TDIContainer, '', DIC);
  mReg.InjectProp('Log', ILog);


  //
  mReg := DIC.Add(TReconciliator, IReconciliator);
  mReg.InjectProp('Log', ILog);
  mReg.InjectProp('ElementFactory', IMetaElementFactory);
  mReg.InjectProp('Injector', IInjector);

  //
  mReg := DIC.Add(TReact, IReact);
  mReg.InjectProp('Log', ILog);
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('ElementFactory', IMetaElementFactory);
  mReg.InjectProp('Injector', IInjector);
  mReg.InjectProp('Injector', IInjector);
  mReg.InjectProp('Reconciliator', IReconciliator);
  //
  mReg := DIC.Add(CreateMainFormInstance, IMainForm);
  mReg.InjectProp('React', IReact);
end;

procedure TApp.RegisterAppServices;
begin
  inherited;
  RegisterTools;
  RegisterGUI;
end;

end.


