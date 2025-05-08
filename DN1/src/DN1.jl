module DN1
export RedkaMatrika, sor
import Base: getindex, setindex!, firstindex, lastindex, *

mutable struct RedkaMatrika
    V
    I
end

function getindex(T::RedkaMatrika, i::Int64, j::Int64)
    vrstica = T.I[i, :]
    index = findfirst(==(j), vrstica)  

    if isnothing(index)
        return 0
    end

    return T.V[i, index]
end

function setindex!(T::RedkaMatrika, v::Float64, i::Int64, j::Int64)
    vrstica = T.I[i, :]
    if T[i, j] != 0 # Vrednost v matrikah i in j obstaja, potrebno jo je prepisati
        index = findfirst(==(j), vrstica)
        T.V[i, index] = v
        return
    end

    index = findfirst(==(0), vrstica) # Poiščemo prvo prosto mesto

    if isnothing(index)
        T.V = hcat(T.V, zeros(size(T.V, 1)))
        T.I = hcat(T.I, zeros(size(T.I, 1)))
        index = size(T.V, 2)
    end

    T.V[i, index] = v
    T.I[i, index] = j

end

function firstindex(T::RedkaMatrika)
    return 1
end

function firstindex(T::RedkaMatrika, i::Int64)
    return 1
end

function lastindex(T::RedkaMatrika)
    return size(T.V, 1) * size(T.V, 1)
end

function lastindex(T::RedkaMatrika, i::Int64)
    if i == 1 || i == 2
        return size(T.V, 1)
    end
    return 1
end

function *(T::RedkaMatrika, v::Vector)
    b = zero(v)
    for i=firstindex(T, 1):lastindex(T, 1)
        for j=firstindex(T, 2):lastindex(T, 2)
            b[i] += T[i,j] * v[j]
        end
    end
    return b
end

function sor_korak(T::RedkaMatrika, x0::Vector, b::Vector, w::Float64)
    x = copy(x0)
    for i = 1:length(b)

        suma = 0
        for j = 1:length(b)
            if i != j 
                suma += x[j] * T[i, j]
            end
        end

        x[i] = (1 - w) * x[i] + (w/T[i,i]) * (b[i] - suma)
    end
    return x
end

function sor(T::RedkaMatrika, b::Vector, x0::Vector, omega::Float64; tol::Float64=1e-10)
    for i = 1:10_000_000
        x0 = sor_korak(T, x0, b, omega)

        diff = (T*x0 - b)
        if maximum(abs, diff) < tol
            print(x0, i)
            return x0
        end
    end

    throw("Sistem ne konvergira!")
end




end