unit uappfunc;

{$mode objfpc}{$H+}

interface

uses
  rea_udesigncomponentfunc, rea_udesigncomponentdata,
  Dialogs, rea_iflux, rea_idesigncomponent, sysutils;

type

  { THelloButtonClickFunc }

  THelloButtonClickFunc = class(TDesignComponentFunc)
  protected
    procedure DoExecute(const AAction: IFluxAction); override;
  end;

  { TTestKeyDownFunc }

  TTestKeyDownFunc = class(TDesignComponentFunc)
  protected
    procedure DoExecute(const AAction: IFluxAction); override;
  end;

  { TTestTextChangedFunc }

  TTestTextChangedFunc = class(TDesignComponentFunc)
  protected
    procedure DoExecute(const AAction: IFluxAction); override;
  end;

  { TDataToGUIFunc }

  TDataToGUIFunc = class(TDesignComponentFunc)
  private
    fProvider: IGridDataProvider;
    fProviderIndex: Integer;
    fData: TEditData;
  protected
    procedure DoExecute(const AAction: IFluxAction); override;
  public
    constructor Create(AID: integer; AData: TEditData; const AProvider: IGridDataProvider;
      AIndex: Integer);
  end;


  { TGridDataToGUIFunc }

  TGridDataToGUIFunc = class(TDesignComponentFunc)
  private
    fProvider: IGridDataProvider;
    fIndexes: array of Integer;
    fData: TGridData;
    function Between(const ANumber, ALower, AUpper: Integer): Boolean;
    function MoveProvider(ADelta: Integer): Integer;
    function ReadRows: Integer;
    procedure ReadDataRow(ARow: Integer);
    procedure ClearDataRow(ARow: Integer);
    procedure ReadData(const ADeltaMove: Integer);
  protected
    procedure DoExecute(const AAction: IFluxAction); override;
  public
    constructor Create(AID: integer; AData: TGridData; const AProvider: IGridDataProvider;
      AIndexes: array of Integer);
  end;

  { TMoveNextFunc }

  TMoveNextFunc = class(TDesignComponentFunc)
  private
    fProvider: IGridDataProvider;
  protected
    procedure DoExecute(const AAction: IFluxAction); override;
  public
    constructor Create(AID: integer; const AProvider: IGridDataProvider);
  end;

  { TMovePrevFunc }

  TMovePrevFunc = class(TDesignComponentFunc)
  private
    fProvider: IGridDataProvider;
  protected
    procedure DoExecute(const AAction: IFluxAction); override;
  public
    constructor Create(AID: integer; const AProvider: IGridDataProvider);
  end;

implementation

{ TMovePrevFunc }

procedure TMovePrevFunc.DoExecute(const AAction: IFluxAction);
begin
  fProvider.Prev;
end;

constructor TMovePrevFunc.Create(AID: integer;
  const AProvider: IGridDataProvider);
begin
  inherited Create(AID);
  fProvider := AProvider;
end;

{ TMoveNextFunc }

procedure TMoveNextFunc.DoExecute(const AAction: IFluxAction);
begin
  fProvider.Next;
end;

constructor TMoveNextFunc.Create(AID: integer;
  const AProvider: IGridDataProvider);
begin
  inherited Create(AID);
  fProvider := AProvider;
end;

{ TGridDataToGUIFunc }

function TGridDataToGUIFunc.Between(const ANumber, ALower, AUpper: Integer): Boolean;
begin
  Result := (ANumber >= ALower) and (ANumber <= AUpper);
end;

function TGridDataToGUIFunc.MoveProvider(ADelta: Integer): Integer;
begin
  Result := 0;
  if ADelta > 0 then begin
    while ADelta > 0 do
    begin
      if not fProvider.Next then
        Break;
      Inc(Result);
      Dec(ADelta);
    end;
  end else begin
    while ADelta < 0 do
    begin
      if not fProvider.Prev then
        Break;
      Inc(Result);
      Inc(ADelta);
    end;
  end;
end;

function TGridDataToGUIFunc.ReadRows: Integer;
var
  i: integer;
begin
  i := 0;
  Result := -1;
  if not fProvider.IsEmpty then begin
    Result := 0;
    repeat
      ReadDataRow(i);
      Inc(i);
      Inc(Result);
    until (i > fData.RowCount - 1) or not fProvider.Next;
  end;
  while i <= fData.RowCount - 1 do begin
    ClearDataRow(i);
    Inc(i);
  end;
end;

procedure TGridDataToGUIFunc.ReadDataRow(ARow: Integer);
var
  i: integer;
begin
  for i := 0 to fData.ColCount - 1 do
    fData.Value[ARow, i] := fProvider[fIndexes[i]];
end;

procedure TGridDataToGUIFunc.ClearDataRow(ARow: Integer);
var
  i: integer;
begin
  for i := 0 to fData.ColCount - 1 do
    fData.Value[ARow, i] := '';
end;

procedure TGridDataToGUIFunc.ReadData(const ADeltaMove: Integer);
var
  mBookmark: IInterface;
  mMovedRows: Integer;
begin
  mBookmark := fProvider.NewBookmark;
  try
    if fData.DataRow = -1 then begin
      if not fProvider.IsEmpty then begin
        fData.LastDataRow := ReadRows;
        fData.DataRow := 0;
      end;
    end
    else if Between(fData.DataRow + ADeltaMove, 0, fData.RowCount - 1) then begin
      fData.DataRow := fData.DataRow + ADeltaMove;
    end
    else begin
      mMovedRows := MoveProvider(-fData.DataRow);
      fData.DataRow := mMovedRows;
      fData.LastDataRow := ReadRows;
    end;
    fData.CurrentRow := fData.DataRow;
  finally
    fProvider.GotoBookmark(mBookmark);
  end;
end;

procedure TGridDataToGUIFunc.DoExecute(const AAction: IFluxAction);
begin
  fProvider.Silent := True;
  try
    ReadData(AAction.Props.AsInt('deltamove'));
  finally
    fProvider.Silent := False;
  end;
end;

constructor TGridDataToGUIFunc.Create(AID: integer; AData: TGridData;
  const AProvider: IGridDataProvider; AIndexes: array of Integer);
begin
  inherited Create(AID);
  fData := AData;
  fProvider := AProvider;
  fIndexes := Copy(AIndexes);
end;

{ TDataToGUIFunc }

procedure TDataToGUIFunc.DoExecute(const AAction: IFluxAction);
begin
  fData.Text := fProvider.Value[fProviderIndex];
end;

constructor TDataToGUIFunc.Create(AID: integer; AData: TEditData; const AProvider: IGridDataProvider;
  AIndex: Integer);
begin
  inherited Create(AID);
  fData := AData;
  fProvider := AProvider;
  fProviderIndex := AIndex;
end;

{ TTestTextChangedFunc }

procedure TTestTextChangedFunc.DoExecute(const AAction: IFluxAction);
begin
  ShowMessage('text changed');
end;

{ TTestKeyDownFunc }

procedure TTestKeyDownFunc.DoExecute(const AAction: IFluxAction);
begin
  ShowMessage('key down');
end;

{ THelloButtonClickFunc }

procedure THelloButtonClickFunc.DoExecute(const AAction: IFluxAction);
begin
  ShowMessage('Hello');
end;

end.

