generate Mutations
================
Sylvain Schmitt
April 20, 2021

  - [Summary](#summary)
  - [References](#references)
      - [Get](#get)
      - [Statistics](#statistics)
      - [Convert](#convert)
      - [Index](#index)
      - [Subsample](#subsample)
  - [All](#all)
      - [Commands](#commands)
      - [DAG](#dag)
      - [Benchamrk](#benchamrk)
  - [Resources](#resources)
  - [References](#references-1)

Development of a [`singularity` &
`snakemake`](https://github.com/sylvainschmitt/snakemake_singularity)
workflow to generate *in silico* mutations.

# Summary

# References

## Get

## Statistics

![](README_files/figure-gfm/refStats-1.png)<!-- -->

## Convert

## Index

## Subsample

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

  - [TreeMutation pages](https://treemutation.netlify.app/)
  - [genologin skanemake
    template](https://forgemia.inra.fr/bios4biol/workflows/-/tree/06c6a5cb3206a594f9a535ba8d3df3e64682a8bc/Snakemake/template_dev)
  - [Oak genome A4
    snakemake](https://forgemia.inra.fr/genome_a4/genome_a4)

# References
