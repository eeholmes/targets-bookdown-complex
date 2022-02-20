#replace math commands (shortcuts) with their long definitions (written out in latex)
#Why do a replacement like this? See comments below
require(stringr)
replace.defs = function(defsfile, inputfile, outputfile){
  defs=readLines(defsfile)
  content=readLines(inputfile)
  for(i in defs){
    start=str_locate(i,"newcommand[{]")[2]+1
    end=str_locate(i,"[}]")[1]-1
    tag=str_sub(i, start, end)
    tag=str_replace(tag, "\\\\","\\\\\\\\")
    start=str_locate_all(i,"[{]")[[1]][2,1]+1
    end=str_length(i)-1
    repval=str_sub(i, start, end)
    repval=str_replace_all(repval, "\\\\","\\\\\\\\")
    content=str_replace_all(content, tag, repval)
  }
  writeLines(content, outputfile)
}

# rawfile is full path to the raw Rmd
clean_file <- function(dir, rawfile, texfile="tex/defs.tex"){
  require(stringr)
  outputfile <- file.path("cleanedRmd", paste0(dir,".Rmd"))
  replace.defs(texfile, rawfile, outputfile)
  outputfile <- file.path("docs", "Rcode", paste0(dir,".R"))
  knitr::purl(rawfile, output= outputfile)
  inputfile <- file.path("cleanedRmd", paste0(dir,".Rmd"))
  outputfile <- file.path("docs", "Rmd", paste0(dir,".Rmd"))
  file.copy(inputfile, outputfile, overwrite=TRUE)
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
