unit iuibits;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls;

type
  // wrapper for real control and its binder
  IUIBit = interface
  ['{479784FA-9E6B-4826-BCFE-92A676B2F7DD}']
    // create / updater cocrete objects from FCL(but from factory ... addclass with owner)
    procedure Render;
    function Surface: TWinControl;
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

implementation

end.

