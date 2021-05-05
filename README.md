generate Mutations
================
Sylvain Schmitt
April 20, 2021

  - [Installation](#installation)
  - [Usage](#usage)
      - [Get data](#get-data)
      - [Locally](#locally)
      - [HPC](#hpc)
  - [Workflow](#workflow)
      - [Source](#source)
      - [**Base** reference](#base-reference)
      - [**Mutated** reference](#mutated-reference)
      - [**Base** reads](#base-reads)
      - [**Mutated** reads](#mutated-reads)
  - [Results](#results)

[`singularity` &
`snakemake`](https://github.com/sylvainschmitt/snakemake_singularity)
workflow to generate *in silico* mutations.

![](dag/dag.svg)<!-- -->

# Installation

  - [x] Python ≥3.5
  - [x] Snakemake ≥5.24.1
  - [x] Golang ≥1.15.2
  - [x] Singularity ≥3.7.3
  - [x] This workflow

<!-- end list -->

``` bash
# Python
sudo apt-get install python3.5
# Snakemake
sudo apt install snakemake`
# Golang
export VERSION=1.15.8 OS=linux ARCH=amd64  # change this as you need
wget -O /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz && \
sudo tar -C /usr/local -xzf /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz
echo 'export GOPATH=${HOME}/go' >> ~/.bashrc && \
echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> ~/.bashrc && \
source ~/.bashrc
# Singularity
mkdir -p ${GOPATH}/src/github.com/sylabs && \
  cd ${GOPATH}/src/github.com/sylabs && \
  git clone https://github.com/sylabs/singularity.git && \
  cd singularity
git checkout v3.7.3
cd ${GOPATH}/src/github.com/sylabs/singularity && \
  ./mconfig && \
  cd ./builddir && \
  make && \
  sudo make install
# generate Mutations
git clone git@github.com:sylvainschmitt/generateMutations.git
cd generateMutations
```

# Usage

## Get data

*Data from <http://urgi.versailles.inra.fr/download/oak>.*

``` bash
cd data
bash scripts/get_data.sh
```

## Locally

``` bash
snakemake -np # dry run
snakemake --dag | dot -Tsvg > dag/dag.svg # dag
snakemake --use-singularity --cores 4 # run
snakemake --use-singularity --cores 1 --verbose # debug
snakemake --report report.html # report
```

## HPC

``` bash
module purge ; module load bioinfo/snakemake-5.8.1 # for test on node
snakemake -np # dry run
sbatch job.sh ; watch 'squeue -u sschmitt' # run
less genMut.*.err # snakemake outputs, use MAJ+F
less genMut.*.out # snakemake outputs, use MAJ+F
snakemake --dag | dot -Tsvg > dag/dag.svg # dag
module purge ; module load bioinfo/snakemake-5.8.1 ; module load system/Python-3.6.3 # for report
snakemake --report report.html # report
```

# Workflow

## Source

*Get source data.*

  - Rule:
    [`uncompress`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/uncompress.smk)
    &
    [`index`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/index.smk)
  - Tools: `zcat` & [`samtools
    faidx`](http://www.htslib.org/doc/samtools-faidx.html)
  - Files: Qrob\_PM1N.fa, Qrob\_PM1N\_genes\_20161004.gff,
    Qrob\_PM1N\_refTEs.gff
  - Singularity:
    oras://registry.forgemia.inra.fr/gafl/singularity/samtools/samtools:latest

## **Base** reference

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

## **Mutated** reference

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

## **Base** reads

*Generate reads from base reference.*

**Beware on genologin, singularity pull failed to create singularity
image from docker in .snakemake/singularity/. I had to manually use
singularity build instead to create the image with the correct name in
the location. To be explored. Maybe we should consider having a single
script to generate imges in an img/ folders to bu used after by the
pipeline.**

  - Rules:
    [`generate_reads`](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/generate_reads.smk)
  - Tools:
    [`insilicoseq`](https://insilicoseq.readthedocs.io/en/latest/)
  - Singularity: docker://hadrieng/insilicoseq:latest
  - Parameters:
      - Sequencing machine: hiseq
      - Number of reads: 1000 (150X)

## **Mutated** reads

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

# Results

<table>

<caption>

Generated mutations.

</caption>

<thead>

<tr>

<th style="text-align:left;">

Chromosome

</th>

<th style="text-align:right;">

Position

</th>

<th style="text-align:left;">

Reference

</th>

<th style="text-align:left;">

Alternative

</th>

<th style="text-align:left;">

Type

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Qrob\_Chr01:0-1000

</td>

<td style="text-align:right;">

163

</td>

<td style="text-align:left;">

T

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:left;">

transversion2

</td>

</tr>

<tr>

<td style="text-align:left;">

Qrob\_Chr01:0-1000

</td>

<td style="text-align:right;">

166

</td>

<td style="text-align:left;">

C

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:left;">

transversion1

</td>

</tr>

<tr>

<td style="text-align:left;">

Qrob\_Chr01:0-1000

</td>

<td style="text-align:right;">

213

</td>

<td style="text-align:left;">

G

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:left;">

transition

</td>

</tr>

<tr>

<td style="text-align:left;">

Qrob\_Chr01:0-1000

</td>

<td style="text-align:right;">

215

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:left;">

T

</td>

<td style="text-align:left;">

transversion2

</td>

</tr>

<tr>

<td style="text-align:left;">

Qrob\_Chr01:0-1000

</td>

<td style="text-align:right;">

278

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:left;">

C

</td>

<td style="text-align:left;">

transversion1

</td>

</tr>

<tr>

<td style="text-align:left;">

Qrob\_Chr01:0-1000

</td>

<td style="text-align:right;">

474

</td>

<td style="text-align:left;">

T

</td>

<td style="text-align:left;">

C

</td>

<td style="text-align:left;">

transition

</td>

</tr>

<tr>

<td style="text-align:left;">

Qrob\_Chr01:0-1000

</td>

<td style="text-align:right;">

708

</td>

<td style="text-align:left;">

C

</td>

<td style="text-align:left;">

T

</td>

<td style="text-align:left;">

transition

</td>

</tr>

<tr>

<td style="text-align:left;">

Qrob\_Chr01:0-1000

</td>

<td style="text-align:right;">

746

</td>

<td style="text-align:left;">

C

</td>

<td style="text-align:left;">

T

</td>

<td style="text-align:left;">

transition

</td>

</tr>

<tr>

<td style="text-align:left;">

Qrob\_Chr01:0-1000

</td>

<td style="text-align:right;">

844

</td>

<td style="text-align:left;">

T

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:left;">

transversion2

</td>

</tr>

<tr>

<td style="text-align:left;">

Qrob\_Chr01:0-1000

</td>

<td style="text-align:right;">

959

</td>

<td style="text-align:left;">

T

</td>

<td style="text-align:left;">

C

</td>

<td style="text-align:left;">

transition

</td>

</tr>

</tbody>

</table>

<!-- ## Resources -->

<!-- * [TreeMutation pages](https://treemutation.netlify.app/mutations-detection.html#in-silico-mutations) -->

<!-- * [genologin skanemake template](https://forgemia.inra.fr/bios4biol/workflows/-/tree/06c6a5cb3206a594f9a535ba8d3df3e64682a8bc/Snakemake/template_dev) -->

<!-- * [Oak genome A4 snakemake](https://forgemia.inra.fr/genome_a4/genome_a4) -->

<!-- * [singularity images from forgemia](https://forgemia.inra.fr/gafl/singularity) -->

<!-- * [biocontainers](https://biocontainers.pro/tools/bioconductor-biostrings) -->

<!-- * https://forgemia.inra.fr/adminforgemia/doc-public/-/wikis/Gitlab-Container-Registry -->

<!-- * https://souchal.pages.in2p3.fr/hugo-perso/2019/09/20/tutorial-singularity-and-docker/ -->

<!-- * https://github.com/ShixiangWang/sigminer -->

<!-- * https://github.com/ShixiangWang/sigflow -->

<!-- * https://github.com/FunGeST/Palimpsest -->

<!-- * https://github.com/IARCbioinfo/needlestack -->

<!-- * https://github.com/luntergroup/octopus -->

<!-- * https://github.com/G3viz/g3viz -->
