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
      - [Reference](#reference)
      - [Mutations](#mutations)
      - [Reads](#reads)
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
bash get_data.sh
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
module purge ; module load bioinfo/snakemake-5.25.0 # for test on node
snakemake -np # dry run
sbatch job.sh ; watch 'squeue -u sschmitt' # run
less genMut.*.err # snakemake outputs, use MAJ+F
less genMut.*.out # snakemake outputs, use MAJ+F
snakemake --dag | dot -Tsvg > dag/dag.svg # dag
module purge ; module load bioinfo/snakemake-5.25.0 ; module load system/Python-3.6.3 # for report
snakemake --report report.html # report
```

# Workflow

## Reference

### [samtools\_faidx](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/samtools_faidx.smk)

  - Tools: [`samtools
    faidx`](http://www.htslib.org/doc/samtools-faidx.html)
  - Singularity:
    oras://registry.forgemia.inra.fr/gafl/singularity/samtools/samtools:latest
  - Parameters:
      - Chromosome: Qrob\_Chr01

### [vcf2model](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/vcf2model.smk)

  - Tools: [`simuG`](https://github.com/yjx1217/simuG)
  - Script: `vcf2model.pl`

### [simug](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/simug.smk)

  - Tools: [`simuG`](https://github.com/yjx1217/simuG)
  - Script: `simuG.pl`

## Mutations

### [generate\_mutations](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/generate_mutations.smk)

  - Script:
    [`generate_mutations.R`](https://bedtools.readthedocs.io/en/latest/content/scripts/generate_mutations.R)
  - Singularity:“<https://github.com/sylvainschmitt/singularity-template/releases/download/0.0.1/sylvainschmitt-singularity-tidyverse-Biostrings.latest.sif>”
  - Parameters:
      - Number: 100, 1000
      - Transition/Transversion ratio R (see below): 2, 3

![](https://dridk.me/images/post17/transition_transversion.png)<!-- -->

## Reads

### [iss\_base](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/iss_base.smk)

  - Tools:
    [`insilicoseq`](https://insilicoseq.readthedocs.io/en/latest/)
  - Singularity: docker://hadrieng/insilicoseq:latest
  - Parameters:
      - Allele frequency: 0.6, 0.8
      - Number of reads: 33333, 50000

### [iss\_mutated](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/iss_mutated.smk)

  - Tools:
    [`insilicoseq`](https://insilicoseq.readthedocs.io/en/latest/)
  - Singularity: docker://hadrieng/insilicoseq:latest
  - Parameters:
      - Allele frequency: 0.6, 0.8
      - Number of reads: 33333, 50000

### [merge\_reads](https://github.com/sylvainschmitt/generateMutations/blob/main/rules/merge_reads.smk)

  - Tools: `cat`

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

Qrob\_Chr01

</td>

<td style="text-align:right;">

27661823

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

Qrob\_Chr01

</td>

<td style="text-align:right;">

26901240

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

Qrob\_Chr01

</td>

<td style="text-align:right;">

14914116

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

Qrob\_Chr01

</td>

<td style="text-align:right;">

39165234

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

Qrob\_Chr01

</td>

<td style="text-align:right;">

50645244

</td>

<td style="text-align:left;">

G

</td>

<td style="text-align:left;">

C

</td>

<td style="text-align:left;">

transversion2

</td>

</tr>

<tr>

<td style="text-align:left;">

Qrob\_Chr01

</td>

<td style="text-align:right;">

22225892

</td>

<td style="text-align:left;">

N

</td>

<td style="text-align:left;">

N

</td>

<td style="text-align:left;">

transition

</td>

</tr>

<tr>

<td style="text-align:left;">

Qrob\_Chr01

</td>

<td style="text-align:right;">

10401489

</td>

<td style="text-align:left;">

N

</td>

<td style="text-align:left;">

N

</td>

<td style="text-align:left;">

transversion2

</td>

</tr>

<tr>

<td style="text-align:left;">

Qrob\_Chr01

</td>

<td style="text-align:right;">

16712504

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

Qrob\_Chr01

</td>

<td style="text-align:right;">

727537

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

Qrob\_Chr01

</td>

<td style="text-align:right;">

23329662

</td>

<td style="text-align:left;">

T

</td>

<td style="text-align:left;">

G

</td>

<td style="text-align:left;">

transversion1

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
