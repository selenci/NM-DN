# Tretja Domača Naloga

## Avtor

**Matej Klančar**

## Opis naloge

Naloga obravnava analizo in numerično reševanje diferencialne enačbe za matematično nihalo v programskem jeziku Julia. Poudarek je na primerjavi polnega nelinearnega modela s poenostavljeno harmonično aproksimacijo.

Ključni cilji naloge so:
- **Implementacija reševalnika za matematično nihalo**: Prevesti enačbo drugega reda v sistem dveh enačb prvega reda in ga rešiti z uporabo numerične metode `DP5` iz paketa `DifferentialEquations.jl`.
- **Primerjava nelinearnega modela s harmonično aproksimacijo**: Grafično prikazati razlike v nihanju med obema modeloma za različne začetne kote (amplitude).
- **Analiza odvisnosti nihajnega časa od amplitude**: Numerično raziskati in grafično ponazoriti, kako se perioda nihanja spreminja z začetno energijo (kotom) nihala, kar je ključna razlika v primerjavi s harmoničnim nihalom, ki ima konstantno periodo.

## Struktura Projekta

```
.
├── src
│   ├── Naloga35.jl              # Glavni modul s funkcijami za reševanje in analizo
│   └── demo.jl                  # Skripta za generiranje vseh grafov za poročilo
├── slike
│   ├── perioda_vs_kot.png      # Generirani grafi
│   └── ...
├── report
│   ├── report.tex               # Izvorna koda poročila v LaTeXu
│   └── report.pdf               # Končno poročilo v PDF formatu
└── README.md                    # Ta datoteka
```

## Navodila za Uporabo

### Zahteve
- Nameščena Julia.
- Nameščena distribucija LaTeX (npr. MiKTeX, TeX Live) za generiranje poročila.
- Julia paketi: `DifferentialEquations`, `Plots`.

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

### 1. Kako generirati grafe?
Skripta `src/demo.jl` vsebuje klice funkcij, ki ustvarijo vse potrebne grafe in jih shranijo v mapo `slike/`.

V terminalu zaženite:
```sh
julia --project src/demo.jl
```
Mapa `slike` bo posodobljena z rezultati.

### 2. Kako ustvariti poročilo?

S poljubnim urejevalnikom LaTeX prevedete datoteko `report.tex` v PDF. Na primer, z uporabo `pdflatex` v terminalu:

 ```sh
 cd report
 pdflatex report.tex
 ```
Zgenerirana bo datoteka `report.pdf`, ki se bo nahajala v mapi `report`.
