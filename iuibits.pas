unit iuibits;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, trl_iprops, Graphics;

type
  // wrapper for real control and its binder
  IUIBit = interface
  ['{479784FA-9E6B-4826-BCFE-92A676B2F7DD}']
    // create / updater cocrete objects from FCL(but from factory ... addclass with owner)
    procedure Render;
    procedure RenderPaint(const ACanvas: TCanvas);
    procedure HookParent(const AParent: TWinControl);
  end;

  IUIFormBit = interface
  ['{64AAE7AE-AC24-4CBA-8430-2885CFC396AC}']
  end;

  IUIStripBit = interface
  ['{354C99E0-E2B2-43CF-89E7-95057DF390F0}']
  end;

  IUIEditBit = interface
  ['{0392A25E-1D90-4F37-9279-09F32D6F7D03}']
  end;

  IUITextBit = interface
   ['{4178C1EC-AA39-4429-B48C-7058676ABA7B}']
  end;

  IUIButtonBit = interface
   ['{7FB3194B-62AB-44B7-8317-603D10706C71}']
  end;

  // maybe with Store param ....bo it will be ideal to only sent messages to store .... like
  IUINotifyEvent = procedure(const AProps: IProps) of object;

  IUINotifier = interface
  ['{110FD82F-1891-4865-A33F-98D6B1E7617C}']
    procedure Notify(const AProps: IProps);
    procedure Add(const AEvent: IUINotifyEvent);
    procedure Remove(const AEvent: IUINotifyEvent);
  end;

implementation

end.

