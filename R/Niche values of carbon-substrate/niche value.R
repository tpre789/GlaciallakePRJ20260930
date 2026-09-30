### niche value

comm <- read.table("MAGs-TPM.txt", header = TRUE) 
env <- read.table("carbon.txt", header = TRUE)

comts <- t(comm)/colSums(comm)

niche_value <- as.matrix(comts) %*% as.matrix(env)

niche_value

write.csv(niche_value, 'niche_value.csv', quote = FALSE)