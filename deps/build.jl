using BinDeps
using CxxWrap

@BinDeps.setup

cxx_wrap_dir = Pkg.dir("CxxWrap","deps","usr","lib","cmake")

eigen_wrapper = library_dependency("eigen_wrapper", aliases=["libeigen_wrapper"])

cmake_prefix = ""

prefix=joinpath(BinDeps.depsdir(eigen_wrapper),"usr")
eigen_wrapper_srcdir = joinpath(BinDeps.depsdir(eigen_wrapper),"src","eigen_wrapper")
eigen_wrapper_builddir = joinpath(BinDeps.depsdir(eigen_wrapper),"builds","eigen_wrapper")
lib_prefix = @static is_windows() ? "" : "lib"
lib_suffix = @static is_windows() ? "dll" : (@static is_apple() ? "dylib" : "so")

makeopts = ["--", "-j", "$(Sys.CPU_CORES+2)"]

# Set generator if on windows
genopt = "Unix Makefiles"

build_type = get(ENV, "CXXWRAP_BUILD_TYPE", "Release")

eigen_steps = @build_steps begin
	`cmake -G "$genopt" -DCMAKE_INSTALL_PREFIX="$prefix" -DCMAKE_BUILD_TYPE="$build_type" -DCMAKE_PREFIX_PATH="$cmake_prefix" -DCxxWrap_DIR="$cxx_wrap_dir" -DCMAKE_CXX_COMPILER=mpic++ -DCMAKE_C_COMPILER=mpicc $eigen_wrapper_srcdir`
	`cmake --build . --config $build_type --target install $makeopts`
end

# If built, always run cmake, in case the code changed
if isdir(eigen_wrapper_builddir)
  BinDeps.run(@build_steps begin
    ChangeDirectory(eigen_wrapper_builddir)
    eigen_steps
  end)
end

provides(BuildProcess,
  (@build_steps begin
    CreateDirectory(eigen_wrapper_builddir)
    @build_steps begin
      ChangeDirectory(eigen_wrapper_builddir)
      FileRule(joinpath(prefix,"lib", "$(lib_prefix)eigen_wrapper.$lib_suffix"),eigen_steps)
    end
  end),eigen_wrapper)

@BinDeps.install Dict([(:eigen_wrapper, :_l_eigen_wrap)])

@static if is_windows()
  if build_on_windows
    empty!(BinDeps.defaults)
    append!(BinDeps.defaults, saved_defaults)
  end
end
