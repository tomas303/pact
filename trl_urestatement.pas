unit trl_urestatement;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, trl_irestatement;

type

  { TRestatement }

  TRestatement = class(TInterfacedObject, IRestatement)
  protected
    fMulti, fDivid: integer;
  protected
    // IRestatement
    function GetDivid: integer;
    function GetMulti: integer;
    procedure SetDivid(AValue: integer);
    procedure SetMulti(AValue: integer);
    function Restate(const ASize: integer): integer;
  published
    property Multi: integer read GetMulti write SetMulti;
    property Divid: integer read GetDivid write SetDivid;
  public
    procedure AfterConstruction; override;
  end;

implementation

{ TRestatement }

function TRestatement.GetDivid: integer;
begin
  Result := fDivid;
end;

function TRestatement.GetMulti: integer;
begin
  Result := fMulti;
end;

procedure TRestatement.SetDivid(AValue: integer);
begin
  fDivid := AValue;
end;

procedure TRestatement.SetMulti(AValue: integer);
begin
  fMulti := AValue;
end;

function TRestatement.Restate(const ASize: integer): integer;
begin
  Result := Round(ASize * Multi / Divid);
end;

procedure TRestatement.AfterConstruction;
begin
  inherited AfterConstruction;
  Multi := 1;
  Divid := 1;
end;

end.

