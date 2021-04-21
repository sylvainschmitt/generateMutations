generate Mutations
================
Sylvain Schmitt
April 20, 2021

  - [Summary](#summary)
  - [Data](#data)
      - [Get genome](#get-genome)
      - [Chromosmes length](#chromosmes-length)
      - [Sample reference](#sample-reference)
  - [Reads](#reads)
      - [Uncompress reference](#uncompress-reference)
      - [Generate reads](#generate-reads)
  - [Mutations](#mutations)
      - [Generate mutations](#generate-mutations)
  - [All](#all)
      - [Commands](#commands)
      - [DAG](#dag)
      - [Benchamrk](#benchamrk)
  - [Resources](#resources)
  - [References](#references)

Development of a [`singularity` &
`snakemake`](https://github.com/sylvainschmitt/snakemake_singularity)
workflow to generate *in silico* mutations.

# Summary

# Data

## Get genome

From <https://urgi.versailles.inra.fr/download/oak/Qrob_PM1N.fa.gz>.

## Chromosmes length

Using `bioawk`.

![](README_files/figure-gfm/refStats-1.png)<!-- -->

## Sample reference

Using `seqkit`.

# Reads

## Uncompress reference

For `insilicoseq` using temporary file.

## Generate reads

Using `insilicoseq`.
[Help](https://insilicoseq.readthedocs.io/en/latest/iss/generate.html#full-list-of-options).

# Mutations

## Generate mutations

Using `SomaticSpike`.

# All

## Commands

``` bash
snakemake -np 
snakemake --dag | dot -Tsvg > dag/dag.svg
snakemake --use-singularity
snakemake --report results/report.html
```

## DAG

![](dag/dag.svg)<!-- -->

## Benchamrk

![](README_files/figure-gfm/benchmark-1.png)<!-- -->

# Resources

  - [TreeMutation
    pages](https://treemutation.netlify.app/mutations-detection.html#in-silico-mutations)
  - [genologin skanemake
    template](https://forgemia.inra.fr/bios4biol/workflows/-/tree/06c6a5cb3206a594f9a535ba8d3df3e64682a8bc/Snakemake/template_dev)
  - [Oak genome A4
    snakemake](https://forgemia.inra.fr/genome_a4/genome_a4)
  - [singularity images from
    forgemia](https://forgemia.inra.fr/gafl/singularity)

# References
