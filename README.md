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
- **Zero-Config inside Quarto**: Automatically detects chunk labels as filenames.
- **Global Configuration**: Set package-wide defaults using R options.
- **Default PDF Export**: One-step PDF generation with professional defaults (7x7", 300 DPI for rasters).
- **Multi-format Support**: Easily export to `png`, `svg`, `jpeg`, or `tiff` via the `devices` argument.
- **Output Management**: Specify a centralized `output_dir` for all figures.

## Installation

You can install the development version of `reportfig` from GitHub:

```r
# install.packages("devtools")
devtools::install_github("MLKaufman/reportfig")
```

## Main Function Documentation

```r
reportfig(plot_expr,                       # plot object or expression to render
          filename = NULL,                 # base filename (inherited from knitr if NULL)
          width = getOption("reportfig.width", 7),
          height = getOption("reportfig.height", 7),
          devices = getOption("reportfig.devices", "pdf"),
          output_dir = getOption("reportfig.output_dir", NULL),
          res = getOption("reportfig.res", 300),
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

### Automated Integration with Quarto

If you are using Quarto or RMarkdown, `reportfig` will automatically use the chunk label as the filename if `filename` is omitted:

```r
#| label: fig-my-analysis
#| fig-cap: "Analysis results"

reportfig(ggplot(mtcars, aes(wt, mpg)) + geom_point())
# This saves 'fig-my-analysis.pdf' automatically
```

## Advanced Features

### Global Options

You can set project-wide defaults in your `.Rprofile`:

```r
options(
  reportfig.output_dir = "figures/exports",
  reportfig.devices = c("pdf", "png"),
  reportfig.width = 10,
  reportfig.height = 6
)
```

### Customizing Export

```r
# Override defaults for a specific plot
reportfig(p, "fine_plot", width = 12, height = 4, devices = "tiff", res = 600)
```

## Why use `reportfig`?

In a Quarto workflow, you often want a plot to look good in the rendered report but also need a high-quality PDF version for a manuscript or presentation. `reportfig` eliminates the need for redundant code like:

```r
# The manual way
p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
p
ggsave("plot.pdf", p)
```

With `reportfig`, it becomes a single, clean call that handles the rendering logic for you regardless of the plotting library used, and keeps your project organized by managing export paths and labels automatically.
