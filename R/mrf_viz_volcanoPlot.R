#' Create a Volcano Plot for Differential Expression Data
#'
#' This function creates a volcano plot to visualize differential expression data, highlighting upregulated, downregulated, and non-significant genes.
#'
#' @param x A data frame containing gene expression data with columns for log2 fold change and p-values.
#' @param logFC Numeric, the log2 fold change threshold for significance. Default is 1.
#' @param pvalue Numeric, the p-value threshold for significance. Default is 0.05.
#'
#' @return A ggplot2 object representing the volcano plot.
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(tidyr)
#' library(tibble)
#' library(ggplot2)
#' # Example data
#' tbl <- data.frame(
#'   logFC = c(1.2, -1.5, 0.3, 2.0),
#'   pvalue = c(0.01, 0.04, 0.2, 0.03)
#' )
#' # Create volcano plot
#' plot <- mrf_viz_volcanoPlot(tbl, logFC = 1, pvalue = 0.05)
#' print(plot)
#' }
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr mutate
#' @importFrom tidyr drop_na
#' @importFrom tibble rownames_to_column
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 scale_color_manual
#' @export
mrf_viz_volcanoPlot <- function(x,
                                logFC = 1,
                                pvalue = 0.05) {

  x %>%
    util_createCond(logFC = logFC, pvalue = pvalue) %>%
    tibble::rownames_to_column("Symbol") %>%
    ggplot2::ggplot(ggplot2::aes(x = logFC, y = -log10(pvalue), col = Cond)) +
    ggplot2::geom_point() +
    ggplot2::scale_color_manual(values = c("Down" = "dodgerblue",
                                           "Up" = "indianred3",
                                           "Ns" = "grey50"))
}

