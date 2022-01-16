unit uappgui;

{$mode objfpc}{$H+}
{$modeswitch typehelpers}
{$modeswitch multihelpers}

interface

uses
  uappdata, sysutils,
  rea_udesigncomponent, rea_idesigncomponent, trl_iprops, trl_imetaelement,
  flu_iflux, rea_ibits, rea_ilayout, trl_itree, trl_idifactory, rea_udesigncomponentfunc,
  rea_udesigncomponentdata, trl_isequence, Graphics;

type

  { TGUI }

  TGUI = class(TDesignComponent, IDesignComponentApp)
  private
    fMainFormData: TFormData;
    fPagerData: TPagerData;
  private
    fMainForm: IDesignComponent;
    fNamesGrid: IDesignComponentGrid;
    fPager: IDesignComponent;
  protected
    procedure InitValues; override;
    function DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement; override;
  end;

implementation

{ TGUI }

procedure TGUI.InitValues;
var
  mF: IDesignComponentFormFactory;
  mP: IDesignComponentPagerFactory;
  mPage: IDesignComponent;
begin
  inherited InitValues;
  fMainFormData := TFormData.Create;
  fMainFormData.Left := 0;
  fMainFormData.Top := 0;
  fMainFormData.Width := 800;
  fMainFormData.Height := 400;
  mF := IDesignComponentFormFactory(Factory.Locate(IDesignComponentFormFactory));
  fMainForm := mF.New(NewProps.SetObject('Data', fMainFormData));
  //
  fPagerData := TPagerData.Create;
  mP := IDesignComponentPagerFactory(Factory.Locate(IDesignComponentPagerFactory));
  fPager := mP.New(NewProps
    .SetObject('Data', fPagerData)
    .SetInt(cProps.SwitchEdge, cEdge.Right)
    .SetInt(cProps.SwitchSize, 40)
  );
  mPage := IDesignComponentHeader(Factory.Locate(IDesignComponentHeader, '', NewProps.SetStr(cProps.Caption, 'red').SetInt(cProps.Color, clRed).SetBool(cProps.Transparent, False)));
  (fPager as INode).AddChild(mPage as INode);
  mPage := IDesignComponentHeader(Factory.Locate(IDesignComponentHeader, '', NewProps.SetStr(cProps.Caption, 'blue').SetInt(cProps.Color, clblue).SetBool(cProps.Transparent, False)));
  (fPager as INode).AddChild(mPage as INode);
  mPage := IDesignComponentHeader(Factory.Locate(IDesignComponentHeader, '', NewProps.SetStr(cProps.Caption, 'green').SetInt(cProps.Color, clgreen).SetBool(cProps.Transparent, False)));
  (fPager as INode).AddChild(mPage as INode);
end;

function TGUI.DoCompose(const AProps: IProps;
  const AChildren: TMetaElementArray): IMetaElement;
var
  mGrid: IMetaElement;
  mPager: IMetaElement;
begin
  Result := fMainForm.Compose(AProps, AChildren);
  mPager := fPager.Compose(AProps, nil);
  (Result as INode).AddChild(mPager as INode);
  //mGrid := fNamesGrid.Compose(AProps, nil);
  //(Result as INode).AddChild(mGrid as INode);
  //mPager := fPager.Compose(AProps, nil);
  //(Result as INode).AddChild(mPager as INode);
end;

end.

