unit uappboot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, trl_iprops, iapp, graphics, rea_ilayout,
  trl_imetaelement, trl_imetaelementfactory, trl_idifactory,
  rea_udesigncomponent, rea_idesigncomponent, flu_iflux, trl_igenericaccess,
  forms, rea_ibits, uappdata,
  trl_ilauncher, trl_ilog, trl_iexecutor, trl_ireconciler, rea_irenderer;

type
  IDMainForm = interface
  ['{8B2411AB-A2D0-4C17-929F-38B4C752DD99}']
  end;

  IDNames = interface
  ['{488880BA-591C-4A01-80A0-56A6AD1EDB6F}']
  end;

  { TDesignComponentApp }

  TDesignComponentApp = class(TDesignComponent, IDesignComponentApp)
  private
    function ComposeTest(const AProps: IProps): IMetaElement;
    function ComposeEmpty(const AProps: IProps): IMetaElement;
    function ComposePager(const AProps: IProps): IMetaElement;
    function ComposeLabelEdit(const AProps: IProps): IMetaElement;
  protected
    procedure InitValues; override;
    function FormData: IGenericAccess;
    function FormDataRO: IGenericAccessRO;
    function DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement; override;
  public
    procedure AfterConstruction; override;
  end;

  { TDNames }

  TDNames = class(TDesignComponent, IDNames)
  private
    //fdata : igriddata .... link data here from App
  protected
    function DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement; override;
  end;


  { TLauncher }

  TLauncher = class(TInterfacedObject, ILauncher)
  {


   ???? mozna misto application.run


  }


  protected
    procedure Launch;
  protected
    fLog: ILog;
    fFactory: IDIFactory;
    fFluxFuncReg: IFluxFuncReg;
    fExecutor: IExecutor;
    fReconciler: IReconciler;
    fRenderer: IRenderer;
    fAppComponent: IDesignComponentApp;
  published
    property Log: ILog read fLog write fLog;
    property Factory: IDIFactory read fFactory write FFactory;
    property FluxFuncReg: IFluxFuncReg read fFluxFuncReg write fFluxFuncReg;
    property Executor: IExecutor read fExecutor write fExecutor;
    property Reconciler: IReconciler read fReconciler write fReconciler;
    property Renderer: IRenderer read fRenderer write fRenderer;
    property AppComponent: IDesignComponentApp read fAppComponent write fAppComponent;
  end;

implementation

{ TLauncher }

procedure TLauncher.Launch;
begin
  //Application.Run;
  // run own solution and call inside it ProcessMessages;
  {
  why .... user signal, message will arrive at FluxFuncReg, from here callback directly or to executor
  callback will do ... and mostly signal renderer to refresh gui

  refresh gui ..... to je to hlavni

    AppComponent ... slozena ze subkomponent, ktere kazde ComposeElement IMetaElement
       wanted to refreshe each subcomponent extra

    callback .... take subcompononet.ComposeElement ... and sent it somewhere where
    is physical components, last layout.

    somewhere .... table of ID x node x parentnode
                   bit head
                   elsement head ..... only tree of bits

    when element is composed, it must be tree of bits ... or better say only concrete elements

    somewhere ... so it could be like Renderer instead of old one, logically belongs to rea
       elementa arrives
       is flattened(only physical nodes)
       based on ID  subtree is find and recondiled (so depends how granular it will be)
       (patche applied on elements will be applied on bits )

      ? how do it better


  }



end;

{ TDNames }

function TDNames.DoCompose(const AProps: IProps;
  const AChildren: TMetaElementArray): IMetaElement;
begin
  ElementFactory.CreateElement(IDesignComponentGrid,
    NewProps
      .SetInt('HorizontalCount', 2)
      .SetInt('VerticalCount', 8)
      .SetInt('MMHeight', 1000)
      .SetInt('MMWidth', 1000)
      .SetInt(cProps.RowMMHeight, 25)
      .SetInt(cProps.ColMMWidth, 25)
      .SetInt(cProps.Color, clMaroon)
      .SetInt('LaticeColColor', clRed)
      .SetInt('LaticeColSize', 10)
      .SetInt('LaticeRowColor', clGreen)
      .SetInt('LaticeRowSize', 2)
      //
    );
end;

{ TDesignComponentApp }

function TDesignComponentApp.ComposeTest(const AProps: IProps): IMetaElement;
var
  mProps: IProps;
  mButtons: IProps;
  mButton: IProps;
  mFrames: TMetaElementArray;
  i: integer;
  minfo: string;
  m: string;
  mSMNotifier: IFluxNotifier;
  mOneClickNotifier: IFluxNotifier;
  mNameSaveNotifier: IFluxNotifier;
begin
  m := SelfProps.AsStr(Layout.Perspective.Name);
  minfo := SelfProps.Info;

  {
   tady by se mel Data injektovat .... problem s func, protoze 2 ruzne elementy
   muzou mit 2 ruzne Data ...jak to promitnout do func?
   to by musel byt skutecne parametr poslany pres notifier ... ?????

  }

  //mOneClickNotifier := NewNotifier(cActions.ClickOne, FormData);

  //mSMNotifier := NewNotifier(cActions.ResizeFunc, FormData);

  Result := ElementFactory.CreateElement(
    IDesignComponentForm,
      NewProps
        //.SetIntf(cProps.SizeNotifier, mSMNotifier)
        //.SetIntf(cProps.MoveNotifier, mSMNotifier)
        .SetStr(cProps.Title, 'Hello world')
        .SetInt(cProps.Layout, cLayout.Vertical)
        //.SetIntf('State', NewState(MainForm.Name))
        .SetStr('DataPath', 'mainform')
        //.SetIntf('State', FormDataRO)
        ,
    [

      ElementFactory.CreateElement(IDesignComponentEdit,
        NewProps
          .SetStr(cProps.Title, 'First name')
          .SetStr(cProps.Value, 'john')
          .SetIntf(cProps.ClickNotifier, mNameSaveNotifier)
       ),
       ElementFactory.CreateElement(IDesignComponentEdit,
         NewProps
           .SetStr(cProps.Title, 'Sure name')
           .SetStr(cProps.Value, 'dow')
           .SetIntf(cProps.ClickNotifier, mNameSaveNotifier)
        ),
       ElementFactory.CreateElement(IDesignComponentButton,
        NewProps
          .SetStr('Text', 'One')
          .SetIntf(cProps.ClickNotifier, mNameSaveNotifier)
        ),


      ElementFactory.CreateElement(IDesignComponentEdit,
        NewProps
          .SetStr(cProps.Title, 'First name')
          .SetStr(cProps.Value, 'Kuliferda')
{
          .setdatakey('surname')
          .setdata('surname') ... to bych se musel odkazat na existujici objekt
          tohle je definice, ze ktere muzu vyrobit vic objektu
          instance - bude sdilena vsemi
          definice - vyrobi se nova pro kazde ... transient
          data pro kazdou komponentu jsou OK ... ty se vyrobi oddelene a funguji
          co potrebuju - system, jak je zaregistrovat nekam
          a] kde budou dostupne pro akce ...
          b] kde se dokazi serialozovat a deserializovat(to nemusi uplne byt)

          slovnik db .... klic x data, pomoci klice tam bez problemu pristoupi

          .SetStr(datakey, 'ja/kuliferda'
          .Store - je globalni a jedno ... slovnikove
          pak skutecne potrebuje jen store a klic ... akorat klic subkomponent se musi odpichnout od klice deti
          bude jen connect - bud se zalozi, nebo uz existuje, bude jen jedno stakovym klicem
          jediny problem - pokud omylem napojim ruzne edity na jeden klic, ... jakmile bude
          stejna prop. budou si prepisovat .. da se to nejak zjistit?
          tim, ze to upravim na slovnik tak ano .... connect ji musi vytvorit, pokud existuje, tak je to chyba
          akci staci klic, data si dohleda az je bude potrebovat ... ma jen to globalni store

          Store
          StoreKey

 }



          .SetIntf(cProps.OnTextNotifier, mOneClickNotifier)),
      ElementFactory.CreateElement(IDesignComponentButton,
        NewProps
          .SetStr('Text', 'One')
          .SetIntf(cProps.ClickNotifier, mOneClickNotifier)),
      ElementFactory.CreateElement(IDesignComponentHeader, NewProps.SetInt('Layout', cLayout.Horizontal),
      [
        ElementFactory.CreateElement(IDesignComponentButton,
        NewProps.SetStr('Text', 'Layout 1').SetInt('Place', cPlace.Elastic).SetInt('ActionClick', cActions.ClickOne)),
        ElementFactory.CreateElement(IDesignComponentButton,
        NewProps.SetStr('Text', 'Layout 2').SetInt('Place', cPlace.Elastic).SetInt('ActionClick', cActions.ClickTwo)),
        ElementFactory.CreateElement(IDesignComponentButton,
        NewProps.SetStr('Text', 'Layout 3').SetInt('Place', cPlace.Elastic).SetInt('ActionClick', cActions.ClickThree))
      ]),

      ElementFactory.CreateElement(IDesignComponentHeader, NewProps.SetInt('Layout', cLayout.Vertical),
      [
        ElementFactory.CreateElement(IDesignComponentHeader,
        NewProps
        .SetStr('Title', SelfProps.AsStr(Layout.Perspective.Name))
        .SetInt('Border', 10)
        .SetInt('BorderColor', clRed)
        .SetInt('FontColor', clBlue)
        .SetInt('Color', clLime)
        .SetBool('Transparent', False)
        .SetInt('MMHeight', 50)
        .SetInt('Place', cPlace.FixFront)
        ),

        ElementFactory.CreateElement(IDesignComponentButton,
        NewProps
        .SetStr('Text', 'Three')
        .SetBool('ParentColor', True)
        //.SetInt('MMHeight', 50)
        //.SetInt('Place', cPlace.FixBack)
        .SetInt('Place', cPlace.Elastic)
        ),

        ElementFactory.CreateElement(IDesignComponentButton,
        NewProps
        .SetStr('Text', 'Four')
        .SetBool('ParentColor', True)
        .SetInt('MMHeight', 20)
        //.SetInt('Place', cPlace.FixBack)
        .SetInt('Place', cPlace.Elastic)
        ),

        ElementFactory.CreateElement(IDesignComponentButton,
        NewProps
        .SetStr('Text', 'Five')
        .SetBool('ParentColor', True)
        .SetInt('MMHeight', 50)
        .SetInt('Place', cPlace.FixBack)
        )
      ])

    ]);
end;

function TDesignComponentApp.ComposeEmpty(const AProps: IProps): IMetaElement;
var
  mCQ: IFluxNotifier;
begin
  mCQ := NewNotifier(-303);
  FluxFuncReg.RegisterFunc(TCloseQueryFunc.Create(-303));
  Result := ElementFactory.CreateElement(
      IDesignComponentForm,
        NewProps
          .SetStr('DataPath', 'mainform')
          .SetStr(cProps.Title, 'Hello world')
          .SetIntf(cProps.CloseQueryNotifier, mCQ),
        [
          ElementFactory.CreateElement(IDesignComponentGrid,
          NewProps
            .SetStr('DataPath', 'maingrid')
            .SetInt('HorizontalCount', 3)
            .SetInt('VerticalCount', 8)
            .SetInt('MMHeight', 1000)
            .SetInt('MMWidth', 1000)
            .SetInt(cProps.RowMMHeight, 25)
            .SetInt(cProps.ColMMWidth, 25)
            //.SetInt(cProps.ColOddColor, clLime)
            //.SetInt(cProps.ColEvenColor, clAqua)
            //.SetInt(cProps.RowOddColor, clRed)
            //.SetInt(cProps.RowEvenColor, clYellow)
            .SetInt(cProps.Color, clMaroon)
            .SetInt('LaticeColColor', clRed)
            .SetInt('LaticeColSize', 10)
            .SetInt('LaticeRowColor', clGreen)
            .SetInt('LaticeRowSize', 2)
            //
          )
        ]
  );
end;

function TDesignComponentApp.ComposePager(const AProps: IProps): IMetaElement;
var
  mCQ: IFluxNotifier;
begin
  mCQ := NewNotifier(-303);
  FluxFuncReg.RegisterFunc(TCloseQueryFunc.Create(-303));
  Result := ElementFactory.CreateElement(
      IDesignComponentForm,
        NewProps
          .SetStr('DataPath', 'mainform')
          .SetStr(cProps.Title, 'Hello world')
          .SetIntf(cProps.CloseQueryNotifier, mCQ),
        [
          ElementFactory.CreateElement(
            IDesignComponentPager,
            NewProps
              .SetStr('DataPath', 'pagertest')
              .SetInt(IDesignComponentPager.SwitchEdge, IDesignComponentPager.SwitchEdgeRight)
              .SetInt(IDesignComponentPager.SwitchSize, 40)
            ,
            [
               ElementFactory.CreateElement(IStripBit, NewProps.SetStr(cProps.Caption, 'red').SetInt('color', clRed).SetBool('Transparent', False)),
               ElementFactory.CreateElement(IStripBit, NewProps.SetStr(cProps.Caption, 'blue').SetInt('color', clBlue).SetBool('Transparent', False)),
               ElementFactory.CreateElement(IStripBit, NewProps.SetStr(cProps.Caption, 'green').SetInt('color', clGreen).SetBool('Transparent', False))
            ]
          )
        ]
  );
end;

function TDesignComponentApp.ComposeLabelEdit(const AProps: IProps
  ): IMetaElement;
var
  mCQ: IFluxNotifier;
begin
  mCQ := NewNotifier(-303);
  FluxFuncReg.RegisterFunc(TCloseQueryFunc.Create(-303));
  Result := ElementFactory.CreateElement(
      IDesignComponentForm,
        NewProps
          .SetStr('DataPath', 'mainform')
          .SetStr(cProps.Title, 'Hello world')
          .SetIntf(cProps.CloseQueryNotifier, mCQ)
          .SetInt(cProps.Layout, cLayout.Vertical)
          ,
        [
          ElementFactory.CreateElement(
            IDesignComponentLabelEdit,
            NewProps
              .SetStr(cProps.DataPath, 'labedit_1')
              .SetInt(cProps.Color, clAqua).SetBool(cProps.Transparent, False)
              .SetInt(cProps.Place, cPlace.FixFront)
              .SetInt(cProps.Height, 1000)
              .SetInt(cProps.Width, 1000)
              .SetInt(cProps.Layout, cLayout.Vertical)
              .SetInt(cProps.CaptionEdge, IDesignComponentLabelEdit.CaptionEdgeLeft)
              .SetInt(cProps.CaptionWidth, 40)
              .SetInt(cProps.PairWidth, 120)
            ,
            [
              ElementFactory.CreateElement(IDesignComponentEdit, NewProps.SetStr(cProps.Caption, 'user').SetInt(cProps.Color, clGreen)),
              ElementFactory.CreateElement(IDesignComponentEdit, NewProps.SetStr(cProps.Caption, 'password').SetInt(cProps.Color, clRed)),
              ElementFactory.CreateElement(IDesignComponentEdit, NewProps.SetStr(cProps.Caption, 'user').SetInt(cProps.Color, clGreen)),
              ElementFactory.CreateElement(IDesignComponentEdit, NewProps.SetStr(cProps.Caption, 'password').SetInt(cProps.Color, clRed)),
              ElementFactory.CreateElement(IDesignComponentEdit, NewProps.SetStr(cProps.Caption, 'user').SetInt(cProps.Color, clGreen)),
              ElementFactory.CreateElement(IDesignComponentEdit, NewProps.SetStr(cProps.Caption, 'password').SetInt(cProps.Color, clRed)),
              ElementFactory.CreateElement(IDesignComponentEdit, NewProps.SetStr(cProps.Caption, 'user').SetInt(cProps.Color, clGreen)),
              ElementFactory.CreateElement(IDesignComponentEdit, NewProps.SetStr(cProps.Caption, 'password').SetInt(cProps.Color, clRed))
            ]
          )
        ]
  );
end;

procedure TDesignComponentApp.InitValues;
begin
  inherited InitValues;
  State := StoreConnector.Data['application'] as IGenericAccessRO;
  FormData.SetInt(MainForm.Width.Name, 400);
  FormData.SetInt(MainForm.Height.Name, 200);
end;

function TDesignComponentApp.FormData: IGenericAccess;
begin
  Result := StoreConnector.Data['appdata'];
end;

function TDesignComponentApp.FormDataRO: IGenericAccessRO;
begin
  Result := FormData as IGenericAccessRO;
end;

function TDesignComponentApp.DoCompose(const AProps: IProps; const AChildren: TMetaElementArray): IMetaElement;
begin
  Result := ComposeEmpty(AProps);
  //Result := ComposePager(AProps);
  //Result := ComposeLabelEdit(AProps);
end;

procedure TDesignComponentApp.AfterConstruction;
begin
  inherited AfterConstruction;
end;

end.

