using BinDeps
@BinDeps.load_dependencies

using CppWrapper
wrap_modules(joinpath(Pkg.dir("EigenCpp"),"deps","usr","lib","libeigen_wrapper"))
