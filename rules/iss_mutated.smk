rule iss_mutated:
    input:
        expand("results/mutations/{genome}_REP{REP}_mutated_N{N}_R{R}.fa", genome=config["genome"], allow_missing=True)
    output:
        temp(expand("results/reads/mutatedtmp_N{N}_R{R}_AF{AF}_NR{NR}_REP{REP}_R{strand}.fastq", strand=["1", "2"], allow_missing=True))
    params:
        N = "{N}",
        R = "{R}",
        AF = "{AF}",
        NR = "{NR}",
        REP = "{REP}"
    log:
        "results/logs/iss_mutateds_N{N}_R{R}_AF{AF}_NR{NR}_REP{REP}.log"
    benchmark:
        "results/benchmarks/iss_mutateds_N{N}_R{R}_AF{AF}_NR{NR}_REP{REP}.benchmark.txt"
    singularity: 
        "docker://hadrieng/insilicoseq:1.5.3"
    threads: 8
    resources:
        mem_mb=32000
    shell:
        "N=$(python -c \"print( round({params.NR}*{params.AF}) )\") ; "
        "N=${{N%.*}} ;"
        "iss generate --genomes {input} --model hiseq --n_reads $N --cpus {threads} "
        "--o results/reads/mutatedtmp_N{params.N}_R{params.R}_AF{params.AF}_NR{params.NR}_REP{params.REP} ; "
        "rm results/reads/mutatedtmp_N{params.N}_R{params.R}_AF{params.AF}_NR{params.NR}_REP{params.REP}_abundance.txt"
