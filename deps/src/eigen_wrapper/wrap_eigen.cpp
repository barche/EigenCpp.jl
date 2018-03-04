#include <jlcxx/jlcxx.hpp>
#include <Eigen/Dense>

namespace jlcxx
{
  // Match the Eigen Matrix type, skipping the default parameters
  template<typename ScalarT, int Rows, int Cols>
  struct BuildParameterList<Eigen::Matrix<ScalarT, Rows, Cols>>
  {
    // We set the parameterlist to int64_t, to avoid having to wrap all parameters in Int32() in Julia
    typedef ParameterList<ScalarT, std::integral_constant<int64_t, Rows>, std::integral_constant<int64_t, Cols>> type;
  };
}

JULIA_CPP_MODULE_BEGIN(registry)
  using namespace jlcxx;

  Module& types = registry.create_module("EigenCpp");

  // Add some fixed-size matrices
  types.add_type<Parametric<TypeVar<1>, TypeVar<2>, TypeVar<3>>>("Matrix")
    .apply<Eigen::Matrix<double, 4, 4>, Eigen::Matrix<double, 4, 2>, Eigen::Matrix<double, 4, 1>>([&types](auto wrapped)
  {
    typedef typename decltype(wrapped)::type WrappedT;
    typedef typename WrappedT::Scalar ScalarT;
    typedef remove_const_ref<decltype(std::declval<WrappedT>()+std::declval<WrappedT>())> SumT;

    types.add_type<SumT>("Sum_" + std::string(typeid(SumT).name()));

    types.method("setConstant", [](WrappedT& eigen_mat, const ScalarT val)
    {
      eigen_mat.setConstant(val);
    });

    types.method("print", [](const WrappedT& eigen_mat)
    {
      std::cout << eigen_mat << std::endl;
    });

    types.method("convert", [](SingletonType<ArrayRef<ScalarT, 2>>, WrappedT& eigen_mat)
    {
      return ArrayRef<ScalarT, 2>(eigen_mat.data(), eigen_mat.rows(), eigen_mat.cols());
    });

    types.method("getindex", [](const WrappedT& eigen_mat, const int64_t row, const int64_t col)
    {
      return eigen_mat(row-1,col-1);
    });

    types.method("setindex!", [](WrappedT& eigen_mat, const ScalarT val, const int64_t row, const int64_t col)
    {
      eigen_mat(row-1,col-1) = val;
    });

    types.method("+", [](const WrappedT& mat1, const WrappedT& mat2)
    {
      return create<SumT>(mat1 + mat2);
    });

    types.method("convert", [](SingletonType<WrappedT>, const SumT& sum)
    {
      return create<WrappedT>(sum);
    });

    types.method("==", [](const WrappedT& eigen_mat, const ArrayRef<ScalarT, WrappedT::ColsAtCompileTime==1?1:2>& julia_mat)
    {
      return eigen_mat == Eigen::Map<const WrappedT>(julia_mat.data());
    });
  });

  // Mat-vec product for (4x4)*(4x1)
  typedef remove_const_ref<decltype(std::declval<Eigen::Matrix<double, 4, 4>>()*std::declval<Eigen::Matrix<double, 4, 1>>())> ProductT;
  types.add_type<ProductT>("Product_" + std::string(typeid(ProductT).name()));

  types.method("*", [](const Eigen::Matrix<double, 4, 4>& mat, const Eigen::Matrix<double, 4, 1>& vec)
  {
    return create<ProductT>(mat * vec);
  });

  types.method("+", [](const Eigen::Matrix<double, 4, 1>& mat, const ProductT& prod)
  {
    return create<Eigen::Matrix<double, 4, 1>>(mat+prod);
  });

  // in-place y += A*x
  types.method("plus_assign_product!", [](const Eigen::Matrix<double, 4, 4>& mat, const Eigen::Matrix<double, 4, 1>& vec, Eigen::Matrix<double, 4, 1>& result)
  {
    result += mat*vec;
  });
JULIA_CPP_MODULE_END
