# Object-oriented Programming

OOP

polymorphism -&gt; many shapes developer can modify interface separately
from its implementation

meaning does not need to be original author to extend functionality

class -&gt; is the type of object method -&gt; implementation of a
specific object class

class specifies what an object is, method specifies what can do with
object

Classes exist in hierarchy -&gt; child classes inherit methods of parent
classes method dispatch - process of finding correct method

Encapsulation -&gt; object is behind a standard interface so use doesn’t
need to worry about details of an object

**encapsulated** OOP -&gt; `object.method(arg1, arg2)` **functional
OOP** -&gt; `generic(object, arg1, arg2)`

encapsulated OOP is more common outside of R, but in R functional is
more common

RC -&gt; reference class, R6 in R is closest to RC

    library(sloop)

    otype(1:10)

    ## [1] "base"

    otype(mtcars)

    ## [1] "S3"

    mle_obj <- stats4::mle(function(x = 1) (x - 2) ^ 2)
    otype(mle_obj)

    ## [1] "S4"

base object vs OO object base doesn’t have a class attr

    attr(1:10, 'class')

    ## NULL

    attr(mtcars, 'class')

    ## [1] "data.frame"

base type -&gt; every object has one

base types in R:

-   vectors
-   functions: closure, special, builtin
-   environment
-   s4
-   language components

typeof to return base type

    typeof(1:10)

    ## [1] "integer"

    typeof(seq)

    ## [1] "closure"

Ch 13

s3 object behaves differently from its underlying base type if it’s
based a generic generic -&gt; short for generic function

sloop::ftype to determine if a function is a generic

    sloop::ftype(print)

    ## [1] "S3"      "generic"

generic defines an interface, that behaves differently depending on the
class of an argument (typically first argument)

    f <- factor(c("a", "b", "c"))
    print(f)

    ## [1] a b c
    ## Levels: a b c

    print(unclass(f)) #printing is diffeerent when stripped of class attribute

    ## [1] 1 2 3
    ## attr(,"levels")
    ## [1] "a" "b" "c"

    time <- strptime(c("2017-01-01", "2020-05-04 03:21"), "%Y-%m-%d")
    str(time)

    ##  POSIXlt[1:2], format: "2017-01-01" "2020-05-04"

    str(unclass(time))

    ## List of 11
    ##  $ sec   : num [1:2] 0 0
    ##  $ min   : int [1:2] 0 0
    ##  $ hour  : int [1:2] 0 0
    ##  $ mday  : int [1:2] 1 4
    ##  $ mon   : int [1:2] 0 4
    ##  $ year  : int [1:2] 117 120
    ##  $ wday  : int [1:2] 0 1
    ##  $ yday  : int [1:2] 0 124
    ##  $ isdst : int [1:2] 0 1
    ##  $ zone  : chr [1:2] "PST" "PDT"
    ##  $ gmtoff: int [1:2] NA NA
    ##  - attr(*, "tzone")= chr [1:3] "" "PST" "PDT"
    ##  - attr(*, "balanced")= logi TRUE

generic is a middleman, defining the interface that a user interacts,
it’s job is to find the right implementation for the job (method
dispatch)

s3 methods have special naming scheme: `generic.class()`,
`print.factor()` You never call method directly, but rely on the generic
to find it for you

s3 methods are not exported, therefore you cannot print their code by
typing their name. but you can use sloop::s3\_get\_method - except some
base R function, and ones you define

# 13.2.1 Exercises

1.  Describe the difference between t.test() and t.data.frame(). When is
    each function called?

t.test() is a function t.data.frame() is a method of the function t()
for objects of class data.frame. It is called whenever t() is called on
a data.frame object.

1.  Make a list of commonly used base R functions that contain . in
    their name but are not S3 methods.

cor.test t.test as.numeric data.frame

    s3_get_method(data.frame)

1.  What does the as.data.frame.data.frame() method do? Why is it
    confusing? How could you avoid this confusion in your own code?

it’s confusing because `.` is in the class name as well as method name

avoid it but avoiding `.` in class and function names

1.  Describe the difference in behaviour in these two calls.

<!-- -->

    set.seed(1014)
    some_days <- as.Date("2017-01-31") + sample(10, 5)

    mean(some_days) #a

    ## [1] "2017-02-06"

    #> [1] "2017-02-06"
    mean(unclass(some_days)) #b

    ## [1] 17203.4

    #> [1] 17203

1.  returns a Date object, which is built on numeric/double
2.  returns a numeric base objec

<!-- -->

1.  What class of object does the following code return? What base type
    is it built on? What attributes does it use?

<!-- -->

    x <- ecdf(rpois(100, 10))
    x

    ## Empirical CDF 
    ## Call: ecdf(rpois(100, 10))
    ##  x[1:18] =      2,      3,      4,  ...,     18,     19

    class(x)

    ## [1] "ecdf"     "stepfun"  "function"

    attributes(x)

    ## $class
    ## [1] "ecdf"     "stepfun"  "function"
    ## 
    ## $call
    ## ecdf(rpois(100, 10))

    typeof(x)

    ## [1] "closure"

    #> Empirical CDF 
    #> Call: ecdf(rpois(100, 10))
    #>  x[1:18] =  2,  3,  4,  ..., 2e+01, 2e+01

It is built on base type “function” It uses “class” and “call”
attributes

1.  What class of object does the following code return? What base type
    is it built on? What attributes does it use?

<!-- -->

    x <- table(rpois(100, 5))
    x

    ## 
    ##  1  2  3  4  5  6  7  8  9 10 
    ##  7  5 18 14 15 15 14  4  5  3

    #> 
    #>  1  2  3  4  5  6  7  8  9 10 
    #>  7  5 18 14 15 15 14  4  5  3

    class(x)

    ## [1] "table"

    attributes(x)

    ## $dim
    ## [1] 10
    ## 
    ## $dimnames
    ## $dimnames[[1]]
    ##  [1] "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"  "10"
    ## 
    ## 
    ## $class
    ## [1] "table"

    typeof(x)

    ## [1] "integer"

It returns table class object, built on integer/numeric, and it uses the
following attributes: dim, dimnames, and class

# 13.2 Classes

R has no formal definition of s3 class

Can make a class on definition

To determine class use `class` To determine if object has a specific
class use `inherits(x, 'classname')`

You can change class of existing object

Hadley’s advice when creating new classes:

-   A low-level constructor, new\_myclass(), that efficiently creates
    new objects with the correct structure.

-   A validator, validate\_myclass(), that performs more computationally
    expensive checks to ensure that the object has correct values.

-   A user-friendly helper, myclass(), that provides a convenient way
    for others to create objects of your class.

# 13.4 Generics and methods

Job of an s3 generic is to do method dispatch, find the correct method
for a given object based on class of that object

Every generic calls `UseMethod()` to perform method dispatch

    x <- 1:3
    s3_dispatch(print(x))

    ##    print.integer
    ##    print.numeric
    ## => print.default

    x <- matrix(1:10, nrow = 2)
    s3_dispatch(mean(x))

    ##    mean.matrix
    ##    mean.integer
    ##    mean.numeric
    ## => mean.default

s3\_dispatch displays which methods were used for a call

to get al lmethods for a given generic:

    s3_methods_generic("mean")

    ## # A tibble: 7 × 4
    ##   generic class      visible source             
    ##   <chr>   <chr>      <lgl>   <chr>              
    ## 1 mean    Date       TRUE    base               
    ## 2 mean    default    TRUE    base               
    ## 3 mean    difftime   TRUE    base               
    ## 4 mean    POSIXct    TRUE    base               
    ## 5 mean    POSIXlt    TRUE    base               
    ## 6 mean    quosure    FALSE   registered S3method
    ## 7 mean    vctrs_vctr FALSE   registered S3method

    #> # A tibble: 7 x 4
    #>   generic class      visible source             
    #>   <chr>   <chr>      <lgl>   <chr>              
    #> 1 mean    Date       TRUE    base               
    #> 2 mean    default    TRUE    base               
    #> 3 mean    difftime   TRUE    base               
    #> 4 mean    POSIXct    TRUE    base               
    #> 5 mean    POSIXlt    TRUE    base               
    #> 6 mean    quosure    FALSE   registered S3method
    #> 7 mean    vctrs_vctr FALSE   registered S3method

    s3_methods_class("ordered")

    ## # A tibble: 4 × 4
    ##   generic       class   visible source             
    ##   <chr>         <chr>   <lgl>   <chr>              
    ## 1 as.data.frame ordered TRUE    base               
    ## 2 Ops           ordered TRUE    base               
    ## 3 relevel       ordered FALSE   registered S3method
    ## 4 Summary       ordered TRUE    base

    #> # A tibble: 4 x 4
    #>   generic       class   visible source             
    #>   <chr>         <chr>   <lgl>   <chr>              
    #> 1 as.data.frame ordered TRUE    base               
    #> 2 Ops           ordered TRUE    base               
    #> 3 relevel       ordered FALSE   registered S3method
    #> 4 Summary       ordered TRUE    base
    #> 

    s3_methods_generic('print')  |>  head()

    ## # A tibble: 6 × 4
    ##   generic class             visible source             
    ##   <chr>   <chr>             <lgl>   <chr>              
    ## 1 print   acf               FALSE   registered S3method
    ## 2 print   activeConcordance FALSE   registered S3method
    ## 3 print   AES               FALSE   registered S3method
    ## 4 print   anova             FALSE   registered S3method
    ## 5 print   aov               FALSE   registered S3method
    ## 6 print   aovlist           FALSE   registered S3method

Two advices from Hadley:

1.  First, you should only ever write a method if you own the generic or
    the class. R will allow you to define a method even if you don’t,
    but it is exceedingly bad manners. Instead, work with the author of
    either the generic or the class to add the method in their code.

2.  A method must have the same arguments as its generic. This is
    enforced in packages by R CMD check, but it’s good practice even if
    you’re not creating a package.

There is one exception to this rule: if the generic has …, the method
can contain a superset of the arguments. This allows methods to take
arbitrary additional arguments. The downside of using …, however, is
that any misspelled arguments will be silently swallowed72, as mentioned
in Section 6.6.

    s3_methods_class('table')

    ## # A tibble: 10 × 4
    ##    generic       class visible source             
    ##    <chr>         <chr> <lgl>   <chr>              
    ##  1 [             table TRUE    base               
    ##  2 aperm         table TRUE    base               
    ##  3 as.data.frame table TRUE    base               
    ##  4 Axis          table FALSE   registered S3method
    ##  5 lines         table FALSE   registered S3method
    ##  6 plot          table FALSE   registered S3method
    ##  7 points        table FALSE   registered S3method
    ##  8 print         table TRUE    base               
    ##  9 summary       table TRUE    base               
    ## 10 tail          table FALSE   registered S3method

# inheritence

classes can be a character vector, meaning objects can have multiple
classes

how do we determine which method to use then?

method dispatch goes through methods one by one

classes can share behaviour through inheritence

method can delegate work by calling `NextMethod`

If class A appears before class B subclass -&gt; class A super class
-&gt; class b

S3 imposes no restrictions on the relationship between sub- and
superclasses but your life will be easier if you impose some. I
recommend that you adhere to two simple principles when creating a
subclass:

The base type of the subclass should be that same as the superclass.

The attributes of the subclass should be a superset of the attributes of
the superclass.
