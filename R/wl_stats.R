#' @title Calculate some stats about the waiting list
#'
#' @description A summary of all the key stats associated with a waiting list
#'
#' @param waiting_list data.frame. A df of referral dates and removals
#' @param target_wait numeric. The required waiting time
#' @param start_date date. The start date to calculate from
#' @param end_date date. The end date to calculate to
#'
#' @return data.frame. A df of important waiting list statistics
#'
#' @export
#'
#'
#' @examples
#'
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals)
#' waiting_list_stats <- wl_stats(waiting_list)
#'
wl_stats <- function(waiting_list,
                     target_wait = 4,
                     start_date = NULL,
                     end_date = NULL) {

  # Error handle
  if (!methods::is(waiting_list, "data.frame")) {
    stop("waiting list should be supplied as a data.frame")
  }


  if (nrow(waiting_list) == 0) {
    stop("No data rows in waiting list")
  }

  if (missing(waiting_list)) {
    stop("No waiting list supplied")
  }


  # get indices and set target wait if possible and get dates
  referral_index <- calc_index(waiting_list, type = "referral")
  removal_index <- calc_index(waiting_list, type = "removal")

  if (!is.null(start_date)) {
    start_date <- as.Date(start_date)
  } else {
    start_date <- min(waiting_list[, referral_index])
  }
  if (!is.null(end_date)) {
    end_date <- as.Date(end_date)
  } else {
    end_date <- max(waiting_list[, referral_index])
  }


  referral_stats <- wl_referral_stats(
    waiting_list,
    start_date,
    end_date,
    referral_index
  )
  queue_sizes <- wl_queue_size(
    waiting_list,
    start_date,
    end_date,
    referral_index,
    removal_index
  )
  removal_stats <- wl_removal_stats(
    waiting_list,
    start_date,
    end_date,
    referral_index,
    removal_index
  )

  # load
  q_load <-
    calc_queue_load(referral_stats$demand_weekly
                    , removal_stats$capacity_weekly)

  # load too big
  q_load_too_big <- (q_load >= 1.)

  # final queue_size
  q_size <- utils::tail(queue_sizes, n = 1)[, 2]

  # target queue size
  q_target <-
    calc_target_queue_size(referral_stats$demand_weekly, target_wait)

  # queue too big
  q_too_big <- (q_size > 2 * q_target)

  # mean wait
  waiting_patients <-
    waiting_list[which((waiting_list[, removal_index] >
                          end_date | is.na(waiting_list[, removal_index]) &
                          waiting_list[, referral_index] <= end_date)), ]
  wait_times <-
    as.numeric(end_date) - as.numeric(waiting_patients[, referral_index])
  mean_wait <- mean(wait_times)

  # target capacity
  if (!q_too_big) {
    target_cap <- calc_target_capacity(
      referral_stats$demand_weekly,
      target_wait,
      4,
      referral_stats$demand_cov,
      removal_stats$capacity_cov
    )
    # target_cap_weekly <- target_cap_daily * 7
  } else {
    target_cap <- NA
  }

  # relief capacity
  if (q_too_big) {
    relief_cap <-
      calc_relief_capacity(referral_stats$demand_weekly, q_size, q_target)
  } else {
    relief_cap <- NA
  }

  # pressure
  pressure <- calc_waiting_list_pressure(mean_wait, target_wait)

  waiting_stats <- data.frame(
    "mean_demand" = referral_stats$demand_weekly,
    "mean_capacity" = removal_stats$capacity_weekly,
    "load" = q_load,
    "load_too_big" = q_load_too_big,
    "count_demand" = referral_stats$demand_count,
    "queue_size" = q_size,
    "target_queue_size" = q_target,
    "queue_too_big" = q_too_big,
    "mean_wait" = mean_wait,
    "cv_arrival" = referral_stats$demand_cov,
    "cv_removal" = removal_stats$capacity_cov,
    "target_capacity" = target_cap,
    "relief_capacity" = relief_cap,
    "pressure" = pressure
  )

  return(waiting_stats)

}
