# config
mutation_number <-  snakemake@config[["mutations"]][["number"]] # yaml::read_yaml("config/config.yml")$mutations$number
R <- snakemake@config[["mutations"]][["R"]] # yaml::read_yaml("config/config.yml")$mutations$R
# input
bed <- snakemake@input[[1]] # "results/base_reference/base_reference.bed"
base_ref <- snakemake@input[[2]] # "results/base_reference/base_reference.fa"
# output
mut_file <-  snakemake@output[[1]] # "results/mutated_reference/mutation.tsv"
mut_ref <- snakemake@output[[2]] # "results/mutated_reference/mutated_reference.fa"

library(tidyverse)
library(Biostrings)

mute_type <- function(ref, R){
  odds <- runif(length(ref))
  type <- rep("transversion", length(ref))
  type[odds > R] <- "transition"
  return(type)
}

mute <- function(ref, type){
  transition <- c("G", "T", "C", "A")
  names(transition) <- c("A", "C", "T", "G")
  trasnversion1 <- c("C", "A", "G", "T")
  names(trasnversion1) <- c("A", "C", "T", "G")
  trasnversion2 <- c("T", "G", "A", "C")
  names(trasnversion2) <- c("A", "C", "T", "G")
  alt <- trasnversion2[ref]
  alt[type == "transition"] <- transition[ref[type == "transition"]]
  odds <- rep(length(type == "transversion"))
  alt[type == "transversion"][odds > 0.5] <- trasnversion1[ref[type == "transversion"]][odds > 0.5]
  return(alt)
}

ref <- readDNAStringSet(base_ref)
mutations <- read_tsv(bed, col_names = c("seq", "start", "stop")) %>% 
  rowwise %>% do(pos = c(.$start:.$stop)) %>% 
  unlist() %>% 
  sample(mutation_number)
mutations_tab <- data.frame(position = mutations,
                        ref = unlist(ref[[1]][mutations])) %>% 
  mutate(type = mute_type(ref, R = R)) %>% 
  mutate(alt = mute(ref, type))

muted <- replaceAt(ref, IRangesList(mutations), mutations_tab$alt)

write_tsv(mutations_tab, file = mut_file)
writeXStringSet(muted, mut_ref)
