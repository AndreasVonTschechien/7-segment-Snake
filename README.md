# 7-segment-Snake
**Pravidla:** 

  **Herní plocha:**
    - tvořena 8 sedmisegmentovými displeji vedle sebe (tvoří pole o rozměrech 3x16)\n
    - každý displej představuje jednu pozici hada
    
  **Snake:**
    - had se skládá z několika svítících segmentů 
    - může se pohybovat ve 4 směrech: ↑ ↓ → ←
    - had se automaticky posouvá v daném směru v pravidelném intervalu 
    - hráč může měnit směr hada tlačítky
    
  **Potrava:**
    - potrava se objevuje náhodně na jednom ze segmentů displeje
    - po "sežrání“ potravy se had prodlouží, zvýší se skóre a zvýší rychlost pohybu

  **Kolize:**
    - hra končí, pokud: had narazí do sebe **NEBO** vyčerpal všechny dostupná pole
    - z důvodu menšího herního prostoru bude hadovi umožněn průchod hranicemi arény ve všech směrech

  **Skóre:**
    - skóre se zobrazuje pomocí svitu diod **→** jeden bod = jedna svítící dioda

  **Start / Restart:**
    - bude realizováno tlačítko pro spuštění nebo restart hry po prohře 


**Členové týmu:**
- Ondřej Gracias (269670)
- Matěj Jurka (269810)
- Dorazil Matouš (269044)
- Dostál Matěj (272709)

