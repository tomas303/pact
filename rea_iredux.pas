unit rea_iredux;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, trl_iprops;

type

  { IAppAction }

  IAppAction = interface
  ['{8BFE6073-9272-4051-A3DA-CCFBCC6526CE}']
    function GetID: integer;
    function GetProps: IProps;
    property ID: integer read GetID;
    property Props: IProps read GetProps;
  end;

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
    function Redux(const AAppState: IAppState; const AAppAction: IAppAction): IAppState;
  end;

  { IAppDispatcher }

  IAppDispatcher = interface
  ['{935D8630-D358-49BA-977B-E4BF88C804ED}']
    procedure Dispatch(const AAppAction: IAppAction);
  end;

  TAppStoreEvent = procedure(const AAppState: IAppState) of object;

  { IAppStore }

  IAppStore = interface
  ['{3E5DDFF7-63FD-4E14-A913-0A5909A55C7C}']
    procedure Add(const AEvent: TAppStoreEvent);
    procedure Remove(const AEvent: TAppStoreEvent);
  end;

  TAppNotifierEvent = procedure(const AProps: IProps) of object;

  { IAppNotifier }

  IAppNotifier = interface
  ['{38D6D48A-5E28-43F1-8450-4E05DB2BD750}']
    procedure Notify;
    procedure Add(const AEvent: TAppNotifierEvent);
    procedure Remove(const AEvent: TAppNotifierEvent);
    function GetEnabled: Boolean;
    procedure SetEnabled(AValue: Boolean);
    property Enabled: Boolean read GetEnabled write SetEnabled;
  end;

  { IMapStateToProps }

  IMapStateToProps = interface
  ['{A311ED5F-8C3C-4751-86AB-E5FCEE278024}']
    function Map(const AProps: IProps): IProps;
    function AddPath(const APath: string; AKeys: TStringArray): IMapStateToProps;
  end;

implementation

end.

