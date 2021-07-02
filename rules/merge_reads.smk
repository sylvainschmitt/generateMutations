N=config["n_mut"]
R=config["R"]
AF=config["AF"]
NR=config["n_reads"]
REP=config["REP"]

rule merge_reads:
    input:
        expand("results/reads/{type}_N{N}_R{R}_AF{AF}_NR{NR}_REP{REP}_R{strand}.fastq", 
                type=["unmutated", "mutatedtmp"], strand=["1","2"], allow_missing=True)
    output:
        expand("results/reads/N{N}_R{R}_AF{AF}_NR{NR}_REP{REP}_mutated_R{strand}.fastq",
                strand=["1","2"], allow_missing=True)
    log:
        "results/logs/merge_reads_N{N}_R{R}_AF{AF}_NR{NR}_REP{REP}.log"
    benchmark:
        "results/benchmarks/merge_reads_N{N}_R{R}_AF{AF}_NR{NR}_REP{REP}.benchmark.txt"
    shell:
        "cat {input[0]} {input[2]} > {output[0]} ; cat {input[1]} {input[3]} > {output[1]}"
