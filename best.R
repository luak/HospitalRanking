library(data.table)
best = function(state, outcome) {
    
    ## Finding the best hospital in a state
    # datasource: https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip
    
    ## Parameters:
    # state: shortcut of the state in USA
    # "AL" "AK" "AZ" "AR" "CA" "CO" "CT" "DE" "DC" "FL" "GA" "HI" "ID" "IL" "IN"
    # "IA" "KS" "KY" "LA" "ME" "MD" "MA" "MI" "MN" "MS" "MO" "MT" "NE" "NV" "NH"
    # "NJ" "NM" "NY" "NC" "ND" "OH" "OK" "OR" "PA" "PR" "RI" "SC" "SD" "TN" "TX"
    # "UT" "VT" "VI" "VA" "WA" "WV" "WI" "WY" "GU"
    # outcome: "heart attack" "heart failure" "pneumonia"
    
    # Read outcome data - type right path
    data = read.csv('~/dataAnalysis/prog/outcome-of-care-measures.csv',
                    colClasses = 'character')
    
    # rename 'important' variables
    colnames(data)[c(2,7,11,17,23)] = c("hospital.name","state","heart.attack",
                                        "heart.failure","pneumonia")
    data[, c(11, 17, 23)] = apply(data[, c(11, 17, 23)], 2, function(x)
        suppressWarnings(as.numeric(x)))
    
    # convert data to data.table format
    data = data.table(data)
    
    # define correct outcome parameter
    outcomes = c("heart attack", "heart failure", "pneumonia")
    outcols = c("heart.attack", "heart.failure", "pneumonia")
    
    # define correct state parameter
    states = data[, unique(state)]
    
    # Check that state and outcome are valid
    if(all(outcome != outcomes)) {
        stop('invalid outcome')
    } else if(all(state != states)) {
        stop('invalid state')
    } else {
        # set key for searching in data.table
        setkey(data, state)
        
        # return hospital name with the lowest 'outcome' variable
        eval(parse(text=paste0("data[.('", state, "'), ][which.min(" ,
                               outcols[which(outcome == outcomes)],
                               "), hospital.name]")))
    }
}