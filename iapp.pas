unit iapp;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

//const
//  cInitFunc = 0;
//  cResizeFunc = 1;
//  cHelloFunc = 2;
//
//const
//  cASMainForm = 'MainForm';
//  cASMainFormLeft = 'Left';
//  cASMainFormTop = 'Top';
//  cASMainFormWidth = 'Width';
//  cASMainFormHeight = 'Height';
//  cASMainFormLeftPath = cASMainForm + '/' + cASMainFormLeft;
//  cASMainFormTopPath = cASMainForm + '/' + cASMainFormTop;
//  cASMainFormWidthPath = cASMainForm + '/' + cASMainFormWidth;
//  cASMainFormHeightPath = cASMainForm + '/' + cASMainFormHeight;

type

  cAppState = class
  public const
    Left = 'Left';
    Top = 'Top';
    Width = 'Width';
    Height = 'Height';
  public const
    MainForm = 'MainForm';
  end;

  cActions = class
  public const
    InitFunc = 0;
    ResizeFunc = 1;
    HelloFunc = 2;
  end;

implementation

initialization

end.

