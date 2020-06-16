unit uappboot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, rea_ireact, rea_ureact, trl_iprops, iapp, graphics, rea_ilayout,
  trl_imetaelement, trl_imetaelementfactory, trl_idifactory,
  rea_udesigncomponent, rea_idesigncomponent, flu_iflux;

type

  { TReactComponentApp }

  TReactComponentApp = class(TReactComponent, IReactComponentApp)
  protected
    function ComposeElement(const AParentElement: IMetaElement): IMetaElement; override;
  end;

  { TBootElementProvider }

  TBootElementProvider = class(TInterfacedObject, IMetaElementProvider)
  protected
    function NewProps: IProps;
  protected
    // IMetaElementProvider
    function ProvideMetaElement: IMetaElement;
    function ProvideMetaElementOriginal: IMetaElement;
  protected
    fFactory: IDIFactory;
    fElementFactory: IMetaElementFactory;
  published
    property Factory: IDIFactory read fFactory write fFactory;
    property ElementFactory: IMetaElementFactory read fElementFactory write fElementFactory;
  end;

  { TDesignComponentApp }

  TDesignComponentApp = class(TDesignComponent, IDesignComponentApp)
  protected
    function DoCompose(const AProps: IProps): IMetaElement; override;
  end;

implementation

{ TDesignComponentApp }

function TDesignComponentApp.DoCompose(const AProps: IProps): IMetaElement;
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
begin
  m := SelfProps.AsStr(Layout.Perspective.Name);
  minfo := SelfProps.Info;

  {
   tady by se mel state injektovat .... problem s func, protoze 2 ruzne elementy
   muzou mit 2 ruzne state ...jak to promitnout do func?
   to by musel byt skutecne parametr poslany pres notifier ... ?????

  }

  mOneClickNotifier := NewNotifier(cActions.ClickOne);

  mSMNotifier := NewNotifier(cActions.ResizeFunc);
  Result := ElementFactory.CreateElement(
    IDesignComponentForm,
      NewProps
        .SetIntf(cProps.SizeNotifier, mSMNotifier)
        .SetIntf(cProps.MoveNotifier, mSMNotifier)
        .SetStr(cProps.Title, 'Hello world')
        .SetInt(cProps.Layout, cLayout.Vertical)
        .SetIntf('State', NewState(MainForm.Name)),
    [
      ElementFactory.CreateElement(IDesignComponentEdit,
        NewProps
          .SetStr(cProps.Title, 'First name')
          .SetStr(cProps.Value, 'Kuliferda')
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

{ TBootElementProvider }

function TBootElementProvider.NewProps: IProps;
begin
  Result := IProps(Factory.Locate(IProps));
end;

function TBootElementProvider.ProvideMetaElementOriginal: IMetaElement;
var
  mProps: IProps;
  mButtons: IProps;
  mButton: IProps;
  mFrames: TMetaElementArray;
  i: integer;
begin
  Result := ElementFactory.CreateElement(
    IReactComponentMainForm,
      NewProps
        .SetStr(cProps.Title, 'Hello world')
        .SetInt(cProps.Layout, cLayout.Vertical)
        .SetInt(cProps.Color, clYellow),
    [
      ElementFactory.CreateElement(IReactComponentEdit, NewProps.SetStr(cProps.Title, 'First name').SetStr(cProps.Value, 'Kuliferda')),
      ElementFactory.CreateElement(IReactComponentButton, NewProps.SetStr('Text', 'One')),

      ElementFactory.CreateElement(IReactComponentHeader, NewProps.SetInt('Layout', cLayout.Horizontal),
      [
        ElementFactory.CreateElement(IReactComponentButton,
        NewProps.SetStr('Text', 'Layout 1').SetInt('Place', cPlace.Elastic).SetInt('ActionClick', cActions.ClickOne)),
        ElementFactory.CreateElement(IReactComponentButton,
        NewProps.SetStr('Text', 'Layout 2').SetInt('Place', cPlace.Elastic).SetInt('ActionClick', cActions.ClickTwo)),
        ElementFactory.CreateElement(IReactComponentButton,
        NewProps.SetStr('Text', 'Layout 3').SetInt('Place', cPlace.Elastic).SetInt('ActionClick', cActions.ClickThree))
      ]),

      ElementFactory.CreateElement(IReactComponentHeader, NewProps.SetInt('Layout', cLayout.Vertical),
      [
        ElementFactory.CreateElement(IReactComponentHeader,
        NewProps
        //.SetStr('Title', SelfProps.AsStr(Layout.Perspective.Name))
        .SetStr('Title', 'Haj')
        .SetInt('Border', 10)
        .SetInt('BorderColor', clRed)
        .SetInt('FontColor', clBlue)
        .SetInt('Color', clLime)
        .SetBool('Transparent', False)
        .SetInt('MMHeight', 50)
        .SetInt('Place', cPlace.FixFront)
        ),

        ElementFactory.CreateElement(IReactComponentButton,
        NewProps
        .SetStr('Text', 'Three')
        .SetBool('ParentColor', True)
        //.SetInt('MMHeight', 50)
        //.SetInt('Place', cPlace.FixBack)
        .SetInt('Place', cPlace.Elastic)
        ),

        ElementFactory.CreateElement(IReactComponentButton,
        NewProps
        .SetStr('Text', 'Four')
        .SetBool('ParentColor', True)
        .SetInt('MMHeight', 20)
        //.SetInt('Place', cPlace.FixBack)
        .SetInt('Place', cPlace.Elastic)
        ),

        ElementFactory.CreateElement(IReactComponentButton,
        NewProps
        .SetStr('Text', 'Five')
        .SetBool('ParentColor', True)
        .SetInt('MMHeight', 50)
        .SetInt('Place', cPlace.FixBack)
        )
      ])

    ]);

end;

function TBootElementProvider.ProvideMetaElement: IMetaElement;
begin
  Result := ElementFactory.CreateElement(
    IReactComponentMainForm,
      NewProps
        .SetStr(cProps.Title, 'Hello world')
        .SetInt(cProps.Layout, cLayout.Vertical)
        .SetInt(cProps.Color, clYellow)
        .SetIntf(cProps.Children,
          NewProps
          .SetIntf('', ElementFactory.CreateElement(IReactComponentEdit, NewProps.SetStr(cProps.Title, 'First name').SetStr(cProps.Value, 'Kuliferda')))
          .SetIntf('', ElementFactory.CreateElement(IReactComponentButton, NewProps.SetStr('Text', 'One')))
          .SetIntf('', ElementFactory.CreateElement(IReactComponentHeader,
                      NewProps
                      .SetInt('Layout', cLayout.Horizontal)
                      .SetIntf(cProps.Children,
                        NewProps
                        .SetIntf('', ElementFactory.CreateElement(IReactComponentButton, NewProps.SetStr('Text', 'Layout 1').SetInt('Place', cPlace.Elastic).SetInt('ActionClick', cActions.ClickOne)))
                        .SetIntf('', ElementFactory.CreateElement(IReactComponentButton, NewProps.SetStr('Text', 'Layout 2').SetInt('Place', cPlace.Elastic).SetInt('ActionClick', cActions.ClickTwo)))
                        .SetIntf('', ElementFactory.CreateElement(IReactComponentButton, NewProps.SetStr('Text', 'Layout 3').SetInt('Place', cPlace.Elastic).SetInt('ActionClick', cActions.ClickThree)))
                      )
                      ))
          .SetIntf('', ElementFactory.CreateElement(IReactComponentHeader,
                      NewProps
                      .SetInt('Layout', cLayout.Vertical)
                      .SetIntf(cProps.Children,
                        NewProps
                        .SetIntf('', ElementFactory.CreateElement(IReactComponentHeader,
                                    NewProps.SetStr('Title', 'Haj')
                                    .SetInt('Border', 10)
                                    .SetInt('BorderColor', clRed)
                                    .SetInt('FontColor', clBlue)
                                    .SetInt('Color', clLime)
                                    .SetBool('Transparent', False)
                                    .SetInt('MMHeight', 50).SetInt('Place', cPlace.FixFront)
                                    .SetIntf(cProps.Children,
                                                             NewProps
                                                             .SetIntf('', ElementFactory.CreateElement(IReactComponentButton, NewProps.SetStr('Text', 'Three').SetBool('ParentColor', True).SetInt('Place', cPlace.Elastic)))
                                                             .SetIntf('', ElementFactory.CreateElement(IReactComponentButton,NewProps.SetStr('Text', 'Four').SetBool('ParentColor', True).SetInt('MMHeight', 20).SetInt('Place', cPlace.Elastic)))
                                                             .SetIntf('', ElementFactory.CreateElement(IReactComponentButton, NewProps.SetStr('Text', 'Five').SetBool('ParentColor', True).SetInt('MMHeight', 50).SetInt('Place', cPlace.FixBack)))

                                    )
                                    ))
                      )
                      ))
        ))
end;

{ TReactComponentApp }

function TReactComponentApp.ComposeElement(const AParentElement: IMetaElement): IMetaElement;
var
  mProps: IProps;
  mButtons: IProps;
  mButton: IProps;
  mFrames: TMetaElementArray;
  i: integer;
  minfo: string;
  m: string;
begin
  m := SelfProps.AsStr(Layout.Perspective.Name);
  minfo := SelfProps.Info;

  //mButtons := NewProps;
  //
  //mButton := NewProps;
  //mButton.SetStr('Caption', 'One').SetInt('ActionClick', cActions.ClickOne);
  //mButtons.SetIntf('1', mButton);
  //
  //mButton := NewProps;
  //mButton.SetStr('Caption', 'Two').SetInt('ActionClick', cActions.ClickTwo);
  //mButtons.SetIntf('2', mButton);
  //
  //mButton := NewProps;
  //mButton.SetStr('Caption', 'Three').SetInt('ActionClick', cActions.ClickThree);
  //mButtons.SetIntf('3', mButton);
  //
  //mProps := NewProps;
  //
  //SetLength(mFrames, AProps.AsInt(Layout.Perspective.Name));
  //for i := 0 to AProps.AsInt(Layout.Perspective.Name) - 1 do
  //begin
  //  mFrames[i] := ElementFactory.CreateElement(IReactComponentHeader,
  //        mProps.Clone.SetBool('Transparent', False)
  //        .SetInt('Color', clRed)
  //        .SetStr('Title', i.ToString)
  //        .SetInt('FontColor', clYellow)
  //        .SetInt('Border', 5)
  //        .SetInt('BorderColor', clPurple)
  //        );
  //end;
  //
  //Result := ElementFactory.CreateElement(
  //  //IFormComposite, 'mainform',  mProps.Clone.SetStr('Title', 'Hello world').SetInt('Layout', cLayout.Horizontal){.SetInt('Color', clYellow)},
  //  IReactComponentMainForm, mProps.Clone.SetStr('Title', 'Hello world').SetInt('Layout', cLayout.Horizontal).SetInt('Color', clYellow),
  //  [
  //
  //    ElementFactory.CreateElement(IReactComponentButtons,
  //    NewProps.SetIntf('Buttons', mButtons).SetInt('Layout', cLayout.Vertical)),
  //
  //    ElementFactory.CreateElement(IReactComponentHeader,
  //    NewProps,
  //    [
  //      ElementFactory.CreateElement(IReactComponentHeader,
  //      mProps.Clone.SetInt('Layout', cLayout.Horizontal),
  //       mFrames
  //      {[
  //        ElementFactory.CreateElement(IHeaderComposite,
  //        mProps.Clone.SetBool('Transparent', False)
  //        .SetInt('Color', clRed)
  //        .SetStr('Title', 'One')
  //        .SetInt('FontColor', clYellow)
  //        .SetInt('Border', 5)
  //        .SetInt('BorderColor', clPurple)
  //        ),
  //        ElementFactory.CreateElement(IHeaderComposite,
  //        mProps.Clone.SetBool('Transparent', False)
  //        .SetInt('Color', clBlack)
  //        .SetStr('Title', 'Two')
  //        .SetInt('FontColor', clLime)
  //        .SetInt('Border', 5)
  //        .SetInt('BorderColor', clAqua)
  //        )
  //      ]})
  //    ])
  //  ]);



  Result := ElementFactory.CreateElement(
    IReactComponentMainForm,
      NewProps
        .SetStr(cProps.Title, 'Hello world')
        .SetInt(cProps.Layout, cLayout.Vertical)
        .SetInt(cProps.Color, clYellow),
    [
      ElementFactory.CreateElement(IReactComponentEdit, NewProps.SetStr(cProps.Title, 'First name').SetStr(cProps.Value, 'Kuliferda')),
      ElementFactory.CreateElement(IReactComponentButton, NewProps.SetStr('Text', 'One')),

      ElementFactory.CreateElement(IReactComponentHeader, NewProps.SetInt('Layout', cLayout.Horizontal),
      [
        ElementFactory.CreateElement(IReactComponentButton,
        NewProps.SetStr('Text', 'Layout 1').SetInt('Place', cPlace.Elastic).SetInt('ActionClick', cActions.ClickOne)),
        ElementFactory.CreateElement(IReactComponentButton,
        NewProps.SetStr('Text', 'Layout 2').SetInt('Place', cPlace.Elastic).SetInt('ActionClick', cActions.ClickTwo)),
        ElementFactory.CreateElement(IReactComponentButton,
        NewProps.SetStr('Text', 'Layout 3').SetInt('Place', cPlace.Elastic).SetInt('ActionClick', cActions.ClickThree))
      ]),

      ElementFactory.CreateElement(IReactComponentHeader, NewProps.SetInt('Layout', cLayout.Vertical),
      [
        ElementFactory.CreateElement(IReactComponentHeader,
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

        ElementFactory.CreateElement(IReactComponentButton,
        NewProps
        .SetStr('Text', 'Three')
        .SetBool('ParentColor', True)
        //.SetInt('MMHeight', 50)
        //.SetInt('Place', cPlace.FixBack)
        .SetInt('Place', cPlace.Elastic)
        ),

        ElementFactory.CreateElement(IReactComponentButton,
        NewProps
        .SetStr('Text', 'Four')
        .SetBool('ParentColor', True)
        .SetInt('MMHeight', 20)
        //.SetInt('Place', cPlace.FixBack)
        .SetInt('Place', cPlace.Elastic)
        ),

        ElementFactory.CreateElement(IReactComponentButton,
        NewProps
        .SetStr('Text', 'Five')
        .SetBool('ParentColor', True)
        .SetInt('MMHeight', 50)
        .SetInt('Place', cPlace.FixBack)
        )
      ])

    ]);


{
  Result := ElementFactory.CreateElement(
    IReactComponentMainForm,
      AProps.Clone
        .SetStr('Title', 'Hello world')
        .SetInt('Layout', cLayout.Vertical)
        .SetInt('Color', clYellow)
        //MMWidth a MMHeight bude treba jeste dopracovat
        .SetInt('MMWidth', 400)
        .SetInt('MMHeight', 300),
    [
      ElementFactory.CreateElement(IReactComponentButton,
        NewProps
        .SetStr('Caption', 'One')
        .SetInt('MMHeight', 50)
        .SetInt('Place', cPlace.FixFront)),
      ElementFactory.CreateElement(IReactComponentButton,
        NewProps
        .SetStr('Caption', 'Two')
        .SetInt('Place', cPlace.Elastic)),
      ElementFactory.CreateElement(IReactComponentButton,
        NewProps
        .SetStr('Caption', 'Three')
        .SetInt('MMHeight', 10)
        .SetInt('Place', cPlace.Elastic)),
      ElementFactory.CreateElement(IReactComponentButton,
        NewProps
        .SetStr('Caption', 'Four')
        .SetInt('MMHeight', 30)
        .SetInt('Place', cPlace.FixBack))
      ]);
 }
end;

end.

