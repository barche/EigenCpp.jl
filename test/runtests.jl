using EigenCpp

xdump(EigenCpp.Matrix)

m1 = EigenCpp.Matrix{Float64,Int32(2),Int32(2),Int32(0),Int32(2),Int32(2)}()
EigenCpp.setConstant(m1, 10)
EigenCpp.print(m1)
