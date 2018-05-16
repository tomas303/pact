unit uappstate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, rdx_urttistate;

type

  { TLayout }

  TLayout = class(TRttiState)
  protected
    fPerspective: integer;
  published
    property Perspective: integer read fPerspective write fPerspective;
  end;

  { TMainForm }

  TMainForm = class(TRttiState)
  protected
    fWidth: integer;
    fHeight: integer;
  published
    property Width: integer read fWidth write fWidth;
    property Height: integer read fHeight write fHeight;
  end;


implementation

end.

