import math

def f():
    sum = 1.0
    eps = 1.e-12
    s = -1.0
    for i in range(2,1000000):
        term = 1 / pow(i,i)
        sum = sum + s * term
        s = -s
        if ( term < eps):
            print("converged")
            break
    return sum
    
sum = f()    
print("integral = ",sum)
