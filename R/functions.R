# Create the references bib file combining the 3 bib files
create_refs <- function(...){
  if(file.exists(file.path("tex", "bookrefs.bib")))
     file.remove(file.path("tex", "bookrefs.bib"))
  file.create(file.path("tex", "bookrefs.bib"))
  file.append(file.path("tex", "bookrefs.bib"), ...)
  return(file.path("tex", "bookrefs.bib"))
}

# Change extension from md to Rmd
#  since (at the moment) bookdown ignores md files unless explicitly stated in
#  rmd_files
#  https://github.com/rstudio/bookdown/issues/956
change_ext <- function(file, inext, outext) {
  newfile <- gsub(inext, outext, file)
  file.rename(file, newfile)
  newfile
}

# Render the raw Rmd
clean_render <- function(dir, file, texfile="tex/defs.tex"){
  clean_file(dir, file, texfile=texfile)
  infile <- file.path("cleanedRmd", paste0(dir,".Rmd"))
  outfile <- paste0(dir, ".Rmd")
  rmarkdown::render(infile, output_file = outfile, output_dir = 'rendered-chapters')
}


# Bookdown render
render_with_deps <- function(index, ...) {
  bookdown::render_book(index, output_format = "all")
}
