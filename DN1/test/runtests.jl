using Test
using DN1

#A = [1 0 1 0 0; -1 2 0 0 0; 0 -1 ]

A = [1 0 1 0 0; -1 2 0 0 0; 0 -1 5 0 -1; 0 0 0 1 0; 1 0 0 0 2]

V = [1 1 0; -1 2 0; -1 5 -1; 1 0 0; 1 2 0]
I = [1 3 0; 1 2 0; 2 3 5; 4 0 0; 1 5 0]

A_r = RedkaMatrika(V, I)

@testset "Matriki sta enaki" begin
    for i = 1:5 
        for j = 1:5
            @test A[i, j] == A_r[i, j]
        end
    end
end


@testset "Matriki lahko nastavimo vrednosti" begin
    test_matrix = RedkaMatrika(copy(V), copy(I))
    test_matrix[1, 1] = 34.0
    test_matrix[3, 1] = 21.0
    test_matrix[5, 4] = 12.0

   @test test_matrix[1, 1] == 34.0
   @test test_matrix[3, 1] == 21.0
   @test test_matrix[5, 4] == 12.0

end

@testset "Prvi index" begin
    @test firstindex(A_r) == 1
    @test firstindex(A_r, 1) == 1
end

@testset "Zadnji index" begin
    @test lastindex(A_r) == 25
    @test lastindex(A_r, 1) == 5
    @test lastindex(A_r, 2) == 5
    @test lastindex(A_r, 3) == 1
end

@testset "Množenje z vektorjem" begin
    v = [1; 2; 3; 4; 5]
    @test A_r * v == [4; 3; 8; 4; 11]
end

@testset "Reševanje s sor" begin
    b = [4.0; 3.0; 8.0; 4.0; 11.0]
    x0 = [1.0; 1; 1; 1; 1]
    x = sor(A_r, b, x0, 1.0)

    @test isapprox(x, [1.0, 2, 3, 4, 5])
end


using Graphs
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

@testset "Reševanje problema vložitve matrik" begin
    G = krožna_lestev(20)
    sprem = setdiff(vertices(G), 1:18)
    A = matrika(G, sprem)
    b = desne_strani(G, sprem, rand(18))
    x = sor(A, b, rand(length(b)), 1.2)
end