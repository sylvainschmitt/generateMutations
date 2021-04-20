## Sylvain SCHMITT
## 20/04/2021

configfile: "config/config.yml"
# singularity: "img/snakemake_tuto.sif"

rule all:
    input:
        "data/reference.stats.txt"
        
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
