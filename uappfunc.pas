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

