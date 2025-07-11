module Naloga35

using DifferentialEquations
using Plots

function nihalo!(sprememba, stanje, parametri, t)
    kot = stanje[1]
    hitrost = stanje[2]
    gravitacija, dolzina = parametri

    sprememba[1] = hitrost
    sprememba[2] = -(gravitacija/dolzina) * sin(kot)
end

function resi_nihalo(zacetni_kot::Float64;
                     koncni_cas::Float64 = 3.0,
                     gravitacija::Float64 = 9.81,
                     dolzina::Float64 = 1.0,
                     zacetna_hitrost::Float64 = 0.0,
                     korak_shranjevanja::Float64 = 0.001)

    parametri = (gravitacija, dolzina)
    zacetno_stanje = [zacetni_kot, zacetna_hitrost]
    casovno_obmocje = (0.0, koncni_cas)

    problem = ODEProblem(nihalo!, zacetno_stanje, casovno_obmocje, parametri)
    resitev = solve(problem, DP5(), saveat=korak_shranjevanja)

    casi = resitev.t
    koti = resitev[1,:]

    return casi, koti
end

function oceni_periodo(casi, koti)
    indeks = 1
    while indeks <= length(koti) && koti[indeks] > 0
        indeks += 1
    end

    indeks > length(koti) ? -1 : 4 * casi[indeks]
end

function narisi_odvisnost_periode(points=30)
    zacetni_koti = range(0.05, π/2, length=points)
    koti = Float64[]
    periode = Float64[]

    for kot in zacetni_koti
        casi, koti_resitev = resi_nihalo(kot)
        perioda = oceni_periodo(casi, koti_resitev)

        perioda < 0 || (push!(koti, kot); push!(periode, perioda))
    end

    graf = plot(koti, periode,
        xlabel = "Začetni kot [rad]",
        ylabel = "Perioda nihanja [s]",
        title = "Perioda v odvisnosti od začetnega kota",
        lw = 2,
        legend = false)

    ime_datoteke = "slike/perioda_vs_kot.png"
    savefig(graf, ime_datoteke)
    println("Graf shranjen v $ime_datoteke")
end

function harmonski_kot(casi, zacetni_kot, gravitacija=9.81, dolzina=1.0)
    omega = sqrt(gravitacija / dolzina)
    return zacetni_kot .* cos.(omega .* casi)
end

function primerjaj(zacetni_kot)
    casi, nelinearni_koti = resi_nihalo(zacetni_kot)
    harmonski_koti = harmonski_kot(casi, zacetni_kot)

    graf = plot(casi, nelinearni_koti, label="Nelinearen model",
        xlabel="Čas [s]", ylabel="Kot [rad]", lw=2)

    plot!(graf, casi, harmonski_koti, label="Harmonska aproksimacija", lw=2, ls=:dash)

    stopinje = round(rad2deg(zacetni_kot); digits=1)
    naslov = "Primerjava nihanja (θ₀ = $(stopinje)°)"
    title!(graf, naslov)
    
    ime_datoteke = "slike/primerjava_$(round(zacetni_kot, digits=2)).png"
    savefig(graf, ime_datoteke)
    println("Graf shranjen v $ime_datoteke")
end

export primerjaj, narisi_odvisnost_periode

end