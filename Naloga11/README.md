# Prva Domača Naloga

## Avtor

**Matej Klančar**

## Opis naloge

Naloga obravnava implementacijo podatkovne strukture za redke matrike in reševanje linearnih sistemov z iterativno metodo SOR v programskem jeziku Julia.

Ključni cilji naloge so:
- **Definicija tipa `RedkaMatrika`**: Ustvariti nov podatkovni tip, ki prostorsko učinkovito hrani redke matrike z uporabo dveh pomožnih matrik: ene za vrednosti (`V`) in druge za stolpčne indekse (`I`).
- **Implementacija osnovnih operacij**: Za novi tip definirati metode za osnovno delovanje, kot so:
    - Indeksiranje (`getindex`, `setindex!`).
    - Množenje z desne z vektorjem (`*`).
- **Implementacija metode SOR**: Napisati funkcijo `sor(A, b, x0, omega)`, ki reši sistem $A\boldsymbol{x} = \boldsymbol{b}$. Funkcija uporablja neskončno normo ostanka $\|A\boldsymbol{x}^{(k)} - \boldsymbol{b}\|_\infty$ kot pogoj za ustavitev.
- **Analiza parametra $\omega$**: Za podan testni primer poiskati optimalni relaksacijski parameter $\omega$, ki zagotavlja najhitrejšo konvergenco, in grafično predstaviti rezultate.

## Struktura Projekta

```
.
├── src
│   └── Naloga11.jl              # Glavni modul s definicijo RedkaMatrika in sor
│   └── demo.jl                  # Koda za iskanje optimalnega parametra ω
├── test
│   └── runtests.jl         # Testi za preverjanje pravilnosti implementacije
├── report
│   └── report.tex          # Izvorna koda poročila v LaTeXu
│   └── report.pdf          # Končno poročilo v PDF formatu
└── README.md               # Ta datoteka
```

## Navodila za Uporabo

### Zahteve
- Nameščena Julia.
- Nameščena distribucija LaTeX (npr. MiKTeX, TeX Live) za generiranje poročila.
- Julia paketi: `Graphs`, `Plots`.

### Priprava Okolja
1. Odprite terminal in se pomaknite v glavno mapo projekta.
2. Zaženite Julio:
   ```sh
   julia
   ```
3. Vstopite v `Pkg` način z vnosom `]`.
4. Aktivirajte okolje projekta in namestite potrebne pakete:
   ```julia-repl
   pkg> activate .
   pkg> instantiate
   ```

### 1. Kako pognati teste?
Testi preverijo pravilnost delovanja funkcij `getindex`, `setindex!`, `*` in `sor`.

Po pripravi okolja (korak 4 zgoraj) v `Pkg` načinu zaženite:
```julia-repl
pkg> test
```
Program se zaključi s sporočilom o prestanih testih.

### 2. Kako ustvariti poročilo?

S poljubnim urejevalnikom LaTeX prevedete datoteko `report.tex` v PDF. Na primer, z uporabo `pdflatex` v terminalu:

 ```sh
 cd report
 pdflatex report.tex
 ```
Zgenerirana bo datoteka `report.pdf`, ki se bo nahajala v mapi `report`.