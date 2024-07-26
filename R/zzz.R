# R/zzz.R

.onLoad <- function(libname, pkgname) {
  source(system.file("R", "install_deps.R", package = pkgname))
}
