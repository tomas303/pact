unit uapp;

{$mode objfpc}{$H+}

interface

uses
  iapp, uappfunc, uappstate, uappboot,
  tal_uapp, rea_ireact, rea_ureact, flu_iflux;

type

  { TApp }

  TApp = class(TALApp)
  protected
    procedure RegisterAppServices; override;
  end;

implementation

{ TApp }

procedure TApp.RegisterAppServices;
begin
  inherited;
  RegApps.RegisterWindowLog;
  // react
  RegReact.RegisterCommon;
  RegFlux.RegisterCommon(IFluxStore);
  // states
  RegRedux.RegisterState(TLayout, Layout.Name);
  RegRedux.RegisterState(TMainForm, MainForm.Name);
  RegRedux.RegisterCommon(
    [Layout.Name, MainForm.Name],
    [TRdxResizeFunc, TRdxTestLayoutFunc]
  );
  RegApps.RegisterReactApp;
  // react components
  RegReact.RegisterReactComponent(TReactComponentApp, IReactComponentApp,
    [Layout.Perspective.Path]);
  RegReact.RegisterReactComponent(TReactComponentMainForm, IReactComponentMainForm,
    [MainForm.Width.Path, MainForm.Height.Path]);
  RegReact.RegisterReactComponent(TReactComponentForm, IReactComponentForm, []);
  RegReact.RegisterReactComponent(TReactComponentEdit, IReactComponentEdit, []);
  RegReact.RegisterReactComponent(TReactComponentButton, IReactComponentButton, []);
  RegReact.RegisterReactComponent(TReactComponentHeader, IReactComponentHeader, []);
end;

end.


