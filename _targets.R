library(targets)
library(tarchetypes)
source("R/functions.R")
source("R/chapterfactory.R")
source("R/clean_rmd.R")

options(tidyverse.quiet = TRUE)

targets::tar_option_set(packages = c("tidyverse", "bookdown"))

list(
  # These are the chapters and are in the chapters folder; 
  # Each chapter needs its own folder; the chapter Rmd is named "_chapter.Rmd"
  target_factory(chap01, dir="chap01-rw"),
  target_factory(chap02, dir="chap02-uss"),
  
  # These are the base bookdown files
  tarchetypes::tar_file(index, 'index.Rmd'),
  tarchetypes::tar_file(refs, 'references.Rmd'),
  tarchetypes::tar_file(mathdefs_file, file.path('tex', 'defs.tex')),
  tarchetypes::tar_file(yaml, '_bookdown.yml'),
  tarchetypes::tar_file(outyaml, '_output.yml'),
  tarchetypes::tar_file(prefix_file, file.path("tex", "preamble.tex")),
  tarchetypes::tar_file(bib_file1, file.path("tex", "Fish507.bib")),
  tarchetypes::tar_file(bib_file2, file.path("tex", "book.bib")),
  tarchetypes::tar_file(bib_file3, file.path("tex", "packages.bib")),
  tarchetypes::tar_file(css_file, file.path("docs", "style.css")),
  
  targets::tar_target(
    bib_file,
    create_refs(c(bib_file1, bib_file2, bib_file3)),
    format = "file"
  ),
  targets::tar_target(
    book,
    render_with_deps(index, yaml, outyaml, prefix_file, bib_file, css_file, refs,
                     chap01, chap02)
  )
)
