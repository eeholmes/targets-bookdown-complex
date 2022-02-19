library(targets)
library(tarchetypes)
source("R/functions.R")
source("R/chapterfactory.R")

options(tidyverse.quiet = TRUE)

tar_option_set(packages = c("tidyverse", "bookdown"))

list(
  target_factory(chap1),
  target_factory(chap2),
  target_factory(chap3, dir="chapters/chap3"),
  
  tar_file(index, 'index.Rmd'),
  tar_file(yaml, '_bookdown.yml'),
  
  tar_target(
    book,
    render_with_deps(index, yaml, chap1, chap2, chap3)
  )
)
