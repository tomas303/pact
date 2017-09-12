unit fmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  test, tal_ilauncher, iuibits, trl_iprops, trl_uprops,
  rea_ireact, trl_ilog, trl_itree, uuibits, rea_iuilayout;

type

  { TForm1 }

  TForm1 = class(TForm, IMainForm, IUINotifier)
    Button1: TButton;
    btnHelloWorld: TButton;
    btnPerspective: TButton;
    procedure btnHelloWorldClick(Sender: TObject);
    procedure btnPerspectiveClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  protected type
    t2ar = array[0..1] of variant;
  protected
    procedure kvik(a: array of t2ar);
    procedure testkvik;
  protected
    fPerspective: integer;
    function NewPerspective(APerspective: integer; ALeft, ATop, AWidth, AHeight: integer): IMetaElement;
  protected
    //IMainForm = interface
    procedure StartUp;
    procedure ShutDown;
  protected
    // IUINotifier
    procedure Notify(const AProps: IProps);
    procedure Add(const AEvent: IUINotifyEvent);
    procedure Remove(const AEvent: IUINotifyEvent);
  protected
    fReact: IReact;
    procedure ReactFormResize(const AProps: IProps);
  published
    property React: IReact read fReact write fReact;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
const
  cg: TGUID = '{FB31C9D0-80B2-4760-9EDE-52E503F0B667}';
  cg2: TGUID = '{08B0B7B2-7063-4D15-9D98-C6A98E8FAD4C}';
var
  mProps: IProps;
  m1: string;
  m2: integer;
  m3: Boolean;
  m4: TGuid;
  mR: IReact;
begin
  //mProps := TProps.Create;
  //
  //mProps
  //.SetStr('c1', 'val')
  //.SetInt('c2', 100)
  //.SetBool('c3', true)
  //.SetGuid('c4', cg)
  //.SetStr('c1', 'val1')
  //.SetInt('c2', 1001)
  //.SetBool('c3', false)
  //.SetGuid('c4', cg2);
  //
  //m1 := mProps.AsStr('c1');
  //m2 := mProps.AsInt('c2');
  //m3 := mProps.AsBool('c3');
  //m4 := mProps.AsGuid('c4');
  //
  //
  //
  //mR.CreateElement(IUIStripBit,
  //  TProps.New.SetInt('color', clGray).SetInt('width', 5),
  //  [
  //    mR.CreateElement(IUITextBit, TProps.New.SetStr('text', 'password:'), []),
  //    mR.CreateElement(IUIEditBit, TProps.New.SetStr('pwdchar', '*'), [])
  //  ]);
  //
  //mR.CreateElement(IUIStripBit,
  //  TProps.New.SetInt('color', clGray).SetInt('width', 5),
  //  [
  //    mR.CreateElement(IUITextBit, TProps.New.SetStr('text', 'password:')),
  //    mR.CreateElement(IUIEditBit, TProps.New.SetStr('pwdchar', '*')),
  //    mR.CreateElement(IUITextBit, TProps.New.SetIt('bottom'))
  //  ]);
  //
  //mR.CreateElement(
  //  IUIFormBit, nil,
  //    [
  //      mR.CreateElement(IUITextBit, TProps.New.SetStr('text', 'Hello world'))
  //    ]);
  //
  //mR.CreateElement(IUIFormBit, TProps.New.SetStr('text', 'Hello world'));
  ////podle elementu vytvorit IUI objekt - ten vytvori form a binder a zobrazi
  //// co za metodu taky Render? v podstate (do)vytvorit / aktualizovat obsah
  //
end;

procedure TForm1.kvik(a: array of t2ar);
begin

end;

procedure TForm1.testkvik;
begin
  //kvik([[], []]);
end;

function TForm1.NewPerspective(APerspective: integer; ALeft, ATop, AWidth, AHeight: integer): IMetaElement;
var
  i: integer;
begin
  //{
  //??? ReactFormResize je udalost
  //property ReactFormResize naprimo ... to asi pujde, ale nejspis k tomu neni podpora v di
  //uvazoval bych jen o bez or only sender .... mozna s prechodem na props
  //or
  //INotifier .... metoda Notify ....to je dobre k tomu, ze tam muzu pichnout 7
  // }
  //Result :=
  //  React.CreateElement(
  //    IUIFormBit,
  //    TProps.New
  //    .SetStr('Title', 'Hello world')
  //    .SetInt('Left', ALeft)
  //    .SetInt('Top', ATop)
  //    .SetInt('Width', AWidth)
  //    .SetInt('Height', AHeight)
  //    .SetInt('Layout', 0)
  //    .SetIntf('ResizeNotifier', Self as IUINotifier)
  //    );
  //
  //(Result as INode).AddChild(
  //  React.CreateElement(
  //      IUITextBit,
  //      TProps.New.SetStr('Text', 'Hellou:').SetInt('MMWidth', 100).SetInt('MMHeight', 25).SetInt('Color', clGreen).SetInt('Place', 1))
  //    as INode);
  //
  //if APerspective = 1 then
  //begin
  //for i:=1 to 10 do begin
  //(Result as INode).AddChild(
  //  React.CreateElement(
  //      IUITextBit,
  //      TProps.New.SetStr('Text', 'Hellou:').SetInt('MMWidth', 100).SetInt('MMHeight', 25).SetInt('Color', clRed).SetInt('Place', 2))
  //    as INode);
  //end;
  //end;
  //
  //(Result as INode).AddChild(
  //  React.CreateElement(
  //      IUIEditBit,
  //      TProps.New.SetStr('Text', 'Hello').SetInt('MMWidth', 100).SetInt('MMHeight', 25).SetInt('Place', 3))
  //    as INode);
  //
end;

procedure TForm1.btnHelloWorldClick(Sender: TObject);
begin
{
  mProps := TProps.New
    .SetInt('Layout', uiLayoutHorizontal)
    .SetInt('Place', uiPlaceElastic)
    .SetInt('HFactor', 1)
    .SetInt('VFactor', 1)
    .SetInt('Left', 0)
    .SetInt('Top', 0)
    .SetInt('Width', 0)
    .SetInt('Height', 0)
}

  //React.Render(
  //  React.CreateElement(
  //    IUIFormBit,
  //    TProps.New.SetStr('Title', 'Hello world').SetInt('Left', 500).SetInt('Top', 30).SetInt('Width', 500).SetInt('Height', 300).SetInt('Layout', 0),
  //    [
  //    React.CreateElement(
  //      IUITextBit,
  //      TProps.New.SetStr('Text', 'Hellou:').SetInt('MMWidth', 100).SetInt('MMHeight', 25).SetInt('Color', clGreen).SetInt('Place', 1)),
  //    React.CreateElement(
  //      IUITextBit,
  //      TProps.New.SetStr('Text', 'Hellou:').SetInt('MMWidth', 100).SetInt('MMHeight', 25).SetInt('Color', clRed).SetInt('Place', 2))
  //
  //      ,
  //     React.CreateElement(
  //       IUIEditBit,
  //       TProps.New.SetStr('Text', 'Hello').SetInt('MMWidth', 100).SetInt('MMHeight', 25).SetInt('Place', 3))
  //
  //    ])
  //);
end;

procedure TForm1.btnPerspectiveClick(Sender: TObject);
begin
  case fPerspective of
    0: fPerspective := 1;
  else
    fPerspective := 0;
  end;
  React.Render(NewPerspective(fPerspective, 10, 10, 1500, 300));
end;

procedure TForm1.StartUp;
begin
end;

procedure TForm1.ShutDown;
begin
end;

procedure TForm1.Notify(const AProps: IProps);
begin
end;

procedure TForm1.Add(const AEvent: IUINotifyEvent);
begin
end;

procedure TForm1.Remove(const AEvent: IUINotifyEvent);
begin
end;

procedure TForm1.ReactFormResize(const AProps: IProps);
begin
  React.Render(NewPerspective(fPerspective,
  AProps.AsInt('Left'),
  AProps.AsInt('Top'),
  AProps.AsInt('Width'),
  AProps.AsInt('Height')
  ));
end;

end.

