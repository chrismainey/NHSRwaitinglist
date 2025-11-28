#' @title A simple operation scheduler
#'
#' @description Takes a list of dates and schedules them to a waiting list,
#' by adding a removal date to the data.frame.
#' This is done in referral date order,
#' I.e. earlier referrals are scheduled first (FIFO).
#'
#' @param waiting_list data.frame. A df of referral dates and removals
#' @param schedule Date or character vector. Should be formatted as
#'   year-month-date, e.g. "2024-04-01".  The dates to schedule open referrals
#'   into (i.e. dates of unbooked future capacity)
#' @param referral_index The column index in the waiting_list which contains the
#'   referral dates
#' @param removal_index The column index in the waiting_list which contains the
#'   removal dates
#' @param unscheduled logical.
#'  If TRUE, returns a list of scheduled and unscheduled procedures
#'  If FALSE, only returns the updated waiting list
#' @param restore_types  Internal function to restore types exactly to previous
#' version in testing
#'
#' @return The updated waiting list with removal dates assigned based on
#'   the given schedule, either as a single \code{data.frame} (default) or as
#'   part of a list (if \code{unscheduled = TRUE}).
#'
#' If \code{unscheduled = TRUE}, returns a \code{list} with two data frames:
#' 1. A \code{data.frame}. The updated waiting list with scheduled removals.
#'
#' 2. A \code{data.frame} showing which slots were used, with columns:
#'
#'    \describe{
#'      \item{schedule}{Date. The available dates from the input
#'        \code{schedule}.}
#'      \item{scheduled}{Numeric. \code{1} if the slot was used to schedule a
#'        patient, \code{0} if not.}
#'    }
#'
#' @import data.table
#'
#' @export
#'
#'
#' @examples
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals)
#' schedule <- c.Date("2024-01-03", "2024-01-05", "2024-01-18")
#' updated_waiting_list <- wl_schedule(waiting_list, schedule)
#'
wl_schedule <- function(
  waiting_list,
  schedule,
  referral_index = 1,
  removal_index = 2,
  unscheduled = FALSE,
  restore_types = TRUE
) {

  # Error handle
  check_wl(waiting_list, referral_index, removal_index)
  check_date(schedule)
  check_class(unscheduled, .expected_class = "logical")

  if (!inherits(schedule, "Date")) {
    schedule <- as.Date(schedule)
  }

  # Precompute column names
  referral_col <- names(waiting_list)[referral_index]
  removal_col  <- names(waiting_list)[removal_index]

  # Split waiters and removed
  wl <- waiting_list[is.na(waiting_list[[removal_col]]), ]
  wl_removed <- waiting_list[!is.na(waiting_list[[removal_col]]), ]
  rownames(wl) <- NULL

  if (!unscheduled) {
    # Local copies for faster in-loop access
    ref <- wl[[referral_col]]
    rem <- wl[[removal_col]]
    n_wl <- length(ref)

    i <- 1L
    for (op in schedule) {
      if (op > ref[i] & i <= n_wl) {
        rem[i] <- op
        i <- i + 1L
      }
    }

    # Only convert if needed
    if (!inherits(rem, "Date")) rem <- as.Date(rem)
    wl[[removal_col]] <- rem

    # Fast combine + sort
    library(data.table)
    updated_dt <- rbindlist(list(as.data.table(wl_removed)
                                 , as.data.table(wl)), use.names = TRUE)
    setorderv(updated_dt, referral_col)

    updated_df <- as.data.frame(updated_dt, stringsAsFactors = FALSE)
    rownames(updated_df) <- seq_len(nrow(updated_df))

    # Optional strict type restoration
    if (restore_types) {
      for (col in seq_along(updated_df)) {
        if (is.factor(waiting_list[[col]])) {
          updated_df[[col]] <- factor(updated_df[[col]]
                                      , levels = levels(waiting_list[[col]]))
        } else {
          class(updated_df[[col]]) <- class(waiting_list[[col]])
        }
      }
    }

    return(updated_df)

  } else {
    scheduled <- data.frame(schedule = schedule
                            , scheduled = integer(length(schedule)))

    ref <- wl[[referral_col]]
    rem <- wl[[removal_col]]
    n_wl <- length(ref)

    i <- 1L
    j <- 0L
    for (op in schedule) {
      j <- j + 1L
      if (op > ref[i] & i <= n_wl) {
        rem[i] <- op
        i <- i + 1L
        scheduled[j, 2] <- 1L
      }
    }

    if (!inherits(rem, "Date")) rem <- as.Date(rem)
    wl[[removal_col]] <- rem

    updated_dt <- rbindlist(list(as.data.table(wl_removed), as.data.table(wl))
                            , use.names = TRUE)
    setorderv(updated_dt, referral_col)

    updated_df <- as.data.frame(updated_dt, stringsAsFactors = FALSE)
    rownames(updated_df) <- seq_len(nrow(updated_df))

    if (restore_types) {
      for (col in seq_along(updated_df)) {
        if (is.factor(waiting_list[[col]])) {
          updated_df[[col]] <- factor(updated_df[[col]]
                                      , levels = levels(waiting_list[[col]]))
        } else {
          class(updated_df[[col]]) <- class(waiting_list[[col]])
        }
      }
    }

    return(list(updated_df, scheduled))
  }
}
