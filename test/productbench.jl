using EigenCpp
using Base.Test

const rows = 4
const nb_elems = 1000000

julia_matrices = Array(Matrix{Float64}, (nb_elems,));
julia_vectors = Array(Vector{Float64}, (nb_elems,));
julia_results = Array(Vector{Float64}, (nb_elems,));

function init_julia!(mats::Vector{Matrix{Float64}}, vecs::Vector{Vector{Float64}}, result::Vector{Vector{Float64}})
  for i in 1:nb_elems
    mats[i] = ones(rows,rows)
    vecs[i] = ones(rows)*2.
    result[i] = zeros(rows)
  end
end

function matvec_julia!(mats::Vector{Matrix{Float64}}, vecs::Vector{Vector{Float64}}, result::Vector{Vector{Float64}})
    for i in 1:length(mats)
        #result[i] += mats[i]*vecs[i]
        @inbounds LinAlg.BLAS.gemv!('N', 1., mats[i], vecs[i], 1., result[i])
    end
end

function check_result{T}(result::Vector{T})
  const ref = ones(rows)*24
  all(result) do vec
    vec == ref
  end
end

println("Julia init time:")
@time init_julia!(julia_matrices, julia_vectors, julia_results)

println("Julia matvec timings:")
@time matvec_julia!(julia_matrices, julia_vectors, julia_results)
@time matvec_julia!(julia_matrices, julia_vectors, julia_results)
@time matvec_julia!(julia_matrices, julia_vectors, julia_results)

println("Julia check time:")
@time @test check_result(julia_results)

typealias EigenMat EigenCpp.Matrix{Float64,rows,rows}
typealias EigenVec EigenCpp.Matrix{Float64,rows,1}

eigen_matrices = Array(EigenMat, (nb_elems,));
eigen_vectors = Array(EigenVec, (nb_elems,));
eigen_results = Array(EigenVec, (nb_elems,));

function init_eigen!(mats::Vector{EigenMat}, vecs::Vector{EigenVec}, result::Vector{EigenVec})
  for i in 1:nb_elems
    mats[i] = EigenMat()
    vecs[i] = EigenVec()
    result[i] = EigenVec()
    EigenCpp.setConstant(mats[i], 1)
    EigenCpp.setConstant(vecs[i], 2)
    EigenCpp.setConstant(result[i], 0)
  end
end

function matvec_eigen!(mats::Vector{EigenMat}, vecs::Vector{EigenVec}, result::Vector{EigenVec})
    for i in 1:length(mats)
        #result[i] += mats[i]*vecs[i]
        EigenCpp.plus_assign_product!(mats[i], vecs[i], result[i])
    end
end

println("Eigen init time:")
@time init_eigen!(eigen_matrices, eigen_vectors, eigen_results)

println("Eigen matvec timings:")
@time matvec_eigen!(eigen_matrices, eigen_vectors, eigen_results)
@time matvec_eigen!(eigen_matrices, eigen_vectors, eigen_results)
@time matvec_eigen!(eigen_matrices, eigen_vectors, eigen_results)

println("Eigen check time:")
@time @test check_result(eigen_results)
