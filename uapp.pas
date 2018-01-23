unit uapp;

{$mode objfpc}{$H+}

interface

uses
  iapp, uappfunc, uappboot, tal_uapp, trl_dicontainer,
  rea_ireact, rea_ureact, flu_iflux;

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
  RegRedux.RegisterCommon([TRdxResizeFunc, TRdxTestLayoutFunc]);
  RegApps.RegisterReactApp;
  // react components
  RegReact.RegisterReactComponent(TReactComponentApp, IReactComponentApp, [Layout.Perspective.Path]);
  RegReact.RegisterReactComponent(TReactComponentForm, IReactComponentForm, []);
  mReg := RegReact.RegisterReactComponent(TReactComponentMainForm, IReactComponentMainForm, [MainForm.Width.Path, MainForm.Height.Path]);
  //mReg.InjectProp('ActionResize', cActions.ResizeFunc);
  RegReact.RegisterReactComponent(TReactComponentEdit, IReactComponentEdit, []);
  RegReact.RegisterReactComponent(TReactComponentEdits, IReactComponentEdits, []);
  RegReact.RegisterReactComponent(TReactComponentButton, IReactComponentButton, []);
  RegReact.RegisterReactComponent(TReactComponentButtons, IReactComponentButtons, []);
  RegReact.RegisterReactComponent(TReactComponentHeader, IReactComponentHeader, []);
end;

end.


