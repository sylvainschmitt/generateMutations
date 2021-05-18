N=config["n_mut"]
R=config["R"]
AF=config["AF"]
NR=config["n_reads"]

rule merge_reads:
    input:
        expand("results/reads_N{N}_R{R}_AF{AF}_NR{NR}/{type}_R{strand}.fastq", 
                type=["base", "mutated"], strand=["1","2"], allow_missing=True)
    output:
        expand("results/reads_N{N}_R{R}_AF{AF}_NR{NR}/mixed_R{strand}.fastq",
                strand=["1","2"], allow_missing=True)
    log:
        "results/logs/merge_reads_N{N}_R{R}_AF{AF}_NR{NR}.log"
    benchmark:
        "results/benchmarks/merge_reads_N{N}_R{R}_AF{AF}_NR{NR}.benchmark.txt"
    shell:
        "cat {input[0]}.tmp {input[2]}.tmp > {output[0]} ; cat {input[1]}.tmp {input[3]}.tmp > {output[1]}"
