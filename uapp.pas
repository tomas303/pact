unit uapp;

{$mode objfpc}{$H+}

interface

uses
  tal_uapp,
  uappgui,
  uappdata,
  trl_dicontainer,
  trl_udifactory,
  rea_idesigncomponent;

type

  { TApp }

  TApp = class(TALApp)
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
  RegReact.RegisterCommon;
  RegApps.RegisterReactLauncher;
  RegRuntime.RegisterSequence('ActionID');
  RegReact.RegisterDesignComponent(TGUI, IDesignComponentApp);

  mReg := DIC.Add(TDummyGridDataProvider, IGridDataProvider);
  mReg.InjectProp('Factory2', TDIFactory2);
end;

end.


