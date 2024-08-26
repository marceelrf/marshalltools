#' Run PECAT for Multiple Configuration Files
#'
#' This function automates the execution of the PECAT pipeline for multiple configuration files generated using the `mrf_ont_pecat_cfgfile` function. The function identifies all configuration files in the working directory with the `_cfgfile` suffix and runs the PECAT pipeline for each of them sequentially.
#'
#' @return The function does not return a value but runs PECAT on all detected configuration files and provides console output on the progress.
#'
#' @details
#' The function searches the current working directory for files with the `_cfgfile` suffix, then iteratively runs the `pecat.pl unzip` command on each configuration file. The progress is displayed in the console with the file's associated gene name highlighted.
#'
#' @examples
#' \dontrun{
#' # Run PECAT for all configuration files in the directory
#' mrf_ont_pecat_run()
#' }
#'
#' @importFrom crayon bold underline red silver
#' @export
mrf_ont_pecat_run <- function(){


  library(crayon)
  cfgfile_list <-
    list.files(pattern = "_cfgfile$")

  hg_theme <- red$bold$underline
  number_theme <- silver$bold$underline

  gene <- gsub(pattern = "_cfgfile$",replacement = "",cfgfile_list)

  for(i in seq_along(cfgfile_list)){



    cat(bold("----------------------------------------\n\n"))
    cat(paste0("Running PECAT for ", hg_theme(gene[i])), "\n\n")


    pecat_cmd <- paste0("pecat.pl unzip ",cfgfile_list[i])

    system(pecat_cmd, intern = FALSE)

    cat(paste0("\n",number_theme(i)," of ", number_theme(length(gene))," done!"), "\n\n")

    cat(bold("----------------------------------------\n\n"))

  }
}
