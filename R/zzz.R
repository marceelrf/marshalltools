# R/zzz.R

.onLoad <- function(libname, pkgname) {

  install_deps_path <- system.file("R", "install_deps.R", package = pkgname)
  if (file.exists(install_deps_path)) {
    source(install_deps_path)
  } else {
    warning("install_deps.R not found in the package.")
  }

  source(system.file("R", "install_deps.R", package = pkgname))

}
