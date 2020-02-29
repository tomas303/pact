unit uappstate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, rdx_urttistate;

type

  { TLayout }

  TLayout = class(TRttiState)
  private
    function GetPerspective: integer;
    procedure SetPerspective(AValue: integer);
  protected
    fPerspective: integer;
  published
    property Perspective: integer read GetPerspective write SetPerspective;
  end;

  { TMainForm }

  TMainForm = class(TRttiState)
  protected
    fLeft: integer;
    fTop: integer;
    fWidth: integer;
    fHeight: integer;
  published
    property Left: integer read fLeft write fLeft;
    property Top: integer read fTop write fTop;
    property Width: integer read fWidth write fWidth;
    property Height: integer read fHeight write fHeight;
  end;


implementation

{ TLayout }

function TLayout.GetPerspective: integer;
begin
  Result := fPerspective;
end;

procedure TLayout.SetPerspective(AValue: integer);
begin
  if fPerspective = AValue then Exit;
  fPerspective := AValue;
end;

end.

