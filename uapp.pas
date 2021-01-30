unit uapp;

{$mode objfpc}{$H+}

interface

uses
  iapp, uappfunc, uappboot,
  tal_uapp, flu_iflux,
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
begin
  inherited;
  RegApps.RegisterWindowLog;
  RegReact.RegisterCommon;
  RegFlux.RegisterCommon(IFluxStore);
  RegRedux.RegisterCommon(
    //[TRdxResizeFunc.ClassName]
  );
  RegApps.RegisterReactApp;
  RegReact.RegisterDesignComponent(TDesignComponentApp, IDesignComponentApp);
end;

end.


