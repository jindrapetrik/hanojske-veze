program HanojskeVeze;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Hanojsk� V�e';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
