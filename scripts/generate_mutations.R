# input
base_ref <- snakemake@input[[1]]
# wildcards
mutation_number <-  as.numeric(snakemake@wildcards[["N"]])
R <- as.numeric(snakemake@wildcards[["R"]])
# output
mut_file <-  snakemake@output[[1]] 
mut_ref <- snakemake@output[[2]]

# # # manual
# base_ref <- "results/reference/Qrob_PM1N_Qrob_Chr01.fa"
# mutation_number <-  100
# R <- 2
# mut_file <-  "results/mutation_N100_R2/Qrob_PM1N_Qrob_Chr01_mutated.tsv"
# mut_ref <- "results/mutation_N100_R2/Qrob_PM1N_Qrob_Chr01_mutated.fa"

library(tidyverse)
library(Biostrings)

R <- R/(R+1)

mute_type <- function(ref, R){
  type <- c("transition", "transversion")[rbinom(length(ref), 1, R) + 1]
  type[type == "transversion"] <- c("transversion1", "transversion2")[rbinom(length(type[type == "transversion"]), 1, 0.5) + 1]
  return(type)
}
  

mute <- function(ref, type){
  transition <- c("G", "T", "C", "A")
  names(transition) <- c("A", "C", "T", "G")
  transversion1 <- c("C", "A", "G", "T")
  names(transversion1) <- c("A", "C", "T", "G")
  transversion2 <- c("T", "G", "A", "C")
  names(transversion2) <- c("A", "C", "T", "G")
  alt <- NA
  alt[type == "transition"] <- transition[ref[type == "transition"]]
  alt[type == "transversion1"] <- transversion1[ref[type == "transversion1"]]
  alt[type == "transversion2"] <- transversion2[ref[type == "transversion2"]]
  return(alt)
}

ref <- readDNAStringSet(base_ref)
bed <- lapply(ref, function(Xch) data.frame(start = 0, stop = length(Xch))) %>% 
  bind_rows(.id = "seq")

mutations.pos <- data.frame(seq = sample(bed$seq, mutation_number, replace = T)) %>% 
  group_by(seq) %>% 
  summarise(N = n()) %>% 
  left_join(bed) %>% 
  do(mutations = paste(.$seq, sample(.$start:.$stop, .$N))) %>% 
  unlist()

mutations_tab <- data.frame(mutation  = mutations.pos) %>% 
  separate(mutation, c("CHROM", "POS"), " ") %>% 
  arrange(CHROM, POS)
  
mutations_tmp <- group_by(mutations_tab, CHROM) %>% 
  do(range = IRanges(start = as.numeric(.$POS),
                     end = as.numeric(.$POS)))

mutations_range <- IRangesList(mutations_tmp$range)

mutations <- extractAt(ref, mutations_range)
  
mutations_tab <- mutations_tab %>% 
  mutate(REF = as.vector(unlist(mutations))) %>% 
  mutate(TYPE = mute_type(REF, R = R)) %>% 
  mutate(ALT = mute(REF, TYPE)) %>% 
  mutate(ALT = ifelse(is.na(ALT), "N", ALT))

mutations_tmp <- group_by(mutations_tab, CHROM) %>% 
  do(mutations = c(.$ALT))

muted <- replaceAt(ref, mutations_range, mutations_tmp$mutations)

if(!all(unlist(extractAt(ref, mutations_range)) == mutations_tab$REF))
  stop("Error with REF.")
if(!all(unlist(extractAt(muted, mutations_range)) == mutations_tab$ALT))
  stop("Error with ALT.")

write_tsv(mutations_tab, file = mut_file)
writeXStringSet(muted, mut_ref)
