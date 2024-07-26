# R/install_deps.R

install_github_dependency <- function() {
  if (!requireNamespace("RcppFaddeeva", quietly = TRUE)) {
    remotes::install_github("marceelrf/RcppFaddeeva")
  }
}

install_github_dependency()
