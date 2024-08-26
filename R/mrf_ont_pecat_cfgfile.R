#' Create a PECAT Configuration File for Oxford Nanopore Sequencing
#'
#' This function generates a configuration file for the PECAT pipeline, tailored to Oxford Nanopore sequencing data. The function supports two modes of operation: `Single` and `Multiple`.
#'
#' In `Single` mode, the function generates a configuration file for a single sequencing project based on the provided project name, reads, and genome size. In `Multiple` mode, the function processes a BED file with multiple regions and generates individual configuration files for each region using a BAM file.
#'
#' @param project `character`. Name of the project. Required in `Single` mode. Ignored in `Multiple` mode.
#' @param bed `character`. Path to the BED file specifying regions of interest. Required in `Multiple` mode.
#' @param reads `character`. Path to the reads file. Required in `Single` mode.
#' @param bam `character`. Path to the BAM file. Required in `Multiple` mode.
#' @param genome_size `numeric`. The size of the genome. Required in `Single` mode.
#' @param threads `integer`. Number of threads to use for processing. Default is 4.
#' @param mode `character`. Mode of operation. Can be either `"Single"` or `"Multiple"`. Default is `"Single"`.
#'
#' @return The function creates one or more configuration files based on the provided input. No return value.
#'
#' @details
#' - In `Single` mode, a single configuration file is generated with the specified project name, reads file, and genome size.
#' - In `Multiple` mode, the function reads a BED file and generates a configuration file for each region specified in the BED file using the corresponding region from the BAM file.
#'
#' @note The function requires that the PECAT tool (`pecat.pl`) is available and that the user is in a Conda environment. If not, the function will stop with an error.
#'
#' @examples
#' \dontrun{
#' # Single mode example
#' mrf_ont_pecat_cfgfile(project = "my_project",
#'                       reads = "reads.fastq",
#'                       genome_size = 3000000000,
#'                       mode = "Single")
#'
#' # Multiple mode example
#' mrf_ont_pecat_cfgfile(bed = "regions.bed",
#'                       bam = "alignment.bam",
#'                       mode = "Multiple")
#' }
#'
#' @importFrom readr read_lines write_lines read_tsv
#' @importFrom crayon blue red
#' @export
mrf_ont_pecat_cfgfile <- function(project = NULL,
                                  bed = NULL,
                                  reads = NULL,
                                  bam = NULL,
                                  genome_size = NULL,
                                  threads = 4,
                                  mode = c("Single", "Multiple")) {

  # Validate and set mode
  mode <- match.arg(mode)

  # Check if in a Conda environment
  if (is.na(Sys.getenv("CONDA_PREFIX"))) {
    stop("You are not in a CONDA ENV")
  }

  # Create a default config file
  if (system("pecat.pl config cfgfile", intern = FALSE) != 0) {
    stop("Failed to create the default config file.")
  }

  if (mode == "Single") {
    # Validate inputs for Single mode
    if (is.null(project)) stop("In single mode, 'project' cannot be NULL.")
    if (is.null(reads)) stop("In single mode, 'reads' must be specified.")
    if (is.null(genome_size)) stop("In single mode, 'genome_size' must be specified.")

    # Read and update the config file
    cfgfile <- readr::read_lines("cfgfile")
    cfgfile[1] <- paste0("project=", project)
    cfgfile[2] <- paste0("reads=", reads)
    cfgfile[3] <- paste0("genome_size=", genome_size)
    cfgfile[4] <- paste0("threads=", threads)

    readr::write_lines(x = cfgfile, file = "cfgfile")

    # Warning about BED file in Single mode
    if (!is.null(bed) && !file.exists(bed)) {
      warning("In single mode, the BED file argument is ignored.")
    }

  } else if (mode == "Multiple") {
    # Validate inputs for Multiple mode
    if (is.null(bed) || !file.exists(bed)) stop("For multiple mode, a valid BED file must be specified.")
    if (is.null(bam) || !file.exists(bam)) stop("In multiple mode, 'bam' file must be specified.")

    # Warning about project argument in Multiple mode
    if (!is.null(project)) {
      warning("In multiple mode, the 'project' argument is ignored.")
    }

    # Read BED file
    bed_file <- readr::read_tsv(file = bed, col_names = FALSE)

    # Process each row in BED file
    cfgfile <- readr::read_lines("cfgfile")

    for (i in seq_len(nrow(bed_file))) {
      # Generate a region string
      region <- paste0(bed_file[i, 1], ":", bed_file[i, 2], "-", bed_file[i, 3])

      # Provide feedback
      cat(paste0("Extracting the reads for ", crayon::blue(bed_file[i, 5]), "\n"))
      # Call mrf_samtools_bam2fq function
      reads_fastq <- mrf_samtools_bam2fq(bam = bam, output_name = "reads.fastq", threads = threads, region = region)


      # Provide feedback
      cat(paste0("Creating the config file for ", crayon::red(bed_file[i, 5]), "\n"))

      # Update the config file for the current BED entry
      cfgfile[1] <- paste0("project=", bed_file[i, 5])
      cfgfile[2] <- paste0("reads=", reads_fastq)
      cfgfile[3] <- paste0("genome_size=", bed_file[i, 3] - bed_file[i, 2] + 1)
      cfgfile[4] <- paste0("threads=", threads)

      # Write the updated config file
      config_filename <- paste0(bed_file[i, 5], "_cfgfile")
      readr::write_lines(x = cfgfile, file = config_filename)


    }

  } else {
    stop("Invalid mode specified. Choose either 'Single' or 'Multiple'.")
  }
}
