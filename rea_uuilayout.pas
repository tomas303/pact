unit rea_uuilayout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, rea_iuilayout, trl_itree, fgl, trl_ilog, trl_irestatement,
  iuibits;

type

  // hide horizontal / vertical implementation
  IUniItem = interface
  ['{BFC52343-B9AE-4908-9D2F-E7A234421EF1}']
    function GetMMSize: integer;
    function GetPlace: integer;
    function GetSize: integer;
    function GetStart: integer;
    procedure SetMMSize(AValue: integer);
    procedure SetPlace(AValue: integer);
    procedure SetSize(AValue: integer);
    procedure SetStart(AValue: integer);
    property Place: integer read GetPlace write SetPlace;
    property MMSize: integer read GetMMSize write SetMMSize;
    property Start: integer read GetStart write SetStart;
    property Size: integer read GetSize write SetSize;
  end;

  { TUniItem }

  TUniItem = class(TInterfacedObject, IUniItem)
  protected
    // IUniItem = interface
    function GetMMSize: integer; virtual; abstract;
    function GetPlace: integer; virtual; abstract;
    function GetSize: integer; virtual; abstract;
    function GetStart: integer; virtual; abstract;
    procedure SetMMSize(AValue: integer); virtual; abstract;
    procedure SetPlace(AValue: integer); virtual; abstract;
    procedure SetSize(AValue: integer); virtual; abstract;
    procedure SetStart(AValue: integer); virtual; abstract;
    property Place: integer read GetPlace write SetPlace;
    property MMSize: integer read GetMMSize write SetMMSize;
    property Start: integer read GetStart write SetStart;
    property Size: integer read GetSize write SetSize;
  protected
    fItem: INode;
  public
    constructor Create(const AItem: INode);
  end;

  TUniItemClass = class of TUniItem;

  { TUniHorizontalItem }

  TUniHorizontalItem = class(TUniItem)
  protected
    // IUniItem = interface
    function GetMMSize: integer; override;
    function GetPlace: integer; override;
    function GetSize: integer; override;
    function GetStart: integer; override;
    procedure SetMMSize(AValue: integer); override;
    procedure SetPlace(AValue: integer); override;
    procedure SetSize(AValue: integer); override;
    procedure SetStart(AValue: integer); override;
  end;

  { TUniVerticalItem }

  TUniVerticalItem = class(TUniItem)
  protected
    // IUniItem = interface
    function GetMMSize: integer; override;
    function GetPlace: integer; override;
    function GetSize: integer; override;
    function GetStart: integer; override;
    procedure SetMMSize(AValue: integer); override;
    procedure SetPlace(AValue: integer); override;
    procedure SetSize(AValue: integer); override;
    procedure SetStart(AValue: integer); override;
  end;

  { TUIDesktopLayout }

  TUIDesktopLayout = class(TInterfacedObject, IUITiler)
  protected type
    TPlaceItems = specialize TFPGInterfacedObjectList<IUniItem>;
  protected
    procedure Reposition(const ANode: INode; const AClass: TUniItemClass; AStart, ASize: integer);
  protected
    function ElasticMMSize(const ANode: INode; const AClass: TUniItemClass): integer;
    function ResizeFixed(const ANode: INode; const AClass: TUniItemClass; const AR: IRestatement): integer;
    function ResizeElastic(const ANode: INode; const AClass: TUniItemClass; const AElasticMMTotal, AElasticTotal: integer): integer;
    procedure Spread(const ANode: INode; const AClass: TUniItemClass; ASize, AUsedSize: integer);
    procedure Replace(const ANode: INode; const AClass: TUniItemClass; ASize: integer; const AR: IRestatement);
  protected
    // IUITiler
    procedure ReplaceChildren(const AContainer: IUIBit);
  protected
    fHR: IRestatement;
    fVR: IRestatement;
  published
    property HR: IRestatement read fHR write fHR;
    property VR: IRestatement read fVR write fVR;
  end;


implementation

{ TUIDesktopLayout }

function TUIDesktopLayout.ElasticMMSize(const ANode: INode; const AClass: TUniItemClass): integer;
var
  mChild: INode;
  mUni: IUniItem;
begin
  Result := 0;
  for mChild in ANode do begin
    mUni := AClass.Create(mChild);
    case mUni.Place of
      cPlace.Elastic:
        Result := Result + mUni.MMSize;
    end;
  end;
end;

function TUIDesktopLayout.ResizeFixed(const ANode: INode; const AClass: TUniItemClass;
  const AR: IRestatement): integer;
var
  mChild: INode;
  mUni: IUniItem;
begin
  Result := 0;
  for mChild in ANode do begin
    mUni := AClass.Create(mChild);
    case mUni.Place of
      cPlace.FixFront, cPlace.FixMiddle, cPlace.FixBack:
        begin
          mUni.Size :=  AR.Restate(mUni.MMSize);
          Result := Result + mUni.Size;
        end;
    end;
  end;
end;

function TUIDesktopLayout.ResizeElastic(const ANode: INode; const AClass: TUniItemClass;
  const AElasticMMTotal, AElasticTotal: integer): integer;
var
  mChild: INode;
  mUni: IUniItem;
begin
  Result := 0;
  for mChild in ANode do begin
    mUni := AClass.Create(mChild);
    case mUni.Place of
      cPlace.Elastic:
        begin
          if AElasticMMTotal = 0 then
          begin
            // this is special case when all sizes are 0 - so we resize them equally
            mUni.Size :=  Round(AElasticTotal / ANode.Count);
          end
          else
          begin
            mUni.Size :=  Round(AElasticTotal * mUni.MMSize / AElasticMMTotal);
          end;
          Result := Result + mUni.Size;
        end;
    end;
  end;
end;

procedure TUIDesktopLayout.Spread(const ANode: INode;
  const AClass: TUniItemClass; ASize, AUsedSize: integer);
var
  mChild: INode;
  mUni: IUniItem;
  mStart, mRightStart: integer;
  mMiddles: TPlaceItems;
  mFixBackHit: Boolean;
  mDelta: integer;
  mCnt: integer;
begin
  mStart := 0;
  mFixBackHit := False;
  mMiddles := TPlaceItems.Create;
  try
    for mChild in ANode do begin
      mUni := AClass.Create(mChild);
      case mUni.Place of
        cPlace.FixMiddle:
          begin
            mMiddles.Add(mUni);
          end;
        cPlace.FixBack:
          begin
             mFixBackHit := True;
             // move postion so last place will touch opposite line(uiPlaceFixBack will push
             // all what remains to oposite line)
             mRightStart := mStart - 1 + ASize - AUsedSize;
             if mRightStart > mStart then
               mStart := mRightStart;
          end;
        else
          begin
            if not mFixBackHit then
              mMiddles.Clear;
          end;
      end;
      mUni.Start := mStart;
      mStart := mUni.Start + mUni.Size;
    end;
    mDelta := (ASize - AUsedSize) div (mMiddles.Count + 1);
    if mDelta > 0 then begin
      mCnt := 0;
      for mUni in mMiddles do
      begin
        inc(mCnt);
        mUni.Start := mUni.Start + mDelta * mCnt;
      end;
    end;
  finally
    mMiddles.Free;
  end;
end;

procedure TUIDesktopLayout.Reposition(const ANode: INode;
  const AClass: TUniItemClass; AStart, ASize: integer);
var
  mChild: INode;
  mUni: IUniItem;
begin
  for mChild in ANode do begin
    mUni := AClass.Create(mChild);
    mUni.Start := AStart;
    mUni.Size := ASize;
  end;
end;

procedure TUIDesktopLayout.Replace(const ANode: INode;
  const AClass: TUniItemClass; ASize: integer; const AR: IRestatement);
var
  mElasticMMTotal: integer;
  mFixedSize: integer;
  mElasticSize: integer;
begin
  mElasticMMTotal := ElasticMMSize(ANode, AClass);
  mFixedSize := ResizeFixed(ANode, AClass, AR);
  mElasticSize := ResizeElastic(ANode, AClass, mElasticMMTotal, ASize - mFixedSize);
  Spread(ANode, AClass, ASize, mFixedSize + mElasticSize);
end;

procedure TUIDesktopLayout.ReplaceChildren(const AContainer: IUIBit);
begin
  // setup same height and count width of fixed fields
  case (AContainer as IUIPlacement).Layout of
    cLayout.Horizontal:
      begin
        Replace(AContainer as INode, TUniHorizontalItem, (AContainer as IUIPlace).Width, HR);
        Reposition(AContainer as INode, TUniVerticalItem, 0, (AContainer as IUIPlace).Height);
      end;
    cLayout.Vertical:
      begin
        Replace(AContainer as INode, TUniVerticalItem, (AContainer as IUIPlace).Height, VR);
        Reposition(AContainer as INode, TUniHorizontalItem, 0, (AContainer as IUIPlace).Width);
      end;
    cLayout.Overlay:
      begin
        Reposition(AContainer as INode, TUniHorizontalItem, 0, (AContainer as IUIPlace).Width);
        Reposition(AContainer as INode, TUniVerticalItem, 0, (AContainer as IUIPlace).Height);
      end;
  end;
end;

{ TUniVerticalItem }

function TUniVerticalItem.GetMMSize: integer;
begin
  Result := (fItem as IUIPlacement).MMHeight;
end;

function TUniVerticalItem.GetPlace: integer;
begin
  Result := (fItem as IUIPlacement).Place;
end;

function TUniVerticalItem.GetSize: integer;
begin
  Result := (fItem as IUIPlace).Height;
end;

function TUniVerticalItem.GetStart: integer;
begin
  Result := (fItem as IUIPlace).Top;
end;

procedure TUniVerticalItem.SetMMSize(AValue: integer);
begin
  (fItem as IUIPlacement).MMHeight := AValue;
end;

procedure TUniVerticalItem.SetPlace(AValue: integer);
begin
  (fItem as IUIPlacement).Place := AValue;
end;

procedure TUniVerticalItem.SetSize(AValue: integer);
begin
  (fItem as IUIPlace).Height := AValue;
end;

procedure TUniVerticalItem.SetStart(AValue: integer);
begin
  (fItem as IUIPlace).Top := AValue;
end;

{ TUniItem }

constructor TUniItem.Create(const AItem: INode);
begin
  fItem := AItem;
end;

{ TUniHorizontalItem }

function TUniHorizontalItem.GetMMSize: integer;
begin
  Result := (fItem as IUIPlacement).MMWidth;
end;

function TUniHorizontalItem.GetPlace: integer;
begin
  Result := (fItem as IUIPlacement).Place;
end;

function TUniHorizontalItem.GetSize: integer;
begin
  Result := (fItem as IUIPlace).Width;
end;

function TUniHorizontalItem.GetStart: integer;
begin
  Result := (fItem as IUIPlace).Left;
end;

procedure TUniHorizontalItem.SetMMSize(AValue: integer);
begin
  (fItem as IUIPlacement).MMWidth := AValue;
end;

procedure TUniHorizontalItem.SetPlace(AValue: integer);
begin
  (fItem as IUIPlacement).Place := AValue;
end;

procedure TUniHorizontalItem.SetSize(AValue: integer);
begin
  (fItem as IUIPlace).Width := AValue;
end;

procedure TUniHorizontalItem.SetStart(AValue: integer);
begin
  (fItem as IUIPlace).Left := AValue;
end;

end.

