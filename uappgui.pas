unit uappgui;

{$mode ObjFPC}{$H+}

interface

uses
  uappdata,
  rea_udesigncomponent, rea_idesigncomponent, trl_iprops, trl_imetaelement,
  flu_iflux, rea_ibits, rea_ilayout, trl_itree;

type

  { TGUI }

  TGUI = class(TDesignComponent, IDesignComponentApp)
  private
    fMainForm: IDesignComponentForm;
    fNamesGrid: IDesignComponentGrid;
  protected
    function DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement; override;
  public
    constructor Create(const AMainForm: IDesignComponentForm; const ANamesGrid: IDesignComponentGrid);
  end;

implementation

{ TGUI }

function TGUI.DoCompose(const AProps: IProps;
  const AChildren: TMetaElementArray): IMetaElement;
var
  mGrid: IMetaElement;
begin
  Result := fMainForm.Compose(AProps, AChildren);
  mGrid := fNamesGrid.Compose(AProps, nil);
  (Result as INode).AddChild(mGrid as INode);
end;

constructor TGUI.Create(const AMainForm: IDesignComponentForm; const ANamesGrid: IDesignComponentGrid);
begin
  inherited Create;
  fMainForm := AMainForm;
  fNamesGrid := ANamesGrid;
end;

end.

