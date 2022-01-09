unit uappdata;

{$mode ObjFPC}{$H+}

interface

uses
  sysutils, rea_idesigncomponent;

type

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

end.

