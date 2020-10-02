unit uappboot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, trl_iprops, iapp, graphics, rea_ilayout,
  trl_imetaelement, trl_imetaelementfactory, trl_idifactory,
  rea_udesigncomponent, rea_idesigncomponent, flu_iflux, trl_igenericaccess,
  forms;

type

  { TCloseQueryFunc }

  TCloseQueryFunc = class(TInterfacedObject, IFluxFunc)
  protected
    procedure Execute(const AAction: IFluxAction);
  end;

  { TDesignComponentApp }

  TDesignComponentApp = class(TDesignComponent, IDesignComponentApp)
  private
    function ComposeTest(const AProps: IProps): IMetaElement;
    function ComposeEmpty(const AProps: IProps): IMetaElement;
  protected
    procedure InitValues; override;
    function FormData: IGenericAccess;
    function FormDataRO: IGenericAccessRO;
    function DoCompose(const AProps: IProps): IMetaElement; override;
  end;

implementation

{ TCloseQueryFunc }

procedure TCloseQueryFunc.Execute(const AAction: IFluxAction);
begin
  if AAction.ID = -303 then begin
    Application.Terminate;
  end;
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
  FluxFuncReg.RegisterFunc(TCloseQueryFunc.Create);
  Result := ElementFactory.CreateElement(
      IDesignComponentForm,
        NewProps
          .SetStr(cProps.Title, 'Hello world')
          .SetIntf(cProps.CloseQueryNotifier, mCQ),
        [
          ElementFactory.CreateElement(IDesignComponentGrid,
          NewProps
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
            //.SetInt(cProps.Color, clGreen)
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
  Result := StoreConnector.Data['mainform'];
end;

function TDesignComponentApp.FormDataRO: IGenericAccessRO;
begin
  Result := FormData as IGenericAccessRO;
end;

function TDesignComponentApp.DoCompose(const AProps: IProps): IMetaElement;
begin
  Result := ComposeEmpty(AProps);
end;

end.

