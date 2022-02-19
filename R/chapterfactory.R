# R/chapterfactory.R
#' @title Chapter target factory.
#' @description Define 2 targets:
#' 1. Chapter Rmd file.
#' 2. Render the file.
#' @return A list of target objects.
#' @export
#' @param file Character, data file path.
target_factory <- function(name, dir="chapters") {
  require(magrittr)
  name_chap <- deparse(substitute(name))
  name_file <- paste0(name_chap, "_file")
  sym_file <- as.symbol(name_file)
  command_render <- substitute(
    rmarkdown::render(file, output_file = file, output_dir = 'rendered-chapters'), 
    env = list(file = sym_file))
  list(
    tar_target_raw(name_file, file.path(dir, paste0(name_chap, ".Rmd")), format = "file"),
    tar_target_raw(
      name_chap,
      command_render,
      format = 'file'
    )
  )
}