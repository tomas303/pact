unit uappfunc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, rea_iredux, iapp, trl_iprops, trl_iinjector, trl_idifactory;

type

  { TAppFunc }

  TAppFunc = class(TInterfacedObject, IAppFunc)
  protected
    function DoResize(const AMainForm: IProps; const AAppAction: IAppAction): IProps;
    function DefaultMainForm: IProps;
  protected
    // IAppFunc
    function Redux(const AAppState: IAppState; const AAppAction: IAppAction): IAppState;
  protected
    fInjector: IInjector;
    fFactory: IDIFactory;
  published
    property Injector: IInjector read fInjector write fInjector;
    property Factory: IDIFactory read fFactory write fFactory;
  end;

implementation

{ TAppFunc }

function TAppFunc.DoResize(const AMainForm: IProps;
  const AAppAction: IAppAction): IProps;
begin
  if AAppAction = nil then begin
    Result := IProps(Factory.Locate(IProps));
    Result.SetInt('Left', 5);
    Result.SetInt('Top', 5);
    Result.SetInt('Width', 500);
    Result.SetInt('Height', 200);
  end
  else
  if not AMainForm.Equals(AAppAction.Props) then
    Result := AAppAction.Props.Clone
  else
    Result := AMainForm;
end;

function TAppFunc.DefaultMainForm: IProps;
begin
  Result := IProps(Factory.Locate(IProps));
  Result
    .SetInt('Left', 500)
    .SetInt('Top', 30)
    .SetInt('Width', 500)
    .SetInt('Height', 300);
end;

function TAppFunc.Redux(const AAppState: IAppState; const AAppAction: IAppAction
  ): IAppState;
var
  mProps: IProps;
  mMainForm, mNewMainForm: IProps;
begin
  case AAppAction.ID of
    cInitFunc:
      begin
        Result := AAppState;
        (Result as IPactState).MainForm := DefaultMainForm;
      end;
    cResizeFunc:
      begin
        //mProps := IProps(Factory.Locate(IProps));
        //Injector.Read(AAppState as TObject, cMainFormStatePath, mProps);
        //if mProps.Count > 0 then
        //  mMainForm := mProps[0].AsInterface as IProps
        //else
        //  mMainForm := IProps(Factory.Locate(IProps));
        //mNewMainForm := DoResize(mMainForm, AAppAction);
        //if mNewMainForm <> mMainForm then begin
        //  mProps.SetIntf(cMainFormStatePath, mNewMainForm as IUnknown);
        //  Injector.Write(AAppState as TObject, mProps);
        //end;
        mNewMainForm := DoResize((AAppState as IPactState).MainForm, AAppAction);
        if mNewMainForm <> mMainForm then begin
          // probably better clone it
          Result := AAppState;
          (Result as IPactState).MainForm := mNewMainForm;
        end;
      end
  else
    Result := AAppState;
  end;
end;

end.

