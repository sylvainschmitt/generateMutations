rule iss_unmutated:
    input:
       expand("results/reference/{genome}_REP{REP}.fa", genome=config["genome"],  allow_missing=True),
       expand("results/reference/{genome}_REP{REP}_snps.fa", genome=config["genome"],  allow_missing=True)
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
