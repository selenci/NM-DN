using Naloga11
using Plots

A = [1 0 1 0 0; -1 2 0 0 0; 0 -1 5 0 -1; 0 0 0 1 0; 1 0 0 0 2]
V = [1 1 0; -1 2 0; -1 5 -1; 1 0 0; 1 2 0]
I = [1 3 0; 1 2 0; 2 3 5; 4 0 0; 1 5 0]
A_r = RedkaMatrika(V, I)
b = [4.0; 3.0; 8.0; 4.0; 11.0]
x0 = [1.0; 1; 1; 1; 1]

# Za konvergenco mora biti 0 < omega < 2.
omega_range = 0.02:0.02:1.98

omegas = Float64[]
iterations = Int[]

# Zanka čez vse testne vrednosti omega
for omega_val in omega_range
    try
        # Poženemo SOR in shranimo število iteracij
        x, it = sor(A_r, b, copy(x0), omega_val)
        
        # Shranimo uspešen rezultat
        push!(omegas, omega_val)
        push!(iterations, it)
    catch e
        # Če metoda za določen omega ne konvergira, izpišemo opozorilo.
        @warn "Pri omega = $omega_val metoda ni konvergirala."
    end
end

min_iterations, index_of_min = findmin(iterations)
optimal_omega = omegas[index_of_min]
println("Optimalna vrednost omega: $optimal_omega, Število iteracij: $min_iterations")

# Ustvarimo graf
plot(omegas, iterations, 
    label="Število iteracij",
    xlabel="Parameter ω",
    ylabel="Število iteracij za konvergenco",
    title="Odvisnost hitrosti konvergence od parametra ω",
    legend=:topright,
    linewidth=2
)

# Shranimo graf
savefig("sor_omega_konvergenca.png")