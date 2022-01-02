unit uappgui;

{$mode ObjFPC}{$H+}

interface

uses
  uappdata,
  rea_udesigncomponent, rea_idesigncomponent, trl_iprops, trl_imetaelement;

type

  { TGUI }

  TGUI = class(TDesignComponent, IDesignComponentApp)
  private
    fMainForm: IDesignComponentForm;
    {
    fNameList ... list of names ... grid
    fedit namae .... edit name and surename

    faction buttons ..... tlacitka ke gridu ... new, edit, delete
    or this both can be part of element

    grid                    edit


    add,remove,delete

    }


  protected
    function DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement; override;
  public
    constructor Create(const AMainForm: IDesignComponentForm);
  end;



implementation

{ TGUI }

function TGUI.DoCompose(const AProps: IProps;
  const AChildren: TMetaElementArray): IMetaElement;
begin
  Result := fMainForm.Compose(AProps, AChildren);
end;

constructor TGUI.Create(const AMainForm: IDesignComponentForm);
begin
  inherited Create;
  fMainForm := AMainForm;
end;

end.

