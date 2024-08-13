#' Get the Complement of a DNA Sequence
#'
#' This function takes a DNA sequence as input and returns its complementary sequence.
#'
#' @param x A character string representing a DNA sequence (containing the nucleotides A, T, C, G).
#'
#' @return A character string representing the complementary DNA sequence.
#'
#' @examples
#' \dontrun{
#' dna_sequence <- "ATCG"
#' complement_sequence <- util_seqComplement(dna_sequence)
#' print(complement_sequence)  # Output will be "TAGC"
#' }
#'
#' @export
util_seqComplement <- function(x) {
  # Create a named vector to map each nucleotide to its complement
  complement_map <- c(A = "T", T = "A", C = "G", G = "C")

  # Split the DNA sequence into individual nucleotides
  nucleotides <- strsplit(x, split = "")[[1]]

  # Get the complement for each nucleotide
  complement <- complement_map[nucleotides]

  # Collapse the complement nucleotides back into a single string
  paste(complement, collapse = "")
}
