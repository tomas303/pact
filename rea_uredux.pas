unit rea_uredux;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, rea_iredux, fgl, trl_idifactory, trl_iprops;

type

  { TAppStore }

  TAppStore = class(TInterfacedObject, IAppStore, IAppDispatcher)
  protected type
    TEvents = specialize TFPGList<TAppStoreEvent>;
  protected
    fEvents: TEvents;
  protected
    // IAppDispatcher
    procedure Dispatch(const AAppAction: IAppAction);
    // IAppStore
    procedure Add(const AEvent: TAppStoreEvent);
    procedure Remove(const AEvent: TAppStoreEvent);
  protected
    fAppState: IAppState;
    fAppFunc: IAppFunc;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  published
    property AppState: IAppState read fAppState write fAppState;
    property AppFunc: IAppFunc read fAppFunc write fAppFunc;
  end;

  { TAppAction }

  TAppAction = class(TInterfacedObject, IAppAction)
  protected
    fID: integer;
    fProps: IProps;
  protected
    //IAppAction
    function GetID: integer;
    function GetProps: IProps;
  published
    property ID: integer read GetID write fID;
    property Props: IProps read GetProps write fProps;
  end;

  { TAppNotifier }

  {
    Props are collected via notifying, action is generated based on it and
    dispatch by dispatcher
  }
  TAppNotifier = class(TInterfacedObject, IAppNotifier)
  protected type
    TEvents = specialize TFPGList<TAppNotifierEvent>;
  protected
    fEvents: TEvents;
  protected
    //IAppNotifier
    procedure Notify;
    procedure Add(const AEvent: TAppNotifierEvent);
    procedure Remove(const AEvent: TAppNotifierEvent);
    function GetEnabled: Boolean;
    procedure SetEnabled(AValue: Boolean);
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  protected
    fActionID: integer;
    fFactory: IDIFactory;
    fDispatcher: IAppDispatcher;
    fEnabled: Boolean;
  published
    property ActionID: integer read fActionID write fActionID;
    property Factory: IDIFactory read fFactory write fFactory;
    property Dispatcher: IAppDispatcher read fDispatcher write fDispatcher;
    property Enabled: Boolean read GetEnabled write SetEnabled;
  end;

  { TMapStateToProps }

  TMapStateToProps = class(TInterfacedObject, IMapStateToProps)
  protected type
    TItem = class(TObject)
    protected
      fPath: string;
      fKeys: TStringArray;
      function GetKey(AIndex: integer): string;
      function GetKeyCount: integer;
    public
      constructor Create(const APath: string; AKeys: TStringArray);
      property Path: string read fPath;
      property KeyCount: integer read GetKeyCount;
      property Key[AIndex: integer]: string read GetKey;
    end;
  protected type
    TItems = specialize TFPGObjectList<TItem>;
  protected
    fItems: TItems;
    fKeys: TStringList;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  protected
    // IMapStateToProps
    function Map(const AProps: IProps): IProps;
    function AddPath(const APath: string; AKeys: TStringArray): IMapStateToProps;
  protected
    fAppState: IAppState;
    procedure SetAddKey(const AKey: string);
  published
    property AppState: IAppState read fAppState write fAppState;
    property AddKey: string write SetAddKey;
  end;

implementation

{ TMapStateToProps.TItem }

function TMapStateToProps.TItem.GetKey(AIndex: integer): string;
begin
  Result := fKeys[AIndex];
end;

function TMapStateToProps.TItem.GetKeyCount: integer;
begin
  Result := Length(fKeys);
end;

constructor TMapStateToProps.TItem.Create(const APath: string;
  AKeys: TStringArray);
begin
  inherited Create;
  fPath := APath;
  fKeys := AKeys;
end;

{ TMapStateToProps }

procedure TMapStateToProps.AfterConstruction;
begin
  inherited AfterConstruction;
  fItems := TItems.Create;
  fKeys := TStringList.Create;
end;

procedure TMapStateToProps.BeforeDestruction;
begin
  FreeAndNil(fItems);
  FreeAndNil(fKeys);
  inherited BeforeDestruction;
end;

function TMapStateToProps.Map(const AProps: IProps): IProps;
var
  mProp, mKeyProp: IProp;
  mItem: TItem;
  mKey: string;
  i: integer;
begin
  Result := AProps.Clone;
  {
  for mItem in fItems do
  begin
    mProp := (AppState as IPropFinder).Find(mItem.Path);
    if  mProp <> nil then begin
      for i := 0 to mItem.KeyCount - 1 do begin
        mKeyProp := (mProp.AsInterface as IPropFinder).Find(mItem.Key[i]);
        if mKeyProp <> nil then begin
          Result.SetProp(mKeyProp.Name, mKeyProp);
        end;
      end;
    end;
  end;
  }
  for mKey in fKeys do
  begin
   mProp := (AppState as IPropFinder).Find(mKey);
   if mProp <> nil then
     Result.SetProp(mProp.Name, mProp);
  end;
end;

function TMapStateToProps.AddPath(const APath: string; AKeys: TStringArray
  ): IMapStateToProps;
begin
  Result := Self;
  fItems.Add(TItem.Create(APath, AKeys));
end;

procedure TMapStateToProps.SetAddKey(const AKey: string);
begin
  if fKeys.IndexOf(AKey) <> -1 then
    raise Exception.CreateFmt('Key %s for map state already added', [AKey]);
  fKeys.Add(AKey);
end;

{ TAppNotifier }

procedure TAppNotifier.Notify;
var
  mProps: IProps;
  mAction: IAppAction;
  mEvent: TAppNotifierEvent;
  m: string;
begin
  if not fEnabled then
    Exit;
  mProps := IProps(Factory.Locate(IProps));
  mProps.SetInt('ID', ActionID);
  mAction := IAppAction(Factory.Locate(IAppAction, '', mProps));
  for mEvent in fEvents do begin
    mEvent(mAction.Props);
  end;
  m := (Dispatcher as TObject).ClassName;
  Dispatcher.Dispatch(mAction);
end;

procedure TAppNotifier.Add(const AEvent: TAppNotifierEvent);
begin
  if fEvents.IndexOf(AEvent) = -1 then
    fEvents.Add(AEvent);
end;

procedure TAppNotifier.Remove(const AEvent: TAppNotifierEvent);
var
  mIndex: integer;
begin
  mIndex := fEvents.IndexOf(AEvent);
  if mIndex <> -1 then
    fEvents.Delete(mIndex);
end;

function TAppNotifier.GetEnabled: Boolean;
begin
  Result := fEnabled;
end;

procedure TAppNotifier.SetEnabled(AValue: Boolean);
begin
  fEnabled := AValue;
end;

procedure TAppNotifier.AfterConstruction;
begin
  inherited AfterConstruction;
  fEvents := TEvents.Create;
end;

procedure TAppNotifier.BeforeDestruction;
begin
  FreeAndNil(fEvents);
  inherited BeforeDestruction;
end;

{ TAppAction }

function TAppAction.GetID: integer;
begin
  Result := fID;
end;

function TAppAction.GetProps: IProps;
begin
  Result := fProps;
end;

{ TAppStore }

procedure TAppStore.Dispatch(const AAppAction: IAppAction);
var
  mEvent: TAppStoreEvent;
begin
  AppState := AppFunc.Redux(AppState, AAppAction);
  if AppState = nil then
    raise Exception.Create('Redux function returned nil instead of AppState');
  for mEvent in fEvents do begin
    mEvent(AppState);
  end;
end;

procedure TAppStore.Add(const AEvent: TAppStoreEvent);
begin
  if fEvents.IndexOf(AEvent) = -1 then
    fEvents.Add(AEvent);
end;

procedure TAppStore.Remove(const AEvent: TAppStoreEvent);
var
  mIndex: integer;
begin
  mIndex := fEvents.IndexOf(AEvent);
  if mIndex <> -1 then
    fEvents.Delete(mIndex);
end;

procedure TAppStore.AfterConstruction;
begin
  inherited AfterConstruction;
  fEvents := TEvents.Create;
end;

procedure TAppStore.BeforeDestruction;
begin
  FreeAndNil(fEvents);
  inherited BeforeDestruction;
end;

end.

