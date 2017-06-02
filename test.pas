unit test;

{$mode objfpc}{$H+}
{$modeswitch typehelpers}
{$modeswitch advancedrecords}

interface

uses
  Classes, SysUtils, tvl_ucontrolbinder, trl_ifactory, StdCtrls, forms, controls,
  typinfo, fgl, types,
  trl_dicontainer, trl_urttibroker, trl_irttibroker,
  iuibits, trl_iprops;

type

  // layout part - read/write json to create binders and throug them controls
  // organized into strip .... echa strip is able to calculate position of its
  // children

  TLayoutPlacement = (Elastic, FixFront, FixMiddle, FixBack);
  TLayoutDirection = (Horizontal, Vertical, Overlay);

  // this one will be associated with every layout component
  TLayoutDetail = record
    Direction: TLayoutDirection;  // this one is for children
    Placement: TLayoutPlacement;
    HFactor: integer; // multiplies height
    WFactor: integer; // multipllies width
  end;

  IStrip = interface
  ['{A3B7543D-2010-45AE-B5C6-E5B43820D218}']
  end;

  { TLayoutBinder }

  TLayoutBinder = class(TControlBinder{, IStrip})
  protected
    fLayoutDetail: TLayoutDetail;
    // z factory budou vyrabet controly podle ID ... ty musi byt nekde extra, protoze
    // se pouziji pro registraci
    fFactory: IFactory;
    function DoCreateControl: TControl; virtual; abstract;
    procedure CreateControl;
  end;

  TLayoutFormBinder = class(TLayoutBinder)
    fForm: tcustomform;
  end;

  TLayoutTitleBinder = class(TLayoutBinder)
    fTitle: TCustomLabel;
  end;

  TLayoutEditBinder = class(TLayoutBinder)
    fEdit: TCustomEdit;
  end;

  TLayoutButtonBinder = class(TLayoutBinder)
    fButton: TButtonControl;
  end;

  // tohle bude component vzor
  // no own control(probably) but will manage children based on their fLayoutDetail
  // his own layout detail will be used by his owner only
  // maybe better that it will be differnt hierarchy ... each control will be inside
  // one strip ..... or should implement istrip ..yes, willbe better
  // no it will not .... strip count children only, byt binder for control have no
  // children at all .... so one sw. defined component .... smallest strip, aka element

  // tahle hierarchie se musi umet vyrobit z json struktury .... root + ui popis
  // takze bude existovat nejaky reader / writer

  TStripBinder = class(TLayoutBinder)
    // one component - one strip
    //reposition
  end;


implementation

{ TLayoutBinder }

procedure TLayoutBinder.CreateControl;
begin
  Bind(DoCreateControl);
end;

end.

