unit uappfunc;

{$mode objfpc}{$H+}

interface

uses
  iapp, rdx_iredux, flu_iflux, trl_iprops, uappstate;

type

  { TRdxTestLayoutFunc }

  TRdxTestLayoutFunc = class(TInterfacedObject, IRdxFunc)
  protected
    // IRdxFunc
    function Redux(const AState: IRdxState; const AAction: IFluxAction): IRdxState;
  end;

  { TRdxResizeFunc }

  TRdxResizeFunc = class(TInterfacedObject, IRdxFunc)
  protected
    // IRdxFunc
    function Redux(const AState: IRdxState; const AAction: IFluxAction): IRdxState;
  end;

implementation

{ TRdxResizeFunc }

function TRdxResizeFunc.Redux(const AState: IRdxState;
  const AAction: IFluxAction): IRdxState;
var
  mProps: IProps;
begin
  mProps := AState.Props(MainForm.Path);
  case AAction.ID of
    cActions.InitFunc:
      begin
        mProps.SetInt(MainForm.Width.Name, 400);
        mProps.SetInt(MainForm.Height.Name, 200);
      end;
    cActions.ResizeFunc:
      begin
        mProps.SetInt(MainForm.Width.Name, AAction.Props.AsInt(MainForm.Width.Name));
        mProps.SetInt(MainForm.Width.Name, AAction.Props.AsInt(MainForm.Width.Name));
      end;
  end;
end;

{ TRdxTestLayoutFunc }

function TRdxTestLayoutFunc.Redux(const AState: IRdxState;
  const AAction: IFluxAction): IRdxState;
var
  mProps: IProps;
begin
  mProps := AState.Props(Layout.Name);
  case AAction.ID of
    cActions.InitFunc:
      begin
        mProps.SetInt(Layout.Perspective.Name, 0);
      end;
    cActions.ClickOne:
      begin
        mProps.SetInt(Layout.Perspective.Name, 1);
      end;
    cActions.ClickTwo:
      begin
        mProps.SetInt(Layout.Perspective.Name, 2);
      end;
    cActions.ClickThree:
      begin
        mProps.SetInt(Layout.Perspective.Name, 3);
      end;
  end;
end;

end.

