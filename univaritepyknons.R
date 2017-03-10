



library(coin)

x<-read.table("tumorclinical.txt", sep="\t", head=T)


time <- "OS_MONTHS_dx"
event <- "vital_status_epid_data_clinic_data"

x <- x[!is.na(x[,time]),]
x <- x[!is.na(x[,event]),]

x<-x[x[,time]>0,]

r <- read.table("table_latestversion_plusmotifs.txt", sep="\t", head=T, comment="#")

r<-r[r$Control=="",]

pyk <- as.character(r$ProbeName[grep("pyk|PYK", r$Symbol_probe)])


mir <- intersect(pyk, colnames(x))

coxmodel <- coxph(Surv(x[,time], x[,event])~ x[,mir[1]])
s <- summary(coxmodel)
v <- cox.zph(coxmodel)$table
e <- cbind(data.frame(mir=mir[1]), as.data.frame(s$conf.int), t(as.data.frame(s$waldtest)), v)

N <- length(mir)
d <- as.data.frame(replicate(ncol(e), rep(NA, N)))
colnames(d) <- colnames(e)

k <- 1000

for (i in 1:N) {
	m <- mir[i]
	u <- x[!is.na(x[,m]),] 
	coxmodel <- coxph(Surv(u[,time], u[,event])~ u[,m])
	s <- summary(coxmodel)
	v <- cox.zph(coxmodel)$table
	d[i,1] <- m
	d[i,2:5] <- s$conf.int
	d[i,6:8] <- s$sctest
	d[i,9:11] <- v
	if (i %% k == 0) write.table(d[(i-k+1):i,], file=paste0("pyk", i, ".txt"), sep="\t", quote=F, row.names=F)
}

d$fdr <- p.adjust(d$pvalue, method="fdr")
d<-subset(d, pvalue<0.05)
write.table(d, file="pyk.txt", sep="\t", quote=F, row.names=F)
