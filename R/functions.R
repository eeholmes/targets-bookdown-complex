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

#replace math commands (shortcuts) with their long definitions (written out in latex)
#Why do a replacement like this? See comments below
replace.defs <- function(defsfile, inputfile, outputfile){
  defs <- readLines(defsfile)
  content <- readLines(inputfile)
  for(i in defs){
    start <- stringr::str_locate(i,"newcommand[{]")[2]+1
    end <- stringr::str_locate(i,"[}]")[1]-1
    tag <- stringr::str_sub(i, start, end)
    tag <- stringr::str_replace(tag, "\\\\","\\\\\\\\")
    start <- stringr::str_locate_all(i,"[{]")[[1]][2,1]+1
    end <- stringr::str_length(i)-1
    repval <- stringr::str_sub(i, start, end)
    repval <- stringr::str_replace_all(repval, "\\\\","\\\\\\\\")
    content <- stringr::str_replace_all(content, tag, repval)
  }
  writeLines(content, outputfile)
}

# Find all the children in an Rmd
find.children <- function(inputfile){
  content <- readLines(inputfile)
  txt <- c("[{]r child=", "[{]r child =", "[{]r  child=", "[{]r  child =")
  childlines <- which(apply(sapply(txt, function(x){stringr::str_detect(content, x)}),1,any))
  kids <- c()
  if(length(childlines)!=0){
    childlines <- content[childlines]
    for(i in childlines){
      start <- na.omit(stringr::str_locate(i, txt))[2]+1
      end <- stringr::str_locate(i,"[}]")[1]-1
      kid <- stringr::str_sub(i, start, end)
      kid <- eval(parse(text=kid))
      kids <- c(kids, kid)
    }
  }
  return(kids)
}


# chapfile is full path to the chapter file
# kids so that can add dependency
clean_render <- function(outname, chapfile, texfile="tex/defs.tex", kids=NULL){
  # this saves the R code
  outputfile <- file.path("docs", "Rcode", paste0(outname,".R"))
  knitr::purl(chapfile, output= outputfile)
  # The part pulls in children and renders
  outfile <- file.path('rendered-chapters', paste0(outname, ".md"))
  knit_file <- knitr::knit(chapfile, outfile)
  # this replace mathdefs with full latex
  infile <- file.path('rendered-chapters', paste0(outname, ".md"))
  outfile <- file.path('rendered-chapters', paste0(outname, ".Rmd"))
  replace.defs(texfile, infile, outfile)
  # this cleans up
  file.remove(infile)
  return(outfile)
}

# This renders to markdown which does not retain the equations
clean_render_old <- function(dir, file, texfile="tex/defs.tex"){
  clean_file(dir, file, texfile=texfile)
  infile <- file.path("cleanedRmd", paste0(dir,".Rmd"))
  outfile <- paste0(dir, ".Rmd")
  rmarkdown::render(infile, output_file = outfile, output_dir = 'rendered-chapters')
}


# Bookdown render
render_with_deps <- function(index, ...) {
  bookdown::render_book(index, output_format = "all")
}


####################################################
# A search via google will show the following solutions
# Add 'before_body' to your output.yml:
#this works but the defs.tex is incl in html and flashes on screen
# If the def file is long, the flash is very obvious.
#
# bookdown::gitbook:
# before: |
#   includes:
#   before_body: [tex/bracket-start.txt, tex/defs.tex, tex/bracket-end.txt]
# bookdown::pdf_book:
#   includes:
# before_body: tex/defs.tex
# 
# Another solution is to use the child arg in a chunk near the top
# The problem is that it only works in math, so $ $ and $$ $$, not in equation, align or gather environments.
# ```{r test-main, child = 'tex/defs.tex'}
# ```
