unit uappstate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, rea_iredux, trl_iprops, iapp;

type

  { TAppState }

  TAppState = class(TInterfacedObject, IAppState, IPactState)
  protected
    fMainForm: IProps;
    function GetMainForm: IProps;
    procedure SetMainForm(AValue: IProps);
  public
    destructor Destroy; override;
  published
    property MainForm: IProps read GetMainForm write SetMainForm;
  end;

implementation

{ TAppState }

function TAppState.GetMainForm: IProps;
begin
  Result := fMainForm;
end;

procedure TAppState.SetMainForm(AValue: IProps);
begin
  fMainForm := AValue;
end;

destructor TAppState.Destroy;
begin
  inherited Destroy;
end;

end.

