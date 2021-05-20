#!/bin/bash

wget https://urgi.versailles.inra.fr/download/oak/Qrob_PM1N.fa.gz
zcat Qrob_PM1N.fa.gz > Qrob_PM1N.fa
rm Qrob_PM1N.fa.gz
head -n 119 Qrob_PM1N.fa > Qrob_PM1N_7k.fa
# wget https://urgi.versailles.inra.fr/download/oak/Qrob_V2_2N.fa.gz
wget https://urgi.versailles.inra.fr/download/oak/Qrob_PM1N_refTEs.gff.gz
wget https://urgi.versailles.inra.fr/download/oak/Qrob_PM1N_genes_20161004.gff.gz
wget www.oakgenome.fr/wp-content/uploads/files/Heterozygous_sites_3P.zip
unzip Heterozygous_sites_3P.zip
unzip Heterozygous_sites_3P/3P.haplov2.3.bam.pisorted.dedup.pileup.mincov100-maxcov200.vcf.withoutindel.sed.siteshz.zip 
rm Heterozygous_sites_3P.zip
rm -r Heterozygous_sites_3P
mv 3P.haplov2.3.bam.pisorted.dedup.pileup.mincov100-maxcov200.vcf.withoutindel.sed.siteshz siteshz3P.vcf
