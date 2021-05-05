# config
mutation_number <-  snakemake@config[["mutations"]][["number"]] # yaml::read_yaml("config/config.yml")$mutations$number
R <- snakemake@config[["mutations"]][["R"]] # yaml::read_yaml("config/config.yml")$mutations$R
# input
bed <- snakemake@input[[1]] # "results/base_reference/base_reference.bed"
base_ref <- snakemake@input[[2]] # "results/base_reference/base_reference.fa"
# output
mut_file <-  snakemake@output[[1]] # "results/mutated_reference/mutation.tsv"
mut_ref <- snakemake@output[[2]] # "results/mutated_reference/mutated_reference.fa"

# # manual
# mutation_number <-  yaml::read_yaml("config/config.yml")$mutations$number
# R <- yaml::read_yaml("config/config.yml")$mutations$R
# bed <- "results/base_reference/base_reference.bed"
# base_ref <- "results/base_reference/base_reference.fa"
# mut_file <-  "results/mutated_reference/mutation.tsv"
# mut_ref <- "results/mutated_reference/mutated_reference.fa"

library(tidyverse)
library(Biostrings)

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

mutations <- read_tsv(bed, col_names = c("seq", "start", "stop")) %>% 
  rowwise %>% do(pos = c(.$start:.$stop)) %>% 
  unlist() %>% 
  sample(mutation_number)

mutations_tab <- data.frame(
  CHROM = ref[1]@ranges@NAMES,
  POS = mutations,
  REF = unlist(ref[[1]][mutations])) %>% 
  mutate(REF = as.character(REF)) %>% 
  mutate(TYPE = mute_type(REF, R = R)) %>% 
  mutate(ALT = mute(REF, TYPE))

muted <- replaceAt(ref, IRangesList(mutations), mutations_tab$ALT)

write_tsv(mutations_tab, file = mut_file)
writeXStringSet(muted, mut_ref)
