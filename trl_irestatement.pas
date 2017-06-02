unit trl_irestatement;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TRestatement }

  IRestatement = interface
  ['{EE27E762-8D64-46EF-B3B8-4F6C1954D8E3}']
    function GetDivid: integer;
    function GetMulti: integer;
    procedure SetDivid(AValue: integer);
    procedure SetMulti(AValue: integer);
    property Multi: integer read GetMulti write SetMulti;
    property Divid: integer read GetDivid write SetDivid;
    function Restate(const ASize: integer): integer;
  end;

implementation

end.

