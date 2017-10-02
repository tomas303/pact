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
    function DoResize(const AMainForm: IProps; const AAppAction: IFluxAction): IProps;
    function DefaultMainForm: IProps;
    function FindProps(const AAppState: IRdxState; const APath: string): IProps;
  protected
    // IRdxFunc
    function Redux(const AAppState: IRdxState; const AAppAction: IFluxAction): IRdxState;
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
  const AAppAction: IFluxAction): IProps;
begin
  if AAppAction = nil then begin
    Result := IProps(Factory.Locate(IProps));
    Result.SetInt('Left', 5);
    Result.SetInt('Top', 5);
    Result.SetInt('Width', 600);
    Result.SetInt('Height', 600);
  end
  else
  if not AMainForm.Equals(AAppAction.Props) then
    Result := AAppAction.Props.Clone
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

function TRdxFunc.FindProps(const AAppState: IRdxState; const APath: string
  ): IProps;
var
  mProp: IProp;
begin
  mProp := (AAppState as IPropFinder).Find(APath);
  if mProp = nil then
    raise Exception.CreateFmt('No props for %s', [APath]);
  Result := mProp.AsInterface as IProps;
end;

function TRdxFunc.Redux(const AAppState: IRdxState; const AAppAction: IFluxAction
  ): IRdxState;
var
  mProp: IProp;
  mProps: IProps;
  mMainForm, mNewMainForm: IProps;
begin
  case AAppAction.ID of
    cActions.InitFunc:
      begin
        mProps := FindProps(AAppState, cAppState.MainForm);
        mProps.SetInt(cAppState.Height, 300);
        mProps.SetInt(cAppState.Width, 600);
        (AAppState as IPropFinder).Find(cAppState.Perspective).SetAsInteger(1);
        Result := AAppState;
      end;
    cActions.ResizeFunc:
      begin
        mProps := FindProps(AAppState, cAppState.MainForm);
        //mProps.SetInt(cAppState.Left, AAppAction.Props.AsInt(cAppState.Left));
        //mProps.SetInt(cAppState.Top, AAppAction.Props.AsInt(cAppState.Top));
        mProps.SetInt(cAppState.Width, AAppAction.Props.AsInt(cAppState.Width));
        mProps.SetInt(cAppState.Height, AAppAction.Props.AsInt(cAppState.Height));
        Result := AAppState;
      end;
    cActions.HelloFunc:
      begin
        Result := AAppState;
      end;
    cActions.ClickOne:
      begin
        (AAppState as IPropFinder).Find(cAppState.Perspective).SetAsInteger(1);
        Result := AAppState;
      end;
    cActions.ClickTwo:
      begin
        (AAppState as IPropFinder).Find(cAppState.Perspective).SetAsInteger(2);
        Result := AAppState;
      end;
    cActions.ClickThree:
      begin
        (AAppState as IPropFinder).Find(cAppState.Perspective).SetAsInteger(3);
        Result := AAppState;
      end;
  else
    Result := AAppState;
  end;
end;

end.

