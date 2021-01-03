program HanojskeVeze;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Hanojské Vìže';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
