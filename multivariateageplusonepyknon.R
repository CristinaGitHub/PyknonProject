

library(coin)


x<-read.table("tablepyknonssign.txt", sep="\t", head=T, na="NA")



time <- "OS_MONTHS_dx"
event <- "vital_status_epid_data_clinic_data"



x <- x[!is.na(x[,time]),]
x <- x[!is.na(x[,event]),]


mir <- colnames(x)[27:ncol(x)]


d <- NULL

for (m in mir) {
	coxmodel<-coxph(Surv(x[,time], x[,event])~ x$age_dx+x[,m])
	s <- summary(coxmodel)
	d <- rbind(d, cbind(as.data.frame(c("age",m)), as.data.frame(s$conf.int), as.data.frame(s$coefficients[,5]),t(as.data.frame(s$waldtest)),samples=length(which(x[,m]!=0 & !is.na(x[,m])))))
}


write.table(d, file="pyknonsagesign.txt", sep="\t", quote=F, row.names=F)

