unit uappdata;

{$mode ObjFPC}{$H+}

interface

uses
  sysutils;

type
  TFormData = class
  private
    fLeft: Integer;
    fTop: Integer;
    fWidth: Integer;
    fHeight: Integer;
  published
    property Left: Integer read fLeft write fLeft;
    property Top: Integer read fTop write fTop;
    property Width: Integer read fWidth write fWidth;
    property Height: Integer read fHeight write fHeight;
  end;

  TEditData = class
  private
    fText: String;
    fFocused: Boolean;
  published
    property Text: String read fText write fText;
    property Focused: Boolean read fFocused write fFocused;
  end;

  { IGridData2 }

  IGridDataProvider = interface
  ['{308CF052-70BC-46D9-8B76-C565B3920261}']
    function Prev: Boolean;
    function Next: Boolean;
    function IsEmpty: Boolean;
    function GetValue(Ind: integer): string;
    procedure SetValue(Ind: integer; AValue: string);
    property Value[Ind: integer]: string read GetValue write SetValue; default;
  end;

  { TGridData2 }

  TGridData2 = class
  private type
    TMatrix = array of array of string;
  private
    fData: TMatrix;
    fEditData: TEditData;
    fDataRow: integer;
    fProvider: IGridDataProvider;
    fColCount: Integer;
    fRowCount: Integer;
    fCurrentRow: Integer;
    fCurrentCol: Integer;
    fBrowseMode: Boolean;
    function GetValue(Row, Col: Integer): string;
    procedure SetColCount(AValue: Integer);
    procedure SetCurrentCol(AValue: Integer);
    procedure SetCurrentRow(AValue: Integer);
    procedure SetRowCount(AValue: Integer);
    procedure SetValue(Row, Col: Integer; AValue: string);
    procedure Move(ADelta: Integer);
    procedure ReadDataRow(ARow: Integer);
    procedure ClearDataRow(ARow: Integer);
    procedure SynchronizeEditText;
  public
    constructor Create(const AProvider: IGridDataProvider);
    procedure BeforeDestruction; override;
    procedure ReadData;
    property ColCount: Integer read fColCount write SetColCount;
    property RowCount: Integer read fRowCount write SetRowCount;
    property CurrentRow: Integer read fCurrentRow write SetCurrentRow;
    property CurrentCol: Integer read fCurrentCol write SetCurrentCol;
    property BrowseMode: Boolean read fBrowseMode write fBrowseMode;
    property Value[Row, Col: Integer]: string read GetValue write SetValue; default;
    property EditData: TEditData read fEditData;
  end;

  { TDummyGridDataProvider }

  TDummyGridDataProvider = class(TInterfacedObject, IGridDataProvider)
  private type
    TData = array[0..2, 0..1] of String;
  private
    fData: TData;
    fActRow: Integer;
  protected
    function IsEmpty: Boolean;
    function Prev: Boolean;
    function Next: Boolean;
    function GetValue(Ind: integer): string;
    procedure SetValue(Ind: integer; AValue: string);
    property Value[Ind: integer]: string read GetValue write SetValue; default;
  public
    constructor Create;
  end;


implementation

{ TDummyGridDataProvider }

function TDummyGridDataProvider.IsEmpty: Boolean;
begin
  Result := False;
end;

function TDummyGridDataProvider.Prev: Boolean;
begin
  Result := fActRow > 0;
  if Result then
    Dec(fActRow);
end;

function TDummyGridDataProvider.Next: Boolean;
begin
  Result := fActRow < High(fData);
  if Result then
    Inc(fActRow);
end;

function TDummyGridDataProvider.GetValue(Ind: integer): string;
begin
  Result := fData[fActRow, Ind];
end;

procedure TDummyGridDataProvider.SetValue(Ind: integer; AValue: string);
begin
  fData[fActRow, Ind] := AValue;
end;

constructor TDummyGridDataProvider.Create;
begin
  fData[0, 0] := 'one';
  fData[0, 1] := 'first';
  fData[1, 0] := 'two';
  fData[1, 1] := 'second';
  fData[2, 0] := 'three';
  fData[2, 1] := 'third';
end;

{ TGridData2 }

function TGridData2.GetValue(Row, Col: Integer): string;
begin
  Result := fData[Row, Col];
end;

procedure TGridData2.SetColCount(AValue: Integer);
begin
  if fColCount = AValue then Exit;
  fColCount := AValue;
end;

procedure TGridData2.SetCurrentCol(AValue: Integer);
begin
  if fCurrentCol = AValue then Exit;
  if (AValue >= Low(fData[CurrentRow])) or (AValue <= High(fData[CurrentRow])) then begin
    fCurrentCol := AValue;
    SynchronizeEditText;
  end;
end;

procedure TGridData2.SetCurrentRow(AValue: Integer);
begin
  if fCurrentRow = AValue then Exit;
  if (AValue >= Low(fData)) or (AValue <= High(fData)) then begin
    fCurrentRow := AValue;
    SynchronizeEditText;
  end;
end;

procedure TGridData2.SetRowCount(AValue: Integer);
begin
  if fRowCount=AValue then Exit;
  fRowCount:=AValue;
end;

procedure TGridData2.SetValue(Row, Col: Integer; AValue: string);
begin
  fData[Row, Col] := AValue;
  Move(Row - fDataRow);
  fProvider[Col] := AValue;
end;

procedure TGridData2.Move(ADelta: Integer);
var
  i: integer;
begin
  if ADelta > 0 then begin
    for i := 1 to ADelta do begin
      fProvider.Next;
      Inc(fDataRow);
    end;
  end else if ADelta < 0 then begin
    for i := ADelta to -1 do begin
      fProvider.Prev;
      Dec(fDataRow);
    end;
  end;
end;

procedure TGridData2.ReadData;
var
  i: integer;
  mMoved: Boolean;
begin
  SetLength(fData, RowCount, ColCount);
  Move(-fDataRow);
  if fProvider.IsEmpty then begin
    for i := 0 to RowCount - 1 do begin
      ClearDataRow(i);
    end;
  end else begin
    for i := 0 to RowCount - 1 do begin
      if mMoved then begin
        ReadDataRow(fDataRow);
        mMoved := fProvider.Next;
        if mMoved then
          Inc(fDataRow);
      end else begin
        ClearDataRow(i);
      end;
    end;
  end;
  SynchronizeEditText;
end;

procedure TGridData2.ReadDataRow(ARow: Integer);
var
  i: integer;
begin
  for i := 0 to ColCount - 1 do
    Value[ARow, i] := fProvider[i];
end;

procedure TGridData2.ClearDataRow(ARow: Integer);
var
  i: integer;
begin
  for i := 0 to ColCount - 1 do
    Value[ARow, i] := '';
end;

procedure TGridData2.SynchronizeEditText;
begin
  EditData.Text := Value[CurrentRow, CurrentCol];
  EditData.Focused := True;
end;

constructor TGridData2.Create(const AProvider: IGridDataProvider);
begin
  fProvider := AProvider;
  fBrowseMode := True;
  fEditData := TEditData.Create;
end;

procedure TGridData2.BeforeDestruction;
begin
  FreeAndNil(fEditData);
  inherited BeforeDestruction;
end;

end.

