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
  RegReact.RegisterComposite(TReactComponentApp, IReactComponentApp, [Layout.Perspective.Path]);
  RegReact.RegisterComposite(TReactComponentForm, IReactComponentForm, []);
  mReg := RegReact.RegisterComposite(TReactComponentMainForm, IReactComponentMainForm, [MainForm.Width.Path, MainForm.Height.Path]);
  //mReg.InjectProp('ActionResize', cActions.ResizeFunc);
  RegReact.RegisterComposite(TReactComponentEdit, IReactComponentEdit, []);
  RegReact.RegisterComposite(TReactComponentEdits, IReactComponentEdits, []);
  RegReact.RegisterComposite(TReactComponentButton, IReactComponentButton, []);
  RegReact.RegisterComposite(TReactComponentButtons, IReactComponentButtons, []);
  RegReact.RegisterComposite(TReactComponentHeader, IReactComponentHeader, []);
end;

end.


