rule iss_base:
    input:
       expand("results/reference/{genome}_REP{REP}.fa", genome=config["genome"], allow_missing=True),
       expand("results/reference/{genome}_REP{REP}_snps.fa", genome=config["genome"], allow_missing=True)
    output:
       expand("results/reads/N{N}_R{R}_AF{AF}_NR{NR}_REP{REP}_base_R{strand}.fastq", strand=["1", "2"], allow_missing=True)
    log:
       "results/logs/iss_base_N{N}_R{R}_AF{AF}_NR{NR}_REP{REP}.log"
    benchmark:
       "results/benchmarks/iss_base_N{N}_R{R}_AF{AF}_NR{NR}_REP{REP}.benchmark.txt"
    params:
       N = "{N}",
       R = "{R}",
       AF = "{AF}",
       NR = "{NR}",
       REP = "{REP}"
    singularity: 
       "docker://hadrieng/insilicoseq:1.5.3"
    threads: 8
    resources:
        mem_mb=32000
    shell:
       "iss generate --genomes {input} --model hiseq --n_reads {params.NR} --cpus {threads} "
       "--o results/reads/N{params.N}_R{params.R}_AF{params.AF}_NR{params.NR}_REP{params.REP}_base ; "
       "rm results/reads/N{params.N}_R{params.R}_AF{params.AF}_NR{params.NR}_REP{params.REP}_base_abundance.txt"
