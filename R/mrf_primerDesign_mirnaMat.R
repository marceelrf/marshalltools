#' Design Primers for miRNA Mature
#'
#' This function designs forward and reverse primers for a given miRNA sequence using predefined sequences. The reverse primer is the complement of the latter part of the transcribed sequence.
#'
#' @param x A character string representing a miRNA sequence.
#' @param print A logical value indicating whether to print the primers to the console. Default is `FALSE`.
#'
#' @return If `print = FALSE`, the function returns a named vector containing the forward and reverse primers. If `print = TRUE`, the primers are printed to the console with color formatting, and nothing is returned.
#'
#' @examples
#' \dontrun{
#' # Example miRNA sequence
#' mirna_seq <- "UGAGGUAGUAGGUUGUAUAGUU"
#'
#' # Generate primers and print them
#' mrf_primerDesign_mirnaMat(mirna_seq, print = TRUE)
#'
#' # Generate primers and return them as a vector
#' primers <- mrf_primerDesign_mirnaMat(mirna_seq)
#' print(primers)
#' }
#'
#' @importFrom crayon red
#' @export
mrf_primerDesign_mirnaMat <- function(x, print = FALSE) {

  preseq <- "CGGCGG"
  posseq <- "CAGCATAGGTCACGCTTATGGAGCCTGGGACGTGACCTATGCTG"
  t_seq <- util_transcribe(x)

  PF <- paste0(preseq, substr(t_seq, 1, 16))
  PRT <- paste0(util_seqComplement(substr(t_seq, 17, nchar(t_seq))), posseq)

  if (print) {
    cat(paste0(crayon::red("Primer Forward: "), PF, "\n\n",
               crayon::red("Primer Reverse: "), PRT))
  } else {
    vct <- c(PF, PRT)
    names(vct) <- c("Primer Forward", "Primer Reverse")
    return(vct)
  }
}

