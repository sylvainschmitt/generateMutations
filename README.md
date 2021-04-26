generate Mutations
================
Sylvain Schmitt
April 20, 2021

  - [Source](#source)
  - [**Base** reference](#base-reference)
  - [**Mutated** reference](#mutated-reference)
  - [**Base** reads](#base-reads)
  - [**Mutated** reads](#mutated-reads)
  - [Misc](#misc)
      - [Commands](#commands)
      - [DAG](#dag)
      - [Benchamrk](#benchamrk)
      - [Resources](#resources)
          - [GitHub](#github)
      - [References](#references)

Development of a [`singularity` &
`snakemake`](https://github.com/sylvainschmitt/snakemake_singularity)
workflow to generate *in silico* mutations.

# Source

Get source data.

  - Rule:
    [`get_source`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/get_source.smk),
    [`uncompress_source`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/uncompress_source.smk)
    &
    [`index_source`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/index_source.smk)
  - Tools: `snakemake.remote.HTTP`, `mv`, `zcat` & [`samtools
    faidx`](http://www.htslib.org/doc/samtools-faidx.html)
  - Address: <http://urgi.versailles.inra.fr/download/oak/>
  - Files: Qrob\_PM1N.fa, Qrob\_PM1N\_genes\_20161004.gff,
    Qrob\_PM1N\_refTEs.gff
  - Singularity:
    “oras://registry.forgemia.inra.fr/gafl/singularity/samtools/samtools:latest”

# **Base** reference

Subsample genome with chromosome and positions.

  - Rules:
    [`reference_bed`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/reference_bed.smk)
    &
    [`sample_reference`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/sample_reference.smk)
  - Tools: `echo` & [`bedtools
    getfasta`](https://bedtools.readthedocs.io/en/latest/content/tools/getfasta.html)
  - Singularity:
    oras://registry.forgemia.inra.fr/gafl/singularity/bedtools/bedtools:latest
  - Sample: Qrob\_Chr01:0-1000

# **Mutated** reference

Mutate reference.

  - Rules:
    [`generate_mutations`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/generate_mutations.smk)
  - Script:
    [`generate_mutations.R`](https://bedtools.readthedocs.io/en/latest/content/scripts/generate_mutations.R)
  - Singularity:
    <https://depot.galaxyproject.org/singularity/bioconductor-biostrings:2.58.0--r40hd029910_1>
  - Mutations:
      - Number: 10
      - Transition/Transversion ratio (see below): 0.5

To be upgraded on several chromosomes and with annotation (beware R
might start to be slow for such a task): transposable elements,
heterosigozity, genes.

![](https://dridk.me/images/post17/transition_transversion.png)<!-- -->

# **Base** reads

Generate reads from base reference.

  - Rules:
  - Tools:
    [`insilicoseq`](https://insilicoseq.readthedocs.io/en/latest/)
  - Singularity: “docker://hadrieng/insilicoseq:latest”
  - Parameters:
      - Sequencing machine: hiseq
      - Number of reads: 1000

# **Mutated** reads

Generate mixed reads from base and mutated reference.

  - Rules:
  - Tools:
    [`insilicoseq`](https://insilicoseq.readthedocs.io/en/latest/)
  - Singularity: “docker://hadrieng/insilicoseq:latest”
  - Parameters:
      - Allelic fraction: 0.6
      - Sequencing machine: hiseq
      - Number of reads: 1000

# Misc

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

## Resources

  - [TreeMutation
    pages](https://treemutation.netlify.app/mutations-detection.html#in-silico-mutations)
  - [genologin skanemake
    template](https://forgemia.inra.fr/bios4biol/workflows/-/tree/06c6a5cb3206a594f9a535ba8d3df3e64682a8bc/Snakemake/template_dev)
  - [Oak genome A4
    snakemake](https://forgemia.inra.fr/genome_a4/genome_a4)
  - [singularity images from
    forgemia](https://forgemia.inra.fr/gafl/singularity)
  - [biocontainers](https://biocontainers.pro/tools/bioconductor-biostrings)

### GitHub

  - <https://github.com/ShixiangWang/sigminer>
  - <https://github.com/ShixiangWang/sigflow>
  - <https://github.com/FunGeST/Palimpsest>
  - <https://github.com/IARCbioinfo/needlestack>
  - <https://github.com/luntergroup/octopus>
  - <https://github.com/G3viz/g3viz>

## References
