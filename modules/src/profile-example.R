#! /usr/bin/Rscript

fun1 <- function(x) {
  res <- NULL
  n <- nrow(x)
  for (i in 1:n) if (!any(is.na(x[i,])))
    res <- rbind(res,x[i,])
  res
}

fun2 <- function(x) {
  n <- nrow(x)
  res <- matrix(0,n,ncol(x))
  k <- 1
  for (i in 1:n)
    if (!any(is.na(x[i,]))) {
      res[k,] <- x[i,]
      k <- k+1
    }
  res[1:(k-1),]
}

x <- matrix(rnorm(2000000),100000,20)
x[x>1.5] <- NA

Rprof("profile1.out", line.profiling=TRUE)
print(unix.time(fun1(x)))
Rprof(NULL)

Rprof("profile2.out", line.profiling=TRUE)
print(unix.time(fun2(x)))
Rprof(NULL)

#summaryRprof("profile1.out", lines = "show")
