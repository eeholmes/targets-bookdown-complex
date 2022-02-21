#replace math commands (shortcuts) with their long definitions (written out in latex)
#Why do a replacement like this? See comments below
replace.defs = function(defsfile, inputfile, outputfile){
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

# rawfile is full path to the raw Rmd
# dir is the chapter directory within chapters folder and used as file name
clean_file <- function(dir, rawfile, texfile="tex/defs.tex"){
  outputfile <- file.path("docs", "Rcode", paste0(dir,".R"))
  knitr::purl(rawfile, output= outputfile)
  outputfile <- file.path("cleanedRmd", paste0(dir,".Rmd"))
  replace.defs(texfile, rawfile, outputfile)
  return(inputfile)
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
