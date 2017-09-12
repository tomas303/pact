unit uappstate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, rea_iredux, trl_iprops, iapp, trl_idifactory;

type

  { TAppState }

  TAppState = class(TInterfacedObject, IAppState, IPropFinder)
  protected
    // IPropFinder
    function Find(const APath: string): IProp;
  protected
    fFactory: IDIFactory;
    fData: IProps;
    procedure SetData(AValue: IProps);
    procedure Build;
  published
    property Factory: IDIFactory read fFactory write fFactory;
    property Data: IProps read fData write SetData;
  end;

implementation

{ TAppState }

procedure TAppState.SetData(AValue: IProps);
begin
  if fData = AValue then
    Exit;
  fData := AValue;
  Build;
end;

procedure TAppState.Build;
begin
  Data.SetIntf(cAppState.MainForm, IUnknown(Factory.Locate(IProps)));
end;

function TAppState.Find(const APath: string): IProp;
begin
  Result := Data.PropByName[APath];
end;

end.

