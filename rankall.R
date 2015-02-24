library(data.table)
rankall <- function(outcome, num = "best") {
    
    ## Rank hospital in a state
    # datasource: https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip
    
    ## Parameters:
    
    # outcome: "heart attack" "heart failure" "pneumonia"
    
    # num: integer or 'best' or 'worst'
    
    # Read outcome data - type right path
    data = read.csv('~/dataAnalysis/prog/outcome-of-care-measures.csv', 
                    colClasses = 'character', na.strings = c("NA", "Not Available"))
    
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
    
    # process num parameter
    if(num == 'best') {
        param = ", hospital.name , decreasing = F), hospital.name][num]))"
        num = 1
    } else if(num == 'worst') {
        param = ", hospital.name , decreasing = T), hospital.name][num]))"
        num = 1
    } else {
        param = ", hospital.name , decreasing = F), hospital.name][num]))"
    }
    
    # Check that state and outcome are valid
    if(all(outcome != outcomes)) {
        stop('invalid outcome')
    } else {
        setkey(data, state)
        # extract ranked hospitals of every state - return vector (with states and hospitals)
        eval(parse(text=paste0("pom = unlist(sapply(unique(data[,state]), function(x) data[.(x), ][order(" ,
                               outcols[which(outcome == outcomes)], param)))
        # reshape vector with result data into data frame
        data.frame(hospital = pom,
                   state=unique(data[,state]))
    }
}