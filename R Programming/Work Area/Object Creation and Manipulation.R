# +++++ Sequences (Vectors) +++++
colonOp <- 1:10
seqFx <- seq(1, 10) # increment by .5
seqFx <- seq(1, 10, .5) # sequence of 30 #s ranging from 1 to 10
seqFx <- seq(1, 10, length=30) # create a seq based on the length of another seq
seqFx2 <- seq(along.with = seqFx) # or use seq_along()
seqFx2 <- seq_along(seqFx)
repSeq <- rep(1, 10) # repeat 1, 10 times
rep(c(0, 1, 2), times = 10)
rep(c(0, 1, 2), each = 10)

# +++++ Vectors +++++

# +++++ Lists +++++
# "pre-allocate" an empty list of length 5
lst <- vector("list", 5)

# +++++  +++++