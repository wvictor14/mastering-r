install.packages(c('dplyr', 'ggplot2'))
library(dplyr)
library(ggplot2)
library(rlang)
df <- datasets::Titanic |>  as_tibble()

plotTitanic <- function(.data, facet_row = NULL, facet_col = NULL) {
  ggplot(df, aes(x = n)) +
    geom_density() +
    facet_grid(
      cols = vars(!!!facet_col),
      rows = vars(!!!facet_row)
    )
}

# no facets
plotTitanic(df)

# facet_row by 1 variable
plotTitanic(df, facet_row = vars(Class))


# allows facet_col take multiple variables
plotTitanic(df, facet_col = vars(Class, Sex))
plotTitanic(df, facet_col = vars(Class))

# string input
plotTitanic(df, facet_col = vars(!!sym('Class'))) # correct

# symbolized string input
Class_obj <- 'Class'
plotTitanic(df, facet_col = vars(!!ensym(Class_obj)))
plotTitanic(df, facet_col = vars(!!Class_obj)) # why is this incorrect



# why is this incorrect
plotTitanic(df, facet_col = vars(sym('Class')))

# why is this incorrect
plotTitanic(df, facet_col = vars(enquo('Class')))


plotTitanic(df)

ggplot(df, aes(x = n)) +
  geom_density() +
  facet_grid(
    cols = vars(Class, Sex),
  )
