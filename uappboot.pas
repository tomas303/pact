unit uappboot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, rea_ireact, rea_ureact, trl_iprops, iapp, graphics, rea_ilayout;

type

  { TReactComponentApp }

  TReactComponentApp = class(TReactComponent, IReactComponentApp)
  protected
    function ComposeElement(const AProps: IProps; const AParentElement: IMetaElement): IMetaElement; override;
  end;

implementation

{ TReactComponentApp }

function TReactComponentApp.ComposeElement(const AProps: IProps;
  const AParentElement: IMetaElement): IMetaElement;
var
  mProps: IProps;
  mButtons: IProps;
  mButton: IProps;
  mFrames: TMetaElementArray;
  i: integer;
begin
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

{

  Result := ElementFactory.CreateElement(
    IReactComponentMainForm,
      AProps.Clone
        .SetStr('Title', 'Hello world')
        .SetInt('Layout', cLayout.Vertical)
        .SetInt('Color', clYellow)
        //MMWidth a MMHeight bude treba jeste dopracovat
        .SetInt('Width', 400)
        .SetInt('Height', 300),
    [
      ElementFactory.CreateElement(IReactComponentButton, NewProps.SetStr('Caption', 'One')),

      //ElementFactory.CreateElement(IReactComponentButton, NewProps.SetStr('Caption', 'Two').SetBool('ParentColor', True))


      ElementFactory.CreateElement(IReactComponentHeader, NewProps.SetInt('Layout', cLayout.Vertical),
      [
        ElementFactory.CreateElement(IReactComponentHeader,
        NewProps
        .SetStr('Title', 'HLAVA')
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
        .SetStr('Caption', 'Two')
        .SetBool('ParentColor', True)
        //.SetInt('MMHeight', 50)
        //.SetInt('Place', cPlace.FixBack)
        .SetInt('Place', cPlace.Elastic)
        ),

        ElementFactory.CreateElement(IReactComponentButton,
        NewProps
        .SetStr('Caption', 'Two')
        .SetBool('ParentColor', True)
        .SetInt('MMHeight', 8)
        //.SetInt('Place', cPlace.FixBack)
        .SetInt('Place', cPlace.Elastic)
        ),

        ElementFactory.CreateElement(IReactComponentButton,
        NewProps
        .SetStr('Caption', 'Two')
        .SetBool('ParentColor', True)
        .SetInt('MMHeight', 30)
        .SetInt('Place', cPlace.FixBack)
        )
      ])

    ]);

 }

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

end;

end.

