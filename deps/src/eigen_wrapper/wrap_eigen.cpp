#include <cpp_wrapper.hpp>
#include <Eigen/Dense>

namespace eigen_wrapper
{

}

JULIA_CPP_MODULE_BEGIN(registry)
  cpp_wrapper::Module& types = registry.create_module("EigenCpp");

  types.add_type<Eigen::MatrixXd>("MatrixXd");
JULIA_CPP_MODULE_END
