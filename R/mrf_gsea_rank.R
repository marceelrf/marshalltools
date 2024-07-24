#' Generate Gene Ranking for GSEA
#'
#' This function generates a ranked list of genes for Gene Set Enrichment Analysis (GSEA) based on specified log fold change and adjusted p-value thresholds.
#'
#' @param x A data frame or matrix containing gene expression data with row names as gene symbols.
#' @param logFC Numeric, the log2 fold change threshold for significance. Default is 0.5.
#' @param padj Numeric, the adjusted p-value threshold for significance. Default is 0.05.
#'
#' @return A named numeric vector containing the log2 fold change values of genes that meet the specified thresholds, ranked in descending order.
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(tibble)
#' # Example data
#' tbl <- data.frame(
#'   row.names = c("Gene1", "Gene2", "Gene3", "Gene4"),
#'   logFC = c(1.2, -1.5, 0.3, 2.0),
#'   padj = c(0.01, 0.04, 0.2, 0.03)
#' )
#' # Generate GSEA ranking
#' ranking <- mrf_gsea_rank(tbl, logFC = 0.5, padj = 0.05)
#' print(ranking)
#' }
#'
#' @import dplyr
#' @import tibble
#' @export
mrf_gsea_rank <- function(x,
                          logFC = .5,
                          padj = 0.05){

  x %>%
    rownames_to_column(var = "Gene") %>%
    mutate(sig = case_when(logFC > logFC & padj < padj ~ "Up",
                           logFC < -logFC & padj < padj ~ "Down",
                           TRUE ~ "Ns")) %>%
    filter(sig != "Ns") %>%
    select(Gene, logFC) %>%
    arrange(desc(logFC)) %>%
    deframe()
}

