unit uappfunc;

{$mode objfpc}{$H+}

interface

uses
  iapp, flu_iflux, trl_iprops, uappstate, trl_igenericaccess;

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
  mState: IGenericAccess;
begin
  mState := (AState as IPropFinder).Find(MainForm.Path).AsInterface as IGenericAccess;
  case AAction.ID of
    cActions.InitFunc:
      begin
        mState.SetInt(MainForm.Width.Name, 400);
        mState.SetInt(MainForm.Height.Name, 200);
      end;
    cActions.ResizeFunc:
      begin
        mState.SetInt(MainForm.Width.Name, AAction.Props.AsInt(MainForm.Width.Name));
        mState.SetInt(MainForm.Width.Name, AAction.Props.AsInt(MainForm.Width.Name));
      end;
  end;
end;

{ TRdxTestLayoutFunc }

function TRdxTestLayoutFunc.Redux(const AState: IFluxState;
  const AAction: IFluxAction): IFluxState;
var
  mState: IGenericAccess;
begin
  mState := (AState as IPropFinder).Find(Layout.Path).AsInterface as IGenericAccess;
  case AAction.ID of
    cActions.InitFunc:
      begin
        mState.SetInt(Layout.Perspective.Name, 0);
      end;
    cActions.ClickOne:
      begin
        mState.SetInt(Layout.Perspective.Name, 1);
      end;
    cActions.ClickTwo:
      begin
        mState.SetInt(Layout.Perspective.Name, 2);
      end;
    cActions.ClickThree:
      begin
        mState.SetInt(Layout.Perspective.Name, 3);
      end;
  end;

end;

end.

