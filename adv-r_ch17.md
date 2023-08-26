# 17.2

    library(rlang)
    library(lobstr)

`expr()` captures whatever you write

    expr(mean(x, na.rm = TRUE))

    ## mean(x, na.rm = TRUE)

    expr(10 + 100 + 1000)

    ## 10 + 100 + 1000

But it doesn’t work if you use it in a function

    capture_it <- function(x) {
      expr(x)
    }
    capture_it(a + b + c)

    ## x

captures “x”, not “a + b + c”, what the user supplied

for that, we use `enexpr()`

    capture_it <- function(x) {
      enexpr(x)
    }
    capture_it(a + b + c)

    ## a + b + c

the `en` means “enrich”. This is the “lazy-evaluated” form of expr.
“Lazy” because it “waits” until it needs to be evaluated, rather than
immediately after being defined (previous example).

New terminology: `enexpr` “quotes” it’s argument

Expressions are like lists

    f <- expr(f(x = 1, y = 2))
    f

    ## f(x = 1, y = 2)

    # Add a new argument
    f$z <- 3
    f

    ## f(x = 1, y = 2, z = 3)

    # Or remove an argument:
    f[[2]] <- NULL
    f

    ## f(y = 2, z = 3)

first element of an expression (or “call”) is the function itself.

# 17.3 Call = tree

Code is almost always represented as an abstract syntax tree (AST)

`lobstr::ast()` displays the AST of an expression

    lobstr::ast(f(a, "b"))

    ## █─f 
    ## ├─a 
    ## └─"b"

`a` is a symbol `"b"` is a constant (string)

    lobstr::ast(f1(f2(a, b), f3(1, f4(2))))

    ## █─f1 
    ## ├─█─f2 
    ## │ ├─a 
    ## │ └─b 
    ## └─█─f3 
    ##   ├─1 
    ##   └─█─f4 
    ##     └─2

# 17.4 code generates code

e.g. `rlang::call2` generates a function call from it’s arguments:

    call2("f", 1, 2, 3)

    ## f(1, 2, 3)

    call2("+", 1, call2("*", 2, 3))

    ## 1 + 2 * 3

alternatively, bang bang (aka unquote) operator can construct function
calls too:

    xx <- expr(x + x)
    yy <- expr(y + y)

    expr(!!xx / !!yy)

    ## (x + x)/(y + y)

This allows defining functions that can construct functions based on
user input

    cv <- function(var) {
      var <- enexpr(var) # quote user expression
      expr(sd(!!var) / mean(!!var)) # insert into expression
    }

    cv(x)

    ## sd(x)/mean(x)

    cv(x + y)

    ## sd(x + y)/mean(x + y)

# 17.5 eval runs code

`base::eval()` takes an expression and an environment and evaluates

    eval(expr(x + y), env(x = 1, y = 10))

    ## [1] 11

    eval(expr(x + y), env(x = 2, y = 100))

    ## [1] 102

if env omitted, takes global env

    x <- 10
    y <- 100
    eval(expr(x + y))

    ## [1] 110

# 17.6 customize expressions with functions

environmental varibales can be functions

here, operators are overwritten

    string_math <- function(x) {
      e <- env(
        caller_env(),
        `+` = function(x, y) paste0(x, y),
        `*` = function(x, y) strrep(x, y)
      )

      eval(enexpr(x), e)
    }

    name <- "Hadley"
    string_math("Hello " + name)

    ## [1] "Hello Hadley"

    string_math(("x" * 2 + "-y") * 3)

    ## [1] "xx-yxx-yxx-y"

# 17.7 customize expressions with data

eval\_tidy = base::eval

except eval\_tidy uses dataframe as datamask (environment) - where
variables are columns

    df <- data.frame(x = 1:5, y = sample(5))
    eval_tidy(expr(x + y), df)

    ## [1] 6 5 4 6 9

with `enexpr` to use in a function:

    with2 <- function(df, expr) {
      eval_tidy(enexpr(expr), df)
    }

    with2(df, x + y)

    ## [1] 6 5 4 6 9

# 17.8 quosures

address this problem

    with2 <- function(df, expr) {
      a <- 1000
      eval_tidy(enexpr(expr), df)
    }
    df <- data.frame(x = 1:3)
    a <- 10
    with2(df, x + a)

    ## [1] 1001 1002 1003

We want `with2`to evaluate using a defined in global (a=1000) not within
with2 definition (a=10).

for this we can use a quosure, which bundles an expression with an
environment

    with2 <- function(df, expr) {
      a <- 1000
      eval_tidy(enquo(expr), df)
    }

    with2(df, x + a)

    ## [1] 11 12 13

Where the environment is global and the expression is global

So for a datamask, always use enquo instead of enexpr
