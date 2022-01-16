unit uappfunc;

{$mode objfpc}{$H+}

interface

uses
  rea_udesigncomponentfunc, Dialogs, flu_iflux;

type

 { THelloButtonClickFunc }

 THelloButtonClickFunc = class(TDesignComponentFunc)
  private
  protected
    procedure DoExecute(const AAction: IFluxAction); override;
  public
    constructor Create(AID: integer);
  end;

implementation

{ THelloButtonClickFunc }

procedure THelloButtonClickFunc.DoExecute(const AAction: IFluxAction);
begin
  ShowMessage('Hello');
end;

constructor THelloButtonClickFunc.Create(AID: integer);
begin
  inherited Create(AID);
end;

end.

