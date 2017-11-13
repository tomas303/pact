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
    procedure RegisterReact;
    procedure RegisterAppServices; override;
  end;

implementation

{ TApp }

procedure TApp.RegisterReact;
var
  mReg: TDIReg;
begin
  RegReact.RegisterComposite(TAppComposite, IAppComposite, [Layout.Perspective.Path]);
  RegReact.RegisterComposite(TFormComposite, IFormComposite, []);
  mReg := RegReact.RegisterComposite(TMainFormComposite, IMainFormComposite, [MainForm.Width.Path, MainForm.Height.Path]);
  mReg.InjectProp('ActionResize', cActions.ResizeFunc);
  RegReact.RegisterComposite(TEditComposite, IEditComposite, []);
  RegReact.RegisterComposite(TEditsComposite, IEditsComposite, []);
  RegReact.RegisterComposite(TButtonComposite, IButtonComposite, []);
  RegReact.RegisterComposite(TButtonsComposite, IButtonsComposite, []);
  RegReact.RegisterComposite(THeaderComposite, IHeaderComposite, []);
end;

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
  RegReact.RegisterComposite(TAppComposite, IAppComposite, [Layout.Perspective.Path]);
  RegReact.RegisterComposite(TFormComposite, IFormComposite, []);
  mReg := RegReact.RegisterComposite(TMainFormComposite, IMainFormComposite, [MainForm.Width.Path, MainForm.Height.Path]);
  mReg.InjectProp('ActionResize', cActions.ResizeFunc);
  RegReact.RegisterComposite(TEditComposite, IEditComposite, []);
  RegReact.RegisterComposite(TEditsComposite, IEditsComposite, []);
  RegReact.RegisterComposite(TButtonComposite, IButtonComposite, []);
  RegReact.RegisterComposite(TButtonsComposite, IButtonsComposite, []);
  RegReact.RegisterComposite(THeaderComposite, IHeaderComposite, []);
end;

end.


