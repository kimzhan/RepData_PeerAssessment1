fill.value<-function(steps,interval){
	filled<-NA
	if(!is.na(steps))
		filled<-c(steps) else filled<-(avg[avg$interval==interval,"steps"])
	return(filled)
}