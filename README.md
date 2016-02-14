# EigenCpp.jl
This is a package wrapping a small part of the development version of the [`Eigen`](http://eigen.tuxfamily.org/index.php?title=Main_Page) library. It is mainly intended as a more elaborate test of the [`CppWrapper`](https://github.com/barche/CppWrapper) package, and for now mostly does a `gemv` comparison with Julia. To run this, do:

```julia
Pkg.clone("https://github.com/barche/EigenCpp.jl.git")
Pkg.build("EigenCpp")
Pkg.test("EigenCpp")
```
