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

``` python
rule reference_get:
    output:
        "data/reference.fa.gz"
    log:
        "logs/reference_get.log"
    benchmark:
        "benchmarks/reference_get.benchmark.txt"
    threads: 4
    shell:
        "wget {config[reference]} -O {output}"
```

## Statistics

``` python
rule reference_stats:
    input:
        "data/reference.fa.gz"
    output:
        "data/reference.stats.txt"
    log:
        "logs/reference_stat.log"
    benchmark:
        "benchmarks/reference_stat.benchmark.txt"
    threads: 4
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/bioawk/bioawk:latest"
    shell:
        "bioawk -c fastx '{{ print $name, length($seq) }}' < {input} > {output}"
```

![](README_files/figure-gfm/refStats-1.png)<!-- -->

## Convert

``` python
rule reference_convert:
    input:
        "data/reference.fa.gz"
    output:
        "data/reference.sam.fa.gz"
    log:
        "logs/reference_convert.log"
    benchmark:
        "benchmarks/reference_convert.benchmark.txt"
    threads: 4
    shell:
        "zcat {input} | bgzip -c > {output}"
```

## Index

``` python
rule reference_index:
    input:
        "data/reference.fa.gz"
    log:
        "logs/reference_index.log"
    benchmark:
        "benchmarks/reference_index.benchmark.txt"
    threads: 4
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/samtools/samtools:latest"
    shell:
        "samtools faidx {input}"
```

## Subsample

``` python
rule reference_subsample:
    input:
        "data/reference.sam.fa.gz"
    output:
        "data/sample.fa.gz"
    log:
        "logs/reference_subsample.log"
    benchmark:
        "benchmarks/reference_subsample.benchmark.txt"
    threads: 4
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/samtools/samtools:latest"
    shell:
        "samtools faidx {input} {config[chromosome]} > {output}"
```

# All

``` bash
snakemake -np 
snakemake --dag | dot -Tsvg > dag/dag.svg
snakemake --use-singularity
```

![](dag/dag.svg)<!-- -->
