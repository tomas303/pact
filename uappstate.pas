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
var
  mPath: TStringArray;
  i: integer;
  mFinder: IPropFinder;
begin
  Result := nil;
  mPath := APath.Split('.');
  mFinder := Data as IPropFinder;
  for i := 0 to High(mPath) do
  begin
    Result := mFinder.Find(mPath[i]);
    if Result = nil then
      raise Exception.CreateFmt('Property %s identified by key %s not found', [mPath[i], APath]);
    if i = High(mPath) then
      Break;
    if not Supports(Result.AsInterface, IPropFinder, mFinder) then
      raise Exception.CreateFmt('Property %s identified by key %s does not support find', [mPath[i], APath]);
    mFinder := Result.AsInterface as IPropFinder;
  end;
end;

end.

