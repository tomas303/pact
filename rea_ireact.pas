unit rea_ireact;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, trl_iprops, trl_itree, iuibits;

type

  { IMetaElement }

  IMetaElement = interface
  ['{13BBE7DA-46FC-4DC1-97AD-73913576EC12}']
    function Guid: TGuid;
    function GetTypeGuid: string;
    function GetTypeID: string;
    function GetProps: IProps;
    property TypeGuid: string read GetTypeGuid;
    property TypeID: string read GetTypeID;
    property Props: IProps read GetProps;
  end;

  IMetaElementEnumerator = interface
  ['{986E6CB6-E8A2-42AA-819E-7BB1F1A2C1A7}']
    function MoveNext: Boolean;
    function GetCurrent: IMetaElement;
    property Current: IMetaElement read GetCurrent;
  end;

  IMetaElementFactory = interface
  ['{64895959-43CF-43E3-A3CE-1EF69608BEBE}']
    function New(const AMetaElement: IMetaElement): IUnknown;
  end;

  IComposite = interface
  ['{177488BD-84E8-4E08-821E-A3D25DE36B5C}']
    // props + state - create metadata what objekt should be created
    function Render: IMetaElement;
  end;

  IReconciliator = interface
  ['{066DDE74-0738-4636-B8DD-E3E1BA873D2E}']
    procedure Reconciliate(var ABit: IUIBit; const AOldElement, ANewElement: IMetaElement);
  end;

  IReact = interface
  ['{AE38F1CF-3993-425E-AF47-065ED87D11BA}']
    function CreateElement(const ATypeGuid: TGuid): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const AProps: IProps): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const AProps: IProps;
      const AChildren: array of IMetaElement): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const ATypeID: string): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const ATypeID: string; const AProps: IProps): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const ATypeID: string; const AProps: IProps;
      const AChildren: array of IMetaElement): IMetaElement;
    procedure Render(const AElement: IMetaElement{; ATo: someplace??? - probably not necessary});
  end;

implementation

end.

