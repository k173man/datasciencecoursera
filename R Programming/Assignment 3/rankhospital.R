rankhospital <- function(state, outcome, num = "best") {
    possibleOutcomes <- c("heart attack", "heart failure", "pneumonia")
    ocIndexes <- c(11, 17, 23) 
    names(ocIndexes) <- possibleOutcomes
    
    ## Check that state and outcome are valid
    if(!any(state.abb == state))
        stop("invalid outcome")
    
    if(!any(possibleOutcomes == outcome))
        stop("invalid outcome")

    # Read outcome data
    outcomeOfCare <- read.csv(
        "data/outcome-of-care-measures.csv", 
        colClasses = "character", 
        na.strings = "Not Available"
    )

    st <- subset(
        outcomeOfCare, 
        outcomeOfCare$State == state & !is.na(outcomeOfCare[, ocIndexes[[outcome]]])
    )
    
    # select hosital name & selected outcome variables
    st <- st[c(2, ocIndexes[[outcome]])]
    # convert outcome variable to numeric
    st[, 2] <- as.numeric(st[, 2])
    
    # order by outcome, hospital name
    if (!is.numeric(num) & num == "worst")
        st <- st[order(-st[, 2], st[, 1]), ]
    else
        st <- st[order(st[, 2], st[, 1]), ]
    
    num2 <- if (!is.numeric(num))
                1
            else
                num
    
    ## Return hospital name in that state with the given rank 30-day death rate
    st$Hospital.Name[num2]
}

# Sample Output
    # > rankhospital("TX", "heart failure", 4)
    # [1] "DETAR HOSPITAL NAVARRO"
    # > rankhospital("MD", "heart attack", "worst")
    # [1] "HARFORD MEMORIAL HOSPITAL"
    # > rankhospital("MN", "heart attack", 5000)
    # [1] NA