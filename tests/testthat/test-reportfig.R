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
    reportfig(plot(1:10), fname)

    expect_true(file.exists(paste0(fname, ".pdf")))
    cleanup(fname)
})

test_that("reportfig renders and saves ggplot2 objects", {
    fname <- "test_ggplot_formal"
    cleanup(fname)

    p <- ggplot(mtcars, aes(wt, mpg)) +
        geom_point()
    res <- reportfig(p, fname)

    expect_true(file.exists(paste0(fname, ".pdf")))
    expect_s3_class(res, "ggplot")
    cleanup(fname)
})

test_that("reportfig renders and saves lattice objects", {
    fname <- "test_lattice_formal"
    cleanup(fname)

    l <- xyplot(mpg ~ wt, data = mtcars)
    res <- reportfig(l, fname)

    expect_true(file.exists(paste0(fname, ".pdf")))
    expect_s3_class(res, "trellis")
    cleanup(fname)
})

test_that("reportfig handles multiple devices", {
    fname <- "test_multi"
    cleanup(fname)

    reportfig(plot(1:5), fname, devices = c("pdf", "png"))

    expect_true(file.exists(paste0(fname, ".pdf")))
    expect_true(file.exists(paste0(fname, ".png")))
    cleanup(fname)
})
