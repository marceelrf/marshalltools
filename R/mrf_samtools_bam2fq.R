#' Convert BAM to FASTQ Using SAMtools
#'
#' This function converts a BAM file to a FASTQ file using SAMtools. It optionally allows for region-specific extraction and supports multi-threading.
#'
#' @param bam `character`. Path to the input BAM file. This argument is required.
#' @param output_name `character`. Name of the output FASTQ file. If not specified, the output file will be named based on the input BAM file with a `_reads.fastq` suffix.
#' @param threads `integer`. Number of threads to use for the conversion process. Default is 1.
#' @param region `character`. Genomic region to extract in the format `chr:start-end`. If not specified, the entire BAM file is converted.
#'
#' @return `character`. The path to the generated FASTQ file.
#'
#' @details
#' The function first uses `samtools view` to extract the specified region from the BAM file (if a region is specified) and writes it to a temporary BAM file. Then, it converts the temporary BAM file to FASTQ format using `samtools bam2fq`. The temporary BAM file is deleted after conversion.
#'
#' @note Ensure that SAMtools is installed and available in your system's PATH before running this function.
#'
#' @examples
#' \dontrun{
#' # Convert an entire BAM file to FASTQ
#' mrf_samtools_bam2fq(bam = "alignment.bam", output_name = "output_reads.fastq")
#'
#' # Convert a specific region from the BAM file to FASTQ
#' mrf_samtools_bam2fq(bam = "alignment.bam", region = "chr1:1000-5000")
#' }
#'
#' @importFrom tools file_path_sans_ext
#' @export
mrf_samtools_bam2fq <- function(bam = NULL,
                                output_name = NULL,
                                threads = 1,
                                region = NULL) {

  # Check if BAM file is provided
  if (is.null(bam)) {
    stop("The 'bam' argument must be specified.")
  }

  # Check if the BAM file exists
  if (!file.exists(bam)) {
    stop("The specified BAM file does not exist.")
  }

  # Determine output file name
  if (is.null(output_name)) {
    # Generate a default output filename based on the BAM file name
    output_name <- paste0(tools::file_path_sans_ext(bam), "_reads.fastq")
  } else {
    # Ensure the output file name has the correct extension
    if (!grepl("\\.fastq$", output_name)) {
      output_name <- paste0(output_name, ".fastq")
    }
  }

  # Create a temporary BAM file name
  tmp_bam <- "tmp_bam.bam"

  # Construct the SAMtools command
  samtools_cmd <- paste0("samtools view -@", threads, " ", bam)

  # Add region specification if provided
  if (!is.null(region)) {
    samtools_cmd <- paste0(samtools_cmd, " ", region)
  }

  # Write the output of samtools view to the temporary BAM file
  samtools_cmd <- paste0(samtools_cmd, " > ", tmp_bam)

  # Execute the SAMtools command
  system(samtools_cmd, intern = FALSE)

  # Construct the bam2fq command
  bam2fq_cmd <- paste0("samtools bam2fq -h -@", threads, " ", tmp_bam, " > ", output_name)

  # Execute the bam2fq command
  system(bam2fq_cmd, intern = FALSE)

  # Remove the temporary BAM file
  file.remove(tmp_bam)

  # Inform the user
  cat(paste0("BAM to FASTQ conversion complete. Output written to ", output_name, "\n"))

  # Return the output file path
  return(output_name)
}
