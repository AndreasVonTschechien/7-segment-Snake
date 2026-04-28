# 7-segment-Snake
## Cíl projektu
Cílem projektu je za pomoci 8 7-segmentových displejů vytvořit funkční a hratelnou verzi populární hry "Snake".
Výsledný projekt bude následně předveden na desce Nexys A7-50T, doplněn krátkým videem, plakátem formátu A3 a přehledným repozitářem na GitHubu.

### Členové týmu
- Ondřej Gracias (269670)
- Matěj Jurka (269810)
- Dorazil Matouš (269044)
- Dostál Matěj (272709)


## Pravidla

- **Herní plocha:**
  - tvořena 8 sedmisegmentovými displeji vedle sebe (tvoří pole o rozměrech 3x16)
  - každý displej představuje jednu pozici hada

- **Snake:**
  - had se skládá z několika svítících segmentů
  - může se pohybovat ve 4 směrech: ↑ ↓ → ←
  - had se automaticky posouvá v daném směru v pravidelném intervalu
  - hráč může měnit směr hada tlačítky

- **Potrava:**
  - potrava se objevuje náhodně na jednom ze segmentů displeje
  - po „sežrání“ potravy se had prodlouží, zvýší se skóre a zvýší rychlost pohybu

- **Kolize:**
  - hra končí, pokud:
    - had narazí do sebe
    - nebo vyčerpal všechna dostupná pole
  - z důvodu omezeného herního prostoru je umožněn průchod hranicemi arény ve všech směrech

- **Skóre:**
  - skóre se zobrazuje pomocí svitu diod → jeden bod = jedna svítící dioda

- **Start / Restart:**
  - tlačítko pro spuštění nebo restart hry po prohře

## LAB1 - 8.4.2026
-adasdasd

## LAB2 - 15.4.2026
-adasdasd

## LAB3 - 22.4.2026

**Pro Jurkise TESTBENCH**

Verifikace návrhu (Simulace)
Na přiloženém screenshotu z Vivado simulátoru je demonstrována funkčnost hlavní řídicí logiky hry. Simulace potvrzuje správnou součinnost všech komponent: synchronního čítače (rychlost hry), debounceru (ošetření vstupů) a stavového automatu pohybu.

Klíčové fáze simulace:Inicializace a Reset: Na začátku časové osy je aktivován signál s_btnc (Reset). Dojde k nastavení výchozí pozice hada na střed displeje (s_x = 3, s_y = 2, což odpovídá čtvrté cifře zprava a prostřednímu segmentu G) a směru pohybu doprava (s_dir = 4).

Automatický pohyb (Osa X): Je vidět, jak se s každým přetečením vnitřního čítače  mění hodnota s_x (z 3 na 2 a následně na 1). Tomu odpovídá i změna aktivní anody s_an[7:0] (hodnoty fb a fd), což potvrzuje, že had se korektně přesouvá mezi jednotlivými ciframi displeje.

Zpracování vstupu a Debouncing: Kolem času 250 ns dochází ke stisku tlačítka Nahoru (s_btnu). Simulace potvrzuje funkci modulu debounce.vhd – signál směru s_dir se nezmění okamžitě, ale až po uplynutí filtrační doby definované čítačem debounceru. Poté směr plynule přechází na hodnotu 1 (Nahoru).

Vertikální pohyb (Schody): Po změně směru můžeme sledovat logiku „pěti pater“. Signál segmentů s_seg se mění z počátečního 3f (segment G) na 5f (svislý segment F – schod) a nakonec na 7e (horní vodorovný segment A). To dokazuje, že had se po displeji nepohybuje jen lineárně, ale využívá celou plochu 7-segmentové cifry.

Závěr simulace:Simulace potvrdila, že systém správně interpretuje stisky tlačítek, filtruje zákmity a udržuje logickou integritu pohybu hada v rámci definovaných omezení displeje.
<img width="1482" height="460" alt="image" src="https://github.com/user-attachments/assets/2d1922b6-5d36-4442-9257-5b13d91029ca" />



