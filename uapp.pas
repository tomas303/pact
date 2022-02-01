unit uapp;

{$mode objfpc}{$H+}

interface

uses
  tal_uapp,
  uappgui,
  rea_idesigncomponent;

type

  { TApp }

  TApp = class(TALApp)
    procedure RegisterAppServices; override;
  end;

implementation

{ TApp }

procedure TApp.RegisterAppServices;
begin
  inherited;
  RegApps.RegisterWindowLog;
  RegReact.RegisterCommon;
  RegApps.RegisterReactLauncher;
  RegRuntime.RegisterSequence('ActionID');
  RegReact.RegisterDesignComponent(TGUI, IDesignComponentApp);
end;

end.


