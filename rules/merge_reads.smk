N=config["n_mut"]
R=config["R"]
AF=config["AF"]
NR=config["n_reads"]

rule merge_reads:
    input:
        expand("results/reads_N{N}_R{R}_AF{AF}_NR{NR}/{type}_R{strand}.fastq", 
                type=["base", "mutated"], strand=["1","2"], allow_missing=True)
    output:
        expand("results/reads_N{N}_R{R}_AF{AF}_NR{NR}/N{N}_R{R}_AF{AF}_NR{NR}_R{strand}.fastq",
                strand=["1","2"], allow_missing=True)
    log:
        "results/logs/merge_reads_N{N}_R{R}_AF{AF}_NR{NR}.log"
    benchmark:
        "results/benchmarks/merge_reads_N{N}_R{R}_AF{AF}_NR{NR}.benchmark.txt"
    shell:
        "cat {input[0]} {input[2]} > {output[0]} ; cat {input[1]} {input[3]} > {output[1]}"
