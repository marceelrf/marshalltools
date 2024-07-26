# R/install_deps.R

install_github_dependency <- function() {
  if (!requireNamespace("RcppFaddeeva", quietly = TRUE)) {

    message("Installing RcppFaddeeva from GitHub...")
    remotes::install_github("marceelrf/RcppFaddeeva")
  }
}

install_github_dependency()
