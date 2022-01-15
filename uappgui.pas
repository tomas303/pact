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
    fMainForm: IDesignComponentForm;
    fNamesGrid: IDesignComponentGrid;
    fPager: IDesignComponentPager;
  protected
    function DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement; override;
  public
    constructor Create(const AMainForm: IDesignComponentForm; const ANamesGrid: IDesignComponentGrid;
      const APager: IDesignComponentPager);
  end;

implementation

{ TGUI }

function TGUI.DoCompose(const AProps: IProps;
  const AChildren: TMetaElementArray): IMetaElement;
var
  mGrid: IMetaElement;
  mPager: IMetaElement;
begin
  Result := fMainForm.Compose(AProps, AChildren);
  //mGrid := fNamesGrid.Compose(AProps, nil);
  //(Result as INode).AddChild(mGrid as INode);
  mPager := fPager.Compose(AProps, nil);
  (Result as INode).AddChild(mPager as INode);
end;

constructor TGUI.Create(const AMainForm: IDesignComponentForm; const ANamesGrid: IDesignComponentGrid;
  const APager: IDesignComponentPager);
begin
  inherited Create;
  fMainForm := AMainForm;
  fNamesGrid := ANamesGrid;
  fPager := APager;
end;

end.

