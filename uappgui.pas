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

  { TDesignComponentGrid2 }

   TDesignComponentGrid2 = class(TDesignComponent, IDesignComponentGrid)
   private
     function ColProps(Row, Col: integer): IProps;
     function RowProps(Row: integer): IProps;
     function GridProps: IProps;
     function MakeRow(Row: integer): TMetaElementArray;
     function MakeGrid: TMetaElementArray;
     function LaticeColProps: IProps;
     function LaticeRowProps: IProps;
     function Latice(AElements: TMetaElementArray; ALaticeEl: TGuid; ALaticeProps: IProps): TMetaElementArray;
   protected
     function DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement; override;
   protected
     fData: TGridData2;
     fEdTextChangedNotifier: IFluxNotifier;
     fEdKeyDownNotifier: IFluxNotifier;
     fLaticeColColor: integer;
     fLaticeRowColor: integer;
     fLaticeColSize: integer;
     fLaticeRowSize: integer;
   published
     property Data: TGridData2 read fData write fData;
     property EdTextChangedNotifier: IFluxNotifier read fEdTextChangedNotifier write fEdTextChangedNotifier;
     property EdKeyDownNotifier: IFluxNotifier read fEdKeyDownNotifier write fEdKeyDownNotifier;
     property LaticeColColor: integer read fLaticeColColor write fLaticeColColor;
     property LaticeRowColor: integer read fLaticeRowColor write fLaticeRowColor;
     property LaticeColSize: integer read fLaticeColSize write fLaticeColSize;
     property LaticeRowSize: integer read fLaticeRowSize write fLaticeRowSize;
   end;

   { TDesignComponentEdit2 }

   TDesignComponentEdit2 = class(TDesignComponent, IDesignComponentEdit)
   protected
     function DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement; override;
   protected
     fData: TEditData;
     fAskNotifier: IFluxNotifier;
     fTextChangedNotifier: IFluxNotifier;
     fKeyDownNotifier: IFluxNotifier;
   published
     property Data: TEditData read fData write fData;
     property AskNotifier: IFluxNotifier read fAskNotifier write fAskNotifier;
     property TextChangedNotifier: IFluxNotifier read fTextChangedNotifier write fTextChangedNotifier;
     property KeyDownNotifier: IFluxNotifier read fKeyDownNotifier write fKeyDownNotifier;
   end;

implementation

{ TDesignComponentEdit2 }

function TDesignComponentEdit2.DoCompose(const AProps: IProps;
  const AChildren: TMetaElementArray): IMetaElement;
var
  mProps: IProps;
begin
  mProps := SelfProps.Clone([cProps.Place, cProps.MMWidth, cProps.MMHeight]);
  mProps
    .SetStr('ID', ID)
    .SetStr('Text', Data.Text)
    .SetIntf('AskNotifier', AskNotifier)
    .SetIntf('TextChangedNotifier', TextChangedNotifier)
    .SetIntf('KeyDownNotifier', KeyDownNotifier)
    .SetBool('Focused', Data.Focused)
    .SetBool('Flat', SelfProps.AsBool('Flat'));
  Result := ElementFactory.CreateElement(IEditBit, mProps);
end;

{ TDesignComponentGrid2 }

function TDesignComponentGrid2.ColProps(Row, Col: integer): IProps;
var
  mProp: IProp;
begin
  Result := NewProps
    .SetInt('Place', cPlace.Elastic)
    .SetStr('Text', Data[Row, Col])
    .SetInt(cProps.MMWidth, SelfProps.AsInt(cProps.ColMMWidth));
  if Row mod 2 = 1 then
    mProp := SelfProps.PropByName[cProps.ColOddColor]
  else
    mProp := SelfProps.PropByName[cProps.ColEvenColor];
  if mProp <> nil then
    Result.SetInt(cProps.Color, mProp.AsInteger);
end;

function TDesignComponentGrid2.RowProps(Row: integer): IProps;
var
  mProp: IProp;
begin
  Result := NewProps
    .SetInt('Place', cPlace.FixFront)
    .SetInt('Layout', cLayout.Horizontal)
    .SetInt(cProps.MMHeight, SelfProps.AsInt(cProps.RowMMHeight));
  if Row mod 2 = 1 then begin
    mProp := SelfProps.PropByName[cProps.RowOddColor];
  end else begin
    mProp := SelfProps.PropByName[cProps.RowEvenColor];
  end;
  if mProp <> nil then
    Result.SetInt(cProps.Color, mProp.AsInteger).SetBool('Transparent', False);
end;

function TDesignComponentGrid2.GridProps: IProps;
var
  mProp: IProp;
begin
  Result := SelfProps.Clone([cProps.Layout, cProps.Place, cProps.MMWidth, cProps.MMHeight]);
  Result
   .SetInt('Place', cPlace.Elastic)
   .SetInt('Layout', cLayout.Vertical);
  mProp := SelfProps.PropByName[cProps.Color];
  if mProp <> nil then
    Result.SetInt(cProps.Color, mProp.AsInteger).SetBool('Transparent', False)
end;

function TDesignComponentGrid2.MakeRow(Row: integer): TMetaElementArray;
var
  i: integer;
  mProps: IProps;
begin
  Result := TMetaElementArray.Create;
  SetLength(Result, Data.ColCount);
  for i := 0 to Data.ColCount - 1 do
    if (Row = Data.CurrentRow) and (i = Data.CurrentCol) then begin
      mProps := ColProps(Row, i);
      mProps
        .SetObject('Data', Data.EditData)
        .SetBool('Flat', True)
        .SetIntf('TextChangedNotifier', EdTextChangedNotifier)
        .SetIntf('KeyDownNotifier', EdKeyDownNotifier);
      Result[i] := ElementFactory.CreateElement(IDesignComponentEdit, mProps);
    end else begin
      Result[i] := ElementFactory.CreateElement(ITextBit, ColProps(Row, i));
    end;
end;

function TDesignComponentGrid2.MakeGrid: TMetaElementArray;
var
  i: integer;
begin
  Result := TMetaElementArray.Create;
  SetLength(Result, Data.RowCount);
  for i := 0 to Data.RowCount - 1 do begin
    Result[i] := ElementFactory.CreateElement(IStripBit, RowProps(i), Latice(MakeRow(i), IStripBit, LaticeColProps));
  end;
  Result := Latice(Result, IStripBit, LaticeRowProps);
end;

function TDesignComponentGrid2.LaticeColProps: IProps;
begin
  Result := NewProps
    .SetInt('Place', cPlace.FixFront)
    .SetBool('Transparent', False)
    .SetInt('Color', LaticeColColor)
    .SetInt('Width', LaticeColSize);
end;

function TDesignComponentGrid2.LaticeRowProps: IProps;
begin
  Result := NewProps
    .SetInt('Place', cPlace.FixFront)
    .SetBool('Transparent', False)
    .SetInt('Color', LaticeRowColor)
    .SetInt('Height', LaticeRowSize);
end;

function TDesignComponentGrid2.Latice(AElements: TMetaElementArray;
  ALaticeEl: TGuid; ALaticeProps: IProps): TMetaElementArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, Length(AElements) * 2 + 1);
  //Result[0] := ElementFactory.CreateElement(IStripBit, LaticeColProps);
  Result[0] := ElementFactory.CreateElement(ALaticeEl, ALaticeProps);
  for i := 0 to Length(AElements) - 1 do begin
    Result[i * 2 + 1] := AElements[i];
    Result[i * 2 + 2] := ElementFactory.CreateElement(ALaticeEl, ALaticeProps);
  end;
end;

function TDesignComponentGrid2.DoCompose(const AProps: IProps;
  const AChildren: TMetaElementArray): IMetaElement;
begin
  Result := ElementFactory.CreateElement(
    IStripBit, GridProps, MakeGrid);
end;

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

