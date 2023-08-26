    library(rlang)
    library(lobstr)

# 18.2.4 exercises

AST to code:

    #> █─f 
    #> └─█─g 
    #>   └─█─h
    #> █─`+` 
    #> ├─█─`+` 
    #> │ ├─1 
    #> │ └─2 
    #> └─3
    #> █─`*` 
    #> ├─█─`(` 
    #> │ └─█─`+` 
    #> │   ├─x 
    #> │   └─y 
    #> └─z

    ast(
      f(g(h()))
    )

    ## █─f 
    ## └─█─g 
    ##   └─█─h

    ast(
      (1+2)+3
    )

    ## █─`+` 
    ## ├─█─`(` 
    ## │ └─█─`+` 
    ## │   ├─1 
    ## │   └─2 
    ## └─3

    ast(
      (x + y ) * z
    )

    ## █─`*` 
    ## ├─█─`(` 
    ## │ └─█─`+` 
    ## │   ├─x 
    ## │   └─y 
    ## └─z

# 18.3.2 symbols

create symbol

    expr(x) # raw

    ## x

    rlang::sym('x') # chr to symbol

    ## x

symbol to string

    as.character(expr(x))

    ## [1] "x"

    as_string(expr(x))

    ## [1] "x"

symbols cannot be vectorized but multiple can be stored in a list (with
`rlang::syms()`)

# 18.4 parsing and grammar

operator precedence for example: 1 + 2 \* 3 = (1 + 2) \* 3, or 1 + (2 \*
3)

! has very low operator precedence, allowing expressions such as

    lobstr::ast(!x %in% y)

    ## █─`!` 
    ## └─█─`%in%` 
    ##   ├─x 
    ##   └─y

associativity is when repeated usage of infix operator results in
ambiguity

is 1 + 2 + 3 = (1 + 2) + 3 or 1 + (2 + 3), they are equivalent in this
case

but for example, ggplot2 + layers are non-associative

e.g. geom\_smooth + geom\_point is not the same plot as geom\_point +
geom\_smooth

most operators are left-associative, operations are evaluaetd from left
to right

# 18.4.3 parsing and deparsing

`rlang::parse_expr` converts a string into an expression

    x1 <- "y <- x + 10"
    x1

    ## [1] "y <- x + 10"

    is.call(x1)

    ## [1] FALSE

    x2 <- rlang::parse_expr(x1)
    x2

    ## y <- x + 10

    is.call(x2)

    ## [1] TRUE

deparsing: expr -&gt; string

    z <- expr(y <- x + 10)
    expr_text(z)

    ## [1] "y <- x + 10"

# 18.5 AST with recursive functions

    expr_type <- function(x) {
      if (rlang::is_syntactic_literal(x)) {
        "constant"
      } else if (is.symbol(x)) {
        "symbol"
      } else if (is.call(x)) {
        "call"
      } else if (is.pairlist(x)) {
        "pairlist"
      } else {
        typeof(x)
      }
    }

    expr_type(expr("a"))

    ## [1] "constant"

    expr_type(expr(x))

    ## [1] "symbol"

    expr_type(expr(f(1, 2)))

    ## [1] "call"

    switch_expr <- function(x, ...) {
      switch(expr_type(x),
        ...,
        stop("Don't know how to handle type ", typeof(x), call. = FALSE)
      )
    }

    recurse_call <- function(x) {
      switch_expr(x,
        # Base cases
        symbol = ,
        constant = ,

        # Recursive cases
        call = ,
        pairlist =
      )
    }
