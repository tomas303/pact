unit uapplogic;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, iapp, rea_ireact, rea_iredux, iuibits, trl_uprops, graphics,
  trl_idifactory, trl_iprops;

type

  { TAppLogic }

  TAppLogic = class(TInterfacedObject, IAppLogic)
  protected
    // IAppLogic
    procedure StartUp;
    procedure ShutDown;
  protected
    fFactory: IDIFactory;
    fReact: IReact;
    fAppStore: IAppStore;
    fElFactory: IMetaElementFactory;
  protected
    function NewNotifier(const AActionID: integer): IAppNotifier;
    function NewMapper: IMapStateToProps;
    function NewElement: IMetaElement;
    function NewElement1: IMetaElement;
  protected
    procedure AppStoreChanged(const AAppState: IAppState);
  published
    property Factory: IDIFactory read fFactory write FFactory;
    property React: IReact read fReact write fReact;
    property AppStore: IAppStore read fAppStore write fAppStore;
    property ElFactory: IMetaElementFactory read fElFactory write fElFactory;
  end;

implementation

{ TAppLogic }

procedure TAppLogic.StartUp;
var
  mAction: IAppAction;
begin
  AppStore.Add(@AppStoreChanged);
  mAction := IAppAction(Factory.Locate(IAppAction, '', TProps.New.SetInt('ID', cActions.InitFunc)));
  (AppStore as IAppDispatcher).Dispatch(mAction);

  // it maybe not totally clear - these are metada for create object, so when I inject
  // instance(like bellow) all constructed object will share it ... will be the same
  // (in case they have public property to inject). On other hand when inject guid, then
  // for each target injection new object will be constructed .....so use with care and
  // better to  start to document it.
  React.Render(
    ElFactory.CreateElement(IAppComposite,
      TProps.New
      .SetIntf('ResizeNotifier', NewNotifier(cActions.ResizeFunc))
      .SetIntf('MapStateToProps',NewMapper
        .AddPath(cAppState.MainForm, TStringArray.Create(
          cAppState.Left, cAppState.Top, cAppState.Width, cAppState.Height)))
     )
  );
end;

procedure TAppLogic.ShutDown;
begin
  AppStore.Remove(@AppStoreChanged);
end;

function TAppLogic.NewNotifier(const AActionID: integer): IAppNotifier;
begin
  Result := IAppNotifier(Factory.Locate(IAppNotifier, '', TProps.New.SetInt('ActionID', AActionID)));
end;

function TAppLogic.NewMapper: IMapStateToProps;
begin
  // later with props property .... will map names from it automaticly
  Result := IMapStateToProps(Factory.Locate(IMapStateToProps, ''));
end;

function TAppLogic.NewElement: IMetaElement;
begin
  Result := ElFactory.CreateElement(
        IUIFormBit,
        TProps.New
        .SetStr('Title', 'Hello world')
        .SetInt('Left', 10)
        .SetInt('Top', 10)
        .SetInt('Width', 300)
        .SetInt('Height', 200)
        .SetInt('Layout', 0)
        .SetIntf('ResizeNotifier', NewNotifier(cActions.ResizeFunc)),
        [
        ElFactory.CreateElement(
          IUITextBit,
          TProps.New.SetStr('Text', 'Hello:').SetInt('MMWidth', 100).SetInt('MMHeight', 25).SetInt('Color', clGreen).SetInt('Place', 1)),

        ElFactory.CreateElement(
            IUIButtonBit,
            TProps.New.SetStr('Caption', 'ClickMe').SetInt('MMWidth', 100).SetInt('MMHeight', 25).SetIntf('ClickNotifier', NewNotifier(cActions.HelloFunc))),

        ElFactory.CreateElement(
           IUIEditBit,
           TProps.New.SetStr('Text', 'Ufff').SetInt('MMWidth', 100).SetInt('MMHeight', 25).SetInt('Place', 3))
        ]
        )
end;

function TAppLogic.NewElement1: IMetaElement;
begin
  Result := ElFactory.CreateElement(
        IFormComposite,
        TProps.New
        .SetStr('Title', 'Hello world')
        //.SetInt('Left', 10)
        //.SetInt('Top', 10)
        //.SetInt('Width', 300)
        //.SetInt('Height', 200)
        .SetInt('Layout', 0)
        .SetIntf('ResizeNotifier', NewNotifier(cActions.ResizeFunc))
        .SetIntf('MapStateToProps',NewMapper
          .AddPath(cAppState.MainForm, TStringArray.Create(cAppState.Left, cAppState.Top, cAppState.Width, cAppState.Height)))
        ,
        [
        ElFactory.CreateElement(
          IUITextBit,
          TProps.New.SetStr('Text', 'Hello:').SetInt('MMWidth', 100).SetInt('MMHeight', 25).SetInt('Color', clGreen).SetInt('Place', 1)),

        ElFactory.CreateElement(
            IUIButtonBit,
            TProps.New.SetStr('Caption', 'ClickMe').SetInt('MMWidth', 100).SetInt('MMHeight', 25).SetIntf('ClickNotifier', NewNotifier(cActions.HelloFunc))),

        ElFactory.CreateElement(
           IUIEditBit,
           TProps.New.SetStr('Text', 'Ufff').SetInt('MMWidth', 100).SetInt('MMHeight', 25).SetInt('Place', 3))
        ]
  );
end;

procedure TAppLogic.AppStoreChanged(const AAppState: IAppState);
begin
  // for now synchronous change, what all will be rendered will be decided by
  // react componenets itself
  React.Rerender;
end;

end.

