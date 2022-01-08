unit uappgui;

{$mode ObjFPC}{$H+}

interface

uses
  uappdata,
  rea_udesigncomponent, rea_idesigncomponent, trl_iprops, trl_imetaelement,
  flu_iflux, rea_ibits;

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

  { TDesignComponentForm2 }

  TDesignComponentForm2 = class(TDesignComponent, IDesignComponentForm)
  protected
    function DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement; override;
  protected
    fData: TFormData;
    fSizeNotifier: IFluxNotifier;
    fMoveNotifier: IFluxNotifier;
    fCloseQueryNotifier: IFluxNotifier;
  published
    property Data: TFormData read fData write fData;
    property SizeNotifier: IFluxNotifier read fSizeNotifier write fSizeNotifier;
    property MoveNotifier: IFluxNotifier read fMoveNotifier write fMoveNotifier;
    property CloseQueryNotifier: IFluxNotifier read fCloseQueryNotifier write fCloseQueryNotifier;
  end;


implementation

{ TDesignComponentForm2 }

function TDesignComponentForm2.DoCompose(const AProps: IProps;
  const AChildren: TMetaElementArray): IMetaElement;
var
  mProps: IProps;
begin
  mProps := SelfProps.Clone([cProps.Title, cProps.Layout, cProps.Color, cProps.ActivateNotifier]);
  mProps
    .SetIntf(cProps.SizeNotifier, SizeNotifier)
    .SetIntf(cProps.MoveNotifier, MoveNotifier)
    .SetIntf(cProps.CloseQueryNotifier, CloseQueryNotifier)
    .SetInt(cProps.MMLeft, Data.Left)
    .SetInt(cProps.MMTop, Data.Top)
    .SetInt(cProps.MMWidth, Data.Width)
    .SetInt(cProps.MMHeight, Data.Height);
  Result := ElementFactory.CreateElement(IFormBit, mProps);
  AddChildren(Result, AChildren);
end;

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

