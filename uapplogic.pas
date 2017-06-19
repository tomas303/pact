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
  protected
    function NewNotifier(const AActionID: integer): IAppNotifier;
    function NewElement: IMetaElement;
  protected
    fMainForm: IProps;
    procedure AppStoreChanged(const AAppState: IAppState);
  published
    property Factory: IDIFactory read fFactory write FFactory;
    property React: IReact read fReact write fReact;
    property AppStore: IAppStore read fAppStore write fAppStore;
  end;

implementation

{ TAppLogic }

procedure TAppLogic.StartUp;
var
  mAction: IAppAction;
begin
  fMainForm := IProps(Factory.Locate(IProps));
  {
  fMainForm
    .SetInt('Left', 500)
    .SetInt('Top', 30)
    .SetInt('Width', 500)
    .SetInt('Height', 300);

}
  AppStore.Add(@AppStoreChanged);

  mAction := IAppAction(Factory.Locate(IAppAction, '', TProps.New.SetInt('ID', cInitFunc)));
  (AppStore as IAppDispatcher).Dispatch(mAction);

  React.Render(NewElement);

end;

procedure TAppLogic.ShutDown;
begin
  AppStore.Remove(@AppStoreChanged);
end;

function TAppLogic.NewNotifier(const AActionID: integer): IAppNotifier;
begin
  Result := IAppNotifier(Factory.Locate(IAppNotifier, '', TProps.New.SetInt('ActionID', AActionID)));
end;

function TAppLogic.NewElement: IMetaElement;
begin
  Result := React.CreateElement(
        IUIFormBit,
        TProps.New
        .SetStr('Title', 'Hello world')
        .SetInt('Left', fMainForm.AsInt('Left'))
        .SetInt('Top', fMainForm.AsInt('Top'))
        .SetInt('Width', fMainForm.AsInt('Width'))
        .SetInt('Height', fMainForm.AsInt('Height'))
        .SetInt('Layout', 0)
        .SetIntf('ResizeNotifier', NewNotifier(cResizeFunc)),
        [
        React.CreateElement(
          IUITextBit,
          TProps.New.SetStr('Text', 'Hello:').SetInt('MMWidth', 100).SetInt('MMHeight', 25).SetInt('Color', clGreen).SetInt('Place', 1)),
         React.CreateElement(
           IUIEditBit,
           TProps.New.SetStr('Text', 'Ufff').SetInt('MMWidth', 100).SetInt('MMHeight', 25).SetInt('Place', 3))
        ])
end;

procedure TAppLogic.AppStoreChanged(const AAppState: IAppState);
begin
  if not (AAppState as IPactState).MainForm.Equals(fMainForm) then begin
    fMainForm := (AAppState as IPactState).MainForm.Clone;
    React.Render(NewElement);
  end;
end;

end.

