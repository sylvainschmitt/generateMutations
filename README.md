generate Mutations
================
Sylvain Schmitt
April 20, 2021

  - [Source](#source)
  - [**Base** reference](#base-reference)
  - [**Mutated** reference](#mutated-reference)
  - [**Base** reads](#base-reads)
  - [**Mutated** reads](#mutated-reads)
  - [Miscellaneous](#miscellaneous)
      - [Commands](#commands)
      - [Direct Acyclic Graph](#direct-acyclic-graph)
      - [Resources](#resources)

Development of a [`singularity` &
`snakemake`](https://github.com/sylvainschmitt/snakemake_singularity)
workflow to generate *in silico* mutations.

# Source

**Issue with the rule on genologin.**

*Get source data.*

  - Rule:
    [`get_source`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/get_source.smk),
    [`uncompress`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/uncompress.smk)
    &
    [`index`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/index.smk)
  - Tools: `snakemake.remote.HTTP`, `mv`, `zcat` & [`samtools
    faidx`](http://www.htslib.org/doc/samtools-faidx.html)
  - Address: <http://>
  - Files: Qrob\_PM1N.fa, Qrob\_PM1N\_genes\_20161004.gff,
    Qrob\_PM1N\_refTEs.gff
  - Singularity:
    oras://registry.forgemia.inra.fr/gafl/singularity/samtools/samtools:latest

# **Base** reference

*Subsample genome with chromosome and positions.*

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

*Mutate reference.*

  - Rules:
    [`generate_mutations`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/generate_mutations.smk)
  - Script:
    [`generate_mutations.R`](https://bedtools.readthedocs.io/en/latest/content/scripts/generate_mutations.R)
  - Singularity:“<https://github.com/sylvainschmitt/singularity-template/releases/download/0.0.1/sylvainschmitt-singularity-tidyverse-Biostrings.latest.sif>”
  - Mutations:
      - Number: 10
      - Transition/Transversion ratio (see below): 0.5

To be upgraded on several chromosomes and with annotation (beware R
might start to be slow for such a task): transposable elements,
heterosigozity, genes.

![](https://dridk.me/images/post17/transition_transversion.png)<!-- -->

# **Base** reads

*Generate reads from base reference.*

  - Rules:
    [`generate_reads`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/generate_reads.smk)
  - Tools:
    [`insilicoseq`](https://insilicoseq.readthedocs.io/en/latest/)
  - Singularity: docker://hadrieng/insilicoseq:latest
  - Parameters:
      - Sequencing machine: hiseq
      - Number of reads: 1000 (150X)

# **Mutated** reads

*Generate mixed reads from base and mutated reference.*

  - Rules:
    [`generate_reads`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/generate_reads.smk)
    &
    [`merge_reads`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/merge_reads.smk)
  - Tools:
    [`insilicoseq`](https://insilicoseq.readthedocs.io/en/latest/)
  - Singularity: docker://hadrieng/insilicoseq:latest
  - Parameters:
      - Allelic fraction: 0.6
      - Sequencing machine: hiseq
      - Number of reads: 1000 (150X)

# Miscellaneous

## Commands

*To run locally.*

``` bash
snakemake -np # dry run
snakemake --dag | dot -Tsvg > dag/dag.svg # dag
snakemake --use-singularity --cores 4 # run
snakemake --report results/report.html # report
```

*To run on HPC.*

``` bash
module purge ; module load bioinfo/snakemake-5.8.1 # for test on node
snakemake -np # dry run
sbatch job.sh ; watch 'squeue -u sschmitt' # run
less genMut.*.err # snakemake outputs, use MAJ+F
less genMut.*.out # snakemake outputs, use MAJ+F
snakemake --dag | dot -Tsvg > dag/dag.svg # dag
module purge ; module load bioinfo/snakemake-5.8.1 ; module load system/Python-3.6.3 # for report
snakemake --report results/report.html # report
```

## Direct Acyclic Graph

*Represent rules.*

![](dag/dag.svg)<!-- -->

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

  - <https://forgemia.inra.fr/adminforgemia/doc-public/-/wikis/Gitlab-Container-Registry>

  - <https://souchal.pages.in2p3.fr/hugo-perso/2019/09/20/tutorial-singularity-and-docker/>

  - <https://github.com/ShixiangWang/sigminer>

  - <https://github.com/ShixiangWang/sigflow>

  - <https://github.com/FunGeST/Palimpsest>

  - <https://github.com/IARCbioinfo/needlestack>

  - <https://github.com/luntergroup/octopus>

  - <https://github.com/G3viz/g3viz>
