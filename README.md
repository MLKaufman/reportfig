# reportfig: Universal plot wrapper for quarto rendering and figure export

`reportfig` is a lightweight R package designed to streamline the workflow of rendering plots in Quarto documents while simultaneously exporting them to high-quality files (defaulting to PDF).

## Key Features

- **Universal Compatibility**: Works seamlessly with any R plotting system:
  - **Base R**: `plot()`, `hist()`, etc.
  - **ggplot2**: Full support for ggplot objects and patchwork.
  - **Lattice**: Support for trellis objects.
  - **ComplexHeatmap**: Explicit support for `Heatmap` and `HeatmapList`.
  - **pheatmap**: Support for gtable outputs.
  - **Grid**: Support for any `grob` or `gtable` object.
- **Quarto & RMarkdown Optimized**: Renders the plot in the current output (HTML/PDF) while creating a sidecar file.
- **Default PDF Export**: One-step PDF generation with professional defaults (7x7", 300 DPI for rasters).
- **Multi-format Support**: Easily export to `png`, `svg`, `jpeg`, or `tiff` via the `devices` argument.

## Installation

You can install the development version of `reportfig` from GitHub:

```r
# install.packages("devtools")
devtools::install_github("MLKaufman/reportfig")
```

## Main Function Documentation

```r
reportfig <- function(plot_expr, # plot object or expression to render
                      filename = NULL, # base filename for export (without extension)
                      width = 7, # export width in inches
                      height = 7, # export height in inches
                      devices = "pdf", # vector of devices to export (e.g., c("pdf", "png"))
                      ...)
``` 

## Usage

### Simple Base R

```r
library(reportfig)
reportfig(plot(1:10, main="Base R Example"), "my_plot")
```

### ggplot2

```r
library(ggplot2)
p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
reportfig(p, "ggplot_export")
```

### Complex Heatmaps

```r
library(ComplexHeatmap)
mat <- matrix(rnorm(100), 10)
h <- Heatmap(mat)
reportfig(h, "heatmap_export")
```

### Customizing Export

```r
# Exporting as both PDF and PNG with custom dimensions
reportfig(p, "fine_plot", width = 10, height = 6, devices = c("pdf", "png"))
```

## Why use `reportfig`?

In a Quarto workflow, you often want a plot to look good in the rendered report but also need a high-quality PDF version for a manuscript or presentation. `reportfig` eliminates the need for redundant code like:

```r
# The manual way
p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
p
ggsave("plot.pdf", p)
```

With `reportfig`, it becomes a single, clean call that handles the rendering logic for you regardless of the plotting library used.