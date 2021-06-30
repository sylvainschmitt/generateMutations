N=config["n_mut"]
R=config["R"]
AF=config["AF"]
NR=config["n_reads"]

rule iss_mutated:
    input:
        expand("results/mutations/{seq}_{chr}_mutated_N{N}_R{R}.fa", seq=config["sequence"], chr=config["chr"], allow_missing=True)
    output:
        temp(expand("results/reads/mutatedtmp_N{N}_R{R}_AF{AF}_NR{NR}_R{strand}.fastq", strand=["1", "2"], allow_missing=True))
    params:
        N = "{N}",
        R = "{R}",
        AF = "{AF}",
        NR = "{NR}"
    log:
        "results/logs/iss_mutateds_N{N}_R{R}_AF{AF}_NR{NR}.log"
    benchmark:
        "results/benchmarks/iss_mutateds_N{N}_R{R}_AF{AF}_NR{NR}.benchmark.txt"
    singularity: 
        "docker://hadrieng/insilicoseq:latest"
    threads: 8
    resources:
        mem_mb=32000
    shell:
        "N=$(python -c \"print( round({params.NR}*{params.AF}) )\") ; "
        "N=${{N%.*}} ;"
        "iss generate --genomes {input} --model hiseq --n_reads $N --cpus {threads} "
        "--o results/reads/mutatedtmp_N{params.N}_R{params.R}_AF{params.AF}_NR{params.NR} ; "
        "rm results/reads/mutatedtmp_N{params.N}_R{params.R}_AF{params.AF}_NR{params.NR}_abundance.txt"
