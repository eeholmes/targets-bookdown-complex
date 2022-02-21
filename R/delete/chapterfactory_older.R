# R/chapterfactory.R
#' @title Chapter target factory.
#' @description Define 2 targets:
#' 1. Chapter Rmd file.
#' 2. clean the Rmd by replacing math with the math defs
#' @return A list of target objects.
#' @export
#' @param file Character, data file path.
target_factory <- function(name, dir) {
  require(magrittr)
  name_chap <- deparse(substitute(name))
  name_file <- paste0(name_chap, "_file")
  sym_file <- as.symbol(name_file)
  # mathdefs_file defined in _targets.R
  command_clean <- substitute(
    clean_file(dir, file, texfile=texfile), 
    env = list(dir = dir, file = sym_file, texfile = as.symbol("mathdefs_file")))
  list(
    tar_target_raw(name_file, file.path("chapters", dir, "_chapter.Rmd"), format = "file"),
    tar_target_raw(
      name_chap,
      command_clean,
      format = 'file'
    )
  )
}