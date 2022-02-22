# More complex example using {targets} and {bookdown} {#top}

Fundamentally {targets} and {bookdown} don't play nice together since I cannot see any way to render but keep the figure legends and references. See targets-bookdown repo for more info.

* [Installing bookdown](#installing-bookdown)
* [Add a chapter](#add-a-chapter)
* [style sheet](#style-sheet)
* [Notes on writing the rmarkdown files](#writing-the-rmarkdown-files)
* [Special Rmd conventions for AFTS](#special-conventions)
* [Key files](#key-files)
* [Directories](#directories)
* [Required packages](#required-packages)
* [Building the book](#build-the-book)
* [Building a chapter](#build-a-chapter)
* [.gitignore file](#gitignore-file)

<!--
    tar_make()
-->

## Basic structure

This repo uses {targets}. The only folder you should edit while writing chapters is `chapters`. To build the book use

```
tar_make()
```

Since {targets} is used, the RStudio Build Book feature is not used.


## Add a chapter
[back to top](#top)

1. Create a folder in the `chapters` folder
2. Copy template.Rmd in that folder and rename it `_chapter.Rmd`
3. Look at other chapters for guidance.
4. Add a line like `target_factory(chap02, dir="chap02-uss")` to `_targets.R`
5. Add a line like  `- "rendered-chapters/chap01-rw.Rmd"` to `_bookdown.yml`

See below for how to edit a single chapter. It can be a hassle to knit a chapter within a {bookdown} repo, so you might want to do the bulk of the work outside the book repo.

### data

If you will be using data in your chapter, you can put it in your chapter folder temporarily. We will later move it to the {atsalibrary} package or {MARSS} package.


## Parts of the book repo
[back to top](#top)

There are many pieces to a bookdown book and this README covers all the pieces.  It also covers some markdown special to bookdown cross-references and some conventions to keep our chapters in the same format in [Notes on writing the rmarkdown files](#writing-the-rmarkdown-files).

Here is the quick start version.

* **Where are the Rmd files for my chapter?**  They are in the folders with prefix "chap". within that the chapter file is named `_chapter.Rmd`. That is your main chapter file. If you have children (called by your main chapter file) then put them in that folder too.
* **I cloned the whole repo. How do I build the book?** Use `targets::tar_make()`. 
* **How do I knit one chapter?** With {targets} ensuring that the book parts are not re-run unnecessarily, you should be able to run `tar_make()` quickly. 

    {bookdown} makes it a real hassle to work on one chapter because the knit button in RStudio won't work. But another way to do one chapter. But if you want to knit your chapter as you work on it, you have two options.
    
    Create a separate project and work there with just your chapter.
    
    Or do the following in the book repo:
    * Set your working directory to be your folder like 'chapters/chap01-rw'
    * Edit your Rmd, named `_chapter.Rmd`
    * Type `rmarkdown::render("_chapter.Rmd", output_format="html_document")`
    * Open the html file.
    * knit will put the html files in your folder and you'll need to clean up later.  The mathdefs won't be replaced and you won't have a bibliography.  If that bugs you, put this yaml at the top of your Rmd
    ```
    ---
    output: 
      html_document:
        includes:
          before_body: [../tex/bracket-start.txt, ../tex/defs.tex, ../tex/bracket-end.txt]
    bibliography: ../tex/Fish507.bib
    ---
    ```
    If you want to leave it there then you'll need to make a tex folder in your chapter directory and copy mathdef.tex and Fish507.bib there.  Then get rid of the '../' in the file paths above.  The reason is that bookdown will detect this yaml and it is working from a directory above.  It won't find '../tex/'.
    
* **How do I cite literature?**  The Fish507.bib file is in the folder "tex". Add bib citations there but search to make sure it is not already there.  "template.Rmd" has examples of citations.
* **Don't make changes to the docs folder.** That's where bookdown puts the website files and your changes will get wiped out.

## Style sheet
[back to top](#top)

Use the style sheet to change the look of the book.  Change it in the top level.  Note, when bookdown builds the docs folder, it wipes out the folder, and copies stuff from the top-level into docs.  But if you are testing the style sheet, then make the change in docs.  Just make sure to copy over to the top-level or you'll lose the changes next time the book is built.

If you are having trouble with vertical spacing, then

* Make sure you have a blank line between your list elements.  Otherwise, the text won't be wrapped in <p> and it mucks with the spacing.

* Take a look at the style sheet and the spacing elements.  

## Writing the rmarkdown files
[back to top](#top)

### Code in text, package names and object names

Use ```foo``` (or ``foo``) for things you want in code font.  The following should be put font: anything you would see in the R console.  Typically, this is code snippets or references to an output value, like ```foo```.  But also use it for anything that you would see in the console.  So if you want to tell the reader what the residual variance is in the ``lm()`` summary output, use ``sigma2``.

functions: The function ```lm()``` is used for linear regression.  Put ``()`` after functions.

Packages: Put in bold face.  **stats** package.

Object names: Put in bold face.  This is a **ts** object.

### Code output in text

If you want the output of code, then decide if you want that output in code font or not.  ```r 1+1``` and ``r 1+1`` will put 2 in code font. `r 1+1` will put 2 in the font of the text.

### Math shortcuts

You can use the shortcuts in tex/defs.tex.  These are things like \AA for ``\mathbf{A}``.  Note that for html, this is processed with mathJax.  For inline, mathJax looks a bit meh.  

We might think of only using \AA in equations and using ``**A**`` in text.  The downside is that it is easy for our text font to not match our font in our equations, which is determined by mathJax.

### Label chunks uniquely with a unique tag for your chapter

Label all your chunks uniquely and do NOT use "." or ":" in your chunk names. "-" is ok.  This is because bookdown will sometimes make filenames from this name and ":" and "." are illegal in filenames.
So ``foo-foo`` is ok and ``foo.foo`` is not

### Chapter and section labelling

Label chapters like with 'chap-' and a tag specific to that chapter

    # This is chapter foo {#chap-foo}

Label sections like with 'sec-' and a tag specific to that chapter

    # This is section foo {#sec-foo-this-section}

### Cross-references

The cross-references all take the form `\@ref(label)`.

Chapters and sections: 

{#sec-ts-CO2-data}  --> Section`\@ref(sec-ts-CO2-data)`

{#chap-ts}  --> Chapter `\@ref(chap-ts)` 

Figures and figures:  Bookdown builds the figure label from the chunk label.

```{r ts-fig-foo}plot(1)``` --> Figure \@ref{fig:ts-fig-foo}

```{r ts-table-foo}kable(1)``` --> Table \@ref{tab:ts-fig-foo}

If you don't use kable(), then read up on table cross-referencing
https://bookdown.org/yihui/bookdown/tables.html

Equations: You must use the form 'eq:label' so an equation reference in the text looks like `\@ref(eq:label)`

To have an equation number that you can reference you need to label the equation.  To do this, you must use the equation, align or gather environments.

```
\begin{equation}
1+1
(\#eq:one)
\end{equation}
```

### Figure captions

You can pass these in `fig.cap='This is my caption.'` but if your caption is long or contains rmarkdown (or latex), then use a text reference. Here is an example

    (ref:foo) This is a caption with **markdown**, ``code`` and some $\beta$ greek in latex. 

    ```{r foo, fig.cap='(ref:foo)'}
    plot(cars)  # a scatterplot
    ```

### R code you don't want put in the R scripts for users

`cleanDefsinRmd.R` will make R code files automatically from the Rmd files.  If you have chunks that you don't want in those files put `purl=FALSE` in the header.  So
```{r foo, purl=FALSE}
```

### Lists notes

Use indenting to make sure the paragraphs in your lists (esp. in the Problems sections) all line up.
```
1. Level 1
   
    Paragraph in Level 1
        
    a. another list within level 1
    b. another list within level 1
````
Use a blank space between your lists.  The html is different and your list spacing will vary if you are not consistent.  The html for this
```
* foo1
* foo2
```
Is different than
```
* foo1

* foo2
```

### Citations

The bib file is Fish507.bib in the tex folder.

``[@Lamonetal1998; @ScheuerellWilliams2005]`` gets you (Lamon et al. 1998; Scheuerell and Williams 2006).

``@Lamonetal1998`` gets Lamon et al. (1998)


## Special conventions
[back to top](#top)

Look at the other Rmd files and follow the conventions for the first page.  These have

* A link to the R code for the chapter in docs/Rcode folder.
* A section about the packages and data.  If short, this can be on page 1 of chapter.  If long, a separate section.
* Data should be put in the **atsalibrary** package and loaded from there.

At the top of the Rmd files, add a hidden chunk that sets the tag if you forget to label a chunk.  You cannot duplicate chunk names across all Rmd files, so the tag makes sure that doesn't happen.

    ```{r dfa-setup, include=FALSE, purl=FALSE}
    #in case you forget to add a chunk label
    knitr::opts_knit$set(unnamed.chunk.label = "dfa-")
    ```
## Required packages
[back to top](#top)

* knitr, bookdown, formatR, targets, tarchetypes
* rjags, r2jags, coda, and install JAGS
* rstan
* forecast
* MARSS

## Build the book
[back to top](#top)

```
tar_make()
```

## Build a chapter
[back to top](#top)

If you are adding a chapter, then you will need to [re-build the whole book](#build-the-book) to get the index.html file updated.  But work on your chapter on its own until it is done.  Just knit the Rmd as described in [Getting started with editing your chapter](#getting-started) and when you are ready, build the whole book.

**Making big changes to your chapter?** Then edit your Rmd in your chapter folder.  Knit that Rmd until you are ready. Once that is ready, [re-build the whole book](#build-the-book).

**Making really minor changes?** Then edit your Rmd in your ``Lab-`` folder AND make the same edits to the html in the docs folder.  No need to knit anything.  You are changing the Rmd so that your changes are not wiped out when the whole book is rebuilt later.


## Key files
[back to top](#top)

* index.Rmd: First page.  Yaml metadata for the book is at the top of file
* _output.yml output yaml is here
* _bookdown.yml has what Rmd to put in the book.  rmd_subdir: TRUE means to allow search across chapters
* style.css is the css file for the book.  Sets things like font and code block style.
* NOT USED DESCRIPTION RStudio uses this to detect that this is a bookdown book.  
* functions.R Functions needed by {targets}
* chapterfactory.R This creates the needed targets for each chapter.
This is the script to populate the cleanedRmd folder with the Rmd files used in _bookdown.yml.  It replaces the mathdefs (like \AA), tangles the R code from the Rmd and puts in docs/Rcode.
* `_targets.R` This defines the {targets} dependencies. It's kind of painful but you should have to do much to it.

## Directories
[back to top](#top)

Most of these you will see on GitHub.  A couple directories are only for your local machine.

### docs

This is where bookdown puts the html files.  It also has an Rcode folders. 

### individual chapter folders

This is were your Rmd files for the chapter are kept.  {targets} will watch the chapter files (including if you use children) and will re-render the chapter as needed. It will put the rendered Rmd into `rendered-chapters`. That allows the book to re-build quickly. The chapters are only re-rendered when they change (or a child changes).

### images

This has cover image though not used anywhere (yet).

### tex

This has tex files used for the PDF production.

### figure

These are the figures from the rendered chapters. You need this to build the book.

### _bookdown_files and cache (local machine only)

bookdown populates this.  It has the cache.  You don't want this on GitHub. Because {targets} is rendering the chapters separately, the `_bookdown_files` folder should never appear. Instead `cache` will appear. 

### libs (local machine only)

To build the book on your local machine, you'll install the bookdown package and build as described in [build the book](#build).  bookdown will create the libs folder in your project with jquery and gitbook folders.

## gitignore file
[back to top](#afts-labbook-info)

I have many files in my local repository that don't need to be on GitHub.  If a book build fails, the clean up fails so you will have a lot of extra directories and files in your base directory.  Normally, if build does not fail, bookdown moves this to the docs folder.  The `#Misc` stuff is stuff I am working on and have not been cleaned up yet.

Here is what my .gitignore looks like

```
#RProj files
.Rproj.user/
*.Rproj
cache/
MARMES_files/
MARMES.Rmd
MARMES.tex
MARMES.pdf
MARMES.log
MARMES.toc
libs
_bookdown_files

#Misc
marss-jags.txt

# Windows image file caches
Thumbs.db
ehthumbs.db

# Folder config file
Desktop.ini

# Recycle Bin used on file shares
$RECYCLE.BIN/

# Windows Installer files
*.cab
*.msi
*.msm
*.msp

# Windows shortcuts
*.lnk

# =========================
# Operating System Files
# =========================

# OSX
# =========================

.DS_Store
.AppleDouble
.LSOverride

# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk
```
