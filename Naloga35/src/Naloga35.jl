"""
Modul Naloga35 rešuje diferencialno enačbo za matematično nihalo in primerja
njegovo obnašanje z obnašanjem harmoničnega nihala. Vključuje funkcije za:
- Definiranje sistema diferencialnih enačb za nihalo.
- Reševanje sistema z uporabo metode DOPRI5.
- Ocenjevanje periode nihanja.
- Risanje odvisnosti periode od začetnega kota (energije).
- Primerjavo rešitve matematičnega nihala z rešitvijo harmoničnega nihala.
"""
module Naloga35

# Uporaba paketov za reševanje diferencialnih enačb in risanje grafov.
using DifferentialEquations
using Plots

"""
    nihalo!(sprememba, stanje, parametri, t)

Funkcija, ki izračuna spremembo stanja nihala. Uporablja se v reševalniku
diferencialnih enačb. Enačbo drugega reda d²θ/dt² + (g/l)sin(θ) = 0 prevede na
sistem dveh enačb prvega reda.

# Argumenti
- `sprememba`: Vektor, v katerega se shrani izračunana sprememba stanja (odvod stanja).
- `stanje`: Vektor trenutnega stanja nihala `[kot, hitrost]`.
- `parametri`: Vektor s parametri `(gravitacija, dolzina)`.
- `t`: Trenutni čas (v tej enačbi ni eksplicitno uporabljen).
"""
function nihalo!(sprememba, stanje, parametri, t)
    kot = stanje[1]
    hitrost = stanje[2]
    gravitacija, dolzina = parametri

    # d(kot)/dt = kotna hitrost
    sprememba[1] = hitrost
    # d(hitrost)/dt = -(g/l) * sin(kot)
    sprememba[2] = -(gravitacija/dolzina) * sin(kot)
end

"""
    resi_nihalo(zacetni_kot; ...)

Reši diferencialno enačbo za matematično nihalo za dani začetni kot.

# Argumenti
- `zacetni_kot::Float64`: Začetni odmik nihala v radianih.

# Neobvezni argumenti
- `koncni_cas::Float64 = 3.0`: Končni čas simulacije v sekundah.
- `gravitacija::Float64 = 9.81`: Težni pospešek v m/s².
- `dolzina::Float64 = 1.0`: Dolžina vrvice nihala v metrih.
- `zacetna_hitrost::Float64 = 0.0`: Začetna kotna hitrost v rad/s.
- `korak_shranjevanja::Float64 = 0.001`: Časovni korak za shranjevanje rezultatov.

# Vrne
- `casi`: Vektor časovnih točk.
- `koti`: Vektor kotnih odmikov v ustreznih časovnih točkah.
"""
function resi_nihalo(zacetni_kot::Float64;
                     koncni_cas::Float64 = 3.0,
                     gravitacija::Float64 = 9.81,
                     dolzina::Float64 = 1.0,
                     zacetna_hitrost::Float64 = 0.0,
                     korak_shranjevanja::Float64 = 0.001)

    # Združevanje parametrov in začetnih pogojev.
    parametri = (gravitacija, dolzina)
    zacetno_stanje = [zacetni_kot, zacetna_hitrost]
    casovno_obmocje = (0.0, koncni_cas)

    # Definiranje problema diferencialne enačbe.
    problem = ODEProblem(nihalo!, zacetno_stanje, casovno_obmocje, parametri)
    
    # Reševanje problema z uporabo numerične metode DP5 (Dormand-Prince 5).
    # `saveat` določa, v katerih časovnih točkah naj se shrani rešitev.
    resitev = solve(problem, DP5(), saveat=korak_shranjevanja)

    # Ekstrakcija časov in kotov iz rešitve.
    casi = resitev.t
    koti = resitev[1,:] # Prva komponenta rešitve so koti.

    return casi, koti
end

"""
    oceni_periodo(casi, koti)

Oceni periodo nihanja na podlagi časov in kotov. Perioda je ocenjena kot
štirikratnik časa, ki ga nihalo potrebuje, da prvič doseže ravnovesno lego
(kot = 0).

# Argumenti
- `casi`: Vektor časovnih točk.
- `koti`: Vektor kotnih odmikov.

# Vrne
- Ocenjeno periodo v sekundah. Če nihalo ne doseže ravnovesne lege, vrne -1.
"""
function oceni_periodo(casi, koti)
    indeks = 1
    # Iščemo prvi indeks, kjer kot postane nepozitiven.
    # To ustreza prvi četrtini nihaja.
    while indeks <= length(koti) && koti[indeks] > 0
        indeks += 1
    end

    # Če je bil najden ustrezen indeks, je čas T/4. Vrnemo 4 * čas.
    # Sicer vrnemo -1, kar pomeni, da perioda ni bila najdena.
    indeks > length(koti) ? -1 : 4 * casi[indeks]
end

"""
    narisi_odvisnost_periode(points=30)

Izračuna in nariše graf odvisnosti periode nihanja od začetnega kota.
Večji začetni kot pomeni večjo začetno energijo.

# Neobvezni argumenti
- `points=30`: Število točk (različnih začetnih kotov) za izris grafa.
"""
function narisi_odvisnost_periode(points=30)
    # Določimo območje začetnih kotov od majhnega (skoraj 0) do π/2.
    zacetni_koti = range(0.05, π/2, length=points)
    koti = Float64[]
    periode = Float64[]

    # Zanka čez vse začetne kote.
    for kot in zacetni_koti
        # Rešimo nihalo in ocenimo periodo.
        casi, koti_resitev = resi_nihalo(kot)
        perioda = oceni_periodo(casi, koti_resitev)

        # Če je bila perioda uspešno ocenjena, jo dodamo na seznam.
        perioda < 0 || (push!(koti, kot); push!(periode, perioda))
    end

    # Izris grafa periode v odvisnosti od začetnega kota.
    graf = plot(koti, periode,
        xlabel = "Začetni kot [rad]",
        ylabel = "Perioda nihanja [s]",
        title = "Perioda v odvisnosti od začetnega kota",
        lw = 2,
        legend = false)

    # Shranjevanje grafa v datoteko.
    ime_datoteke = "slike/perioda_vs_kot.png"
    savefig(graf, ime_datoteke)
    println("Graf shranjen v $ime_datoteke")
end

"""
    harmonski_kot(casi, zacetni_kot, gravitacija=9.81, dolzina=1.0)

Izračuna odmik harmoničnega nihala (aproksimacija za majhne kote).
Rešitev enačbe d²θ/dt² + (g/l)θ = 0 je θ(t) = θ₀ * cos(ωt), kjer je ω = sqrt(g/l).

# Argumenti
- `casi`: Vektor časovnih točk.
- `zacetni_kot`: Začetni odmik.
- `gravitacija`: Težni pospešek.
- `dolzina`: Dolžina nihala.

# Vrne
- Vektor kotnih odmikov za harmonično nihalo.
"""
function harmonski_kot(casi, zacetni_kot, gravitacija=9.81, dolzina=1.0)
    omega = sqrt(gravitacija / dolzina)
    return zacetni_kot .* cos.(omega .* casi)
end

"""
    primerjaj(zacetni_kot)

Primerja nihanje matematičnega (nelinearnega) nihala s harmonično aproksimacijo
za dani začetni kot in nariše graf.

# Argumenti
- `zacetni_kot`: Začetni kot v radianih, za katerega se izvede primerjava.
"""
function primerjaj(zacetni_kot)
    # Rešimo nelinearno enačbo.
    casi, nelinearni_koti = resi_nihalo(zacetni_kot)
    # Izračunamo rešitev za harmonično aproksimacijo.
    harmonski_koti = harmonski_kot(casi, zacetni_kot)

    # Izrišemo obe rešitvi na isti graf za primerjavo.
    graf = plot(casi, nelinearni_koti, label="Nelinearen model",
        xlabel="Čas [s]", ylabel="Kot [rad]", lw=2)

    plot!(graf, casi, harmonski_koti, label="Harmonska aproksimacija", lw=2, ls=:dash)

    # Dodamo informativen naslov z začetnim kotom v stopinjah.
    stopinje = round(rad2deg(zacetni_kot); digits=1)
    naslov = "Primerjava nihanja (θ₀ = $(stopinje)°)"
    title!(graf, naslov)
    
    # Shranimo graf v datoteko z imenom, določenim glede na začetni kot.
    ime_datoteke = "slike/primerjava_$(round(zacetni_kot, digits=2)).png"
    savefig(graf, ime_datoteke)
    println("Graf shranjen v $ime_datoteke")
end

# Izvozimo funkcije, ki so namenjene uporabi izven modula.
export primerjaj, narisi_odvisnost_periode

end