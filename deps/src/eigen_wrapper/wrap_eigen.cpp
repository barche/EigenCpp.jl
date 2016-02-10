#include <cpp_wrapper.hpp>
#include <Eigen/Dense>

namespace cpp_wrapper
{
  /// Match Eigen template types
  template<typename ScalarT, template<typename, int...> class T, int... Parameters>
  struct BuildParameterList<T<ScalarT, Parameters...>>
  {
    typedef ParameterList<ScalarT, std::integral_constant<int, Parameters>...> type;
  };
}

JULIA_CPP_MODULE_BEGIN(registry)
  using namespace cpp_wrapper;

  Module& types = registry.create_module("EigenCpp");

  types.add_type<Parametric<TypeVar<1>, TypeVar<2>, TypeVar<3>, TypeVar<4>, TypeVar<5>, TypeVar<6>>>("Matrix")
    .apply<Eigen::Matrix<double, 2, 2>>([&types](auto wrapped)
  {
    typedef typename decltype(wrapped)::type WrappedT;
    types.method("setConstant", [](WrappedT& eigen_mat, const double val)
    {
      eigen_mat.setConstant(val);
    });

    types.method("print", [](const WrappedT& eigen_mat)
    {
      std::cout << "\n" << eigen_mat << std::endl;
    });

    //types.method("convert", [](SingletonType<ArrayRef<typename WrappedT::Scalar, 2>>, const WrappedT& eigen_mat)
    //{
    //  return ArrayRef<typename WrappedT::Scalar, 2>(eigen_mat.data(), eigen_mat.rows(), eigen_mat.cols());
    //});
  });


JULIA_CPP_MODULE_END
