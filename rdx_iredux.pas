unit rdx_iredux;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, trl_iprops, flu_iflux;

type

  { IAppLogic }

  IAppLogic = interface
  ['{DDA9D37C-8F7D-48F5-B70B-1E3C8E0F0C43}']
    procedure StartUp;
    procedure ShutDown;
  end;

  { IAppState }

  IAppState = interface
  ['{0930F255-E3FB-423E-B8BE-81109F56FDE4}']
  end;

  { IAppFunc }

  IAppFunc = interface
  ['{D5CD4D66-CC4B-4A5E-A206-3D2838BB6CC6}']
    function Redux(const AAppState: IAppState; const AAppAction: IFluxAction): IAppState;
  end;

  TAppStoreEvent = procedure(const AAppState: IAppState) of object;

  { IAppStore }

  IAppStore = interface
  ['{3E5DDFF7-63FD-4E14-A913-0A5909A55C7C}']
    procedure Add(const AEvent: TAppStoreEvent);
    procedure Remove(const AEvent: TAppStoreEvent);
  end;

  { IMapStateToProps }

  IMapStateToProps = interface
  ['{A311ED5F-8C3C-4751-86AB-E5FCEE278024}']
    function Map(const AProps: IProps): IProps;
    function AddPath(const APath: string; AKeys: TStringArray): IMapStateToProps;
  end;

implementation

end.

