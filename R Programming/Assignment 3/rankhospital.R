rankhospital <- function(state, outcome, num = "best") {
    # Exclude NAs
    # Handling ties; sort on hospital name & return the 1st one
        # use order()
    # possible values for num: "best", "worst", or an int
        # best = lowest mortality rate
        # worst = highest mortality rate
        #int n = nth lowest mortality rate
            # num > # of hospitals in that state, then return NA
    ## Read outcome data
    ## Check that state and outcome are valid
        # invalid state: stop("invalid state")
        # invalid outcome: stop("invalid outcome")
    ## Return hospital name in that state with the given rank 30-day death rate
}

# Sample Output
    # > rankhospital("TX", "heart failure", 4)
    # [1] "DETAR HOSPITAL NAVARRO"
    # > rankhospital("MD", "heart attack", "worst")
    # [1] "HARFORD MEMORIAL HOSPITAL"
    # > rankhospital("MN", "heart attack", 5000)
    # [1] NA