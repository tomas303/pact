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
    fNamesGridData: TGridData;
  private
    fMainForm: IDesignComponent;
    fNamesGrid: IDesignComponent;
    fPager: IDesignComponent;
  protected
    procedure InitValues; override;
    function DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement; override;
  end;

implementation

{ TGUI }

procedure TGUI.InitValues;
var
  mFF: IDesignComponentFormFactory;
  mPF: IDesignComponentPagerFactory;
  mPage: IDesignComponent;
  mGF: IDesignComponentGridFactory;
begin
  inherited InitValues;
  fMainFormData := TFormData.Create;
  fMainFormData.Left := 0;
  fMainFormData.Top := 0;
  fMainFormData.Width := 800;
  fMainFormData.Height := 400;
  mFF := IDesignComponentFormFactory(Factory.Locate(IDesignComponentFormFactory));
  fMainForm := mFF.New(NewProps.SetObject('Data', fMainFormData));
  //
  fNamesGridData := TGridData.Create(TDummyGridDataProvider.Create);
  fNamesGridData.RowCount := 10;
  fNamesGridData.ColCount := 2;
  fNamesGridData.ReadData;
  mGF := IDesignComponentGridFactory(Factory.Locate(IDesignComponentGridFactory));
  fNamesGrid := mGF.New(NewProps
    .SetObject('Data', fNamesGridData)
    .SetInt('MMHeight', 1000)
    .SetInt('MMWidth', 1000)
    .SetInt(cProps.RowMMHeight, 25)
    .SetInt(cProps.ColMMWidth, 25)
    .SetInt(cProps.ColOddColor, clLime)
    .SetInt(cProps.ColEvenColor, clAqua)
    .SetInt(cProps.RowOddColor, clRed)
    .SetInt(cProps.RowEvenColor, clYellow)
    .SetInt(cProps.Color, clMaroon)
    .SetInt('LaticeColColor', clRed)
    .SetInt('LaticeColSize', 10)
    .SetInt('LaticeRowColor', clGreen)
    .SetInt('LaticeRowSize', 2)
  );
  //
  fPagerData := TPagerData.Create;
  mPF := IDesignComponentPagerFactory(Factory.Locate(IDesignComponentPagerFactory));
  fPager := mPF.New(NewProps
    .SetObject('Data', fPagerData)
    .SetInt(cProps.SwitchEdge, cEdge.Right)
    .SetInt(cProps.SwitchSize, 40)
  );
  mPage := IDesignComponentHeader(Factory.Locate(IDesignComponentHeader, '', NewProps.SetStr(cProps.Caption, 'red').SetInt(cProps.Color, clRed).SetBool(cProps.Transparent, False)));
  (fPager as INode).AddChild(mPage as INode);
  mPage := IDesignComponentHeader(Factory.Locate(IDesignComponentHeader, '', NewProps.SetStr(cProps.Caption, 'blue').SetInt(cProps.Color, clblue).SetBool(cProps.Transparent, False)));
  (mPage as INode).AddChild(fNamesGrid as INode);
  (fPager as INode).AddChild(mPage as INode);
  mPage := IDesignComponentHeader(Factory.Locate(IDesignComponentHeader, '', NewProps.SetStr(cProps.Caption, 'green').SetInt(cProps.Color, clgreen).SetBool(cProps.Transparent, False)));
  (fPager as INode).AddChild(mPage as INode);
end;

function TGUI.DoCompose(const AProps: IProps;
  const AChildren: TMetaElementArray): IMetaElement;
var
  mPager: IMetaElement;
begin
  mPager := fPager.Compose(AProps, nil);
  Result := fMainForm.Compose(AProps, [mPager as IMetaElement]);
end;

end.

