unit uappboot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, rea_ireact, rea_ureact, trl_iprops, iapp, graphics, rea_ilayout;

type

  { TAppComposite }

  TAppComposite = class(TComposite, IAppComposite)
  protected
    function ComposeElement(const AProps: IProps; const AChildren: array of IMetaElement): IMetaElement; override;
  end;

implementation

{ TAppComposite }

function TAppComposite.ComposeElement(const AProps: IProps;
  const AChildren: array of IMetaElement): IMetaElement;
var
  mProps: IProps;
  mButtons: IProps;
  mButton: IProps;
  mFrames: TMetaElementArray;
  i: integer;
begin
  mButtons := NewProps;

  mButton := NewProps;
  mButton.SetStr('Caption', 'One').SetInt('ActionClick', cActions.ClickOne);
  mButtons.SetIntf('1', mButton);

  mButton := NewProps;
  mButton.SetStr('Caption', 'Two').SetInt('ActionClick', cActions.ClickTwo);
  mButtons.SetIntf('2', mButton);

  mButton := NewProps;
  mButton.SetStr('Caption', 'Three').SetInt('ActionClick', cActions.ClickThree);
  mButtons.SetIntf('3', mButton);

  mProps := NewProps;

  SetLength(mFrames, AProps.AsInt(Layout.Perspective.Name));
  for i := 0 to AProps.AsInt(Layout.Perspective.Name) - 1 do
  begin
    mFrames[i] := ElementFactory.CreateElement(IHeaderComposite,
          mProps.Clone.SetBool('Transparent', False)
          .SetInt('Color', clRed)
          .SetStr('Title', i.ToString)
          .SetInt('FontColor', clYellow)
          .SetInt('Border', 5)
          .SetInt('BorderColor', clPurple)
          );
  end;

  Result := ElementFactory.CreateElement(
    //IFormComposite, 'mainform',  mProps.Clone.SetStr('Title', 'Hello world').SetInt('Layout', cLayout.Horizontal){.SetInt('Color', clYellow)},
    IMainFormComposite, mProps.Clone.SetStr('Title', 'Hello world').SetInt('Layout', cLayout.Horizontal){.SetInt('Color', clYellow)},
    [

      ElementFactory.CreateElement(IButtonsComposite,
      NewProps.SetIntf('Buttons', mButtons).SetInt('Layout', cLayout.Vertical)),

      ElementFactory.CreateElement(IHeaderComposite,
      NewProps,
      [
        ElementFactory.CreateElement(IHeaderComposite,
        mProps.Clone.SetInt('Layout', cLayout.Horizontal),
         mFrames
        {[
          ElementFactory.CreateElement(IHeaderComposite,
          mProps.Clone.SetBool('Transparent', False)
          .SetInt('Color', clRed)
          .SetStr('Title', 'One')
          .SetInt('FontColor', clYellow)
          .SetInt('Border', 5)
          .SetInt('BorderColor', clPurple)
          ),
          ElementFactory.CreateElement(IHeaderComposite,
          mProps.Clone.SetBool('Transparent', False)
          .SetInt('Color', clBlack)
          .SetStr('Title', 'Two')
          .SetInt('FontColor', clLime)
          .SetInt('Border', 5)
          .SetInt('BorderColor', clAqua)
          )
        ]})
      ])
    ]);
end;

end.

