% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mrf_viz_volcanoPlot.R
\name{mrf_viz_volcanoPlot}
\alias{mrf_viz_volcanoPlot}
\title{Create a Volcano Plot for Differential Expression Data}
\usage{
mrf_viz_volcanoPlot(x, logFC = 1, pvalue = 0.05)
}
\arguments{
\item{x}{A data frame containing gene expression data with columns for log2 fold change and p-values.}

\item{logFC}{Numeric, the log2 fold change threshold for significance. Default is 1.}

\item{pvalue}{Numeric, the p-value threshold for significance. Default is 0.05.}
}
\value{
A ggplot2 object representing the volcano plot.
}
\description{
This function creates a volcano plot to visualize differential expression data, highlighting upregulated, downregulated, and non-significant genes.
}
\examples{
\dontrun{
library(dplyr)
library(tidyr)
library(tibble)
library(ggplot2)
# Example data
tbl <- data.frame(
  logFC = c(1.2, -1.5, 0.3, 2.0),
  pvalue = c(0.01, 0.04, 0.2, 0.03)
)
# Create volcano plot
plot <- mrf_viz_volcanoPlot(tbl, logFC = 1, pvalue = 0.05)
print(plot)
}

}
