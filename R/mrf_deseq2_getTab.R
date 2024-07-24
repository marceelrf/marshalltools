#' Extract Differential Expression Results into a Data Frame
#'
#' This function extracts relevant data from a DESeq2 results object and returns it as a data frame.
#'
#' @param x A DESeq2 results object from which to extract the data. This object should contain list data with components
#' `baseMean`, `log2FoldChange`, `lfcSE`, `stat`, `pvalue`, and `padj`, as well as row names.
#'
#' @return A data frame with the following columns:
#' \item{baseMean}{Mean of normalized counts for all samples.}
#' \item{logFC}{Log2 fold change between conditions.}
#' \item{lfcSE}{Standard error of the log2 fold change estimate.}
#' \item{stat}{Test statistic value.}
#' \item{pvalue}{Raw p-value.}
#' \item{padj}{Adjusted p-value.}
#'
#' @examples
#' \dontrun{
#' library(DESeq2)
#' # Example DESeq2 analysis
#' dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition)
#' dds <- DESeq(dds)
#' res <- results(dds)
#' # Extract results into a data frame
#' res_df <- mrf_deseq2_getTab(res)
#' head(res_df)
#' }
#'
#' @export
mrf_deseq2_getTab <- function(x){

  df <- data.frame(
    baseMean = x@listData$baseMean,
    logFC = x@listData$log2FoldChange,
    lfcSE = x@listData$lfcSE,
    stat = x@listData$stat,
    pvalue = x@listData$pvalue,
    padj = x@listData$padj,
    row.names = x@rownames
  )

  return(df)
}

