# Uvozimo potrebni knjižnici: Test za izvajanje testov in Naloga11 za definicije, ki jih testiramo.
using Test
using Naloga11

# Definiramo polno (gosto) matriko A, ki jo bomo uporabili za primerjavo z našo redko matriko.
A = [1 0 1 0 0; -1 2 0 0 0; 0 -1 5 0 -1; 0 0 0 1 0; 1 0 0 0 2]

# Definiramo matriki, ki predstavljata našo redko matriko.
# V vsebuje vrednosti neničelnih elementov.
V = [1 1 0; -1 2 0; -1 5 -1; 1 0 0; 1 2 0]
# I vsebuje stolpčne indekse neničelnih elementov.
I = [1 3 0; 1 2 0; 2 3 5; 4 0 0; 1 5 0]

# S pomočjo matrik V in I ustvarimo objekt RedkaMatrika.
A_r = RedkaMatrika(V, I)

# Testni sklop, ki preverja, ali je dostop do elementov redke matrike enak kot pri polni.
@testset "Matriki sta enaki" begin
    # Iteriramo čez vse elemente in preverimo enakost.
    for i = 1:5 
        for j = 1:5
            @test A[i, j] == A_r[i, j]
        end
    end
end


# Testni sklop, ki preverja, ali lahko pravilno nastavljamo vrednosti v redki matriki (funkcionalnost setindex!).
@testset "Matriki lahko nastavimo vrednosti" begin
    # Ustvarimo kopijo matrike, da ne spremenimo originalne A_r med testiranjem.
    test_matrix = RedkaMatrika(copy(V), copy(I))
    # Nastavimo nekaj novih vrednosti na različnih pozicijah.
    test_matrix[1, 1] = 34.0
    test_matrix[3, 1] = 21.0
    test_matrix[5, 4] = 12.0

   # Preverimo, ali so bile vrednosti pravilno nastavljene.
   @test test_matrix[1, 1] == 34.0
   @test test_matrix[3, 1] == 21.0
   @test test_matrix[5, 4] == 12.0

end

# Testni sklop za firstindex, ki preverja pravilno implementacijo vmesnika za polja (arrays).
@testset "Prvi index" begin
    @test firstindex(A_r) == 1
    @test firstindex(A_r, 1) == 1
end

# Testni sklop za lastindex. Preverja meje matrike po posameznih dimenzijah.
@testset "Zadnji index" begin
    @test lastindex(A_r) == 25 # Skupno število elementov (5*5) pri linearnem indeksiranju
    @test lastindex(A_r, 1) == 5 # Zadnji indeks v prvi dimenziji (vrstice)
    @test lastindex(A_r, 2) == 5 # Zadnji indeks v drugi dimenziji (stolpci)
    @test lastindex(A_r, 3) == 1 # Standardno obnašanje v Julii za dimenzije, ki presegajo definirane
end

# Testiramo, ali množenje redke matrike z vektorjem vrne pravilen rezultat.
@testset "Množenje z vektorjem" begin
    v = [1; 2; 3; 4; 5]
    # Preverimo produkt A_r * v.
    @test A_r * v == [4; 3; 8; 4; 11]
end

# Testni sklop za reševanje sistema linearnih enačb A*x = b z metodo SOR (Successive Over-Relaxation).
@testset "Reševanje s sor" begin
    # Definiramo vektor desnih strani b in začetni približek x0.
    b = [4.0; 3.0; 8.0; 4.0; 11.0]
    x0 = [1.0; 1; 1; 1; 1]
    # Poženemo metodo SOR z relaksacijskim parametrom omega = 1.0 (kar ustreza Gauss-Seidlovi metodi).
    x, _ = sor(A_r, b, x0, 1.0)

    # Preverimo, ali je izračunana rešitev x približno enaka pričakovani rešitvi.
    @test isapprox(x, [1.0, 2, 3, 4, 5])
end


using Graphs

# Funkcija, ki zgradi graf tipa 'krožna lestev' z 2n vozlišči.
function krožna_lestev(n)
    G = SimpleGraph(2 * n)
    # prvi cikel
    for i = 1:n-1
        add_edge!(G, i, i + 1)
    end
    add_edge!(G, 1, n)
    # drugi cikel
    for i = n+1:2n-1
        add_edge!(G, i, i + 1)
    end
    add_edge!(G, n + 1, 2n)
    # povezave med obema cikloma
    for i = 1:n
        add_edge!(G, i, i + n)
    end
    return G
end


function matrika(G::AbstractGraph, sprem)
# preslikava med vozlišči in indeksi v matriki
    v_to_i = Dict([sprem[i] => i for i in eachindex(sprem)])
    m = length(sprem)
    A = RedkaMatrika(zeros(m, 1), zeros(m, 1))

    for i = 1:m
        vertex = sprem[i]
        sosedi = neighbors(G, vertex)
        for vertex2 in sosedi
            if haskey(v_to_i, vertex2)
                j = v_to_i[vertex2]
                A[i, j] = 1.0
            end
        end

        A[i, i] = -(length(sosedi) + 0.0)
    end

    return A
end

function desne_strani(G::AbstractGraph, sprem, koordinate)
    set = Set(sprem)
    m = length(sprem)
    b = zeros(m)
    for i = 1:m
        v = sprem[i]
        for v2 in neighbors(G, v)
            if !(v2 in set) # dodamo le točke, ki so fiksirane
                b[i] -= koordinate[v2]
            end
        end
    end
    return b
end

# Preverimo, da ne pride do napake.
@testset "Reševanje problema vložitve matrik" begin
    G = krožna_lestev(20)
    sprem = setdiff(vertices(G), 1:18)
    A = matrika(G, sprem)
    b = desne_strani(G, sprem, rand(18))
    x, _ = sor(A, b, rand(length(b)), 1.2)
end