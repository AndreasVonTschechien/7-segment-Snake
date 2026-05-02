# SNA7E 🐍
[![University: VUT FEKT](https://img.shields.io/badge/VUT-FEKT-blue?style=flat-square&logo=university&logoColor=white)](https://www.fekt.vut.cz/)
[![Language: VHDL](https://img.shields.io/badge/language-VHDL-purple?style=flat-square&logo=intel&logoColor=white)](https://en.wikipedia.org/wiki/VHDL)
[![Hardware: 7-Segment](https://img.shields.io/badge/display-7--Segment-red?style=flat-square&logo=circuitpython&logoColor=white)](https://en.wikipedia.org/wiki/Seven-segment_display)


### Obsah
* [Úvod](#uvod)
* [Základní informace o projektu](#základní-informace-k-projektu)
* [Simulace komponentů](#simulace-komponent)
* [Základní pohyb hada po displeji](#základní-pohyb-hada-po-displeji)
* [Finalizace projektu](#Finalizace-projektu)

## Úvod
Cílem projektu je za pomoci 8 7-segmentových displejů vytvořit funkční a hratelnou verzi populární hry "Snake".
Výsledný projekt bude následně předveden na desce Nexys A7-50T, doplněn krátkým videem, plakátem formátu A3 a přehledným repozitářem na GitHubu.

### Členové týmu
- Ondřej Gracias (269670)
- Matěj Jurka (269810)
- Dorazil Matouš (269044)
- Dostál Matěj (272709)

## Pravidla hry
* **Herní plocha a Snake:** Pole tvoří 8 sedmisegmentových displejů (dohromady tvoří pole o 3 řadách a 16 sloupcích), kde každý segment představuje jednu pozici. Had se skládá ze svítících segmentů, pohybuje se automaticky ve 4 směrech a hráč mění směr tlačítky.

<br>

* **Potrava a skóre:** Potrava se objevuje náhodně na segmentech. Po „sežrání“ se had prodlouží, zvýší se rychlost a skóre, které se zobrazuje pomocí diod (jeden bod = jedna svítící dioda).

<br>


* **Kolize a konec:** Hra končí, pokud had narazí do sebe nebo vyčerpá všechna pole. Z důvodu omezeného prostoru je umožněn průchod hranicemi arény ve všech směrech.

<br>

* **Start / Restart:** Pro spuštění nebo restart hry po prohře slouží dedikované tlačítko umístěné ve středu ovládacích prvků. Po stisku tlačítka dojde k resetu programu, had se zmenší na původní velikost a vrátí na startovní souřadnice.

<br>

<br>

# Základní informace k projektu

## Blokové schéma
<br>

## Rozhraní signálů (Vstupní / Výstupní / Vnitřní)
### Vstupní signály
| Signál | Směr | Šířka | Popis |
| :--- | :---: | :---: | :--- |
| **`CLK`** | In | 1 bit | Hlavní systémový hodinový signál. |
| **`BTNC`** | In | 1 bit | Vstupní signál z tlačítka, který uvádí hru do výchozího stavu. |
| **`BTNU`** | In | 1 bit | Vstupní signál z tlačítka pro pohyb hada nahoru. |
| **`BTND`** | In | 1 bit | Vstupní signál z tlačítka pro pohyb hada dolů. |
| **`BTNL`** | In | 1 bit | Vstupní signál z tlačítka pro pohyb hada doleva. |
| **`BTNR`**| In | 1 bit | Vstupní signál z tlačítka pro pohyb hada doprava. |

### Výstupní signály
| Signál | Směr | Šířka | Popis |
| :--- | :---: | :---: | :--- |
| **`SEG(6:0)`** | Out | 7 bitů |Výstupní signál pro spínání jednotlivých segmentů (A-G) na 7-segmentovém displeji. |
| **`AN(7:0)`** | Out | 8 bitů | Výstupní signál pro spínání příslušné anody pro výběr aktivní cifry. |
| **`LED(15:0)`** | Out | 16 bitů |  Výstupní signál pro spínání příslušné LED diody. |

### Vnitřní propojení
* **`SIG_CE`**: Pomalý synchronizační puls z `CLK_EN`, který řídí taktování logiky a displeje.
* **`SIG_BTN_X_PRESS`**: Vyčištěné pulsy z `DEBOUNCERu` o délce jednoho taktu `CLK`.
* **`SIG_VID_OUT(63:0)`**: 64-bitová sběrnice nesoucí data o stavu "pixelů" (segmentů) pro zobrazení.

<br>
<br>

## RTL schéma
* **[📄 Odkaz na kompletní RTL schéma v PDF](./Schémata/my_snake_schematic.pdf)**

### Popis jednotlivých bloků
| Modul / Blok | Funkce / Význam v systému | Klíčové informace |
| :--- | :--- | :--- |
| **DEB_U, D, L, R, C** | **Debouncer** (Ošetření tlačítek) | Hlavní náplní je filtrace mechanických zákmitů tlačítek. Deklaruje čistý puls `press` pro synchronní zpracování uživatelského vstupu (směru hada). |
| **CLK_GM** | **Game Clock Enable** (Dělička hry) | Generuje pomalý puls pro řízení rychlosti pohybu hada. Využívá generické parametry pro nastavení frekvence (např. 2 Hz). |
| **CLK_MUX** | **Mux Clock Enable** (Dělička displeje) | Deklaruje rychlý takt pro přepínání (multiplexování) sedmisegmentových displejů, aby nedocházelo k blikání obrazu nebo nežádoucím obrazcům. |
| **GAME_CTRL** | **Snake Control** (Herní jádro) | Představuje "mozek" hry. Vypočítává pohyb, detekuje kolize a spravuje pozici jídla. Komunikuje skrze komplexní záznamy (Records). |
| **CNT_MUX** | **Counter** (Adresace displejů) | Tříbitový čítač, který cykluje mezi adresami 0 až 7. Tímto čítáním určuje, která anoda displeje je aktuálně aktivní a která bude aktivní jako další. |
| **DISP_DRV** | **Snake Display** (Grafický řadič) | Zajišťuje transformaci souřadnic hada na konkrétní segmenty displeje. Deklaruje logiku pro vykreslování jídla a těla hada. |
| **SCORE_DRV** | **Snake Score** (Indikace skóre) | Převádí aktuální délku hada z modulu `snake_control` na vizuální zobrazení. Ovládá 16 LED diod na desce FPGA. |

<br> 

### TestBench komponenty COUNTER
   * Hlavní náplní tohoto bloku je lineární čítání pulzů, které deklaruje výstupní port `cnt`. Na simulačním průběhu můžeme jasně vidět stabilitu návrhu: modul korektně reaguje na synchronní reset, který má prioritu před všemi ostatními operacemi.  Klíčovou funkcí je zde deklarovaný vstup `en` (enable).
   * Simulace prokazuje, že čítač inkrementuje svou hodnotu pouze v případě, že je tento signál aktivní. V opačném případě modul uchovává svůj stav, což je nezbytné pro správnou funkci časování v nadřazeném systému hry Snake. Ověřili jsme také chování při přetečení, kdy modul po dosažení binární hodnoty `111` (dekadicky 7) plynule přechází zpět na hodnotu `000`, čímž deklaruje správnou funkci modulo aritmetiky v rámci definovaného rozsahu `G_BITS`.
<img src="https://github.com/AndreasVonTschechien/7-segment-Snake/blob/main/TestBenches/tb_counter.png?raw=true" />

* **[📄 Odkaz na TestBench komponenty COUNTER](./SNAKE_FINAL.srcs/sim_1/new/tb_counter.vhd)**


<br> 

### TestBench komponenty DEBOUNCE
* Hlavní náplní tohoto bloku je filtrace vstupních signálů z mechanických tlačítek, která používají vnitřní posuvný registr pro eliminaci zákmitů. Na simulaci je patrné, že modul ignoruje úvodní sekvenci šumu na vstupu `btn_in`. Výstupní stav `btn_state` se mění na logickou jedničku až po uplynutí doby nezbytné pro stabilizaci signálu v celém rozsahu registru.
* Klíčovým prvkem návrhu je deklarace pulzu `btn_press`. Jak prokazuje časový diagram, tento výstup generuje signál o šířce jednoho hodinového cyklu okamžitě po validaci stisku. Tento mechanismus je kritický pro herní mechaniku, protože zajišťuje, že každý fyzický stisk tlačítka vyvolá v systému právě jednu akci, bez ohledu na délku stisku nebo kvalitu kontaktů tlačítka.
<img src="https://github.com/AndreasVonTschechien/7-segment-Snake/blob/main/TestBenches/tb_debounce.png?raw=true" />

* **[📄 Odkaz na TestBench komponenty DEBOUNCE](./SNAKE_FINAL.srcs/sim_1/new/tb_debounce.vhd)**

<br>

### TestBench komponenty SNAKE CONTROL
* Signál `sig_clk` generuje stabilní hodinový takt (10 ns) pro veškerou vnitřní synchronizaci bloku. Signál `sig_ce_game` určuje přesný moment, kdy se souřadnice hada přepočítají a posunou. Signál `sig_rst_btn` vynuluje na začátku herní stav a deklaruje startovní pozici hlavy na souřadnicích `x=7, y=4`.
* Signály `sig_u` a `sig_r` určují vstupní směrové povely (`Up, Right`) ... vidíme, že změna směru v paměti proběhne okamžitě, ale fyzický pohyb v datech nastane až s následným pulsem `sig_ce_game`.  Signál `sig_snake_out (x, y)` ovládá pohyb doprava (hodnota `x(0)` se postupně mění ze 7 na 8 a následně na 9, zatímco `y(0)` zůstává konstantní) a pohyb nahoru (po aktivaci `sig_u` se hodnota `x(0)` ustálí na 9 a začne klesat hodnota `y(0)` (4 → 3 → 2 → 1)). Signál `sig_snake_out.len` zůstává na hodnotě 1, protože v simulaci nedošlo ke kolizi hada s potravou.
<img width="1442" height="288" alt="image" src="https://github.com/user-attachments/assets/6bef37b1-a6b6-48fb-815e-81cb69d1069f" />
<br>

* **[📄 Odkaz na TestBench komponenty SNAKE CONTROL](./SNAKE_FINAL.srcs/sim_1/new/tb_snake_control.vhd)**

<br>

### TestBench komponenty SNAKE DISPLAY
* Hlavní náplní této simulace je ověření správnosti multiplexního řízení a segmentového dekodéru. Signál `sig_an` je modul, který deklaruje korektní postupné spínání anod v závislosti na čítači `mux_cnt`. Hodnoty `fe` až `7f` potvrzují, že je v každý okamžik aktivní právě jeden displej v režimu společné anody.
* Signál `sig_seg` je modul, který úspěšně transformuje souřadnice bloku rekordů snake a food na budicí signály segmentů. Hodnota `7e` při nulté anodě prokazuje správné vykreslení hlavy hada na horním segmentu `(A)`. Hodnota `77` při sedmé anodě prokazuje korektní zobrazení potravy na spodním segmentu `(D)`.
<img src="https://github.com/AndreasVonTschechien/7-segment-Snake/blob/main/TestBenches/tb_snake_display.png?raw=true" />

* **[📄 Odkaz na TestBench komponenty SNAKE DISPLAY](./SNAKE_FINAL.srcs/sim_1/new/tb_snake_display.vhd)**

<br>






















