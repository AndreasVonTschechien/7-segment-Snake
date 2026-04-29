# SNA7E 🐍
[![University: VUT FEKT](https://img.shields.io/badge/VUT-FEKT-blue?style=flat-square&logo=university&logoColor=white)](https://www.fekt.vut.cz/)
[![Language: VHDL](https://img.shields.io/badge/language-VHDL-purple?style=flat-square&logo=intel&logoColor=white)](https://en.wikipedia.org/wiki/VHDL)
[![Hardware: 7-Segment](https://img.shields.io/badge/display-7--Segment-red?style=flat-square&logo=circuitpython&logoColor=white)](https://en.wikipedia.org/wiki/Seven-segment_display)


### Obsah
* [Úvod](#uvod)
* [Základní informace o projektu](#základní-informace-k-projektu-ℹ️)
* [Simulace komponentů](#simulace-komponent)
* [Základní pohyb hada po displeji](#základní-pohyb-hada-po-displeji)

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

# Simulace komponent
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
   * Po změně směru lze sledovat logiku „pěti pater“. Hodnota signálu segmentů `s_seg` se mění z počátečního `3f` (segment G) na `5f` (svislý segment F – schod) a nakonec na `7e` (horní vodorovný segment A). To dokazuje, že had plně využívá celou plochu sedmisegmentové cifry.
<img width="1482" height="460" alt="image" src="https://github.com/user-attachments/assets/2d1922b6-5d36-4442-9257-5b13d91029ca" />

<br>
<br>

# Základní pohyb hada po displeji
### RTL schéma
* Toto RTL schéma je základní kostra projektu. Tento program zastřešuje základní pohyb hada po zvolené hrací ploše 3x16.
<img width="1482" height="560" alt="image" src="https://github.com/AndreasVonTschechien/7-segment-Snake/blob/main/block_diagram_of_VHDL_design.png?raw=true" />

### Popis bloků RTL schématu
| Blok / Modul | Funkce| Význam v systému |
| :--- | :--- | :--- |
| **`debounce`** | Ošetření vstupů | Filtruje mechanické zákmity tlačítek a generuje čisté synchronní pulzy pro změnu směru. Nebýt tohoto modulu, had by se stal neovladatelným. |
| **`control_logic`** | Správa směru | Přijímá povely z debouncerů a udržuje stav aktuálního směru. Zabraňuje neplatným pohybům (např. otočení o 180° přímo do sebe). |
| **`clk_en` & `counter`** | Časování & Multiplex | Generují povolovací signály (`ce`) pro rychlost hry a zajišťují přepínání anod pro multiplexní řízení displeje. |
| **`movement_logic`** | Herní engine: | Hlavní mozek hry. Na základě herního taktu a směru vypočítává pozici hada, detekuje kolize a generuje data pro obraz. |

<br> 

<br> 

# Finalizace projektu
## RTL schéma
* **[📄 Odkaz na kompletní RTL schéma v PDF](./my_snake_schematic.pdf)**


* **TestBench komponenty COUNTER**
<img src="https://github.com/AndreasVonTschechien/7-segment-Snake/blob/main/tb_counter.png?raw=true" />
* **Simulace čítače**
* [cite_start]Na simulačním průběhu je patrná stabilita návrhu: modul korektně reaguje na synchronní reset `rst` [cite: 13][cite_start], který má prioritu před všemi ostatními operacemi[cite: 18].
* [cite_start]Klíčovou funkcí bloku je deklarovaný vstup `en` (Enable)[cite: 14]. [cite_start]Simulace prokazuje, že vnitřní signál `sig_cnt` [cite: 16] [cite_start]inkrementuje svou hodnotu pouze v případě, že je tento signál aktivní[cite: 19].
* [cite_start]V opačném případě modul uchovává svůj aktuální stav, což je nezbytné pro správnou funkci časování v nadřazeném systému hry Snake[cite: 20].
* [cite_start]Ověřili jsme také chování při přetečení (wrap-around), kdy modul po dosažení binární hodnoty `111` (dekadicky 7 pro `G_BITS = 3`) plynule přechází zpět na hodnotu `000`[cite: 12, 15, 19]. Tím je potvrzena správná funkce modulo aritmetiky v rámci definovaného rozsahu `G_BITS`[cite: 12].

<br> 

### TestBench komponenty DEBOUNCE
<img src="https://github.com/AndreasVonTschechien/7-segment-Snake/blob/main/tb_debounce.png?raw=true" />
* Hlavní náplní tohoto bloku je filtrace vstupních signálů z mechanických tlačítek, která používají vnitřní posuvný registr pro eliminaci zákmitů.   Na simulaci je patrné, že modul ignoruje úvodní sekvenci šumu na vstupu `btn_in`. Výstupní stav `btn_state` se mění na logickou jedničku až po uplynutí doby nezbytné pro stabilizaci signálu v celém rozsahu registru.   Klíčovým prvkem návrhu je deklarace pulzu `btn_press`. Jak prokazuje časový diagram, tento výstup generuje signál o šířce jednoho hodinového cyklu okamžitě po validaci stisku.  Tento mechanismus je kritický pro herní mechaniku, protože zajišťuje, že každý fyzický stisk tlačítka vyvolá v systému právě jednu akci, bez ohledu na délku stisku nebo kvalitu kontaktů tlačítka.

<br>

### TestBench komponenty SNAKE CONTROL
<img width="1442" height="288" alt="image" src="https://github.com/user-attachments/assets/6bef37b1-a6b6-48fb-815e-81cb69d1069f" />
Signál `sig_clk` generuje stabilní hodinový takt (10 ns) pro veškerou vnitřní synchronizaci bloku. Signál `sig_ce_game` určuje přesný moment, kdy se souřadnice hada přepočítají a posunou. Signál `sig_rst_btn` vynuluje na začátku herní stav a deklaruje startovní pozici hlavy na souřadnicích `x=7, y=4`. Signály `sig_u` a `sig_r` určují vstupní směrové povely (`Up, Right`) ... vidíme, že změna směru v paměti proběhne okamžitě, ale fyzický pohyb v datech nastane až s následným pulsem `sig_ce_game`.  Signál `sig_snake_out (x, y)` ovládá pohyb doprava (hodnota `x(0)` se postupně mění ze 7 na 8 a následně na 9, zatímco `y(0)` zůstává konstantní) a pohyb nahoru (po aktivaci `sig_u` se hodnota `x(0)` ustálí na 9 a začne klesat hodnota `y(0)` (4 → 3 → 2 → 1)). Signál `sig_snake_out.len` zůstává na hodnotě 1, protože v simulaci nedošlo ke kolizi hada s potravou."
<br>

### TestBench komponenty SNAKE DISPLAY
<img src="https://github.com/AndreasVonTschechien/7-segment-Snake/blob/main/tb_snake_display.png?raw=true" />
* Hlavní náplní této simulace je ověření správnosti multiplexního řízení a segmentového dekodéru. Signál `sig_an` je modul, který deklaruje korektní postupné spínání anod v závislosti na čítači `mux_cnt`. Hodnoty `fe` až `7f` potvrzují, že je v každý okamžik aktivní právě jeden displej v režimu společné anody. Signál `sig_seg` je modul, který úspěšně transformuje souřadnice bloku rekordů snake a food na budicí signály segmentů. Hodnota `7e` při nulté anodě prokazuje správné vykreslení hlavy hada na horním segmentu `(A)`. Hodnota `77` při sedmé anodě prokazuje korektní zobrazení potravy na spodním segmentu `(D)`.

<br>






















