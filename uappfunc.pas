unit uappfunc;

{$mode objfpc}{$H+}

interface

uses
  rea_udesigncomponentfunc, Dialogs, rea_iflux;

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

implementation

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

