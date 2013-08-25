#! /usr/bin/Rscript
#
# Example to illustrate code profiling with Rprof
# on three different ways to remove rows with
# missing values in large matrices.

# slow implementation
fun1 <- function(x) {
  res <- NULL
  n <- nrow(x)
  for (i in 1:n) if (!any(is.na(x[i,])))
    res <- rbind(res,x[i,])
  res
}

# faster implementation
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

# broken implementation
fun3 <-  function(x) {
  omit <- F
  n <- nrow(x)
  for (i in 1:n)
    omit <- omit | is.na(x[i,])
  x[!omit,]
}

# create large matrix with missing values
x <- matrix(rnorm(2000000),100000,20)
x[x>1.5] <- NA

# save profile data to file
Rprof("profile1.out", line.profiling=TRUE)
print(unix.time(fun1(x)))
Rprof(NULL)

Rprof("profile2.out", line.profiling=TRUE)
print(unix.time(fun2(x)))
Rprof(NULL)

# can use summaryRprof to display profile information
#summaryRprof("profile1.out", lines = "show")
#
# alternatively, the following will work from a shell prompt:
# $ R CMD Rprof profile1.out
