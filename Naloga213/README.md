# Druga Domača Naloga

## Avtor

**Matej Klančar**

## Opis naloge

Naloga obravnava izpeljavo in uporabo Gauss–Legendrove integracijske metode.

Ključni cilji naloge so:
- **Izpeljava Gauss-Legendrove formule**: Analitično izpeljati dvotočkovno Gauss-Legendrovo integracijsko pravilo na standardnem intervalu `[-1, 1]` in nato izvesti transformacijo za uporabo na poljubnem intervalu `[a, b]`.
- **Implementacija sestavljenega pravila**: V Julii napisati program, ki uporablja sestavljeno dvotočkovno Gaussovo pravilo za numerično integracijo funkcije $\frac{\sin x}{x}$.
- **Ocena konvergence**: Z implementiranim programom oceniti, koliko izračunov funkcijske vrednosti je potrebnih, da bi dosegli natančnost integrala na $10$ decimalnih mest.

## Struktura Projekta

```
.
├── src
│   └── Naloga213.jl          # Skripta za izvedbo numeričnega eksperimenta
├── report
│   └── report.tex          # Izvorna koda poročila v LaTeXu
│   └── report.pdf          # Končno poročilo v PDF formatu
└── README.md               # Ta datoteka
```

## Navodila za uporabo

### Zahteve
- Nameščena Julia.
- Nameščena distribucija LaTeX (npr. MiKTeX, TeX Live) za generiranje poročila.

### Priprava Okolja
1. Odprite terminal in se pomaknite v glavno mapo projekta.
2. Zaženite Julio:
   ```sh
   julia
   ```
3. Vstopite v `Pkg` način z vnosom `]`.
4. Aktivirajte okolje projekta:
   ```julia-repl
   pkg> activate .
   ```

### 1. Ocena števila izračunov
Skripta v mapi `src` izračuna potrebno število podintervalov za dosego želene natančnosti.

V terminalu zaženite:
```sh
julia src/Naloga213.jl
```
Program bo izpisal zaporedne približke integrala in se na koncu zaključil z izpisom končnega števila točk, potrebnih za dosego natančnosti.

### 2. Kako ustvariti poročilo?

S poljubnim urejevalnikom LaTeX prevedete datoteko `report/report.tex` v PDF. Na primer, z uporabo `pdflatex` v terminalu:

 ```sh
 cd report
 pdflatex report.tex
 ```
Zgenerirana bo datoteka `report.pdf`, ki se bo nahajala v mapi `report`.