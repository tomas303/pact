unit uappfunc;

{$mode objfpc}{$H+}

interface

uses
  uappdata, flu_iflux, rea_idesigncomponent, rea_udesigncomponent,
  rea_irenderer,
  forms, trl_imetaelement, trl_iExecutor, LCLType;

type

  { TSizeFunc }

  TSizeFunc = class(TInterfacedObject, IFluxFunc)
  private
    fID: integer;
    fData: TFormData;
    fRenderNotifier: IFluxNotifier;
  protected
    procedure Execute(const AAction: IFluxAction);
    function GetID: integer;
  public
    constructor Create(AID: integer; AData: TFormData; ARenderNotifier: IFluxNotifier);
  end;

  { TMoveFunc }

  TMoveFunc = class(TInterfacedObject, IFluxFunc)
  private
    fID: integer;
    fData: TFormData;
  protected
    procedure Execute(const AAction: IFluxAction);
    function GetID: integer;
  public
    constructor Create(AID: integer; AData: TFormData);
  end;

  { TRenderGUIFunc }

  TRenderGUIFunc = class(TInterfacedObject, IFluxFunc)
  private
    fID: integer;
    fGUI: IDesignComponentApp;
    fRenderer: IRenderer;
  protected
    procedure Execute(const AAction: IFluxAction);
    function GetID: integer;
  public
    constructor Create(AID: integer; AGUI: IDesignComponentApp; ARenderer: IRenderer);
  end;

  { TProcessMessagesFunc }

  TProcessMessagesFunc = class(TInterfacedObject, IFluxFunc)
  private
    fID: integer;
    fProcessMessages: IFluxNotifier;
  protected
    procedure Execute(const AAction: IFluxAction);
    function GetID: integer;
  public
    constructor Create(AID: integer; AProcessMessages: IFluxNotifier);
  end;

  { TCloseQueryFunc }

  TCloseQueryFunc = class(TInterfacedObject, IFluxFunc)
  private
    fID: integer;
  protected
    procedure Execute(const AAction: IFluxAction);
    function GetID: integer;
  public
    constructor Create(AID: integer);
  end;

  { TGridFunc }

  TGridFunc = class(TInterfacedObject, IFluxFunc)
  private
    fID: integer;
    fRenderNotifier: IFluxNotifier;
  protected
    procedure Execute(const AAction: IFluxAction);
    procedure DoExecute(const AAction: IFluxAction); virtual; abstract;
    function GetID: integer;
  protected
    fData: TGridData;
  public
    constructor Create(AID: integer; const AData: TGridData; const ARenderNotifier: IFluxNotifier);
  end;

  { TGridEdTextChangedFunc }

  TGridEdTextChangedFunc = class(TGridFunc)
  protected
    procedure DoExecute(const AAction: IFluxAction); override;
  end;


  { TGridEdKeyDownFunc }

  TGridEdKeyDownFunc = class(TGridFunc)
  protected
    procedure DoExecute(const AAction: IFluxAction); override;
  end;

  { TextChangedFunc }

  TextChangedFunc = class(TInterfacedObject, IFluxFunc)
  private
    fID: integer;
    fData: TEditData;
  protected
    procedure Execute(const AAction: IFluxAction);
    function GetID: integer;
  public
    constructor Create(AID: integer; AData: TEditData);
  end;


implementation

{ TextChangedFunc }

procedure TextChangedFunc.Execute(const AAction: IFluxAction);
begin
  fData.Text := AAction.Props.AsStr('Text');
end;

function TextChangedFunc.GetID: integer;
begin
  Result := fID;
end;

constructor TextChangedFunc.Create(AID: integer; AData: TEditData);
begin
  fID := AID;
  fData := AData;
end;

{ TGridEdKeyDownFunc }

procedure TGridEdKeyDownFunc.DoExecute(const AAction: IFluxAction);
begin
  case AAction.Props.AsInt('CharCode') of
    VK_ESCAPE:
      fData.BrowseMode := True;
    VK_RETURN:
      fData.BrowseMode := False;
    VK_LEFT:
      if fData.BrowseMode and (fData.CurrentCol > 0) then begin
        fData.CurrentCol := fData.CurrentCol - 1;
        fRenderNotifier.Notify;
      end;
    VK_RIGHT:
      if fData.BrowseMode and (fData.CurrentCol < fData.ColCount - 1) then begin
        fData.CurrentCol := fData.CurrentCol + 1;
        fRenderNotifier.Notify;
      end;
    VK_UP:
      if fData.BrowseMode and (fData.CurrentRow > 0) then begin
        fData.CurrentRow := fData.CurrentRow - 1;
        fRenderNotifier.Notify;
      end;
    VK_DOWN:
      if fData.BrowseMode and (fData.CurrentRow < fData.RowCount - 1) then begin
        fData.CurrentRow := fData.CurrentRow + 1;
        fRenderNotifier.Notify;
      end;
  end;
end;

{ TGridEdTextChangedFunc }

procedure TGridEdTextChangedFunc.DoExecute(const AAction: IFluxAction);
begin
  fData.EditData.Text := AAction.Props.AsStr('Text');
  fData[fData.CurrentRow, fData.CurrentCol] := AAction.Props.AsStr('Text');
end;

{ TGridFunc }

procedure TGridFunc.Execute(const AAction: IFluxAction);
begin
  DoExecute(AAction);
end;

function TGridFunc.GetID: integer;
begin
  Result := fID;
end;

constructor TGridFunc.Create(AID: integer; const AData: TGridData; const ARenderNotifier: IFluxNotifier);
begin
  fID := AID;
  fData := AData;
  fRenderNotifier := ARenderNotifier;
end;

{ TCloseQueryFunc }

procedure TCloseQueryFunc.Execute(const AAction: IFluxAction);
begin
  raise EExecutorStop.Create('');
end;

function TCloseQueryFunc.GetID: integer;
begin
  Result := fID;
end;

constructor TCloseQueryFunc.Create(AID: integer);
begin
  inherited Create;
  fID := AID;
end;

{ TProcessMessagesFunc }

procedure TProcessMessagesFunc.Execute(const AAction: IFluxAction);
begin
  Application.ProcessMessages;
  fProcessMessages.Notify;
end;

function TProcessMessagesFunc.GetID: integer;
begin
  Result := fID;
end;

constructor TProcessMessagesFunc.Create(AID: integer; AProcessMessages: IFluxNotifier);
begin
  inherited Create;
  fID := AID;
  fProcessMessages := AProcessMessages;
end;

{ TRenderGUIFunc }

procedure TRenderGUIFunc.Execute(const AAction: IFluxAction);
var
  mEl: IMetaElement;
begin
  mEl := fGUI.Compose(nil, []);
  fRenderer.Render(mEl);
end;

function TRenderGUIFunc.GetID: integer;
begin
  Result := fID;
end;

constructor TRenderGUIFunc.Create(AID: integer; AGUI: IDesignComponentApp; ARenderer: IRenderer);
begin
  inherited Create;
  fID := AID;
  fGUI := AGUI;
  fRenderer := ARenderer;
end;

{ TMoveFunc }

procedure TMoveFunc.Execute(const AAction: IFluxAction);
begin
  fData.Left := AAction.Props.AsInt(cProps.MMLeft);
  fData.Top := AAction.Props.AsInt(cProps.MMTop);
end;

function TMoveFunc.GetID: integer;
begin
  Result := fID;
end;

constructor TMoveFunc.Create(AID: integer; AData: TFormData);
begin
  inherited Create;
  fID := AID;
  fData := AData;
end;

{ TSizeFunc }

procedure TSizeFunc.Execute(const AAction: IFluxAction);
var
  mChange: Boolean;
begin
  mChange := False;
  if fData.Width <> AAction.Props.AsInt(cProps.MMWidth) then begin
    fData.Width := AAction.Props.AsInt(cProps.MMWidth);
    mChange := True;
  end;
  if fData.Height <> AAction.Props.AsInt(cProps.MMHeight) then begin
    fData.Height := AAction.Props.AsInt(cProps.MMHeight);
    mChange := True;
  end;
  if mChange then
     fRenderNotifier.Notify;
end;

function TSizeFunc.GetID: integer;
begin
  Result := fID;
end;

constructor TSizeFunc.Create(AID: integer; AData: TFormData; ARenderNotifier: IFluxNotifier);
begin
  inherited Create;
  fID := AID;
  fData := AData;
  fRenderNotifier := ARenderNotifier;
end;

end.

