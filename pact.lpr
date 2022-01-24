program pact;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  uapp, uappdata, uappgui;

{$R *.res}

begin
  TApp.Go;
end.

