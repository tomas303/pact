unit rdx_ufunc;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, rdx_iredux, iapp, trl_iprops, trl_iinjector, trl_idifactory,
  flu_iflux;

type

  { TRdxFunc }

  TRdxFunc = class(TInterfacedObject, IRdxFunc)
  protected
    function DoResize(const AMainForm: IProps; const AAction: IFluxAction): IProps;
    function DefaultMainForm: IProps;
    function FindProps(const AState: IRdxState; const APath: string): IProps;
  protected
    // IRdxFunc
    function Redux(const AState: IRdxState; const AAction: IFluxAction): IRdxState;
  protected
    fInjector: IInjector;
    fFactory: IDIFactory;
  published
    property Injector: IInjector read fInjector write fInjector;
    property Factory: IDIFactory read fFactory write fFactory;
  end;

implementation

{ TRdxFunc }

function TRdxFunc.DoResize(const AMainForm: IProps;
  const AAction: IFluxAction): IProps;
begin
  if AAction = nil then begin
    Result := IProps(Factory.Locate(IProps));
    Result.SetInt('Left', 5);
    Result.SetInt('Top', 5);
    Result.SetInt('Width', 600);
    Result.SetInt('Height', 600);
  end
  else
  if not AMainForm.Equals(AAction.Props) then
    Result := AAction.Props.Clone
  else
    Result := AMainForm;
end;

function TRdxFunc.DefaultMainForm: IProps;
begin
  Result := IProps(Factory.Locate(IProps));
  Result
    .SetInt('Left', 500)
    .SetInt('Top', 30)
    .SetInt('Width', 500)
    .SetInt('Height', 300);
end;

function TRdxFunc.FindProps(const AState: IRdxState; const APath: string
  ): IProps;
var
  mProp: IProp;
begin
  mProp := (AState as IPropFinder).Find(APath);
  if mProp = nil then
    raise Exception.CreateFmt('No props for %s', [APath]);
  Result := mProp.AsInterface as IProps;
end;

function TRdxFunc.Redux(const AState: IRdxState; const AAction: IFluxAction
  ): IRdxState;
var
  mProp: IProp;
  mProps: IProps;
  mMainForm, mNewMainForm: IProps;
begin
  case AAction.ID of
    cActions.InitFunc:
      begin
        mProps := FindProps(AState, cAppState.MainForm);
        mProps.SetInt(cAppState.Height, 300);
        mProps.SetInt(cAppState.Width, 600);
        (AState as IPropFinder).Find(cAppState.Perspective).SetAsInteger(1);
        Result := AState;
      end;
    cActions.ResizeFunc:
      begin
        mProps := FindProps(AState, cAppState.MainForm);
        //mProps.SetInt(cAppState.Left, AAction.Props.AsInt(cAppState.Left));
        //mProps.SetInt(cAppState.Top, AAction.Props.AsInt(cAppState.Top));
        mProps.SetInt(cAppState.Width, AAction.Props.AsInt(cAppState.Width));
        mProps.SetInt(cAppState.Height, AAction.Props.AsInt(cAppState.Height));
        Result := AState;
      end;
    cActions.HelloFunc:
      begin
        Result := AState;
      end;
    cActions.ClickOne:
      begin
        (AState as IPropFinder).Find(cAppState.Perspective).SetAsInteger(1);
        Result := AState;
      end;
    cActions.ClickTwo:
      begin
        (AState as IPropFinder).Find(cAppState.Perspective).SetAsInteger(2);
        Result := AState;
      end;
    cActions.ClickThree:
      begin
        (AState as IPropFinder).Find(cAppState.Perspective).SetAsInteger(3);
        Result := AState;
      end;
  else
    Result := AState;
  end;
end;

end.

