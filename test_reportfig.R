# Test reportfig
source("R/reportfig.R")
library(ggplot2)
library(lattice)

# 1. Base R
message("Testing Base R...")
reportfig(plot(1:10, main = "Base R"), "test_base")

# 2. ggplot2
message("Testing ggplot2...")
p <- ggplot(mtcars, aes(wt, mpg)) +
    geom_point() +
    labs(title = "ggplot2")
reportfig(p, "test_ggplot")

# 3. lattice
message("Testing lattice...")
l <- xyplot(mpg ~ wt, data = mtcars, main = "Lattice")
reportfig(l, "test_lattice")

# Check if files exist
files <- c("test_base.pdf", "test_ggplot.pdf", "test_lattice.pdf")
for (f in files) {
    if (file.exists(f)) {
        message("SUCCESS: ", f, " created.")
    } else {
        message("FAILURE: ", f, " NOT created.")
    }
}
