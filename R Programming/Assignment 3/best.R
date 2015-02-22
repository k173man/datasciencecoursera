best <- function(state, outcome) {
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
    st <- st[order(st[, 2], st[, 1]), ]
    
    st$Hospital.Name[1]
}

# Sample output from the function.
    # > best("TX", "heart attack")
    # [1] "CYPRESS FAIRBANKS MEDICAL CENTER"
    # > best("TX", "heart failure")
    # [1] "FORT DUNCAN MEDICAL CENTER"
    # > best("MD", "heart attack")
    # [1] "JOHNS HOPKINS HOSPITAL, THE"
    # > best("MD", "pneumonia")
    # [1] "GREATER BALTIMORE MEDICAL CENTER"
    # > best("BB", "heart attack")
    # Error in best("BB", "heart attack") : invalid state
    # > best("NY", "hert attack")
    # Error in best("NY", "hert attack") : invalid outcome