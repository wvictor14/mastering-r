    library(rlang)
    library(purrr)

    ## 
    ## Attaching package: 'purrr'

    ## The following objects are masked from 'package:rlang':
    ## 
    ##     %@%, flatten, flatten_chr, flatten_dbl, flatten_int, flatten_lgl,
    ##     flatten_raw, invoke, splice

# 19.2 cement

    cement <- function(...) {
      args <- ensyms(...)
      paste(purrr::map(args, as_string), collapse = " ")
    }

    cement(Good, morning, Hadley)

    ## [1] "Good morning Hadley"

    #> [1] "Good morning Hadley"
    cement(Good, afternoon, Alice)

    ## [1] "Good afternoon Alice"

    #> [1] "Good afternoon Alice"

This function `cement` quotes all of it’s inputs, and then converts them
to strings.

but it won’t work when we want to use variables

    name <- "Hadley"
    time <- "morning"

    paste("Good", time, name)

    ## [1] "Good morning Hadley"

    #> [1] "Good morning Hadley"

For that we need to use the unquote operator !!:

    cement(Good, !!time, !!name)

    ## [1] "Good morning Hadley"

It makes it so the time and name variables are evaluated before
“entering” the function

# 19.3 quoting
