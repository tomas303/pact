unit uapp;

{$mode objfpc}{$H+}

interface

uses
  iapp, uappfunc, uappstate, uappboot,
  tal_uapp, rea_ireact, rea_ureact, flu_iflux,
  trl_imetaelement,
  trl_dicontainer, trl_idifactory, trl_imetaelementfactory,
  rea_idesigncomponent, rea_udesigncomponent;

type

  { TApp }

  TApp = class(TALApp)
  protected
    procedure RegisterAppServices; override;
  end;

implementation

{ TApp }

procedure TApp.RegisterAppServices;
var
  mReg: TDIReg;
begin
  inherited;
  RegApps.RegisterWindowLog;
  // react
  RegReact.RegisterCommon;
  RegFlux.RegisterCommon(IFluxStore);

  {
  RegRedux.RegisterState(TLayout, Layout.Name); // prida i do hlavniho
  RegRedux.RegisterFunc(TRdxResizeFunc, Layout.Name); // prida i do state dispatcheru, nasetuje state
  from state  -- funkci, ktera nasetuje podcestu ze statu, prazdna zn. state

  Error when injecting property "TReactLauncher.ReactApp":
Error when injecting property "TReactApp.AppStore":
Error when injecting property "TRdxStore.Dispatcher":
Error when injecting property "TRdxFuncDispatcher.AddFunc":
Error when injecting property "TRdxResizeFunc.State":
Registration for interface: {00000000-0000-0000-0000-000000000000} ID: not found.

Press OK to ignore and risk data corruption.
Press Abort to kill the program.

   }
  // states
  RegRedux.RegisterState(TLayout, Layout.Name);
  RegRedux.RegisterState(TMainForm, MainForm.Name);

  RegRedux.RegisterFunc(TRdxResizeFunc, MainForm.Name);

  RegRedux.RegisterCommon(
    [Layout.Name, MainForm.Name],
    [TRdxResizeFunc.ClassName]
  );
  RegApps.RegisterReactApp;


  // react components
  {
  RegReact.RegisterReactComponent(TReactComponentApp, IReactComponentApp,
    [Layout.Perspective.Path]);
  RegReact.RegisterReactComponent(TReactComponentMainForm, IReactComponentMainForm,
    [MainForm.Width.Path, MainForm.Height.Path]);
  RegReact.RegisterReactComponent(TReactComponentForm, IReactComponentForm, []);
  RegReact.RegisterReactComponent(TReactComponentEdit, IReactComponentEdit, []);
  RegReact.RegisterReactComponent(TReactComponentButton, IReactComponentButton, []);
  RegReact.RegisterReactComponent(TReactComponentHeader, IReactComponentHeader, [Layout.Perspective.Path]);

  mReg := DIC.Add(TBootElementProvider, IMetaElementProvider, 'boot');
  mReg.InjectProp('Factory', IDIFactory);
  mReg.InjectProp('ElementFactory', IMetaElementFactory);
  }
  RegReact.RegisterDesignComponent(TDesignComponentApp, IDesignComponentApp);
  RegReact.RegisterDesignComponent(TDesignComponentForm, IDesignComponentForm);
  RegReact.RegisterDesignComponent(TDesignComponentEdit, IDesignComponentEdit);
  RegReact.RegisterDesignComponent(TDesignComponentButton, IDesignComponentButton);
  RegReact.RegisterDesignComponent(TDesignComponentHeader, IDesignComponentHeader);

end;

end.


