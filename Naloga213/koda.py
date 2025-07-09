import numpy as np
import math

def f(x):
    return math.sin(x)/x

r = (5/2)*(f(5/2 - 5*math.sqrt(3)/6) + f(5/2 + 5*math.sqrt(3)/6))
print(r)


points = 2
err = 1
corr = 1.54993124494467413727440840073063901218318489396637221047796971068148720895

while abs(err) >= 1e-10:
    sp = np.linspace(0, 5, points)

    integ = 0
    for i in range(points - 1):
        a = sp[i]
        b = sp[i + 1]

        u = (a+b)/2

        integ += ((b-a)/2) * (f(u - (b-a)*math.sqrt(3)/6) +  f(u + (b-a)*math.sqrt(3)/6))
        
    print(integ)
    points += 1

    err = integ - corr


print(points)

# while abs(err) >= 1e-10:
#     h = 5 / points
#     err = 5*h*(h**2 - 25) / (24 * math.sqrt(3))
#     print(points, h, err)

#     points += 1

# print(points)