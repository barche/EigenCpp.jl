using BinDeps

@BinDeps.setup

cpp_wrapper_dir = joinpath(Pkg.dir("CppWrapper"),"deps","usr","lib","cmake")

eigen_wrapper = library_dependency("eigen_wrapper", aliases=["libeigen_wrapper"])
prefix=joinpath(BinDeps.depsdir(eigen_wrapper),"usr")
eigen_wrapper_srcdir = joinpath(BinDeps.depsdir(eigen_wrapper),"src","eigen_wrapper")
eigen_wrapper_builddir = joinpath(BinDeps.depsdir(eigen_wrapper),"builds","eigen_wrapper")
lib_suffix = @windows? "dll" : (@osx? "dylib" : "so")
provides(BuildProcess,
	(@build_steps begin
		CreateDirectory(eigen_wrapper_builddir)
		@build_steps begin
			ChangeDirectory(eigen_wrapper_builddir)
			FileRule(joinpath(prefix,"lib", "libeigen_wrapper.$lib_suffix"),@build_steps begin
				`cmake -DCMAKE_INSTALL_PREFIX="$prefix" -DCMAKE_BUILD_TYPE="Release" -DCppWrapper_DIR="$cpp_wrapper_dir" $eigen_wrapper_srcdir`
				`make`
				`make install`
			end)
		end
	end),eigen_wrapper)

@BinDeps.install
