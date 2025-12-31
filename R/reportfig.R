#' Wrap and Save R Plots for Quarto
#'
#' This function takes a plotting expression or object, renders it in the current
#' device (e.g., a Quarto document), and simultaneously saves it to one or more
#' file formats (defaulting to PDF).
#'
#' @param plot_expr A plotting expression (e.g., `plot(1:10)`) or a plot object
#'   (e.g., a ggplot2 or lattice object).
#' @param filename The base filename for the exported plot (without extension).
#'   If NULL, no file is saved.
#' @param width The width of the exported plot in inches. Default is 7.
#' @param height The height of the exported plot in inches. Default is 7.
#' @param devices A character vector of file extensions/devices to save to.
#'   Default is "pdf". Supported: "pdf", "png", "svg", "jpeg", "tiff".
#' @param ... Additional arguments passed to the specific device function
#'   (e.g., `pdf()`, `png()`).
#'
#' @return The original plot object (invisibly) if it's an object-based plot,
#'   otherwise NULL.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' reportfig(plot(1:10), "base_plot")
#'
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'     geom_point()
#' reportfig(p, "ggplot_example")
#' }
reportfig <- function(plot_expr,
                      filename = NULL,
                      width = getOption("reportfig.width", 7),
                      height = getOption("reportfig.height", 7),
                      devices = getOption("reportfig.devices", "pdf"),
                      output_dir = getOption("reportfig.output_dir", NULL),
                      res = getOption("reportfig.res", 300),
                      ...) {
    # 1. Capture the expression if it's not already an object
    # We use substitute to handle base R calls like reportfig(plot(1:10))
    expr <- substitute(plot_expr)

    # 2. Handle default filename from knitr if possible
    if (is.null(filename)) {
        if (requireNamespace("knitr", quietly = TRUE)) {
            label <- knitr::opts_current$get("label")
            if (!is.null(label)) {
                filename <- label
            }
        }
    }

    # Function to render the plot
    render_plot <- function() {
        # If plot_expr is a ggplot, lattice, or other object, print it
        # Supported classes include ggplot, lattice (trellis), grid (grob/gtable),
        # ComplexHeatmap (Heatmap/HeatmapList), and patchwork.
        if (inherits(plot_expr, c(
            "ggplot", "trellis", "grob", "gtable",
            "RecordedPlot", "Heatmap", "HeatmapList",
            "pheatmap", "patchwork"
        ))) {
            print(plot_expr)
        } else {
            # Otherwise evaluate the captured expression for base R plots
            eval(expr, envir = parent.frame())
        }
    }

    # 3. Render in the current device (e.g., Quarto/RStudio)
    render_plot()

    # 4. Handle file export if filename is provided (or retrieved from knitr)
    saved_paths <- character()
    if (!is.null(filename)) {
        # Prepare output directory
        if (!is.null(output_dir)) {
            if (!dir.exists(output_dir)) {
                dir.create(output_dir, recursive = TRUE)
            }
            filename <- file.path(output_dir, filename)
        }

        for (dev_type in devices) {
            ext <- tolower(dev_type)
            full_filename <- paste0(filename, ".", ext)

            # Select the device function
            dev_func <- switch(ext,
                pdf = grDevices::pdf,
                png = grDevices::png,
                svg = grDevices::svg,
                jpeg = grDevices::jpeg,
                jpg = grDevices::jpeg,
                tiff = grDevices::tiff,
                stop("Unsupported device: ", dev_type)
            )

            # Units for raster formats
            if (ext %in% c("png", "jpeg", "jpg", "tiff")) {
                dev_func(full_filename, width = width, height = height, units = "in", res = res, ...)
            } else {
                dev_func(full_filename, width = width, height = height, ...)
            }

            # Important: Capture errors during rendering to device to ensure dev.off() is called
            tryCatch({
                render_plot()
                saved_paths <- c(saved_paths, full_filename)
            }, finally = {
                grDevices::dev.off()
            })

            message("Saved plot to: ", full_filename)
        }
    }

    # Return saved paths invisibly, or the plot object if no paths were saved
    if (length(saved_paths) > 0) {
        return(invisible(saved_paths))
    }

    if (inherits(plot_expr, c(
        "ggplot", "trellis", "grob", "gtable",
        "RecordedPlot", "Heatmap", "HeatmapList",
        "pheatmap", "patchwork"
    ))) {
        return(invisible(plot_expr))
    } else {
        return(invisible(NULL))
    }
}
