# R/chapterfactory.R
#' @title Chapter target factory.
#' @description Define 2 targets:
#' 1. Chapter Rmd file.
#' 2. Render the file to markdown. Equations won't work.
#' @return A list of target objects.
#' @export
#' @param file Character, data file path.
target_factory <- function(name, dir) {
  require(magrittr)
  name_chap <- deparse(substitute(name))
  name_file <- paste0(name_chap, "_file")
  kids_file <- paste0(name_chap, "_kids")
  sym_file <- as.symbol(name_file)
  kids <- find.children(file.path("chapters", dir, "_chapter.Rmd"))
  # clean_render is defined in functions.R
  command_render <- substitute(
    clean_render(outname, chapfile, texfile=texfile), 
    env = list(outname = dir, chapfile = sym_file, texfile = as.symbol("mathdefs_file")))
  command_render_with_kids <- substitute(
    clean_render(outname, chapfile, texfile=texfile, kids=kidsfile), 
    env = list(outname = dir, chapfile = sym_file, texfile = as.symbol("mathdefs_file"), kidsfile = as.symbol(kids_file)))
  list(
    targets::tar_target_raw(name_file, file.path("chapters", dir, "_chapter.Rmd"), format = "file"),
    if(length(kids)!=0) tarchetypes::tar_files_raw(
       kids_file, 
       substitute(find.children(inputfile), env = list(inputfile = sym_file))),
    if(length(kids)==0) tar_target_raw(
      name_chap,
      command_render,
      format = 'file'
    ),
    if(length(kids)!=0) tar_target_raw(
      name_chap,
      command_render_with_kids,
      format = 'file'
    )
  )
}