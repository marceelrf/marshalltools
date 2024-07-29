#' Export Differential Expression Results to CSV
#'
#' This function processes differential expression data to add condition labels and exports the results to a CSV file.
#'
#' @param x A data frame containing gene expression data with columns for log2 fold change and p-values.
#' @param title A character string specifying the prefix of the output CSV file name. Default is an empty string.
#' @param logFC Numeric, the log2 fold change threshold for significance. Default is 1.
#' @param pvalue Numeric, the p-value threshold for significance. Default is 0.05.
#'
#' @return A CSV file with the processed differential expression results, including condition labels.
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(tidyr)
#' library(tibble)
#' library(readr)
#' # Example data
#' tbl <- data.frame(
#'   logFC = c(1.2, -1.5, 0.3, 2.0),
#'   pvalue = c(0.01, 0.04, 0.2, 0.03)
#' )
#' # Export results to CSV
#' mrf_deseq2_exportTabs(tbl, title = "results", logFC = 1, pvalue = 0.05)
#' }
#'
#' @import dplyr
#' @import tidyr
#' @import tibble
#' @import readr
#' @export
mrf_deseq2_exportTabs <- function(x, title = "",
                                  logFC = 1,
                                  pvalue = 0.05) {

  x %>%
    util_createCond(logFC, pvalue) %>%
    readr::write_csv(file = paste0(title, ".csv"))
}
