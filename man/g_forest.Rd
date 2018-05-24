% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/g_forest.R
\name{g_forest}
\alias{g_forest}
\title{Create a Forest Plot based on a Table}
\usage{
g_forest(tbl, col_x, col_ci, vline = NULL, forest_header = NULL,
  xlim = NULL, logx = FALSE, x_at = NULL, width_row.names = NULL,
  width_columns = NULL, width_forest = unit(1, "null"), draw = TRUE,
  newpage = TRUE)
}
\arguments{
\item{tbl}{an rtable object}

\item{col_x}{column index with estimator}

\item{col_ci}{column index with confidence intervals}

\item{vline}{x coordinate for vertical line, if \code{NULL} then the line is
omitted}

\item{forest_header}{character vector of length 2, diplayed to the left and
right of \code{vline}, respectively. If \code{vline=NULL} then
\code{forest_header} needs to be \code{NULL} too}

\item{xlim}{x limits for x-scales}

\item{logx}{boolean for showing x-values on logrithm scale}

\item{x_at}{numeric vector with x tick locations, if \code{NULL} they get
automatically chosen}

\item{width_row.names}{\code{\link[grid]{unit}} object with width for row
names. If \code{NULL} the widths get automatically calculated.}

\item{width_columns}{\code{\link[grid]{unit}} object with widths for the
table columns. If \code{NULL} the widths get automatically calculated.}

\item{width_forest}{\code{\link[grid]{unit}} object with width for the forest
column. If \code{NULL} the widths get automatically calculated.}

\item{draw}{boolean, should plot be drawn}

\item{newpage}{boolean if \code{draw=TRUE} should plot be drawn on a new page}
}
\description{
Create a forest plot from any \code{\link[rtables]{rtable}} object that has a
column with a single value and a column with 2 values
}
\examples{

library(random.cdisc.data)

ASL <- radam("ASL")
ASL$RACE <- factor(sapply(as.character(ASL$RACE), function(x) {
 if (nchar(x)>9) paste0(substr(x, 1,9), "...") else x
}))
ATE <- radam("ATE", ADSL = ASL)

ATE_f <- subset(ATE, PARAMCD == "OS") 

ANL <- merge(ASL, ATE_f)

tbl <- t_forest_tte(
  tte = ANL$AVAL,
  is_event = ANL$CNSR == 0,
  col_by = factor(ANL$ARM), 
  group_data = as.data.frame(lapply(ANL[, c("SEX", "RACE")], as.factor))
)

## note plot requires a certain width
g_forest(
  tbl = tbl,
  col_x = 8,
  col_ci = 9,
  vline = 1,
  forest_header = c("Treatement\\nBetter", "Comparison\\nBetter"),
  xlim = c(.1, 10),
  logx = TRUE,
  x_at = c(.1, 1, 10)
)

# For response table

ASL <- radam("ASL")
ARS <- radam("ARS", ADSL = ASL)

ARS_f <- subset(ARS, PARAMCD == "OVRSPI")
ANL <- merge(ASL, ARS_f)

tbl <- t_forest_rsp(
  rsp = ANL$AVALC \%in\% c("CR", "PR"),
  col_by = ANL$ARM, 
  group_data = ANL[, c("SEX", "RACE")]
)

tbl

g_forest(
  tbl = tbl,
  col_x = 8,
  col_ci = 9,
  vline = 1,
  forest_header = c("Comparison\\nBetter", "Treatement\\nBetter"),
  xlim = c(.1, 10),
  logx = TRUE,
  x_at = c(.1, 1, 10)
)



# Works with any rtable

tbl <- rtable(
  header = c("E", "CI"),
  rrow("", 1, c(.8, 1.2)),
  rrow("", 1.2, c(1.1, 1.4))
)

g_forest(
  tbl = tbl,
  col_x = 1,
  col_ci = 2
)

tbl <- rtable(
  header = rheader(
    rrow("", rcell("A", colspan = 2)),
    rrow("", "c1", "c2")
  ),
  rrow("row 1", 1, c(.8, 1.2)),
  rrow("row 2", 1.2, c(1.1, 1.4))
)

g_forest(
  tbl = tbl,
  col_x = 1,
  col_ci = 2,
  vline = 1,
  forest_header = c("Hello", "World")
)



}
\author{
Adrian Waddell (waddella) \email{adrian.waddell@roche.com}
}