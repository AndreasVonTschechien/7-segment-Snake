# SNA7E 🐍
[![University: VUT FEKT](https://img.shields.io/badge/VUT-FEKT-blue?style=flat-square&logo=university&logoColor=white)](https://www.fekt.vut.cz/)
[![Language: VHDL](https://img.shields.io/badge/language-VHDL-purple?style=flat-square&logo=intel&logoColor=white)](https://en.wikipedia.org/wiki/VHDL)
[![Hardware: 7-Segment](https://img.shields.io/badge/display-7--Segment-red?style=flat-square&logo=circuitpython&logoColor=white)](https://en.wikipedia.org/wiki/Seven-segment_display)


### Obsah
* [Úvod](#uvod)
* [Základní informace o projektu](#základní-informace-k-projektu-ℹ️)
* [Simulace komponentů](#simulace-komponentů)
* [Realizace](#realizace)

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

* **Start / Restart:** Pro spuštění nebo restart hry po prohře slouží dedikované tlačítko umístěné ve středu ovládácích prvků. Po stisku tlačítka dojde k resetu programu, had se zmenší na původní velikost a vrátí na startovní souřadnice.

<br>

<br>

# Základní informace k projektu ℹ️
### Blokové schéma projektu
<img width="1200" height="600" alt="image" src="https://github.com/AndreasVonTschechien/7-segment-Snake/blob/main/7-SEGMENT%20SNAKE.jpg?raw=true" />


### 1. CLK_EN (Clock Enable)
- Účel:   Dělič frekvence systémových hodin (Frequency Divider).
- Funkce: Transformuje vysokofrekvenční CLK na nízkofrekvenční puls 'CE'.
- Význam: Zpomaluje hru na hratelnou rychlost a synchronizuje timing všech bloků.

------------------------

### 2. DEBOUNCER 
- Účel:   Ošetření mechanických vstupů z tlačítek.
- Funkce: Odstraňuje elektrické zákmity (glitche) vznikající při stisku.
- Výstup: Generuje čisté "One-Shot" pulsy (šířka 1 CLK) pro ovládání směru.

------------------------

### 3. SNAKE LOGIC (Game Engine)
- Účel:   Hlavní herní procesor a stavový automat.
- Funkce: 
    * Výpočet souřadnic hlavy a segmentů těla.
    * Detekce kolizí (stěny, vlastní ocas) a konzumace potravy.
    * Správa herního stavu (Game Over, Score counting).
- Data:   Vystupuje skóre (LED_SCORE) a video data (SEG_VID_OUT).

------------------------

### 4. DISPLAY CONTROL (I/O Driver)
- Účel:   Ovladač rozhraní 7-segmentového displeje.
- Funkce: Provádí časový multiplex pro 8 cifer (přepínání anod).
- Převod: Dekóduje binární data z logiky na signály pro segmenty (katody).

<br>

## Rozhraní signálů (Entity I/O) 🔌
### Vstupní signály
| Signál | Směr | Šířka | Popis |
| :--- | :---: | :---: | :--- |
| **`CLK`** | In | 1 bit | Hlavní systémový hodinový signál (např. 100 MHz). |
| **`RST`** | In | 1 bit | Prostřední tlačítko, které uvádí hru do výchozího stavu. |
| **`BTN_UP`** | In | 1 bit | Vstupní signál pro pohyb hada nahoru. |
| **`BTN_DOWN`** | In | 1 bit | Vstupní signál pro pohyb hada dolů. |
| **`BTN_LEFT`** | In | 1 bit | Vstupní signál pro pohyb hada doleva. |
| **`BTN_RIGHT`**| In | 1 bit | Vstupní signál pro pohyb hada doprava. |

### Výstupní signály
| Signál | Směr | Šířka | Popis |
| :--- | :---: | :---: | :--- |
| **`SEG(7:0)`** | Out | 8 bitů | Ovládání jednotlivých segmentů (A-G + DP) pro 7-segmentový displej. |
| **`AN(7:0)`** | Out | 8 bitů | Společné anody pro výběr aktivní cifry (Multiplexing). |

### Interní propojení
* **`SIG_CE`**: Pomalý synchronizační puls z `CLK_EN`, který řídí taktování logiky a displeje.
* **`SIG_BTN_X_PRESS`**: Vyčištěné pulsy z `DEBOUNCERu` o délce jednoho taktu `CLK`.
* **`SIG_VID_OUT(63:0)`**: 64-bitová sběrnice nesoucí data o stavu "pixelů" (segmentů) pro zobrazení.

<br>
<br>

# Simulace komponentů
* **Generátor Clock Enable (`ce`)**
    * Systémové hodiny (clk) tikají na vysoké frekvenci, což je pro mechaniku hada příliš rychlé.
    * Místo vytváření nových hodinových domén běží vše na jedné frekvenci, ale modul `ce` generuje v pravidelných intervalech krátký „povolující“ pulz, který dovolí hadovi udělat krok jen jednou za určitý čas, čímž zajišťuje konstantní a hratelnou rychlost.
<img width="1200" height="250" alt="image" src="https://github.com/AndreasVonTschechien/7-segment-Snake/blob/main/clock_sim.png?raw=true" />

<br>

* **Debouncer a zpracování tlačítek**
    * Tlačítka jsou mechanická a při stisku generují krátké zákmity (digitální šum). Čip by tyto milisekundy trvající vibrace interpretoval jako desítky rychlých stisků za sebou. Debouncer tyto zákmity filtruje. Počká na ustálení signálu a do systému propustí pouze jeden čistý logický pulz. Díky tomu hra reaguje na každé zmáčknutí přesně jednou a had se neotočí o 180 stupňů omylem.
    * Po ustálení signálu generuje `sig_press_...` krátký pulz pro jednorázové vyhodnocení stisku.
    * Signály `sig_direction` mění stav okamžitě po detekci stisku a drží hodnotu až do dalšího platného povelu.
<img width="1200" height="500" alt="image" src="https://github.com/AndreasVonTschechien/7-segment-Snake/blob/main/direction_sim.png?raw=true" />

<br>

* **Simulace ovládání hada**
   * Na začátku časové osy je aktivován signál `s_btnc` (Reset). Dojde k nastavení výchozí pozice hada na střed displeje (s_x = 3, s_y = 2), což odpovídá čtvrté cifře zprava a prostřednímu    segmentu G. Směr pohybu je zahájen doprava `s_dir = 4`.
   * V průběhu simulace je patrné, jak se s každým přetečením vnitřního čítače mění hodnota souřadnice `s_x` (3 → 2 → 1). Tomu odpovídá i změna aktivní anody `s_an[7:0]` (hodnoty fb a fd), což potvrzuje, že se had korektně přesouvá mezi jednotlivými ciframi displeje.
   * Kolem času 250 ns dochází ke stisku tlačítka `s_btnu` (Nahoru). Simulace ověřuje funkci modulu `debounce.vhd` – signál směru `s_dir` se nezmění okamžitě, ale až po uplynutí filtrační doby definované čítačem debounceru. Poté směr plynule přechází na hodnotu `1`.
   * Po změně směru lze sledovat logiku „pěti pater“. Hodnota signálu segmentů `s_seg` se mění z počátečního `3f` (segment G) na `5f` (svislý segment F – schod) a nakonec na `7e` (horní vodorovný segment A). To dokazuje, že se had po displeji nepohybuje pouze lineárně, ale plně využívá celou plochu sedmisegmentové cifry.
<img width="1482" height="460" alt="image" src="https://github.com/user-attachments/assets/2d1922b6-5d36-4442-9257-5b13d91029ca" />

<br>
<br>

# Realizace 
### RTL schéma
<img width="1482" height="460" alt="image" src="https://github.com/AndreasVonTschechien/7-segment-Snake/blob/main/block_diagram_of_VHDL_design.png?raw=true" />

## Architektura systému (RTL schéma)
| Blok / Modul | Funkce | Význam v systému |
| :--- | :--- | :--- |
| **`debounce`** | Ošetření vstupů | Filtruje mechanické zákmity tlačítek a generuje čisté synchronní pulzy pro změnu směru. Nebát tohoto modulu, had by se stal neovladatelným. |
| **`control_logic`** | Správa směru | Přijímá povely z debouncerů a udržuje stav aktuálního směru. Zabraňuje neplatným pohybům (např. otočení o 180° přímo do sebe). |
| **`clk_en` & `counter`** | Časování & Multiplex | Generují povolovací signály (`ce`) pro rychlost hry a zajišťují přepínání anod pro multiplexní řízení displeje. |
| **`movement_logic`** | Herní engine: | Hlavní mozek hry. Na základě herního taktu a směru vypočítává pozici hada, detekuje kolize a generuje data pro obraz. |

































