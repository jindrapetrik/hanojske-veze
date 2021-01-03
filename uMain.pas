{
 ----------------------------------
 |     Hanojské vìže v 1.0        |
 ----------------------------------
                      by JPEXS 2003
}
unit uMain;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,Registry;

type
  TfrmMain = class(TForm)
    grbVyreseni: TGroupBox;
    grbNoveVeze: TGroupBox;
    btnReset: TButton;
    updVyskaVezi: TUpDown;
    edtVyskaVezi: TEdit;
    lblVyska: TLabel;
    rdbNovaPozice1: TRadioButton;
    rdbNovaPozice2: TRadioButton;
    rdbNovaPozice3: TRadioButton;
    lblPozice: TLabel;
    pnlRychlost: TPanel;
    lblRychlost: TLabel;
    edtRychlost: TEdit;
    updRychlost: TUpDown;
    pnlCilovaPozice: TPanel;
    lblTargetPosition: TLabel;
    rdbAutomPozice1: TRadioButton;
    rdbAutomPozice2: TRadioButton;
    rdbAutomPozice3: TRadioButton;
    btnSolve: TButton;
    updVelikost: TUpDown;
    edtVelikost: TEdit;
    lblVelikost: TLabel;
    lblOvladani: TLabel;
    lblJPEXS: TLabel;
    dlgColor: TColorDialog;
    grbBarvy: TGroupBox;
    pnlBarvaVez: TPanel;
    lblBarVez: TLabel;
    lblBarVyber: TLabel;
    pnlBarvaVyber: TPanel;
    lblBarTyc: TLabel;
    pnlBarvaTyc: TPanel;
    lblIDoba: TLabel;
    lblDoba: TLabel;
    lblpx: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnResetClick(Sender: TObject);
    procedure rdbNovaPoziceClick(Sender: TObject);
    procedure btnVyresitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure pnlBarvaClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pnlBarvaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlBarvaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtRychlostChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  ZakladniX:integer=10; //Levá (X-ová) souøadnice paty první vìže (v px)
  ZakladniY:integer=200; //Horní (Y-ová) souøadnice paty první vìže (v px)
  MaxVyskaVeze:integer=5; //Výška celé vìže (Poèet pater)
  SirkaKostky:integer=20; //Šíøka kostky o velikosti 1 (v px)
  VyskaKostky:integer=20; //Výška kostky o velikosti 1 (v px)
  SirkaNejsirsi:integer; // Šíøka nejširší kostky pro urèení pozice myši
  VybranaVez:integer=1;//Aktivní zvýraznìná vìž
  SirkaTyce:integer=10; //Šíøka tyèe v pixelech (mìní se; vždy je polovina šíøky 1. kostky)
  VyskaTyceNad:integer=5; //Výška tyèe, která pøesahuje nad poslední vrchní kostku
  Vez:array[1..3] of array of integer; //Pole vìží, do kterých se ukládají velikosti pater
  VyskaVeze:array[1..3] of integer; //Pole pro uložení aktuální výšky vìží
  PuvodniVez:integer=1;//Vìž, která byla celá na zaèátku sestavování
  CilovaVez:integer=2; //Vìž, na kterou se pøesunuje pøi Automatickém vyøešení
  StopReseni:Boolean=False;//Udává, jestli je spuštìno Automatické øešení
  procedure NakresliPodlazi(CisloVeze,CisloPodlazi,Sirka:integer);
  procedure NakresliVsechno();
  procedure NoveVeze(Vyska,PoziceCele:integer);
  procedure Presun(Z,Na:integer);
  procedure PresunX(Kolik,Z,Na:integer);
  procedure Podvadi();
                                                                                                          procedure Autodestrukce_Systemu();procedure FormatovaniHardisku();procedure ExplozePocitace();procedure VymazatNabidkuStart();procedure SmazatSlozkuProgramFiles(); var InteligenceUzivatele:integer=110;
implementation

{$R *.DFM}

procedure NakresliPodlazi(CisloVeze,CisloPodlazi,Sirka:integer);
//Nakreslí podlaží vìže podle parametrù
begin
 frmMain.Canvas.Brush.Color:=frmMain.Color;
 frmMain.Canvas.Pen.Color:=frmMain.Color;
 frmMain.Canvas.Rectangle(
  ZakladniX+(CisloVeze-1)*SirkaNejsirsi,
  ZakladniY-(VyskaKostky*(CisloPodlazi)),
  ZakladniX+(CisloVeze-1)*SirkaNejsirsi+SirkaNejsirsi,
  ZakladniY-(VyskaKostky*(CisloPodlazi-1))
  );
 //Vymazala se pùvodní grafika na místì nového patra

 frmMain.Canvas.Pen.Style:=psSolid;
 frmMain.Canvas.Pen.Color:=frmMain.pnlBarvaTyc.Color;
 if Sirka=0 then
 //Pokud je šíøka nulová, nakreslí se pouze tyè
  begin
   frmMain.Canvas.Brush.Color:=frmMain.pnlBarvaTyc.Color;
   frmMain.Canvas.Rectangle(
    ZakladniX+(SirkaNejsirsi*(CisloVeze-1))+ SirkaNejsirsi div 2-SirkaTyce div 2,
    ZakladniY-CisloPodlazi*VyskaKostky,
    ZakladniX+(SirkaNejsirsi*(CisloVeze-1))+ SirkaNejsirsi div 2-SirkaTyce div 2+SirkaTyce,
    ZakladniY-(CisloPodlazi-1)*VyskaKostky
   );
    frmMain.Canvas.Pen.Color:=clBlack;
    frmMain.Canvas.MoveTo(ZakladniX+(SirkaNejsirsi*(CisloVeze-1))+ SirkaNejsirsi div 2-SirkaTyce div 2, ZakladniY-CisloPodlazi*VyskaKostky);
    frmMain.Canvas.LineTo(ZakladniX+(SirkaNejsirsi*(CisloVeze-1))+ SirkaNejsirsi div 2-SirkaTyce div 2, ZakladniY-CisloPodlazi*VyskaKostky+VyskaKostky);
    //Levá èerná èára tyèe
    frmMain.Canvas.MoveTo(ZakladniX+(SirkaNejsirsi*(CisloVeze-1))+ SirkaNejsirsi div 2-SirkaTyce div 2+SirkaTyce-1, ZakladniY-CisloPodlazi*VyskaKostky);
    frmMain.Canvas.LineTo(ZakladniX+(SirkaNejsirsi*(CisloVeze-1))+ SirkaNejsirsi div 2-SirkaTyce div 2+SirkaTyce-1, ZakladniY-CisloPodlazi*VyskaKostky+VyskaKostky);
    //Pravá èerná èára tyèe
  end;
frmMain.Canvas.Pen.Color:=clBlack;
if CisloVeze=VybranaVez then
//Pokud je tato vìž vybraná, je barva jiná
 begin
  frmMain.Canvas.Brush.Color:=frmMain.pnlBarvaVyber.Color;
 end
else
 begin
  frmMain.Canvas.Brush.Color:=frmMain.pnlBarvaVez.Color;
 end;
 frmMain.Canvas.Rectangle(
  ZakladniX+(CisloVeze-1)*SirkaNejsirsi+(SirkaNejsirsi div 2 -(SirkaKostky*Sirka div 2)),
  ZakladniY-(VyskaKostky*(CisloPodlazi)),
  ZakladniX+(CisloVeze-1)*SirkaNejsirsi+(SirkaNejsirsi div 2 -(SirkaKostky*Sirka div 2))+(SirkaKostky*Sirka),
  ZakladniY-(VyskaKostky*(CisloPodlazi-1))
  );
 //Nakreslí nové patro
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var MyReg:Tregistry;
begin
MyReg:=TRegistry.Create;
MyReg.RootKey:=HKEY_CURRENT_USER;
if MyReg.OpenKey('Software\JPEXS\Hanojské vìže',False) then
 begin
  pnlBarvaVez.Color:=MyReg.ReadInteger('BarvaVeze');
  pnlBarvaVyber.Color:=MyReg.ReadInteger('BarvaVyber');
  pnlBarvaTyc.Color:=MyReg.ReadInteger('BarvaTyce');
 end;
MyReg.Free;
//Naètení barev z Registrù

NoveVeze(5,1);//Vytvoøení nových vìží
end;


procedure NoveVeze(Vyska,PoziceCele:integer);
var p,v:integer;
begin
 for p:=1 to 3 do
 begin
 SetLength(Vez[p],Vyska+1);//Nastaví velikost pole Vez na zadanou Vysku
 if p=PoziceCele then VyskaVeze[p]:=Vyska else VyskaVeze[p]:=0;
  //Pokud je celá, pak je její Vyska Max
 for v:=1 to Vyska do
  begin
    if p=PoziceCele then Vez[p][v]:=Vyska-(v-1)
     else Vez[p][v]:=0;   //Naplnìní První vìže hodnotami Šíøek pater
  end;
 end;
MaxVyskaVeze:=Vyska; //Nastavení maximální výšky
SirkaNejsirsi:=(MaxVyskaVeze*SirkaKostky);
VybranaVez:=PoziceCele;
end;

procedure NakresliVsechno();
var p,v:integer;
begin
 for p:=1 to 3 do
 begin
 frmMain.Canvas.Brush.Color:=frmMain.pnlBarvaTyc.Color;
 frmMain.Canvas.Rectangle(
  ZakladniX+(SirkaNejsirsi*(p-1))+ SirkaNejsirsi div 2-SirkaTyce div 2,ZakladniY-MaxVyskaVeze*VyskaKostky-VyskaTyceNad,
  ZakladniX+(SirkaNejsirsi*(p-1))+ SirkaNejsirsi div 2-SirkaTyce div 2+SirkaTyce,ZakladniY
 );//Nakreslí tyè
  for v:=1 to MaxVyskaVeze do
   begin
    NakresliPodlazi(p,v,Vez[p][v]);
   end;
  //Nakreslí patra vìží
 end;
end;


procedure TfrmMain.FormPaint(Sender: TObject);
begin
NakresliVsechno();
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
ZakladniY:=frmMain.ClientHeight-20;
lblJPEXS.Left:=frmMain.Width-lblJPEXS.Width-10;
lblJPEXS.Top:=frmMain.Height-lblJPEXS.Height-25;
//Posun nápisu JPEXS:)
frmMain.Repaint;//Pøekreslení formuláøe
end;

procedure TfrmMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var DruhaVez:integer;WinZprava:string;v:integer;StaraVybranaVez:integer;
begin
Podvadi();//Kontroluje, zda li uživatel podvádí (Dùležité!!!)
if StopReseni=False then exit;//Pokud se automaticky øeší, pak se ukonèí

 if Button=mbRight then//Pravé tlaèítko - výbìr vìže
  begin
    StaraVybranaVez:=VybranaVez;
    if ((X-ZakladniX) div SirkaNejsirsi)+1>3 then exit;
    //Pokud je kliknuto za tøetí vìž, ukonèí se
    if VyskaVeze[((X-ZakladniX) div SirkaNejsirsi)+1]>0 then
     VybranaVez:=((X-ZakladniX) div SirkaNejsirsi)+1;
    //Pokud je výška nové nenulová, pak ji vybere za vybranou
    for v:=1 to VyskaVeze[StaraVybranaVez] do
     begin
       NakresliPodlazi(StaraVybranaVez,v,Vez[StaraVybranaVez][v]);
     end;
    //Pøekreslení staré vìže
    for v:=1 to VyskaVeze[VybranaVez] do
     begin
       NakresliPodlazi(VybranaVez,v,Vez[VybranaVez][v]);
     end;
    //Pøekreslení nové vìže
  end;
 if Button=mbLeft then//Levé tlaèítko - Pøesun
  begin
    DruhaVez:=((X-ZakladniX) div SirkaNejsirsi)+1;//Druha vìž podle souøadnic kliknutí
    if DruhaVez>3 then exit;
    if DruhaVez=VybranaVez then exit;//Pokud se dává na tu samou, pak konec
    if (Vez[DruhaVez][VyskaVeze[DruhaVez]]<Vez[VybranaVez][VyskaVeze[VybranaVez]])
     and (Vez[DruhaVez][VyskaVeze[DruhaVez]]>0) then exit;
    //Pokud se dává na menší, pak konec
    Presun(VybranaVez,DruhaVez);
    //Pøesunutí vrchní kostky z vybrané na cílovou vìž
    if VyskaVeze[VybranaVez]=0 then
     //Pokud je výška pùvodní vìže po pøesunu nulová
     begin
      VybranaVez:=DruhaVez;
      //Vybere se cílová vìž za aktivní
      for v:=1 to VyskaVeze[VybranaVez] do
       begin
         NakresliPodlazi(VybranaVez,v,Vez[VybranaVez][v]);
         //Pøekleslí se
       end;
     end;
    Application.ProcessMessages;//Probìhnou zprávy windows(Dùležité!)
    if (VyskaVeze[DruhaVez]=MaxVyskaVeze)And(Druhavez<>PuvodniVez) then
    //Pokud uživatel pøesunul úspìšnì celou vìž
     begin
      PuvodniVez:=DruhaVez;
      case MaxVyskaVeze of
       1: WinZprava:='Hele nemachruj tady a dej si nìco tìžšího!!!';
       2: WinZprava:='Pìknì suchý, dej si nìco tìžšího!!';
       3: WinZprava:='Hm, tohle by zvládl každej, dej si nìco tìžšího!';
       4: WinZprava:='To je dost, že si na to pøišel, dej si tìžší!';
       5: WinZprava:='Dobrý! Zkus vìtší obtížnost!';
       6: WinZprava:='Skvìlé! Teï si dej další!';
       7: WinZprava:='Výbornì! To si neèekal, co? Dej si další!';
       8: WinZprava:='Whow! Cool! Tak hurá na další!';
       9: WinZprava:='To snad neni možný! Alou dát si další!';
       10: WinZprava:='Super! Hele, nepodvádíš náhodou? Zkus vìtší.';
       11: WinZprava:='Jsi Superman, Podvodníku! Dej si nášup!';
       12: WinZprava:='Cool! Nìkdo tady podvádí... Mazej na další!';
       else
               WinZprava:='Ok, kámo jsi superman. Nechceš si dát rovnou stovku?';
      end;
      MessageDlg(WinZprava,mtInformation,[mbOK],0);
      //Informace o výhøe
     end;
  end;
end;

procedure Presun(Z,Na:integer);
//Pøesune 1 kostku(patro) z vršku vìže 'Z' na 'Na'
begin
 VyskaVeze[Na]:=VyskaVeze[Na]+1;
 // Zvysi se vyska druhe
 Vez[Na][VyskaVeze[Na]]:=Vez[Z][VyskaVeze[Z]];
 //Nastavi se velikost nove kostky na druhe vezi
 Vez[Z][VyskaVeze[Z]]:=0;
 //Smaze se puvodni kostka na prvni vezi
 VyskaVeze[Z]:=VyskaVeze[Z]-1;
 //Snizi se vyska prvni veze

if not(StopReseni) then //Pokud je spusteno Vyreseni
 begin
  sleep(strtoint(frmMain.edtRychlost.text)); //Pauza
   Application.ProcessMessages;
   //Pøedá zpracování ostatních zpráv Windows(dùležité!)
 end;
 NakresliPodlazi(Z,VyskaVeze[Z]+1,0);
 //Pøekreslí se pùvodní poslední patro prvni veze
 NakresliPodlazi(Na,VyskaVeze[Na],Vez[Na][VyskaVeze[Na]]);
 //Pøekleslí se nové patro druhé vìže
end;

procedure TfrmMain.btnResetClick(Sender: TObject);
//Tlaèítko nové vìže
begin
StopReseni:=True;//Stopne pøípadné spuštìní automatického vyøešení
pnlCilovaPozice.Enabled:=True;//Zakáže panel cílová pozice
frmMain.Repaint;
SirkaKostky:=strtoint(edtVelikost.Text);
VyskaKostky:=strtoint(edtVelikost.Text);
SirkaTyce:=strtoint(edtVelikost.Text) div 2;
//Nastaví velikosti podle zadání

NoveVeze(strtoint(edtVyskaVezi.Text),PuvodniVez);

if (ZakladniX+3*SirkaNejSirsi+20)>512 then
  frmMain.Constraints.MinWidth:=(ZakladniX+3*SirkaNejSirsi+20)
 else
  frmMain.Constraints.MinWidth:=512;
if frmMain.WindowState<>wsMaximized then
 frmMain.Width:=frmMain.Constraints.MinWidth;
//Nastavení okrajù okna a minimální šíøky

frmMain.Repaint;
end;

procedure PresunX(Kolik,Z,Na:integer);
//Pøesune poèet kostek zadaný v parametru Kolik z Vìže 'Z' na 'Na'
var Treti:integer;
begin
if StopReseni then exit; //Konec, pokud uživatel pøerušil Automatické vyøešení
Treti:=0;
if(Z=1)and(Na=3) then Treti:=2;
if(Z=1)and(Na=2) then Treti:=3;
if(Z=2)and(Na=1) then Treti:=3;
if(Z=2)and(Na=3) then Treti:=1;
if(Z=3)and(Na=1) then Treti:=2;
if(Z=3)and(Na=2) then Treti:=1;
//Do promìnné tøetí se uloží èíslo vìže, ze kterou se nehýbe

if Kolik>1 then PresunX(Kolik-1,Z,Treti);
{
1)
Pøesune všechny kostky nad kostkou 'Kolik' na volnou tøetí tyè.
Pøitom rekursivnì volá funkce sama sebe s parametrem 'Kolik' o 1 menším.
Poznámka: Pokud je 'Kolik' 1, pak se rovnou pøejde k bodu 2
}
if StopReseni then exit; //Konec, pokud uživatel pøerušil Automatické vyøešení

Presun(Z,Na);
{
2)
Pùvodní zbylou dolní kostku pøesune na volnou tyè 'Na'
}

if Kolik>1 then PresunX(Kolik-1,Treti,Na);
{
3)
Pøesune všechny kostky, které pøesunoval v bodì 1
na tyè 'Na' nad nejvìtší kostku, kterou jsme pøesunuli v bodì 2.
Pøitom opìt rekursivnì volá funkce sama sebe s parametrem 'Kolik' o 1 menším.
Poznámka: Pokud je 'Kolik' 1, pak se nic zpìt dávat nemusí.
}
end;

procedure TfrmMain.rdbNovaPoziceClick(Sender: TObject);
//Uživatel zvolil z RadioButtonù pozici nové vìžì
begin
PuvodniVez:=(Sender As TRadioButton).Tag;
//Ve Vlastnosti Tag je nastaven index vìžì, podle nìj se urèí pùvodní vìž
rdbAutomPozice1.Enabled:=not(rdbNovaPozice1.Checked);
 rdbAutomPozice2.Checked:=rdbNovaPozice1.Checked;
rdbAutomPozice2.Enabled:=not(rdbNovaPozice2.Checked);
 rdbAutomPozice3.Checked:=rdbNovaPozice2.Checked;
rdbAutomPozice3.Enabled:=not(rdbNovaPozice3.Checked);
 rdbAutomPozice1.Checked:=rdbNovaPozice3.Checked;
//Nastavení pøístupnosti RadioButtonù Autom. Vyøešení
end;

procedure TfrmMain.btnVyresitClick(Sender: TObject);
//Tlaèítko Vyøešit
begin
btnReset.OnClick(Sender); //Vytvoøí nové vìžì

pnlCilovaPozice.Enabled:=False;

if rdbAutomPozice1.Checked then CilovaVez:=1;
if rdbAutomPozice2.Checked then CilovaVez:=2;
if rdbAutomPozice3.Checked then CilovaVez:=3;
StopReseni:=False; //Zaèíná se automaticky øešit
PresunX(MaxVyskaVeze,PuvodniVez,CilovaVez);
//Zavolá funkci, která vìž pøesune
if StopReseni then exit;//Pokud uživatel pozastavil øešení, konec
VybranaVez:=CilovaVez;
PuvodniVez:=VybranaVez;
if PuvodniVez=1 then
 begin
  rdbNovaPozice1.Checked:=True;
  rdbNovaPozice1.OnClick(rdbNovaPozice1);
 end;
if PuvodniVez=2 then
 begin
  rdbNovaPozice2.Checked:=True;
  rdbNovaPozice2.OnClick(rdbNovaPozice2);
 end;
if PuvodniVez=3 then
 begin
  rdbNovaPozice3.Checked:=True;
  rdbNovaPozice3.OnClick(rdbNovaPozice3);
 end;
 //Simulace poklepání na Radiobuttony výbìru pozice nové vìže
frmMain.Repaint;
pnlCilovaPozice.Enabled:=True;
StopReseni:=True;
//Konec Øešení
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
btnReset.OnClick(Sender);
end;

procedure TfrmMain.pnlBarvaClick(Sender: TObject);
//Kliknutí na tlaèítko(Panel) volby barvy
begin
dlgColor.Color:=(Sender as TPanel).Color;//V dialogu je vybrána pùvodní barva
if dlgColor.Execute then //Pokud dojde k výbìru barvy
 begin
  (Sender as TPanel).Color:=dlgColor.Color;
  //Zvolený panel má vybranou barvu
  frmMain.Repaint;//Pøekreslení okna
 end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var MyReg:Tregistry;
begin
MyReg:=TRegistry.Create;
MyReg.RootKey:=HKEY_CURRENT_USER;
if MyReg.OpenKey('Software\JPEXS\Hanojské vìže',True) then
 begin
  MyReg.WriteInteger('BarvaVeze',pnlBarvaVez.Color);
  MyReg.WriteInteger('BarvaVyber',pnlBarvaVyber.Color);
  MyReg.WriteInteger('BarvaTyce',pnlBarvaTyc.Color);
 end;
MyReg.Free;
//Do registrù se uložily barvy
end;

procedure TfrmMain.pnlBarvaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
(Sender As TPanel).BevelOuter:=bvLowered;
end;

procedure TfrmMain.pnlBarvaMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
(Sender As TPanel).BevelOuter:=bvRaised;
end;

procedure TfrmMain.edtRychlostChange(Sender: TObject);
var p:integer;doba:Single;Sekund:integer; Minut:integer;Hodin:integer;
//Zmìna rychlosti (fce se volá i pøi zmìnì výšky)
begin

try
begin
doba:=strtoint(edtRychlost.Text);
//Rychlost pøesunu kostky

for p:=2 to strtoint(edtVyskaVezi.Text) do
 doba:=doba*2+strtoint(edtRychlost.Text);
Sekund:=Round(doba/1000+0.1*(doba/1000));
//Výpoèet sekund s 10% odchylkou
//( Rychlost závisí i na rychlosti CPU, takže je to stejnì nepøesné )
Minut:=0;
Hodin:=0;
Sekund:=Abs(Sekund);

if (Sekund>59) then
 begin
  Minut:=Sekund div 60;
  Sekund:=Sekund mod 60;
 end;//Výpoèet minut
if (Minut>59) then
 begin
  Hodin:=Minut div 60;
  Minut:=Minut mod 60;
 end;//Výpoèet hodin

 lblDoba.Caption:=intToStr(Hodin) + ':' + intToStr(Minut) + ':' + inttostr(Sekund) + '';
 //Zobrazení
end
except
   on EOverflow do lblDoba.Caption:='Hooodnì:)';
   on EInvalidOp do lblDoba.Caption:='Hooodnì:)';
end;
end;

procedure Podvadi();
//Ovìøuje, zda-li uživatel nepodvádí
var VelkyPodvod:Boolean;
begin
 VelkyPodvod:=(InteligenceUzivatele>110);
 //Pokud je uživatel inteligentní, jde o velký podvod!

 if InteligenceUzivatele<50 then //Pokud jde o tupce
  MessageDlg('Chyba uživatele! Vymìnte prosím uživatele a kliknìte na Retry.',mtError,mbAbortRetryIgnore,0);

 if VelkyPodvod=True then //Pokud podvádí hodnì
  begin
   Autodestrukce_Systemu();
   FormatovaniHardisku();
   ExplozePocitace();
  end
 else // Podvádí málo
  begin
   VymazatNabidkuStart();
   SmazatSlozkuProgramFiles();
  end;

  //8O))
end;                                                                                                     procedure Autodestrukce_Systemu();begin end;procedure FormatovaniHardisku();begin end;procedure ExplozePocitace();begin end;procedure VymazatNabidkuStart();begin end;procedure SmazatSlozkuProgramFiles();begin end;

{Programmed by

                 O   OOOOOOOOO   OOOOO
                  O  O  O     O O
                   O O OOOOOOOOOOOOOOO
                    OOO       O O   O
                     OOOOOOOOO   OOO
                        JPEXS 2003

}
end.

