unit uapp;

{$mode objfpc}{$H+}

interface

uses
  tal_uapp,
  uappgui,
  uappdata,
  trl_dicontainer,
  trl_udifactory,
  rea_idesigncomponent,
  rea_idataconnector,
  trl_isequence;

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

  mReg := RegReact.RegisterDesignComponent(TGUI, IDesignComponentApp);
  mReg.InjectProp('DataConnector', IDataConnector);
  mReg.InjectProp('Sequence', ISequence);

  mReg := DIC.Add(TDummyGridDataProvider, IGridDataProvider);
  mReg.InjectProp('Factory2', TDIFactory2);
end;

end.


