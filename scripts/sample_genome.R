input <- snakemake@input[[1]]
R <- as.numeric(snakemake@wildcards[["REP"]])
L <- as.numeric(snakemake@config[["L"]])
output <- snakemake@output[[1]]

library(Biostrings)

genome <- readDNAStringSet(input)
genome <- genome[width(genome) > L]
genome <- genome[sample(names(genome), 1)]
pos <- sample(0:(width(genome)-L), 1)
genome <- subseq(genome, pos+1, pos+L)
writeXStringSet(genome, output)
