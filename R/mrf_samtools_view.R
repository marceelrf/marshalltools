#' Extract and Convert Regions from BAM Files Using SAMtools
#'
#' This function uses SAMtools to extract specified regions from a BAM file and convert the output to a chosen format (BAM, SAM, or CRAM). It supports multi-threading and allows users to specify an output file name.
#'
#' @param bam `character`. Path to the input BAM file. This argument is required.
#' @param output_format `character`. The format of the output file. Options are `"BAM"`, `"SAM"`, or `"CRAM"`. Default is `"BAM"`.
#' @param region `character`. Genomic region to extract in the format `chr:start-end`. If not specified, the entire BAM file is processed.
#' @param threads `integer`. Number of threads to use for the operation. Default is 1.
#' @param output_name `character`. Name of the output file. If not specified, a default name is generated based on the input BAM file and the chosen output format.
#'
#' @return `character`. The path to the generated output file.
#'
#' @details
#' The function constructs a SAMtools `view` command to extract data from the specified BAM file. The output can be saved in BAM, SAM, or CRAM format, depending on the user's choice. If a region is specified, only that region is extracted; otherwise, the entire BAM file is processed.
#'
#' @note Ensure that SAMtools is installed and available in your system's PATH before running this function.
#'
#' @examples
#' \dontrun{
#' # Extract and save a region in BAM format
#' mrf_samtools_view(bam = "alignment.bam", region = "chr1:1000-5000")
#'
#' # Convert the entire BAM file to SAM format
#' mrf_samtools_view(bam = "alignment.bam", output_format = "SAM")
#'
#' # Extract and save a region in CRAM format
#' mrf_samtools_view(bam = "alignment.bam", region = "chr2:2000-6000", output_format = "CRAM")
#' }
#'
#' @importFrom tools file_path_sans_ext
#' @export
mrf_samtools_view <- function(bam = NULL,
                              output_format = "BAM",
                              region = NULL,
                              threads = 1,
                              output_name = NULL) {

  # Check if bam file is provided
  if (is.null(bam)) {
    stop("The 'bam' argument must be specified.")
  }

  # Check if the BAM file exists
  if (!file.exists(bam)) {
    stop("The specified BAM file does not exist.")
  }

  # Validate output format
  valid_formats <- c("BAM", "SAM", "CRAM")
  if (!(output_format %in% valid_formats)) {
    stop("Invalid output format. Choose from 'BAM', 'SAM', or 'CRAM'.")
  }

  # Determine output file name
  if (is.null(output_name)) {
    # Generate a default output filename based on the BAM file name and desired format
    output_name <- paste0(tools::file_path_sans_ext(bam), "_view.", tolower(output_format))
  } else {
    # Ensure the output file name has the correct extension
    if (!grepl(paste0("\\.", tolower(output_format), "$"), output_name)) {
      output_name <- paste0(output_name, ".", tolower(output_format))
    }
  }

  # Construct the SAMtools command
  samtools_cmd <- paste0("samtools view -h -@", threads, " ", bam)

  # Add region specification if provided
  if (!is.null(region)) {
    samtools_cmd <- paste0(samtools_cmd, " ", region)
  }

  # Add format specification and redirect output
  if (output_format != "BAM") {
    samtools_cmd <- paste0(samtools_cmd, " | samtools view -@", threads, " -", tolower(output_format), " > ", output_name)
  } else {
    samtools_cmd <- paste0(samtools_cmd, " > ", output_name)
  }

  # Execute the SAMtools command
  system(samtools_cmd, intern = FALSE)

  # Inform the user
  cat(paste0("SAMtools view operation complete. Output written to ", output_name, "\n"))

  # Return the output file path
  return(output_name)
}
