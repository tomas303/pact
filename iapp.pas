unit iapp;

{$mode objfpc}{$H+}

interface

uses
  typinfo, flu_iflux, trl_iprops, trl_uprops, trl_irttibroker, trl_urttibroker,
  sysutils, trl_igenericaccess, rdx_urttistate;

type

  { TC }

  TC = class(TObject)
  public
    class function Path: string;
    class function Name: string;
  end;

  MainForm = class(TC)
  public type
    Width = class(TC);
    Height = class(TC);
  end;

  Layout = class(TC)
  public type
    Perspective = class(TC);
  end;

  cActions = class
  public const
    InitFunc = 0;
    ResizeFunc = 1;
    HelloFunc = 2;
    ClickOne = 3;
    ClickTwo = 4;
    ClickThree = 5;
  end;

implementation

{ TC }

class function TC.Path: string;
begin
  Result := ClassName;
end;

class function TC.Name: string;
var
  mInfo: PTypeInfo;
begin
  mInfo := ClassInfo;
  Result := mInfo^.Name;
end;

initialization

end.

