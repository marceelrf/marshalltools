#' Create Condition Labels for Differential Expression Data
#'
#' This function adds a condition label ("Up", "Down", or "Ns") to each gene based on specified log fold change and p-value thresholds.
#'
#' @param x A data frame containing gene expression data with columns for log2 fold change and p-values.
#' @param logFC Numeric, the log2 fold change threshold for significance. Default is 1.
#' @param pvalue Numeric, the p-value threshold for significance. Default is 0.05.
#'
#' @return A data frame with an additional column, "Cond", indicating the condition of each gene:
#' \item{"Up"}{If log2 fold change > logFC and p-value < pvalue.}
#' \item{"Down"}{If log2 fold change < -logFC and p-value < pvalue.}
#' \item{"Ns"}{If neither condition is met.}
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(tidyr)
#' library(tibble)
#' # Example data
#' tbl <- data.frame(
#'   logFC = c(1.2, -1.5, 0.3, 2.0),
#'   pvalue = c(0.01, 0.04, 0.2, 0.03)
#' )
#' # Create condition labels
#' labeled_data <- util_createCond(tbl, logFC = 1, pvalue = 0.05)
#' print(labeled_data)
#' }
#'
#' @import dplyr
#' @import tidyr
#' @import tibble
#' @export
util_createCond <- function(x,
                            logFC = 1,
                            pvalue = 0.05){


  x %>%
    tidyr::drop_na() %>%
    dplyr::mutate(Cond = dplyr::case_when(
      logFC > 1 & pvalue < 0.05 ~ "Up",
      logFC < -1 & pvalue < 0.05 ~ "Down",
      TRUE ~ "Ns"
    ))
}
