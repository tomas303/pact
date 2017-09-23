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

  TMetaElementArray = array of IMetaElement;

  IMetaElementFactory = interface
  ['{64895959-43CF-43E3-A3CE-1EF69608BEBE}']
    function New(const AMetaElement: IMetaElement): IUnknown;
    function CreateElement(const ATypeGuid: TGuid): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const AProps: IProps): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const AChildren: array of IMetaElement): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const AProps: IProps;
      const AChildren: array of IMetaElement): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const ATypeID: string): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const ATypeID: string; const AProps: IProps): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const ATypeID: string; const AChildren: array of IMetaElement): IMetaElement;
    function CreateElement(const ATypeGuid: TGuid; const ATypeID: string; const AProps: IProps;
      const AChildren: array of IMetaElement): IMetaElement;
  end;

  IComposite = interface
  ['{177488BD-84E8-4E08-821E-A3D25DE36B5C}']
    function CreateElement(const ASourceElement: IMetaElement): IMetaElement;
  end;

  { IComposites }

  IComposites = interface
  ['{146EB9CF-576B-4362-A28C-6EBF734F6517}']
    function GetCount: integer;
    function GetItem(const AIndex: integer): IComposite;
    procedure Add(const AComposite: IComposite);
    property Count: integer read GetCount;
    property Item[const AIndex: integer]: IComposite read GetItem; default;
  end;

  IAppComposite = interface(IComposite)
  ['{CAD729C0-F921-4932-9583-921B177142D2}']
  end;

  IFormComposite = interface(IComposite)
  ['{E549424C-6C94-48BC-934D-B100341207C9}']
  end;

  IEditComposite = interface(IComposite)
  ['{E649F83B-D785-4209-B2F1-B072ECFDC680}']
  end;

  IEditsComposite = interface(IComposite)
  ['{B5B85863-29E5-4444-A65C-890A713E51C6}']
  end;

  IButtonComposite = interface(IComposite)
  ['{F4526301-63C9-4270-B61F-AD8BFAC60220}']
  end;

  IButtonsComposite = interface(IComposite)
  ['{F350FB28-34B2-4626-ABD9-ABA2AE87B760}']
  end;

  IHeaderComposite = interface(IComposite)
  ['{4F6C423B-D002-4717-B455-67232370A145}']
  end;

  IReact = interface
  ['{AE38F1CF-3993-425E-AF47-065ED87D11BA}']
    procedure Render(const AElement: IMetaElement);
    procedure Rerender;
  end;

  { IReactComponent }

  IReactComponent = interface
  ['{FB2D2C72-1E52-40C0-BE52-63AFA7448590}']
    procedure Rerender(const AUpperComponent: IReactComponent);
    //procedure AddComposite(const AComposite: IComposite);
    procedure ResetData(const AElement: IMetaElement; const AComposite: IComposite; const ABit: IUIBit);
    function GetElement: IMetaElement;
    property Element: IMetaElement read GetElement;
    function GetComposite: IComposite;
    property Composite: IComposite read GetComposite;
    function GetBit: IUIBit;
    property Bit: IUIBit read GetBit;
  end;

  {

     XCp -> XCp -> Xb1 -> Xb
                       -> Xcp -> Xb2 -> Xb
                                     -> Xb
                       -> Xb


                  Xb1 -> Xb
                      -> Xb2 -> Xb
                             -> Xb
                      -> Xb

            (Xb1)   (xb2)
     XCp -> XCp -> XCp

     because when XCp something change, it will be Xb who will be reconciliated
     similarly if in parent XCP something change, it will be XCp who will be reconciliated

     it make sence that bits will be 1 net, composites will be 2 net ... od I ever
     need composite? Yes - to connect both nest together ... to deliver change from rerender

  }



  IXReactComponent = interface
  ['{B7822CA4-A760-466E-843F-82715084F931}']
    procedure Rerender;
    procedure ResetData(const AElement: IMetaElement; const AObject: IUnknown);
    function GetElement: IMetaElement;
    property Element: IMetaElement read GetElement;
  end;

  IUIBitComponent = interface(IXReactComponent)
  ['{0F3CE857-3C45-4FE7-B64D-1E733A3DEAF0}']
    function GetUIBit: IUIBit;
    property UIBit: IUIBit read GetUIBit;
  end;

  ICompositeComponent = interface(IXReactComponent)
  ['{0F3CE857-3C45-4FE7-B64D-1E733A3DEAF0}']
    function GetComposite: IComposite;
    property Composite: IComposite read GetComposite;
  end;

  IReactFactory = interface
  ['{6F9A1695-2442-401C-98ED-893CFF586962}']
    function New(const AElement: IMetaElement): IReactComponent;
    function New1(const AMetaElement: IMetaElement; const AComponent: IReactComponent): IUIBit;
    function New2(const AMetaElement: IMetaElement): IXReactComponent;
  end;

  IReconciliator = interface
  ['{066DDE74-0738-4636-B8DD-E3E1BA873D2E}']
    function Reconciliate(const AComponent: IReactComponent; var ABit: IUIBit; const AOldElement, ANewElement: IMetaElement): Boolean;
  end;

implementation

end.

