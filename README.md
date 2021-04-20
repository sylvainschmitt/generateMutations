generate Mutations
================
Sylvain Schmitt
April 20, 2021

  - [Summary](#summary)
  - [Reference](#reference)
      - [Get](#get)
      - [Statistics](#statistics)
  - [All](#all)

Development of a [`singularity` &
`snakemake`](https://github.com/sylvainschmitt/snakemake_singularity)
workflow to generate *in silico* mutations.

# Summary

# Reference

## Get

``` python
rule get_reference:
    output:
        "data/reference.fa.gz"
    log:
        "logs/get_reference.log"
    benchmark:
        "benchmarks/get_reference.benchmark.txt"
    threads: 4
    shell:
        "wget {config[reference]} -O {output}"
```

## Statistics

``` python
rule stat_reference:
    input:
        "data/reference.fa.gz"
    output:
        "data/reference.stats.txt"
    log:
        "logs/stat_reference.log"
    benchmark:
        "benchmarks/stat_reference.benchmark.txt"
    threads: 4
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/bioawk/bioawk:latest"
    shell:
        "bioawk -c fastx '{{ print $name, length($seq) }}' < {input} > {output}"
```

![](README_files/figure-gfm/refStats-1.png)<!-- -->

# All

``` bash
snakemake -np 
snakemake --dag | dot -Tsvg > dag/dag.svg
snakemake --use-singularity
```

![](dag/dag.svg)<!-- -->
