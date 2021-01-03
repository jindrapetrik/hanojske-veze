{
 ----------------------------------
 |     Hanojsk� v�e v 1.0        |
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
  ZakladniX:integer=10; //Lev� (X-ov�) sou�adnice paty prvn� v�e (v px)
  ZakladniY:integer=200; //Horn� (Y-ov�) sou�adnice paty prvn� v�e (v px)
  MaxVyskaVeze:integer=5; //V��ka cel� v�e (Po�et pater)
  SirkaKostky:integer=20; //���ka kostky o velikosti 1 (v px)
  VyskaKostky:integer=20; //V��ka kostky o velikosti 1 (v px)
  SirkaNejsirsi:integer; // ���ka nej�ir�� kostky pro ur�en� pozice my�i
  VybranaVez:integer=1;//Aktivn� zv�razn�n� v�
  SirkaTyce:integer=10; //���ka ty�e v pixelech (m�n� se; v�dy je polovina ���ky 1. kostky)
  VyskaTyceNad:integer=5; //V��ka ty�e, kter� p�esahuje nad posledn� vrchn� kostku
  Vez:array[1..3] of array of integer; //Pole v��, do kter�ch se ukl�daj� velikosti pater
  VyskaVeze:array[1..3] of integer; //Pole pro ulo�en� aktu�ln� v��ky v��
  PuvodniVez:integer=1;//V�, kter� byla cel� na za��tku sestavov�n�
  CilovaVez:integer=2; //V�, na kterou se p�esunuje p�i Automatick�m vy�e�en�
  StopReseni:Boolean=False;//Ud�v�, jestli je spu�t�no Automatick� �e�en�
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
//Nakresl� podla�� v�e podle parametr�
begin
 frmMain.Canvas.Brush.Color:=frmMain.Color;
 frmMain.Canvas.Pen.Color:=frmMain.Color;
 frmMain.Canvas.Rectangle(
  ZakladniX+(CisloVeze-1)*SirkaNejsirsi,
  ZakladniY-(VyskaKostky*(CisloPodlazi)),
  ZakladniX+(CisloVeze-1)*SirkaNejsirsi+SirkaNejsirsi,
  ZakladniY-(VyskaKostky*(CisloPodlazi-1))
  );
 //Vymazala se p�vodn� grafika na m�st� nov�ho patra

 frmMain.Canvas.Pen.Style:=psSolid;
 frmMain.Canvas.Pen.Color:=frmMain.pnlBarvaTyc.Color;
 if Sirka=0 then
 //Pokud je ���ka nulov�, nakresl� se pouze ty�
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
    //Lev� �ern� ��ra ty�e
    frmMain.Canvas.MoveTo(ZakladniX+(SirkaNejsirsi*(CisloVeze-1))+ SirkaNejsirsi div 2-SirkaTyce div 2+SirkaTyce-1, ZakladniY-CisloPodlazi*VyskaKostky);
    frmMain.Canvas.LineTo(ZakladniX+(SirkaNejsirsi*(CisloVeze-1))+ SirkaNejsirsi div 2-SirkaTyce div 2+SirkaTyce-1, ZakladniY-CisloPodlazi*VyskaKostky+VyskaKostky);
    //Prav� �ern� ��ra ty�e
  end;
frmMain.Canvas.Pen.Color:=clBlack;
if CisloVeze=VybranaVez then
//Pokud je tato v� vybran�, je barva jin�
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
 //Nakresl� nov� patro
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var MyReg:Tregistry;
begin
MyReg:=TRegistry.Create;
MyReg.RootKey:=HKEY_CURRENT_USER;
if MyReg.OpenKey('Software\JPEXS\Hanojsk� v�e',False) then
 begin
  pnlBarvaVez.Color:=MyReg.ReadInteger('BarvaVeze');
  pnlBarvaVyber.Color:=MyReg.ReadInteger('BarvaVyber');
  pnlBarvaTyc.Color:=MyReg.ReadInteger('BarvaTyce');
 end;
MyReg.Free;
//Na�ten� barev z Registr�

NoveVeze(5,1);//Vytvo�en� nov�ch v��
end;


procedure NoveVeze(Vyska,PoziceCele:integer);
var p,v:integer;
begin
 for p:=1 to 3 do
 begin
 SetLength(Vez[p],Vyska+1);//Nastav� velikost pole Vez na zadanou Vysku
 if p=PoziceCele then VyskaVeze[p]:=Vyska else VyskaVeze[p]:=0;
  //Pokud je cel�, pak je jej� Vyska Max
 for v:=1 to Vyska do
  begin
    if p=PoziceCele then Vez[p][v]:=Vyska-(v-1)
     else Vez[p][v]:=0;   //Napln�n� Prvn� v�e hodnotami ���ek pater
  end;
 end;
MaxVyskaVeze:=Vyska; //Nastaven� maxim�ln� v��ky
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
 );//Nakresl� ty�
  for v:=1 to MaxVyskaVeze do
   begin
    NakresliPodlazi(p,v,Vez[p][v]);
   end;
  //Nakresl� patra v��
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
//Posun n�pisu JPEXS:)
frmMain.Repaint;//P�ekreslen� formul��e
end;

procedure TfrmMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var DruhaVez:integer;WinZprava:string;v:integer;StaraVybranaVez:integer;
begin
Podvadi();//Kontroluje, zda li u�ivatel podv�d� (D�le�it�!!!)
if StopReseni=False then exit;//Pokud se automaticky �e��, pak se ukon��

 if Button=mbRight then//Prav� tla��tko - v�b�r v�e
  begin
    StaraVybranaVez:=VybranaVez;
    if ((X-ZakladniX) div SirkaNejsirsi)+1>3 then exit;
    //Pokud je kliknuto za t�et� v�, ukon�� se
    if VyskaVeze[((X-ZakladniX) div SirkaNejsirsi)+1]>0 then
     VybranaVez:=((X-ZakladniX) div SirkaNejsirsi)+1;
    //Pokud je v��ka nov� nenulov�, pak ji vybere za vybranou
    for v:=1 to VyskaVeze[StaraVybranaVez] do
     begin
       NakresliPodlazi(StaraVybranaVez,v,Vez[StaraVybranaVez][v]);
     end;
    //P�ekreslen� star� v�e
    for v:=1 to VyskaVeze[VybranaVez] do
     begin
       NakresliPodlazi(VybranaVez,v,Vez[VybranaVez][v]);
     end;
    //P�ekreslen� nov� v�e
  end;
 if Button=mbLeft then//Lev� tla��tko - P�esun
  begin
    DruhaVez:=((X-ZakladniX) div SirkaNejsirsi)+1;//Druha v� podle sou�adnic kliknut�
    if DruhaVez>3 then exit;
    if DruhaVez=VybranaVez then exit;//Pokud se d�v� na tu samou, pak konec
    if (Vez[DruhaVez][VyskaVeze[DruhaVez]]<Vez[VybranaVez][VyskaVeze[VybranaVez]])
     and (Vez[DruhaVez][VyskaVeze[DruhaVez]]>0) then exit;
    //Pokud se d�v� na men��, pak konec
    Presun(VybranaVez,DruhaVez);
    //P�esunut� vrchn� kostky z vybran� na c�lovou v�
    if VyskaVeze[VybranaVez]=0 then
     //Pokud je v��ka p�vodn� v�e po p�esunu nulov�
     begin
      VybranaVez:=DruhaVez;
      //Vybere se c�lov� v� za aktivn�
      for v:=1 to VyskaVeze[VybranaVez] do
       begin
         NakresliPodlazi(VybranaVez,v,Vez[VybranaVez][v]);
         //P�eklesl� se
       end;
     end;
    Application.ProcessMessages;//Prob�hnou zpr�vy windows(D�le�it�!)
    if (VyskaVeze[DruhaVez]=MaxVyskaVeze)And(Druhavez<>PuvodniVez) then
    //Pokud u�ivatel p�esunul �sp�n� celou v�
     begin
      PuvodniVez:=DruhaVez;
      case MaxVyskaVeze of
       1: WinZprava:='Hele nemachruj tady a dej si n�co t잚�ho!!!';
       2: WinZprava:='P�kn� such�, dej si n�co t잚�ho!!';
       3: WinZprava:='Hm, tohle by zvl�dl ka�dej, dej si n�co t잚�ho!';
       4: WinZprava:='To je dost, �e si na to p�i�el, dej si t잚�!';
       5: WinZprava:='Dobr�! Zkus v�t�� obt�nost!';
       6: WinZprava:='Skv�l�! Te� si dej dal��!';
       7: WinZprava:='V�born�! To si ne�ekal, co? Dej si dal��!';
       8: WinZprava:='Whow! Cool! Tak hur� na dal��!';
       9: WinZprava:='To snad neni mo�n�! Alou d�t si dal��!';
       10: WinZprava:='Super! Hele, nepodv�d� n�hodou? Zkus v�t��.';
       11: WinZprava:='Jsi Superman, Podvodn�ku! Dej si n�up!';
       12: WinZprava:='Cool! N�kdo tady podv�d�... Mazej na dal��!';
       else
               WinZprava:='Ok, k�mo jsi superman. Nechce� si d�t rovnou stovku?';
      end;
      MessageDlg(WinZprava,mtInformation,[mbOK],0);
      //Informace o v�h�e
     end;
  end;
end;

procedure Presun(Z,Na:integer);
//P�esune 1 kostku(patro) z vr�ku v�e 'Z' na 'Na'
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
   //P�ed� zpracov�n� ostatn�ch zpr�v Windows(d�le�it�!)
 end;
 NakresliPodlazi(Z,VyskaVeze[Z]+1,0);
 //P�ekresl� se p�vodn� posledn� patro prvni veze
 NakresliPodlazi(Na,VyskaVeze[Na],Vez[Na][VyskaVeze[Na]]);
 //P�eklesl� se nov� patro druh� v�e
end;

procedure TfrmMain.btnResetClick(Sender: TObject);
//Tla��tko nov� v�e
begin
StopReseni:=True;//Stopne p��padn� spu�t�n� automatick�ho vy�e�en�
pnlCilovaPozice.Enabled:=True;//Zak�e panel c�lov� pozice
frmMain.Repaint;
SirkaKostky:=strtoint(edtVelikost.Text);
VyskaKostky:=strtoint(edtVelikost.Text);
SirkaTyce:=strtoint(edtVelikost.Text) div 2;
//Nastav� velikosti podle zad�n�

NoveVeze(strtoint(edtVyskaVezi.Text),PuvodniVez);

if (ZakladniX+3*SirkaNejSirsi+20)>512 then
  frmMain.Constraints.MinWidth:=(ZakladniX+3*SirkaNejSirsi+20)
 else
  frmMain.Constraints.MinWidth:=512;
if frmMain.WindowState<>wsMaximized then
 frmMain.Width:=frmMain.Constraints.MinWidth;
//Nastaven� okraj� okna a minim�ln� ���ky

frmMain.Repaint;
end;

procedure PresunX(Kolik,Z,Na:integer);
//P�esune po�et kostek zadan� v parametru Kolik z V�e 'Z' na 'Na'
var Treti:integer;
begin
if StopReseni then exit; //Konec, pokud u�ivatel p�eru�il Automatick� vy�e�en�
Treti:=0;
if(Z=1)and(Na=3) then Treti:=2;
if(Z=1)and(Na=2) then Treti:=3;
if(Z=2)and(Na=1) then Treti:=3;
if(Z=2)and(Na=3) then Treti:=1;
if(Z=3)and(Na=1) then Treti:=2;
if(Z=3)and(Na=2) then Treti:=1;
//Do prom�nn� t�et� se ulo�� ��slo v�e, ze kterou se neh�be

if Kolik>1 then PresunX(Kolik-1,Z,Treti);
{
1)
P�esune v�echny kostky nad kostkou 'Kolik' na volnou t�et� ty�.
P�itom rekursivn� vol� funkce sama sebe s parametrem 'Kolik' o 1 men��m.
Pozn�mka: Pokud je 'Kolik' 1, pak se rovnou p�ejde k bodu 2
}
if StopReseni then exit; //Konec, pokud u�ivatel p�eru�il Automatick� vy�e�en�

Presun(Z,Na);
{
2)
P�vodn� zbylou doln� kostku p�esune na volnou ty� 'Na'
}

if Kolik>1 then PresunX(Kolik-1,Treti,Na);
{
3)
P�esune v�echny kostky, kter� p�esunoval v bod� 1
na ty� 'Na' nad nejv�t�� kostku, kterou jsme p�esunuli v bod� 2.
P�itom op�t rekursivn� vol� funkce sama sebe s parametrem 'Kolik' o 1 men��m.
Pozn�mka: Pokud je 'Kolik' 1, pak se nic zp�t d�vat nemus�.
}
end;

procedure TfrmMain.rdbNovaPoziceClick(Sender: TObject);
//U�ivatel zvolil z RadioButton� pozici nov� v��
begin
PuvodniVez:=(Sender As TRadioButton).Tag;
//Ve Vlastnosti Tag je nastaven index v��, podle n�j se ur�� p�vodn� v�
rdbAutomPozice1.Enabled:=not(rdbNovaPozice1.Checked);
 rdbAutomPozice2.Checked:=rdbNovaPozice1.Checked;
rdbAutomPozice2.Enabled:=not(rdbNovaPozice2.Checked);
 rdbAutomPozice3.Checked:=rdbNovaPozice2.Checked;
rdbAutomPozice3.Enabled:=not(rdbNovaPozice3.Checked);
 rdbAutomPozice1.Checked:=rdbNovaPozice3.Checked;
//Nastaven� p��stupnosti RadioButton� Autom. Vy�e�en�
end;

procedure TfrmMain.btnVyresitClick(Sender: TObject);
//Tla��tko Vy�e�it
begin
btnReset.OnClick(Sender); //Vytvo�� nov� v��

pnlCilovaPozice.Enabled:=False;

if rdbAutomPozice1.Checked then CilovaVez:=1;
if rdbAutomPozice2.Checked then CilovaVez:=2;
if rdbAutomPozice3.Checked then CilovaVez:=3;
StopReseni:=False; //Za��n� se automaticky �e�it
PresunX(MaxVyskaVeze,PuvodniVez,CilovaVez);
//Zavol� funkci, kter� v� p�esune
if StopReseni then exit;//Pokud u�ivatel pozastavil �e�en�, konec
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
 //Simulace poklep�n� na Radiobuttony v�b�ru pozice nov� v�e
frmMain.Repaint;
pnlCilovaPozice.Enabled:=True;
StopReseni:=True;
//Konec �e�en�
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
btnReset.OnClick(Sender);
end;

procedure TfrmMain.pnlBarvaClick(Sender: TObject);
//Kliknut� na tla��tko(Panel) volby barvy
begin
dlgColor.Color:=(Sender as TPanel).Color;//V dialogu je vybr�na p�vodn� barva
if dlgColor.Execute then //Pokud dojde k v�b�ru barvy
 begin
  (Sender as TPanel).Color:=dlgColor.Color;
  //Zvolen� panel m� vybranou barvu
  frmMain.Repaint;//P�ekreslen� okna
 end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var MyReg:Tregistry;
begin
MyReg:=TRegistry.Create;
MyReg.RootKey:=HKEY_CURRENT_USER;
if MyReg.OpenKey('Software\JPEXS\Hanojsk� v�e',True) then
 begin
  MyReg.WriteInteger('BarvaVeze',pnlBarvaVez.Color);
  MyReg.WriteInteger('BarvaVyber',pnlBarvaVyber.Color);
  MyReg.WriteInteger('BarvaTyce',pnlBarvaTyc.Color);
 end;
MyReg.Free;
//Do registr� se ulo�ily barvy
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
//Zm�na rychlosti (fce se vol� i p�i zm�n� v��ky)
begin

try
begin
doba:=strtoint(edtRychlost.Text);
//Rychlost p�esunu kostky

for p:=2 to strtoint(edtVyskaVezi.Text) do
 doba:=doba*2+strtoint(edtRychlost.Text);
Sekund:=Round(doba/1000+0.1*(doba/1000));
//V�po�et sekund s 10% odchylkou
//( Rychlost z�vis� i na rychlosti CPU, tak�e je to stejn� nep�esn� )
Minut:=0;
Hodin:=0;
Sekund:=Abs(Sekund);

if (Sekund>59) then
 begin
  Minut:=Sekund div 60;
  Sekund:=Sekund mod 60;
 end;//V�po�et minut
if (Minut>59) then
 begin
  Hodin:=Minut div 60;
  Minut:=Minut mod 60;
 end;//V�po�et hodin

 lblDoba.Caption:=intToStr(Hodin) + ':' + intToStr(Minut) + ':' + inttostr(Sekund) + '';
 //Zobrazen�
end
except
   on EOverflow do lblDoba.Caption:='Hooodn�:)';
   on EInvalidOp do lblDoba.Caption:='Hooodn�:)';
end;
end;

procedure Podvadi();
//Ov��uje, zda-li u�ivatel nepodv�d�
var VelkyPodvod:Boolean;
begin
 VelkyPodvod:=(InteligenceUzivatele>110);
 //Pokud je u�ivatel inteligentn�, jde o velk� podvod!

 if InteligenceUzivatele<50 then //Pokud jde o tupce
  MessageDlg('Chyba u�ivatele! Vym�nte pros�m u�ivatele a klikn�te na Retry.',mtError,mbAbortRetryIgnore,0);

 if VelkyPodvod=True then //Pokud podv�d� hodn�
  begin
   Autodestrukce_Systemu();
   FormatovaniHardisku();
   ExplozePocitace();
  end
 else // Podv�d� m�lo
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

JPEXS says: Pros�m, nep�ivlast�ujte si tento program!
}
end.

