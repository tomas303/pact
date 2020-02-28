unit uappfunc;

{$mode objfpc}{$H+}

interface

uses
  iapp, flu_iflux, trl_iprops, uappstate, trl_igenericaccess, rdx_ufunc;

type

  { TRdxTestLayoutFunc }

  TRdxTestLayoutFunc = class(TRdxFunc)
  protected
    procedure DoExecute(const AAction: IFluxAction); override;
  end;

  { TRdxResizeFunc }

  TRdxResizeFunc = class(TRdxFunc)
  protected
    procedure DoExecute(const AAction: IFluxAction); override;
  end;

{
  function TRdxFunc.DefaultMainForm: IProps;
  begin
    Result := IProps(Factory.Locate(IProps));
    Result
      .SetInt('Left', 500)
      .SetInt('Top', 30)
      .SetInt('Width', 500)
      .SetInt('Height', 300);
  end;
}

implementation

{ TRdxResizeFunc }

procedure TRdxResizeFunc.DoExecute(const AAction: IFluxAction);
var
  mw,mh: integer;
begin
  case AAction.ID of
    cActions.InitFunc:
      begin
        State.SetInt(MainForm.Width.Name, 400);
        State.SetInt(MainForm.Height.Name, 200);
      end;
    cActions.ResizeFunc:
      begin
        //State.SetInt(MainForm.Width.Name, AAction.Props.AsInt(MainForm.Width.Name));
        //State.SetInt(MainForm.Width.Name, AAction.Props.AsInt(MainForm.Width.Name));

        // 'MMWidth' na state neexistue
        mw:=AAction.Props.AsInt('MMWidth');
        mh:=AAction.Props.AsInt('MMHeight');
        State.SetInt(MainForm.Width.Name, AAction.Props.AsInt('MMWidth'));
        State.SetInt(MainForm.Height.Name, AAction.Props.AsInt('MMHeight'));
      end;
  end;
end;


{ TRdxTestLayoutFunc }

procedure TRdxTestLayoutFunc.DoExecute(const AAction: IFluxAction);
begin
  case AAction.ID of
    cActions.InitFunc:
      begin
        State.SetInt(Layout.Perspective.Name, 0);
      end;
    cActions.ClickOne:
      begin
        State.SetInt(Layout.Perspective.Name, 1);
      end;
    cActions.ClickTwo:
      begin
        State.SetInt(Layout.Perspective.Name, 2);
      end;
    cActions.ClickThree:
      begin
        State.SetInt(Layout.Perspective.Name, 3);
      end;
  end;

end;

end.

