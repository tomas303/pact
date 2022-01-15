unit uappgui;

{$mode objfpc}{$H+}
{$modeswitch typehelpers}
{$modeswitch multihelpers}

interface

uses
  uappdata, sysutils,
  rea_udesigncomponent, rea_idesigncomponent, trl_iprops, trl_imetaelement,
  flu_iflux, rea_ibits, rea_ilayout, trl_itree, trl_idifactory, rea_udesigncomponentfunc,
  rea_udesigncomponentdata, trl_isequence;

type

  { TGUI }

  TGUI = class(TDesignComponent, IDesignComponentApp)
  private
    fMainFormData: TFormData;
  private
    fMainForm: IDesignComponent;
    fNamesGrid: IDesignComponentGrid;
    fPager: IDesignComponentPager;
  protected
    procedure InitValues; override;
    function DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement; override;
  public
    constructor Create(const AMainForm: IDesignComponentForm; const ANamesGrid: IDesignComponentGrid;
      const APager: IDesignComponentPager);
  end;

implementation

{ TGUI }

procedure TGUI.InitValues;
var
  mF: IDesignComponentFormFactory;
begin
  inherited InitValues;
  fMainFormData := TFormData.Create;
  fMainFormData.Left := 0;
  fMainFormData.Top := 0;
  fMainFormData.Width := 800;
  fMainFormData.Height := 400;
  mF := IDesignComponentFormFactory(Factory.Locate(IDesignComponentFormFactory));
  fMainForm := mF.New(NewProps.SetObject('Data', fMainFormData));
end;

function TGUI.DoCompose(const AProps: IProps;
  const AChildren: TMetaElementArray): IMetaElement;
var
  mGrid: IMetaElement;
  mPager: IMetaElement;
begin
  Result := fMainForm.Compose(AProps, AChildren);
  //mGrid := fNamesGrid.Compose(AProps, nil);
  //(Result as INode).AddChild(mGrid as INode);
  //mPager := fPager.Compose(AProps, nil);
  //(Result as INode).AddChild(mPager as INode);
end;

constructor TGUI.Create(const AMainForm: IDesignComponentForm; const ANamesGrid: IDesignComponentGrid;
  const APager: IDesignComponentPager);
begin
  inherited Create;
  //fMainForm := AMainForm;
  fNamesGrid := ANamesGrid;
  fPager := APager;
end;

end.

