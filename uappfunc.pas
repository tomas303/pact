unit uappfunc;

{$mode objfpc}{$H+}

interface

uses
  uappdata, flu_iflux, rea_idesigncomponent, rea_irenderer,
  forms, trl_imetaelement, trl_iExecutor;

type

  { TSizeFunc }

  TSizeFunc = class(TInterfacedObject, IFluxFunc)
  private
    fID: integer;
    fData: TFormData;
    fNotifier: IFluxNotifier;
  protected
    procedure Execute(const AAction: IFluxAction);
    function GetID: integer;
  public
    constructor Create(AID: integer; AData: TFormData; ANotifier: IFluxNotifier);
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

implementation

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
     fNotifier.Notify;
end;

function TSizeFunc.GetID: integer;
begin
  Result := fID;
end;

constructor TSizeFunc.Create(AID: integer; AData: TFormData; ANotifier: IFluxNotifier);
begin
  inherited Create;
  fID := AID;
  fData := AData;
  fNotifier := ANotifier;
end;

end.

