using EigenCpp
using Base.Test


m1 = EigenCpp.Matrix{Float64,4,2}()
jm1 = Matrix{Float64}(m1) # converted to Julia
EigenCpp.setConstant(m1, 10)
m1[1,2] = 5.
@test m1 == [10. 5.; 10. 10.; 10. 10.; 10. 10]

println("Printing 4x2 matrix:")
EigenCpp.print(m1)

@test jm1[1,2] == 5.
@test m1[1,2] == 5.

sumexpr = m1 + m1
@test startswith(string(typeof(sumexpr)), "Sum")
msum = EigenCpp.Matrix{Float64,4,2}(sumexpr)
@test Matrix{Float64}(msum) == [20. 10.; 20. 20.; 20. 20.; 20. 20]
