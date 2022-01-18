unit uappgui;

{$mode objfpc}{$H+}
{$modeswitch typehelpers}
{$modeswitch multihelpers}

interface

uses
  uappdata, uappfunc, sysutils,
  rea_udesigncomponent, rea_idesigncomponent, trl_iprops, trl_imetaelement,
  flu_iflux, rea_ibits, rea_ilayout, trl_itree, trl_idifactory, rea_udesigncomponentfunc,
  rea_udesigncomponentdata, trl_isequence, Graphics;

type

  { TGUI }

  TGUI = class(TDesignComponent, IDesignComponentApp)
  private
    fActionIDSequence: ISequence;
  private
    fMainFormData: TFormData;
    fPagerData: TPagerData;
    fPersonGridData: TGridData;
    fTestEditData: TEditData;
  private
    fMainForm: IDesignComponent;
    fPersonGrid: IDesignComponent;
    fPager: IDesignComponent;
    fHelloButton: IDesignComponent;
    fTestEdit: IDesignComponent;
    fPersonEdit: IDesignComponent;
    function NewLabEdit(const AEdge: integer; const ACaption: String; AMMWidth, AMMHeight: Integer;
      AColor: TColor; ACapWidth, ACapHeight: Integer): IDesignComponent;
    function NewPersonEdit: IDesignComponent;
    function NewPersonGrid: IDesignComponent;
    function NewPerson: IDesignComponent;
  protected
    procedure InitValues; override;
    function DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement; override;
  end;

implementation

{ TGUI }

function TGUI.NewLabEdit(const AEdge: integer; const ACaption: String;
  AMMWidth, AMMHeight: Integer; AColor: TColor; ACapWidth, ACapHeight: Integer): IDesignComponent;
var
  mF: IDesignComponentLabelEditFactory;
  mProps: IProps;
begin
  mF := IDesignComponentLabelEditFactory(Factory.Locate(IDesignComponentLabelEditFactory));
  mProps := NewProps
    .SetBool(cProps.Flat, True)
    .SetStr(cProps.Caption, ACaption)
    .SetInt(cProps.CaptionEdge, AEdge)
    .SetInt(cProps.Color, AColor)
    .SetBool(cProps.Transparent, False)
    .SetInt(cProps.MMWidth, AMMWidth)
    .SetInt(cProps.MMHeight, AMMHeight)
    .SetInt(cProps.CaptionWidth, ACapWidth)
    .SetInt(cProps.CaptionHeight, ACapHeight);
  Result := mF.New(mProps);
end;

function TGUI.NewPersonEdit: IDesignComponent;
var
  mF: IDesignComponentStripFactory;
begin
  mF := IDesignComponentStripFactory(Factory.Locate(IDesignComponentStripFactory));
  Result := mF.New(NewProps
    .SetInt(cProps.MMWidth, 200)
    .SetInt(cProps.Place, cPlace.FixBack)
    .SetInt(cProps.Layout, cLayout.Vertical)
    .SetInt(cProps.Border, 11)
    .SetInt(cProps.BorderColor, clBlack)
  );
  (Result as INode).AddChild( NewLabEdit(cEdge.Top, 'Name', 0, 70, clAqua, 0, 30) as INode);
  (Result as INode).AddChild( NewLabEdit(cEdge.Top, 'Surename', 0, 70, clAqua, 0, 30) as INode);
end;

function TGUI.NewPersonGrid: IDesignComponent;
var
  mF: IDesignComponentGridFactory;
begin
  mF := IDesignComponentGridFactory(Factory.Locate(IDesignComponentGridFactory));
  Result := mF.New(NewProps
    .SetObject('Data', fPersonGridData)
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
end;

function TGUI.NewPerson: IDesignComponent;
var
  mF: IDesignComponentStripFactory;
begin
  mF := IDesignComponentStripFactory(Factory.Locate(IDesignComponentStripFactory));
  Result := mF.New(NewProps
    .SetInt(cProps.Layout, cLayout.Horizontal)
    .SetInt(cProps.Place, cPlace.Elastic)
  );
  (Result as INode).AddChild(fPersonGrid as INode);
  (Result as INode).AddChild(fPersonEdit as INode);
end;

procedure TGUI.InitValues;
var
  mFF: IDesignComponentFormFactory;
  mPF: IDesignComponentPagerFactory;
  mPage: IDesignComponent;
  mGF: IDesignComponentGridFactory;
  mBF: IDesignComponentButtonFactory;
  mBClickFunc: IFluxFunc;
  mEF: IDesignComponentEditFactory;
  mEKeyDownFunc, mEKeyTextChangedFunc: IFluxFunc;
  mSF: IDesignComponentStripFactory;
  mStrip: IDesignComponent;
begin
  inherited InitValues;
  fActionIDSequence := ISequence(Factory.Locate(ISequence, 'ActionID'));
  //
  fPersonGridData := TGridData.Create(TDummyGridDataProvider.Create);
  fPersonGridData.RowCount := 10;
  fPersonGridData.ColCount := 2;
  fPersonGridData.ReadData;
  //
  fMainFormData := TFormData.Create;
  fMainFormData.Left := 0;
  fMainFormData.Top := 0;
  fMainFormData.Width := 800;
  fMainFormData.Height := 400;
  mFF := IDesignComponentFormFactory(Factory.Locate(IDesignComponentFormFactory));
  fMainForm := mFF.New(NewProps.SetObject('Data', fMainFormData));
  //
  fPersonEdit := NewPersonEdit;
  fPersonGrid := NewPersonGrid;
  //
  mBF := IDesignComponentButtonFactory(Factory.Locate(IDesignComponentButtonFactory));
  mBClickFunc := THelloButtonClickFunc.Create(fActionIDSequence.Next);
  fHelloButton := mBF.New(NewProps
    .SetIntf(cProps.ClickFunc, mBClickFunc)
    .SetStr(cProps.Text, 'Hello')
  );
  //
  fTestEditData := TEditData.Create;
  mEF := IDesignComponentEditFactory(Factory.Locate(IDesignComponentEditFactory));
  mEKeyDownFunc := TTestKeyDownFunc.Create(fActionIDSequence.Next);
  mEKeyTextChangedFunc := TTestTextChangedFunc.Create(fActionIDSequence.Next);
  fTestEdit := mEF.New(NewProps
    .SetObject('Data', fTestEditData)
    .SetIntf(cProps.KeyDownFunc, mEKeyDownFunc)
    .SetIntf(cProps.TextChangedFunc, mEKeyTextChangedFunc)
    .SetStr(cProps.Text, 'Test')
  );
  //
  fPagerData := TPagerData.Create;
  mPF := IDesignComponentPagerFactory(Factory.Locate(IDesignComponentPagerFactory));
  fPager := mPF.New(NewProps
    .SetObject('Data', fPagerData)
    .SetInt(cProps.SwitchEdge, cEdge.Right)
    .SetInt(cProps.SwitchSize, 40)
  );
  mPage := IDesignComponentStrip(Factory.Locate(IDesignComponentStrip, '', NewProps.SetStr(cProps.Caption, 'red').SetInt(cProps.Color, clRed).SetBool(cProps.Transparent, False)));

  mSF := IDesignComponentStripFactory(Factory.Locate(IDesignComponentStripFactory));
  mStrip := mSF.New(NewProps
    .SetInt(cProps.MMWidth, 400)
    .SetInt(cProps.Place, cPlace.FixMiddle)
    .SetInt(cProps.Layout, cLayout.Vertical)
    );
  (mStrip as INode).AddChild(fHelloButton as INode);
  (mStrip as INode).AddChild(fTestEdit as INode);
  (mPage as INode).AddChild(mStrip as INode);
  (fPager as INode).AddChild(mPage as INode);
  //
  mPage := IDesignComponentStrip(Factory.Locate(IDesignComponentStrip, '', NewProps.SetStr(cProps.Caption, 'blue').SetInt(cProps.Color, clblue).SetBool(cProps.Transparent, False)));
  (mPage as INode).AddChild(fPersonGrid as INode);
  (fPager as INode).AddChild(mPage as INode);
  //
  mPage := IDesignComponentStrip(Factory.Locate(IDesignComponentStrip, '', NewProps
    .SetStr(cProps.Caption, 'green')
    .SetInt(cProps.Color, clgreen)
    .SetBool(cProps.Transparent, False)
    .SetInt(cProps.Layout, cLayout.Vertical)
  ));
  {
  (mPage as INode).AddChild( NewLabEdit(cEdge.Right, 'ONE', 0, 30, clYellow, 80, 0) as INode);
  (mPage as INode).AddChild( NewLabEdit(cEdge.Right, 'TWO', 0, 30, clBlue, 80, 0) as INode);
  }
  {
  (mPage as INode).AddChild( NewLabEdit(cEdge.Bottom, 'ONE', 0, 80, clYellow, 0, 30) as INode);
  (mPage as INode).AddChild( NewLabEdit(cEdge.Bottom, 'TWO', 0, 80, clBlue, 0, 30) as INode);
  }
  (mPage as INode).AddChild(NewPerson as INode);
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

