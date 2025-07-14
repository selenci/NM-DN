module Naloga213
function main()
    # Definiramo funkcijo f(x), ki je enaka sin(x)/x.
    # Ker deljenje z ničlo ni definirano (pri x=0), za x=0 vrnemo 
    # vrednost 1.0, kar je limita funkcije, ko se x približuje 0.
    f(x) = iszero(x) ? 1.0 : sin(x)/x

    # Izračunamo integral funkcije f(x) na celotnem intervalu [0, 5]
    # z uporabo Gauss-Legendrove kvadrature z dvema točkama.
    r = (5/2) * (f(5/2 - 5*sqrt(3)/6) + f(5/2 + 5*sqrt(3)/6))
    println(r)

    # Inicializacija spremenljivk za iterativni postopek.
    # - points: Začetno število točk, ki določajo število podintervalov (points - 1).
    # - err: Začetna vrednost napake, postavljena na 1.0, da se zanka 'while' zagotovo izvede.
    points = 2
    err = 1.0

    # Točna, vnaprej izračunana vrednost integrala, ki jo uporabljamo za primerjavo
    # in izračun napake naše numerične metode.
    corr = 1.54993124494467413727440840073063901218318489396637221047796971068148720895

    # Glavna zanka, ki se izvaja, dokler absolutna napaka naše aproksimacije
    # ne pade pod določen prag (1e-10). Z vsako iteracijo povečamo število
    # podintervalov in tako izboljšamo natančnost.
    while abs(err) >= 1e-10
        # Poiščemo meje intervalov, na katerih bomo izvajali integracijo.
        sp = LinRange(0, 5, points)

        # Ponastavimo vrednost integrala za to iteracijo.
        integ = 0.0

        # Zanka gre čez vse ustvarjene podintervale.
        for i in 1:(points - 1)
            # Določimo meje (a, b) trenutnega podintervala.
            a = sp[i]
            b = sp[i + 1]

            # Izračunamo središče 'u' podintervala.
            u = (a+b)/2

            # Na vsakem podintervalu uporabimo in prištejemo Gauss-Legendrovo kvadraturo
            integ += ((b-a)/2) * (f(u - (b-a)*sqrt(3)/6) + f(u + (b-a)*sqrt(3)/6))
        end

        println(integ)

        # Povečamo število točk za naslednjo iteracijo.
        points += 1

        # Izračunamo napako kot razliko med našo aproksimacijo in točno vrednostjo.
        err = integ - corr
    end

    # Ko je dosežena želena natančnost, izpišemo končno število točk.
    println("Final number of points: ", points)
end

main()

end