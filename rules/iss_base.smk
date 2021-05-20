N=config["n_mut"]
R=config["R"]
AF=config["AF"]
NR=config["n_reads"]

rule iss_base:
    input:
       expand("results/reference/{seq}_{chr}.fa", seq=[config["sequence"]],  chr=[config["chr"]]),
       expand("results/reference/{seq}_{chr}_snps.fa", seq=[config["sequence"]],  chr=[config["chr"]])
    output:
       expand("results/reads/N{N}_R{R}_AF{AF}_NR{NR}_base_R{strand}.fastq", strand=["1", "2"], allow_missing=True)
    log:
       "results/logs/iss_base_N{N}_R{R}_AF{AF}_NR{NR}.log"
    benchmark:
       "results/benchmarks/iss_base_N{N}_R{R}_AF{AF}_NR{NR}.benchmark.txt"
    params:
       N = "{N}",
       R = "{R}",
       AF = "{AF}",
       NR = "{NR}"
    singularity: 
       "docker://hadrieng/insilicoseq:latest"
    shell:
       "iss generate --genomes {input} --model hiseq --n_reads {params.NR} --cpus {threads} "
       "--o results/reads/N{params.N}_R{params.R}_AF{params.AF}_NR{params.NR}_base ; "
       "rm results/reads/N{params.N}_R{params.R}_AF{params.AF}_NR{params.NR}_base_abundance.txt"
