N=config["n_mut"]
R=config["R"]
AF=config["AF"]
NR=config["n_reads"]
REP=config["REP"]

rule iss_unmutated:
    input:
       expand("results/reference/{seq}_{chr}.fa", seq=[config["sequence"]],  chr=[config["chr"]]),
       expand("results/reference/{seq}_{chr}_snps.fa", seq=[config["sequence"]],  chr=[config["chr"]])
    output:
        temp(expand("results/reads/unmutated_N{N}_R{R}_AF{AF}_NR{NR}_REP{REP}_R{strand}.fastq", strand=["1", "2"], allow_missing=True))
    log:
        "results/logs/iss_unmutated_N{N}_R{R}_AF{AF}_NR{NR}_REP{REP}.log"
    benchmark:
        "results/benchmarks/iss_unmutated_N{N}_R{R}_AF{AF}_NR{NR}_REP{REP}.benchmark.txt"
    params:
        N = "{N}",
        R = "{R}",
        AF = "{AF}",
        NR = "{NR}",
        REP = "{REP}"
    singularity: 
        "docker://hadrieng/insilicoseq:latest"
    threads: 8
    resources:
        mem_mb=32000
    shell:
        "N=$(python -c \"print( round({params.NR}*(1-{params.AF})) )\") ; "
        "N=${{N%.*}} ;"
        "iss generate --genomes {input} --model hiseq --n_reads $N --cpus {threads} "
        "--o results/reads/unmutated_N{params.N}_R{params.R}_AF{params.AF}_NR{params.NR}_REP{params.REP} ; "
        "rm results/reads/unmutated_N{params.N}_R{params.R}_AF{params.AF}_NR{params.NR}_REP{params.REP}_abundance.txt"
