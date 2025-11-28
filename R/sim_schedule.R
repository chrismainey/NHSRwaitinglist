#' @title Generator a list of dates to schedule
#'
#' @description Generates a list if dates in a given range
#'
#' @param n_rows Number of rows/patients to generate
#' @param start_date Start date (needed to generate patient ages)
#' @param daily_capacity Number of patients per day
#'
#' @return A vector of \code{Date} values representing scheduled procedure
#'   dates. The length of the vector is equal to \code{n_rows}, and the dates
#'   are spaced according to the specified \code{daily_capacity}.
#'
#' @export sim_schedule
#'

sim_schedule <- function(
    n_rows = 10,
    start_date = NULL,
    daily_capacity = 1
) {
  if (is.null(start_date)) start_date <- Sys.Date()

  # Original logic: ceiling(seq(0, n_rows - 1, by = 1 / daily_capacity))
  # Vectorized equivalent:
  offsets <- ceiling(seq(0, n_rows - 1, by = 1 / daily_capacity))

  # Add offsets to start_date
  schedule <- start_date + offsets

  return(schedule)
}
