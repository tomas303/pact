unit uappdata;

{$mode delphi}{$H+}

interface

uses
  sysutils, rea_idesigncomponent, rea_iflux, trl_iprops, trl_udifactory;

type

  { TDummyGridDataProvider }

  TDummyGridDataProvider = class(TInterfacedObject, IGridDataProvider)
  private type
    TData = array[0..2, 0..1] of String;

    { IBookmark }

    IBookmark = interface
    ['{5DDCB7AB-EC37-4A0C-A100-1411753F9676}']
      function GetData: Integer;
      procedure SetData(AValue: Integer);
      property Data: Integer read GetData write SetData;
    end;

    { TBookmark }

    TBookmark = class(TInterfacedObject, IBookmark)
    private
      fData: Integer;
      function GetData: Integer;
      procedure SetData(AValue: Integer);
      property Data: Integer read GetData write SetData;
    public
      constructor Create(const AData: Integer);
    end;

  private
    fData: TData;
    fActRow: Integer;
    fDeltaMove: Integer;
    fSilent: Boolean;
    procedure MoveNotifierData(const AProps: IProps);
    procedure SetMoveNotifier(AValue: IFluxNotifier);
    procedure NotifyMove;
  protected
    function IsEmpty: Boolean;
    function Prev: Boolean;
    function Next: Boolean;
    function NewBookmark: IInterface;
    procedure GotoBookmark(ABookmark: IInterface);
    function GetValue(Ind: integer): string;
    procedure SetValue(Ind: integer; AValue: string);
    property Value[Ind: integer]: string read GetValue write SetValue; default;
    function GetSilent: Boolean;
    procedure SetSilent(AValue: Boolean);
    property Silent: Boolean read GetSilent write SetSilent;
  public
    procedure AfterConstruction; override;
  protected
    fFactory2: TDIFactory2;
    fMoveNotifier: IFluxNotifier;
    fRenderNotifier: IFluxNotifier;
  published
    property Factory2: TDIFactory2 read fFactory2 write fFactory2;
    property MoveNotifier: IFluxNotifier read fMoveNotifier write SetMoveNotifier;
    property RenderNotifier: IFluxNotifier read fRenderNotifier write fRenderNotifier;
  end;


implementation

{ TDummyGridDataProvider.TBookmark }

function TDummyGridDataProvider.TBookmark.GetData: Integer;
begin
  Result := fData;
end;

procedure TDummyGridDataProvider.TBookmark.SetData(AValue: Integer);
begin
  fData := AValue;
end;

constructor TDummyGridDataProvider.TBookmark.Create(const AData: Integer);
begin
  inherited Create;
  fData := AData;
end;

{ TDummyGridDataProvider }

procedure TDummyGridDataProvider.MoveNotifierData(const AProps: IProps);
begin
  AProps.SetInt('deltamove', fDeltaMove);
end;

procedure TDummyGridDataProvider.SetMoveNotifier(AValue: IFluxNotifier);
begin
  if fMoveNotifier = AValue then Exit;
  fMoveNotifier := AValue;
  fMoveNotifier.Add(MoveNotifierData);
end;

procedure TDummyGridDataProvider.NotifyMove;
begin
  if MoveNotifier <> nil then begin
    MoveNotifier.Notify;
    if RenderNotifier <> nil then
      RenderNotifier.Notify;
  end;
end;

function TDummyGridDataProvider.IsEmpty: Boolean;
begin
  Result := False;
end;

function TDummyGridDataProvider.Prev: Boolean;
begin
  Result := fActRow > 0;
  if Result then begin
    Dec(fActRow);
    if not Silent and (MoveNotifier <> nil) then begin
      fDeltaMove := -1;
      NotifyMove;
    end;
  end;
end;

function TDummyGridDataProvider.Next: Boolean;
var
  mProps: IProps;
begin
  Result := fActRow < High(fData);
  if Result then begin
    Inc(fActRow);
    if not Silent and (MoveNotifier <> nil) then begin
      fDeltaMove := 1;
      NotifyMove;
    end;
  end;
end;

function TDummyGridDataProvider.NewBookmark: IInterface;
begin
  Result := TBookmark.Create(fActRow);
end;

procedure TDummyGridDataProvider.GotoBookmark(ABookmark: IInterface);
begin
  fActRow := (ABookmark as IBookmark).Data;
end;

function TDummyGridDataProvider.GetValue(Ind: integer): string;
begin
  Result := fData[fActRow, Ind];
end;

procedure TDummyGridDataProvider.SetValue(Ind: integer; AValue: string);
begin
  fData[fActRow, Ind] := AValue;
end;

function TDummyGridDataProvider.GetSilent: Boolean;
begin
  Result := fSilent;
end;

procedure TDummyGridDataProvider.SetSilent(AValue: Boolean);
begin
  fSilent := AValue;
end;

procedure TDummyGridDataProvider.AfterConstruction;
begin
  inherited AfterConstruction;
  fData[0, 0] := 'one';
  fData[0, 1] := 'first';
  fData[1, 0] := 'two';
  fData[1, 1] := 'second';
  fData[2, 0] := 'three';
  fData[2, 1] := 'third';
end;

end.

