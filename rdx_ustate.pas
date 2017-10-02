unit rdx_ustate;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, rdx_iredux, trl_iprops, iapp, trl_idifactory;

type

  { TRdxState }

  TRdxState = class(TInterfacedObject, IRdxState, IPropFinder)
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

{ TRdxState }

procedure TRdxState.SetData(AValue: IProps);
begin
  if fData = AValue then
    Exit;
  fData := AValue;
  Build;
end;

procedure TRdxState.Build;
begin
  Data.SetIntf(cAppState.MainForm, IUnknown(Factory.Locate(IProps)));
  Data.SetInt(cAppState.Perspective, 0);
end;

function TRdxState.Find(const APath: string): IProp;
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

