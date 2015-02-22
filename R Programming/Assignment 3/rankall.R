rankall <- function(outcome, num = "best") {
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
    
    ococ <- subset(
        outcomeOfCare, 
        !is.na(outcomeOfCare[, ocIndexes[[outcome]]])
    )
    
    # select hosital name, state & selected outcome variables
    ococ <- ococ[c(2, 7, ocIndexes[[outcome]])]
    names(ococ) <- c("Hospital", "State", "Outcome")
    # convert outcome variable to numeric
    ococ[, 3] <- as.numeric(ococ[, 3])
    
    # order by outcome, hospital name
    if (!is.numeric(num) & num == "worst")
        ococ <- ococ[order(-ococ[, 3], ococ[, 2]), ococ[, 1]), ]
    else
        ococ <- ococ[order(ococ[, 3], ococ[, 2]), ococ[, 1]), ]
    
    num2 <- if (!is.numeric(num))
        1
    else
        num

    state <- NULL
    hospital <- NULL
    
    for(st in state.abb) {
        tmp <- subset(ococ, ococ$State == st & !is.na(ococ$Hospital.Name[num2]))
        
        if (nrow(tmp) == 0)
            hospital <- c(hospital, NA_character_)
        else
            hospital <- c(hospital, tmp$Hospital[1])
        
        state <- c(state, st)
    }
    
    data.frame(
        hospital = hospital, 
        state = state, 
        row.names = state.abb, 
        stringsAsFactors = FALSE
    )

    ## For each state, find the hospital of the given rank
    ## Return a data frame with the hospital names and the (abbreviated) state name
    
    # The function should return a value for every state (some may be NA)
    # Handle ties in the same way as in rankhospital
    # Returns a data frame named hospital
    # 1st column: hospital name
    # 2nd column is named state
    # Hospitals that do not have data on a particular outcome should be excluded from the set of hospitals when deciding the rankings.
}

# Sample Output
    # > head(rankall("heart attack", 20), 10)
    # hospital state
    # AK <NA> AK
    # AL D W MCMILLAN MEMORIAL HOSPITAL AL
    # AR ARKANSAS METHODIST MEDICAL CENTER AR
    # AZ JOHN C LINCOLN DEER VALLEY HOSPITAL AZ
    # CA SHERMAN OAKS HOSPITAL CA
    # CO SKY RIDGE MEDICAL CENTER CO
    # CT MIDSTATE MEDICAL CENTER CT
    # DC <NA> DC
    # DE <NA> DE
    # FL SOUTH FLORIDA BAPTIST HOSPITAL FL
    # > tail(rankall("pneumonia", "worst"), 3)
    # hospital state
    # WI MAYO CLINIC HEALTH SYSTEM - NORTHLAND, INC WI
    # WV PLATEAU MEDICAL CENTER WV
    # WY NORTH BIG HORN HOSPITAL DISTRICT WY
    # > tail(rankall("heart failure"), 10)
    # hospital state
    # TN WELLMONT HAWKINS COUNTY MEMORIAL HOSPITAL TN
    # TX FORT DUNCAN MEDICAL CENTER TX
    # UT VA SALT LAKE CITY HEALTHCARE - GEORGE E. WAHLEN VA MEDICAL CENTER UT
    # VA SENTARA POTOMAC HOSPITAL VA
    # VI GOV JUAN F LUIS HOSPITAL & MEDICAL CTR VI
    # VT SPRINGFIELD HOSPITAL VT
    # WA HARBORVIEW MEDICAL CENTER WA
    # WI AURORA ST LUKES MEDICAL CENTER WI
    # WV FAIRMONT GENERAL HOSPITAL WV
    # WY CHEYENNE VA MEDICAL CENTER WY