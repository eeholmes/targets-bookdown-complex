# Targets + Bookdown

This is an attempt to use {targets} with {bookdown} to track the status of chapter and not re-run chapters each time the book needs to be rebuilt. At the book level, the dependencies are super simple, just checks if the chapter Rmd has changed. But for a specific chapter, you can have a separate {targets} pipeline that might be much more complex. Someone more clever than I could figure out how to have the base book level `_targets` depend on the chapter level `_targets` so if a chapter dependency changed (within say `chapters/chap3/`), the base `_targets.R` would figure that out and re-run `chapters/chap3/chap3.rmd`.

Caching with {bookdown} often crashes it. Maybe this will work better.

Note this is pretty meh as it doesn't keep track of any dependencies within the chapters, just checks if the Rmd changed.


## To run the book

* Install the {targets} package and {bookdown}
* Type `tar_make()` at the command line.
* Look in the `_book` folder for the `index.html` file and open that.

## To add chapters

* The chapters are in the `chapters` folder. Add an Rmd there.
* Open the `_targets.R` file and add something like `target_factory(chap2)` but replace `chap2` with your file name.
* `chapters/chap3` shows and example where the chapter uses targets markdown to create a chapter specific pipeline. To run, set `chapters/chap3` as the working directory, open `chap3.Rmd` and knit. Then 

## Explanations

* `_targets.R` is setting up the targets objects so {targets} can keep track of when objects need to be updated (because a dependency changed)
* `R/chapterfactory.R` is a file I wrote to create the chapter dependencies and objects. Basically it just renders a chapter Rmd and put the rendered version (md) into the folder `rendered-chapters` folder.
* Use `tar_visnetworks()` to visualize the network and status.

