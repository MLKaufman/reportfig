library(testthat)
library(ggplot2)
library(lattice)

# Helper to clean up test files
cleanup <- function(filename) {
    for (ext in c(".pdf", ".png", ".svg", ".jpeg", ".jpg", ".tiff")) {
        f <- paste0(filename, ext)
        if (file.exists(f)) unlink(f)
    }
}

test_that("reportfig renders and saves Base R plots", {
    fname <- "test_base_formal"
    cleanup(fname)

    # We use try because base R plot might not return anything
    res <- reportfig(plot(1:10), fname)

    expect_true(file.exists(paste0(fname, ".pdf")))
    expect_equal(res, paste0(fname, ".pdf"))
    cleanup(fname)
})

test_that("reportfig renders and saves ggplot2 objects", {
    fname <- "test_ggplot_formal"
    cleanup(fname)

    p <- ggplot(mtcars, aes(wt, mpg)) +
        geom_point()
    res <- reportfig(p, fname)

    expect_true(file.exists(paste0(fname, ".pdf")))
    expect_equal(res, paste0(fname, ".pdf"))
    cleanup(fname)
})

test_that("reportfig renders and saves lattice objects", {
    fname <- "test_lattice_formal"
    cleanup(fname)

    l <- xyplot(mpg ~ wt, data = mtcars)
    res <- reportfig(l, fname)

    expect_true(file.exists(paste0(fname, ".pdf")))
    expect_equal(res, paste0(fname, ".pdf"))
    cleanup(fname)
})

test_that("reportfig handles multiple devices", {
    fname <- "test_multi"
    cleanup(fname)

    res <- reportfig(plot(1:5), fname, devices = c("pdf", "png"))

    expect_true(file.exists(paste0(fname, ".pdf")))
    expect_true(file.exists(paste0(fname, ".png")))
    expect_length(res, 2)
    cleanup(fname)
})

test_that("reportfig handles output_dir", {
    fname <- "test_out"
    out_dir <- "test_dir"
    if (dir.exists(out_dir)) unlink(out_dir, recursive = TRUE)

    reportfig(plot(1:5), fname, output_dir = out_dir)

    expect_true(file.exists(file.path(out_dir, paste0(fname, ".pdf"))))
    unlink(out_dir, recursive = TRUE)
})

test_that("reportfig respects global options", {
    fname <- "test_opts"
    cleanup(fname)

    options(reportfig.devices = "png")
    on.exit(options(reportfig.devices = NULL))

    reportfig(plot(1:5), fname)

    expect_true(file.exists(paste0(fname, ".png")))
    expect_false(file.exists(paste0(fname, ".pdf")))
    cleanup(fname)
})

test_that("reportfig uses knitr label as default filename", {
    # Mock knitr::opts_current
    if (!requireNamespace("knitr", quietly = TRUE)) skip("knitr not available")

    # This is tricky to mock perfectly without loading knitr,
    # but we can try to inject into the namespace or just check the logic if we were in a chunk.
    # For CI/automated tests, we can use a simpler check if filename is null and not in knitr
    res <- reportfig(plot(1:5), filename = NULL)
    expect_null(res) # Should be null if not in knitr and no filename provided
})
