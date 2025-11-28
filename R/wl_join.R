#' @title Join two waiting list
#'
#' @description Take two waiting list and sorting in date order

#'
#' @param wl_1 a waiting list: dataframe consisting addition and removal dates
#' @param wl_2 a waiting list: dataframe consisting addition and removal dates
#' @param referral_index the column index where referrals are listed
#'
#' @return A data.frame representing the combined waiting list, created by
#'   joining \code{wl_1} and \code{wl_2}. The result is sorted by the referral
#'   date column specified by \code{referral_index}. The column structure is
#'   preserved from the input data frames.
#' @import data.table
#'
#' @export
#'
#' @examples
#'
#' referrals <- c.Date("2024-01-01","2024-01-04","2024-01-10","2024-01-16")
#' removals <- c.Date("2024-01-08",NA,NA,NA)
#' wl_1 <- data.frame("referral" = referrals ,"removal" = removals )
#'
#' referrals <- c.Date("2024-01-04","2024-01-05","2024-01-16","2024-01-25")
#' removals <- c.Date("2024-01-09",NA,"2024-01-19",NA)
#' wl_2 <- data.frame("referral" = referrals ,"removal" = removals )
#' wl_join(wl_1,wl_2)
#'
wl_join <- function(wl_1, wl_2, referral_index = 1) {
  check_wl(wl_1, referral_index)
  check_wl(wl_2, referral_index)

  # Convert to data.table
  wl_1 <- as.data.table(wl_1)
  wl_2 <- as.data.table(wl_2)

  # Combine
  updated_list <- rbindlist(list(wl_1, wl_2), use.names = TRUE, fill = TRUE)

  # Get column name from position if referral_index is numeric
  if (is.numeric(referral_index)) {
    referral_index <- names(updated_list)[referral_index]
  }

  # Sort in place
  setorderv(updated_list, cols = referral_index)

  return(as.data.frame(updated_list))
}
