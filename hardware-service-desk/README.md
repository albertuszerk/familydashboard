# Hardware Service Desk

![Hardware Service Desk Banner](images/Banner.jpg)

> **Hardware Service Desk (Physische Durchreiche & Verwahrung)**  
> Zur physischen Verwahrung von Handies dient die nachbarschaftliche Balkon-Durchreiche mit integriertem Sichtschutz und einem Vogelhäuschen.

[← Zurück zum Hauptprojekt (familydashboard)](../README.md)

---

## 1. Problemstellung: Das Bildschirm-Dilemma

<table>
  <tr>
    <td width="55%" valign="top">
      Digitale Filterregeln, Kindersicherungen und zeitbasierte Software-Sperren stossen im Familienalltag regelmässig an ihre Grenzen: Sie erzeugen endlose Diskussionen, fordern Umgehungstricks heraus und verlagern Konflikte in die reine Softwareebene.
      <br><br>
      Wenn digitale Limiten nicht mehr greifen, hilft eine unmissverständliche, analoge Schnittstelle. Der <b>Hardware Service Desk</b> verlagert die Verwahrung aus dem Spannungsfeld des Kinderzimmers an eine physische Übergabestelle – transparent, verlässlich und mit klaren Ritualen.
    </td>
    <td width="45%" align="center" valign="middle">
      <img src="images/Service-Desk.jpg" alt="Service Desk" width="100%" />
    </td>
  </tr>
</table>

---

## 2. Funktionsweise & Architektur

| Baugruppe | Funktion |
| :--- | :--- |
| **Ladeschublade** | Schubfach zur kontaktlosen Abgabe und Verwahrung des Smartphones |
| **Magnetschlüssel** | Unsichtbare Verriegelung der Schublade |
| **Sichtschutz** | Schutz der Privatsphäre |
| **Vogelhaus** | Tarnung & Nistplatz |
| **Wetter- & Regenschutz** | Abtropfkante |
| **Meshcore-Integration** | Wettergeschützte Aufnahme eines solarunterstützten Funkknotens ([Meshcore](https://www.meshcore.io)) |

---

## 3. Die Ladeschublade (Verwahr- & Schliessmechanik)

Die beiden Schubladen sind passgenau für gängige Smartphones gefräst.

* **Verriegelung:** Die Sperre greift mechanisch. Ein Entriegeln ist nur über den zugehörigen Magnetschlüssel möglich.
* **Zwei-Wege-System:** Über die getrennte Entnahme-Schublade können Geräte kontrolliert entnommen werden, ohne die Gesamtanlage öffnen zu müssen.

<p align="center">
  <img src="images/Magnet-Schluessel1.jpg" alt="Magnet-Schlüssel" width="48%" />
  <img src="images/Entnahme-Schublade1.jpg" alt="Entnahme-Schublade" width="48%" />
</p>

---

## 4. Videos zur Demonstration

* [Funktionsweise & Basisfunktion ansehen](https://youtu.be/EO7W-KcHg_o)
* [Servicefunktion & Mechanik von unten ansehen](https://youtu.be/3OLYUpjaIk4)

---

## 5. Konstruktion, CAD & Montage

Die gesamte Konstruktion ist mietwohnungskonform ausgeführt: Sie klemmt beschädigungsfrei auf dem vorhandenen Handlauf des Balkongeländers.

* **3D-Modell (SketchUp Archiv):** [Direkter Download: 3D-Plan-Balkon-Durchreiche-v1.0.zip](https://raw.githubusercontent.com/albertuszerk/familydashboard/main/hardware-service-desk/cad/3D-Plan-Balkon-Durchreiche-v1.0.zip)
* **Integritätsprüfung (SHA-256):** `76f2eb862b67277f1c25b4c770af4d649f2860217d21bb4c999bf9bb0b90206e`
* **Laser-Montageblech (Onshape):** [Onshape Montageblech CAD-Modell](https://cad.onshape.com/documents/048f00407a617d19f4a008ea/w/fefb94ada2602383629b39b9/e/5afe78f2b9829ff1aa034ac5?renderMode=0)

<p align="center">
  <img src="images/Planungsansicht1-in-3D.jpg" width="31%" />
  <img src="images/Montage-Blech1-3D.jpg" width="31%" />
  <img src="images/Befestigungsvorrichtung1.jpg" width="31%" />
</p>

---

## 6. Witterungsschutz & Meshcore-Knoten

* **Regenabweiser:** Durch gezielte Abtropfleisten bleibt die Lade- und Entladezone bei Regenfall trocken.
* **Meshcore-Node:** Das Vogelhaus dient gleichzeitig als unauffälliges Gehäuse für einen autarken LoRa-/[Meshcore](https://www.meshcore.io)-Repeater.

<p align="center">
  <img src="images/Regenabweiser1.jpg" alt="Regenabweiser" width="48%" />
  <img src="images/Vogelhaus-Wartungsposition5-mit-MeshcoreNode.jpg" alt="Meshcore-Node im Vogelhaus" width="48%" />
</p>

---

## 7. Bildergalerie

### Schubladen & Schliessmechanismus
| | | |
| :---: | :---: | :---: |
| ![Ladeschublade geöffnet](images/Ladeschublade-geoeffnet.jpg)<br><sub>Ladeschublade geöffnet</sub> | ![Ladeschublade geschlossen](images/Ladeschublade-geschlossen.jpg)<br><sub>Ladeschublade geschlossen</sub> | ![Ladeschublade mit Handy](images/Ladeschublade-mit-Handy.jpg)<br><sub>Ladeschublade mit Handy</sub> |
| ![Ladeschublade ohne Handy](images/Ladeschublade-ohne-Handy.jpg)<br><sub>Ladeschublade ohne Handy</sub> | ![Entnahme geschlossen](images/Entnahme-Schublade-geschlossen.jpg)<br><sub>Entnahme geschlossen</sub> | ![Entnahme mit Handy](images/Entnahmeschublade-mit-Handy.jpg)<br><sub>Entnahme mit Handy</sub> |
| ![Beide Schubladen](images/Beide-Schubladen-Obenansicht.jpg)<br><sub>Beide Schubladen (Obenansicht)</sub> | ![Service-Desk Abgabestelle](images/Service-Desk-Abgabestelle.jpg)<br><sub>Service-Desk Abgabestelle</sub> | ![Funktionsweise Magnetschlüssel](images/Funktionsweise-Magnetschluessel.jpg)<br><sub>Funktionsweise Magnetschlüssel</sub> |

### Magnetschlüssel & Schliessfunktion
| | | |
| :---: | :---: | :---: |
| ![Schliessfunktion von unten](images/Schliessfunktion-von-unten.jpg)<br><sub>Schliessfunktion von unten</sub> | ![MagnetClip 1](images/MagnetClip1.jpg)<br><sub>MagnetClip 1</sub> | ![MagnetClip 2](images/MagnetClip2.jpg)<br><sub>MagnetClip 2</sub> |
| ![Scharnierbefestigung](images/Scharnierbefestigung.jpg)<br><sub>Scharnierbefestigung</sub> | | |

### Sichtschutz mit Schliessfunktion
| | | |
| :---: | :---: | :---: |
| ![Sichtschutz geöffnet 1](images/Durchreiche-Sichtschutz-geoeffnet1-Schlumpfparadies.jpg)<br><sub>Sichtschutz geöffnet (Schlumpfparadies)</sub> | ![Sichtschutz geöffnet 2](images/Durchreiche-Sichtschutz-geoeffnet2.jpg)<br><sub>Sichtschutz geöffnet</sub> | ![Sichtschutz geöffnet mit Schliessfunktion](images/Durchreiche-Sichtschutz-geoeffnet3-mit-Schliessfunktion.jpg)<br><sub>Sichtschutz geöffnet mit Verriegelung</sub> |
| ![Sichtschutz geschlossen 1](images/Durchreiche-Sichtschutz-geschlossen1.jpg)<br><sub>Sichtschutz geschlossen 1</sub> | ![Sichtschutz geschlossen 2](images/Durchreiche-Sichtschutz-geschlossen2.jpg)<br><sub>Sichtschutz geschlossen 2</sub> | ![Sichtschutz geschlossen 3](images/Durchreiche-Sichtschutz-geschlossen3.jpg)<br><sub>Sichtschutz geschlossen 3</sub> |
| ![Sichtschutz geschlossen 4](images/Durchreiche-Sichtschutz-geschlossen4.jpg)<br><sub>Sichtschutz geschlossen 4</sub> | ![Sichtschutz geschlossen 5](images/Durchreiche-Sichtschutz-geschlossen5.jpg)<br><sub>Sichtschutz geschlossen 5</sub> | ![Ansicht links/rechts](images/Ansicht-links-rechts1.jpg)<br><sub>Ansicht links / rechts</sub> |

### Vogelhaus & Meshcore-Node
| | | |
| :---: | :---: | :---: |
| ![Ausladung Vogelhaus 1](images/Ausladung-Vogelhaus1.jpg)<br><sub>Ausladung Vogelhaus 1</sub> | ![Ausladung Vogelhaus 2](images/Ausladung-Vogelhaus2.jpg)<br><sub>Ausladung Vogelhaus 2</sub> | ![Ausladung Vogelhaus 3](images/Ausladung-Vogelhaus3.jpg)<br><sub>Ausladung Vogelhaus 3</sub> |
| ![Vogelhaus Ansicht hinten](images/Vogelhaus-Ansicht-hinten.jpg)<br><sub>Vogelhaus Ansicht hinten</sub> | ![Wartungsposition 1](images/Vogelhaus-Wartungsposition1.jpg)<br><sub>Wartungsposition 1</sub> | ![Wartungsposition 2](images/Vogelhaus-Wartungsposition2.jpg)<br><sub>Wartungsposition 2</sub> |
| ![Wartungsposition 3](images/Vogelhaus-Wartungsposition3.jpg)<br><sub>Wartungsposition 3</sub> | ![Wartungsposition 4](images/Vogelhaus-Wartungsposition4.jpg)<br><sub>Wartungsposition 4</sub> | ![Wartungsposition 6 Meshcore](images/Vogelhaus-Wartungsposition6-mit-MeshcoreNode.jpg)<br><sub>Wartungsposition mit Meshcore-Node Detail</sub> |
| ![Durchreiche mit Meshcore](images/Durchreiche-mit-MeshcoreNode1.jpg)<br><sub>Durchreiche mit Meshcore-Node</sub> | ![Draufsicht](images/Draufsicht1.jpg)<br><sub>Draufsicht</sub> | |

### Montage, Bleche & Geländerklemmen
| | | |
| :---: | :---: | :---: |
| ![Befestigungsvorrichtung 1](images/Befestigungsvorrichtung1.jpg)<br><sub>Befestigungsvorrichtung 1</sub> | ![Befestigungsvorrichtung 2](images/Befestigungsvorrichtung2.jpg)<br><sub>Befestigungsvorrichtung 2</sub> | ![Montageblech 3D 1](images/Montage-Blech1-3D.jpg)<br><sub>Montageblech 3D (1)</sub> |
| ![Montageblech 3D 2](images/Montage-Blech2-3D.jpg)<br><sub>Montageblech 3D (2)</sub> | ![Montageblech 3D 3](images/Montage-Blech3-3D.jpg)<br><sub>Montageblech 3D (3)</sub> | ![Planungsansicht 3D](images/Planungsansicht2-in-3D.jpg)<br><sub>Planungsansicht 3D (2)</sub> |
| ![Ansicht unten mit Blech 1](images/Ansicht-unten-mit-Montageblech1.jpg)<br><sub>Ansicht unten mit Montageblech 1</sub> | ![Ansicht unten mit Blech 2](images/Ansicht-unten-mit-Montageblech2.jpg)<br><sub>Ansicht unten mit Montageblech 2</sub> | ![Ansicht unten ohne Blech](images/Ansicht-unten-ohne-Montageblech.jpg)<br><sub>Ansicht unten ohne Montageblech</sub> |
| ![Ansicht unten 1](images/Ansicht-unten1.jpg)<br><sub>Ansicht unten 1</sub> | ![Ansicht unten 2](images/Ansicht-unten2.jpg)<br><sub>Ansicht unten 2</sub> | ![Ansicht unten 3](images/Ansicht-unten3.jpg)<br><sub>Ansicht unten 3</sub> |
| ![Durchreiche Obenansicht](images/Durchreiche-Ansicht-oben.jpg)<br><sub>Durchreiche Obenansicht</sub> | ![Regenabweiser 2](images/Regenabweiser2.jpg)<br><sub>Regenabweiser Detail 2</sub> | |

---

[← Zurück zum Hauptprojekt (familydashboard)](../README.md)

`#FamilyDashboard` `#HardwareServiceDesk` `#DigitalDetox` `#MakerDIY` `#Holzhandwerk` `#CAD` `#Onshape` `#SketchUp` `#Meshcore` `#LoRa` `#BalkonDIY` `#ParentingHacks`
