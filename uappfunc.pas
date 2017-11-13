unit uappfunc;

{$mode objfpc}{$H+}

interface

uses
  iapp, flu_iflux, trl_iprops, uappstate;

type

  { TRdxTestLayoutFunc }

  TRdxTestLayoutFunc = class(TInterfacedObject, IFluxFunc)
  protected
    // IFluxFunc
    function Redux(const AState: IFluxState; const AAction: IFluxAction): IFluxState;
  end;

  { TRdxResizeFunc }

  TRdxResizeFunc = class(TInterfacedObject, IFluxFunc)
  protected
    // IFluxFunc
    function Redux(const AState: IFluxState; const AAction: IFluxAction): IFluxState;
  end;

implementation

{ TRdxResizeFunc }

function TRdxResizeFunc.Redux(const AState: IFluxState;
  const AAction: IFluxAction): IFluxState;
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

function TRdxTestLayoutFunc.Redux(const AState: IFluxState;
  const AAction: IFluxAction): IFluxState;
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

