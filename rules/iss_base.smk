N=config["n_mut"]
R=config["R"]
AF=config["AF"]
NR=config["n_reads"]

rule iss_base:
    input:
       expand("results/reference/{seq}_{chr}.fa", seq=[config["sequence"]],  chr=[config["chr"]]),
       expand("results/reference/{seq}_{chr}_snps.fa", seq=[config["sequence"]],  chr=[config["chr"]])
    output:
        temp(expand("results/reads/base_N{N}_R{R}_AF{AF}_NR{NR}_R{strand}.fastq", strand=["1", "2"], allow_missing=True))
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
        "N=$(python -c \"print( round({params.NR}*(1-{params.AF})) )\") ; "
        "N=${{N%.*}} ;"
        "iss generate --genomes {input} --model hiseq --n_reads $N --cpus {threads} "
        "--o results/reads/base_N{params.N}_R{params.R}_AF{params.AF}_NR{params.NR} ; "
        "rm results/reads/base_N{params.N}_R{params.R}_AF{params.AF}_NR{params.NR}_abundance.txt"
