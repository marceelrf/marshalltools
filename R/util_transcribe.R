#' Transcribe RNA Sequence to DNA Sequence
#'
#' This function transcribes an RNA sequence by replacing all occurrences of "U" with "T", converting it to a DNA sequence.
#'
#' @param x A character string representing an RNA sequence.
#'
#' @return A character string representing the corresponding DNA sequence.
#'
#' @examples
#' \dontrun{
#' rna_sequence <- "AUGCUA"
#' dna_sequence <- util_transcribe(rna_sequence)
#' print(dna_sequence)  # Output will be "ATGCTA"
#' }
#'
#' @export
util_transcribe <- function(x) {
  gsub(pattern = "U", replacement = "T", x = x)
}
