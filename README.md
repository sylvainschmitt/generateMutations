generate Mutations
================
Sylvain Schmitt
April 20, 2021

  - [Summary](#summary)
  - [Reference](#reference)
      - [Get](#get)
      - [Statistics](#statistics)
      - [Convert](#convert)
      - [Index](#index)
      - [Subsample](#subsample)
  - [All](#all)

Development of a [`singularity` &
`snakemake`](https://github.com/sylvainschmitt/snakemake_singularity)
workflow to generate *in silico* mutations.

# Summary

# Reference

## Get

## Statistics

![](README_files/figure-gfm/refStats-1.png)<!-- -->

## Convert

## Index

## Subsample

# All

``` bash
snakemake -np 
snakemake --dag | dot -Tsvg > dag/dag.svg
snakemake --use-singularity
snakemake --report results/report.html
```

![](dag/dag.svg)<!-- -->
