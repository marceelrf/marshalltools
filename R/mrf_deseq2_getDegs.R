#' Extract Differentially Expressed Genes
#'
#' This function extracts differentially expressed genes (DEGs) from a DESeq2 results object based on specified log fold change
#' and p-value thresholds.
#'
#' @param x A DESeq2 results object containing the results of differential expression analysis.
#' @param logFC Numeric, the log2 fold change threshold for significance. Default is 1.
#' @param pvalue Numeric, the p-value threshold for significance. Default is 0.05.
#'
#' @return A character vector containing the symbols of differentially expressed genes (DEGs) that meet the specified thresholds.
#'
#' @examples
#' \dontrun{
#' library(DESeq2)
#' library(dplyr)
#' library(tidyr)
#' library(tibble)
#' # Example DESeq2 analysis
#' dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition)
#' dds <- DESeq(dds)
#' res <- results(dds)
#' # Extract DEGs
#' degs <- mrf_deseq2_getDegs(res, logFC = 1, pvalue = 0.05)
#' print(degs)
#' }
#'
#' @import dplyr
#' @import tidyr
#' @import tibble
#' @export
mrf_deseq2_getDegs <- function(x,
                               logFC = 1,
                               pvalue = 0.05){

  x %>%
    util_createCond(logFC = logFC,
                    pvalue = pvalue) %>%
    dplyr::filter(Cond != "Ns") %>%
    tibble::rownames_to_column("Symbol") %>%
    dplyr::pull("Symbol")
}

