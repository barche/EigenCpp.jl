using CxxWrap

const depsfile = joinpath(dirname(dirname(@__FILE__)), "deps", "deps.jl")
if !isfile(depsfile)
  error("$depsfile not found, package EigenCpp did not build properly")
end
include(depsfile)

wrap_modules(_l_eigen_wrap)
