"""
Modul Naloga11 definira strukturo za redke matrike in implementira
metodo SOR (Successive Over-Relaxation) za reševanje linearnih sistemov.
"""
module Naloga11
# Izvozimo strukturo RedkaMatrika in funkcijo sor, da sta vidni izven modula.
export RedkaMatrika, sor
# Uvozimo in razširimo osnovne funkcije iz modula Base za našo strukturo.
import Base: getindex, setindex!, firstindex, lastindex, *

"""
    RedkaMatrika

Struktura za predstavitev redke matrike.

# Polja
- V: Matrika, ki hrani vrednosti neničelnih elementov. Vsaka vrstica ustreza vrstici v redki matriki.
- I: Matrika, ki hrani stolpčne indekse neničelnih elementov. Urejena je enako kot V.
"""
mutable struct RedkaMatrika
    V
    I
end

"""
    getindex(T::RedkaMatrika, i::Int64, j::Int64)

Pridobi vrednost elementa na poziciji (i, j) v redki matriki T.
To omogoča uporabo standardne sintakse T[i, j].
"""
function getindex(T::RedkaMatrika, i::Int64, j::Int64)
    # Vzamemo vrstico stolpčnih indeksov, ki pripada i-ti vrstici matrike.
    vrstica = T.I[i, :]
    # Poiščemo, na katerem mestu v tej vrstici se nahaja iskani stolpčni indeks j.
    index = findfirst(==(j), vrstica)  

    # Če indeksa j nismo našli, pomeni, da je element na (i,j) enak 0.
    if isnothing(index)
        return 0
    end

    # Če smo indeks našli, vrnemo ustrezno vrednost iz matrike vrednosti V.
    return T.V[i, index]
end

"""
    setindex!(T::RedkaMatrika, v::Float64, i::Int64, j::Int64)

Nastavi vrednost v elementu na poziciji (i, j) v redki matriki T.
To omogoča uporabo standardne sintakse T[i, j] = v.
"""
function setindex!(T::RedkaMatrika, v::Float64, i::Int64, j::Int64)
    vrstica = T.I[i, :]
    # Preverimo, ali element na (i, j) že obstaja (ima neničelno vrednost).
    if T[i, j] != 0 
        # Element že obstaja, zato ga samo posodobimo.
        index = findfirst(==(j), vrstica)
        T.V[i, index] = v
        return
    end

    # Če element ne obstaja, poiščemo prvo prosto mesto v vrstici i.
    # Prosto mesto je označeno z indeksom 0.
    index = findfirst(==(0), vrstica) 

    # Če prostega mesta ni, moramo razširiti matriki V in I.
    if isnothing(index)
        T.V = hcat(T.V, zeros(size(T.V, 1)))
        T.I = hcat(T.I, zeros(size(T.I, 1)))
        # Novi indeks je na koncu razširjene matrike.
        index = size(T.V, 2)
    end

    # Na prosto mesto vstavimo novo vrednost v in njen stolpčni indeks j.
    T.V[i, index] = v
    T.I[i, index] = j

end

function firstindex(T::RedkaMatrika)
    return 1
end

function firstindex(T::RedkaMatrika, i::Int64)
    return 1
end

# Vrne zadnji linearni indeks, kot da bi bila matrika polna (n x n).
function lastindex(T::RedkaMatrika)
    return size(T.V, 1) * size(T.V, 1)
end

"""
Vrne zadnji indeks za dano dimenzijo. Predpostavlja, da je matrika kvadratna
z dimenzijo, enako številu vrstic v T.V.
"""
function lastindex(T::RedkaMatrika, i::Int64)
    # Ta funkcija predpostavlja, da gre za 2D matriko (dimenziji 1 in 2).
    if i == 1 || i == 2
        return size(T.V, 1) # Vrne število vrstic kot velikost za obe dimenziji.
    end
    return 1
end

"""
    *(T::RedkaMatrika, v::Vector)

Definira operacijo množenja med redko matriko T in vektorjem v.
To omogoča uporabo standardnega operatorja * za to operacijo (npr. T * v).
"""
function *(T::RedkaMatrika, v::Vector)
    # Inicializira rezultatski vektor b z enako velikostjo kot v in ga napolni z ničlami.
    b = zero(v)
    
    # Zunanja zanka iterira čez vrstice matrike T.
    # Meje iteracije določata funkciji firstindex(T, 1) in lastindex(T, 1).
    for i=firstindex(T, 1):lastindex(T, 1)
        # Notranja zanka iterira čez stolpce matrike T.
        # Meje iteracije določata firstindex(T, 2) in lastindex(T, 2).
        for j=firstindex(T, 2):lastindex(T, 2)
            # Za vsak element (i, j) matrike T izračuna produkt T[i,j] * v[j].
            # Klic T[i,j] uporabi zgoraj definirano funkcijo getindex, ki vrne 0,
            # če element ni eksplicitno shranjen.
            # Rezultat prišteje k i-ti komponenti vektorja b, s čimer se tvori skalarni produkt
            # i-te vrstice matrike T z vektorjem v.
            b[i] += T[i,j] * v[j]
        end
    end
    # Vrne izračunan vektor b, ki je rezultat množenja T * v.
    return b
end

"""
    sor_korak(T::RedkaMatrika, x0::Vector, b::Vector, w::Float64)

Izvede en korak (iteracijo) metode SOR za reševanje sistema T*x = b.
"""
function sor_korak(T::RedkaMatrika, x0::Vector, b::Vector, w::Float64)
    x = copy(x0) # Naredimo kopijo vektorja, da ne spreminjamo originala.
    # Iteriramo čez vse vrstice sistema.
    for i = 1:length(b)

        suma = 0
        # Izračunamo vsoto Σ(T_ij * x_j) za j ≠ i.
        for j = 1:length(b)
            if i != j 
                suma += x[j] * T[i, j]
            end
        end

        # Uporabimo formulo za posodobitev i-te komponente vektorja x.
        # x_i^(k+1) = (1-w)*x_i^(k) + (w/T_ii) * (b_i - Σ(T_ij * x_j))
        # Pri tem se za x_j uporabljajo že izračunane vrednosti iz trenutne iteracije (za j < i)
        # in vrednosti iz prejšnje iteracije (za j > i), ker posodabljamo x sproti.
        x[i] = (1 - w) * x[i] + (w/T[i,i]) * (b[i] - suma)
    end
    return x
end

"""
    sor(T::RedkaMatrika, b::Vector, x0::Vector, omega::Float64; tol::Float64=1e-10)

Reši linearni sistem T*x = b z metodo SOR.

# Argumenti
- T: Sistemska matrika (tipa RedkaMatrika).
- b: Vektor desnih strani.
- x0: Začetni približek za rešitev x.
- omega: Relaksacijski parameter (omega).
- tol: Toleranca za konvergenco. Iteracije se ustavijo, ko je norma ostanka manjša od tol.

# Vrne
- Vektor x, ki je rešitev sistema.

# Napake
- Vrne napako, če metoda ne konvergira v določenem številu iteracij.
"""
function sor(T::RedkaMatrika, b::Vector, x0::Vector, omega::Float64; tol::Float64=1e-10)
    # Zanka z maksimalnim številom iteracij (varnostni mehanizem proti neskončni zanki).
    for i = 1:100_000
        # Izvedemo en korak SOR metode.
        x0 = sor_korak(T, x0, b, omega)

        # Preverimo pogoj za ustavitev.
        # Izračunamo ostanek (residual): r = b - T*x.
        # Tukaj je ostanek izračunan kot T*x - b, kar je za normo nepomembno.
        diff = (T*x0 - b)
        # Če je največja absolutna vrednost komponente ostanka pod toleranco, smo končali.
        if maximum(abs, diff) < tol
            println("Konvergenca dosežena po $i iteracijah.")
            return x0, i
        end
        # Pripravimo se na naslednjo iteracijo.
    end

    # Če zanka pride do konca, metoda ni konvergirala.
    throw("Sistem ne konvergira!")
end




end