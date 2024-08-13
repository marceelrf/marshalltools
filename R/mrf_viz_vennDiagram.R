#' Create and Save a Venn Diagram
#'
#' This function creates a Venn diagram based on the provided list of sets and saves it to a file.
#'
#' @param x A list of sets for which the Venn diagram is to be created. The length of the list should be between 2 and 4.
#' @param filename A character string specifying the name of the output file. Default is an empty string.
#' @param res Numeric, the resolution of the output image. Default is 600.
#' @param height Numeric, the height of the output image. Default is 6000.
#' @param width Numeric, the width of the output image. Default is 6000.
#' @param compression A character string specifying the type of compression for the output file. Default is "lzw".
#' @param cex Numeric, the scaling factor for the text in the diagram. Default is 2.
#' @param fontface A character string specifying the font face for the text. Default is "bold".
#' @param ... Additional arguments passed to the `venn.diagram` function.
#'
#' @return A Venn diagram saved to the specified file.
#'
#' @examples
#' \dontrun{
#' library(VennDiagram)
#' # Example data
#' list_of_sets <- list(A = 1:5, B = 3:7, C = 6:10)
#' # Create and save Venn diagram
#' mrf_viz_vennDiagram(list_of_sets, filename = "venn_diagram.tiff")
#' }
#'
#' @importFrom VennDiagram venn.diagram
#' @export
mrf_viz_vennDiagram <- function(x,
                                filename = "",
                                res = 600,
                                height = 6000,
                                width = 6000,
                                compression = "lzw",
                                cex = 2,
                                fontface = "bold",
                                ...) {

  stopifnot("The length of 'x' must be between 2 and 4." = length(x) >= 2 & length(x) <= 4)

  VennDiagram::venn.diagram(x = x,
                            filename = filename,
                            height = height,
                            width = width,
                            resolution = res,
                            compression = compression,
                            cex = cex,
                            fontface = fontface,
                            euler.d = FALSE,
                            scaled = FALSE,
                            ...)
}
