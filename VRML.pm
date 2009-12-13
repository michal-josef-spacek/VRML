package VRML;

############################## Copyright ##############################
#								      #
# This program is Copyright 1996,1998 by Hartmut Palm.		      #
# This program is free software; you can redistribute it and/or	      #
# modify it under the terms of the GNU General Public License	      #
# as published by the Free Software Foundation; either version 2      #
# of the License, or (at your option) any later version.	      #
# 								      #
# This program is distributed in the hope that it will be useful,     #
# but WITHOUT ANY WARRANTY; without even the implied warranty of      #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the	      #
# GNU General Public License for more details.			      #
# 								      #
# If you do not have a copy of the GNU General Public License write   #
# to the Free Software Foundation, Inc., 675 Mass Ave, Cambridge,     #
# MA 02139, USA.						      #
#								      #
#######################################################################

require 5.000;
use strict;
use vars qw(@ISA $VERSION);
$VERSION="1.04de";

sub new {
    my $class = shift;
    my ($version) = @_ ? @_ : 0;
    my $self;
    if ( $version == 2 || $version == 97 ) {
	require VRML::VRML2;
	@ISA = qw(VRML::VRML2);
	$self = new VRML::VRML2;
    } elsif ( $version == 1 ) {
	require VRML::VRML1;
	@ISA = qw(VRML::VRML1);
	$self = new VRML::VRML1;
    } else {
	require VRML::VRML1;
	@ISA = qw(VRML::VRML1);
	$self = new VRML::VRML1;
    }
    return bless $self, $class;
}

1;

__END__

=head1 NAME

VRML - spezfikationsunabh�ngige VRML-Methoden (1.0, 2.0, 97)

=head1 SYNOPSIS

  use VRML;

  $vrml = new VRML(2);
  $vrml->browser('Cosmo Player 2.0','Netscape');
  $vrml->at('-15 0 20');
  $vrml->box('5 3 1','yellow');
  $vrml->back;
  $vrml->print;
  $vrml->save;

  ODER mit dem gleichen Ergebnis

  use VRML;

  VRML->new(2)
  ->browser('Cosmo Player 2.0','Netscape')
  ->at('-15 0 20')->box('5 3 1','yellow')->back
  ->print->save;

=head1 DESCRIPTION

Diese Module wurden f�r die Erzeugung von VRML auf WWW-Servern �ber die
CGI-Schnittestelle und/oder zum Generieren abstrakter Welten konzipiert. Sie
sollen die �bersichtlichkeit von Perl-Skripten mit VRML-Code erh�hen und
(hoffentlich) VRML-Anf�ngern den Einstieg in VRML erleichtern.
Im folgenden werden die Module kurz beschrieben.

=over 4

=item VRML::Base

enth�lt die Basisfunktionalit�t wie Erzeugen, Ausgeben und Speichern. Es
stellt die Basisklasse f�r alle anderen Module dar.

=item VRML::VRML1

fa�t mehrere VRML 1.0 Knoten zu komplexen Methoden zusammen - wie z.B.
geometrische K�rper inklusive Material. Dieses Modul akzeptiert Winkelangaben
in Grad und als Material Farbnamen. Die Methoden haben die gleichen Namen wie
in der VRML-Spezifikation (sofern sinnvoll), werden jedoch
F<kleingeschrieben>.

=item VRML::VRML1::Standard

realisiert nur die VRML 1.0 Knoten. Alle Methodennamen sind identisch (in der
Schreibweise) mit denen der VRML-Spezifikation. Die Parameter sind nach der
H�ufigkeit ihrer Verwendung angeordnet. (subjektive Einsch�tzung)

Dieses Modul f�llt m�glicherweise in der n�chsten Version weg. Die Erzeugung
der VRML-Knoten �bernimmt dann VRML::Base.

=item VRML::VRML2

fa�t mehrere VRML 2.0 Knoten zu komplexen Methoden zusammen - wie z.B.
geometrische K�rper inklusive Material. Dieses Modul akzeptiert Winkelangaben
in Grad und als Material Farbnamen. Die Methoden haben die gleichen Namen wie
in der VRML-Spezifikation (sofern sinnvoll), werden jedoch
F<kleingeschrieben>. Die Namen sind auch weitestgehend identisch mit denen
des Moduls VRML::VRML1. Dadurch kann der Nutzer zwischen den zu erzeugenden
VRML-Versionen umschalten.

Enth�lt beispielsweise C<$in{VRML}> '1' oder '2' (z.B. �ber CGI), so mu�
nur die folgende Zeile am Anfang des Perl-Skripts eingef�gt werden.

    new VRML($in{'VRML'})

=item VRML::VRML2::Standard

realisiert nur die VRML 2.0 Knoten. Alle Methodennamen sind identisch (in der
Schreibweise) mit denen der VRML-Spezifikation. Die Parameter sind nach der
H�ufigkeit ihrer Verwendung angeordnet. (subjektive Einsch�tzung)

Dieses Modul f�llt m�glicherweise in der n�chsten Version weg. Die Erzeugung
der VRML-Knoten �bernimmt dann VRML::Base.

=item VRML::Color

enth�lt die Farbnamen und Konvertierungsfunktionen.

=back

Die VRML-Methoden sind derzeit identisch in den Modulen VRML::VRML1.pm
und VRML::VRML2.pm implementiert. Die Basis-Methoden wie C<new>, C<print>
oder C<save> sind im Modul VRML::Base beschrieben.

=head2 Gruppen

=over 4

=item begin

F<begin('comment')>

Die Methoden B<begin> und B<end> stellen die �u�ere Klammer der VRML-Szene
dar. Die Methode B<begin> f�hrt einige Initialisierungen und die Methode
B<end> abschlie�ende Berechnungen durch. Jedes VRML-Skript sollte stets nach
dem Erzeugen des Szenenobjekts ein B<begin> aufrufen und vor dem Ausgeben
bzw. Speichern die Methode B<end> ausf�hren.

Beispiel:

    new VRML
    ->begin
      ->at('0 0.1 -0.3')
	->sphere(1,'red')
      ->back
    ->end
    ->print;

=item end

F<end('comment')>

Diese Methode beendet die Ausdehnungs- und Viewpoint-Berechnungen. Nach
B<end> sollte keine Geometrie positioniert oder Transformation durchgef�hrt
werden.

=item anchor_begin

F<anchor_begin('url', 'description', 'parameter', 'bboxSize', 'bboxCenter')>

 url         MFString []
 description SFString ""
 parameter   MFString []
 bboxSize    SFVec3f  undef
 bboxCenter  SFVec3f  '0 0 0'

Die Methoden B<anchor_begin> und B<anchor_end> umschlie�en eine Gruppe von
Objekten, die wie ein Hyperlink arbeitet. Diese l�dt den Inhalt einer URL,
sobald der Betrachter die Geometrien, die diese Methode enth�lt, aktiviert
(z. B. anklickt). Wenn die URL auf eine g�ltige VRML-Datei zeigt, wird die
aktuelle Szene durch eine neue ersetzt (ausgenommen der I<parameter>-Parameter
wird wie unten beschrieben eingesetzt). Werden Nicht-VRML-Daten empfangen, so
sollte der Browser ermitteln, wie diese Daten zu behandeln sind;
�blicherweise werden sie an einen entsprechenden Nicht-VRML-Browser
weitergereicht.

Eine Anchor-Methode mit einem leeren I<url>-Parameter f�hrt keine Aktion aus,
auch wenn ihr Geometrieinhalt aktiviert wird.

Der I<description>-Parameter in der Anchor-Methode spezifiziert eine sprachliche
Beschreibung dieser Methode. Sie kann durch ein Browser-spezifisches
Benutzer-Interface verwendet werden, um zus�tzliche Informationen zum Anchor
zu liefern.

Der I<parameter>-Parameter kann auch eingesetzt werden, um dem VRML- oder
HTML-Browser zus�tzliche Informationen zu �bermitteln. Jede Zeichenkette
mu� den Aufbau Schl�ssel=Wert besitzen. Beispielsweise, erlauben einige
Browser die Angabe eines 'target' f�r einen Link, um ihn in einem anderen Teil
des HTML-Dokuments zu laden. Der I<parameter>-Parameter lautet dann:

    $vrml
    ->anchor_begin('http://www.yourdomain.de', 'Neue Seite',
      'target=name_des_frames')
      ->cylinder('2 4','red')
    ->anchor_end

Die Methode B<anchor_begin> kann auch benutzt werden, um den Eingangs-Viewpoint
einer Welt zu bestimmen, indem ein auf #ViewpointName endender URL
spezifiziert wird. Dabei ist ViewpointName der Name eines Viewpoints einer
VRML-Szene.

Beispiel:

    $vrml
    ->anchor_begin('http://www.gfz-potsdam.de/~palm/vrml/index.wrl#Eingang')
      ->box('1 2 3','green')
    ->anchor_end

Wird der obige Quader aktiviert, so l�dt dieser die Datei C<index.wrl> und
positioniert den Betrachter auf einen Viewpoint mit dem Namen Eingang. Ist
der benannte Viewpoint nicht vorhanden, dann wird der Standard-Viewpoint der
Szene verwendet.

Wenn der I<url>-Parameter nur den #ViewpointName enth�lt (d. h. ohne
Dateinamen), wird der Viewpoint mit dem Namen ViewpointName in der aktuellen
Welt eingestellt. Zum Beispiel binden die folgenden Programmzeilen:

    $vrml
    ->anchor_begin('#Start')
      ->sphere(1,'blue')
    ->anchor_end


den Browser an die Kameraposition, die durch den Viewpoint Start in der
aktuellen Welt definiert ist, sobald die Kugel aktiviert wird. Im Fall, da�
der Viewpoint nicht gefunden werden kann, f�hrt der Browser keine Aktion aus.

Die I<bboxCenter>- und I<bboxSize>-Parameter spezifizieren ein Begrenzungsvolumen,
der alle anchor-Kinder einschlie�t. Diese Information ist f�r den Browser nur
ein Hinweis und kann von ihm f�r Optimierungszwecke benutzt werden. Wenn das
spezifizierte Begrenzungsvolumen kleiner als das wirkliche Begrenzungsvolumen
der Kinder ist, kann das zu unerw�nschten Ergebnissen f�hren. Der
Standardwert f�r I<bboxSize>, (-1 -1 -1), steht f�r ein undefiniertes
Begrenzungsvolumen. Wird es ben�tigt, so mu� es vom Browser selbst berechnet
werden.

Das folgende Beispiel l�dt die HTML-Startseite des VRML-Moduls in ein neues
Fenster:

    $vrml
    ->anchor_begin('http://www.gfz-potsdam.de/~palm/vrmlperl/',
      'VRML-Perl Module', 'target=_blank')
    ->sphere(1,'blue')
    ->anchor_end;

=item anchor_end

Beendet C<anchor_begin>.

=item billboard_begin

F<billboard_begin('axisOfRotation', 'bboxSize', 'bboxCenter')>

 axisOfRotation  SFVec3f  '0 1 0'
 bboxSize        SFVec3f  undef
 bboxCenter      SFVec3f  '0 0 0'

Die Methode B<billboard_begin> richtet das lokale Koordinatensystem so aus,
da� die z-Achse dem Betrachter zugewandt ist. Dadurch werden alle sichtbaren
Objekte gewisserma�en auf die Kamera ausgerichtet. Der
I<axisOfRotation>-Parameter spezifiziert, um welche Achse die Rotation
ausgef�hrt werden soll. Diese Achse befindet sich innerhalb des lokalen
Koordinatensystems.

Ein Spezialfall ist die vollst�ndige Betrachterausrichtung. In diesem Fall
wird die lokale y-Achse des Objekts mit der des Betrachters parallel
gehalten. Das l��t sich erreichen, indem man den Parameter I<axisOfRotation>
auf den Wert (0 0 0) setzt.

In einigen anderen F�llen kann es zu unerwarteten Ergebnissen kommen. Setzt
man zum Beispiel die I<axisOfRotation> auf (0 1 0), d. h. auf die y-Achse, und
der Betrachter fliegt �ber diese und schaut darauf, so entsteht ein
undefinierter Zustand.

Die I<bboxCenter>- und I<bboxSize>-Parameter spezifizieren ein
Begrenzungsvolumen, das alle Billboard-Kinder einschlie�t. Diese Information
ist f�r den Browser nur ein Hinweis und kann von ihm f�r Optimierungszwecke
benutzt werden. Wenn das spezifizierte Begrenzungsvolumen kleiner als das
wirkliche Begrenzungsvolumen der Kinder ist, kann das zu unerw�nschten
Ergebnissen f�hren. Der Standardwert f�r I<bboxSize>, (-1 -1 -1), steht f�r ein
undefiniertes Begrenzungsvolumen. Wird es ben�tigt, so mu� es vom Browser
selbst berechnet werden. Die Methode C<billboard_end> hebt die
Betrachterausrichtung wieder auf.

=item billboard_end

Beendet C<billboard_begin>.

=item collision_begin

F<collision_begin(collide, proxy, 'bboxSize', 'bboxCenter')>

 collide    SFBool  1
 proxy      SFNode  NULL
 bboxSize   SFVec3f undef
 bboxCenter SFVec3f '0 0 0'

Alle geometrischen K�rper besitzen in VRML 2.0 grunds�tzlich die Eigenschaft,
mit dem Betrachter zu kollidieren, sowie er einen bestimmten Abstand
unterschreitet. Diese Eigenschaft kann �ber den Parameter I<collide> beeinflu�t
werden. Geometrische Strukturen, die sich innerhalb der Methoden
B<collision_begin> und B<collision_end> befinden, gelten als durchdringbar, wenn
collide auf 0 gesetzt wird. Die Methode kann auch bei besonders komplexen
Strukturen verwendet werden, um einen Vertreter (engl. Proxy) als
alternatives Objekt f�r die Kollisionsberechnung anzugeben, das eine
�hnliche, aber einfachere Struktur besitzt.

Beispiel:

    $vrml
    ->collision_begin(1, sub{$vrml->box('5 1 0.01')})
      ->text('undurchdringbar','yellow',1,'MIDDLE')
    ->collision_end

=item collision_end

Beendet C<collision_begin>.

=item group_begin('comment')

Die Methoden B<group_begin> und B<group_end> stellen die einfachste Form einer
Gruppierung dar. Sie bewirken keine zus�tzlichen Aktivit�ten au�er der
Gruppierung und f�hren auch keine Transformationen aus.

Beispiel:

    $vrml
    ->group_begin
      ->sphere(1,'red')
    ->group_end

=item group_end

Beendet C<group_begin>.

=item lod_begin

F<lod_begin('range', 'center')>

 range  MFFloat []
 center SFVec3f '0 0 0'

Die Methoden B<lod_begin> und B<lod_end> gestatten es dem VRML-Browser, zwischen
unterschiedlich detaillierten und damit unterschiedlich aufwendigen
Strukturen umzuschalten. Die Reihenfolge der Kindmethoden beginnt mit der
komplexesten und endet mit der einfachsten. Die Entfernungen im Parameter
I<range> m�ssen aufsteigend sortiert sein und immer mindestens einen Wert
weniger besitzen als Kindmethoden vorhanden sind. Werden keine Parameter
angegeben, so kann der VRML-Browser unter Gesichtspunkten der Optimierung
ausw�hlen, welche Kindstruktur er darstellt. Der Parameter I<center> bestimmt
den Punkt, der f�r die Berechnung der Entfernung vom Betrachter aus verwendet
wird.

Das folgende Beispiel bringt einen Text in der VRML-Szene unter, der nur bis
zu einer bestimmten Entfernung gut lesbar ist und dar�ber hinaus
verschwindet. Nat�rlich h�ngt die Lesbarkeit von der Schrift- und
Bildschirmgr��e ab. Diese Beziehung kann man im Bedarfsfall mit Variablen
recht einfach realisieren. Die Methode B<lod_begin> enth�lt in diesem Beispiel
eine Entfernung und ben�tigt somit zwei Kinder.

    $vrml
    ->lod_begin('30')
      ->text('gut lesbar')
      ->group_begin->group_end # leere Gruppe
    ->lod_end

=item lod_end

Beendet C<lod_begin>.

=item switch_begin

F<switch_begin(whichChoice)>

 whichChoice SFInt32 -1

Die Methoden B<switch_begin> und B<switch_end> umschlie�en mehrere Kinder,
von denen �ber den Parameter I<whichChoice> jeweils nur einer oder keiner
wiedergegeben wird. Alle Kinder sind mit 0 beginnend durchnumeriert und
k�nnen �ber ihren Index ausgew�hlt werden. Ist der Wert kleiner als 0 oder
gr��er als die Anzahl der zur Verf�gung stehenden Kinder, so erfolgt keine
Wiedergabe. In VRML 1.0 wird dieses Verfahren haupts�chlich zum Umschalten
der Kameras und zur Definition von noch nicht ben�tigten Knoten eingesetzt.

=item switch_end

Beendet C<switch_begin>.

=item transform_begin

F<transform_begin(transformationsListe)>

 transformationsListe  SFString ""

Die wichtigste und m�chtigste Methode zum Gruppieren stellt B<transform_begin>
dar. Sie bietet die M�glichkeit Translationen (Verschiebungen), Rotationen
(Drehungen) und Skalierungen (Vergr��erungen bzw. Verkleinerungen)
durchzuf�hren. Dabei wird ein lokales Koordinatensystem relativ zum
�bergeordneten Koordinatensystem definiert. Alle durchgef�hrten
Transformationen werden in dem lokalen Koordinatensystem ausgef�hrt. Um alle
Transformationen zu beenden und zum �bergeordneten Koordinatensystem
zur�ckzukehren, mu� die Methode C<transform_end> aufgerufen werden. Sie ben�tigt
keinen Parameter.

Die I<transformationsListe> hat folgenden Aufbau:

    'Param1=Wert1', 'Param2=Wert2', ...

Param* kann die Anfangsbuchstaben der folgenden Wort belegen. Die
Kompatibilit�t zu VRML 1.0 ist nur bei Verwendung der Anfangsbuchstaben
gew�hrleistet.

=over 4

=item t = translation (Verschiebung)

Das lokale Koordinatensystem wird um die entsprechenden Anteile in x-, y- und
z-Richtung relativ zum �bergeordneten Koordinatensystem verschoben.

=item r = rotation (Drehung)

Die Drehung wird um die angegebenen Achsen mit dem entsprechenden Winkel
durchgef�hrt. Das Rotationszentrum kann �ber den Parameter c (I<center>)
angegeben werden.

=item s = scale bzw. scaleFactor in VRML 1.0 (Vergr��erungsvektor bzw.
Vergr��erungsfaktor)

Gibt f�r jede Richtung einen Skalierungsfaktor an. Die neuen Koordinaten
werden bez�glich des Punktes im Parameter c (I<center>) berechnet.

=item so = scaleOrientation (Skalierungsrichtung)

Dient zur Angabe einer Drehung, die sich nur bei der Skalierung auswirkt.

=item c = center (Zentrum)

Der Vektor wird als Verschiebung relativ zum lokalen Koordinatensystem
angegeben; er wird bei einer Skalierung oder Rotation als Ursprung benutzt.

=back

Wert* beinhaltet eine Zeichenkette des entsprechenden Typs.

Beispiel:

    $vrml
    ->transform_begin('t=0 1 0','r=180')
      ->cone('0.5 2','red')
    ->transform_end

=item transform_end

Beendet C<transform_begin>.

=item at

Die Methode B<at> bzw. die Methode C<back> sind verk�rzte Schreibweisen f�r
C<transform_begin> bzw. C<transform_end>. Da diese Methoden am h�ufigsten ben�tigt
werden, l��t sich mit der verk�rzten Schreibweise eine bessere Lesbarkeit
erreichen.

Beispiel:

    $vrml
    ->at('0 2 0')
      ->sphere(0.5,'red')
    ->back

=item back

ist die Kurzversion von C<transform_end>.

=item inline

F<inline('url', 'bboxSize', 'bboxCenter')>

 url        MFString []
 bboxSize   SFVec3f  undef
 bboxCenter SFVec3f  '0 0 0'

Die Methode B<inline> kommt ohne _begin und _end aus, da ihre Kinder nur �ber
URLs eingebunden werden. Als zus�tzliche Informationen k�nnen dem Browser
Angaben �ber Ausdehnung und Position der Szene in Form eines
Begrenzungsvolumens mitgeteilt werden. Da es sich aber m�glicherweise um
Szenen eines anderen Servers handelt, bedarf es eines ausgekl�gelten
Kontrollmechanismus', den der Anwender selbst implementieren mu�, um externe
�nderungen in den lokalen bbox-Angaben nachzuf�hren.

=back

=head2 Unabh�ngige Methoden

=over 4

=item background

F<background(
frontUrl =E<gt> '...',
leftUrl =E<gt> '...',
rightUrl =E<gt> '...',
backUrl =E<gt> '...',
bottomUrl =E<gt> '...',
topUrl =E<gt> '...',
skyColor =E<gt> '...',
skyAngle =E<gt> '...',
groundColor =E<gt> '...',
groundAngle =E<gt> '...'
)>

 frontUrl    MFString []
 leftUrl     MFString []
 rightUrl    MFString []
 backUrl     MFString []
 bottomUrl   MFString []
 topUrl      MFString []
 skyColor    MFColor  ['0 0 0']
 skyAngle    MFFloat  []
 groundColor MFColor  []
 groundAngle MFFloat  []


Die B<background>-Methode kann sowohl zum Erzeugen eines farbigen Himmels und
Bodens, als auch einer Hintergrundtextur in Form eines Panoramas, das sich
hinter der gesamten Geometrie befindet, verwendet werden. Hintergrundmotive
werden in dem lokalen Koordinatensystem spezifiziert und nur durch Rotationen
beeinflu�t.

Der I<skyColor>-Parameter spezifiziert die Farbe des Himmels in verschiedenen
Winkeln auf der Himmelskugel. Der erste Wert des I<skyColor>-Parameters gibt die
Farbe des Himmels bei 0 Grad an. Der I<skyAngle>-Parameter spezifiziert die
Winkel vom Zenit, in denen die konzentrischen Kreise verlaufen sollen. Der
Zenit der Kugel ist implizit definiert mit 0.0 Grad; der nat�rliche Horizont
liegt bei 90 Grad und der Fu�punkt bei 180 Grad. Der Parameter I<skyAngle> ist
f�r aufsteigende Werte im Bereich [0, 180] definiert. Es mu� immer ein
I<skyColor>-Wert mehr angegeben werden als I<skyAngle>-Werte existieren. Der erste
Farbwert bestimmt die Farbe des Zenits und ben�tigt keinen I<skyAngle>-Wert. Ist
der letzte I<skyAngle>-Wert kleiner als 180, dann wird f�r die Farbe vom letzten
I<skyAngle> bis zum Fu�punkt der letzte I<skyColor>-Wert verwendet. Die
Himmelsfarbe wird zwischen den I<skyColor>-Werten linear interpoliert.

Der I<groundColor>-Parameter spezifiziert die Farbe des Bodens in verschiedenen
Winkeln auf der Untergrundhalbkugel. Der erste Wert des
I<groundColor>-Parameters bestimmt die Farbe des Fu�punktes. Der
I<groundAngle>-Parameter gibt die Winkel an, in denen die Farbe in
konzentrischen Kreisen verl�uft. Der Fu�punkt ist implizit definiert mit 0.0
Radians. Der Parameter I<groundAngle> ist f�r aufsteigende Werte im Bereich
[0.0, p /2] definiert. Es mu� immer ein I<groundColor>-Wert mehr angegeben
werden als I<groundAngle>-Werte existieren. Ist der letzte I<groundAngle>-Wert
kleiner als p /2, so wird die Region zwischen dem letzten I<groundAngle>-Wert
und dem �quator unsichtbar. Die Untergrundfarbe wird linear interpoliert
zwischen den einzelnen I<groundColor>-Werten.

Die I<backUrl>-, I<bottomUrl>-, I<frontUrl>-, I<leftUrl>-, I<rightUrl>- und
I<topUrl>-Parameter spezifizieren einen Satz von Bildern, die ein
Hintergrundpanorama zwischen den Geometrien und den Hintergrundfarben
definieren. Das Panorama besteht aus sechs Bildern, von denen jedes auf eine
Seite eines �bergro�en W�rfels im lokalen Koordinatensystem projiziert wird.
Die Bilder werden individuell jeder Seite zugeordnet. Alpha-Werte in den
Panoramabildern (d. h. Zwei- oder Vier-Komponentenbilder) machen bestimmte
Regionen halb- oder transparent und erm�glichen das Durchscheinen der
I<groundColor>- und I<skyColor>-Farben. Oftmals werden auch die I<bottomUrl>-
und I<topUrl>-Bilder nicht angegeben, um den Himmel und Boden sichtbar zu
lassen. Alle g�ngigen VRML-Browser unterst�tzen bisher die Bildformate JPEG
und GIF. Hinzu kommt das Format PNG, welches ausdr�cklich in der
Spezifikation VRML 2.0 empfohlen wird. Panoramabilder k�nnen eine Komponente
(Graustufen), zwei Komponenten (Graustufen mit Alphakanal), drei Komponenten
(RGB), oder vier Komponenten (RGB mit Alphakanal) besitzen.

Der Betrachter kann sich nicht den Bildern n�hern; er kann sich jedoch
drehen, um das ganze Panorama zu erfassen.

Der Hintergrund wird nicht durch die C<fog>-Methode (Nebel) beeinflu�t. Es ist
Aufgabe des Szenenautors, die Farben verblassen zu lassen und die Bilder
entsprechend zu �ndern, wenn sich der Betrachter im Nebel befindet.

F�r die Generierung von VRML 1.0 werden nur die Parameter I<frontUrl> und
I<skyColor> ber�cksichtigt. Durch die Vielzahl der Parameter wurde bei der
C<background>-Methode die �bergabeform Parameter => Wert (Hash) gew�hlt. Dabei
spielt die Reihenfolge der Parameter keine Rolle; nicht ben�tigte Parameter
k�nnen weggelassen werden.

Beispiel:

    $vrml->background(skyColor => 'lightblue',
                      frontUrl => 'http://www.yourdomain.de/bg/berge.gif');

=item backgroundcolor

F<backgroundcolor('skyColor', 'groundColor')>

 skyColor     SFColor  '0 0 0'
 groundColor  SFColor  '0 0 0'

Die B<backgroundcolor>-Methode stellt eine stark vereinfachte Variante der
C<background>-Methode dar. Sie spezifiziert nur die Hintergrundfarben einer
Szene. Bei der Generierung einer VRML-2.0-Quelle wird der Parameter
I<skyColor> f�r den Himmel und I<groundColor> f�r den Boden verwendet. F�r
VRML-1.0-Quellen wird der zweite Parameter ignoriert.

Beispiel:

    $vrml->backgroundcolor('lightblue');

=item backgroundimage

F<backgroundimage('url')>

 url SFString ""

�ber die Methode B<backgroundimage> kann das Hintergrundbild einer Szene
definiert werden. Dazu mu� der Parameter I<url> eine Grafikdatei enthalten.
Die am h�ufigsten unterst�tzten Grafikformate sind GIF, JPEG und PNG. Neben
diesen stellen einige VRML-Browser auch das BMP-Format dar. Aus Gr�nden der
Kompatibilit�t zur UNIX- und Macintosh-Welt und wegen des �berm��igen
Platzbedarfs sollte dieses Format nicht einsetzt werden. Die Methode
B<backgroundimage> belegt den kompletten Hintergrund in VRML 1.0 und alle
sechs Panoramabilder in VRML 2.0 mit dem gleichen Bild. F�r eine individuelle
Zuweisung jedes Panoramateils mu� die Methode C<background> verwendet werden.

Beispiel:

    $vrml->backgroundimage('http://www.yourdomain.de/bg/sterne.gif');

=item title

F<title('string')>

 string SFString ""

Die Angabe eines Titels in der Methode B<title> hat keine Auswirkung auf die
darstellbare Szene. Sie kann lediglich vom Browser als Zusatzinformation
verwendet werden und wird h�ufig in dessen Titelleiste angezeigt.

Beispiel:

    $vrml->title('Meine virtuelle Welt');

=item info

F<info('string')>

 string MFString []


Mit der Methode B<info> k�nnen beliebige Informationen in einer VRML-Datei
untergebracht werden.

Beispiel:

    $vrml->info('letzte �nderung: 8.05.1997');

=item worldinfo

F<worldinfo('title', 'info')>

 title  SFString ""
 info   MFString []


Die Methode B<worldinfo> stellt Informationen �ber die aktuelle Szene zur
Verf�gung. Diese Methode ist nur f�r Dokumentationszwecke gedacht und hat
keinen Einflu� auf die VRML-Welt. Im I<title>-Parameter kann der Name oder
Titel der Welt gespeichert werden, um ihn gegebenenfalls in der Titelleiste
zu pr�sentieren. Andere Informationen �ber die Welt wie Autor, Copyright oder
Nutzungshinweise k�nnen im I<info>-Parameter abgelegt werden. Die Methode
B<worldinfo> kombiniert die Methoden C<title> und C<info>.

Beispiel:

    $vrml->worldinfo('Sofies Welt', 'Jostein Gaarder');

=item navigationinfo

F<navigationinfo('type', speed, headlight, visibilityLimit, avatarSize)>

 type         MFEnum     ['WALK', 'ANY'] # ANY, WALK, FLY, EXAMINE, NONE
 speed        SFFloat    1.0
 headlight    SFBool     1
 visibilityLimit SFFloat 0.0
 avatarSize   MFFloat    [0.25, 1.6, 0.75]

Mit der Methode I<navigationinfo> k�nnen verschiedene Informationen f�r die
Steuerung des VRML-Browsers festgelegt werden. Diese Informationen
beschreiben Eigenschaften des Betrachters und die Art wie er durch die Szene
navigiert. Die Bewegungsart wird �ber den Parameter I<type> spezifiziert. Beim
Gehen (WALK) wirkt die Schwerkraft auf den Betrachter, die ihn auf den
Untergrund zieht. Dadurch wird es ihm auch m�glich, einem Gel�nde zu folgen.
Das Gehen erfordert eine aufrechte Haltung (parallel zur y-Achse), die durch
den Browser realisiert wird. Das Fliegen (FLY) �hnelt dem Gehen, jedoch ohne
die Wirkung einer Schwerkraft. Sowohl beim Gehen als auch beim Fliegen ist
die Kollisionserkennung standardm��ig eingeschaltet. Der Mindestabstand
zwischen dem Betrachter und geometrischen Objekten der Szene kann �ber den
ersten Wert des Parameters I<avatarSize> eingestellt werden (voreingestellt sind
25 cm). Wird dieser unterschritten, kollidiert man. Der zweite Wert des
Parameters I<avatarSize> bestimmt die Blickh�he des Betrachters
(voreingestellt sind 1,6 Meter). Besonders negativ machen sich
H�henunterschiede zwischen der aktuellen Blickh�he und vordefinierten
Aussichtspunkten (engl. Viewpoints) bemerkbar. Hierbei wird die H�he
angepa�t, sowie man sich von der Stelle bewegt, was zu einer Auf- bzw.
Abw�rtsbewegung f�hrt. Der dritte Wert des Parameters I<avatarSize>
spezifiziert die H�he eines K�rpers den der Betrachter bei eingeschalteter
Schwerkraft noch �berwinden kann (voreingestellt sind 75 cm).

Die Geschwindigkeit, mit der man sich in der Welt bewegt, spezifiziert der
Parameter I<speed>. Sie wird in Metern pro Sekunde angegeben und betr�gt
standardm��ig 1,0 m/s (3,6 km/h). Von den Parametern der aktuellen
Transformation beeinflu�t nur der Skalierungsfaktor die Geschwindigkeit.

Viele VRML-Browser besitzen als zus�tzliche Beleuchtung eine Helmlampe, deren
Lichtstrahlen in Blickrichtung verlaufen. Die Helmlampe ist je nach Browser
standardm��ig ein- oder ausgeschaltet. Erst in der Spezifikation VRML 2.0
wurde festgelegt, da� diese beim Start leuchtet, wenn sie nicht explizit
durch den Parameter I<headlight> ausgeschaltet wurde. Nach dem Laden der Szene
hat der Betrachter die M�glichkeit, den aktuellen Zustand zu �ndern.

Die Sichtweite des Betrachters kann �ber den Parameter I<visibilityLimit>
eingegrenzt werden. Abh�ngig vom jeweiligen Browser brechen einige die
Darstellung an dieser Position ab, w�hrend andere nur komplette Geometrien
weglassen.

Beispiel:

    $vrml->navigationinfo('WALK', 1.5, 0, 1000);

=item viewpoint_begin

Kameradefinitionen bzw. Aussichtspunkte stehen �blicherweise im vorderen Teil
einer VRML-Quelle. Da sie aber - bei einer dynamischen Erstellung einer
VRML-Szene - erst in bestimmten Programmteilen berechnet werden k�nnen, gibt
es die M�glichkeit, die gew�nschte Stelle mit der Methode B<viewpoint_begin> zu
markieren. Beim Aufruf der Methode C<viewpoint_end> werden die Definitionen an
der markierten Stelle eingef�gt. W�hrend in VRML 2.0 die Aussichtspunkte
prinzipiell �ber die ganze Quelle verstreut sein d�rfen, m�ssen sich die
Camera-Knoten in VRML 1.0 innerhalb eines Switch-Knotens befinden. Nur dann
kann sp�ter zwischen ihnen gewechselt werden.

=item viewpoint

F<viewpoint('description', 'position', 'orientation', fieldOfView, jump)>

 description SFString          ""
 position    SFVec3f           0 0 10
 orientation SFRotation/SFEnum 0 0 1 0 # FRONT, LEFT, BACK, RIGHT, TOP, BOTTOM
 fieldOfView SFFloat           45 # Grad
 jump        SFBool            1

Die Methode B<viewpoint> dient der individuellen Positionierung einer Kamera
bzw. der Festlegung von bestimmten Aussichtspunkten. Der Parameter
I<position> spezifiziert die Position, an der sich die Kamera befinden soll.
F�r den Parameter I<orientation> stehen neben der Angabe eines
SFRotation-Werts auch Synonyme f�r die h�ufigsten Richtungen FRONT, LEFT,
BACK, RIGHT, TOP, BOTTOM und ALL in Form von Zeichenketten zur Verf�gung. Der
Parameter I<description> enth�lt die Bezeichnung des Aussichtspunktes. Er
wird sp�ter vom VRML-Browser in einem Pulldown-Men� dargestellt und zur
Auswahl angeboten. Nach jedem Hinzuf�gen eines neuen Aussichtspunktes wird
dieser als aktuelle Benutzersicht �bernommen. Um das zu verhindern, mu� der
Parameter I<jump> auf 0 gesetzt werden. Den Blickwinkel bestimmt der
Parameter I<fieldOfView>. Kleine Winkel sind vergleichbar mit einem
Teleobjektiv, gro�e mit einem Weitwinkelobjektiv.

Beispiel:

    $vrml->viewpoint('Start','0 0 0','0 0 -1 0',60);

ist identisch mit

    $vrml->viewpoint('Start',undef,'FRONT',60);


=item viewpoint_set

F<viewpoint_set('center', distance, fieldOfView, avatarSize)>

 center       SFVec3f '0 0 0'
 distance     SFFloat 10
 fieldOfView  SFFloat 45 # Grad
 avatarSize   MFFloat [0.25, 1.6, 0.75]

Eine zeitraubende und st�ndig wiederkehrende Arbeit ist die Positionierung
von Aussichtspunkten (engl. Viewpoints) f�r die Standardansichten von vorn,
von rechts, von hinten, von links, von oben und von unten. Die Methode
B<viewpoint_set> soll helfen, diese undankbare Aufgabe zu erleichtern. Durch
ihre Anwendung lassen sich alle Standardeinstellungen mit einer Anweisung
definieren. Weitere Aussichtspunkte k�nnen �ber die Methode C<viewpoint>
hinzugef�gt werden. Der Parameter I<avatarSize> sichert, da� die Viewpoints
in der gleichen H�he angeordnet werden in der sich der Betrachter bewegt.

Das folgende Beispiel ordnet alle sechs Standardansichten im Abstand von f�nf
Metern um das Zentrum (4 3 0) an:

    $vrml->viewpoint_set('4 3 0',5);

=item viewpoint_auto_set

Setzt alle Parameter von C<viewpoint_set> automatisch, voraugesetzt das es
nach der Geometrieplazierung aufgerufen wird.

=item viewpoint_end

Beendet C<viewpoint_begin>.

=item directionallight

F<directionallight('direction', intensity, ambientIntensity, 'color', on)>

 direction         SFVec3f  '0 0 -1'
 intensity         SFFloat  1
 ambientIntensity  SFFloat  1
 color             SFColor  '1 1 1' #wei�
 on                SFBool   1

Die B<directionallight>-Methode beleuchtet Objekte in einer Szene mit parallelem
Licht gleicher Intensit�t. Der I<direction>-Parameter spezifiziert die Richtung
der Strahlen bezogen auf das lokale Koordinatensystem. Das Licht wird von
einer unendlich weit entfernten Quelle ausgestrahlt und beleuchtet nur die
Objekte der Gruppe, in der es sich befindet, bzw. deren untergeordnete
Gruppen. Der I<intensity>-Parameter spezifiziert die Intensit�t der Lichtquelle.
Ein Wert von 1 bedeutet maximale Helligkeit. Die Farbe des ausgesendeten
Lichtes bestimmt der I<color>-Parameter. �ber den Parameter I<on> l��t sich der
Grundzustand der Lichtquelle angeben.

Alle durchgef�hrten �bergeordneten Transformationen wirken sich auch auf die
Lichtquelle aus.

Beispiel:

    $vrml->directionallight("0 0 -1", 0.3);


=item sound

F<sound('url','description', 'location', 'direction', intensity, loop, pitch)>

 url         MFString []
 description SFString ""
 location    SFVec3f  '0 0 0'
 direction   SFVec3f  '0 0 1'
 intensity   SFFloat  1.0
 loop        SFBool   0
 pitch       SFFloat  1.0

Die I<sound>-Methode spezifiziert die r�umliche Pr�sentation von T�nen in
einer VRML-Szene.

Der I<url>-Parameter spezifiziert die URL, von der der Klang geladen werden
soll. Die unterst�tzen Typen sind meistens WAV im unkomprimierten PCM-Format
und MPEG-1. Zus�tzlich k�nnen viele VRML-Browser noch den MIDI-Dateityp 1
unter Verwendung des General MIDI Patch wiedergeben.

Der I<description>-Parameter gibt eine sprachliche Beschreibung der
Audio-Quelle an. Ein Browser mu� den I<description>-Parameter nicht anzeigen,
kann es aber w�hrend der Wiedergabe des Klangs tun.

Der I<location>-Parameter bestimmt den Ort im lokalen Koordinatensystem, von
dem der Sound ausgestrahlt werden soll. Die B<sound>-Methode gibt keine T�ne
ab, wenn sie nicht Teil der dargestellten Szene ist; d. h. wenn sie sich in
einem Teil eines LOD- oder Switch- Knotens befindet der ausgeschaltet ist.

Der I<direction>-Parameter spezifiziert die Richtung, in die der Sound
ausgestrahlt werden soll.

Der I<intensity>-Parameter spezifiziert die Wiedergabelautst�rke. Der
Wertebereich geht von 0.0 bis 1.0. Bei einer Intensit�t von 1.0 wird der Ton
mit maximaler Lautst�rke wiedergegeben; bei 0.0 hingegen herrscht Ruhe.

Der I<loop>-Parameter bestimmt, ob das Musikst�ck einmal oder fortlaufend
wiedergegeben werden soll.

Der I<pitch>-Parameter spezifiziert ein Vielfaches der Wiedergabefrequenz. Es
sind nur positive Werte g�ltig. Ein Wert von Null oder kleiner produziert
undefinierte Ergebnisse. Die �nderung des I<pitch>-Parameter erzeugt sowohl
eine Tonh�hen�nderung als auch eine �nderung der Wiedergabegeschwindigkeit.
Ein Wert von 2.0 bedeutet, da� der Klang eine Oktave h�her als normal
gespielt wird und doppelt so schnell. Bei einem gesampelten Klang �ndert der
I<pitch>-Parameter die Wiedergabefrequenz. Im Falle einer MIDI (oder eines
anderen in Noten aufgezeichneten Musikst�cks) wird das Tempo der Wiedergabe
erh�ht und die MIDI-Steuerung entsprechend angepa�t, um den gew�nschten
Effekt zu erzielen.

=back

=head2 Geometrien

F�r die Darstellung von geometrischen K�rpern gibt es eine Vielzahl von
Methoden. Sie ben�tigen grunds�tzlich Dimensionsangaben wie Breite, H�he oder
Radius. Dar�ber hinaus k�nnen �ber den Parameter I<appearance> die Farbe bzw.
die Oberfl�cheneigenschaften spezifiziert werden.

=over 4

=item box

F<box('size', 'appearance')>

 size       SFVec3f  '2 2 2' # Breite H�he Tiefe
 appearance SFString ""      # siehe Material & Farbe


Die Methode B<box> definiert einen Quader mit dem Mittelpunkt (0 0 0) im
lokalen Koordinatensystem. Standardm��ig hat der Quader die Gr��e von zwei
Einheiten in jeder Richtung, jeweils von -1 bis +1. Der I<size>-Parameter
spezifiziert die Ausdehnung entlang der x-, y- und z-Achse und mu� bei jeder
Komponente gr��er als 0.0 sein. Sind alle drei Angaben gleich, so wird aus
dem Quader ein W�rfel. Der Parameter I<appearance> spezifiziert die Farbe
bzw. die Oberfl�cheneigenschaften. Texturen werden auf jede Fl�che einzeln
projiziert.

Ein Quader erfordert nur die Darstellung von Au�enfl�chen. Die Betrachtung
der Innenseiten f�hrt zu undefinierten Ergebnissen.


=item cone

F<cone('bottomRadius height', 'appearance')>

 bottomRadius height SFVec2f '1 2'
 appearance          SFString "" # siehe Material & Farbe


Die Methode B<cone> spezifiziert einen Kegel, dessen Mittelpunkt (0 0 0) im
lokalen Koordinatensystem und dessen zentrale Achse auf der y-Achse liegt.
Der I<bottomRadius>-Parameter bestimmt den Radius des Kegelbodens und der
I<height>-Parameter die H�he des Kegels. Standardm��ig hat der Kegel einen
Radius von 1.0 und eine H�he von 2.0 mit der Spitze bei y = I<height>/2 und dem
Boden bei y = -I<height>/2. Beide, I<bottomRadius> und I<height>, m�ssen gr��er als
0.0 sein. Der Parameter I<appearance> spezifiziert die Farbe bzw. die
Oberfl�cheneigenschaften.

Ein Kegel erfordert nur die Darstellung von Au�enfl�chen. Die Betrachtung der
Innenseiten f�hrt zu undefinierten Ergebnissen.


=item cylinder

F<cylinder('radius height', 'appearance')>

 radius height SFVec2f  '1 2'
 appearance    SFString "" # siehe Material & Farbe


Die Methode B<cylinder> spezifiziert einen geschlossenen Zylinder (Abbildung 6)
mit dem Mittelpunkt (0 0 0) im lokalen Koordinatensystem, dessen zentrale
Achse auf der y-Achse liegt. Standardm��ig hat der Zylinder eine Ausdehnung
von -1 bis +1 in alle drei Richtungen. Der I<radius>-Parameter bestimmt den
Radius des Zylinders und der I<height>-Parameter die H�he entlang der zentralen
Achse. Beide, I<radius> und I<height>, m�ssen gr��er als 0.0 sein. Der Parameter
I<appearance> spezifiziert die Farbe bzw. die Oberfl�cheneigenschaften.

Ein Zylinder erfordert nur die Darstellung von Au�enfl�chen. Die Betrachtung
der Innenseiten f�hrt zu undefinierten Ergebnissen.


=item line

F<line('from', 'to', radius, 'appearance', 'path')>

 from        SFVec3f   ""
 to          SFVec3f   ""
 radius      SFFloat   0 # 0 = Haarlinie
 appearance  SFString  ""
 path        SFEnum    "" # XYZ, XZY, YXZ, YZX, ZXY, ZYX

In VRML erfolgt die Positionierung eines K�rpers durch die Angabe eines
Raumpunktes und der Richtung im Raum (Vektor). Diese Vorgehensweise erweist
sich dann als besonders nachteilig, wenn zwei Punkte durch einen K�rper
miteinander verbunden werden m�ssen. Der VRML-Knoten C<IndexedLineSet> bietet
nur die M�glichkeit, zwei Punkte durch Linien in einer Standardstrichst�rke
zu verbinden. Um eine variable Linienst�rke zu realisieren, mu� ein Zylinder
als Linienersatz dienen. Die Methode B<line> f�hrt alle notwendigen Berechnungen
durch, um diesen Zylinder korrekt zu plazieren. Die Parameter I<from> und I<to>
bestimmen den Start- und Endpunkt der Linie. Der Parameter I<radius> gibt den
Radius des Zylinders vor, der f�r die Verbindung eingesetzt wird. Ob die
Linie einen direkten oder einen orthogonalen Verlauf entlang der x-, y- und
z-Achsen nehmen soll, spezifiziert der Parameter I<path>. Bei leerem Parameter
wird die direkte Verbindung gew�hlt.

In dem folgenden Beispiel erzeugt die erste Linie einen orthogonalen
Linienverlauf beginnend an der Position '1 -1 1', der sich zun�chst entlang
der x-Achse bewegt, dann in Richtung der z-Achse und schlie�lich parallel zur
y-Achse an der Koordinate '-3 2 2' endet. Der Zylinder hat einen Durchmesser
von drei Zentimetern. Der zweite Zylinder verbindet beide Koordinaten auf
direktem Weg miteinander.

    new VRML(2)
    ->begin
      ->line('1 -1 1', '-3 2 2', 0.03, 'red', 'XZY')
      ->line('1 -1 1', '-3 2 2', 0.03, 'white')
    ->end
    ->print;

=item pyramid

F<pyramid('size', 'appearance')>

 size       SFVec3f  '2 2 2' # Breite H�he Tiefe
 appearance SFString ""      # siehe Material & Farbe


Die Methode B<pyramid> definiert eine Pyramide mit dem Mittelpunkt (0 0 0) im
lokalen Koordinatensystem. Standardm��ig hat der Pyramide die Gr��e von zwei
Einheiten in jeder Richtung, jeweils von -1 bis +1. Der I<size>-Parameter
spezifiziert die Ausdehnung entlang der x-, y- und z-Achse und mu� bei jeder
Komponente gr��er als 0.0 sein. Der Parameter I<appearance> spezifiziert die
Farbe bzw. die Oberfl�cheneigenschaften. Werden mehrere Farben angegeben
(durch Kommata getrennt), so wird jede Seite mit der entsprechen Farbe
belegt.

Beispiel:

    $vrml->pyramid('1 1 1','blue,green,red,yellow,white');

=item sphere

F<sphere(radius, 'appearance')>

 radius     SFFloat  1
 appearance SFString "" # siehe Material & Farbe

Die Methode B<sphere> spezifiziert eine Kugel mit dem Mittelpunkt (0 0 0) im
lokalen Koordinatensystem. Der I<radius>-Parameter bestimmt den Radius der Kugel
und mu� gr��er als 0.0 sein. Der Parameter I<appearance> spezifiziert die Farbe
bzw. die Oberfl�cheneigenschaften.

Wenn eine Textur auf die Kugel gelegt wird, umh�llt sie die ganze Oberfl�che,
beginnend von der R�ckseite entgegen dem Uhrzeigersinn. Die Textur hat eine
Naht an der R�ckseite, wo die Fl�che x=0 die Kugel schneidet und die z-Werte
negativ sind.

Eine Kugel erfordert nur die Darstellung von Au�enfl�chen. Die Betrachtung
der Innenseiten f�hrt zu undefinierten Ergebnissen.


=item elevationgrid

F<elevationgrid(height, color, xDimension, zDimension, xSpacing, zSpacing,
creaseAngle, colorPerVertex, solid)>

 height          MFFloat  []
 color           MFColor  []  # bzw. Material & Farbe
 xDimension      SFInt32  0
 zDimension      SFInt32  0
 xSpacing        SFFloat  1.0
 zSpacing        SFFloat  1.0
 creaseAngle     SFFloat  0
 colorPerVertex	 SFBool   1
 solid           SFBool   0

Die Methode B<elevationgrid> spezifiziert ein H�henmodell durch ein
regelm��iges Gitter. Der Parameter I<height> gibt dabei eine Anzahl von
H�henwerten vor zu denen jeweils ein Farbwert (bei I<colorPerVertex> gleich
1) geh�rt. Wird I<colorPerVertex> auf 0 gesetzt, so werden die Fl�chen
zwischen vier Punkten eingef�rbt, d.h. es wird ein Farbwert pro Dimension
(x,z) weniger ben�tigt. Der Parameter I<height> kann als Referenz auf ein
Array - welches eine x-Zeile enth�lt - angegeben werden. In diesem Fall wird
die Anzahl der Elemente als I<xDimension> und die Anzahl der Zeilen als
I<zDimension> interpretiert. Sie sollte dann nicht nochmals ermittelt werden.
Wird der Parameter I<color> nicht als Referenz auf ein ARRAY �bergeben, so
wird angenommen, da� es sich um eine Farb- bzw. Texturangabe handelt.

Beispiel:

    open(FILE,"<height.txt");
    my @height = <FILE>;
    open(COL,"<color.txt");
    my @color = <COL>;
    $vrml->navigationinfo(["EXAMINE","FLY"],200)
         ->viewpoint("Top","1900 6000 1900","TOP")
         ->elevationgrid(\@height, \@color, undef, undef, 250, undef, 0)
	 ->print;


=item text

F<text('string', 'appearance', 'font', 'align')>

 string     MFString []
 appearance SFString "" # siehe Material & Farbe
 font       SFString '1 SERIF PLAIN'
 align      SFEnum   'BEGIN' # BEGIN, MIDDLE, END


Die Methode B<text> spezifiziert eine flache, zweiseitige Zeichenkette, die
in der z-Ebene des lokalen Koordinatensystems positioniert wird. Der
Parameter string kann eine Liste von Zeichenketten enthalten, wobei jeder
Eintrag in einer neuen Zeile dargestellt wird. Der Parameter I<appearance>
spezifiziert die Farbe bzw. die Oberfl�cheneigenschaften, die f�r den
kompletten Text g�ltig ist. Der Parameter font gliedert sich in drei Teile
I<size>, I<family> und I<style>, jeweils durch ein Leerzeichen getrennt. Der
erste Wert I<size> spezifiziert die Schriftgr��e (Schriftgrad), bezogen auf
das lokale Koordinatensystem der C<text>-Methode. Er mu� immer gr��er als 0.0
sein. Der zweite Wert I<family> enth�lt eine Zeichenkette in Gro�buchstaben,
welche die Font-Familie spezifiziert. Der Browser bestimmt jedoch
letztendlich, welcher Font aus dieser Familie zum Einsatz kommt.
�blicherweise werden von den Browsern mindestens SERIF f�r einen Serif-Font
wie Times Roman, SANS f�r einen Sans-Serif-Font wie Helvetica und TYPEWRITER
f�r einen Font mit konstanter Buchstabenbreite wie Courier unterst�tzt. Ein
leerer Wert f�r I<family> ist identisch mit SERIF. Der Parameter I<style>
kann die Werte PLAIN, BOLD, ITALIC und BOLDITALIC annehmen.

    PLAIN  (keine Besonderheiten, Voreinstellung)
    BOLD   (fett)
    ITALIC (kursiv)
    BOLDITALIC (fett und kursiv)

Der Parameter I<align> gibt die Ausrichtung des Textes an. Es stehen folgende
Werte zur Verf�gung:

    BEGIN  bzw. LEFT   (linksb�ndig, Voreinstellung)
    MIDDLE bzw. CENTER (zentriert)
    END    bzw. RIGHT  (rechtsb�ndig)

=item billtext

F<billtext('string', 'appearance', 'font', 'align')>

 string     MFString []
 appearance SFString "" # siehe Material & Farbe
 font       SFString '1 SERIF PLAIN'
 align      SFEnum   'BEGIN' # BEGIN, MIDDLE, END


Die Methode B<billtext> ist �quivalent zur Methode C<text> mit der
zus�tzlichen Eigenschaft, da� der Text immer dem Betrachter zugewandt bleibt.
Sie kombiniert die Methoden B<billboard> und C<text>, da es h�ufig vorkommt,
da� die Textinformationen einer Szene aus allen Richtungen lesbar sein
m�ssen.

=back

=head2 Material & Farbe

Das Erscheinungsbild von geometrischen Objekten (engl. Shape) wird in VRML
2.0 durch den Appearance-Knoten bestimmt. Dieser kann als Kindknoten einen
Material- und einen Texture-Knoten enthalten. In VRML 1.0 definiert der
letzte Material- bzw. Texture-Knoten das Aussehen aller darauf folgenden
Objekte. Diese unterschiedliche Verfahrensweise zur Angabe des
Erscheinungsbildes eines geometrischen Objekts erschwert die flexible Ausgabe
einer Szene in einer beliebigen Spezifikation. Das VRML-Modul erm�glicht
jedoch eine einfache und benutzerfreundliche Farb- bzw. Texturangabe. Es
bietet verschiedene Varianten der Materialzusammensetzung nach folgender
Schema:

    'Eigenschaft1=Liste1; Eigenschaft2=Farbe1,Farbe2; ...'

wobei I<Eigenschaft> die Werte:

    a - ambientColor (nur VRML 1.0)
    d - diffuseColor
    e - emissiveColor
    s - specularColor

    ai - ambientIntensity (nur VRML 2.0)
    sh - shininess
    tr - transparency

    tex - filename, wrapS, wrapT

    def    - benennt den Appearance-Knoten
    defmat - benennt den Material-Knoten
    deftex - benennt den Image- bzw. MovieTexture-Knoten

annehmen kann und I<Liste> eine Anzahl von Materialien definiert, die durch
Kommata getrennt werden m�ssen. Das K�rzel f�r einen Farbwert besteht dabei
aus einem Buchstaben und das K�rzel einer Intensit�t aus zwei Buchstaben.
Drei und mehr Buchstaben sind f�r Definitionen und Texturen vorgesehen. Das
Modul erkennt selbst�ndig, ob es sich um eine ImageTexture (GIF, JPEG, PNG,
BMP) oder um ein Video (AVI, MPEG, MOV) handelt. Mehrere Eigenschaften k�nnen
kombiniert werden, indem diese durch ein Semikolon voneinander getrennt
werden. Farbwerte k�nnen als RGB-Tripel oder als Name angegeben werden.
Es gibt vier Schreibweisen, um eine Farbe (z. B. intensives Gelb) zu
definieren.

    '1 1 0' (VRML-Standard)
    'FFFF00' oder 'ffff00'
    '255 255 0'
    'yellow'

Die beiliegende Version des VRML-Moduls enth�lt alle X11-Farbnamen. Jedem
Farbnamen kann ein zweistelliger Zahlenwert folgen, der die Helligkeit linear
verringert. Dieser prozentuale Anteil mu� von dem Farbnamen durch ein
spezielles Zeichen ( % _ ) getrennt werden. Hier bietet sich das
Prozentzeichen als intuitive Gedankenst�tze an. Von der Verwendung dieses
Zeichens innerhalb eines Parameters einer URL-Adresse ist jedoch abzuraten,
da Prozentzeichen, die von Ziffern gefolgt werden, in entsprechende
ASCII-Zeichen umgewandelt werden. Es wird deshalb empfohlen, in URL-Adressen,
insbesondere im QUERY_STRING, den Unterstrich (_) als Trennsymbol zu
verwenden !

Analog zum vorherigen Beispiel k�nnen vier verschiedene Schreibweisen
eingesetzt werden, um die Intensit�t einer Farbe (z. B. Gelb) zu verringern.

    '.5 .5 0' (VRML-Standard)
    '808000'
    '128 128 0'
    'yellow%50'

Abschlie�end noch zwei Beispiele f�r identische Farbwerte:

    yellow%100 = yellow_100 = yellow (gelb)

    white%0 = black (schwarz)

Eine Liste der verf�gbaren Farbnamen befindet sich im Modul VRML::Color.

=over 4

=item appearance

F<appearance('Typ=Wert1,Wert2 ; Typ=...')>

Die Methode B<appearance> wird implizit beim Gebrauch der Geometriemethoden
aufgerufen. Sie realisiert die obige Synatx. Normalerweise wird sie nicht
anderweitig ben�tigt.

=back

=head2 Interpolatoren

F�r die Erstellung von Animationen sind Interpolatoren unentbehrlich. Sie stehen
f�r fast alle Datentypen zur Verf�gung. Grunds�tzlich besitzen alle
Interpolatoren als Parameter einen Namen, eine Liste von St�tzstellen und eine
dazugeh�rige Liste mit Funktionswerten. Die St�tzstellen, auch C<keys> genannt,
liegen immer im Bereich von 0.0 bis 1.0. Zu jedem C<key> mu� es einen Funktionswert
vom Typ des Interpolators geben. Zwischen den C<keys> wird linear interpoliert. Um
eine bessere Interpolation als die st�ckweise lineare Interpolation zu erzielen,
mu� man sich einen eigenen Interpolator schreiben. F�r ganze Zahlen gibt es
keinen Interpolator.

=over 4

=item interpolator

F<interpolator('name','type',[keys],[keyValues])>

 name      SFString ""
 type      SFEnum   "" # Color, Coordinate, Normal, Orientation,
                       # Position und Scalar
 keys      MFFloat  [] # [0,1]
 keyValues MF...    [] # Typ des Interpolators

Die Methode B<interpolator> erzeugt einen benannten Interpolator, der linear
zwischen den Funktionswerten des im Parameters I<type> spezifizierten Datentyps
interpoliert. Als Typen stehen zur Auswahl: Color, Coordinate, Normal,
Orientation, Position und Scalar. Der Parameter I<name> enth�lt den Bezeichner,
�ber den der Interpolator beispielsweise in einer C<route>-Methode referenziert
werden kann.

Beispiel:

    $vrml->interpolator('RotBlau', 'Color', [0,1], ['1 0 0', '0 0 1']);


=back

=head2 Sensoren

Sensoren erm�glichen eine direkte Wechselwirkung des Betrachters mit Objekten
einer Szene. Die Sensoren in VRML 2.0 gliedern sich in zwei Kategorien:
Geometriesensoren und Zeitsensoren. Ein Teil der Geometriesensoren - Cylinder-,
Plane- und SphereSensor - liefern Ereignisse, wenn die mit ihnen verbundenen
Objekte aktiviert und bewegt werden. Andere Sensoren, wie der Proximity- oder
der Visibility-Sensor, reagieren schon beim Betreten oder Sichtbarwerden eines
Bereiches. Die erzeugten Ereignisse k�nnen von Interpolator- oder Script-Knoten
verarbeitet werden, die wiederum Ereignisse f�r andere Knoten generieren. Die
Ereignisse einiger Sensoren k�nnen auch direkt an einen Transform-Knoten
weitergeleitet werden.

F�r den Ablauf von Animationen ist der TimeSensor von besonderer Bedeutung. Er
kann in kontinuierlichen Abst�nden Ereignisse liefern, die an Skripte oder
Interpolatoren gesendet werden.

Alle Sensoren ben�tigen grunds�tzlich einen Namen f�r die referenzierende
C<route>-Anweisung. Dieser wird immer im Parameter I<name> spezifiziert.

=over 4

=item cylindersensor

F<cylindersensor('name',maxAngle,minAngle,diskAngle,offset,autoOffset,enabled)>

 name       SFString ""
 maxAngle   SFFloat  undef
 minAngle   SFFloat  0
 diskAngle  SFFloat  15
 offset     SFFloat  0
 autoOffset SFBool   1
 enabled    SFBool   1

Der Cylinder-Sensor generiert Ereignisse, sobald der Benutzer einen virtuellen
Zylinder anklickt.

=item planesensor

F<planesensor('name',maxPosition,minPosition,offset,autoOffset,enabled)>

 name         SFString  ""
 maxPosition  SFVec2f  undef
 minPosition  SFVec2f  '0 0'
 offset       SFVec3f  '0 0 0'
 autoOffset   SFBool  1
 enabled      SFBool  1

Der Plane-Sensor generiert Ereignisse, sobald der Benutzer eine virtuelle Ebene
anklickt.

=item proximitysensor

F<proximitysensor('name',size,center,enabled)>

 name    SFString ""
 size    SFVec3f  '0 0 0'
 center  SFVec3f  '0 0 0'
 enabled SFBool   1

Der Proximity-Sensor generiert Ereignisse, sobald sich der Benutzer innerhalb
eines bestimmten (quaderf�rmigen) Bereichs um ein bestimmtes Objekt bzw. einen
bestimmten Koordinatenpunkt bewegt.

=item spheresensor

F<spheresensor('name',offset,autoOffset,enabled)>

 name       SFString   ""
 offset     SFRotation '0 1 0 0'
 autoOffset SFBool     1
 enabled    SFBool     1

Der Sphere-Sensor generiert Ereignisse, sobald der Benutzer eine virtuelle Kugel
anklickt.

=item timesensor

F<timesensor('name',cycleInterval,loop,startTime,stopTime,enabled)>

 name          SFString ""
 cycleInterval SFFloat  1
 loop          SFBool   0
 startTime     SFFloat  0
 stopTime      SFFloat  0
 enabled       SFBool   1

Der Time-Sensor generiert Ereignisse, die Zeitwerte enthalten. Diese
Zeitwerte k�nnen beispielsweise Animationen steuern.

=item touchsensor

F<touchsensor('name',enabled)>

    name    SFString ""
    enabled SFBool   1

Der Touch-Sensor generiert Ereignisse, sobald sich der Benutzer mit dem
Mauszeiger �ber ein bestimmtes Objektteil bewegt und dieses anklickt.

Das folgende Beispiel stellt eine wei�e Kugel dar, die bei Aktivierung mit rotem
Licht bestrahlt wird.

Beispiel:

    $vrml
    ->begin
	->touchsensor('Schalter')
	->sphere(1,'white')
	->def('Licht')->directionallight("", 1, 0, 'red', 0)
	->route('Schalter.isActive', 'Licht.on')
    ->end
    ->print->save;

=item visibitysensor

F<visibitysensor('name',size,center,enabled)>

    name    SFString ""
    size    SFVec3f  '0 0 0'
    center  SFVec3f  '0 0 0'
    enabled SFBool   1

Der Visibility-Sensor generiert Ereignisse, sobald ein Teil eines
quaderf�rmigen Bereiches in das Blickfeld des Betrachters eintritt oder aus
dem Blickfeld verschwindet.

=back

=head2 Sonstiges

=over 4

=item route

F<route('from','to')>

 FROM.feldname SFString ""
 TO.feldname   SFString ""

Die Methode B<route> stellt die Verbindung zwischen einem Knoten, der Ereignisse
sendet, und einem Knoten, der dieses Ereignis empf�ngt her. Das Verst�ndnis der
Beziehungen zwischen den Sende- und Empfangsfeldern der jeweiligen Knoten ist
Voraussetzung f�r das erfolgreiche Weiterleiten (routen) von Ereignissen. Der
Parameter I<FROM.feldname> spezifiziert das Feld eines benannten Knotens, von
dem das Ereignis gesendet wird. Der Parameter I<TO.feldname> spezifiziert das
Feld eines benannten Knotens, welches das Ereignis erhalten soll. Als Werte
dieser Parameter k�nnen nur mit def benannte Objekte verwendet werden, bei denen
die Datentypen �bereinstimmen. Ein Beispiel f�r die Weiterleitung von
Ereignissen ist im Abschnitt L<Sensoren> zu finden.

=item def

F<def('name')>

 name SFString ""

Die Benennung eines Knotens ist Grundvoraussetzung f�r die Wiederverwendung
(Instanzierung) und das Weiterleiten von Ereignissen. Namen von Knoten,
Feldern, Ereignissen und Prototypen d�rfen nicht mit einer Ziffer beginnen
und keines der folgenden Zeichen enthalten:

    Steuerzeichen (ASCII 0 bis 31)
    Leerzeichen
    einfache und doppelte Anf�hrungszeichen
    Kommentarzeichen #
    Komma, Punkt und Semikolon
    Plus- und Minus-Zeichen
    Klammern
    Backslash

Beispiel:

    $vrml->def('Kugel')->sphere(1,'red')

=item use

F<use('name')>

 name SFString ""

Die Methode B<use> dient der Referenzierung bzw. Instanzierung eines mit der
Methode def definierten Objekts. Als einzigen Parameter ben�tigt sie den
Namen des Objekts.

Beispiel:

    $vrml->use('Kugel')

=back

=head1 SEE ALSO

VRML::VRML1

VRML::VRML1::Standard

VRML::VRML2

VRML::VRML2::Standard

VRML::Base

VRML::Color

Siehe auch http://www.gfz-potsdam.de/~palm/vrmlperl/ f�r weitere
Informationen zu den F<VRML-Modulen> und wie man sie einsetzen kann.

=head1 BUGS

Nicht alle Methoden wurden ausgiebig getestet. Manche Programmierer w�rden
sicher die Reihenfolge der Parameter anders w�hlen. Ich arbeiete daran, in
einer der n�chsten Versionen benannte Parameter einzusetzen.

=head1 AUTHOR

Hartmut Palm F<E<lt>palm@gfz-potsdam.deE<gt>>

Homepage http://www.gfz-potsdam.de/~palm/

=cut
