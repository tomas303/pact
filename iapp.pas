unit iapp;

{$mode objfpc}{$H+}

interface

uses
  trl_iprops;

const
  cInitFunc = 0;
  cResizeFunc = 1;

const
  cMainFormStatePath = 'MainForm';

type

  { IPactState }

  IPactState = interface
  ['{C249A0F2-10C6-4686-9470-D18832D43B65}']
    function GetMainForm: IProps;
    procedure SetMainForm(AValue: IProps);
    property MainForm: IProps read GetMainForm write SetMainForm;
  end;


implementation

end.

