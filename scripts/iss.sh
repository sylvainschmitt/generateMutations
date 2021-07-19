#!/usr/bin/bash

# vars
while getopts i:o:m:b:t: flag
do
    case "${flag}" in
        i) in=${OPTARG};;
        o) out=${OPTARG};;
        m) n_mut=${OPTARG};;
        b) n_bas=${OPTARG};;
        t) threads=${OPTARG};;
    esac
done
file="${out%_R1.fq}"


# base
iss generate \
  --genomes $in \
  --model hiseq \
  --n_reads $n_bas \
  --cpus $threads \
  --o "$file"_bas
rm "$file"_bas_abundance.txt

# mutated
if [ "$n_mut" -gt "0" ]
  then
    iss generate \
      --genomes $in \
      --model hiseq \
      --n_reads $n_mut \
      --cpus $threads \
      --o "$file"_mut
    rm "$file"_mut_abundance.txt
fi

# merge
if [ "$n_mut" -gt "0" ]
  then
    cat "$file"_bas_R1.fastq "$file"_mut_R1.fastq > "$file"_R1.fq
    cat "$file"_bas_R2.fastq "$file"_mut_R2.fastq > "$file"_R2.fq
    rm "$file"_bas_R1.fastq "$file"_mut_R1.fastq "$file"_bas_R2.fastq "$file"_mut_R2.fastq
fi
if [ "$n_mut" -eq "0" ]
  then
    mv "$file"_bas_R1.fastq "$file"_R1.fq
    mv "$file"_bas_R2.fastq "$file"_R2.fq
fi
